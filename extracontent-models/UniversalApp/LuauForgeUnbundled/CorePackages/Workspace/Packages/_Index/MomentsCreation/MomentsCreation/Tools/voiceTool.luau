local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local eventNames = MomentsCommon.Analytics.EventNames

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local VoiceEditor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoiceEditor")
local VoicePreviewLayer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoicePreviewLayer")

return {
	kind = "voice",
	presentation = "Step",
	step = CreationFlowState.Voice,
	zIndex = 4,
	cta = {
		icon = BuilderIcons.Icon.FiveVerticalLinesWave,
		localizationKey = "Feature.Moments.Action.AddVoice",
		order = 4,
		analyticsEvent = eventNames.EditingFlowVoiceButtonPressed,
		commitAnalyticsEvent = eventNames.EditingFlowVoiceDoneButtonPressed,
		cancelAnalyticsEvent = eventNames.EditingFlowVoiceDeleteChangePressed,
		commitRequiresEdit = true
	},
	supportedCaptureTypes = { Enum.CaptureType.Video },
	createSession = function()
		return createEditSession()
	end,
	renderEditor = function(p2)
		return React.createElement(VoiceEditor, { controller = p2, layoutOrder = 2 })
	end,
	renderPreviewLayer = function(p2, p3)
		return React.createElement(VoicePreviewLayer, { controller = p2, ctx = p3, zIndex = 4 })
	end,
	toEdits = function(p2)
		if p2 == nil or p2.text == "" then
			return {}
		end

		return { tts = p2 }
	end
}
