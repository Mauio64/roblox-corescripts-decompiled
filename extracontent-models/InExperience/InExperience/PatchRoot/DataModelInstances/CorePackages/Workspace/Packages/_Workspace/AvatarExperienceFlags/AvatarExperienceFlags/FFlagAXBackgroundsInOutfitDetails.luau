local FFlagAXBackgroundsRoot = require(script.Parent.FFlagAXBackgroundsRoot)
local FFlagAXBackgroundsOutfitPersistence = require(script.Parent.FFlagAXBackgroundsOutfitPersistence)

local defineFastFlag = game:DefineFastFlag("AXBackgroundsInOutfitDetails", false)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundsOutfitPersistence and defineFastFlag
