local parent = script.Parent.Parent
local parent2 = parent.Parent

local VoiceChatCore = require(parent2.VoiceChatCore)
local default = VoiceChatCore.CoreVoiceManager.default
local VoiceChat = require(parent2.VoiceChat)
local default2 = VoiceChat.GlobalVoiceManager.default

local EventNames = require(parent.Analytics.EventNames)
local VideoCaptureStarted = require(parent.Actions.VideoCaptureStarted)
local VideoCaptureStopped = require(parent.Actions.VideoCaptureStopped)
require(parent.Types)

local CaptureTriggerType = require(parent.Enums.CaptureTriggerType)
local Constants = require(parent.Constants)

local SharedFlags = require(parent2.SharedFlags)
local GetFFlagEnableVoiceChatMuteForVideoCaptures = SharedFlags.GetFFlagEnableVoiceChatMuteForVideoCaptures

local SharedFlags2 = require(parent2.SharedFlags)
local GetFFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags2.GetFFlagEnableCrossExperienceVoiceCaptureMute

local function maybeMuteVoiceChat(flag: boolean)
	if game:GetEngineFeature("ReenableMomentsVoice") then
		return
	end

	if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		if flag then
			default2:MuteAll("Capture")
		else
			default2:UnmuteAll("Capture")
		end
	end

	if default:UserVoiceEnabled() and default:IsInitialized() then
		if not GetFFlagEnableCrossExperienceVoiceCaptureMute() then
			default:MuteAll(flag, "Capture")
		end

		if GetFFlagEnableVoiceChatMuteForVideoCaptures then
			if flag then
				default:RequestHidePublicVoiceUI()
			else
				default:RequestShowPublicVoiceUI()
			end
		end
	end
end

local function makeVideoCaptureInProgressHandler(object, _, callback)
	local function videoCaptureInProgressHandler(flag: boolean, triggerType)
		local status = object:getState()[Constants.RoduxKey].IsVideoCaptureActive.status

		if flag and not status then
			object:dispatch(VideoCaptureStarted(triggerType))

			if triggerType == CaptureTriggerType.UserCapture or triggerType == CaptureTriggerType.DeveloperCapture then
				maybeMuteVoiceChat(true)
			end

			if triggerType == CaptureTriggerType.DeveloperCapture then
				callback(EventNames.CapturesVideoCaptureDevApiStarted)
			end

			callback(EventNames.CapturesVideoCaptureStarted, { triggerType = triggerType })
		elseif not flag and status then
			object:dispatch(VideoCaptureStopped(triggerType))

			if triggerType == CaptureTriggerType.UserCapture or triggerType == CaptureTriggerType.DeveloperCapture then
				maybeMuteVoiceChat(false)
			end

			if triggerType == CaptureTriggerType.DeveloperCapture then
				callback(EventNames.CapturesVideoCaptureDevApiEnded)
			end

			callback(EventNames.CapturesVideoCaptureStopped, { triggerType = triggerType })
		end
	end

	return videoCaptureInProgressHandler
end

return makeVideoCaptureInProgressHandler
