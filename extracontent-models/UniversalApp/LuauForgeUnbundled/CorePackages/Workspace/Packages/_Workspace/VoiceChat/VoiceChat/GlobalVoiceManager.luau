local VoiceChatCore = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/VoiceChatCore")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/CrossExperienceVoice")
local CrossExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/CrossExperience")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChat/SharedFlags")

local default = VoiceChatCore.CoreVoiceManager.default
local default2 = CrossExperienceVoice.CrossExperienceVoiceManager.default
local AUDIO_FOCUS_MANAGEMENT = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT

local fFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice()
local fFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute()

local class = {}
class.__index = class

function class.new()
	local v5 = {}
	setmetatable(v5, class)
	return v5
end

function class:isPublicVoiceFocused(): boolean
	return not fFlagEnableCrossExpVoice
		or default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
end

function class:isPrivateVoiceFocused()
	return fFlagEnableCrossExpVoice
		and default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
end

function class:MuteAll(p2)
	if self:isPrivateVoiceFocused() and fFlagEnableCrossExperienceVoiceCaptureMute then
		default2:muteAll(p2)
	end

	if self:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(true, p2)
	end
end

function class:UnmuteAll(p2)
	if self:isPrivateVoiceFocused() and fFlagEnableCrossExperienceVoiceCaptureMute then
		default2:unmuteAll(p2)
	end

	if self:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(false, p2)
	end
end

class.default = class.new()

return class
