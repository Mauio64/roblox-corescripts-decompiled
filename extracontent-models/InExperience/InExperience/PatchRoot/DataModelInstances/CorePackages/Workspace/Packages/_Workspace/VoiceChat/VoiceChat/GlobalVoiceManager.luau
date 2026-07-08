local Parent = script:FindFirstAncestor("VoiceChat").Parent
local VoiceChatCore = require(Parent.VoiceChatCore)
local CrossExperienceVoice = require(Parent.CrossExperienceVoice)
local CrossExperience = require(Parent.CrossExperience)
local SharedFlags = require(Parent.SharedFlags)
local default = VoiceChatCore.CoreVoiceManager.default
local default2 = CrossExperienceVoice.CrossExperienceVoiceManager.default
local AUDIO_FOCUS_MANAGEMENT = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT
local v9 = SharedFlags.GetFFlagEnableCrossExpVoice()
local v10 = SharedFlags.GetFFlagEnableCrossExperienceVoiceCaptureMute()
local t1 = {}

t1.__index = t1

function t1.new() -- line: 38
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)

	return t2
end
function t1.isPublicVoiceFocused(_) -- line: 44
	-- upvalues: v9 (copy), default2 (copy), AUDIO_FOCUS_MANAGEMENT (copy)
	return not v9 or default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.UGC.CONTEXT_ID
end
function t1.isPrivateVoiceFocused(_) -- line: 49
	-- upvalues: v9 (copy), default2 (copy), AUDIO_FOCUS_MANAGEMENT (copy)
	return v9 and default2:getCurrentAudioContext() == AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
end
function t1.MuteAll(t3: {[any]: any}, s1: string?) -- line: 54
	-- upvalues: v10 (copy), default2 (copy), default (copy)
	if t3:isPrivateVoiceFocused() and v10 then
		default2:muteAll(s1)
	end

	if t3:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(true, s1)
	end
end
function t1.UnmuteAll(t4: {[any]: any}, s2: string?) -- line: 64
	-- upvalues: v10 (copy), default2 (copy), default (copy)
	if t4:isPrivateVoiceFocused() and v10 then
		default2:unmuteAll(s2)
	end

	if t4:isPublicVoiceFocused() and default:UserVoiceEnabled() and default:IsInitialized() then
		default:MuteAll(false, s2)
	end
end

t1.default = t1.new()

return t1
