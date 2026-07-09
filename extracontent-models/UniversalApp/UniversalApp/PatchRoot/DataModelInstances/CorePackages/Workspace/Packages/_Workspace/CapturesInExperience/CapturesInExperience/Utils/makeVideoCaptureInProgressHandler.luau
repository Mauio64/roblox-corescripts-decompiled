local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local default = require(ParentParentParent.VoiceChatCore).CoreVoiceManager.default
local default2 = require(ParentParentParent.VoiceChat).GlobalVoiceManager.default
local EventNames = require(ParentParent.Analytics.EventNames)
local VideoCaptureStarted = require(ParentParent.Actions.VideoCaptureStarted)
local VideoCaptureStopped = require(ParentParent.Actions.VideoCaptureStopped)

require(ParentParent.Types)

local CaptureTriggerType = require(ParentParent.Enums.CaptureTriggerType)
local Constants = require(ParentParent.Constants)
local GetFFlagEnableVoiceChatMuteForVideoCaptures = require(ParentParentParent.SharedFlags).GetFFlagEnableVoiceChatMuteForVideoCaptures
local GetFFlagEnableCrossExperienceVoiceCaptureMute = require(ParentParentParent.SharedFlags).GetFFlagEnableCrossExperienceVoiceCaptureMute

local function maybeMuteVoiceChat(b1: boolean) -- line: 22
	-- upvalues: GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), default2 (copy), default (copy), GetFFlagEnableVoiceChatMuteForVideoCaptures (copy)
	if game:GetEngineFeature("ReenableMomentsVoice") then
		return
	end

	if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		if b1 then
			default2:MuteAll("Capture")
		else
			default2:UnmuteAll("Capture")
		end
	end

	if default:UserVoiceEnabled() and default:IsInitialized() then
		if not GetFFlagEnableCrossExperienceVoiceCaptureMute() then
			default:MuteAll(b1, "Capture")
		end

		if GetFFlagEnableVoiceChatMuteForVideoCaptures then
			if b1 then
				default:RequestHidePublicVoiceUI()

				return
			end

			default:RequestShowPublicVoiceUI()
		end
	end
end
local function makeVideoCaptureInProgressHandler(p1, _, p3: ((...any) -> ...any)) -- line: 47
	-- upvalues: Constants (copy), VideoCaptureStarted (copy), CaptureTriggerType (copy), maybeMuteVoiceChat (copy), EventNames (copy), VideoCaptureStopped (copy)
	local function videoCaptureInProgressHandler(b2: boolean, p4) -- line: 52
		-- upvalues: p1 (copy), Constants (copy), VideoCaptureStarted (copy), CaptureTriggerType (copy), maybeMuteVoiceChat (copy), p3 (copy), EventNames (copy), VideoCaptureStopped (copy)
		local status = p1:getState()[Constants.RoduxKey].IsVideoCaptureActive.status

		if b2 and not status then
			p1:dispatch(VideoCaptureStarted(p4))

			if p4 == CaptureTriggerType.UserCapture or p4 == CaptureTriggerType.DeveloperCapture then
				maybeMuteVoiceChat(true)
			end

			if p4 == CaptureTriggerType.DeveloperCapture then
				p3(EventNames.CapturesVideoCaptureDevApiStarted)
			end

			p3(EventNames.CapturesVideoCaptureStarted, {
				triggerType = p4
			})

			return
		end

		if not b2 and status then
			p1:dispatch(VideoCaptureStopped(p4))

			if p4 == CaptureTriggerType.UserCapture or p4 == CaptureTriggerType.DeveloperCapture then
				maybeMuteVoiceChat(false)
			end

			if p4 == CaptureTriggerType.DeveloperCapture then
				p3(EventNames.CapturesVideoCaptureDevApiEnded)
			end

			p3(EventNames.CapturesVideoCaptureStopped, {
				triggerType = p4
			})
		end
	end

	return videoCaptureInProgressHandler
end

return makeVideoCaptureInProgressHandler
