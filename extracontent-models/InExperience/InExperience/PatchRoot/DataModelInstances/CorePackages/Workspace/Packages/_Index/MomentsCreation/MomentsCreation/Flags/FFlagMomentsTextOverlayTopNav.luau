local parent = script:FindFirstAncestor("MomentsCreation").Parent

local MomentsCommon = require(parent.MomentsCommon)

return game:DefineFastFlag("MomentsTextOverlayTopNav", false) and MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
