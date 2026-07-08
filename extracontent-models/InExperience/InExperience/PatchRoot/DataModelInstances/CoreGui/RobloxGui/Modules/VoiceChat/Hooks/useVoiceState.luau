local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local BlockedStatusChangedEvent = require(CorePackages.Workspace.Packages.BlockingUtility):GetBlockedStatusChangedEvent()
local default = require(script.Parent.Parent.VoiceChatServiceManager).default
local VoiceStateContext = require(RobloxGui.Modules.VoiceChat.VoiceStateContext)
local VOICE_STATE = require(CorePackages.Workspace.Packages.VoiceChat).Constants.VOICE_STATE
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local v10 = LocalPlayer and LocalPlayer.UserId or 0
local u11 = if not game:GetEngineFeature("VoiceChatSupported") then {
	Idle = 1,
	Joining = 2,
	JoiningRetry = 3,
	Joined = 4,
	Leaving = 5,
	Ended = 6,
	Failed = 7
} else Enum.VoiceChatState
local t1 = {
	[u11.Idle] = VOICE_STATE.HIDDEN,
	[u11.Joining] = VOICE_STATE.CONNECTING,
	[u11.JoiningRetry] = VOICE_STATE.CONNECTING,
	[u11.Joined] = VOICE_STATE.MUTED,
	[u11.Leaving] = VOICE_STATE.MUTED,
	[u11.Ended] = VOICE_STATE.HIDDEN,
	[u11.Failed] = VOICE_STATE.ERROR
}

local function mapVoiceChatStateToVoiceState(p1) -- line: 74
	-- upvalues: t1 (copy), VOICE_STATE (copy)
	if not t1[p1] then
		return VOICE_STATE.MUTED
	end

	return t1[p1]
end
local function mapParticipantStateToVoiceState(p2) -- line: 82
	-- upvalues: VOICE_STATE (copy)
	local INACTIVE = VOICE_STATE.INACTIVE

	if p2.subscriptionFailed then
		return VOICE_STATE.ERROR
	end

	if not p2.subscriptionCompleted then
		return VOICE_STATE.CONNECTING
	end

	if p2.isMutedLocally then
		return VOICE_STATE.LOCAL_MUTED
	end

	if p2.isMuted then
		return VOICE_STATE.MUTED
	end

	if p2.isSignalActive then
		INACTIVE = VOICE_STATE.TALKING
	end

	return INACTIVE
