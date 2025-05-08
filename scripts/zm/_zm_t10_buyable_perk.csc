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

#insert scripts\zm\_zm_t10_buyable_perk.gsh;

#precache( "client_fx", T10_BUYABLE_PERK_IDLE_FX );

#namespace zm_t10_buyable_perk;

REGISTER_SYSTEM_EX( "zm_t10_buyable_perk", &__init__, &__main__, undefined )

function __init__()
{
    // Clientfields
    clientfield::register( "scriptmover", T10_BUYABLE_PERK_IDLE_FX_CF_NAME, VERSION_SHIP, 1, "int", &buyable_perk_idle_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

    // Load the menu
    luiload( "ui.uieditor.menus.T10BuyablePerk.T10BuyablePerk_Main" );

    // FX
    level._effect["buyable_perk_idle"] = T10_BUYABLE_PERK_IDLE_FX;
}

function __main__()
{
}

function buyable_perk_idle_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self endon( "entityshutdown" );

	self util::waittill_dobj( localClientNum );

    if( isdefined( self.buyable_perk_idle_fx ) )
    {
        stopfx( localClientNum, self.buyable_perk_idle_fx );
        self.buyable_perk_idle_fx = undefined;
    }

    if( newVal )
    {
        self.buyable_perk_idle_fx = playfxontag( localClientNum, level._effect["buyable_perk_idle"], self, "body_jnt" );
    }
}