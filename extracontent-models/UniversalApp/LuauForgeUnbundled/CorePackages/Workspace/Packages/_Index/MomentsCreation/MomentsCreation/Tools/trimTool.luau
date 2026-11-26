local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local TrimmingView = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TrimmingView")

local eventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "trim",
	presentation = "Step",
	step = CreationFlowState.Trimming,
	zIndex = 1,
	cta = {
		icon = BuilderIcons.Icon.ThreeBarsVerticalTrianglesHorizontal,
		localizationKey = "Feature.Moments.Action.TrimVideo",
		analyticsEvent = eventNames.EditingFlowTrimButtonPressed,
		commitAnalyticsEvent = eventNames.EditingFlowTrimDoneButtonPressed,
		cancelAnalyticsEvent = eventNames.EditingFlowTrimBackButtonPressed,
		order = 1
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function()
		return createEditSession()
	end,
	renderEditor = function(p2)
		return React.createElement(TrimmingView, { controller = p2, layoutOrder = 2 })
	end,
	toEdits = function(p2)
		return { trim = p2 }
	end
}
