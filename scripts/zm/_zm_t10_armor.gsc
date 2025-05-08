#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_t10_armor.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "triggerstring", "T10_ARMOR_CHALK_OWNED", "1", "4000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_OWNED", "2", "4000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_OWNED", "3", "4000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "1", "4000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "2", "6000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "2", "10000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "3", "4000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "3", "10000" );
#precache( "triggerstring", "T10_ARMOR_CHALK_BUY", "3", "14000" );

#namespace zm_t10_armor;

REGISTER_SYSTEM_EX( "zm_t10_armor", &__init__, &__main__, undefined )

function __init__()
{
	// Clientfields
	for( i = 0; i < getdvarint( "com_maxclients" ); i++ )
	{
		clientfield::register( "world", T10_ARMOR_VEST_TIER_CF_NAME + "_" + i, VERSION_SHIP, 2, "int" );
		clientfield::register( "world", T10_ARMOR_VEST_PLATE_CF_NAME + "_" + i, VERSION_SHIP, 2, "int" );
		clientfield::register( "world", T10_ARMOR_VEST_HEALTH_CF_NAME + "_" + i, VERSION_SHIP, 7, "float" );
	}

	clientfield::register( "clientuimodel", T10_ARMOR_PLATE_AMMO_CF_NAME, VERSION_SHIP, 2, "int" );

	// Callbacks
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	zm::register_player_damage_callback( &armor_vest_health_callback );
}

function __main__()
{
	// Register armor plate weapons as equipment
	zm_equipment::register_for_level( T10_ARMOR_WEAPON_NAME );
	zm_equipment::register_for_level( T10_ARMOR_WEAPON_FAST_NAME );
	
	// Init unitriggers
	level.t10_armor_chalks = struct::get_array( "zm_t10_armor", "targetname" );
	array::thread_all( level.t10_armor_chalks, &spawn_init, &armor_chalk_update_prompt, &armor_chalk_trigger_think );
}

function on_player_connect()
{
	// Handles armor plating
	self thread armor_vest_watch_ammo();
}

function on_player_spawned()
{
	// Set initial tier of armor when the player spawns
	self armor_vest_set_tier( 0 );
}

function spawn_init( update_prompt_func, trigger_think_func )
{
	// Set the tier of this armor vest
	self.tier = armor_chalk_get_tier();

	if( !isdefined( self.model ) || !isdefined( self.tier ) )
	{
		return;
	}

	// Spawn the model
	self.spawned_model = util::spawn_model( self.model, self.origin, self.angles );
	self.script_unitrigger_type = "unitrigger_box_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = true;
	self.prompt_and_visibility_func = update_prompt_func;
	zm_unitrigger::register_static_unitrigger( self, trigger_think_func );
}

function armor_chalk_update_prompt( player )
{
	current_weapon = player getcurrentweapon();

	if( IS_DRINKING( player.is_drinking ) || zm_utility::is_hero_weapon( current_weapon ) )
	{
		self sethintstring( "" );
		return false;
	}
	
	player_tier = player armor_vest_get_tier();
	chalk_tier = self.stub.tier;
	cost = self armor_chalk_get_cost( chalk_tier, player_tier );

	// If the player already owns this tier of armor
	if( player_tier >= chalk_tier )
	{
		self sethintstring( &"T10_ARMOR_CHALK_OWNED", STR( player_tier ), STR( cost ) );
		return true;
	}

	self sethintstring( &"T10_ARMOR_CHALK_BUY", STR( chalk_tier ), STR( cost ) );
	return true;
}

function armor_chalk_trigger_think()
{
	self endon( "kill_trigger" );
	
	while( true )
	{
		self waittill( "trigger", player );
		self.stub armor_chalk_buy( player );
	}
}