end
local function useVoiceState(p3, b1: boolean?, p4) -- line: 98
	-- upvalues: default (copy), React (copy), VoiceStateContext (copy), VOICE_STATE (copy), v10 (copy), t1 (copy), u11 (ref), BlockedStatusChangedEvent (copy)
	local v22 = p4 and p4.voiceChatServiceManager or default
	local v23 = React.useContext(VoiceStateContext.Context)
	local v24, v25 = React.useState(VOICE_STATE.HIDDEN)

	React.useEffect(function() -- line: 103
		-- upvalues: v23 (copy), p3 (copy), b1 (copy), v25 (copy), VOICE_STATE (copy), v10 (copy), v24 (copy), t1 (copy), v22 (copy), u11 (ref), BlockedStatusChangedEvent (copy)
		if not v23.voiceEnabled or (not p3 or b1) then
			v25(VOICE_STATE.HIDDEN)

			return function() -- line: 106
			end
		end

		local num = tonumber(p3)
		local str = tostring(p3)
		local v28 = num == v10
		local u29 = nil
		local t2 = {}
		local u31 = false

		local function updateVoiceState(p5) -- line: 117
			-- upvalues: u31 (ref), v25 (copy)
			if not u31 then
				v25(p5)
			end
		end
		local function setVoiceEnabled(p6) -- line: 123
			-- upvalues: v24 (copy), v28 (copy), t1 (copy), VOICE_STATE (copy), v22 (copy), str (copy), u29 (ref), u11 (ref), u31 (ref), v25 (copy)
			local v36 = v24

			if v28 then
				v36 = if t1[p6] then t1[p6] else VOICE_STATE.MUTED
			else
				local v37 = v22.participants[str]

				if v37 and not u29 then
					v36 = VOICE_STATE.INACTIVE

					if v37.subscriptionFailed then
						v36 = VOICE_STATE.ERROR
					elseif not v37.subscriptionCompleted then
						v36 = VOICE_STATE.CONNECTING
					elseif v37.isMutedLocally then
						v36 = VOICE_STATE.LOCAL_MUTED
					elseif v37.isMuted then
						v36 = VOICE_STATE.MUTED
					elseif v37.isSignalActive then
						v36 = VOICE_STATE.TALKING
					end
				end
			end

			if p6 == u11.Failed then
				if not v28 then
					v36 = VOICE_STATE.HIDDEN
				end
			elseif p6 == u11.Joined and not v22.localMuted and v28 then
				v36 = if not v22.isTalking then if not v22.localMuted then VOICE_STATE.INACTIVE else VOICE_STATE.MUTED else VOICE_STATE.TALKING
			end

			if not u31 then
				v25(v36)
			end
		end

		setVoiceEnabled(v23.voiceState)
		delay(0, function() -- line: 157
			-- upvalues: u31 (ref), setVoiceEnabled (copy), v23 (copy), v28 (copy), t2 (copy), v22 (copy), VOICE_STATE (copy), v25 (copy), str (copy), u29 (ref), num (copy), BlockedStatusChangedEvent (copy)
			if u31 then
				return
			end

			setVoiceEnabled(v23.voiceState)

			if v28 then
				table.insert(t2, v22.talkingChanged.Event:Connect(function(p7) -- line: 168
					-- upvalues: VOICE_STATE (copy), u31 (ref), v25 (copy)
					local v39 = if not p7 then VOICE_STATE.INACTIVE else VOICE_STATE.TALKING

					if not u31 then
						v25(v39)
					end
				end))
				table.insert(t2, v22.muteChanged.Event:Connect(function(p8) -- line: 175
					-- upvalues: VOICE_STATE (copy), u31 (ref), v25 (copy)
					local v41 = if not p8 then VOICE_STATE.INACTIVE else VOICE_STATE.MUTED

					if not u31 then
						v25(v41)
					end
				end))

				return
			end

			table.insert(t2, v22.participantsUpdate.Event:Connect(function(p9) -- line: 183
				-- upvalues: str (copy), u29 (ref), VOICE_STATE (copy), u31 (ref), v25 (copy)
				local v43 = p9[str]

				if v43 and not u29 then
					local INACTIVE = VOICE_STATE.INACTIVE

					if v43.subscriptionFailed then
						INACTIVE = VOICE_STATE.ERROR
					elseif not v43.subscriptionCompleted then
						INACTIVE = VOICE_STATE.CONNECTING
					elseif v43.isMutedLocally then
						INACTIVE = VOICE_STATE.LOCAL_MUTED
					elseif v43.isMuted then
						INACTIVE = VOICE_STATE.MUTED
					elseif v43.isSignalActive then
						INACTIVE = VOICE_STATE.TALKING
					end

					if not u31 then
						v25(INACTIVE)

						return
					end
				else
					local HIDDEN = VOICE_STATE.HIDDEN

					if not u31 then
						v25(HIDDEN)
					end
				end
			end))
			table.insert(t2, v22.participantLeft.Event:Connect(function(_, p11) -- line: 195
				-- upvalues: num (copy), VOICE_STATE (copy), u31 (ref), v25 (copy)
				if p11 == num then
					local HIDDEN = VOICE_STATE.HIDDEN

					if not u31 then
						v25(HIDDEN)
					end
				end
			end))
			table.insert(t2, v22.participantJoined.Event:Connect(function(_, p13) -- line: 204
				-- upvalues: num (copy), VOICE_STATE (copy), u31 (ref), v25 (copy)
				if p13 == num then
					local HIDDEN = VOICE_STATE.HIDDEN

					if not u31 then
						v25(HIDDEN)
					end
				end
			end))
			table.insert(t2, BlockedStatusChangedEvent:Connect(function(p14, p15) -- line: 215
				-- upvalues: num (copy), u29 (ref), VOICE_STATE (copy), u31 (ref), v25 (copy), v22 (copy), str (copy)
				if p14 == num then
					if p15 then
						u29 = true

						local HIDDEN = VOICE_STATE.HIDDEN

						if not u31 then
							v25(HIDDEN)

							return
						end
					else
						u29 = nil

						local v55 = v22.participants[str]

						if v55 then
							local INACTIVE = VOICE_STATE.INACTIVE

							if v55.subscriptionFailed then
								INACTIVE = VOICE_STATE.ERROR
							elseif not v55.subscriptionCompleted then
								INACTIVE = VOICE_STATE.CONNECTING
							elseif v55.isMutedLocally then
								INACTIVE = VOICE_STATE.LOCAL_MUTED
							elseif v55.isMuted then
								INACTIVE = VOICE_STATE.MUTED
							elseif v55.isSignalActive then
								INACTIVE = VOICE_STATE.TALKING
							end

							if not u31 then
								v25(INACTIVE)

								return
							end
						else
							local HIDDEN = VOICE_STATE.HIDDEN

							if not u31 then
								v25(HIDDEN)
							end
						end
					end
				end
			end))
		end)

		return function() -- line: 235
			-- upvalues: u31 (ref), t2 (copy)
			u31 = true
			delay(0, function() -- line: 238
				-- upvalues: t2 (copy)
				for _, v59 in t2 do
					v59:disconnect()
				end
			end)
		end
	end, {
		p3,
		v23.voiceState,
		b1 == true
	})

	return v24
end

return useVoiceState
