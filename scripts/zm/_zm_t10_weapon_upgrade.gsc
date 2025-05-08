#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_t10_hud;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_t10_weapon_upgrade.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "menu", "T10WeaponUpgrade_Main" );
#precache( "triggerstring", "T10_AMMO_CRATE", "250" );
#precache( "triggerstring", "T10_AMMO_CRATE", "1000" );
#precache( "triggerstring", "T10_AMMO_CRATE", "2500" );
#precache( "triggerstring", "T10_AMMO_CRATE", "5000" );
#precache( "triggerstring", "T10_AMMO_CRATE", "10000" );
#precache( "triggerstring", "T10_AMMO_CRATE_INVALID" );
#precache( "triggerstring", "T10_PACK_A_PUNCH", "1", "5000" );
#precache( "triggerstring", "T10_PACK_A_PUNCH", "2", "15000" );
#precache( "triggerstring", "T10_PACK_A_PUNCH", "3", "30000" );
#precache( "triggerstring", "T10_PACK_A_PUNCH_MAX_LEVEL" );
#precache( "triggerstring", "T10_PACK_A_PUNCH_IN_USE" );
#precache( "triggerstring", "T10_WEAPON_UPGRADE" );

#using_animtree( "generic" );

#namespace zm_t10_weapon_upgrade;

