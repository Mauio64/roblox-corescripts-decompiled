local FFlagAXMigrateOutfitsToUserInventory = require(script.Parent.FFlagAXMigrateOutfitsToUserInventory)
local EngineFeature = game:GetEngineFeature("MakeupOutfits")

return game:DefineFastFlag("AXOutfitPageRevamp2", false) and (FFlagAXMigrateOutfitsToUserInventory and EngineFeature)
