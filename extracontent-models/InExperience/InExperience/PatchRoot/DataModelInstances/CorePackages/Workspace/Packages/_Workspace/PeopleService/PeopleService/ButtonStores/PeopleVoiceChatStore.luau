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
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = require(ParentParent.Flags).FFlagVoiceVolumeControlsPerUserPlayerGridMenu
local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(ParentParent.Flags).FFlagVoiceChatVolumePerUserMuteVolumeSync
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = require(ParentParent.Flags).FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local VoiceVolumeControlsEligibility = require(ParentParentParent.VoiceChatCore).VoiceVolumeControlsEligibility
local v24 = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)
local EngineFeature = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")
local Constants2 = require(ParentParent.Constants)
local FRAME_BUFFER = Constants2.VOICE_CHAT.MIC_ANIMATION.FRAME_BUFFER
local ICONS = Constants2.VOICE_CHAT.ICONS
local VOICE_VOLUME = Constants2.VOICE_CHAT.VOICE_VOLUME
local PlayerMuteStatusIcons = default.PlayerMuteStatusIcons

local function createPeopleVoiceChatStore() -- line: 85
	-- upvalues: Signals (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), RunService (copy), FRAME_BUFFER (copy), PlayerMuteStatusIcons (copy), default (copy), v14 (copy), Players (copy), VOICE_STATE (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), Constants (copy), VOICE_VOLUME (copy), v24 (copy), EngineFeature (copy), ICONS (copy), GetFFlagNewPeoplePageIcons (copy), GetFFlagAddPeoplePageCardLayout (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), GetFFlagVoiceChatUILogging (copy), v15 (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy)
	local v32, v33 = Signals.createSignal(false)
	local v34, v35 = Signals.createSignal(false)
	local v36, v37 = Signals.createSignal(nil)
	local v38, v39 = Signals.createSignal(false)
	local v40 = nil
	local u41 = nil

	if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		local v42

		v40, v42 = Signals.createSignal(false)
		u41 = v42
	end

	local v43 = if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else {}
	local u44 = nil
	local v45, v46 = Signals.createSignal(0)
	local v47, v48 = Signals.createSignal(0)
	local n1 = 0
	local connection = nil

	local function startMicAnimation() -- line: 110
		-- upvalues: connection (ref), RunService (copy), v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy)
		if connection then
			return
		end

		connection = RunService.RenderStepped:Connect(function() -- line: 115
			-- upvalues: v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy)
			if v38(false) then
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v110 = math.random()

					v46(v110)
					n1 = 0

					return
				end
			else
				n1 += 1

				if n1 > FRAME_BUFFER then
					local v111 = math.random()

					v48(v111)
					n1 = 0
				end
			end
		end)
	end
	local function stopMicAnimation() -- line: 136
		-- upvalues: connection (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	local v53 = Signals.createComputed(function(p1) -- line: 166
		-- upvalues: v32 (copy), default (copy), v14 (copy), Players (copy), VOICE_STATE (copy)
		if not v32(p1) or not default.voiceUIVisible then
			return false
		end

		local v63 = v14.getVoiceParticipants(p1)

		if not v63 then
			return false
		end

		for k, v in pairs(v63) do
			local num = tonumber(k)

			if num and Players.LocalPlayer and num ~= Players.LocalPlayer.UserId and v ~= VOICE_STATE.LOCAL_MUTED then
				return false
			end
		end

		return true
	end)
	local u54 = nil

	if FFlagVoiceChatVolumePerUserMuteVolumeSync then
		function u54(n2: number, b1: boolean) -- line: 194
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

	local v55 = if not GetFFlagAddPeoplePageCardLayout() then nil else function(n3: number) -- line: 396
		-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
		return Signals.createComputed(function(p2) -- line: 397
			-- upvalues: v14 (copy), n3 (copy), VOICE_STATE (copy)
			return v14.getOrCreateVoiceState(n3)(p2) == VOICE_STATE.TALKING
		end)
	end

	local function updateVolumeControlEligibility(p3) -- line: 404
		-- upvalues: u41 (ref), default (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy)
		if not game:IsLoaded() then
			u41(false)

			return
		end

		local v91 = default:getService()
		local v92 = (p3 or v91 and v91.VoiceChatState) == Enum.VoiceChatState.Joined

		u41(VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v92, VoiceChatService.UseNewAudioApi))
	end
	local function initializeVoiceChat() -- line: 419
		-- upvalues: default (copy), v33 (copy), Players (copy), v14 (copy), v37 (copy), v39 (copy), v35 (copy), connection (ref), RunService (copy), v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), v43 (copy), u44 (ref), updateVolumeControlEligibility (copy), VoiceChatService (copy), GetFFlagVoiceChatUILogging (copy), v15 (copy)
		if not game:GetEngineFeature("VoiceChatSupported") then
			return
		end

		default:asyncInit():andThen(function() -- line: 426
			-- upvalues: v33 (copy), default (copy), Players (copy), v14 (copy), v37 (copy), v39 (copy), v35 (copy), connection (ref), RunService (copy), v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), v43 (copy), u44 (ref), updateVolumeControlEligibility (copy), VoiceChatService (copy)
			v33(true)
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

			default.muteChanged.Event:Connect(function(p4) -- line: 443
				-- upvalues: v37 (copy)
				v37(p4)
			end)
			default.talkingChanged.Event:Connect(function(p5) -- line: 448
				-- upvalues: v39 (copy)
				v39(p5)
			end)
			v37(default.localMuted)
			v39(default.isTalking)
			default.participantsUpdate.Event:Connect(function(p6) -- line: 457
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantsChanged(p6)
			end)
			default.participantJoined.Event:Connect(function(_, p8) -- line: 461
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantAdded((tostring(p8)))
			end)
			default.participantLeft.Event:Connect(function(_, p10) -- line: 465
				-- upvalues: v14 (copy)
				v14.handleVoiceParticipantRemoved((tostring(p10)))
			end)
			default.showVoiceUI.Event:Connect(function() -- line: 470
				-- upvalues: v35 (copy), connection (ref), RunService (copy), v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy)
				v35(true)

				if connection then
					return
				end

				connection = RunService.RenderStepped:Connect(function() -- line: 115
					-- upvalues: v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy)
					if v38(false) then
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v162 = math.random()

							v46(v162)
							n1 = 0

							return
						end
					else
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v163 = math.random()

							v48(v163)
							n1 = 0
						end
					end
				end)
			end)
			default.hideVoiceUI.Event:Connect(function() -- line: 475
				-- upvalues: v35 (copy), connection (ref)
				v35(false)

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end)

			if default.voiceUIVisible then
				v35(true)
			end

			if not connection then
				connection = RunService.RenderStepped:Connect(function() -- line: 115
					-- upvalues: v38 (copy), n1 (ref), FRAME_BUFFER (copy), v46 (copy), v48 (copy)
					if v38(false) then
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v155 = math.random()

							v46(v155)
							n1 = 0

							return
						end
					else
						n1 += 1

						if n1 > FRAME_BUFFER then
							local v156 = math.random()

							v48(v156)
							n1 = 0
						end
					end
				end)
			end

			if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
				local v127 = v43

				function u44(_, p12) -- line: 490
					-- upvalues: updateVolumeControlEligibility (copy)
					updateVolumeControlEligibility(p12)
				end

				default:subscribe("OnStateChanged", u44)

				local function subscribeToEligibilityProperty(s1: string) -- line: 495
					-- upvalues: VoiceChatService (copy), updateVolumeControlEligibility (copy), v127 (copy)
					local ok, result = pcall(function() -- line: 496
						-- upvalues: VoiceChatService (copy), s1 (copy), updateVolumeControlEligibility (copy)
						return VoiceChatService:GetPropertyChangedSignal(s1):Connect(function() -- line: 497
							-- upvalues: updateVolumeControlEligibility (copy)
							updateVolumeControlEligibility()
						end)
					end)

					if ok then
						table.insert(v127, result)
					end
				end

				local s2 = "UseNewAudioApi"
				local ok, result = pcall(function() -- line: 496
					-- upvalues: VoiceChatService (copy), s2 (copy), updateVolumeControlEligibility (copy)
					return VoiceChatService:GetPropertyChangedSignal(s2):Connect(function() -- line: 497
						-- upvalues: updateVolumeControlEligibility (copy)
						updateVolumeControlEligibility()
					end)
				end)

				if ok then
					table.insert(v127, result)
				end

				local s3 = "EnableVoiceVolumeControls"
				local ok2, result2 = pcall(function() -- line: 496
					-- upvalues: VoiceChatService (copy), s3 (copy), updateVolumeControlEligibility (copy)
					return VoiceChatService:GetPropertyChangedSignal(s3):Connect(function() -- line: 497
						-- upvalues: updateVolumeControlEligibility (copy)
						updateVolumeControlEligibility()
					end)
				end)

				if ok2 then
					table.insert(v127, result2)
				end

				if game:IsLoaded() then
					updateVolumeControlEligibility()

					return
				end

				table.insert(v127, game.Loaded:Connect(updateVolumeControlEligibility))
			end
		end):catch(function(_) -- line: 516
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
	local function getPlayerVoiceVolume(n4: number) -- line: 525
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
		if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
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
	local function subscribePlayerVoiceVolume(n5: number, p14: ((...any) -> ...any)) -- line: 542
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy), Signals (copy)
		if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
			return function() -- line: 544
			end
		end

		local PlayerByUserId = Players:GetPlayerByUserId(n5)

		if not PlayerByUserId then
			return function() -- line: 548
			end
		end

		local connection2 = PlayerByUserId:GetPropertyChangedSignal("VoiceChatVolume"):Connect(function() -- line: 550
			-- upvalues: p14 (copy), n5 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
			local v136 = p14
			local v137 = n5
			local g138 = nil
			local PlayerByUserId2 = nil
			local v140 = nil

			repeat
				if g138 or (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
					if not g138 then
						PlayerByUserId2 = Players:GetPlayerByUserId(v137)
					end

					if g138 or PlayerByUserId2 then
						if not g138 then
							v140 = if not FFlagVoiceChatVolumePerUserMuteVolumeSync or v14.getOrCreateVoiceState(v137)(false) ~= VOICE_STATE.LOCAL_MUTED then PlayerByUserId2.VoiceChatVolume else VOICE_VOLUME.MIN
						end

						g138 = false
						v136(v140)

						return
					end
				end

				v140 = VOICE_VOLUME.DEFAULT
				g138 = true
			until not g138
		end)
		local u99 = nil

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			local v100 = Signals.createComputed(function(p15) -- line: 384
				-- upvalues: n5 (copy), v14 (copy), VOICE_STATE (copy)
				if not n5 then
					return false
				end

				return v14.getOrCreateVoiceState(n5)(p15) == VOICE_STATE.LOCAL_MUTED
			end)

			u99 = Signals.createEffect(function(p16) -- line: 557
				-- upvalues: v100 (copy), p14 (copy), n5 (copy), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
				v100(p16)

				local v143 = p14
				local v144 = n5
				local g145 = nil
				local PlayerByUserId3 = nil
				local v147 = nil

				repeat
					if g145 or (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
						if not g145 then
							PlayerByUserId3 = Players:GetPlayerByUserId(v144)
						end

						if g145 or PlayerByUserId3 then
							if not g145 then
								v147 = if not FFlagVoiceChatVolumePerUserMuteVolumeSync or v14.getOrCreateVoiceState(v144)(false) ~= VOICE_STATE.LOCAL_MUTED then PlayerByUserId3.VoiceChatVolume else VOICE_VOLUME.MIN
							end

							g145 = false
							v143(v147)

							return
						end
					end

					v147 = VOICE_VOLUME.DEFAULT
					g145 = true
				until not g145
			end)
		end

		return function() -- line: 563
			-- upvalues: connection2 (copy), u99 (ref)
			connection2:Disconnect()

			if u99 then
				u99()
			end
		end
	end
	local function setPlayerVoiceVolume(n6: number, n7: number) -- line: 571
		-- upvalues: FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), Players (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), u54 (ref), v14 (copy), VOICE_STATE (copy), VOICE_VOLUME (copy)
		if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
			local PlayerByUserId = Players:GetPlayerByUserId(n6)

			if not PlayerByUserId then
				return
			end

			if FFlagVoiceChatVolumePerUserMuteVolumeSync and u54 then
				local v104 = v14.getOrCreateVoiceState(n6)(false) == VOICE_STATE.LOCAL_MUTED
				local v105 = math.clamp(n7, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)

				if v105 == VOICE_VOLUME.MIN then
					PlayerByUserId.VoiceChatVolume = VOICE_VOLUME.MIN

					if not v104 then
						u54(n6, true)

						return
					end
				else
					PlayerByUserId.VoiceChatVolume = v105

					if v104 then
						u54(n6, false)

						return
					end
				end
			else
				PlayerByUserId.VoiceChatVolume = math.clamp(n7, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)
			end
		end
	end
	local function getVoiceSessionId() -- line: 597
		-- upvalues: default (copy)
		local SessionId = nil

		if pcall(function() -- line: 599
			-- upvalues: SessionId (ref), default (copy)
			SessionId = default:GetSessionId()
		end) and (SessionId ~= nil and SessionId ~= "") then
			return SessionId
		end

		return nil
	end

	initializeVoiceChat()

	return {
		voiceChatServiceConnected = v32,
		voiceUIVisible = v34,
		allPlayersMuted = v53,
		voiceParticipants = v14.getVoiceParticipants,
		localMuted = v36,
		localTalking = v38,
		toggleMuteAll = function() -- line: 241
			-- upvalues: v32 (copy), v53 (copy), default (copy), Constants (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), Players (copy), VOICE_VOLUME (copy)
			if not v32(false) then
				return
			end

			local v76 = not v53(false)

			default:MuteAll(v76, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

			if FFlagVoiceChatVolumePerUserMuteVolumeSync and not v76 then
				local LocalPlayer = Players.LocalPlayer

				for _, player in Players:GetPlayers() do
					if LocalPlayer and player.UserId ~= LocalPlayer.UserId and player.VoiceChatVolume == VOICE_VOLUME.MIN then
						player.VoiceChatVolume = VOICE_VOLUME.DEFAULT
					end
				end
			end
		end,
		toggleMuteSelf = function() -- line: 264
			-- upvalues: v32 (copy), default (copy)
			if not v32(false) then
				return
			end

			default:ToggleMic("InGameMenuPlayers")
		end,
		SubscribeRetry = function(n8: number) -- line: 273
			-- upvalues: v32 (copy), default (copy)
			if not v32(false) then
				return
			end

			default:SubscribeRetry(n8)
		end,
		getPlayerMuteState = function(n9: number) -- line: 282
			-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p17) -- line: 283
				-- upvalues: v14 (copy), n9 (copy), VOICE_STATE (copy)
				local v117 = v14.getOrCreateVoiceState(n9)(p17)

				if not v117 then
					return false
				end

				return v117 == VOICE_STATE.LOCAL_MUTED or v117 == VOICE_STATE.MUTED
			end)
		end,
		togglePlayerMute = function(n10: number) -- line: 295
			-- upvalues: v32 (copy), v34 (copy), default (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), u54 (ref), v14 (copy), VOICE_STATE (copy), Constants (copy), v24 (copy), EngineFeature (copy)
			if not v32(false) then
				return
			end

			if not v34(false) then
				return
			end

			local v83 = default.participants[tostring(n10)]

			if v83 and v83.subscriptionCompleted then
				if FFlagVoiceChatVolumePerUserMuteVolumeSync and u54 then
					local v84 = v14.getOrCreateVoiceState(n10)(false) == VOICE_STATE.LOCAL_MUTED

					u54(n10, not v84)

					return
				end

				default:ToggleMutePlayer(tonumber(n10), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

				return
			end

			if v83 and v83.subscriptionFailed then
				if not v24 then
					default:SubscribeRetry(n10)

					return
				end

				if not EngineFeature then
					default:SubscribeRetry(n10)

					return
				end
			else
				if FFlagVoiceChatVolumePerUserMuteVolumeSync and u54 then
					local v85 = v14.getOrCreateVoiceState(n10)(false) == VOICE_STATE.LOCAL_MUTED

					u54(n10, not v85)

					return
				end

				default:ToggleMutePlayer(tonumber(n10), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
			end
		end,
		getPlayerShouldShowMuteButton = function(n11: number) -- line: 346
			-- upvalues: Signals (copy), v34 (copy), Players (copy), v14 (copy)
			return Signals.createComputed(function(p18) -- line: 347
				-- upvalues: v34 (copy), Players (copy), n11 (copy), v14 (copy)
				if not v34(p18) or Players.LocalPlayer and n11 == Players.LocalPlayer.UserId then
					return false
				end

				return v14.getOrCreateVoiceState(n11)(p18) ~= nil
			end)
		end,
		getPlayerAnimatedIcon = function(n12: number) -- line: 358
			-- upvalues: Signals (copy), v14 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v47 (copy)
			return Signals.createComputed(function(p19) -- line: 359
				-- upvalues: v14 (copy), n12 (copy), ICONS (copy), VOICE_STATE (copy), GetFFlagNewPeoplePageIcons (copy), v47 (copy)
				local v120 = v14.getOrCreateVoiceState(n12)(p19)

				if not v120 then
					return ICONS.DEFAULT_SPEAKER
				end

				if v120 == VOICE_STATE.LOCAL_MUTED or v120 == VOICE_STATE.MUTED then
					if GetFFlagNewPeoplePageIcons() then
						return ICONS.MUTED_SPEAKER
					end

					return ICONS.SPEAKER_OFF
				end

				if v120 == VOICE_STATE.TALKING then
					local v121 = math.floor(0.5 + 5 * v47(p19)) * 20

					return string.format(ICONS.ANIMATED_SPEAKER_FORMAT, v121)
				end

				return ICONS.DEFAULT_SPEAKER
			end)
		end,
		getPlayerIsLocalMuted = function(n13: number) -- line: 383
			-- upvalues: Signals (copy), v14 (copy), VOICE_STATE (copy)
			return Signals.createComputed(function(p20) -- line: 384
				-- upvalues: n13 (copy), v14 (copy), VOICE_STATE (copy)
				if not n13 then
					return false
				end

				return v14.getOrCreateVoiceState(n13)(p20) == VOICE_STATE.LOCAL_MUTED
			end)
		end,
		getPlayerIsTalking = if not GetFFlagAddPeoplePageCardLayout() then nil else v55,
		getMuteSelfIcon = function() -- line: 143
			-- upvalues: Signals (copy), v36 (copy), v38 (copy), PlayerMuteStatusIcons (copy), v45 (copy), default (copy)
			return Signals.createComputed(function(p21) -- line: 144
				-- upvalues: v36 (copy), v38 (copy), PlayerMuteStatusIcons (copy), v45 (copy), default (copy)
				local v113 = v36(p21)
				local v114 = v38(p21)

				if v113 == nil then
					return PlayerMuteStatusIcons.Loading
				end

				if v113 then
					return PlayerMuteStatusIcons.MicOff
				end

				if v114 then
					local v115 = math.floor(0.5 + 5 * v45(p21)) * 20

					return (default:GetIcon("Unmuted" .. tostring(v115), "MicLight"))
				end

				return PlayerMuteStatusIcons.MicOn
			end)
		end,
		getShowVolumeControl = if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else v40,
		getPlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else getPlayerVoiceVolume,
		subscribePlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else subscribePlayerVoiceVolume,
		setPlayerVoiceVolume = if not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else setPlayerVoiceVolume,
		getVoiceSessionId = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry or not FFlagVoiceVolumeControlsPerUserPlayerListButton and not FFlagVoiceVolumeControlsPerUserPlayerGridMenu then nil else getVoiceSessionId,
		cleanup = function() -- line: 609
			-- upvalues: connection (ref), FFlagVoiceVolumeControlsPerUserPlayerListButton (copy), FFlagVoiceVolumeControlsPerUserPlayerGridMenu (copy), u44 (ref), default (copy), v43 (copy)
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
				if u44 then
					default:unsubscribe("OnStateChanged", u44)
					u44 = nil
				end

				local v107 = v43

				for _, v109 in v107 do
					v109:Disconnect()
				end

				table.clear(v107)
			end
		end
	}
end

return (createPeopleVoiceChatStore())