REGISTER_SYSTEM_EX( "zm_t10_weapon_upgrade", &__init__, &__main__, undefined )

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T10 WEAPON UPGRADES
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function __init__()
{
	// Clientfields
	clientfield::register( "clientuimodel", T10_PACK_A_PUNCH_TIER_CF_NAME, VERSION_SHIP, 2, "int" );
	clientfield::register( "scriptmover", T10_PACK_A_PUNCH_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int" );
	clientfield::register( "clientuimodel", T10_WEAPON_UPGRADE_AAT_SUPPORTED_CF_NAME, VERSION_SHIP, 1, "int" );
	clientfield::register( "clientuimodel", T10_WEAPON_UPGRADE_TIER_CF_NAME, VERSION_SHIP, 3, "int" );
	clientfield::register( "scriptmover", T10_WEAPON_UPGRADE_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int" );

	// Callbacks
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	callback::on_laststand( &on_player_laststand );
	zm::register_actor_damage_callback( &weapon_tier_damage_callback );
}

function __main__()
{
	// Init unitriggers
	level.t10_weapon_upgrade_machines = struct::get_array( "zm_t10_weapon_upgrade_machine", "targetname" );
	array::thread_all( level.t10_weapon_upgrade_machines, &weapon_upgrade_spawn_init, &weapon_upgrade_update_prompt, &weapon_upgrade_trigger_think );

	level.t10_pack_a_punch_machines = struct::get_array( "zm_t10_pack_a_punch_machine", "targetname" );
	array::thread_all( level.t10_pack_a_punch_machines, &pack_a_punch_spawn_init, &pack_a_punch_update_prompt, &pack_a_punch_trigger_think );

	level.t10_ammo_crates = struct::get_array( "zm_t10_ammo_crate", "targetname" );
	array::thread_all( level.t10_ammo_crates, &ammo_crate_spawn_init, &ammo_crate_update_prompt, &ammo_crate_trigger_think );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CALLBACKS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function on_player_connect()
{
	// Handles opening the weapon upgrade menu
	self thread weapon_upgrade_menu_handler();

	// Set the clientfields for the weapon tiers
	self thread set_player_weapon_clientfields();

	// Keep weapon tiers up-to-date
	self thread player_weapon_tiers_monitor();

	// Fix for incorrectly clearing weapon tiers
	self thread set_player_was_in_laststand();
}

function on_player_spawned()
{
	// Clear all weapon upgrades
	self clear_all_weapon_tiers();
}

function on_player_laststand()
{
	// Handles closing the weapon upgrade menu when downed
	self weapon_upgrade_close_menu();
}

function weapon_tier_damage_callback( inflictor, attacker, damage, flags, means_of_death, weapon, point, dir, hit_loc, offset_time, bone_index, surface_type )
{
	if( isdefined( self ) && IS_EQUAL( self.team, level.zombie_team ) && isdefined( attacker ) && isplayer( attacker ) )
	{
		wpn_multiplier = attacker get_damage_multiplier( weapon );
		pap_multiplier = attacker get_damage_multiplier( weapon, true );
		total_multiplier = wpn_multiplier + pap_multiplier + 1.0;
		new_damage = int( damage * total_multiplier );

		// Only do this for zombies, other ai types already have hitmarkers
		if( IS_EQUAL( self.archetype, "zombie" ) && IS_TRUE( T10_USE_HIT_MARKERS ) && damagefeedback::doDamageFeedback( weapon, inflictor, new_damage, means_of_death ) )
		{
			death = ( self.health - new_damage ) <= 0;
			attacker show_hit_marker( death );
		}

		// The damage went too high
		if( new_damage < damage )
		{
			new_damage = damage;
		}

		return new_damage;
	}

	return -1;
}

function show_hit_marker( death )
{
	if( isdefined( self ) && isdefined( self.hud_damagefeedback ) )
	{
		material = (death ? "damage_feedback_glow_orange" : "damage_feedback");
		self.hud_damagefeedback SetShader( material, 24, 48 );
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback FadeOverTime( 1 );
		self.hud_damagefeedback.alpha = 0;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WEAPON UPGRADE MACHINE
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function weapon_upgrade_spawn_init( update_prompt_func, trigger_think_func )
{
	// Decides if the close sound should play
	DEFAULT( self.playing_sound, false );

	// Spawn the model
	self.spawned_model = util::spawn_model( T10_WEAPON_UPGRADE_MODEL_OFF, self.origin, self.angles );
	self.spawned_model useanimtree( #animtree );

	// Spawn the unitrigger at the correct height
	self.origin += ( 0, 0, 56 );
	self.script_unitrigger_type = "unitrigger_box_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = true;
	self.prompt_and_visibility_func = update_prompt_func;
	zm_unitrigger::register_static_unitrigger( self, trigger_think_func );

	// Turn on the machine
	level thread weapon_upgrade_wait_for_power( self );
}

function weapon_upgrade_update_prompt( player )
{
	current_weapon = player getcurrentweapon();

	if( IS_DRINKING( player.is_drinking ) || zm_utility::is_hero_weapon( current_weapon ) )
	{
		self sethintstring( "" );
		return false;
	}

	if( !level flag::get( "power_on" ) )
	{
		self sethintstring( &"ZOMBIE_NEED_POWER" );
		return false;
	}

	self sethintstring( &"T10_WEAPON_UPGRADE" );
	return true;
}

function weapon_upgrade_trigger_think()
{
	self endon( "kill_trigger" );
	
	while( true )
	{
		self waittill( "trigger", player );
		player weapon_upgrade_open_menu();
	}
}

function weapon_upgrade_wait_for_power( stub )
{
	level endon( "end_game" );

	// Turn on the machine
	level flag::wait_till( "power_on" );
	stub.spawned_model setmodel( T10_WEAPON_UPGRADE_MODEL_ON );
	stub.spawned_model clientfield::set( T10_WEAPON_UPGRADE_IDLE_FX_CF_NAME, 1 );
	stub.spawned_model thread animation::play( T10_WEAPON_UPGRADE_ANIM_IDLE );
	stub.spawned_model playloopsound( T10_WEAPON_UPGRADE_IDLE_SOUND );

	// Setup the jingle
	stub.spawned_model.script_sound = T10_WEAPON_UPGRADE_JINGLE_SOUND;
	stub.spawned_model.sndJingleCooldown = false;
	stub.spawned_model thread zm_audio::sndPerksJingles_Timer();

	// Play credits
	level thread weapon_upgrade_play_credits( stub );
}

function weapon_upgrade_set_playing_sound( stub )
{
	level endon( "end_game" );
	stub notify( "weapon_upgrade_set_playing_sound" );
	stub endon( "weapon_upgrade_set_playing_sound" );

	stub.playing_sound = true;
	wait( 5 );
	stub.playing_sound = false;
}

function weapon_upgrade_play_credits( stub )
{
	level endon( "end_game" );
	stub notify( "weapon_upgrade_play_credits" );
	stub endon( "weapon_upgrade_play_credits" );

	while( true )
	{
		time = randomintrange( 60, 120 );
		wait( time );

		if( isdefined( stub.playing_sound ) && !stub.playing_sound )
		{
			level thread weapon_upgrade_set_playing_sound( stub );
			stub.spawned_model playsound( "t10_vox_arsenal_machine_credits" );
		}
	}
}

function weapon_upgrade_close_menu( stub = undefined )
{
	if( isdefined( stub ) )
	{
		if( isdefined( stub.playing_sound ) && !stub.playing_sound )
		{
			level thread weapon_upgrade_set_playing_sound( stub );
			stub.spawned_model playsound( T10_WEAPON_UPGRADE_CLOSE_SOUND );
		}
	}

	// Close the menu
	self closeingamemenu();
	self closemenu( "T10WeaponUpgrade_Main" );
}

function weapon_upgrade_open_menu()
{
	// Open the menu
	self weapon_upgrade_close_menu();
    self openmenu( "T10WeaponUpgrade_Main" );
}

function weapon_upgrade_menu_handler()
{
	self endon( "disconnect" );
	self notify( "weapon_upgrade_menu_handler" );
	self endon( "weapon_upgrade_menu_handler" );

	while( true )
	{
		// Wait for the menu response
		self waittill( "menuresponse", menu, response );

		// Get the machine stub
		machine_stub = arraygetclosest( self.origin, level.t10_weapon_upgrade_machines );

		// Make sure the model exists
		if( !isdefined( machine_stub ) || !isdefined( machine_stub.spawned_model ) )
		{
			continue;
		}

		// Make sure it's the correct menu
		if( !IS_EQUAL( menu, "T10WeaponUpgrade_Main" ) )
		{
			continue;
		}

		// Close the menu if we send the close string
		if( IS_EQUAL( response, "close" ) )
		{
			self weapon_upgrade_close_menu( machine_stub );
			continue;
		}

		// Sort the response string
		split_string = strtok( response, "|" );
		tab_name = STR( split_string[0] );
		tab_data = STR( split_string[1] );
		current_weapon = self getcurrentweapon();

		// Check if the weapon is valid
		if( !is_valid_weapon( current_weapon ) || zm_weapons::is_wonder_weapon( current_weapon ) )
		{
			self playsound( "zmb_no_cha_ching" );
			self zm_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		if( IS_EQUAL( tab_name, "aat" ) )
		{
			// Make sure aat is allowed on this weapon
			if( !is_aat_supported( current_weapon ) )
			{
				self playsound( "zmb_no_cha_ching" );
				self zm_audio::create_and_play_dialog( "general", "sigh" );
				continue;
			}

			// Get data
			data = strtok( tab_data, "," );
			cost = int( data[0] );
			aat = STR( data[1] );

			// Get current aat
			current_aat = self aat::getaatonweapon( current_weapon );

			// If the player has an aat, don't let them buy the same one again
			if( isdefined( current_aat ) && IS_EQUAL( current_aat.name, aat ) )
			{
				self playsound( "zmb_no_cha_ching" );
				self zm_audio::create_and_play_dialog( "general", "sigh" );
				continue;
			}

			// Check player has enough junk
			if( !self zm_t10_hud::can_player_purchase_junk( cost ) )
			{
				self playsound( "zmb_no_cha_ching" );
				self zm_audio::create_and_play_dialog( "general", "outofmoney" );
				continue;
			}

			// Buy it
			self playsound( "zmb_cha_ching" );
			self zm_t10_hud::minus_to_player_junk( cost );
			self thread aat::acquire( current_weapon, aat );

			// Only play a vox if one isn't already playing
			if( isdefined( machine_stub.playing_sound ) && !machine_stub.playing_sound )
			{
				level thread weapon_upgrade_set_playing_sound( machine_stub );
				machine_stub.spawned_model playsound( "t10_vox_arsenal_machine_" + getsubstr( aat, 7 ) );
			}

			// Play equip & stinger sounds
			machine_stub.spawned_model playsound( T10_WEAPON_UPGRADE_AMMO_MOD_EQUIP_SOUND );
			machine_stub.spawned_model playsound( T10_WEAPON_UPGRADE_STINGER_SOUND );
		}
		else if( IS_EQUAL( tab_name, "tier" ) )
		{
			// Get data
			data = strtok( tab_data, "," );
			cost = int( data[0] );
			tier = int( data[1] );

			current_tier = self get_weapon_tier( current_weapon );

			// Don't let the player buy an upgrade that they already own
			if( current_tier >= tier )
			{
				self playsound( "zmb_no_cha_ching" );
				self zm_audio::create_and_play_dialog( "general", "sigh" );
				continue;
			}

			// Check player has enough junk
			if( !self zm_t10_hud::can_player_purchase_junk( cost ) )
			{
				self playsound( "zmb_no_cha_ching" );
				self zm_audio::create_and_play_dialog( "general", "outofmoney" );
				continue;
			}

			// Buy it
			self playsound( "zmb_cha_ching" );
			self zm_t10_hud::minus_to_player_junk( cost );
			self set_weapon_tier( current_weapon, tier );

			// Only play a vox if one isn't already playing
			if( isdefined( machine_stub.playing_sound ) && !machine_stub.playing_sound )
			{
				level thread weapon_upgrade_set_playing_sound( machine_stub );
				machine_stub.spawned_model playsound( T10_WEAPON_UPGRADE_TIER_EQUIP_VOXES[tier - 1] );
			}
			
			// Play equip & stinger sounds
			machine_stub.spawned_model playsound( T10_WEAPON_UPGRADE_TIER_EQUIP_SOUNDS[tier - 1] );
			machine_stub.spawned_model playsound( T10_WEAPON_UPGRADE_STINGER_SOUND );
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PACK-A-PUNCH MACHINE
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function pack_a_punch_spawn_init( update_prompt_func, trigger_think_func )
{
	// Track usage
	DEFAULT( self.in_use, false );

	// Spawn the model
	self.spawned_model = util::spawn_model( T10_PACK_A_PUNCH_MODEL_OFF, self.origin, self.angles );
	self.spawned_model useanimtree( #animtree );

	// Spawn the unitrigger at the correct height
	self.origin += ( 0, 0, 56 );
	self.script_unitrigger_type = "unitrigger_box_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = true;
	self.prompt_and_visibility_func = update_prompt_func;
	zm_unitrigger::register_static_unitrigger( self, trigger_think_func );

	// Turn on the machine
	level thread pack_a_punch_wait_for_power( self );
}

function pack_a_punch_update_prompt( player )
{
	current_weapon = player getcurrentweapon();

	if( IS_DRINKING( player.is_drinking ) || zm_utility::is_hero_weapon( current_weapon ) )
	{
		self sethintstring( "" );
		return false;
	}

	current_tier = player get_weapon_tier( current_weapon, true );
	cost = pack_a_punch_get_cost( current_tier );

	if( !level flag::get( "power_on" ) )
	{
		self sethintstring( &"ZOMBIE_NEED_POWER" );
		return false;
	}

	if( IS_TRUE( self.stub.in_use ) )
	{
		self sethintstring( &"T10_PACK_A_PUNCH_IN_USE" );
		return true;
	}

	if( current_tier >= 3 )
	{
		self sethintstring( &"T10_PACK_A_PUNCH_MAX_LEVEL" );
		return true;
	}

	self sethintstring( &"T10_PACK_A_PUNCH", STR( ( current_tier + 1 ) ), STR( cost ) );
	return true;
}

function pack_a_punch_trigger_think()
{
	self endon( "kill_trigger" );
	
	while( true )
	{
		self waittill( "trigger", player );
		self.stub thread pack_a_punch_use( player );
	}
}

function pack_a_punch_wait_for_power( stub )
{
	level endon( "end_game" );

	// Turn on the machine
	level flag::wait_till( "power_on" );
	stub.spawned_model setmodel( T10_PACK_A_PUNCH_MODEL_ON );
	stub.spawned_model clientfield::set( T10_PACK_A_PUNCH_IDLE_FX_CF_NAME, 1 );
	stub.spawned_model thread animation::play( T10_PACK_A_PUNCH_ANIM_IDLE );
	stub.spawned_model playloopsound( T10_PACK_A_PUNCH_IDLE_SOUND );
	stub.spawned_model pack_a_punch_show_screen_tier( 1 );
}

function pack_a_punch_get_cost( tier )
{
	return T10_PACK_A_PUNCH_COSTS[tier];
}

function pack_a_punch_show_screen_tier( tier )
{
	// Hide parts
	for( i = 1; i < 4; i++ )
	{
		self hidepart( "screen_" + i + "_jnt" );
	}

	// Show part
	self showpart( "screen_" + tier + "_jnt" );
}

function pack_a_punch_use( player )
{
	// Check isn't already in use
	if( IS_TRUE( self.in_use ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	current_weapon = player getcurrentweapon();

	// Check if the weapon is valid
	if( !is_valid_weapon( current_weapon ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	current_tier = player get_weapon_tier( current_weapon, true );

	// Weapon is already maxed
	if( current_tier >= 3 )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	// Get cost
	cost = pack_a_punch_get_cost( current_tier );

	// Check player has enough points
	if( !player zm_score::can_player_purchase( cost ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		return;
	}

	// Set in use
	self.in_use = true;

	// Buy it
	player playsound( "zmb_cha_ching" );
	player zm_score::minus_to_player_score( cost );
	player thread pack_a_punch_give( current_weapon, current_tier );

	// Play upgrade sound, show tier screen, and trigger upgrade fx/animations
	self.spawned_model clientfield::set( T10_PACK_A_PUNCH_IDLE_FX_CF_NAME, 0 );
	self.spawned_model playsound( "t10_evt_zm_core_pap_fxanim_upgrade_tier_" + (current_tier + 1) );
	self.spawned_model pack_a_punch_show_screen_tier( current_tier + 1 );
	self.spawned_model animation::play( "t10_zm_pap_fxanim_activate_" + (current_tier + 1) );
	self.spawned_model clientfield::set( T10_PACK_A_PUNCH_IDLE_FX_CF_NAME, 1 );
	self.spawned_model thread animation::play( T10_PACK_A_PUNCH_ANIM_IDLE );

	// Set not in use
	self.in_use = false;
}

function pack_a_punch_give( weapon, tier )
{
	self endon( "disconnect" );

	// Using pap
	self.using_pap = true;

	// Current weapon
	weapon = self zm_weapons::switch_from_alt_weapon( weapon );

	// Get pap variant
	upgrade_weapon = zm_weapons::get_upgrade_weapon( weapon, true );
	upgrade_weapon = self getbuildkitweapon( upgrade_weapon, true );
	upgrade_weapon.pap_camo_to_use = T10_PACK_A_PUNCH_CAMOS[tier];

	// Current aat
	current_aat = self aat::getaatonweapon( weapon );

	// Take old weapon
	self zm_weapons::weapon_take( weapon );

	// Can't take and give on the same frame
	util::wait_network_frame();

	// Give new weapon
	upgrade_weapon = self zm_weapons::give_build_kit_weapon( upgrade_weapon );
	self givestartammo( upgrade_weapon );
	self notify( "weapon_give", upgrade_weapon );
	self switchtoweapon( upgrade_weapon );

	// Give the aat back if there was one
	if( isdefined( current_aat ) )
	{
		self thread aat::acquire( upgrade_weapon, current_aat.name );
	}

	// Set new weapon tier
	weapon = zm_weapons::get_base_weapon( upgrade_weapon );
	self set_weapon_tier( weapon, tier + 1, true );

	// Not using pap
	self.using_pap = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// AMMO CRATE
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function ammo_crate_spawn_init( update_prompt_func, trigger_think_func )
{
	if( !isdefined( self.model ) )
	{
		return;
	}

	// Spawn the model
	self.spawned_model = util::spawn_model( self.model, self.origin, self.angles );
	self.spawned_model useanimtree( #animtree );
	// Spawn the unitrigger at the correct height
	self.origin += ( 0, 0, 24 );
	self.script_unitrigger_type = "unitrigger_box_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = true;
	self.prompt_and_visibility_func = update_prompt_func;
	zm_unitrigger::register_static_unitrigger( self, trigger_think_func );
}

function ammo_crate_update_prompt( player )
{
	current_weapon = player getcurrentweapon();

	if( IS_DRINKING( player.is_drinking ) || zm_utility::is_hero_weapon( current_weapon ) )
	{
		self sethintstring( "" );
		return false;
	}

	if( !is_valid_weapon( current_weapon ) )
	{
		self sethintstring( &"T10_AMMO_CRATE_INVALID" );
		return false;
	}

	cost = player ammo_crate_get_cost( current_weapon );
	
	self sethintstring( &"T10_AMMO_CRATE", STR( cost ) );
	return true;
}

function ammo_crate_trigger_think()
{
	self endon( "kill_trigger" );
	
	while( true )
	{
		self waittill( "trigger", player );
		self.stub ammo_crate_use( player );
	}
}

function ammo_crate_get_cost( weapon )
{
	if( zm_weapons::is_wonder_weapon( weapon ) )
	{
		return 10000;
	}
	
	pap_tier = self get_weapon_tier( weapon, true );
	return T10_AMMO_CRATE_COSTS[pap_tier];
}

function ammo_crate_use( player )
{
	current_weapon = player getcurrentweapon();

	// Check if the weapon is valid
	if( !is_valid_weapon( current_weapon ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	// Check if the ammo is already full
	if( player is_full_ammo( current_weapon ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "sigh" );
		return;
	}

	cost = player ammo_crate_get_cost( current_weapon );

	// Check player has enough points
	if( !player zm_score::can_player_purchase( cost ) )
	{
		player playsound( "zmb_no_cha_ching" );
		player zm_audio::create_and_play_dialog( "general", "outofmoney" );
		return;
	}

	// Buy it
	player playsound( "zmb_cha_ching" );
	player zm_score::minus_to_player_score( cost );
	player give_full_ammo( current_weapon );
	self.spawned_model animation::play( T10_AMMO_CRATE_ANIM_ACTIVATE );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// UTILITY FUNCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function is_valid_weapon( weapon )
{
	if( IS_EQUAL( weapon, level.weaponnone ) || IS_EQUAL( weapon, level.weaponzmfists ) )
	{
		return false;
	}

	if( zm_utility::is_offhand_weapon( weapon ) )
	{
		return false;
	}

	if( IS_TRUE( weapon.isriotshield ) )
	{
		return false;
	}

	if( IS_EQUAL( weapon, level.zombie_powerup_weapon["minigun"] ) )
	{
		return false;
	}

	return true;
}

function is_aat_supported( weapon_to_check )
{
	foreach( weapon_upgraded in getarraykeys( level.aat_exemptions ) )
	{
		weapon = zm_weapons::get_base_weapon( weapon_upgraded );

		if( IS_EQUAL( weapon, weapon_to_check ) || IS_EQUAL( weapon_upgraded, weapon_to_check ) )
		{
			return false;
		}
	}

	return true;
}

function get_damage_multiplier( weapon, pap = false )
{
	weapon_tier = self get_weapon_tier( weapon, pap );

	// Don't multiply damage for WW's on normal tiers
	if( !pap && zm_weapons::is_wonder_weapon( weapon ) )
	{
		return 0;
	}

	max_tier = (!pap ? 4 : 3);
    return float( weapon_tier / max_tier );
}

function get_weapon_tier( weapon, pap = false )
{
	weapon = zm_weapons::get_base_weapon( weapon );

	if( !isdefined( weapon.name ) || !is_valid_weapon( weapon ) )
	{
		return 0;
	}

	DEFAULT( self.weapon_tiers, [] );
	DEFAULT( self.weapon_tiers[weapon.name], array( 0, 0 ) );

	// Set WW's to tier 5
	if( zm_weapons::is_wonder_weapon( weapon ) )
	{
		self.weapon_tiers[weapon.name][0] = 5;
	}

	wpn_tier = self.weapon_tiers[weapon.name][0];
	pap_tier = self.weapon_tiers[weapon.name][1];
	tier = (!pap ? wpn_tier : pap_tier);
	
	return tier;
}

function set_weapon_tier( weapon, tier, pap = false )
{
	weapon = zm_weapons::get_base_weapon( weapon );

	if( !isdefined( weapon.name ) || !is_valid_weapon( weapon ) )
	{
		return;
	}

	DEFAULT( self.weapon_tiers, [] );
	DEFAULT( self.weapon_tiers[weapon.name], array( 0, 0 ) );

	index = (!pap ? 0 : 1);
	clamp = (!pap ? 4 : 3);
	client_field_name = (!pap ? T10_WEAPON_UPGRADE_TIER_CF_NAME : T10_PACK_A_PUNCH_TIER_CF_NAME);

	self.weapon_tiers[weapon.name][index] = math::clamp( tier, 0, clamp );
	self clientfield::set_player_uimodel( client_field_name, self.weapon_tiers[weapon.name][index] );
}

function clear_weapon_tiers( weapon )
{
	weapon = zm_weapons::get_base_weapon( weapon );

	DEFAULT( self.weapon_tiers, [] );

	if( isdefined( weapon.name ) && isdefined( self.weapon_tiers[weapon.name] ) )
	{
		self.weapon_tiers[weapon.name] = undefined;
	}
}

function clear_all_weapon_tiers()
{
	self.weapon_tiers = [];
}

function update_weapon_tiers()
{
	// Make sure the player is not in laststand
	if( self laststand::player_is_in_laststand() )
	{
		return;
	}

	// Fix for incorrectly clearing weapon tiers
	if( IS_TRUE( self.i_was_in_last_stand ) )
	{
		return;
	}

	// Make sure we're not using pap
	if( IS_TRUE( self.using_pap ) )
	{
		return;
	}

	DEFAULT( self.weapon_tiers, [] );

	foreach( weapon_name in getarraykeys( self.weapon_tiers ) )
	{
		weapon = zm_weapons::get_base_weapon( getweapon( weapon_name ) );

		if( isdefined( self.weapon_tiers[weapon_name] ) && !self zm_weapons::has_weapon_or_upgrade( weapon ) )
		{
			self clear_weapon_tiers( weapon );
		}
	}
}

function set_player_weapon_clientfields()
{
    self endon( "disconnect" );
	self notify( "set_player_weapon_clientfields" );
	self endon( "set_player_weapon_clientfields" );

	while( true )
	{
		WAIT_SERVER_FRAME;

		// Current weapon
		current_weapon = self getcurrentweapon();

		// Set aat supported clientfield
		aat_supported = is_aat_supported( current_weapon );
		self zm_t10_hud::set_player_uimodel_clientfield( T10_WEAPON_UPGRADE_AAT_SUPPORTED_CF_NAME, aat_supported );

		// Set weapon tier clientfield
		weapon_tier = self get_weapon_tier( current_weapon );
		self zm_t10_hud::set_player_uimodel_clientfield( T10_WEAPON_UPGRADE_TIER_CF_NAME, weapon_tier );

		// Set pap tier clientfield
		pap_tier = self get_weapon_tier( current_weapon, true );
		self zm_t10_hud::set_player_uimodel_clientfield( T10_PACK_A_PUNCH_TIER_CF_NAME, pap_tier );
	}
}

function player_weapon_tiers_monitor()
{
    self endon( "disconnect" );
	self notify( "player_weapon_tiers_monitor" );
	self endon( "player_weapon_tiers_monitor" );

	while( true )
	{
		self waittill( "weapon_change", weapon );
		self update_weapon_tiers();
	}
}

function set_player_was_in_laststand()
{
	self endon( "disconnect" );
	self notify( "set_player_was_in_laststand" );
	self endon( "set_player_was_in_laststand" );

	// FIX: Weapon tiers being cleared when going down and being revived
	// In very specific scenarios (Electric Cherry & Self Medication)
	self.i_was_in_last_stand = false;

	while( true )
	{
		self waittill( "player_downed" );

		if( self laststand::player_is_in_laststand() )
		{
			while( self laststand::player_is_in_laststand() )
			{
				WAIT_SERVER_FRAME;
			}

			if( !zm_utility::is_player_valid( self ) )
			{
				continue;
			}

			self.i_was_in_last_stand = true;
			
			while( self isswitchingweapons() )
			{
				WAIT_SERVER_FRAME;
			}

			self.i_was_in_last_stand = false;
		}
	}
}

function is_full_ammo( weapon )
{
	if( !is_valid_weapon( weapon ) )
	{
		return false;
	}

	clip_max     = weapon.clipsize;
	stock_max    = weapon.maxammo;
	ammo_clip    = self getweaponammoclip( weapon );
	ammo_stock   = self getweaponammostock( weapon );

	is_clip_full  = IS_EQUAL( clip_max, ammo_clip );
	is_stock_full = IS_EQUAL( stock_max, ammo_stock );

	if( !is_clip_full || !is_stock_full )
	{
		return false;
	}

	if( weapon.isdualwield )
	{
		dw_weapon     = weapon.dualwieldweapon;
		dw_clip_max   = dw_weapon.clipsize;
		dw_ammo_clip  = self getweaponammoclip( dw_weapon );
		is_dw_full    = IS_EQUAL( dw_clip_max, dw_ammo_clip );

		if( !is_dw_full )
		{
			return false;
		}
	}

	return true;
}

function give_full_ammo( weapon )
{
	if( !is_valid_weapon( weapon ) )
	{
		return;
	}

	clip_max = weapon.clipsize;
	stock_max = weapon.maxammo;
	
	self setweaponammoclip( weapon, clip_max );
	self setweaponammostock( weapon, stock_max );

	if( weapon.isdualwield )
	{
		dw_weapon = weapon.dualwieldweapon;
		dw_clip_max = dw_weapon.clipsize;
		self setweaponammoclip( dw_weapon, dw_clip_max );
	}
}