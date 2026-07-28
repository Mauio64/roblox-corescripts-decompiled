local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)

require(MomentsCreation.Types.CreationFlowTypes)

local EventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "generateText",
	presentation = "InstantAction",
	cta = {
		localizationKey = "Feature.Moments.Action.GenerateText",
		order = 4,
		icon = BuilderIcons.Icon.TagSparkle,
		analyticsEvent = EventNames.EditingFlowGenerateTextButtonPressed
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	isAvailable = function(p1) -- line: 22
		return p1.canGenerateText == true
	end,
	apply = function(p2) -- line: 25
		p2.generateText()
	end
}
