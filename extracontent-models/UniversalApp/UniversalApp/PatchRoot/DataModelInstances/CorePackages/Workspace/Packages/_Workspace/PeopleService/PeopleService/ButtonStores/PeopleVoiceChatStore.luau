local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local Modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local VoiceChat = Modules:WaitForChild("VoiceChat")
local Flags = Modules:WaitForChild("Flags")
local default = require(VoiceChat:WaitForChild("VoiceChatServiceManager")).default
local Constants = require(VoiceChat:WaitForChild("Constants"))
local VOICE_STATE = Constants.VOICE_STATE
local v13 = require(ParentParentParent.ExpChat).Stores.GetVoiceStore(false)
local v14 = require(ParentParentParent.CoreScriptsInitializer).CoreLogger:new(script.Name)
local GetFFlagVoiceChatUILogging = require(Flags:WaitForChild("GetFFlagVoiceChatUILogging"))
local GetFFlagNewPeoplePageIcons = require(ParentParent.Flags).GetFFlagNewPeoplePageIcons
local GetFFlagAddPeoplePageCardLayout = require(ParentParent.Flags).GetFFlagAddPeoplePageCardLayout
local v18 = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)
local EngineFeature = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")
local Constants2 = require(ParentParent.Constants)
local FRAME_BUFFER = Constants2.VOICE_CHAT.MIC_ANIMATION.FRAME_BUFFER
local ICONS = Constants2.VOICE_CHAT.ICONS
local PlayerMuteStatusIcons = default.PlayerMuteStatusIcons

