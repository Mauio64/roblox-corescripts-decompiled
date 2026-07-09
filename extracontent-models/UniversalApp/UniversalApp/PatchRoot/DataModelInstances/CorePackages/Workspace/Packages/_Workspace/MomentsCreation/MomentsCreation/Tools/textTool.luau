local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)

local createEditSession = require(MomentsCreation.Stores.createEditSession)
local TextOverlayControls = require(MomentsCreation.Components.TextOverlay.TextOverlayControls)
local TextOverlayLayer = require(MomentsCreation.Components.TextOverlay.TextOverlayLayer)
local EventNames = MomentsCommon.Analytics.EventNames

return {
	kind = "text",
	presentation = "Step",
	zIndex = 3,
	step = CreationFlowState.TextOverlay,
	cta = {
		localizationKey = "Feature.Moments.Action.AddText",
		order = 3,
		icon = BuilderIcons.Icon.TextUppercaseALowercaseA,
		analyticsEvent = EventNames.EditingFlowTextOverlayButtonPressed,
		commitAnalyticsEvent = EventNames.EditingFlowTextOverlayDoneButtonPressed,
		cancelAnalyticsEvent = EventNames.EditingFlowTextOverlayBackButtonPressed
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function() -- line: 40
		-- upvalues: createEditSession (copy)
		return createEditSession()
	end,
	renderEditor = function(p1) -- line: 43
		-- upvalues: React (copy), TextOverlayControls (copy)
		return React.createElement(TextOverlayControls, {
			layoutOrder = 2,
			controller = p1
		})
	end,
	renderPreviewLayer = function(p2, p3) -- line: 48
		-- upvalues: React (copy), TextOverlayLayer (copy)
		return React.createElement(TextOverlayLayer, {
			zIndex = 3,
			controller = p2,
			ctx = p3
		})
	end,
	toEdits = function(p4) -- line: 51
		local v15 = p4 and p4[1]

		if v15 == nil or v15.text == "" then
			return {}
		end

		return {
			textOverlays = p4
		}
	end
}
