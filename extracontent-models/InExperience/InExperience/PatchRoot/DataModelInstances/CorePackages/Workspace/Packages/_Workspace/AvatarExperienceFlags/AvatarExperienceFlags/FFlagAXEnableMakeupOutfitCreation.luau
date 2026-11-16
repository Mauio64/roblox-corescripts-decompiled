local FFlagAXOutfitPageRevamp = require(script.Parent.FFlagAXOutfitPageRevamp)

local engineFeature = game:GetEngineFeature("AvatarEditorServiceV4CreateOutfitType")

return game:DefineFastFlag("AXEnableMakeupOutfitCreation", false) and FFlagAXOutfitPageRevamp and engineFeature
