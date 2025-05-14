#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_perks.gsh;
#insert scripts\zm\_zm_t10_buyable_perk.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "menu", "T10BuyablePerk_Main" );
#precache( "triggerstring", "T10_BUYABLE_PERK" );

#using_animtree( "generic" );

#namespace zm_t10_buyable_perk;

REGISTER_SYSTEM_EX( "zm_t10_buyable_perk", &__init__, &__main__, undefined )

function __init__()
{
	// Clientfields
	clientfield::register( "scriptmover", T10_BUYABLE_PERK_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int" );

	// Callbacks
	callback::on_connect( &on_player_connect );
	callback::on_laststand( &on_player_laststand );
}

function __main__()
{
	// Init unitriggers
	level.t10_buyable_perk_machines = struct::get_array( "zm_t10_buyable_perk_machine", "targetname" );
	array::thread_all( level.t10_buyable_perk_machines, &spawn_init, &buyable_perk_update_prompt, &buyable_perk_trigger_think );
}

function on_player_connect()
{
	// Handles opening the buyable perk menu
	self thread buyable_perk_menu_handler();
}

function on_player_laststand()
{
	// Handles closing the buyable perk menu when downed
	self buyable_perk_close_menu();
}

function spawn_init( update_prompt_func, trigger_think_func )
{
	// Spawn the model
	self.spawned_model = util::spawn_model( T10_BUYABLE_PERK_MODEL_OFF, self.origin, self.angles );
	self.spawned_model useanimtree( #animtree );

	// tag_origin is at the back of the model, adjust origin for trigger
	self.origin += vectorscale( anglestoforward( self.angles ), 24 );

	// Spawn the bump trigger
	self.bump_trigger = spawn( "trigger_radius", self.origin + vectorscale( ( 0, 0, 1 ), 20 ), 0, 40, 80 );
	self.bump_trigger.script_activated = 1;
	self.bump_trigger.script_sound = "zmb_perks_bump_bottle";
	self.bump_trigger.targetname = "audio_bump_trigger";

	// Spawn the unitrigger at the correct height
	self.origin += ( 0, 0, 56 );
	self.script_unitrigger_type = "unitrigger_box_use";
	self.cursor_hint = "HINT_NOICON";
	self.require_look_at = true;
	self.prompt_and_visibility_func = update_prompt_func;
	zm_unitrigger::register_static_unitrigger( self, trigger_think_func );

	// Turn on the machine
	level thread buyable_perk_wait_for_power( self );
}

function buyable_perk_update_prompt( player )
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

	self sethintstring( &"T10_BUYABLE_PERK" );
	return true;
}

function buyable_perk_trigger_think()
{
	self endon( "kill_trigger" );
	
	while( true )
	{
		self waittill( "trigger", player );
		player buyable_perk_open_menu();
	}
}

function buyable_perk_wait_for_power( stub )
{
	level endon( "end_game" );

	// Turn on the machine
	level flag::wait_till( "power_on" );
	stub.spawned_model setmodel( T10_BUYABLE_PERK_MODEL_ON );
	stub.spawned_model clientfield::set( T10_BUYABLE_PERK_IDLE_FX_CF_NAME, 1 );
	stub.spawned_model playloopsound( T10_BUYABLE_PERK_IDLE_SOUND );

	// Setup the jingle
	stub.spawned_model.script_sound = buyable_perk_get_random_jingle();
	stub.spawned_model.sndJingleCooldown = false;
	stub.spawned_model thread zm_audio::sndPerksJingles_Timer();
	level thread buyable_perk_rotate_jingle( stub );
}

function buyable_perk_get_random_jingle()
{
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	random_trigger = array::random( vending_triggers );
	return random_trigger.script_sound;
}

function buyable_perk_rotate_jingle( stub )
{
	level endon( "end_game" );

	while( true )
	{
		wait( 30 );
		stub.spawned_model.script_sound = buyable_perk_get_random_jingle();
	}
}

function buyable_perk_close_menu()
{
	// Close the menu
	self closeingamemenu();
	self closemenu( "T10BuyablePerk_Main" );
}

function buyable_perk_open_menu()
{
	// Open the menu
	self buyable_perk_close_menu();
    self openmenu( "T10BuyablePerk_Main" );
}

function buyable_perk_menu_handler()
{
	self endon( "disconnect" );
	self notify( "buyable_perk_menu_handler" );
	self endon( "buyable_perk_menu_handler" );

	while( true )
	{
		// Wait for the menu response
		self waittill( "menuresponse", menu, response );

		// Make sure it's the correct menu
		if( !IS_EQUAL( menu, "T10BuyablePerk_Main" ) )
		{
			continue;
		}

		// Get the machine stub
		machine_stub = arraygetclosest( self.origin, level.t10_buyable_perk_machines );

		// Make sure the model exists
		if( !isdefined( machine_stub ) || !isdefined( machine_stub.spawned_model ) )
		{
			continue;
		}

		// Close the menu if we send the close string
		if( IS_EQUAL( response, "close" ) )
		{
			self buyable_perk_close_menu();
			continue;
		}

		// Make sure it's a valid response
		if( !issubstr( response, "," ) )
		{
			continue;
		}

		// Sort the response string
		split_string = strtok( response, "," );
		cost = int( split_string[0] );
		perk = STR( split_string[1] );

		// Limit quick revive in solo
		if( IS_EQUAL( perk, PERK_QUICK_REVIVE ) && level flag::exists( "solo_game" ) && level flag::exists( "solo_revive" ) && level flag::get( "solo_game" ) && level flag::get( "solo_revive" ) )
		{
			self playsound( "zmb_no_cha_ching" );
			self zm_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		// Check if we should be able to buy the perk
		if( self hasperk( perk ) || self zm_perks::has_perk_paused( perk ) || !self zm_utility::can_player_purchase_perk() )
		{
			self playsound( "zmb_no_cha_ching" );
			self zm_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		// Check if we can afford the perk
		if( !self zm_score::can_player_purchase( cost ) )
		{
			self playsound( "zmb_no_cha_ching" );
			self zm_audio::create_and_play_dialog( "general", "outofmoney" );
			continue;
		}

		// Give perk
		self playsound( "zmb_cha_ching" );
		self zm_score::minus_to_player_score( cost );
		self thread buyable_perk_give( perk );
		machine_stub.spawned_model thread animation::play( T10_BUYABLE_PERK_ANIM_IDLE );
	}
}

function buyable_perk_give( perk )
{
	self endon( "disconnect" );
	self endon( "perk_abort_drinking" );

	self.perk_purchased = perk;
	self notify( "perk_purchased", perk );
	
	self zm_perks::give_perk( perk, false );

	// Only do drink animation if we're not already doing it
	// This is how it works in the newer games
	if( !IS_DRINKING( self.is_drinking ) )
	{
		gun = self zm_perks::perk_give_bottle_begin( perk );
		self util::waittill_any( "fake_death", "death", "self_downed", "weapon_change_complete", "perk_abort_drinking", "disconnect" );
		self zm_perks::perk_give_bottle_end( gun, perk );
	}

	// TODO: race condition?
	if( self laststand::player_is_in_laststand() || IS_TRUE( self.intermission ) )
	{
		return;
	}

	self notify( "burp" );
	
	if( isdefined( level.perk_bought_func ) )
	{
		self [[level.perk_bought_func]]( perk );
	}

	self.perk_purchased = undefined;

	// Check If Perk Machine Was Powered Down While Drinking, Is So Pause The Perks
	//-----------------------------------------------------------------------------
	machine_trigger = GetEnt( perk, "script_noteworthy" );

	if( isdefined( machine_trigger ) )
	{
		if( !IS_TRUE( machine_trigger.power_on ) )
		{
			wait( 1 ); 
			zm_perks::perk_pause( perk );
		}
	}
}
