local parent = script:FindFirstAncestor("VoiceChat").Parent
local VoiceChatCore = require(parent.VoiceChatCore)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local CrossExperience = require(parent.CrossExperience)
local SharedFlags = require(parent.SharedFlags)

local default = VoiceChatCore.CoreVoiceManager.default
local default2 = CrossExperienceVoice.CrossExperienceVoiceManager.default
local AUDIO_FOCUS_MANAGEMENT = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT

local fFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice()
local fFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute()

local GlobalVoiceManager = {}
GlobalVoiceManager.__index = GlobalVoiceManager

function GlobalVoiceManager.new()
	local v = {}
	setmetatable(v, GlobalVoiceManager)
	return v
end

function GlobalVoiceManager:isPublicVoiceFocused(): boolean
	return not fFlagEnableCrossExpVoice or default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
end

function GlobalVoiceManager:isPrivateVoiceFocused()
	return fFlagEnableCrossExpVoice and default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
end

function GlobalVoiceManager:MuteAll(p: string?)
	if self:isPrivateVoiceFocused() and fFlagEnableCrossExperienceVoiceCaptureMute then
		default2:muteAll(p)
	end

	if self:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(true, p)
	end
end

function GlobalVoiceManager:UnmuteAll(p: string?)
	if self:isPrivateVoiceFocused() and fFlagEnableCrossExperienceVoiceCaptureMute then
		default2:unmuteAll(p)
	end

	if self:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(false, p)
	end
end

GlobalVoiceManager.default = GlobalVoiceManager.new()

return GlobalVoiceManager
