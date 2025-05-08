// -------------------------------------------------------------------------------
// Black Ops 6 Style Item Drops for Black Ops III
// Based on original script by Scobalula
// -------------------------------------------------------------------------------
// Originally licensed under the "Do whatever you want thx hun bun" license.
// Modified by Kingslayer Kyle for Black Ops 6 style behavior.
// -------------------------------------------------------------------------------
// NOTE: A lot of these values can be overridden in GSC by the level variables
// on a per map basis, refer to the main gsc for more information!
// -----------------------------------------
// Spawn Settings
// -----------------------------------------
// Defines whether or not to only drop for player kills. (True/False)
#define ZM_ITEM_DROPS_REQUIRES_PLAYER               true
// Defines whether or not to only drop in valid zones.  (True/False)
#define ZM_ITEM_DROPS_REQUIRES_VALID_ZONE           true
// Defines whether or not to only drop if there is a line of sight.  (True/False)
#define ZM_ITEM_DROPS_REQUIRES_LINE_OF_SIGHT        true
// Defines whether or not items can overlap on drop.  (True/False)
#define ZM_ITEM_DROPS_REQUIRES_NO_OVERLAPS          true
// Defines the min round for an item to drop.  (Integer)
#define ZM_ITEM_DROPS_MIN_ROUND                     1
// The max number of items that can be dropped at once. (Integer)
#define ZM_ITEM_DROPS_MAX_ITEMS                     20
// The default time to live before an item deletes itself. (Integer)
#define ZM_ITEM_DROPS_DEFAULT_TIME_TO_LIVE          120
// The minimum number of kills required for another drop. (Integer)
#define ZM_ITEM_DROPS_KILLS_REQUIRED_MIN            2
// The maximum number of kills required for another drop. (Integer)
#define ZM_ITEM_DROPS_KILLS_REQUIRED_MAX            5
// Defines the radius for triggers and touching items to pick them up. (Float)
#define ZM_ITEM_DROPS_RANGE_SQUARED                 1000

// -----------------------------------------
// Drop Calculation
// -----------------------------------------
// The min radius for searching for a drop location. (Float)
#define ZM_ITEM_DROPS_DROP_CALC_MIN_RADIUS      80
// The max radius for searching for a drop location. (Float)
#define ZM_ITEM_DROPS_DROP_CALC_MAX_RADIUS      140
// The max height difference away from the origin for a drop location. (Float)
#define ZM_ITEM_DROPS_DROP_CALC_HALF_HEIGHT     48
// The distance between points when searching for a drop location. (Float)
#define ZM_ITEM_DROPS_DROP_CALC_INNER_SPACING   16

// -----------------------------------------
// Item Types
// -----------------------------------------
// Defines the white item drop. (Integer)
#define ZM_ITEM_DROPS_WHITE                     1
// Defines the green item drop. (Integer)  
#define ZM_ITEM_DROPS_GREEN                     2
// Defines the blue item drop. (Integer)
#define ZM_ITEM_DROPS_BLUE                      3
// Defines the yellow item drop. (Integer)
#define ZM_ITEM_DROPS_YELLOW                    4

// -----------------------------------------
// Item Collection Types
// -----------------------------------------
// Defins whether or not the item is picked up by touching it. (Integer)
#define ZM_ITEM_DROP_PICK_UP_TOUCH              0
// Defins whether or not the item is picked up by a unitrigger. (Integer)
#define ZM_ITEM_DROP_PICK_UP_UNITRIGGER         1
// Defins whether or not the item is picked up by both. (Integer)
#define ZM_ITEM_DROP_PICK_UP_BOTH               2

// -----------------------------------------
// Item Assets
// -----------------------------------------
// Defines the white item drop fx name. (String)
#define ZM_ITEM_DROPS_WHITE_FX_NAME                 "_t10/item_drops/white"
// Defines the green item drop fx name. (String)
#define ZM_ITEM_DROPS_GREEN_FX_NAME                 "_t10/item_drops/green"
// Defines the blue item drop fx name. (String)
#define ZM_ITEM_DROPS_BLUE_FX_NAME                  "_t10/item_drops/blue"
// Defines the yellow item drop fx name. (String)
#define ZM_ITEM_DROPS_YELLOW_FX_NAME                "_t10/item_drops/yellow"
// Defines the white item drop fx name. (String)
#define ZM_ITEM_DROPS_WHITE_MTL_NAME                "mc/mtl_zm_t10_item_drops_white"
// Defines the green item drop fx name. (String)
#define ZM_ITEM_DROPS_GREEN_MTL_NAME                "mc/mtl_zm_t10_item_drops_green"
// Defines the blue item drop fx name. (String)
#define ZM_ITEM_DROPS_BLUE_MTL_NAME                 "mc/mtl_zm_t10_item_drops_blue"
// Defines the yellow item drop fx name. (String)
#define ZM_ITEM_DROPS_YELLOW_MTL_NAME               "mc/mtl_zm_t10_item_drops_yellow"
// Defines the default sound to play on dropping. (String)
#define ZM_ITEM_DROPS_DEFAULT_DROP_SOUND            undefined
// Defines the default sound to play on landing. (String)
#define ZM_ITEM_DROPS_DEFAULT_LAND_SOUND            undefined
// Defines the default sound to play on loop. (String)
#define ZM_ITEM_DROPS_DEFAULT_LOOP_SOUND            undefined
// Defines the default sound to play on landing. (String)
#define ZM_ITEM_DROPS_DEFAULT_PICK_UP_SOUND         undefined

// -----------------------------------------
// Advanced Settings
// -----------------------------------------
// Defines the target name of dropped items. (String)
#define ZM_ITEM_DROPS_TARGET_NAME       "zm_dropped_item"
// Defines the number of fx variants. (Integer)
#define ZM_ITEM_DROPS_FX_VARIANTS       4
// Defines the number of iterations to perform to get a valid location. (Integer)
#define ZM_ITEM_DROPS_CALC_ITERATIONS   8
// Defines the bounds scalar padding to apply to radius. (Float)
#define ZM_ITEM_DROPS_BOUNDS_SCALAR     2
// Defines the height for which to test visbility to the drops. (Float)
#define ZM_ITEM_DROPS_VIS_HEIGHT        72
// Defines the name of the drop fx cf name. (String)
#define ZM_ITEM_DROPS_FX_CF_NAME        "zm_item_drops_fx"

// -----------------------------------------
// Specific drops
// -----------------------------------------
// Pickup sounds
#define ZM_ITEM_DROPS_AMMO_PICKUP_SOUND         "fly_equipment_pickup"
#define ZM_ITEM_DROPS_ARMOR_PICKUP_SOUND        "eqp_armor_plates_pickup"
#define ZM_ITEM_DROPS_JUNK_PICKUP_SOUND         "zmb_buildable_pickup"

// Drop chance
#define ZM_ITEM_DROPS_AMMO_CHANCE               10
#define ZM_ITEM_DROPS_ARMOR_CHANCE              25
#define ZM_ITEM_DROPS_JUNK_CHANCE               100
