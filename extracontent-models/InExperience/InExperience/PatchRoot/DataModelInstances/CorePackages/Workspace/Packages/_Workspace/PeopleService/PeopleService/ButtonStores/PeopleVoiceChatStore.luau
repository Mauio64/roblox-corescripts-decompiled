local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VoiceChatService = game:GetService("VoiceChatService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Signals = require(ParentParentParent.Signals)
local Modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local VoiceChat = Modules:WaitForChild("VoiceChat")
local Flags = Modules:WaitForChild("Flags")
local default = require(VoiceChat:WaitForChild("VoiceChatServiceManager")).default
local Constants = require(VoiceChat:WaitForChild("Constants"))
local VOICE_STATE = Constants.VOICE_STATE
local v14 = require(ParentParentParent.ExpChat).Stores.GetVoiceStore(false)
local v15 = require(ParentParentParent.CoreScriptsInitializer).CoreLogger:new(script.Name)
local GetFFlagVoiceChatUILogging = require(Flags:WaitForChild("GetFFlagVoiceChatUILogging"))
local GetFFlagNewPeoplePageIcons = require(ParentParent.Flags).GetFFlagNewPeoplePageIcons
local GetFFlagAddPeoplePageCardLayout = require(ParentParent.Flags).GetFFlagAddPeoplePageCardLayout
local FFlagVoiceVolumeControlsPerUserPlayerListButton = require(ParentParent.Flags).FFlagVoiceVolumeControlsPerUserPlayerListButton
local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(ParentParent.Flags).FFlagVoiceChatVolumePerUserMuteVolumeSync
local VoiceVolumeControlsEligibility = require(ParentParentParent.VoiceChatCore).VoiceVolumeControlsEligibility
local v22 = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)
local EngineFeature = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")
local Constants2 = require(ParentParent.Constants)
local FRAME_BUFFER = Constants2.VOICE_CHAT.MIC_ANIMATION.FRAME_BUFFER
local ICONS = Constants2.VOICE_CHAT.ICONS
local VOICE_VOLUME = Constants2.VOICE_CHAT.VOICE_VOLUME
local PlayerMuteStatusIcons = default.PlayerMuteStatusIcons

