local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent

local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
local InterventionShared = require(parent.InterventionShared)
local Constants = InterventionShared.Utils.Constants
local InterventionShared2 = require(parent.InterventionShared)
local voiceInterventionReceivedSignal = InterventionShared2.Signals.voiceInterventionReceivedSignal

local showFeatureRestrictionFromRealtime = require(parent.UniversalFeatureRestrictions.showFeatureRestrictionFromRealtime)

require(InExperienceIntervention.Utils.Types)

local function isVoiceRestriction(p): boolean
	return p.abuseVector == Constants.AbuseVectorType.Voice
		and (p.type == Constants.NotificationDialogType.ChatNudge or p.type == Constants.NotificationDialogType.ChatTimeout)
end

local function onVoiceRestrictionAppeal() end

local VoiceInterventionConfig = {}
VoiceInterventionConfig.configName = "VoiceIntervention"
VoiceInterventionConfig.shouldTriggerVisualTreatment = isVoiceRestriction
VoiceInterventionConfig.shouldTriggerBehavioralTreatment = isVoiceRestriction

function VoiceInterventionConfig.shouldTriggerEventReceived(_): boolean
	return false
end

function VoiceInterventionConfig.onTriggerVisualTreatment(_, p)
	showFeatureRestrictionFromRealtime(AbuseVector.Voice, p, { onAppeal = onVoiceRestrictionAppeal })
end

function VoiceInterventionConfig.onTriggerBehavioralTreatment(p)
	voiceInterventionReceivedSignal:fire(p)
end
function VoiceInterventionConfig.onTriggerEventReceived(_) end

return VoiceInterventionConfig
