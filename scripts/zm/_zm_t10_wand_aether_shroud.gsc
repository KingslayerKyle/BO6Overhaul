#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_hero_weapon;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_t10_wand_aether_shroud.gsh;

#namespace zm_t10_wand_aether_shroud;

REGISTER_SYSTEM( "zm_t10_wand_aether_shroud", &__init__, undefined )

function __init__()
{
	// Clientfields
	clientfield::register( "toplayer", "aether_shroud_post_fx", VERSION_SHIP, 1, "int" );
	clientfield::register( "allplayers", "aether_shroud_duplicate_render", VERSION_SHIP, 1, "int" );

	// Register aether shroud as a hero weapon
	zm_hero_weapon::register_hero_weapon( AETHER_SHROUD_WEAPON_NAME );
	zm_hero_weapon::register_hero_weapon_wield_unwield_callbacks( AETHER_SHROUD_WEAPON_NAME, &aether_shroud_wield, &aether_shroud_unwield );
	zm_hero_weapon::register_hero_weapon_power_callbacks( AETHER_SHROUD_WEAPON_NAME, &aether_shroud_power_full, &aether_shroud_power_empty );

	// Callbacks
	callback::on_spawned( &on_player_spawned );
	callback::on_laststand( &on_player_laststand );
}

function aether_shroud_wield( weapon )
{
	self endon( "disconnect" );

	// Wait
	wait( 0.7 );

	// Check player is valid after the wait
	if( !zm_utility::is_player_valid( self ) )
	{
		return;
	}

	// Check player didn't switch weapons
	if( !IS_EQUAL( self getcurrentweapon(), weapon ) )
	{
		return;
	}

	// Check the hero weapon is fully charged
	if( !IS_EQUAL( self.hero_power, HERO_MAXPOWER ) )
	{
		return;
	}

	// Make the hero weapon unusable
	self setweaponammoclip( weapon, 0 );

	// Set hero weapon state to in use
	self zm_hero_weapon::default_wield( weapon );

	// Activate aether shroud
	self aether_shroud_activate();

	// Wait for weapon swap to be done
	self waittill( "weapon_change_complete" );

	// Switch back to primary weapon
	self switchtoweapon();
}

function aether_shroud_unwield( weapon )
{
	// Do nothing,
	// Can't set this function to undefined
	// Because that will do the default unwield
}

function aether_shroud_power_full( weapon )
{
	// If we get a full power, stop the hero weapon
	if( self zm_hero_weapon::is_hero_weapon_in_use() )
	{
		// Deactivate aether shroud
		self aether_shroud_deactivate();
	}

	// Make the hero weapon usable
	self setweaponammoclip( weapon, 1 );

	// Set hero weapon state to ready
	self zm_hero_weapon::default_power_full( weapon );
}

function aether_shroud_power_empty( weapon )
{
	// Deactivate aether shroud
	self aether_shroud_deactivate();

	// Set hero weapon state to charging
	self zm_hero_weapon::default_power_empty( weapon );
}

function on_player_spawned()
{
	// Give aether shroud on spawn
	self thread give_hero_weapon_on_spawn();
}

function on_player_laststand()
{
	// Deactivate aether shroud
	self aether_shroud_deactivate();
}

function give_hero_weapon_on_spawn()
{
	self endon( "disconnect" );

	// Wait until the player has a weapon
	self waittill( "weapon_change_complete" );

	// Give hero weapon
	self zm_weapons::weapon_give( AETHER_SHROUD_WEAPON );
	self setweaponammoclip( AETHER_SHROUD_WEAPON, 0 );
	self gadgetpowerset( 0, 0 );
}

function aether_shroud_activate()
{
	// Start draining the hero weapon
	self thread zm_hero_weapon::continue_draining_hero_weapon( AETHER_SHROUD_WEAPON );

	// Set aether shroud clientfields
	self clientfield::set_to_player( "aether_shroud_post_fx", 1 );
	self clientfield::set( "aether_shroud_duplicate_render", 1 );

	// Make zombies ignore the player
	self zm_utility::increment_ignoreme();

	// Handle if anything else decrements ignoreme
	self thread aether_shroud_ignoreme_monitor();
}

function aether_shroud_deactivate()
{
	// Stop draining
	self notify( "stop_draining_hero_weapon" );

	// Set aether shroud clientfields
	self clientfield::set_to_player( "aether_shroud_post_fx", 0 );
	self clientfield::set( "aether_shroud_duplicate_render", 0 );

	// Make zombies NOT ignore the player
	self zm_utility::decrement_ignoreme();

	// Set hero weapon state back to charging
	self zm_hero_weapon::set_hero_weapon_state( undefined, 1 );
}

function aether_shroud_ignoreme_monitor()
{
	self endon( "disconnect" );
	self endon( "stop_draining_hero_weapon" );

	while( true )
	{
		WAIT_SERVER_FRAME;

		// Is the player valid?
		is_player_valid = zm_utility::is_player_valid( self, false, false );

		// Is the hero weapon in use?
		is_hero_weapon_in_use = self zm_hero_weapon::is_hero_weapon_in_use();

		// Are we being ignored?
		ignoreme = IS_TRUE( self.ignoreme );

		// If any of these return false then we need to deactivate aether shroud
		if( !is_player_valid || !is_hero_weapon_in_use || !ignoreme )
		{
			self thread aether_shroud_deactivate();
		}
	}
}