local function createPeopleVoiceChatStore() -- line: 81
	-- upvalues: Signals (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), RunService (copy), FRAME_BUFFER (copy), PlayerMuteStatusIcons (copy), default (copy), v14 (copy), Players (copy), VOICE_STATE (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), Constants (copy), VOICE_VOLUME (copy), v22 (copy), EngineFeature (copy), ICONS (copy), GetFFlagNewPeoplePageIcons (copy), GetFFlagAddPeoplePageCardLayout (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), GetFFlagVoiceChatUILogging (copy), v15 (copy)
	local v30, v31 = Signals.createSignal(false)
	local v32, v33 = Signals.createSignal(false)
	local v34, v35 = Signals.createSignal(nil)
	local v36, v37 = Signals.createSignal(false)
	local v38 = nil
	local u39 = nil

	if FFlagVoiceVolumeControlsPerUserPlayerListButton then
		local v40

		v38, v40 = Signals.createSignal(false)
		u39 = v40
	end

	local v41 = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else {}
	local u42 = nil
	local v43, v44 = Signals.createSignal(0)
	local v45, v46 = Signals.createSignal(0)
	local n1 = 0
	local connection = nil

	local function startMicAnimation() -- line: 105
		-- upvalues: connection (ref), RunService (copy), v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy)
		if connection then
			return
		end

		connection = RunService.RenderStepped:Connect(function() -- line: 110
			-- upvalues: v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy)
			if v36(false) then
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v106 = math.random()

					v44(v106)
					n1 = 0

					return
				end
			else
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v107 = math.random()

					v46(v107)
					n1 = 0
				end
			end
		end)
	end
	local function stopMicAnimation() -- line: 131
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local v51 = Signals.createComputed(function(p1) -- line: 161
		-- upvalues: v30 (copy), default (copy), v14 (copy), Players (copy), VOICE_STATE (copy)
		if not v30(p1) or not default.voiceUIVisible then
			return false
		end

		local v60 = v14.getVoiceParticipants(p1)

		if not v60 then
			return false
		end

		for k, v in pairs(v60) do
			local num = tonumber(k)

			if num and Players.LocalPlayer and num ~= Players.LocalPlayer.UserId and v ~= VOICE_STATE.LOCAL_MUTED then
				return false
			end
		end

		return true
	end)
	local u52 = nil

	if FFlagVoiceChatVolumePerUserMuteVolumeSync then
		function u52(n2: number, b1: boolean) -- line: 189
			-- upvalues: default (copy), Players (copy), Constants (copy), VOICE_VOLUME (copy)
			local num = tonumber(n2)

			if not num then
				return
			end

			local coreVoiceManager = default.coreVoiceManager

			if not b1 and coreVoiceManager and coreVoiceManager.muteAll then
				coreVoiceManager.muteAll = false

				if coreVoiceManager.muteAllChanged then
					coreVoiceManager.muteAllChanged:Fire(false)
				end

				local t1 = {}
				local LocalPlayer = Players.LocalPlayer

				for _, player in Players:GetPlayers() do
					if LocalPlayer and player.UserId ~= LocalPlayer.UserId and num ~= player.UserId then
						table.insert(t1, player.UserId)
					end
				end

				if #t1 > 0 then
					default:ToggleMuteSome(t1, true, Constants.VOICE_GROUP_TYPE.ALL, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
				end
			end

			default:ToggleMuteSome({ num }, b1, Constants.VOICE_GROUP_TYPE.ALL, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

			if not b1 then
				local PlayerByUserId = Players:GetPlayerByUserId(num)

				if PlayerByUserId and PlayerByUserId.VoiceChatVolume == VOICE_VOLUME.MIN then
					PlayerByUserId.VoiceChatVolume = VOICE_VOLUME.DEFAULT
				end
			end
		end
	end

	local v53 = if not GetFFlagAddPeoplePageCardLayout() then nil else function(n3: number) -- line: 391
		-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
		return Signals.createComputed(function(p2) -- line: 392
			-- upvalues: v14 (copy), n3 (copy), VOICE_STATE (copy)
			return v14.getOrCreateVoiceState(n3)(p2) == VOICE_STATE.TALKING
		end)
	end

	local function updateVolumeControlEligibility(p3) -- line: 399
		-- upvalues: u39 (ref), default (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
		if not game:IsLoaded() then
			u39(false)

			return
		end

		local v88 = default:getService()
		local v89 = (p3 or v88 and v88.VoiceChatState) == Enum.VoiceChatState.Joined

		u39(VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v89, VoiceChatService.UseNewAudioApi))
	end
	local function initializeVoiceChat() -- line: 414
		-- upvalues: default (copy), v31 (copy), Players (copy), v14 (copy), v35 (copy), v37 (copy), v33 (copy), connection (ref), RunService (copy), v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), v41 (copy), u42 (ref), updateVolumeControlEligibility (copy), VoiceChatService (copy), GetFFlagVoiceChatUILogging (copy), v15 (copy)
		if not game:GetEngineFeature("VoiceChatSupported") then
			return
		end

		default:asyncInit():andThen(function() -- line: 421
			-- upvalues: v31 (copy), default (copy), Players (copy), v14 (copy), v35 (copy), v37 (copy), v33 (copy), connection (ref), RunService (copy), v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), v41 (copy), u42 (ref), updateVolumeControlEligibility (copy), VoiceChatService (copy)
			v31(true)
			default:SetupParticipantListeners()

			for k, _ in pairs(default.participants) do
				local LocalPlayer = Players.LocalPlayer

				if LocalPlayer and k ~= tostring(LocalPlayer.UserId) then
					v14.handleVoiceParticipantAdded(k)
				end
			end

			if default.participants and next(default.participants) then
				v14.handleVoiceParticipantsChanged(default.participants)
			end

			default.muteChanged.Event:Connect(function(p4) -- line: 438
				-- upvalues: v35 (copy)
				v35(p4)
			end)
			default.talkingChanged.Event:Connect(function(p5) -- line: 443
				-- upvalues: v37 (copy)
				v37(p5)
			end)
			v35(default.localMuted)
			v37(default.isTalking)
			default.participantsUpdate.Event:Connect(function(p6) -- line: 452
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantsChanged(p6)
			end)
			default.participantJoined.Event:Connect(function(_, p8) -- line: 456
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantAdded((tostring(p8)))
			end)
			default.participantLeft.Event:Connect(function(_, p10) -- line: 460
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantRemoved((tostring(p10)))
			end)
			default.showVoiceUI.Event:Connect(function() -- line: 465
				-- upvalues: v33 (copy), connection (ref), RunService (copy), v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy)
				v33(true)

				if connection then
					return
				end

				connection = RunService.RenderStepped:Connect(function() -- line: 110
					-- upvalues: v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy)
					if v36(false) then
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v158 = math.random()

							v44(v158)
							n1 = 0

							return
						end
					else
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v159 = math.random()

							v46(v159)
							n1 = 0
						end
					end
				end)
			end)
			default.hideVoiceUI.Event:Connect(function() -- line: 470
				-- upvalues: v33 (copy), connection (ref)
				v33(false)

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end)

			if default.voiceUIVisible then
				v33(true)
			end

			if not connection then
				connection = RunService.RenderStepped:Connect(function() -- line: 110
					-- upvalues: v36 (copy), n1 (ref), FRAME_BUFFER (copy), v44 (copy), v46 (copy)
					if v36(false) then
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v151 = math.random()

							v44(v151)
							n1 = 0

							return
						end
					else
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v152 = math.random()

							v46(v152)
							n1 = 0
						end
					end
				end)
			end

			if FFlagVoiceVolumeControlsPerUserPlayerListButton then
				local v123 = v41

				function u42(_, p12) -- line: 485
					-- upvalues: updateVolumeControlEligibility (copy)
					updateVolumeControlEligibility(p12)
				end

				default:subscribe("OnStateChanged", u42)

				local function subscribeToEligibilityProperty(s1: string) -- line: 490
					-- upvalues: VoiceChatService (copy), updateVolumeControlEligibility (copy), v123 (copy)
					local ok, result = pcall(function() -- line: 491
						-- upvalues: VoiceChatService (copy), s1 (copy), updateVolumeControlEligibility (copy)
						return VoiceChatService:GetPropertyChangedSignal(s1):Connect(function() -- line: 492
							-- upvalues: updateVolumeControlEligibility (copy)
							updateVolumeControlEligibility()
						end)
					end)

					if ok then
						table.insert(v123, result)
					end
				end

				local s2 = "UseNewAudioApi"
				local ok, result = pcall(function() -- line: 491
					-- upvalues: VoiceChatService (copy), s2 (copy), updateVolumeControlEligibility (copy)
					return VoiceChatService:GetPropertyChangedSignal(s2):Connect(function() -- line: 492
						-- upvalues: updateVolumeControlEligibility (copy)
						updateVolumeControlEligibility()
					end)
				end)

				if ok then
					table.insert(v123, result)
				end

				local s3 = "EnableVoiceVolumeControls"
				local ok2, result2 = pcall(function() -- line: 491
					-- upvalues: VoiceChatService (copy), s3 (copy), updateVolumeControlEligibility (copy)
					return VoiceChatService:GetPropertyChangedSignal(s3):Connect(function() -- line: 492
						-- upvalues: updateVolumeControlEligibility (copy)
						updateVolumeControlEligibility()
					end)
				end)

				if ok2 then
					table.insert(v123, result2)
				end

				if game:IsLoaded() then
					updateVolumeControlEligibility()

					return
				end

				table.insert(v123, game.Loaded:Connect(updateVolumeControlEligibility))
			end
		end):catch(function(_) -- line: 511
			-- upvalues: GetFFlagVoiceChatUILogging (copy), v15 (copy), connection (ref)
			if GetFFlagVoiceChatUILogging() then
				v15:warning("Failed to init VoiceChatServiceManager")
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end)
	end
	local function getPlayerVoiceVolume(n4: number) -- line: 520
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
		if FFlagVoiceVolumeControlsPerUserPlayerListButton then
			local PlayerByUserId = Players:GetPlayerByUserId(n4)

			if PlayerByUserId then
				if FFlagVoiceChatVolumePerUserMuteVolumeSync and v14.getOrCreateVoiceState(n4)(false) == VOICE_STATE.LOCAL_MUTED then
					return VOICE_VOLUME.MIN
				end

				return PlayerByUserId.VoiceChatVolume
			end
		end

		return VOICE_VOLUME.DEFAULT
	end
	local function subscribePlayerVoiceVolume(n5: number, p14: ((...any) -> ...any)) -- line: 537
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy), Signals (copy)
		if not FFlagVoiceVolumeControlsPerUserPlayerListButton then
			return function() -- line: 539
			end
		end

		local PlayerByUserId = Players:GetPlayerByUserId(n5)

		if not PlayerByUserId then
			return function() -- line: 543
			end
		end

		local connection2 = PlayerByUserId:GetPropertyChangedSignal("VoiceChatVolume"):Connect(function() -- line: 545
			-- upvalues: p14 (copy), n5 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
			local v132 = p14
			local v133 = n5
			local g134 = nil
			local PlayerByUserId2 = nil
			local v136 = nil

			repeat
				if g134 or FFlagVoiceVolumeControlsPerUserPlayerListButton then
					if not g134 then
						PlayerByUserId2 = Players:GetPlayerByUserId(v133)
					end

					if g134 or PlayerByUserId2 then
						if not g134 then
							v136 = if not FFlagVoiceChatVolumePerUserMuteVolumeSync or v14.getOrCreateVoiceState(v133)(false) ~= VOICE_STATE.LOCAL_MUTED then PlayerByUserId2.VoiceChatVolume else VOICE_VOLUME.MIN
						end

						g134 = false
						v132(v136)

						return
					end
				end

				v136 = VOICE_VOLUME.DEFAULT
				g134 = true
			until not g134
		end)
		local u96 = nil

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			local v97 = Signals.createComputed(function(p15) -- line: 379
				-- upvalues: n5 (copy), v14 (copy), VOICE_STATE (copy)
				if not n5 then
					return false
				end

				return v14.getOrCreateVoiceState(n5)(p15) == VOICE_STATE.LOCAL_MUTED
			end)

			u96 = Signals.createEffect(function(p16) -- line: 552
				-- upvalues: v97 (copy), p14 (copy), n5 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
				v97(p16)

				local v139 = p14
				local v140 = n5
				local g141 = nil
				local PlayerByUserId3 = nil
				local v143 = nil

				repeat
					if g141 or FFlagVoiceVolumeControlsPerUserPlayerListButton then
						if not g141 then
							PlayerByUserId3 = Players:GetPlayerByUserId(v140)
						end

						if g141 or PlayerByUserId3 then
							if not g141 then
								v143 = if not FFlagVoiceChatVolumePerUserMuteVolumeSync or v14.getOrCreateVoiceState(v140)(false) ~= VOICE_STATE.LOCAL_MUTED then PlayerByUserId3.VoiceChatVolume else VOICE_VOLUME.MIN
							end

							g141 = false
							v139(v143)

							return
						end
					end

					v143 = VOICE_VOLUME.DEFAULT
					g141 = true
				until not g141
			end)
		end

		return function() -- line: 558
			-- upvalues: connection2 (copy), u96 (ref)
			connection2:Disconnect()

			if u96 then
				u96()
			end
		end
	end
	local function setPlayerVoiceVolume(n6: number, n7: number) -- line: 566
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), u52 (ref), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
		if FFlagVoiceVolumeControlsPerUserPlayerListButton then
			local PlayerByUserId = Players:GetPlayerByUserId(n6)

			if not PlayerByUserId then
				return
			end

			if FFlagVoiceChatVolumePerUserMuteVolumeSync and u52 then
				local v101 = v14.getOrCreateVoiceState(n6)(false) == VOICE_STATE.LOCAL_MUTED
				local v102 = math.clamp(n7, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)

				if v102 == VOICE_VOLUME.MIN then
					PlayerByUserId.VoiceChatVolume = VOICE_VOLUME.MIN

					if not v101 then
						u52(n6, true)

						return
					end
				else
					PlayerByUserId.VoiceChatVolume = v102

					if v101 then
						u52(n6, false)

						return
					end
				end
			else
				PlayerByUserId.VoiceChatVolume = math.clamp(n7, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)
			end
		end
	end

	initializeVoiceChat()

	return {
		voiceChatServiceConnected = v30,
		voiceUIVisible = v32,
		allPlayersMuted = v51,
		voiceParticipants = v14.getVoiceParticipants,
		localMuted = v34,
		localTalking = v36,
		toggleMuteAll = function() -- line: 236
			-- upvalues: v30 (copy), v51 (copy), default (copy), Constants (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), Players (copy), VOICE_VOLUME (copy)
			if not v30(false) then
				return
			end

			local v73 = not v51(false)

			default:MuteAll(v73, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

			if FFlagVoiceChatVolumePerUserMuteVolumeSync and not v73 then
				local LocalPlayer = Players.LocalPlayer

				for _, player in Players:GetPlayers() do
					if LocalPlayer and player.UserId ~= LocalPlayer.UserId and player.VoiceChatVolume == VOICE_VOLUME.MIN then
						player.VoiceChatVolume = VOICE_VOLUME.DEFAULT
					end
				end
			end
		end,
		toggleMuteSelf = function() -- line: 259
			-- upvalues: v30 (copy), default (copy)
			if not v30(false) then
				return
			end

			default:ToggleMic("InGameMenuPlayers")
		end,
		SubscribeRetry = function(n8: number) -- line: 268
			-- upvalues: v30 (copy), default (copy)
			if not v30(false) then
				return
			end

			default:SubscribeRetry(n8)
		end,
		getPlayerMuteState = function(n9: number) -- line: 277
			-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p17) -- line: 278
				-- upvalues: v14 (copy), n9 (copy), VOICE_STATE (copy)
				local v113 = v14.getOrCreateVoiceState(n9)(p17)

				if not v113 then
					return false
				end

				return v113 == VOICE_STATE.LOCAL_MUTED or v113 == VOICE_STATE.MUTED
			end)
		end,
		togglePlayerMute = function(n10: number) -- line: 290
			-- upvalues: v30 (copy), v32 (copy), default (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), u52 (ref), v14 (copy), VOICE_STATE (copy), Constants (copy), v22 (copy), EngineFeature (copy)
			if not v30(false) then
				return
			end

			if not v32(false) then
				return
			end

			local v80 = default.participants[tostring(n10)]

			if v80 and v80.subscriptionCompleted then
				if FFlagVoiceChatVolumePerUserMuteVolumeSync and u52 then
					local v81 = v14.getOrCreateVoiceState(n10)(false) == VOICE_STATE.LOCAL_MUTED

					u52(n10, not v81)

					return
				end

				default:ToggleMutePlayer(tonumber(n10), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

				return
			end

			if v80 and v80.subscriptionFailed then
				if not v22 then
					default:SubscribeRetry(n10)

					return
				end

				if not EngineFeature then
					default:SubscribeRetry(n10)

					return
				end
			else
				if FFlagVoiceChatVolumePerUserMuteVolumeSync and u52 then
					local v82 = v14.getOrCreateVoiceState(n10)(false) == VOICE_STATE.LOCAL_MUTED

					u52(n10, not v82)

					return
				end

				default:ToggleMutePlayer(tonumber(n10), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
			end
		end,
		getPlayerShouldShowMuteButton = function(n11: number) -- line: 341
			-- upvalues: Signals (copy), v32 (copy), Players (copy), v14 (copy)
			return Signals.createComputed(function(p18) -- line: 342
				-- upvalues: v32 (copy), Players (copy), n11 (copy), v14 (copy)
				if not v32(p18) or Players.LocalPlayer and n11 == Players.LocalPlayer.UserId then
					return false
				end

				return v14.getOrCreateVoiceState(n11)(p18) ~= nil
			end)
		end,
		getPlayerAnimatedIcon = function(n12: number) -- line: 353
			-- upvalues: Signals (copy), v14 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v45 (copy)
			return Signals.createComputed(function(p19) -- line: 354
				-- upvalues: v14 (copy), n12 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v45 (copy)
				local v116 = v14.getOrCreateVoiceState(n12)(p19)

				if not v116 then
					return ICONS.DEFAULT_SPEAKER
				end

				if v116 == VOICE_STATE.LOCAL_MUTED or v116 == VOICE_STATE.MUTED then
					if GetFFlagNewPeoplePageIcons() then
						return ICONS.MUTED_SPEAKER
					end

					return ICONS.SPEAKER_OFF
				end

				if v116 == VOICE_STATE.TALKING then
					local v117 = math.floor(0.5 + 5 * v45(p19)) * 20

					return string.format(ICONS.ANIMATED_SPEAKER_FORMAT, v117)
				end

				return ICONS.DEFAULT_SPEAKER
			end)
		end,
		getPlayerIsLocalMuted = function(n13: number) -- line: 378
			-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p20) -- line: 379
				-- upvalues: n13 (copy), v14 (copy), VOICE_STATE (copy)
				if not n13 then
					return false
				end

				return v14.getOrCreateVoiceState(n13)(p20) == VOICE_STATE.LOCAL_MUTED
			end)
		end,
		getPlayerIsTalking = if not GetFFlagAddPeoplePageCardLayout() then nil else v53,
		getMuteSelfIcon = function() -- line: 138
			-- upvalues: Signals (copy), v34 (copy), v36 (copy), PlayerMuteStatusIcons (copy), v43 (copy), default (copy)
			return Signals.createComputed(function(p21) -- line: 139
				-- upvalues: v34 (copy), v36 (copy), PlayerMuteStatusIcons (copy), v43 (copy), default (copy)
				local v109 = v34(p21)
				local v110 = v36(p21)

				if v109 == nil then
					return PlayerMuteStatusIcons.Loading
				end

				if v109 then
					return PlayerMuteStatusIcons.MicOff
				end

				if v110 then
					local v111 = math.floor(0.5 + 5 * v43(p21)) * 20

					return (default:GetIcon("Unmuted" .. tostring(v111), "MicLight"))
				end

				return PlayerMuteStatusIcons.MicOn
			end)
		end,
		getShowVolumeControl = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else v38,
		getPlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else getPlayerVoiceVolume,
		subscribePlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else subscribePlayerVoiceVolume,
		setPlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton then nil else setPlayerVoiceVolume,
		cleanup = function() -- line: 593
			-- upvalues: connection (ref), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), u42 (ref), default (copy), v41 (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if FFlagVoiceVolumeControlsPerUserPlayerListButton then
				if u42 then
					default:unsubscribe("OnStateChanged", u42)
					u42 = nil
				end

				local v103 = v41

				for _, v105 in v103 do
					v105:Disconnect()
				end

				table.clear(v103)
			end
		end
	}
end

return (createPeopleVoiceChatStore())
