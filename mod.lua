---
--- Author: Patrick Shannon
--- Digital Storage (working title) is a mod fashioned after Applied Energetics and similar mods for Minecraft.
--- It allows for automatic import, export, and digital storage of items and fluids. It also adds a single access point
--- for all items and fluids stored. It will NOT add any sort of wireless item or fluid access.
---
--- Features:
---   Access Consoles: Allow items and fluids to be withdrawn and deposited to digital storage.
---   Interface Tiles: floor tiles that act on any machine that falls within their bounding box.
---     Import Tile: imports items and fluids from attached machines to digital storage.
---     Export Tile: exports items and fluids from digital storage to attached machines.
---     Storage Tile: allows items and fluids in attached machine to be viewed and accessed by consoles.
---     Connection Tiles: extends the network of tiles.
---   Machine Interface Markers: Items that
---

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
    api_log("Attempting to init DS.")
    api_set_devmode(true)
    return Success
end