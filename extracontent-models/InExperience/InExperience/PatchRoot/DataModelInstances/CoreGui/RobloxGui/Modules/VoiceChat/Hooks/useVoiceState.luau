local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local blockedStatusChangedEvent = BlockingUtility:GetBlockedStatusChangedEvent()
local VoiceChatServiceManager = require(script.Parent.Parent.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local VOICE_STATE = VoiceChat.Constants.VOICE_STATE

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local userId = LocalPlayer and LocalPlayer.UserId or 0

local v = not game:GetEngineFeature("VoiceChatSupported") and {
	Idle = 1,
	Joining = 2,
	JoiningRetry = 3,
	Joined = 4,
	Leaving = 5,
	Ended = 6,
	Failed = 7
} or Enum.VoiceChatState

local v2 = {
	[v.Idle] = VOICE_STATE.HIDDEN,
	[v.Joining] = VOICE_STATE.CONNECTING,
	[v.JoiningRetry] = VOICE_STATE.CONNECTING,
	[v.Joined] = VOICE_STATE.MUTED,
	[v.Leaving] = VOICE_STATE.MUTED,
	[v.Ended] = VOICE_STATE.HIDDEN,
	[v.Failed] = VOICE_STATE.ERROR
}

local function mapVoiceChatStateToVoiceState(p) -- 1 equivalent call inferred from this helper
	if v2[p] then
		return v2[p]
	end

	return VOICE_STATE.MUTED
end

local function mapParticipantStateToVoiceState(data) -- 2 equivalent calls inferred from this helper
	local inactive = VOICE_STATE.INACTIVE

	if data.subscriptionFailed then
		return VOICE_STATE.ERROR
	end

	if not data.subscriptionCompleted then
		return VOICE_STATE.CONNECTING
	end

	if data.isMutedLocally then
		return VOICE_STATE.LOCAL_MUTED
	end

	if data.isMuted then
		return VOICE_STATE.MUTED
	end

	return if data.isSignalActive then VOICE_STATE.TALKING else inactive
end

local function useVoiceState(p, flag: boolean?, p2)
	local voiceChatServiceManager = p2 and p2.voiceChatServiceManager or default
	local v3 = React.useContext(VoiceStateContext.Context)
	local state, setState = React.useState(VOICE_STATE.HIDDEN)

	React.useEffect(function()
		if not v3.voiceEnabled or not p or flag then
			setState(VOICE_STATE.HIDDEN)
			return function() end
		end

		local v4 = tonumber(p)
		local v5 = tostring(p)
		local v6 = userId == v4
		local v7 = nil
		local connections = {}
		local flag2 = false

		local function updateVoiceState(p3) -- 10 equivalent calls inferred from this helper
			if not flag2 then
				setState(p3)
			end
		end

		local function setVoiceEnabled(voiceState)
			local v8 = state

			if v6 then
				v8 = mapVoiceChatStateToVoiceState(voiceState) -- inferred equivalent call
			else
				local participant = voiceChatServiceManager.participants[v5]

				if participant and not v7 then
					v8 = VOICE_STATE.INACTIVE

					if participant.subscriptionFailed then
						v8 = VOICE_STATE.ERROR
					elseif participant.subscriptionCompleted then
						if participant.isMutedLocally then
							v8 = VOICE_STATE.LOCAL_MUTED
						elseif participant.isMuted then
							v8 = VOICE_STATE.MUTED
						elseif participant.isSignalActive then
							v8 = VOICE_STATE.TALKING
						end
					else
						v8 = VOICE_STATE.CONNECTING
					end
				end
			end

			if voiceState == v.Failed then
				if not v6 then
					v8 = VOICE_STATE.HIDDEN
				end
			elseif voiceState == v.Joined and not voiceChatServiceManager.localMuted and v6 then
				if voiceChatServiceManager.isTalking then
					v8 = VOICE_STATE.TALKING
				elseif voiceChatServiceManager.localMuted then
					v8 = VOICE_STATE.MUTED
				else
					v8 = VOICE_STATE.INACTIVE
				end
			end

			updateVoiceState(v8) -- inferred equivalent call
		end

		setVoiceEnabled(v3.voiceState)

		delay(0, function()
			if flag2 then
				return
			end

			setVoiceEnabled(v3.voiceState)

			if v6 then
				table.insert(connections, voiceChatServiceManager.talkingChanged.Event:Connect(function(p3)
					local v8

					if p3 then
						v8 = VOICE_STATE.TALKING
					else
						v8 = VOICE_STATE.INACTIVE
					end

					updateVoiceState(v8) -- inferred equivalent call
				end))

				table.insert(connections, voiceChatServiceManager.muteChanged.Event:Connect(function(p3)
					local v8

					if p3 then
						v8 = VOICE_STATE.MUTED
					else
						v8 = VOICE_STATE.INACTIVE
					end

					updateVoiceState(v8) -- inferred equivalent call
				end))
			else
				table.insert(connections, voiceChatServiceManager.participantsUpdate.Event:Connect(function(p3)
					local v8 = p3[v5]

					if v8 and not v7 then
						updateVoiceState(mapParticipantStateToVoiceState(v8)) -- inferred equivalent call
					else
						updateVoiceState(VOICE_STATE.HIDDEN) -- inferred equivalent call
					end
				end))

				table.insert(connections, voiceChatServiceManager.participantLeft.Event:Connect(function(_, p3)
					if p3 == v4 then
						updateVoiceState(VOICE_STATE.HIDDEN) -- inferred equivalent call
					end
				end))

				table.insert(connections, voiceChatServiceManager.participantJoined.Event:Connect(function(_, p3)
					if p3 == v4 then
						updateVoiceState(VOICE_STATE.HIDDEN) -- inferred equivalent call
					end
				end))

				table.insert(connections, blockedStatusChangedEvent:Connect(function(p3, p4)
					if v4 == p3 then
						if p4 then
							v7 = true
							updateVoiceState(VOICE_STATE.HIDDEN) -- inferred equivalent call
						else
							v7 = nil
							local participant = voiceChatServiceManager.participants[v5]

							if participant then
								updateVoiceState(mapParticipantStateToVoiceState(participant)) -- inferred equivalent call
							else
								updateVoiceState(VOICE_STATE.HIDDEN) -- inferred equivalent call
							end
						end
					end
				end))
			end
		end)

		return function()
			flag2 = true

			delay(0, function()
				for _, connection in connections do
					connection:disconnect()
				end
			end)
		end
	end, { p, v3.voiceState, flag == true })

	return state
end

return useVoiceState
