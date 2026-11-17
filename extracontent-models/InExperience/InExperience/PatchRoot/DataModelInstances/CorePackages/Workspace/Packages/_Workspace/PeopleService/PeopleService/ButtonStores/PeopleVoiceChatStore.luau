local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VoiceChatService = game:GetService("VoiceChatService")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local Signals = require(parent2.Signals)

local modules = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules")
local voiceChat = modules:WaitForChild("VoiceChat")
local flags = modules:WaitForChild("Flags")

local VoiceChatServiceManager = require(voiceChat:WaitForChild("VoiceChatServiceManager"))
local default = VoiceChatServiceManager.default
local Constants = require(voiceChat:WaitForChild("Constants"))
local VOICE_STATE = Constants.VOICE_STATE

local ExpChat = require(parent2.ExpChat)
local voiceStore = ExpChat.Stores.GetVoiceStore(false)

local CoreScriptsInitializer = require(parent2.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local GetFFlagVoiceChatUILogging = require(flags:WaitForChild("GetFFlagVoiceChatUILogging"))
local Flags = require(parent.Flags)
local GetFFlagNewPeoplePageIcons = Flags.GetFFlagNewPeoplePageIcons
local Flags2 = require(parent.Flags)
local GetFFlagAddPeoplePageCardLayout = Flags2.GetFFlagAddPeoplePageCardLayout

local Flags3 = require(parent.Flags)
local FFlagVoiceVolumeControlsPerUserPlayerListButton = Flags3.FFlagVoiceVolumeControlsPerUserPlayerListButton
local Flags4 = require(parent.Flags)
local FFlagVoiceVolumeControlsPerUserPlayerGridMenu = Flags4.FFlagVoiceVolumeControlsPerUserPlayerGridMenu
local Flags5 = require(parent.Flags)
local FFlagVoiceChatVolumePerUserMuteVolumeSync = Flags5.FFlagVoiceChatVolumePerUserMuteVolumeSync

local Flags6 = require(parent.Flags)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = Flags6.FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry

local VoiceChatCore = require(parent2.VoiceChatCore)
local VoiceVolumeControlsEligibility = VoiceChatCore.VoiceVolumeControlsEligibility

local defineFastFlag = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)

local engineFeature = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")

local Constants2 = require(parent.Constants)
local FRAME_BUFFER = Constants2.VOICE_CHAT.MIC_ANIMATION.FRAME_BUFFER
local icons = Constants2.VOICE_CHAT.ICONS
local VOICE_VOLUME = Constants2.VOICE_CHAT.VOICE_VOLUME

local playerMuteStatusIcons = default.PlayerMuteStatusIcons

