local FFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXMigrateOutfitsToUserInventory")

local engineFeature = game:GetEngineFeature("MakeupOutfits")

return game:DefineFastFlag("AXOutfitPageRevamp3", false) and FFlagAXMigrateOutfitsToUserInventory and engineFeature
