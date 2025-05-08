#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_t10_armor;
#using scripts\zm\_zm_t10_buyable_perk;
#using scripts\zm\_zm_t10_item_drops;
#using scripts\zm\_zm_t10_wand_aether_shroud;
#using scripts\zm\_zm_t10_weapon_upgrade;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_t10_hud;

REGISTER_SYSTEM_EX( "zm_t10_hud", &__init__, &__main__, undefined )

function __init__()
{
    // Clientfields
    for( i = 0; i < getdvarint( "com_maxclients" ); i++ )
    {
        clientfield::register( "world", "t10_health_" + i, VERSION_SHIP, 7, "float", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    }

    clientfield::register( "clientuimodel", "powerup_instant_kill.time", VERSION_SHIP, 8, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "powerup_double_points.time", VERSION_SHIP, 8, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "powerup_fire_sale.time", VERSION_SHIP, 8, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "powerup_mini_gun.time", VERSION_SHIP, 8, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", "t10_mule_kick", VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "toplayer", "t10_junk", VERSION_SHIP, 16, "int", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

    // Load the menu
    luiload( "ui.uieditor.menus.hud.T10Hud_zm_factory" );
}

function __main__()
{
}

function set_ui_model_value( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	setuimodelvalue( createuimodel( getuimodelforcontroller( localClientNum ), fieldName ), newVal );
}
