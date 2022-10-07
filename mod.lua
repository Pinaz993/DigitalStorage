---
--- Author: Patrick Shannon
--- Resonant Transfer is a mod originally fashioned after Applied Energistics and similar mods for
--- Minecraft. However, due to the dissimilarities between APICO and Minecraft, a simpler implementation was decided
--- upon.
---
--- Resonant Transfer focuses on the wireless transfer and storage of inventory items and fluids. All devices depend on
--- the concept of honeycore resonance to achieve wireless transfer. Any dispatching device may dispatch items and
--- fluids to any receiving device on the same frequency. All fluid handling will ignore the `power` fluid, as it is a
--- representation of bv.
---
--- Devices:
---    *Dispatcher: A device that transmits the item or fluid in the given slot(s) in the given menu object to any
---         receiving device on the same frequency. Does not have an item or fluid buffer. Is powered by bv, and uses a
---         static amount per item or bl received. Very low bv cost on idle.
---    *Receiver: A device that places the item or fluid received from any dispatching machine on the same frequency in
---         the given slot(s) in the given menu object. Does not have an item or fluid buffer. Is powered by BV, and
---         uses a static amount per item or bl received. Very low bv cost on idle.
---    *Depot: A device that can receive, dispatch and store items and fluids. Has separate frequencies for reception
---         and dispatch. Can filter on both. Is powered by bv, and uses a static amount per item received or
---         dispatched. Very low bv cost on idle. Does not require bv to be accessed. Will not accept transmissions of
---         items or fluids it cannot accept (i.e, the container is full, no room for  items, different fluid from what
---          is in the tank, tank is full, ect.)
---    *Resonance Pylon: Enables all DS devices in its radius to operate. Does not have a menu interface, but if the
---         player is hovering over it, the range of the device will be displayed, much as a queen's range is displayed
---         in a hive or apiary.
---
--- Methodology:
--- *Objects are defined in a standalone .lua file, and contain prototypical objects as needed. Object definitions are
---     defined in said .lua file at global scope, and also include any STATIC variables that need to be used elsewhere,
---     including in scripts.
--- *Scripts in the script module defer ALL logic to methods written in the .lua file that they best fit in.
--- *Since the order of clock() and tick() are non-deterministic, I've decided to use tick() exclusively. I cannot,
---     however, process every machine on every tick and also guarantee that there will not be lag. So, I've written
---     a tick scheduler. Every device is responsible for storing the amount of ticks they need to wait until their
---     next operation. The tick scheduler has an active queue and a passive queue. At the start of each tick, the
---     scheduler iterates through all devices in the passive queue, and calculate the new tick delay values for
---     each. Any with a zero tick delay are added to the end of the active queue. After processing the passive
---     queue, a configurable amount (default 20) of devices is processed and removed from the active queue. If any
---     devices are left in the active queue at the end of the tick, they will be first in line to be processed next
---     time. Considering that devices will have a 5 tick delay before they are processed, this should mean that it
---     would take over 100 devices before the tick scheduler can get backed up.
--- *Some devices need to have processing done EVERY tick (such as receivers updating if they can receive items/fluids).
---     These devices will have a separate queue, made specifically for quicker tasks.
---

--TODO: Frequency Selection Screen for implementation in all devices that need it.
--TODO: Machine and Slot selection screen for implementation in all devices that need it.
--TODO: Frequency management singleton
--TODO: Filter screen for implementation for all devices that need it.
--TODO: Implement Dispatcher
--TODO: Implement Receiver
--TODO: Implement Depot
--TODO: Implement Resonance Pylon
--

-- TODO: Implement tabs in interface.

-- Mod Properties
RESONANT_TRANSFER = {}
RESONANT_TRANSFER.ID = "resonant_transfer"
RESONANT_TRANSFER.TICK_SCHEDULE = {} -- A list of all devices that need to be ticked.
RESONANT_TRANSFER.TICK_SCHEDULE.PASSIVE = {} -- Devices to process every tick
RESONANT_TRANSFER.TICK_SCHEDULE.ACTIVE = {} -- Devices to process this tick
RESONANT_TRANSFER.TICK_SCHEDULE.MAX_UPDATES_PER_TICK = 20


--- Register the mod with the game.
---
--- Hooks are methods that are defined here, just like register() and init(). If we want to use them, we need to ask
--- for them to be enabled for our mod in the hooks table.
---
--- Modules are additional Lua files we can put code in.
function register()
    return {
        name = RESONANT_TRANSFER.ID,
        hooks = {"draw", "tick"}, -- Methods that need to be run in certain situations.
        modules = {"test_menu_item", "resonance_pylon"} -- Or any modules, though that may change.
    }
end

--- This is run when the game first starts. Any setup code needs to be run from here.
--- Return 'Success' if all is well. Otherwise, return an error code.
function init()
    --TODO: Set up error gathering mechanism to make sure that all the definition methods work smoothly.
    api_set_devmode(true)
    define_test_object()
    RESONANCE_PYLON.define()
    RESONANT_TRANSFER.DRAW_OBJECTS = {RESONANCE_PYLON} -- A list of all objects that need to do special drawing.
    return "Success"
end

--- Runs on every frame. FAIL FAST!
function draw()
    hover = api_get_highlighted("obj") -- What object are we highlighting?
    -- If we're hovering over an object, iterate through all objects in RESONANT_TRANSFER.DRAW_OBJECTS.
    if hover ~= nil then for _, obj in pairs(RESONANT_TRANSFER.DRAW_OBJECTS) do
        -- Does the object we're hovering over have an OID that matches that of the object we're considering?
        if api_gp(hover, "oid") == RESONANT_TRANSFER.ID .. "_" .. obj.id then
            cam = api_get_camera_position() -- Grab the camera position.
            obj.draw(
                    api_gp(hover, "x") - cam.x, -- The X and Y coordinates of
                    api_gp(hover, "y") - cam.y) -- the object in screen-space.
        end -- Otherwise, try the next one.
    end end -- No object or not one of ours? Do nothing.
end

--- Runs at 10hz. Again, FAIL FAST!
function tick()
    -- Iterate through all devices on the passive schedule.
    for _, dev in pairs(RESONANT_TRANSFER.TICK_SCHEDULE.PASSIVE) do
        dev.on_tick() -- Tick the device.
        -- If the device is due for an update, add it to the end of the active queue.
        if dev.ticks_until_update == 0 then table.insert(RESONANT_TRANSFER.TICK_SCHEDULE.ACTIVE, dev) end
    end
    -- Iterate through the top devices on the active schedule. Stop when you reach the maximum allowed updates per tick.
    for i=1, RESONANT_TRANSFER.TICK_SCHEDULE.MAX_UPDATES_PER_TICK do
        dev = RESONANT_TRANSFER.TICK_SCHEDULE.ACTIVE[i] -- Grab the current device.
        if dev ~= nil then dev.on_update() else break end -- If the current device isn't null, fire the update.
        -- Otherwise, break out of the loop.
    end
end