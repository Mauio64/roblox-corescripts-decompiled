local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)

local createEditSession = require(MomentsCreation.Stores.createEditSession)
local TrimmingView = require(MomentsCreation.Components.TrimmingView)
local EventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "trim",
	presentation = "Step",
	zIndex = 1,
	step = CreationFlowState.Trimming,
	cta = {
		localizationKey = "Feature.Moments.Action.TrimVideo",
		order = 1,
		icon = BuilderIcons.Icon.ThreeBarsVerticalTrianglesHorizontal,
		analyticsEvent = EventNames.EditingFlowTrimButtonPressed,
		commitAnalyticsEvent = EventNames.EditingFlowTrimDoneButtonPressed,
		cancelAnalyticsEvent = EventNames.EditingFlowTrimBackButtonPressed
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function() -- line: 39
		-- upvalues: createEditSession (copy)
		return createEditSession()
	end,
	renderEditor = function(p1) -- line: 42
		-- upvalues: React (copy), TrimmingView (copy)
		return React.createElement(TrimmingView, {
			layoutOrder = 2,
			controller = p1
		})
	end,
	toEdits = function(p2) -- line: 49
		return {
			trim = p2
		}
	end
}