local function createPeopleVoiceChatStore()
	local signal, v2 = Signals.createSignal(false)
	local signal2, v3 = Signals.createSignal(false)
	local signal3, v4 = Signals.createSignal(nil)
	local signal4, v5 = Signals.createSignal(false)
	local getShowVolumeControl, v6

	if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
		getShowVolumeControl, v6 = Signals.createSignal(false)
	else
		v6 = nil
	end

	local v7 = (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)
		and {}
		or nil

	local fn = nil

	local signal5, v8 = Signals.createSignal(0)
	local signal6, v9 = Signals.createSignal(0)

	local count = 0

	local renderSteppedConnection = nil

	local function startMicAnimation() -- 2 equivalent calls inferred from this helper
		if renderSteppedConnection then
			return
		end

		renderSteppedConnection = RunService.RenderStepped:Connect(function()
			if signal4(false) then
				count += 1

				if FRAME_BUFFER < count then
					v8((math.random()))
					count = 0
				end
			else
				count += 1

				if FRAME_BUFFER < count then
					v9((math.random()))
					count = 0
				end
			end
		end)
	end

	local function stopMicAnimation() -- 3 equivalent calls inferred from this helper
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
			renderSteppedConnection = nil
		end
	end

	local allPlayersMuted = Signals.createComputed(function(p): boolean
		if not (signal(p) and default.voiceUIVisible) then
			return false
		end

		local voiceParticipants = voiceStore.getVoiceParticipants(p)

		if not voiceParticipants then
			return false
		end

		for k, voiceParticipant in pairs(voiceParticipants) do
			local v10 = tonumber(k)

			if
				v10
				and Players.LocalPlayer
				and v10 ~= Players.LocalPlayer.UserId
				and voiceParticipant ~= VOICE_STATE.LOCAL_MUTED
			then
				return false
			end
		end

		return true
	end)

	local fn2 = FFlagVoiceChatVolumePerUserMuteVolumeSync and function(p: number, flag: boolean)
		local v10 = tonumber(p)

		if not v10 then
			return
		end

		local coreVoiceManager = default.coreVoiceManager

		if not flag and coreVoiceManager and coreVoiceManager.muteAll then
			coreVoiceManager.muteAll = false

			if coreVoiceManager.muteAllChanged then
				coreVoiceManager.muteAllChanged:Fire(false)
			end

			local localPlayer = Players.LocalPlayer
			local userIds = {}

			for _, v11 in Players:GetPlayers() do
				if localPlayer and v11.UserId ~= localPlayer.UserId and v11.UserId ~= v10 then
					table.insert(userIds, v11.UserId)
				end
			end

			if #userIds > 0 then
				default:ToggleMuteSome(
					userIds,
					true,
					Constants.VOICE_GROUP_TYPE.ALL,
					Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU
				)
			end
		end

		default:ToggleMuteSome({ v10 }, flag, Constants.VOICE_GROUP_TYPE.ALL, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

		if not flag then
			local playerByUserId = Players:GetPlayerByUserId(v10)

			if playerByUserId and playerByUserId.VoiceChatVolume == VOICE_VOLUME.MIN then
				playerByUserId.VoiceChatVolume = VOICE_VOLUME.DEFAULT
			end
		end
	end or nil

	local function toggleMuteAll()
		if not signal(false) then
			return
		end

		local v10 = not allPlayersMuted(false)
		default:MuteAll(v10, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

		if FFlagVoiceChatVolumePerUserMuteVolumeSync and not v10 then
			local localPlayer = Players.LocalPlayer

			for _, v11 in Players:GetPlayers() do
				if localPlayer and v11.UserId ~= localPlayer.UserId and v11.VoiceChatVolume == VOICE_VOLUME.MIN then
					v11.VoiceChatVolume = VOICE_VOLUME.DEFAULT
				end
			end
		end
	end

	local function toggleMuteSelf()
		if not signal(false) then
			return
		end

		default:ToggleMic("InGameMenuPlayers")
	end

	local function SubscribeRetry(p: number)
		if not signal(false) then
			return
		end

		default:SubscribeRetry(p)
	end

	local function getPlayerMuteState(p: number)
		return Signals.createComputed(function(p2): boolean
			local v10 = voiceStore.getOrCreateVoiceState(p)(p2)

			if v10 then
				return v10 == VOICE_STATE.LOCAL_MUTED or v10 == VOICE_STATE.MUTED
			end

			return false
		end)
	end

	local function togglePlayerMute(p: number)
		if not (signal(false) and signal2(false)) then
			return
		end

		local participant = default.participants[tostring(p)]

		if participant and participant.subscriptionCompleted then
			if FFlagVoiceChatVolumePerUserMuteVolumeSync and fn2 then
				fn2(p, voiceStore.getOrCreateVoiceState(p)(false) ~= VOICE_STATE.LOCAL_MUTED)
			else
				default:ToggleMutePlayer(tonumber(p), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
			end
		elseif participant and participant.subscriptionFailed then
			if not defineFastFlag then
				default:SubscribeRetry(p)
			elseif not engineFeature then
				default:SubscribeRetry(p)
			end
		elseif FFlagVoiceChatVolumePerUserMuteVolumeSync and fn2 then
			fn2(p, voiceStore.getOrCreateVoiceState(p)(false) ~= VOICE_STATE.LOCAL_MUTED)
		else
			default:ToggleMutePlayer(tonumber(p), Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
		end
	end

	local function getPlayerShouldShowMuteButton(p: number)
		return Signals.createComputed(function(p2): boolean
			if signal2(p2) and (not Players.LocalPlayer or p ~= Players.LocalPlayer.UserId) then
				return voiceStore.getOrCreateVoiceState(p)(p2) ~= nil
			end

			return false
		end)
	end

	local function getPlayerAnimatedIcon(p: number)
		return Signals.createComputed(function(p2)
			local v10 = voiceStore.getOrCreateVoiceState(p)(p2)

			if not v10 then
				return icons.DEFAULT_SPEAKER
			end

			if v10 == VOICE_STATE.LOCAL_MUTED or v10 == VOICE_STATE.MUTED then
				if GetFFlagNewPeoplePageIcons() then
					return icons.MUTED_SPEAKER
				end

				return icons.SPEAKER_OFF
			else
				if v10 ~= VOICE_STATE.TALKING then
					return icons.DEFAULT_SPEAKER
				end

				local v11 = math.floor(0.5 + 5 * signal6(p2)) * 20
				return string.format(icons.ANIMATED_SPEAKER_FORMAT, v11)
			end
		end)
	end

	local function getPlayerIsLocalMuted(p: number) -- 1 equivalent call inferred from this helper
		return Signals.createComputed(function(p2): boolean
			if p then
				return voiceStore.getOrCreateVoiceState(p)(p2) == VOICE_STATE.LOCAL_MUTED
			end

			return false
		end)
	end

	local fn3 = GetFFlagAddPeoplePageCardLayout() and function(p: number)
		return Signals.createComputed(function(p2): boolean
			return voiceStore.getOrCreateVoiceState(p)(p2) == VOICE_STATE.TALKING
		end)
	end or nil

	local function updateVolumeControlEligibility(p)
		if not game:IsLoaded() then
			v6(false)
			return
		end

		local service = default:getService()
		local v10 = (p or service and service.VoiceChatState) == Enum.VoiceChatState.Joined
		v6(VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v10, VoiceChatService.UseNewAudioApi))
	end

	local function initializeVoiceChat()
		if not game:GetEngineFeature("VoiceChatSupported") then
			return
		end

		default:asyncInit():andThen(function()
			v2(true)
			default:SetupParticipantListeners()

			for k, _ in pairs(default.participants) do
				local localPlayer = Players.LocalPlayer

				if localPlayer and k ~= tostring(localPlayer.UserId) then
					voiceStore.handleVoiceParticipantAdded(k)
				end
			end

			if default.participants and next(default.participants) then
				voiceStore.handleVoiceParticipantsChanged(default.participants)
			end

			default.muteChanged.Event:Connect(function(p)
				v4(p)
			end)

			default.talkingChanged.Event:Connect(function(p)
				v5(p)
			end)

			v4(default.localMuted)
			v5(default.isTalking)

			default.participantsUpdate.Event:Connect(function(p)
				voiceStore.handleVoiceParticipantsChanged(p)
			end)

			default.participantJoined.Event:Connect(function(_, p)
				voiceStore.handleVoiceParticipantAdded((tostring(p)))
			end)

			default.participantLeft.Event:Connect(function(_, p)
				voiceStore.handleVoiceParticipantRemoved((tostring(p)))
			end)

			default.showVoiceUI.Event:Connect(function()
				v3(true)
				startMicAnimation() -- inferred equivalent call
			end)

			default.hideVoiceUI.Event:Connect(function()
				v3(false)
				stopMicAnimation() -- inferred equivalent call
			end)

			if default.voiceUIVisible then
				v3(true)
			end

			startMicAnimation() -- inferred equivalent call

			if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
				local v10 = v7

				fn = function(_, p)
					updateVolumeControlEligibility(p)
				end
				default:subscribe("OnStateChanged", fn)

				local function subscribeToEligibilityProperty(propertyName: string) -- 2 equivalent calls inferred from this helper
					local success, result = pcall(function()
						return VoiceChatService:GetPropertyChangedSignal(propertyName):Connect(function()
							updateVolumeControlEligibility()
						end)
					end)

					if success then
						table.insert(v10, result)
					end
				end

				subscribeToEligibilityProperty("UseNewAudioApi") -- inferred equivalent call
				subscribeToEligibilityProperty("EnableVoiceVolumeControls") -- inferred equivalent call

				if game:IsLoaded() then
					updateVolumeControlEligibility()
				else
					table.insert(v10, game.Loaded:Connect(updateVolumeControlEligibility))
				end
			end
		end):catch(function(_)
			if GetFFlagVoiceChatUILogging() then
				v:warning("Failed to init VoiceChatServiceManager")
			end

			stopMicAnimation() -- inferred equivalent call
		end)
	end

	local function getPlayerVoiceVolume(p: number)
		local playerByUserId = (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)
			and Players:GetPlayerByUserId(p)

		if not playerByUserId then
			return VOICE_VOLUME.DEFAULT
		end

		if
			FFlagVoiceChatVolumePerUserMuteVolumeSync
			and voiceStore.getOrCreateVoiceState(p)(false) == VOICE_STATE.LOCAL_MUTED
		then
			return VOICE_VOLUME.MIN
		end

		return playerByUserId.VoiceChatVolume
	end

	local function subscribePlayerVoiceVolume(p: number, callback)
		if not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
			return function() end
		end

		local playerByUserId = Players:GetPlayerByUserId(p)

		if not playerByUserId then
			return function() end
		end

		local voiceChatVolumeChangedConnection = playerByUserId:GetPropertyChangedSignal("VoiceChatVolume"):Connect(function()
			local v10 = p
			local playerByUserId2 = (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)
				and Players:GetPlayerByUserId(v10)
			local v11

			if playerByUserId2 then
				if
					FFlagVoiceChatVolumePerUserMuteVolumeSync
					and voiceStore.getOrCreateVoiceState(v10)(false) == VOICE_STATE.LOCAL_MUTED
				then
					v11 = VOICE_VOLUME.MIN
				else
					v11 = playerByUserId2.VoiceChatVolume
				end
			else
				v11 = VOICE_VOLUME.DEFAULT
			end

			callback(v11)
		end)
		local v10

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			local playerIsLocalMuted = getPlayerIsLocalMuted(p) -- inferred equivalent call
			v10 = Signals.createEffect(function(p2)
				playerIsLocalMuted(p2)
				local v11 = p
				local playerByUserId2 = (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)
					and Players:GetPlayerByUserId(v11)
				local v12

				if playerByUserId2 then
					if
						FFlagVoiceChatVolumePerUserMuteVolumeSync
						and voiceStore.getOrCreateVoiceState(v11)(false) == VOICE_STATE.LOCAL_MUTED
					then
						v12 = VOICE_VOLUME.MIN
					else
						v12 = playerByUserId2.VoiceChatVolume
					end
				else
					v12 = VOICE_VOLUME.DEFAULT
				end

				callback(v12)
			end)
		else
			v10 = nil
		end

		return function()
			voiceChatVolumeChangedConnection:Disconnect()

			if v10 then
				v10()
			end
		end
	end

	local function setPlayerVoiceVolume(p: number, value: number)
		if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
			local playerByUserId = Players:GetPlayerByUserId(p)

			if not playerByUserId then
				return
			end

			if FFlagVoiceChatVolumePerUserMuteVolumeSync and fn2 then
				local v10 = voiceStore.getOrCreateVoiceState(p)(false) == VOICE_STATE.LOCAL_MUTED
				local voiceChatVolume = math.clamp(value, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)

				if voiceChatVolume == VOICE_VOLUME.MIN then
					playerByUserId.VoiceChatVolume = VOICE_VOLUME.MIN

					if not v10 then
						fn2(p, true)
					end
				else
					playerByUserId.VoiceChatVolume = voiceChatVolume

					if v10 then
						fn2(p, false)
					end
				end
			else
				playerByUserId.VoiceChatVolume = math.clamp(value, VOICE_VOLUME.MIN, VOICE_VOLUME.MAX)
			end
		end
	end

	local function getVoiceSessionId()
		local sessionId = nil

		if pcall(function()
			sessionId = default:GetSessionId()
		end) and sessionId ~= nil and sessionId ~= "" then
			return sessionId
		end

		return nil
	end

	local function cleanup()
		stopMicAnimation() -- inferred equivalent call

		if FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu then
			if fn then
				default:unsubscribe("OnStateChanged", fn)
				fn = nil
			end

			local v10 = v7

			for _, connection in v10 do
				connection:Disconnect()
			end

			table.clear(v10)
		end
	end

	initializeVoiceChat()

	if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		local PerUserVoiceVolumeSessionLifecycle = require(parent.Analytics.PerUserVoiceVolumeSessionLifecycle)
		PerUserVoiceVolumeSessionLifecycle.ensureStarted()
	end

	local peopleVoiceChatStore = {
		voiceChatServiceConnected = signal,
		voiceUIVisible = signal2,
		allPlayersMuted = allPlayersMuted,
		voiceParticipants = voiceStore.getVoiceParticipants,
		localMuted = signal3,
		localTalking = signal4,
		toggleMuteAll = toggleMuteAll,
		toggleMuteSelf = toggleMuteSelf,
		SubscribeRetry = SubscribeRetry,
		getPlayerMuteState = getPlayerMuteState,
		togglePlayerMute = togglePlayerMute,
		getPlayerShouldShowMuteButton = getPlayerShouldShowMuteButton,
		getPlayerAnimatedIcon = getPlayerAnimatedIcon,
		getPlayerIsLocalMuted = getPlayerIsLocalMuted,
		getPlayerIsTalking = 0,
		getMuteSelfIcon = 0,
		getShowVolumeControl = 0,
		getPlayerVoiceVolume = 0,
		subscribePlayerVoiceVolume = 0,
		setPlayerVoiceVolume = 0,
		getVoiceSessionId = 0,
		cleanup = 0
	}

	if not GetFFlagAddPeoplePageCardLayout() then
		fn3 = nil
	end

	peopleVoiceChatStore.getPlayerIsTalking = fn3

	function peopleVoiceChatStore.getMuteSelfIcon()
		return Signals.createComputed(function(p)
			local v10 = signal3(p)
			local v11 = signal4(p)

			if v10 == nil then
				return playerMuteStatusIcons.Loading
			end

			if v10 then
				return playerMuteStatusIcons.MicOff
			end

			if not v11 then
				return playerMuteStatusIcons.MicOn
			end

			local v12 = math.floor(0.5 + 5 * signal5(p)) * 20
			return (default:GetIcon("Unmuted" .. tostring(v12), "MicLight"))
		end)
	end

	if not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
		getShowVolumeControl = nil
	end

	peopleVoiceChatStore.getShowVolumeControl = getShowVolumeControl

	if not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
		getPlayerVoiceVolume = nil
	end

	peopleVoiceChatStore.getPlayerVoiceVolume = getPlayerVoiceVolume

	if not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
		subscribePlayerVoiceVolume = nil
	end

	peopleVoiceChatStore.subscribePlayerVoiceVolume = subscribePlayerVoiceVolume

	if not (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu) then
		setPlayerVoiceVolume = nil
	end

	peopleVoiceChatStore.setPlayerVoiceVolume = setPlayerVoiceVolume

	if not (FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and (FFlagVoiceVolumeControlsPerUserPlayerListButton or FFlagVoiceVolumeControlsPerUserPlayerGridMenu)) then
		getVoiceSessionId = nil
	end

	peopleVoiceChatStore.getVoiceSessionId = getVoiceSessionId

	peopleVoiceChatStore.cleanup = cleanup
	return peopleVoiceChatStore
end

return createPeopleVoiceChatStore()