function armor_chalk_buy( player )
{
	player_tier = player armor_vest_get_tier();
	chalk_tier = self.tier;
	armor_health = player armor_vest_get_health();
	armor_ammo = player armor_vest_get_ammo();
	cost = self armor_chalk_get_cost( chalk_tier, player_tier );

	// This condition checks if the player should be able to buy armor
	// Example: You have a tier 1 vest and try to buy a tier 1 vest when you have full armor health
	if( player_tier >= chalk_tier && IS_EQUAL( armor_health, float( player_tier ) ) && IS_EQUAL( armor_ammo, 3 ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	if( !player zm_score::can_player_purchase( cost ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		return;
	}

	// Buy it
	player playsound( "zmb_cha_ching" );
	player zm_score::minus_to_player_score( cost );
	self armor_chalk_spawn_vest_model( chalk_tier, player );
	player armor_vest_set_tier( chalk_tier, player_tier );
}

function armor_chalk_get_tier()
{
	foreach( index, model in T10_ARMOR_CHALKS )
	{
		if( isdefined( self ) && IS_EQUAL( self.model, model ) )
		{
			return index + 1;
		}
	}

	return undefined;
}

function armor_chalk_get_cost( chalk_tier, player_tier )
{
	// If we're only buying a repair
	if( player_tier >= chalk_tier )
	{
		return T10_ARMOR_CHALKS_COSTS[0];
	}

	cost = 0;
	cost += T10_ARMOR_CHALKS_COSTS[chalk_tier - 1];

	// Subtract the cost of the previous vest, based on the player's tier
	if( player_tier > 0 )
	{
		cost -= T10_ARMOR_CHALKS_COSTS[player_tier - 1];
	}

	return cost;
}

function armor_chalk_get_model( tier )
{
	return T10_ARMOR_MODELS[tier - 1];
}

function armor_chalk_spawn_vest_model( tier, player )
{
	if( isdefined( self.spawned_vest_model ) )
	{
		return;
	}

	model = armor_chalk_get_model( tier );
	self.spawned_vest_model = util::spawn_model( model, self.origin, self.angles + ( 0, 0, 90 ) );
	self.spawned_vest_model zm_weapons::weapon_show( player );
}

function armor_vest_get_tier()
{
	DEFAULT( self.t10_armor_vest_tier, 0 );
	return self.t10_armor_vest_tier;
}

function armor_vest_set_tier( chalk_tier, player_tier = undefined )
{
	// If we're only buying a repair
	if( isdefined( player_tier ) && player_tier >= chalk_tier )
	{
		self armor_vest_set_health( float( player_tier ) );
		self armor_vest_set_ammo( 3 );
		return;
	}

	// Set the armor vest tier
	self.t10_armor_vest_tier = chalk_tier;
	level clientfield::set( T10_ARMOR_VEST_TIER_CF_NAME + "_" + self getentitynumber(), chalk_tier );
	self armor_vest_set_health( float( chalk_tier ) );

	// Only give plates if we have a valid tier of armor
	if( chalk_tier > 0 )
	{
		self armor_vest_set_ammo( 3 );
	}
}

function armor_vest_get_health()
{
	DEFAULT( self.t10_armor_vest_plates, 0.0 );
	return self.t10_armor_vest_plates;
}

function armor_vest_set_health( health )
{
	// Handles setting the health of the armor plates
	old_plate = self armor_vest_get_current_plate();
	player_tier = self armor_vest_get_tier();
	health_limit = float( self armor_vest_get_tier() );
    self.t10_armor_vest_plates = math::clamp( health, 0.0, health_limit );
    new_plate = self armor_vest_get_current_plate();
    new_health = math::clamp( self.t10_armor_vest_plates - ( new_plate * 1.0 ), 0.0, 1.0 );
	level clientfield::set( T10_ARMOR_VEST_PLATE_CF_NAME + "_" + self getentitynumber(), new_plate );
	level clientfield::set( T10_ARMOR_VEST_HEALTH_CF_NAME + "_" + self getentitynumber(), new_health );

	// Play the break sound if the plate has been broken,
	// Don't play the sound if we were at full armor and it's the first hit
	if( new_plate < old_plate && old_plate < player_tier )
	{
		self playsound( T10_ARMOR_BREAK_SOUND );
	}
}

function armor_vest_get_current_plate()
{
	plate = 0;

	if( isdefined( self.t10_armor_vest_plates ) )
	{
		plate = int( floor( self.t10_armor_vest_plates ) );
	}

	return plate;
}

function armor_vest_get_plate_for_repair( tier )
{
	if( isdefined( self.t10_armor_vest_plates ) )
	{
		if( self.t10_armor_vest_plates < float( tier ) )
		{
			return int( floor( self.t10_armor_vest_plates ) ) - 1;
		}
	}

	return undefined;
}

function armor_vest_get_ammo()
{
	DEFAULT( self.t10_armor_weapon_ammo, 0 );
	return self.t10_armor_weapon_ammo;
}

function armor_vest_set_ammo( ammo )
{
	// Set the amount of armor plates the player has
	self.t10_armor_weapon_ammo = ammo;
	self clientfield::set_player_uimodel( T10_ARMOR_PLATE_AMMO_CF_NAME, ammo );
}

function armor_vest_watch_ammo()
{
	self endon( "disconnect" );
	self notify( "armor_vest_watch_ammo" );
	self endon( "armor_vest_watch_ammo" );

	while( true )
	{
		WAIT_SERVER_FRAME;

		if( self actionslottwobuttonpressed() )
		{
			if( !zm_utility::is_player_valid( self ) )
			{
				continue;
			}

			if( IS_DRINKING( self.is_drinking ) )
			{
				continue;
			}

			if( self isswitchingweapons() )
			{
				while( self isswitchingweapons() )
				{
					WAIT_SERVER_FRAME;
				}
				
				continue;
			}

			plate_ammo = self armor_vest_get_ammo();
			tier = self armor_vest_get_tier();
			plate = self armor_vest_get_plate_for_repair( tier );

			// Make sure we should be able to apply plates
			if( plate_ammo < 1 || tier < 1 || !isdefined( plate ) )
			{
				continue;
			}

			original_weapon = self getcurrentweapon();
			armor_weapon = (self hasperk( PERK_SLEIGHT_OF_HAND ) ? T10_ARMOR_WEAPON_FAST : T10_ARMOR_WEAPON); // Gives the faster version if we have speed-cola
			self giveweapon( armor_weapon );
			self switchtoweapon( armor_weapon );
			self zm_utility::increment_is_drinking(); // Prevents picking up the death machine and other invalid actions whilst plating

			evt = self util::waittill_any_return( "fake_death", "death", "player_downed", "weapon_change_complete" );

			self takeweapon( armor_weapon );
			self zm_utility::decrement_is_drinking();

			// Player is done with armor plate animation, give the armor
			if( IS_EQUAL( evt, "weapon_change_complete" ) )
			{
				self zm_weapons::switch_back_primary_weapon( original_weapon );
				self armor_vest_set_ammo( plate_ammo - 1 );
				health = self armor_vest_get_health();
				self armor_vest_set_health( health + 1.0 );
				self waittill( "weapon_change_complete" );
			}
		}
	}
}

function armor_vest_health_callback( inflictor, attacker, damage, id_flags, means_of_death, weapon, point, dir, hit_loc, offset_time, bone_index )
{
	// Let's make sure it's a zombie that's dealing damage
	if( isdefined( attacker ) && IS_EQUAL( attacker.team, level.zombie_team ) )
	{
		// Current armor vest health
		health = self armor_vest_get_health();

		if( health > 0 )
		{
			// Half of the damage taken
			half_damage = int( damage / 2 );
			damage_to_apply = half_damage / 100;

			// Subtract this from our armor vest health
			health -= damage_to_apply;
			self armor_vest_set_health( health );
			
			// Give the other half of the damage to the player's health
			return half_damage;
		}
	}

	return -1;
}
