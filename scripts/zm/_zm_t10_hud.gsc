#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_t10_armor;
#using scripts\zm\_zm_t10_buyable_perk;
#using scripts\zm\_zm_t10_item_drops;
#using scripts\zm\_zm_t10_wand_aether_shroud;
#using scripts\zm\_zm_t10_weapon_upgrade;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_utility.gsh;

#precache( "menu", "StartMenu_Main" );
#precache( "string", "T10_UI_SCORE_EVENT_ELIMINATION" );
#precache( "string", "T10_UI_SCORE_EVENT_CRITICAL_KILL" );
#precache( "string", "T10_UI_SCORE_EVENT_MELEE_KILL" );
#precache( "string", "T10_UI_SCORE_EVENT_BURNED_KILL" );
#precache( "string", "T10_UI_POWERUP_EVENT_CARPENTER" );
#precache( "string", "T10_UI_POWERUP_EVENT_FREE_PERK" );
#precache( "string", "T10_UI_POWERUP_EVENT_NUKE" );
#precache( "string", "T10_UI_POWERUP_EVENT_BONUS_POINTS" );

#namespace zm_t10_hud;

REGISTER_SYSTEM_EX( "zm_t10_hud", &__init__, &__main__, undefined )

function __init__()
{
	// Clientfields
	for( i = 0; i < getdvarint( "com_maxclients" ); i++ )
	{
		clientfield::register( "world", "t10_health_" + i, VERSION_SHIP, 7, "float" );
	}

	clientfield::register( "clientuimodel", "powerup_instant_kill.time", VERSION_SHIP, 8, "int" );
	clientfield::register( "clientuimodel", "powerup_double_points.time", VERSION_SHIP, 8, "int" );
	clientfield::register( "clientuimodel", "powerup_fire_sale.time", VERSION_SHIP, 8, "int" );
	clientfield::register( "clientuimodel", "powerup_mini_gun.time", VERSION_SHIP, 8, "int" );
	clientfield::register( "clientuimodel", "t10_mule_kick", VERSION_SHIP, 1, "int" );
	clientfield::register( "toplayer", "t10_junk", VERSION_SHIP, 16, "int" );

	// Callbacks
	callback::on_connect( &on_player_connect );
	zm::register_zombie_damage_override_callback( &zombie_death_points_callback );
}

function __main__()
{
	// Get rid of game over text
	level._supress_survived_screen = true;

	// Powerup modifications
	level._powerup_grab_check = &powerup_grab_check;

	// Set team colors
	level thread set_team_colors();
}

function on_player_connect()
{
	self thread menu_option_third_person_handler();
	self thread set_player_health_clientfield();
	self thread set_powerup_time_clientfield();
	self thread set_mule_kick_clientfield();
}

function set_player_uimodel_clientfield( name, val )
{
	if( IS_EQUAL( self clientfield::get_player_uimodel( name ), val ) )
	{
		return;
	}

	self clientfield::set_player_uimodel( name, val );
}

function set_world_clientfield( name, val )
{
	if( IS_EQUAL( level clientfield::get( name ), val ) )
	{
		return;
	}

	level clientfield::set( name, val );
}

function get_junk()
{
    DEFAULT( self.t10_junk, 0 );
    return self.t10_junk;
}

function set_junk( amount )
{
    self.t10_junk = math::clamp( amount, 0, 65000 );
    self clientfield::set_to_player( "t10_junk", self.t10_junk );
}

function add_to_player_junk( amount )
{
	current_junk = self get_junk();
	new_junk = current_junk + amount;
	self set_junk( new_junk );
}

function minus_to_player_junk( amount )
{
	current_junk = self get_junk();
	new_junk = current_junk - amount;
	self set_junk( new_junk );
}

function can_player_purchase_junk( amount )
{
	current_junk = self get_junk();
	return current_junk >= amount;
}

function set_team_colors()
{
	team_colors = array(
		"0.07 0.58 0.00 1",
		"0.98 1.00 0.04 1",
		"0.27 0.78 0.94 1",
		"0.97 0.40 0.77 1"
	);

	foreach( index, color in team_colors )
	{
		setdvar( "cg_scorescolor_gamertag_" + index, color );
	}
}

