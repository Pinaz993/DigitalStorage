--- A global object for managing the transfer of items and fluids from dispatching machines to receiving machines.
--- There are a total of 128 frequencies, and each one can have any number of devices assigned to it. This object stores
--- a table of all currently used frequencies, indexed by a 7 bit binary number held in a string. Each frequency has two
--- tables: one of fluid receivers, and one of item receivers. All such tables are an ordered list, indexed at 1.
--- This object will not be serialized at the end of a play session. Instead, devices that make use of frequencies
--- Will be iterated over upon game load and add themselves to a new frequency manager.
---
--- When a device attempts to dispatch items or fluids, this object will attempt the following process:
---     list = (the list of eligible devices)
---     local device = list.remove(1) -- Remove the first element on the list
---     local first = device -- Preserve a reference to this first element
---     while (not device.can_accept()) do -- Check to see if the device can accept what is being dispatched. If not, loop.
---         list.add(device) -- Add the device onto the end of the list
---         device = list.remove(1) -- Remove the first entry from the list
---         if device == first then return "Fail" end -- We've come full circle and none can accept the item/fluids. Stop trying.
---     end
---     device.receive(the items/fluids being dispatched)
---     return "Success"
---
--TODO: Implement item transfer function
--TODO: Implement fluid transfer function.

FREQUENCY_MANAGER = {} -- An object that stores all active frequencies.
setmetatable(FREQUENCY_MANAGER, FREQUENCY_MANAGER) -- FREQUENCY_MANAGER acts as its own metatable.

FREQUENCY_MANAGER.proto = {} -- A prototypical frequency entry for FREQUENCY_MANAGER.
FREQUENCY_MANAGER.proto.item_receivers = nil -- A number indexed ordered list to store all devices that can receive items.
FREQUENCY_MANAGER.proto.fluid_receivers = nil -- Ditto, but for fluids

function FREQUENCY_MANAGER.proto:transmit_items() -- A function for transmitting items to the first possible receiver.
    --TODO: Implement FREQUENCY_MANAGER.proto.transmit_items()
    --TODO: Decide on method signature for transmit_items() and transmit_fluids()
end

function FREQUENCY_MANAGER.proto:transmit_fluids() -- Again, ditto, but for fluids.
    --TODO: Implement FREQUENCY_MANAGER.proto.transmit_fluids()
end

function FREQUENCY_MANAGER:__index(_, k) -- If someone tries to access an entry that doesn't exist:
    rtn = {} -- A new frequency entry we'll add to FREQUENCY_MANAGER and return at the end.
    -- If you can't find anything in the object itself, look in the prototypical frequency entry.
    getmetatable(rtn).__index = FREQUENCY_MANAGER.proto -- These represent class members and functions.
    -- Deal with instance members.
    rtn.item_receivers = {} --Instantiate an empty list for all item receivers on this frequency.
    rtn.fluid_receivers = {} -- Same for fluids.
    rtn.freq = k -- Store the frequency string in case we need it.
    self[k] = rtn -- Add the new entry to this manager.
    return rtn -- Return the new entry.
end
