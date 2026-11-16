local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local FFlagEnableVoiceChatStorybookFix = require(RobloxGui.Modules.Flags.FFlagEnableVoiceChatStorybookFix)

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local VOICE_STATE

if FFlagEnableVoiceChatStorybookFix() then
	local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
	VOICE_STATE = VoiceChat.Constants.VOICE_STATE
else
	local VoiceChatServiceManager = require(script.Parent.Parent.VoiceChatServiceManager)
	VOICE_STATE = VoiceChatServiceManager.default.VOICE_STATE
end

local ParticipantAdded = require(script.Parent.Parent.Actions.ParticipantAdded)
local ParticipantRemoved = require(script.Parent.Parent.Actions.ParticipantRemoved)
local VoiceStateChanged = require(script.Parent.Parent.Actions.VoiceStateChanged)
local VoiceEnabledChanged = require(script.Parent.Parent.Actions.VoiceEnabledChanged)
local ParticipantsChanged = require(script.Parent.Parent.Actions.ParticipantsChanged)

return (Rodux.createReducer({}, {
	[VoiceEnabledChanged.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { voiceEnabled = p2.enabled })
	end,
	[ParticipantAdded.name] = function(p, p2)
		local userId = p2.userId
		local v = p[userId] or VOICE_STATE.HIDDEN

		return Cryo.Dictionary.join(p, { [userId] = v })
	end,
	[ParticipantRemoved.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { [p2.userId] = Cryo.None })
	end,
	[ParticipantsChanged.name] = function(p, p2)
		local newParticipants = p2.newParticipants
		local clone = table.clone(p)

		for k, newParticipant in newParticipants do
			local v = VOICE_STATE.INACTIVE

			if newParticipant.subscriptionCompleted then
				if newParticipant.isMutedLocally then
					v = VOICE_STATE.LOCAL_MUTED
				elseif newParticipant.isMuted then
					v = VOICE_STATE.MUTED
				elseif newParticipant.isSignalActive then
					v = VOICE_STATE.TALKING
				end
			else
				v = VOICE_STATE.CONNECTING
			end

			clone[tostring(k)] = v
		end

		return clone
	end,
	[VoiceStateChanged.name] = function(p, p2)
		if not p[p2.userId] then
			return p
		end

		return Cryo.Dictionary.join(p, { [p2.userId] = p2.newState })
	end
}))