function menu_option_third_person_handler()
{
	self endon( "disconnect" );
	self notify( "menu_option_third_person_handler" );
	self endon( "menu_option_third_person_handler" );

	while( true )
	{
		self waittill( "menuresponse", menu, response );

		split_string = strtok( response, "|" );
		option_name = split_string[0];
		option_value = split_string[1];

		if( IS_EQUAL( menu, "StartMenu_Main" ) && IS_EQUAL( option_name, "ui_menu_option_third_person" ) )
		{
			self setclientthirdperson( int( option_value ) );
		}
	}
}

function set_player_health_clientfield()
{
    self endon( "disconnect" );
	self notify( "set_player_health_clientfield" );
	self endon( "set_player_health_clientfield" );

	while( true )
	{
		WAIT_SERVER_FRAME;
		health = ( zm_utility::is_player_valid( self ) ? float( self.health / self.maxhealth ) : 0 );
		level set_world_clientfield( "t10_health_" + self getentitynumber(), health );
	}
}

function powerup_grab_check( player )
{
	// Give full clip with max ammo
	// Give full armor with carpenter
	if( IS_EQUAL( self.powerup_name, "full_ammo" ) )
	{
		array::run_all( getplayers(), &full_ammo_give_clip );
	}
	else if( IS_EQUAL( self.powerup_name, "carpenter" ) )
	{
		array::run_all( getplayers(), &carpenter_give_armor );
	}

	// Do powerup notification
	if( IS_TRUE( self.only_affects_grabber ) )
	{
		player send_powerup_notification( self );
	}
	else
	{
		array::run_all( getplayers(), &send_powerup_notification, self );
	}

	return true;
}

function full_ammo_give_clip()
{
	if( !zm_utility::is_player_valid( self ) )
	{
		return;
	}

	primary_weapons = self getweaponslistprimaries();
	
	foreach( weapon in primary_weapons )
	{
		self setweaponammoclip( weapon, weapon.clipsize );

		if( weapon.isdualwield )
		{
			dw_weapon = weapon.dualwieldweapon;
			self setweaponammoclip( dw_weapon, dw_weapon.clipsize );
		}
	}
}

function carpenter_give_armor()
{
	current_tier = self zm_t10_armor::armor_vest_get_tier();

	if( current_tier > 0 )
	{
		self zm_t10_armor::armor_vest_set_health( float( current_tier ) );
	}
}

function send_powerup_notification( powerup )
{
	text = undefined;

	switch( powerup.powerup_name )
	{
		case "carpenter":
			text = &"T10_UI_POWERUP_EVENT_CARPENTER";
			break;

		case "free_perk":
			text = &"T10_UI_POWERUP_EVENT_FREE_PERK";
			break;

		case "nuke":
			text = &"T10_UI_POWERUP_EVENT_NUKE";
			break;

		case "bonus_points_player":
		case "bonus_points_team":
			text = &"T10_UI_POWERUP_EVENT_BONUS_POINTS";
			break;

		default:
			break;
	}

	if( isdefined( text ) )
	{
		self luinotifyevent( &"zombie_notification", 1, text );
	}
}

function set_powerup_time_clientfield()
{
    self endon( "disconnect" );
	self notify( "set_powerup_time_clientfield" );
	self endon( "set_powerup_time_clientfield" );

	while( true )
	{
		WAIT_SERVER_FRAME;
		
		foreach( powerup in level.zombie_powerups )
		{
			client_field_name = powerup.client_field_name;

			if( isdefined( client_field_name ) )
			{
				time = get_powerup_time( powerup );

				if( isdefined( time ) )
				{
					self set_player_uimodel_clientfield( client_field_name + ".time", time );
				}
			}
		}
	}
}

