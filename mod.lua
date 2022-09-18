---
--- Author: Patrick Shannon
--- Digital Storage (working title) is a mod originally fashioned after Applied Energistics and similar mods for
--- Minecraft. However, due to the dissimilarities between APICO and Minecraft, a simpler implementation was decided
--- upon.
---
--- Digital Storage focuses on the digital transfer and storage of inventory items and fluids. All devices depend on the
--- concept of honeycore resonance to achieve wireless transfer. Any dispatching device may dispatch items and fluids to
--- any receiving device on the same frequency. All fluid handling will ignore the `power` fluid, as it is a
--- representation of bv.
---
--- Devices:
---    *Dispatcher: A device that transmits the item or fluid in the given slot(s) in the given menu object to any
---     receiving device on the same frequency. Does not have an item or fluid buffer. Is powered by bv, and uses a
---     static amount per item or bl received. Very low bv cost on idle.
---    *Receiver: A device that places the item or fluid received from any dispatching machine on the same frequency in
---     the given slot(s) in the given menu object. Does not have an item or fluid buffer. Is powered by BV, and uses a
---     static amount per item or bl received. Very low bv cost on idle.
---    *Item Depot: A device that can receive, dispatch and store items. Has separate frequencies for reception and
---     dispatch. Can filter on both. Is powered by bv, and uses a static amount per item received or dispatched. Very
---     low bv cost on idle. Does not require bv to store items or be accessed. Will not accept transmissions of items
---     it cannot accept (i.e, the container is full, or there is no room for the items.)
---    *Fluid Depot: A device that can receive, dispatch, and store fluids. Has separate frequencies for reception and
---     dispatch. can filter on both. is powered by bv, and uses a static amount per item received or dispatched. Very
---     low bv cost on idle. Does not require bv to store fluids, or be accessed. Will not accept transmissions of
---     fluids it cannot accept (i.e. different fluid from what is in the tank, tank is full).
---    *Resonance Pylon: Enables all DS devices in its radius to operate. Does not have a menu interface, but if the
---     player is hovering over it, the range of the device will be displayed, much as a queen's range is displayed in a
---     hive or apiary.
---
--- Methodology:
--- Objects are defined in a standalone .lua file, and contain prototypical objects as needed.
---

--TODO: Frequency Selection Screen for implementation in all devices that need it.
--TODO: Machine and Slot selection screen for implementation in all devices that need it.
--TODO: Research adding additional window button to DS menus.
--TODO: Frequency management singleton
--TODO: Filter screen for implementation for all devices that need it.
--TODO: Implement Dispatcher
--TODO: Implement Receiver
--TODO: Implement Item Depot
--TODO: Implement Fluid Depot
--TODO: Implement Resonance Pylon
--

-- Mod Properties
MOD_NAME = "digital_storage"

--- Register the mod with the game.
---
--- Hooks are methods that are defined here, just like register() and init(). If we want to use them, we need to ask
--- for them to be enabled for our mod in the hooks table.
---
--- Modules are additional Lua files we can put code in, I think.
function register()
    return {
        name = MOD_NAME
        --hooks = {}, -- Don't need any hooks just yet
        --modules = {} -- Or any modules, though that may change.
    }
end

--- This is run when the game first starts. Any setup code needs to be run from here.
--- Return 'Success' if all is well. Otherwise, return an error code.
function init()
    api_set_devmode(true)
    return "Success"
end