local function createPeopleVoiceChatStore() -- line: 69
	-- upvalues: Signals (copy), RunService (copy), FRAME_BUFFER (copy), PlayerMuteStatusIcons (copy), default (copy), v13 (copy), Players (copy), VOICE_STATE (copy), Constants (copy), v18 (copy), EngineFeature (copy), ICONS (copy), GetFFlagNewPeoplePageIcons (copy), GetFFlagAddPeoplePageCardLayout (copy), GetFFlagVoiceChatUILogging (copy), v14 (copy)
	local v25, v26 = Signals.createSignal(false)
	local v27, v28 = Signals.createSignal(false)
	local v29, v30 = Signals.createSignal(nil)
	local v31, v32 = Signals.createSignal(false)
	local v33, v34 = Signals.createSignal(0)
	local v35, v36 = Signals.createSignal(0)
	local n1 = 0
	local connection = nil

	local function startMicAnimation() -- line: 84
		-- upvalues: connection (ref), RunService (copy), v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
		if connection then
			return
		end

		connection = RunService.RenderStepped:Connect(function() -- line: 89
			-- upvalues: v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
			if v31(false) then
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v58 = math.random()

					v34(v58)
					n1 = 0

					return
				end
			else
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v59 = math.random()

					v36(v59)
					n1 = 0
				end
			end
		end)
	end
	local function stopMicAnimation() -- line: 110
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local v41 = Signals.createComputed(function(p1) -- line: 140
		-- upvalues: v25 (copy), default (copy), v13 (copy), Players (copy), VOICE_STATE (copy)
		if not v25(p1) or not default.voiceUIVisible then
			return false
		end

		local v45 = v13.getVoiceParticipants(p1)

		if not v45 then
			return false
		end

		for k, v in pairs(v45) do
			local num = tonumber(k)

			if num and Players.LocalPlayer and num ~= Players.LocalPlayer.UserId and v ~= VOICE_STATE.LOCAL_MUTED then
				return false
			end
		end

		return true
	end)
	local v42 = if not GetFFlagAddPeoplePageCardLayout() then nil else function(n2: number) -- line: 291
		-- upvalues: Signals (copy), v13 (copy), VOICE_STATE (copy)
		return Signals.createComputed(function(p2) -- line: 292
			-- upvalues: v13 (copy), n2 (copy), VOICE_STATE (copy)
			return v13.getOrCreateVoiceState(n2)(p2) == VOICE_STATE.TALKING
		end)
	end

	local function initializeVoiceChat() -- line: 300
		-- upvalues: default (copy), v26 (copy), Players (copy), v13 (copy), v30 (copy), v32 (copy), v28 (copy), connection (ref), RunService (copy), v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy), GetFFlagVoiceChatUILogging (copy), v14 (copy)
		if not game:GetEngineFeature("VoiceChatSupported") then
			return
		end

		default:asyncInit():andThen(function() -- line: 307
			-- upvalues: v26 (copy), default (copy), Players (copy), v13 (copy), v30 (copy), v32 (copy), v28 (copy), connection (ref), RunService (copy), v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
			v26(true)
			default:SetupParticipantListeners()

			for k, _ in pairs(default.participants) do
				local LocalPlayer = Players.LocalPlayer

				if LocalPlayer and k ~= tostring(LocalPlayer.UserId) then
					v13.handleVoiceParticipantAdded(k)
				end
			end

			if default.participants and next(default.participants) then
				v13.handleVoiceParticipantsChanged(default.participants)
			end

			default.muteChanged.Event:Connect(function(p3) -- line: 324
				-- upvalues: v30 (copy)
				v30(p3)
			end)
			default.talkingChanged.Event:Connect(function(p4) -- line: 329
				-- upvalues: v32 (copy)
				v32(p4)
			end)
			v30(default.localMuted)
			v32(default.isTalking)
			default.participantsUpdate.Event:Connect(function(p5) -- line: 338
				-- upvalues: v13 (copy)
				v13.handleVoiceParticipantsChanged(p5)
			end)
			default.participantJoined.Event:Connect(function(_, p7) -- line: 342
				-- upvalues: v13 (copy)
				v13.handleVoiceParticipantAdded((tostring(p7)))
			end)
			default.participantLeft.Event:Connect(function(_, p9) -- line: 346
				-- upvalues: v13 (copy)
				v13.handleVoiceParticipantRemoved((tostring(p9)))
			end)
			default.showVoiceUI.Event:Connect(function() -- line: 351
				-- upvalues: v28 (copy), connection (ref), RunService (copy), v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
				v28(true)

				if connection then
					return
				end

				connection = RunService.RenderStepped:Connect(function() -- line: 89
					-- upvalues: v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
					if v31(false) then
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v85 = math.random()

							v34(v85)
							n1 = 0

							return
						end
					else
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v86 = math.random()

							v36(v86)
							n1 = 0
						end
					end
				end)
			end)
			default.hideVoiceUI.Event:Connect(function() -- line: 356
				-- upvalues: v28 (copy), connection (ref)
				v28(false)

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end)

			if default.voiceUIVisible then
				v28(true)
			end

			if connection then
				return
			end

			connection = RunService.RenderStepped:Connect(function() -- line: 89
				-- upvalues: v31 (copy), n1 (ref), FRAME_BUFFER (copy), v34 (copy), v36 (copy)
				if v31(false) then
					n1 += 1

					if n1 > FRAME_BUFFER then
						local v83 = math.random()

						v34(v83)
						n1 = 0

						return
					end
				else
					n1 += 1

					if n1 > FRAME_BUFFER then
						local v84 = math.random()

						v36(v84)
						n1 = 0
					end
				end
			end)
		end):catch(function(_) -- line: 368
			-- upvalues: GetFFlagVoiceChatUILogging (copy), v14 (copy), connection (ref)
			if GetFFlagVoiceChatUILogging() then
				v14:warning("Failed to init VoiceChatServiceManager")
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end)
	end

	initializeVoiceChat()

	return {
		voiceChatServiceConnected = v25,
		voiceUIVisible = v27,
		allPlayersMuted = v41,
		voiceParticipants = v13.getVoiceParticipants,
		localMuted = v29,
		localTalking = v31,
		toggleMuteAll = function() -- line: 167
			-- upvalues: v25 (copy), v41 (copy), default (copy), Constants (copy)
			if not v25(false) then
				return
			end

			local v49 = v41(false)

			default:MuteAll(not v49, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
		end,
		toggleMuteSelf = function() -- line: 177
			-- upvalues: v25 (copy), default (copy)
			if not v25(false) then
				return
			end

			default:ToggleMic("InGameMenuPlayers")
		end,
		SubscribeRetry = function(n3: number) -- line: 186
			-- upvalues: v25 (copy), default (copy)
			if not v25(false) then
				return
			end

			default:SubscribeRetry(n3)
		end,
		getPlayerMuteState = function(n4: number) -- line: 195
			-- upvalues: Signals (copy), v13 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p11) -- line: 196
				-- upvalues: v13 (copy), n4 (copy), VOICE_STATE (copy)
				local v65 = v13.getOrCreateVoiceState(n4)(p11)

				if not v65 then
					return false
				end

				return v65 == VOICE_STATE.LOCAL_MUTED or v65 == VOICE_STATE.MUTED
			end)
		end,
		togglePlayerMute = function(n5: number) -- line: 208
			-- upvalues: v25 (copy), v27 (copy), default (copy), Constants (copy), v18 (copy), EngineFeature (copy)
			if not v25(false) then
				return
			end

			if not v27(false) then
				return
			end

			local v53 = default.participants[tostring(n5)]

			if v53 and v53.subscriptionCompleted then
				default:ToggleMutePlayer(tonumber(n5), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

				return
			end

			if v53 and v53.subscriptionFailed then
				if not v18 then
					default:SubscribeRetry(n5)

					return
				end

				if not EngineFeature then
					default:SubscribeRetry(n5)

					return
				end
			else
				default:ToggleMutePlayer(tonumber(n5), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
			end
		end,
		getPlayerShouldShowMuteButton = function(n6: number) -- line: 241
			-- upvalues: Signals (copy), v27 (copy), Players (copy), v13 (copy)
			return Signals.createComputed(function(p12) -- line: 242
				-- upvalues: v27 (copy), Players (copy), n6 (copy), v13 (copy)
				if not v27(p12) or Players.LocalPlayer and n6 == Players.LocalPlayer.UserId then
					return false
				end

				return v13.getOrCreateVoiceState(n6)(p12) ~= nil
			end)
		end,
		getPlayerAnimatedIcon = function(n7: number) -- line: 253
			-- upvalues: Signals (copy), v13 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v35 (copy)
			return Signals.createComputed(function(p13) -- line: 254
				-- upvalues: v13 (copy), n7 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v35 (copy)
				local v68 = v13.getOrCreateVoiceState(n7)(p13)

				if not v68 then
					return ICONS.DEFAULT_SPEAKER
				end

				if v68 == VOICE_STATE.LOCAL_MUTED or v68 == VOICE_STATE.MUTED then
					if GetFFlagNewPeoplePageIcons() then
						return ICONS.MUTED_SPEAKER
					end

					return ICONS.SPEAKER_OFF
				end

				if v68 == VOICE_STATE.TALKING then
					local v69 = math.floor(0.5 + 5 * v35(p13)) * 20

					return string.format(ICONS.ANIMATED_SPEAKER_FORMAT, v69)
				end

				return ICONS.DEFAULT_SPEAKER
			end)
		end,
		getPlayerIsLocalMuted = function(n8: number) -- line: 278
			-- upvalues: Signals (copy), v13 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p14) -- line: 279
				-- upvalues: n8 (copy), v13 (copy), VOICE_STATE (copy)
				if not n8 then
					return false
				end

				return v13.getOrCreateVoiceState(n8)(p14) == VOICE_STATE.LOCAL_MUTED
			end)
		end,
		getPlayerIsTalking = if not GetFFlagAddPeoplePageCardLayout() then nil else v42,
		getMuteSelfIcon = function() -- line: 117
			-- upvalues: Signals (copy), v29 (copy), v31 (copy), PlayerMuteStatusIcons (copy), v33 (copy), default (copy)
			return Signals.createComputed(function(p15) -- line: 118
				-- upvalues: v29 (copy), v31 (copy), PlayerMuteStatusIcons (copy), v33 (copy), default (copy)
				local v61 = v29(p15)
				local v62 = v31(p15)

				if v61 == nil then
					return PlayerMuteStatusIcons.Loading
				end

				if v61 then
					return PlayerMuteStatusIcons.MicOff
				end

				if v62 then
					local v63 = math.floor(0.5 + 5 * v33(p15)) * 20

					return (default:GetIcon("Unmuted" .. tostring(v63), "MicLight"))
				end

				return PlayerMuteStatusIcons.MicOn
			end)
		end,
		cleanup = function() -- line: 378
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end
	}
end

return (createPeopleVoiceChatStore())
