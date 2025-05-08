#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_zm_utility;

#insert scripts\shared\duplicaterender.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#insert scripts\zm\_zm_t10_item_drops.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache("client_fx", ZM_ITEM_DROPS_WHITE_FX_NAME);
#precache("client_fx", ZM_ITEM_DROPS_GREEN_FX_NAME);
#precache("client_fx", ZM_ITEM_DROPS_BLUE_FX_NAME);
#precache("client_fx", ZM_ITEM_DROPS_YELLOW_FX_NAME);

#namespace zm_t10_item_drops;

REGISTER_SYSTEM_EX("zm_t10_item_drops", &__init__, &__main__, undefined)

function __init__()
{
    // Clientfields
    clientfield::register("scriptmover", ZM_ITEM_DROPS_FX_CF_NAME, VERSION_SHIP, GetMinBitCountForNum(ZM_ITEM_DROPS_FX_VARIANTS), "int", &do_dropped_item_fx, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);

    // Duplicate Renders
    duplicate_render::set_dr_filter_framebuffer_duplicate("dr_zm_item_drop_white",   90, "zm_item_drop_white",   undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, ZM_ITEM_DROPS_WHITE_MTL_NAME,   DR_CULL_ALWAYS);
    duplicate_render::set_dr_filter_framebuffer_duplicate("dr_zm_item_drop_green",   90, "zm_item_drop_green",   undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, ZM_ITEM_DROPS_GREEN_MTL_NAME,   DR_CULL_ALWAYS);
    duplicate_render::set_dr_filter_framebuffer_duplicate("dr_zm_item_drop_blue",    90, "zm_item_drop_blue",    undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, ZM_ITEM_DROPS_BLUE_MTL_NAME,    DR_CULL_ALWAYS);
    duplicate_render::set_dr_filter_framebuffer_duplicate("dr_zm_item_drop_yellow",  90, "zm_item_drop_yellow",  undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, ZM_ITEM_DROPS_YELLOW_MTL_NAME,  DR_CULL_ALWAYS);

    // FX
    level._effect["zm_item_drop_white"]     = ZM_ITEM_DROPS_WHITE_FX_NAME;
    level._effect["zm_item_drop_green"]     = ZM_ITEM_DROPS_GREEN_FX_NAME;
    level._effect["zm_item_drop_blue"]      = ZM_ITEM_DROPS_BLUE_FX_NAME;
    level._effect["zm_item_drop_yellow"]    = ZM_ITEM_DROPS_YELLOW_FX_NAME;
}

function __main__()
{
}

// Handles fx and dr for a dropped item.
function private do_dropped_item_fx(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump)
{
    self endon("entityshutdown");

    if(isdefined(self.trailing_drop_fx))
    {
        StopFX(localClientNum, self.trailing_drop_fx);
        self.trailing_drop_fx = undefined;
    }

    switch(newVal)
    {
    case ZM_ITEM_DROPS_WHITE:
        self.trailing_drop_fx = PlayFXOnTag(localClientNum, level._effect["zm_item_drop_white"], self, "tag_origin");
        self duplicate_render::update_dr_flag(localClientNum, "zm_item_drop_white", 1);
        break;
    case ZM_ITEM_DROPS_GREEN:
        self.trailing_drop_fx = PlayFXOnTag(localClientNum, level._effect["zm_item_drop_green"], self, "tag_origin");
        self duplicate_render::update_dr_flag(localClientNum, "zm_item_drop_green", 1);
        break;
    case ZM_ITEM_DROPS_BLUE:
        self.trailing_drop_fx = PlayFXOnTag(localClientNum, level._effect["zm_item_drop_blue"], self, "tag_origin");
        self duplicate_render::update_dr_flag(localClientNum, "zm_item_drop_blue", 1);
        break;
    case ZM_ITEM_DROPS_YELLOW:
        self.trailing_drop_fx = PlayFXOnTag(localClientNum, level._effect["zm_item_drop_yellow"], self, "tag_origin");
        self duplicate_render::update_dr_flag(localClientNum, "zm_item_drop_yellow", 1);
        break;
    default:
        break;
    }
}