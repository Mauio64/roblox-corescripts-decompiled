local FFlagAXMigrateOutfitsToUserInventory = require(script.Parent.FFlagAXMigrateOutfitsToUserInventory)

local engineFeature = game:GetEngineFeature("MakeupOutfits")

return game:DefineFastFlag("AXOutfitPageRevamp3", false) and FFlagAXMigrateOutfitsToUserInventory and engineFeature
