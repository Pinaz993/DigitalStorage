--- A device that has some sort of task that needs to be carried out during tick(), and possibly one that needs to
--- be carried out every few ticks. Both default behaviors can be overridden or left.

Tickable_Device = {}
Tickable_Device.TICK_DELAY = 5

-- Default ticking behavior
function Tickable_Device:on_tick()
    self.ticks_until_update = self.ticks_until_update - 1 -- Decrement the timer.
end

-- Default update behavior
function Tickable_Device:on_update()
    self.ticks_until_update = self.TICK_DELAY -- Reset the time.
end

-- Add a device to the schedule. DO NOT APPLY TO OBJECT TEMPLATES! ONLY TO OBJECT INSTANCES!
function Tickable_Device.schedule(device)
    table.insert(RESONANT_TRANSFER.TICK_SCHEDULE.PASSIVE_QUEUE, device)
end

-- Cause an object instance to inherit tickable behavior. This is a form of multiple inheritance. No metatable shenanigans here!
function Tickable_Device:inherit(ticks_until_update, TICK_DELAY)
    self.ticks_until_update = ticks_until_update or 1 -- Implement var and schedule next update (next tick by default).
    self.TICK_DELAY = TICK_DELAY or Tickable_Device.TICK_DELAY -- Set TICK_DELAY or inherit default tick delay (5).
    self["on_tick"] = Tickable_Device["on_tick"] -- Inherit default tick behavior.
    self["on_update"] = Tickable_Device["on_update"] -- Inherit default update behavior (so it isn't nil).
end