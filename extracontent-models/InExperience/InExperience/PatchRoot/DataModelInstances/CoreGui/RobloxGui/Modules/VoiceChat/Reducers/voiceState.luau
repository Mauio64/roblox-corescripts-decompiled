local CorePackages = game:GetService("CorePackages")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local FFlagEnableVoiceChatStorybookFix = require(RobloxGui.Modules.Flags.FFlagEnableVoiceChatStorybookFix)
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local u6 = if not FFlagEnableVoiceChatStorybookFix() then require(script.Parent.Parent.VoiceChatServiceManager).default.VOICE_STATE else require(CorePackages.Workspace.Packages.VoiceChat).Constants.VOICE_STATE
local ParticipantAdded = require(script.Parent.Parent.Actions.ParticipantAdded)
local ParticipantRemoved = require(script.Parent.Parent.Actions.ParticipantRemoved)
local VoiceStateChanged = require(script.Parent.Parent.Actions.VoiceStateChanged)
local VoiceEnabledChanged = require(script.Parent.Parent.Actions.VoiceEnabledChanged)
local ParticipantsChanged = require(script.Parent.Parent.Actions.ParticipantsChanged)

return (Rodux.createReducer({}, {
	[VoiceEnabledChanged.name] = function(p1, p2) -- line: 26
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			voiceEnabled = p2.enabled
		})
	end,
	[ParticipantAdded.name] = function(p3, p4) -- line: 32
		-- upvalues: u6 (ref), Cryo (copy)
		local userId = p4.userId
		local v17 = p3[userId] or u6.HIDDEN

		return Cryo.Dictionary.join(p3, {
			[userId] = v17
		})
	end,
	[ParticipantRemoved.name] = function(p5, p6) -- line: 42
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			[p6.userId] = Cryo.None
		})
	end,
	[ParticipantsChanged.name] = function(p7, p8) -- line: 49
		-- upvalues: u6 (ref)
		local newParticipants = p8.newParticipants
		local v23 = table.clone(p7)

		for v24, v25 in newParticipants do
			local INACTIVE = u6.INACTIVE

			if not v25.subscriptionCompleted then
				INACTIVE = u6.CONNECTING
			elseif v25.isMutedLocally then
				INACTIVE = u6.LOCAL_MUTED
			elseif v25.isMuted then
				INACTIVE = u6.MUTED
			elseif v25.isSignalActive then
				INACTIVE = u6.TALKING
			end

			v23[tostring(v24)] = INACTIVE
		end

		return v23
	end,
	[VoiceStateChanged.name] = function(p9, p10) -- line: 69
		-- upvalues: Cryo (copy)
		if p9[p10.userId] then
			return Cryo.Dictionary.join(p9, {
				[p10.userId] = p10.newState
			})
		end

		return p9
	end
}))
