local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
require(MomentsCreation.Types.CreationFlowTypes)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local TrimmingView = require(MomentsCreation.Components.TrimmingView)

local EventNames = MomentsCommon.Analytics.EventNames
local TrimTool = {}
TrimTool.kind = "trim"
TrimTool.presentation = "Step"
TrimTool.step = CreationFlowState.Trimming
TrimTool.zIndex = 1
TrimTool.cta = {
	icon = BuilderIcons.Icon.ThreeBarsVerticalTrianglesHorizontal,
	localizationKey = "Feature.Moments.Action.TrimVideo",
	analyticsEvent = EventNames.EditingFlowTrimButtonPressed,
	commitAnalyticsEvent = EventNames.EditingFlowTrimDoneButtonPressed,
	cancelAnalyticsEvent = EventNames.EditingFlowTrimBackButtonPressed,
	order = 1
}

TrimTool.supportedCaptureTypes = { Enum.CaptureType.Video }
function TrimTool.createSession()
	return createEditSession()
end

function TrimTool.renderEditor(controller)
	return React.createElement(TrimmingView, { controller = controller, layoutOrder = 2 })
end

function TrimTool.toEdits(trim)
	return { trim = trim }
end

return TrimTool
