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

#insert scripts\zm\_zm_t10_weapon_upgrade.gsh;

#precache( "client_fx", T10_PACK_A_PUNCH_IDLE_FX );
#precache( "client_fx", T10_WEAPON_UPGRADE_IDLE_LIGHT_FX );
#precache( "client_fx", T10_WEAPON_UPGRADE_IDLE_SMOKE_FX );

#namespace zm_t10_weapon_upgrade;

REGISTER_SYSTEM_EX( "zm_t10_weapon_upgrade", &__init__, &__main__, undefined )

function __init__()
{
    // Clientfields
    clientfield::register( "clientuimodel", T10_PACK_A_PUNCH_TIER_CF_NAME, VERSION_SHIP, 2, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "scriptmover", T10_PACK_A_PUNCH_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int", &pack_a_punch_idle_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", T10_WEAPON_UPGRADE_AAT_SUPPORTED_CF_NAME, VERSION_SHIP, 1, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "clientuimodel", T10_WEAPON_UPGRADE_TIER_CF_NAME, VERSION_SHIP, 3, "int", undefined, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "scriptmover", T10_WEAPON_UPGRADE_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int", &weapon_upgrade_idle_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

    // Load the menu
    luiload( "ui.uieditor.menus.T10WeaponUpgrade.T10WeaponUpgrade_Main" );

    // FX
    level._effect["pack_a_punch_idle"] = T10_PACK_A_PUNCH_IDLE_FX;
    level._effect["weapon_upgrade_idle_light"] = T10_WEAPON_UPGRADE_IDLE_LIGHT_FX;
    level._effect["weapon_upgrade_idle_smoke"] = T10_WEAPON_UPGRADE_IDLE_SMOKE_FX;
}

function __main__()
{
}

function pack_a_punch_idle_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self endon( "entityshutdown" );

	self util::waittill_dobj( localClientNum );

    if( isdefined( self.pack_a_punch_idle_fx ) )
    {
        stopfx( localClientNum, self.pack_a_punch_idle_fx );
        self.pack_a_punch_idle_fx = undefined;
    }

    if( newVal )
    {
        self.pack_a_punch_idle_fx = playfxontag( localClientNum, level._effect["pack_a_punch_idle"], self, "sphere_jnt" );
    }
}

function weapon_upgrade_idle_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self endon( "entityshutdown" );

	self util::waittill_dobj( localClientNum );

    if( isdefined( self.weapon_upgrade_idle_light_fx ) )
    {
        stopfx( localClientNum, self.weapon_upgrade_idle_light_fx );
        self.weapon_upgrade_idle_light_fx = undefined;
    }

    if( isdefined( self.weapon_upgrade_idle_smoke_fx ) )
    {
        stopfx( localClientNum, self.weapon_upgrade_idle_smoke_fx );
        self.weapon_upgrade_idle_smoke_fx = undefined;
    }

    if( newVal )
    {
        self.weapon_upgrade_idle_light_fx = playfxontag( localClientNum, level._effect["weapon_upgrade_idle_light"], self, "j_light" );
        self.weapon_upgrade_idle_smoke_fx = playfxontag( localClientNum, level._effect["weapon_upgrade_idle_smoke"], self, "tag_origin" );
    }
}