local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local EventNames = MomentsCommon.Analytics.EventNames

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
require(MomentsCreation.Types.CreationFlowTypes)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local VoiceEditor = require(MomentsCreation.Components.Voice.VoiceEditor)
local VoicePreviewLayer = require(MomentsCreation.Components.Voice.VoicePreviewLayer)
local VoiceTool = {}
VoiceTool.kind = "voice"
VoiceTool.presentation = "Step"
VoiceTool.step = CreationFlowState.Voice
VoiceTool.zIndex = 4
VoiceTool.cta = {
	icon = BuilderIcons.Icon.FiveVerticalLinesWave,
	localizationKey = "Feature.Moments.Action.AddVoice",
	order = 4,
	analyticsEvent = EventNames.EditingFlowVoiceButtonPressed,
	commitAnalyticsEvent = EventNames.EditingFlowVoiceDoneButtonPressed,
	cancelAnalyticsEvent = EventNames.EditingFlowVoiceDeleteChangePressed,
	commitRequiresEdit = true
}

VoiceTool.supportedCaptureTypes = { Enum.CaptureType.Video }
function VoiceTool.createSession()
	return createEditSession()
end

function VoiceTool.renderEditor(controller)
	return React.createElement(VoiceEditor, { controller = controller, layoutOrder = 2 })
end

function VoiceTool.renderPreviewLayer(controller, ctx)
	return React.createElement(VoicePreviewLayer, { controller = controller, ctx = ctx, zIndex = 4 })
end

function VoiceTool.toEdits(tts)
	if tts == nil or tts.text == "" then
		return {}
	end

	return { tts = tts }
end

return VoiceTool
