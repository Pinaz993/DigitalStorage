--- Access Console
--- An object that, when connected to a DS network, allows the player to withdraw and deposit non-bee items.
--- Features:
---     Placeable in world
---     Does not require power
---     Search bar
---         Will query by item name by default
---         Can search by tooltip and OID using prefixes, as defined by mod BEI by bCubed.
---             \; searches by oid
---             \@ searches by mod
---             \,[] searches by tooltip string
---     Displays items in a similar way to the bee box and bee bank interface.

function define_access_console()
    -- Properties
    NAME = "Access Console"
    ID = "access_console"
    CATEGORY = "Storage"
    TOOLTIP = "Provides access to items in digital storage."
    LAYOUT = {  -- Layout of all inventory slots in the interface.
        {4, 4, "Input"} -- The input slot for the terminal
    }
    BUTTONS = {"Help", "Target", "Close"} -- Which buttons to show on the upper left edge of the interface window.
    INFO = { -- Text to be displayed on the right side of the window when the help overlay is active.
        {"1. DS Network Input", "BLUE"},
        {"2. DS Network Access", "PURPLE"},
        {"3. Terminal Output Buffer", "ORANGE"}
    }
    TOOLS = {"mouse1", "hammer1"} -- Which tool icons to show in the tooltip.
    PLACEABLE = true -- Can it be placed?
    -- Sprite paths
    ITEM_SPRITE_PATH = "sprites/access_console/access_console_item.png"
    MENU_SPRITE_PATH = "sprites/access_console/access_console_menu.png"
    -- Scripts (functions nominally defined in scripts.lua)
    DEFINE_SCRIPT = "access_console_define"
    DRAW_SCRIPT = "access_console_draw"
    TICK_SCRIPT = "access_console_tick"
    CHANGE_SCRIPT = "access_console_change"
end