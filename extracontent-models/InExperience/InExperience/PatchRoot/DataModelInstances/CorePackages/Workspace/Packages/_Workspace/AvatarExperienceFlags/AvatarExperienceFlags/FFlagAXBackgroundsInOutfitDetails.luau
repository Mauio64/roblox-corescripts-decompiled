local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundsOutfitPersistence = require(script.Parent.FFlagAXBackgroundsOutfitPersistence)
local v3 = game:DefineFastFlag("AXBackgroundsInOutfitDetails", false)

return FFlagAXBackgroundsRoot and (FFlagAXBackgroundsOutfitPersistence and v3)
