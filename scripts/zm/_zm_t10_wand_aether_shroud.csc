#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_utility;

#insert scripts\shared\duplicaterender.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_t10_wand_aether_shroud.gsh;

#precache( "client_fx", AETHER_SHROUD_PLAYER_FX );

#namespace zm_t10_wand_aether_shroud;

REGISTER_SYSTEM( "zm_t10_wand_aether_shroud", &__init__, undefined )

function __init__()
{
    // Clientfields
    clientfield::register( "toplayer", "aether_shroud_post_fx", VERSION_SHIP, 1, "int", &aether_shroud_post_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
    clientfield::register( "allplayers", "aether_shroud_duplicate_render", VERSION_SHIP, 1, "int", &aether_shroud_duplicate_render, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );

    // Duplicate renders
	duplicate_render::set_dr_filter_framebuffer( "aether_shroud", 90, "aether_shroud_on", undefined, DR_TYPE_FRAMEBUFFER, AETHER_SHROUD_MATERIAL, DR_CULL_ALWAYS );

    // FX
    level._effect["wand_aether_shroud"] = AETHER_SHROUD_PLAYER_FX;
}

function aether_shroud_post_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
    self endon( "entityshutdown" );

    if( newVal )
    {
        self thread postfx::playPostfxBundle( AETHER_SHROUD_POST_FX );
        self playsound( localClientNum, AETHER_SHROUD_START_SOUND );
        self playloopsound( AETHER_SHROUD_LOOP_SOUND, 1 );
    }
    else
    {
        self thread postfx::stopPlayingPostfxBundle();
        self playsound( localClientNum, AETHER_SHROUD_END_SOUND );
        self stopallloopsounds( 1 );
    }
}

function aether_shroud_duplicate_render( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
    self endon( "entityshutdown" );

    if( isdefined( self.aether_shroud_fx ) )
    {
        stopfx( localClientNum, self.aether_shroud_fx );
        self.aether_shroud_fx = undefined;
    }

    if( newVal )
    {
        self.aether_shroud_fx = playfxontag( localClientNum, level._effect["wand_aether_shroud"], self, "j_spine4" );
    }

    self duplicate_render::update_dr_flag( localClientNum, "aether_shroud_on", newVal );
    self mapshaderconstant( localClientNum, 0, "scriptVector3", 1, newVal, 0, 1 );
}
