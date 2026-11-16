local FFlagAXOutfitPageRevamp = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXOutfitPageRevamp")

local engineFeature = game:GetEngineFeature("AvatarEditorServiceV4CreateOutfitType")

return game:DefineFastFlag("AXEnableMakeupOutfitCreation", false) and FFlagAXOutfitPageRevamp and engineFeature
