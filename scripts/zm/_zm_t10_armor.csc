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

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_t10_armor.gsh;

#namespace zm_t10_armor;

REGISTER_SYSTEM_EX( "zm_t10_armor", &__init__, &__main__, undefined )

function __init__()
{
    // Clientfields
    for( i = 0; i < getdvarint( "com_maxclients" ); i++ )
    {
        clientfield::register( "world", T10_ARMOR_VEST_TIER_CF_NAME + "_" + i, VERSION_SHIP, 2, "int", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
        clientfield::register( "world", T10_ARMOR_VEST_PLATE_CF_NAME + "_" + i, VERSION_SHIP, 2, "int", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
        clientfield::register( "world", T10_ARMOR_VEST_HEALTH_CF_NAME + "_" + i, VERSION_SHIP, 7, "float", &set_ui_model_value, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    }
    
    clientfield::register( "clientuimodel", T10_ARMOR_PLATE_AMMO_CF_NAME, VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function __main__()
{
}

// A function to create a model and set the clientfield's value to it
// This is necessary to send data to the ui for clientfield's that are not clientuimodel type.
function set_ui_model_value( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	setuimodelvalue( createuimodel( getuimodelforcontroller( localClientNum ), fieldName ), newVal );
}