function get_powerup_time( powerup )
{
	on_name = powerup.on_name;
	time_name = powerup.time_name;
	powerup_timer = undefined;
	powerup_on = undefined;
	time = undefined;
	
	if( isdefined( on_name ) && isdefined( time_name ) )
	{
		if( powerup.only_affects_grabber )
		{
			if( IS_TRUE( self._show_solo_hud ) )
			{
				powerup_timer = self.zombie_vars[time_name];
				powerup_on = self.zombie_vars[on_name];
			}
		}
		else if( isdefined( level.zombie_vars[self.team][time_name] ) )
		{
			powerup_timer = level.zombie_vars[self.team][time_name];
			powerup_on = level.zombie_vars[self.team][on_name];
		}
		else if( isdefined( level.zombie_vars[time_name] ) )
		{
			powerup_timer = level.zombie_vars[time_name];
			powerup_on = level.zombie_vars[on_name];
		}

		if( isdefined( powerup_timer ) && isdefined( powerup_on ) )
		{
			time = math::clamp( int( powerup_timer ), 0, 255 );
		}
	}

	return time;
}

function set_mule_kick_clientfield()
{
    self endon( "disconnect" );
	self notify( "set_mule_kick_clientfield" );
	self endon( "set_mule_kick_clientfield" );

	while( true )
	{
		self waittill( "weapon_change", weapon );

		mule_kick = false;
		primary_weapons = self getweaponslistprimaries();

		if( primary_weapons.size > 2 )
		{
			last_weapon = primary_weapons[primary_weapons.size];

			if( IS_EQUAL( last_weapon, weapon ) )
			{
				mule_kick = !IS_EQUAL( last_weapon, level.zombie_powerup_weapon["minigun"] );
			}
		}

		self set_player_uimodel_clientfield( "t10_mule_kick", mule_kick );
	}
}

function zombie_death_points_callback( death, inflictor, attacker, damage, flags, mod, weapon, vpoint, vdir, sHitLoc, psOffsetTime, boneIndex, surfaceType )
{
	if( isdefined( self ) && IS_EQUAL( self.archetype, "zombie" ) && IS_EQUAL( self.team, level.zombie_team ) )
	{
		if( death && isdefined( attacker ) && isplayer( attacker ) )
		{
			player_points = zm_score::get_zombie_death_player_points();
			kill_bonus = get_points_kill_bonus( mod, sHitLoc, weapon, player_points );
			points = kill_bonus[0];
			text = kill_bonus[1];

			if( level.zombie_vars[attacker.team]["zombie_powerup_insta_kill_on"] == 1 && mod == "MOD_UNKNOWN" )
			{
				points *= 2;
			}

			player_points += points;
			player_points *= level.zombie_vars[attacker.team]["zombie_point_scalar"];

			attacker luinotifyevent( &"score_event", 2, text, player_points );
		}
	}
	
	return false;
}

function get_points_kill_bonus( mod, hit_location, weapon, player_points = undefined )
{
	ret_val = array( 0, &"T10_UI_SCORE_EVENT_ELIMINATION" );

	if( mod == "MOD_MELEE" )
	{
		ret_val[0] = level.zombie_vars["zombie_score_bonus_melee"];
		ret_val[1] = &"T10_UI_SCORE_EVENT_MELEE_KILL";
		return ret_val;
	}

	if( mod == "MOD_BURNED" )
	{
		ret_val[0] = level.zombie_vars["zombie_score_bonus_burn"];
		ret_val[1] = &"T10_UI_SCORE_EVENT_BURNED_KILL";
		return ret_val;
	}

	if( isdefined( hit_location ) )
    {
		switch( hit_location )
		{
			case "head":
			case "helmet":
				ret_val[0] = level.zombie_vars["zombie_score_bonus_head"];
				ret_val[1] = &"T10_UI_SCORE_EVENT_CRITICAL_KILL";
				break;
		
			case "neck":
				ret_val[0] = level.zombie_vars["zombie_score_bonus_neck"];
				ret_val[1] = &"T10_UI_SCORE_EVENT_ELIMINATION";
				break;
		
			case "torso_upper":
			case "torso_lower":
				ret_val[0] = level.zombie_vars["zombie_score_bonus_torso"];
				ret_val[1] = &"T10_UI_SCORE_EVENT_ELIMINATION";
				break;
			
			default:
				break;
		}
    }

	return ret_val; 
}
