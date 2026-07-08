local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = require(CorePackages.Workspace.Packages.SharedFlags).FStringTimeoutLoadingLocalPlayerInBackgroundDM
local getMemStorageKey = CrossExperience.Utils.getMemStorageKey
local CEV_JOIN_ATTEMPT_ID_KEY = CrossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY
local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = CrossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM
local v13 = game:DefineFastInt("BackgroundDMLocalPlayerLoadingTimeoutSeconds", 12)
local v14 = game:DefineFastFlag("DelayAudioFocusReplication", false)
local v15 = game:DefineFastInt("PlayerAudioFocusReplicationTimeoutSeconds", 10)
local u16 = nil

if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	u16 = Players.LocalPlayer and Players.LocalPlayer.UserId or -1
end

local function sendAnalyticsEvent(s1: string, t1: {[any]: any}?) -- line: 30
	-- upvalues: getMemStorageKey (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), LOCAL_PLAYER_LOADING_TIMEOUT_ENUM (copy), u16 (ref), RbxAnalyticsService (copy)
	local v98 = t1 or {}

	v98.cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
	v98.clientTimeStamp = os.time()
	v98.userId = if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then u16 else nil
	RbxAnalyticsService:SendEventDeferred("client", "partyVoice", s1, v98)
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	sendAnalyticsEvent("partyVoiceCEVChannelFileLoaded")
end

local v18 = CrossExperience.EventManager.new(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE, true)

local function notifyVoiceStatusChange(p1, s2: string?) -- line: 51
	-- upvalues: v18 (copy), CrossExperience (copy)
	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
		status = p1,
		detail = s2
	})
end
local function ensureLocalPlayerWithTimeout() -- line: 59
	-- upvalues: Players (copy), Promise (copy), v13 (copy), sendAnalyticsEvent (copy), CrossExperience (copy), v18 (copy)
	local LocalPlayer = Players.LocalPlayer

	if not LocalPlayer then
		local v102 = Promise.new(function(resolve) -- line: 63
			-- upvalues: Players (copy)
			if Players.LocalPlayer then
				resolve("loaded")

				return
			end

			local connection = nil

			connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 68
				-- upvalues: Players (copy), connection (ref), resolve (copy)
				if Players.LocalPlayer then
					connection:Disconnect()
					resolve("loaded")
				end
			end)
		end)
		local v103 = Promise.delay(v13):andThen(function() -- line: 78
			return "timeout"
		end)

		Promise.race({
			v102,
			v103
		}):andThen(function(p2) -- line: 83
			-- upvalues: LocalPlayer (ref), Players (copy), sendAnalyticsEvent (copy), v13 (copy), CrossExperience (copy), v18 (copy)
			if p2 == "loaded" then
				LocalPlayer = Players.LocalPlayer
				sendAnalyticsEvent("cevDefaultChannelBackgroundDMLocalPlayerLoaded", {
					timeoutSeconds = v13
				})

				return
			end

			sendAnalyticsEvent("backgroundDMLocalPlayerLoadingTimeout", {
				timeoutSeconds = v13
			})

			local ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT = CrossExperience.Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT
			local v179 = "LocalPlayer loading timed out after " .. v13 .. " seconds"

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				status = ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT,
				detail = v179
			})
			LocalPlayer = nil
		end):await()
	end

	if not LocalPlayer then
		Promise.new(function() -- line: 110
		end):await()
	end

	return LocalPlayer.UserId
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	u16 = -1
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	sendAnalyticsEvent("partyVoiceCEVChannelFileLoaded")
end

local PlayerAudioFocusChanged = nil

if not v14 then
	PlayerAudioFocusChanged = ReplicatedStorage:WaitForChild("PlayerAudioFocusChanged")
	sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedLoaded")
end

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local default2 = VoiceChatCore.CoreVoiceManager.default
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local v30 = if not SharedFlags.GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")

require(CorePackages.Packages.LuauPolyfill)

local FFlagPartyVoiceBlockSync = SharedFlags.FFlagPartyVoiceBlockSync
local GetFFlagVoiceChatClientRewriteMasterLua = SharedFlags.GetFFlagVoiceChatClientRewriteMasterLua
local v33 = game:DefineFastFlag("UseNotificationServiceIsConnected", false)
local v34 = game:DefineFastFlag("DefaultChannelEnableDefaultVoice", true)
local v35 = game:DefineFastFlag("EnableCrossExpVoiceDebug", false)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagEnableCrossExperienceVoiceCaptureMute = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExperienceVoiceCaptureMute
local v38 = game:DefineFastFlag("LogPartyVoiceReconnect", false)
local v39 = game:DefineFastFlag("PartyVoiceFixCaptureVideoCheck", false)
local FIntPartyVoiceUndeafenDelayMS = SharedFlags.FIntPartyVoiceUndeafenDelayMS
local v41 = game:DefineFastFlag("PartyVoiceExecuteVoiceActionsPostAsyncInit", false)
local v42 = game:DefineFastInt("VoiceJoinTimeoutInSeconds", 15)
local EngineFeature = game:GetEngineFeature("VoiceServiceEnableDefaultVoiceAvailable")
local EngineFeature2 = game:GetEngineFeature("NotificationServiceIsConnectedAvailable")
local EngineFeature3 = game:GetEngineFeature("AudioFocusManagement")
local EngineFeature4 = game:GetEngineFeature("CevReadinessSync")
local v47 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v48 = VoiceChatCore.Analytics.new()
local observeCurrentContextId = CrossExperience.Utils.observeCurrentContextId
local VoiceChatService = game:GetService("VoiceChatService")
local Constants = CrossExperience.Constants
local VOICE_STATUS = Constants.VOICE_STATUS
local v53 = SharedFlags.GetFFlagFixPartyVoiceGetPermissions()
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local v55 = game:DefineFastFlag("EnableCEVPersistMuteStateForAFM", false)
local u56 = nil

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	default2:setOptions({
		allowSeamlessVoice = false,
		passInitErrorInPromiseReject = true,
		forceVoiceEnabled = true
	})
end

local v57 = createPersistenceMiddleware({
	storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
})

sendAnalyticsEvent("partyVoicePersistenceMiddlewareCreated")

local default3 = CrossExperience.PartyAudioPlayer.default

sendAnalyticsEvent("partyVoiceCrossExperienceReducerLoaded")

local function v59(p3) -- line: 214
	-- upvalues: default2 (copy), v47 (copy)
	default2:asyncInit():andThen(function() -- line: 216
		-- upvalues: p3 (copy)
		p3()
	end):catch(function(p4) -- line: 219
		-- upvalues: v47 (copy)
		v47:info("CoreVoiceManager did not initialize {}", p4)
	end)
end

local t2 = {
	previousGroupId = nil,
	previousMutedState = false
}
local BindableEvent = Instance.new("BindableEvent")
local u62 = false
local u63 = nil

if EngineFeature4 then
	v47:info("Registering early observer for foreground readiness signal.")
	u63 = v18:addObserver(CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY, function() -- line: 235
		-- upvalues: u62 (ref), v47 (copy), BindableEvent (copy)
		if not u62 then
			v47:info("Received foreground UI readiness signal.")
			u62 = true
			BindableEvent:Fire()
		end
	end)
end

local v64 = Rodux.Store.new((function() -- line: 203
	-- upvalues: Rodux (copy), CrossExperience (copy)
	return Rodux.combineReducers({
		Squad = Rodux.combineReducers({
			CrossExperienceVoice = CrossExperience.installReducer()
		})
	})
end)(), nil, {
	Rodux.thunkMiddleware,
	v57.getMiddleware()
})

sendAnalyticsEvent("partyVoicePersistenceMiddlewareReducerLoaded")
v18:subscribe(v64)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

sendAnalyticsEvent("partyVoiceGameLoaded")

local RCC_CONNECTED = Constants.VOICE_STATUS.RCC_CONNECTED

v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
	detail = nil,
	status = RCC_CONNECTED
})
sendAnalyticsEvent("partyVoiceRCCConnectedSignalFired")
v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_EXPERIENCE_JOINED, {
	jobId = if game.JobId ~= "" and game.JobId ~= nil then game.JobId else HttpService:GenerateGUID(true),
	placeId = game.PlaceId,
	gameId = game.GameId
})

if v14 then
	local u66 = nil
	local u67 = false

	observeCurrentContextId(function(p5) -- line: 277
		-- upvalues: u66 (ref), u67 (ref), PlayerAudioFocusChanged (ref)
		u66 = p5
		print("CurrentContextId changed to", p5, "isReplicationReady:", u67)

		if u67 and PlayerAudioFocusChanged then
			PlayerAudioFocusChanged:FireServer(p5)
			print("Fired PlayerAudioFocusChanged with contextId:", p5)
		end
	end)
	print("Waiting for PlayerAudioFocusChanged to replicate...")
	PlayerAudioFocusChanged = ReplicatedStorage:WaitForChild("PlayerAudioFocusChanged", v15)

	if PlayerAudioFocusChanged then
		print("PlayerAudioFocusChanged replicated successfully.")
		sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedLoaded")
		PlayerAudioFocusChanged.OnClientEvent:Connect(function(p6, p7, p8) -- line: 299
			-- upvalues: v18 (copy), CrossExperience (copy)
			print("Received PlayerAudioFocusChanged OnClientEvent:", p6, p7)
			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, {
				userId = p6,
				contextId = p7,
				contextIds = p8
			})
		end)
		u67 = true

		if u66 then
			PlayerAudioFocusChanged:FireServer(u66)
			print("Fired PlayerAudioFocusChanged with latestContextId:", u66)
		end
	else
		print("PlayerAudioFocusChanged did not replicate within timeout of ", v15, " seconds.")
		sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedReplicationTimeout", {
			timeoutSeconds = v15
		})
	end
else
	observeCurrentContextId(function(p9) -- line: 325
		-- upvalues: PlayerAudioFocusChanged (ref)
		PlayerAudioFocusChanged:FireServer(p9)
	end)
	PlayerAudioFocusChanged.OnClientEvent:Connect(function(p10, p11, p12) -- line: 329
		-- upvalues: v18 (copy), CrossExperience (copy)
		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, {
			userId = p10,
			contextId = p11,
			contextIds = p12
		})
	end)
end

local function v68(p13) -- line: 338
	-- upvalues: v18 (copy), CrossExperience (copy), u16 (ref), FFlagEnablePartyVoiceChangersInLua (copy)
	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_ADDED, {
		userId = p13.UserId,
		isLocalUser = p13.UserId == u16,
		username = p13.Name,
		displayname = p13.DisplayName,
		isVoiceChangerActive = not FFlagEnablePartyVoiceChangersInLua and nil,
		isVoiceChangerHearMyselfActive = not FFlagEnablePartyVoiceChangersInLua and nil,
		selectedVoicePack = if not FFlagEnablePartyVoiceChangersInLua then nil else "None"
	})
end
local function v69(p14) -- line: 356
	-- upvalues: v18 (copy), CrossExperience (copy), u16 (ref), default3 (copy)
	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_REMOVED, {
		userId = p14.UserId,
		isLocalUser = p14.UserId == u16
	})
	default3:playSound("leave")
end
local function v70(p15) -- line: 364
	-- upvalues: CrossExperience (copy), v18 (copy), u16 (ref)
	local v116 = if not p15.isActive then CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE else CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE

	v18:notify(v116, {
		isLocalUser = true,
		userId = u16
	})
end
local function v71(p16) -- line: 374
	-- upvalues: v55 (copy), t2 (ref), CrossExperience (copy), v41 (copy), v59 (copy), v18 (copy), u16 (ref)
	if not v55 then
		t2.previousMutedState = p16
	end

	local v118 = if not p16 then CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED else CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED

	if v41 then
		v59(function() -- line: 383
			-- upvalues: v18 (copy), v118 (copy), u16 (ref)
			v18:notify(v118, {
				isLocalUser = true,
				userId = u16
			})
		end)

		return
	end

	v18:notify(v118, {
		isLocalUser = true,
		userId = u16
	})
end
local function onLocalVoiceChangerChanged(p17) -- line: 397
	-- upvalues: CrossExperience (copy), v18 (copy), u16 (ref)
	local v120 = if not p17 then CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED else CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED

	v18:notify(v120, {
		isLocalUser = true,
		userId = u16
	})
end
local function onLocalVoiceChangerHearMyselfChanged(p18) -- line: 408
	-- upvalues: CrossExperience (copy), v18 (copy), u16 (ref)
	local v122 = if not p18 then CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_DISABLED else CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_ENABLED

	v18:notify(v122, {
		isLocalUser = true,
		userId = u16
	})
end
local function v74(p19) -- line: 419
	-- upvalues: FFlagEnablePartyVoiceChangersInLua (copy), CrossExperience (copy), u16 (ref), v18 (copy)
	for k, v in pairs(p19) do
		local isSignalActive = v.isSignalActive
		local isMuted = v.isMuted
		local v128 = if not FFlagEnablePartyVoiceChangersInLua then nil else v.isVoiceChangerActive
		local v129 = if not isSignalActive then CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE else CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE
		local v130 = if not isMuted then CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED else CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED
		local v131 = if not FFlagEnablePartyVoiceChangersInLua then nil else if not v128 then CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED else CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED
		local t3 = {
			userId = k,
			isLocalUser = k == u16
		}

		v18:notify(v130, t3)
		v18:notify(v129, t3)

		if FFlagEnablePartyVoiceChangersInLua then
			v18:notify(v131, t3)
		end
	end
end
local function v75(p20) -- line: 452
	-- upvalues: u16 (ref), v41 (copy), v59 (copy), v55 (copy), t2 (ref), default2 (copy)
	local num = tonumber(p20.userId)
	local v135 = num == u16

	if v41 then
		v59(function() -- line: 457
			-- upvalues: v135 (copy), v55 (copy), t2 (ref), default2 (copy), num (copy)
			if v135 then
				if v55 then
					t2.previousMutedState = not default2.localMuted
				end

				default2:ToggleMic("Squads")

				return
			end

			default2:ToggleMutePlayer(num)
		end)

		return
	end

	if v135 then
		default2:ToggleMic("Squads")

		return
	end

	default2:ToggleMutePlayer(num)
end
local function setVoicePack(p21) -- line: 476
	-- upvalues: default2 (copy), v18 (copy), CrossExperience (copy), u16 (ref)
	local voicePackName = p21.voicePackName

	default2:SetVoicePack(voicePackName)
	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PACK_WAS_SET, {
		isLocalUser = true,
		userId = u16,
		voicePackName = voicePackName
	})
end
local function toggleVoiceChanger(p22) -- line: 486
	-- upvalues: u16 (ref), default2 (copy)
	local num = tonumber(p22.userId)

	if num == u16 then
		default2:ToggleVoiceChanger("Squads")

		return
	end

	default2:ToggleVoiceChanger(num)
end
local function toggleVoiceChangerHearMyself(p23) -- line: 497
	-- upvalues: u16 (ref), default2 (copy)
	local num = tonumber(p23.userId)

	if num == u16 then
		default2:ToggleVoiceChangerHearMyself("Squads")

		return
	end

	default2:ToggleVoiceChangerHearMyself(num)
end

function handleParticipants() -- line: 508
	-- upvalues: Players (copy), v68 (copy), default3 (copy), v69 (copy), u16 (ref)
	Players.PlayerAdded:Connect(function(player) -- line: 509
		-- upvalues: v68 (copy), default3 (copy)
		v68(player)
		default3:playSound("join")
	end)
	Players.PlayerRemoving:Connect(v69)

	for _, player in pairs(Players:GetPlayers()) do
		if player:IsA("Player") then
			v68(player)

			if player.UserId == u16 then
				default3:playSound("join")
			end
		end
	end
end
function handleMicrophone() -- line: 525
	-- upvalues: default2 (copy), v71 (copy), v18 (copy), CrossExperience (copy), v75 (copy)
	default2.muteChanged.Event:Connect(v71)
	v18:addObserver(CrossExperience.Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, v75)
	v18:addObserver(CrossExperience.Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, v75)
end
function handleVoiceChanger() -- line: 531
	-- upvalues: default2 (copy), onLocalVoiceChangerChanged (copy), v18 (copy), CrossExperience (copy), toggleVoiceChanger (copy), setVoicePack (copy), onLocalVoiceChangerHearMyselfChanged (copy), toggleVoiceChangerHearMyself (copy)
	default2.voiceChangerChanged.Event:Connect(onLocalVoiceChangerChanged)
	v18:addObserver(CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER, toggleVoiceChanger)
	v18:addObserver(CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER, toggleVoiceChanger)
	v18:addObserver(CrossExperience.Constants.EVENTS.SET_PARTY_VOICE_PACK, setVoicePack)
	default2.voiceChangerHearMyselfChanged.Event:Connect(onLocalVoiceChangerHearMyselfChanged)
	v18:addObserver(CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER_FEEDBACK, toggleVoiceChangerHearMyself)
	v18:addObserver(CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER_FEEDBACK, toggleVoiceChangerHearMyself)
end

local function v79(t4: {[any]: any}) -- line: 547
	-- upvalues: Players (copy), BlockingUtility (copy), v47 (copy)
	local v145 = tonumber(t4.userId) or 0
	local PlayerByUserId = Players:GetPlayerByUserId(v145)

	if PlayerByUserId then
		coroutine.wrap(function() -- line: 551
			-- upvalues: BlockingUtility (copy), PlayerByUserId (copy), v47 (copy)
			if BlockingUtility:AddPlayerToBlockList(PlayerByUserId) then
				v47:info("Participant {} was blocked from party voice", PlayerByUserId.DisplayName)
			end
		end)()
	end
end
local function v80(t5: {[any]: any}) -- line: 560
	-- upvalues: Players (copy), BlockingUtility (copy), v47 (copy)
	local v148 = tonumber(t5.userId) or 0
	local PlayerByUserId = Players:GetPlayerByUserId(v148)

	if PlayerByUserId then
		coroutine.wrap(function() -- line: 564
			-- upvalues: BlockingUtility (copy), PlayerByUserId (copy), v47 (copy)
			if BlockingUtility:RemovePlayerFromBlockList(PlayerByUserId) then
				v47:info("Participant {} was unblocked from party voice", PlayerByUserId.DisplayName)
			end
		end)()
	end
end
local function v81() -- line: 573
	-- upvalues: GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy)
	return GetFFlagEnableCrossExperienceVoiceCaptureMute() and (v30 and v30:IsCapturingVideo())
end
local function isAuthorizedPermission(p24, p25) -- line: 581
	-- upvalues: Cryo (copy)
	if p24.missingPermissions then
		return not Cryo.List.find(p24.missingPermissions, p25)
	end

	return false
end
local function requestPermissions(p26) -- line: 588
	-- upvalues: Promise (copy), default (copy), Cryo (copy)
	local t6 = {
		hasMicPermissions = false
	}

	return Promise.new(function(resolve, _) -- line: 593
		-- upvalues: default (copy), p26 (copy), t6 (copy), Cryo (copy)
		default:requestPermissions(p26):andThen(function(p28) -- line: 595
			-- upvalues: t6 (copy), default (copy), Cryo (copy), resolve (copy)
			local v222 = t6
			local MICROPHONE_ACCESS = default.Permissions.MICROPHONE_ACCESS

			v222.hasMicPermissions = not not p28.missingPermissions and not Cryo.List.find(p28.missingPermissions, MICROPHONE_ACCESS)
			resolve(t6)
		end):catch(function() -- line: 600
			-- upvalues: resolve (copy), t6 (copy)
			resolve(t6)
		end)
	end)
end
local function initializeParticipantBlockListener() -- line: 606
	-- upvalues: v18 (copy), CrossExperience (copy), v79 (copy), v80 (copy)
	v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, v79)
	v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, v80)
end

function onCoreVoiceManagerInitialized() -- line: 617
	-- upvalues: default2 (copy), v70 (copy), v74 (copy)
	default2:getService().PlayerMicActivitySignalChange:Connect(v70)
	default2.participantsUpdate.Event:Connect(v74)
end

local function unmuteMicrophoneOnce() -- line: 627
	-- upvalues: default2 (copy), v41 (copy), v59 (copy)
	default2.muteChanged.Event:Once(function(p29) -- line: 628
		-- upvalues: v41 (copy), v59 (copy), default2 (copy)
		if p29 ~= nil then
			if v41 then
				v59(function() -- line: 631
					-- upvalues: default2 (copy)
					default2:ToggleMic("BackgroundDM")
				end)

				return
			end

			default2:ToggleMic("BackgroundDM")
		end
	end)
end
local function initializeDefaultChannel(p30) -- line: 641
	-- upvalues: default2 (copy), v47 (copy), v48 (copy)
	local v155 = default2:getService()

	if not v155 then
		return nil
	end

	v47:info("Joining default channel")

	local v156 = v155:JoinByGroupIdToken("default", p30)

	if v156 then
		v48:reportVoiceChatJoinResult(true, "defaultJoinSuccess")

		return v156
	end

	v48:reportVoiceChatJoinResult(false, "defaultJoinFailed", "error")

	return v156
end
local function validateSetup() -- line: 660
	-- upvalues: EngineFeature2 (copy), v33 (copy), NotificationService (copy), v47 (copy), VoiceChatService (copy), Players (copy), EngineFeature (copy), v34 (copy), v48 (copy), Constants (copy), v18 (copy), CrossExperience (copy)
	if EngineFeature2 and v33 then
		if not NotificationService.IsConnected then
			v47:debug("NotificationService is not yet connected")
			NotificationService:GetPropertyChangedSignal("IsConnected"):Wait()
		end

		v47:debug("NotificationService connected")
	end

	if not VoiceChatService.UseNewAudioApi then
		if not Players.LocalPlayer.Character then
			Players.LocalPlayer.CharacterAdded:Wait()
			v47:debug("Player character loaded")
		else
			v47:debug("Player character already loaded")
		end
	end

	if EngineFeature and v34 then
		local Service = game:FindService("VoiceChatService")

		if not Service then
			v47:info("VoiceChatService not found. Assuming default values.")
		elseif not Service.EnableDefaultVoice and not Service.UseNewAudioApi then
			v47:debug("Default channel is disabled.")
			v48:reportVoiceChatJoinResult(false, "defaultDisabled")

			local ERROR_VOICE_SETUP = Constants.VOICE_STATUS.ERROR_VOICE_SETUP

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				detail = "Default channel disabled",
				status = ERROR_VOICE_SETUP
			})

			return false
		end
	end

	return true
end
local function getPlayerUsersIds() -- line: 692
	-- upvalues: Players (copy)
	local t7 = {}

	for _, player in ipairs(Players:GetPlayers()) do
		table.insert(t7, player.UserId)
	end

	return table.concat(t7, ", ")
end
local function getPermissions(p31) -- line: 700
	-- upvalues: Promise (copy), default (copy), Cryo (copy)
	local t8 = {
		hasMicPermissions = false
	}

	return Promise.new(function(resolve, _) -- line: 705
		-- upvalues: default (copy), p31 (copy), t8 (copy), Cryo (copy), Promise (copy)
		default:hasPermissions(p31):andThen(function(p33) -- line: 707
			-- upvalues: t8 (copy), default (copy), Cryo (copy), p31 (copy), Promise (copy), resolve (copy)
			local v225 = t8
			local MICROPHONE_ACCESS = default.Permissions.MICROPHONE_ACCESS

			v225.hasMicPermissions = not not p33.missingPermissions and not Cryo.List.find(p33.missingPermissions, MICROPHONE_ACCESS)

			if not t8.hasMicPermissions then
				local v227 = p31
				local t9 = {
					hasMicPermissions = false
				}

				Promise.new(function(resolve2, _) -- line: 593
					-- upvalues: default (copy), v227 (copy), t9 (copy), Cryo (copy)
					default:requestPermissions(v227):andThen(function(p35) -- line: 595
						-- upvalues: t9 (copy), default (copy), Cryo (copy), resolve2 (copy)
						local v246 = t9
						local MICROPHONE_ACCESS2 = default.Permissions.MICROPHONE_ACCESS

						v246.hasMicPermissions = not not p35.missingPermissions and not Cryo.List.find(p35.missingPermissions, MICROPHONE_ACCESS2)
						resolve2(t9)
					end):catch(function() -- line: 600
						-- upvalues: resolve2 (copy), t9 (copy)
						resolve2(t9)
					end)
				end):andThen(resolve)

				return
			end

			resolve(t8)
		end):catch(function() -- line: 716
			-- upvalues: resolve (copy), t8 (copy)
			resolve(t8)
		end)
	end)
end

local u90 = false

local function setupListeners() -- line: 724
	-- upvalues: u90 (ref), v47 (copy), default2 (copy), v53 (copy), Promise (copy), default (copy), Cryo (copy), FFlagEnablePartyVoiceChangersInLua (copy), FFlagPartyVoiceBlockSync (copy), v18 (copy), CrossExperience (copy), v79 (copy), v80 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v59 (copy), v35 (copy), HttpService (copy), v64 (copy), Constants (copy), v38 (copy), getPlayerUsersIds (copy), u16 (ref), RbxAnalyticsService (copy), Players (copy), getMemStorageKey (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy), t2 (ref)
	if u90 then
		v47:debug("listeners already registered, skipping duplicate setup")

		return
	end

	u90 = true
	v47:debug("setting up listeners for the first time")
	default2:subscribe("GetPermissions", function(p36, p37) -- line: 733
		-- upvalues: v53 (copy), Promise (copy), default (copy), Cryo (copy)
		if v53 then
			local t10 = {
				hasMicPermissions = false
			}

			Promise.new(function(resolve, _) -- line: 705
				-- upvalues: default (copy), p37 (copy), t10 (copy), Cryo (copy), Promise (copy)
				default:hasPermissions(p37):andThen(function(p39) -- line: 707
					-- upvalues: t10 (copy), default (copy), Cryo (copy), p37 (copy), Promise (copy), resolve (copy)
					local v241 = t10
					local MICROPHONE_ACCESS = default.Permissions.MICROPHONE_ACCESS

					v241.hasMicPermissions = not not p39.missingPermissions and not Cryo.List.find(p39.missingPermissions, MICROPHONE_ACCESS)

					if not t10.hasMicPermissions then
						local v243 = p37
						local t11 = {
							hasMicPermissions = false
						}

						Promise.new(function(resolve3, _) -- line: 593
							-- upvalues: default (copy), v243 (copy), t11 (copy), Cryo (copy)
							default:requestPermissions(v243):andThen(function(p41) -- line: 595
								-- upvalues: t11 (copy), default (copy), Cryo (copy), resolve3 (copy)
								local v251 = t11
								local MICROPHONE_ACCESS3 = default.Permissions.MICROPHONE_ACCESS

								v251.hasMicPermissions = not not p41.missingPermissions and not Cryo.List.find(p41.missingPermissions, MICROPHONE_ACCESS3)
								resolve3(t11)
							end):catch(function() -- line: 600
								-- upvalues: resolve3 (copy), t11 (copy)
								resolve3(t11)
							end)
						end):andThen(resolve)

						return
					end

					resolve(t10)
				end):catch(function() -- line: 716
					-- upvalues: resolve (copy), t10 (copy)
					resolve(t10)
				end)
			end):andThen(p36)

			return
		end

		p36({
			hasMicPermissions = true
		})
	end)
	handleParticipants()
	handleMicrophone()

	if FFlagEnablePartyVoiceChangersInLua then
		handleVoiceChanger()
	end

	if FFlagPartyVoiceBlockSync then
		v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, v79)
		v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, v80)
	end

	if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_MUTE_ALL, function(p42) -- line: 757
			-- upvalues: v59 (copy), default2 (copy)
			v59(function() -- line: 758
				-- upvalues: default2 (copy), p42 (copy)
				default2:MuteAll(true, p42.context)
			end)
		end)
		v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNMUTE_ALL, function(p43) -- line: 762
			-- upvalues: v59 (copy), default2 (copy)
			v59(function() -- line: 763
				-- upvalues: default2 (copy), p43 (copy)
				default2:MuteAll(false, p43.context)
			end)
		end)
	end

	if v35 then
		v18:addObserver(CrossExperience.Constants.EVENTS.DEBUG_COMMAND, function(p44) -- line: 770
			-- upvalues: HttpService (copy), v64 (copy), default2 (copy)
			if p44.name == "dump_session" then
				print("----------- CEV BACKGROUND -----------")
				print("Store State", HttpService:JSONEncode(v64:getState()))
				print("--------------------------------------")
				print("CoreVoiceManager State:")
				print("Participants", HttpService:JSONEncode(default2.participants))
				print("Local Muted", HttpService:JSONEncode({
					value = default2.localMuted
				}))
				print("Mute All", HttpService:JSONEncode({
					value = default2.muteAll
				}))
				print("Muted Anyone", HttpService:JSONEncode({
					value = default2._mutedAnyone
				}))
				print("Is Talking", HttpService:JSONEncode({
					value = default2.isTalking
				}))
				print("Muted Players", HttpService:JSONEncode(default2.mutedPlayers))

				for v193 in default2.audioDevices do
					if v193.Player then
						print("Audio Device ", v193.Player.UserId, " Active:", v193.Active, " MutedByLocalPlayer:", v193.MutedByLocalUser)
					end
				end

				print("Voice Enabled", HttpService:JSONEncode({
					value = default2.voiceEnabled
				}))
				print("Permissions Result", HttpService:JSONEncode(default2.communicationPermissionsResult))
				print("Voice Join Progress", HttpService:JSONEncode({
					value = default2.VoiceJoinProgress
				}))
				print("-----------------------------")
			end
		end)
	end

	default2:subscribe("OnRequestMicPermissionRejected", function() -- line: 802
		-- upvalues: Constants (copy), v18 (copy), CrossExperience (copy)
		local ERROR_VOICE_MIC_REJECTED = Constants.VOICE_STATUS.ERROR_VOICE_MIC_REJECTED

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			detail = nil,
			status = ERROR_VOICE_MIC_REJECTED
		})
	end)
	default2:subscribe("OnPlayerModerated", function() -- line: 806
		-- upvalues: Constants (copy), v18 (copy), CrossExperience (copy)
		local ERROR_VOICE_MODERATED = Constants.VOICE_STATUS.ERROR_VOICE_MODERATED

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			detail = "On Player Moderated",
			status = ERROR_VOICE_MODERATED
		})
	end)
	default2:subscribe("OnInitialJoinFailed", function() -- line: 810
		-- upvalues: Constants (copy), v18 (copy), CrossExperience (copy)
		local ERROR_VOICE_JOIN = Constants.VOICE_STATUS.ERROR_VOICE_JOIN

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			detail = "Initial Join failed",
			status = ERROR_VOICE_JOIN
		})
	end)
	default2:subscribe("OnRetryRequested", function() -- line: 814
		-- upvalues: v38 (copy), Constants (copy), v18 (copy), CrossExperience (copy)
		if v38 then
			local VOICE_RECONNECTING = Constants.VOICE_STATUS.VOICE_RECONNECTING

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				detail = "Retry requested",
				status = VOICE_RECONNECTING
			})

			return
		end

		local VOICE_CONNECTING = Constants.VOICE_STATUS.VOICE_CONNECTING

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			detail = "Retry requested",
			status = VOICE_CONNECTING
		})
	end)
	default2:subscribe("OnStateChanged", function(_, p46) -- line: 822
		-- upvalues: default2 (copy), getPlayerUsersIds (copy), v18 (copy), CrossExperience (copy), u16 (ref), Constants (copy), RbxAnalyticsService (copy), Players (copy), getMemStorageKey (copy), CEV_JOIN_ATTEMPT_ID_KEY (copy), t2 (ref)
		if p46 == Enum.VoiceChatState.Joined then
			local ChannelId = default2:GetChannelId()
			local SessionId = default2:GetSessionId()
			local v203 = getPlayerUsersIds()

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				userId = u16,
				status = Constants.VOICE_STATUS.VOICE_CONNECTED,
				voiceChannelId = ChannelId,
				voiceSessionId = SessionId,
				voicePlaySessionId = RbxAnalyticsService:GetPlaySessionId(),
				participants = v203,
				numberActive = #Players:GetPlayers(),
				cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
			})
			t2.previousGroupId = default2.service:GetGroupId()

			return
		end

		if p46 == Enum.VoiceChatState.Failed then
			local ERROR_VOICE_FAILED = Constants.VOICE_STATUS.ERROR_VOICE_FAILED

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				detail = nil,
				status = ERROR_VOICE_FAILED
			})

			return
		end

		if p46 == Enum.VoiceChatState.Ended then
			local ERROR_VOICE_DISCONNECTED = Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				detail = nil,
				status = ERROR_VOICE_DISCONNECTED
			})
		end
	end)
	default2:subscribe("OnReportJoinFailed", function(p47) -- line: 851
		-- upvalues: v47 (copy), Constants (copy), v18 (copy), CrossExperience (copy)
		v47:error("CEV OnReportJoinFailed " .. p47)

		local ERROR_VOICE_JOIN = Constants.VOICE_STATUS.ERROR_VOICE_JOIN

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			status = ERROR_VOICE_JOIN,
			detail = p47
		})
	end)
end

function initializeAFM() -- line: 858
	-- upvalues: EngineFeature3 (copy), CrossExperience (copy), FIntPartyVoiceUndeafenDelayMS (copy), u56 (ref), v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy), default2 (copy), v55 (copy), t2 (ref), v47 (copy), v41 (copy), v59 (copy), Promise (copy)
	if EngineFeature3 then
		local ok, result = pcall(function() -- line: 860
			return game:GetService("AudioFocusService")
		end)

		if ok and result then
			local CONTEXT_ID = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
			local FOCUS_PRIORITY = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT.CEV.FOCUS_PRIORITY

			result:RegisterContextIdFromLua(CONTEXT_ID)

			local function v168() -- line: 868
				-- upvalues: FIntPartyVoiceUndeafenDelayMS (copy), u56 (ref), v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy), default2 (copy), v55 (copy), t2 (ref)
				if FIntPartyVoiceUndeafenDelayMS > 0 and u56 then
					task.cancel(u56)
					u56 = nil
				end

				if v39 and (not GetFFlagEnableCrossExperienceVoiceCaptureMute() or (not v30 or not v30:IsCapturingVideo())) or not v81 then
					default2:MuteAll(true, "AudioFocusManagement - CEV deafenAll")
				end

				if not default2.localMuted and (not v55 or t2.previousMutedState == default2.localMuted) then
					default2:ToggleMic("AudioFocusManagement - CEV deafenAll")
				end
			end
			local function v169() -- line: 889
				-- upvalues: FIntPartyVoiceUndeafenDelayMS (copy), u56 (ref), v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy), default2 (copy), v47 (copy), v41 (copy), v59 (copy), v55 (copy), t2 (ref)
				if FIntPartyVoiceUndeafenDelayMS > 0 and u56 then
					task.cancel(u56)
					u56 = nil
				end

				if v39 and (not GetFFlagEnableCrossExperienceVoiceCaptureMute() or (not v30 or not v30:IsCapturingVideo())) or not v81 then
					default2:MuteAll(false, "AudioFocusManagement - CEV Mute All")
				end

				if default2.localMuted == nil then
					v47:info("CEV undeafenAll - Voice not connected yet - calling unmuteMicrophoneOnce")
					default2.muteChanged.Event:Once(function(p48) -- line: 628
						-- upvalues: v41 (copy), v59 (copy), default2 (copy)
						if p48 ~= nil then
							if v41 then
								v59(function() -- line: 631
									-- upvalues: default2 (copy)
									default2:ToggleMic("BackgroundDM")
								end)

								return
							end

							default2:ToggleMic("BackgroundDM")
						end
					end)

					return
				end

				if default2.localMuted and (not v55 or t2.previousMutedState ~= default2.localMuted) then
					v47:info("CEV undeafenAll - Voice connected and muted - unmuting immediately")
					default2:ToggleMic("AudioFocusManagement - CEV undeafenAll")
				end
			end

			result.OnDeafenVoiceAudio:Connect(function(p49) -- line: 914
				-- upvalues: CONTEXT_ID (copy), FIntPartyVoiceUndeafenDelayMS (copy), u56 (ref), v47 (copy), v168 (copy)
				if p49 == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 and u56 then
						task.cancel(u56)
						u56 = nil
					end

					v47:info("CEV OnDeafenVoiceAudio fired" .. p49)
					v168()
				end
			end)
			result.OnUndeafenVoiceAudio:Connect(function(p50) -- line: 925
				-- upvalues: CONTEXT_ID (copy), v47 (copy), FIntPartyVoiceUndeafenDelayMS (copy), u56 (ref), v169 (copy)
				if p50 == CONTEXT_ID then
					v47:info("CEV OnUndeafenVoiceAudio fired for context: {} - expected: {}", p50, CONTEXT_ID)

					if FIntPartyVoiceUndeafenDelayMS > 0 then
						if u56 then
							task.cancel(u56)
						end

						u56 = task.delay(FIntPartyVoiceUndeafenDelayMS / 1000, function() -- line: 936
							-- upvalues: u56 (ref), v47 (copy), p50 (copy), v169 (copy)
							u56 = nil
							v47:info("CEV OnUndeafenVoiceAudio fired delayed" .. p50)
							v169()
						end)

						return
					end

					v47:info("CEV OnUndeafenVoiceAudio fired" .. p50)
					v169()
				end
			end)
			v47:info("CEV requestAudioFocusWithPromise - id: {} - priority: {}", CONTEXT_ID, FOCUS_PRIORITY)
			Promise.new(function(resolve, reject) -- line: 950
				-- upvalues: result (copy), CONTEXT_ID (copy), FOCUS_PRIORITY (copy), v47 (copy)
				local ok2, result2 = pcall(result.RequestFocus, result, CONTEXT_ID, FOCUS_PRIORITY)

				if ok2 then
					v47:info("CEV requestAudioFocusWithPromise - focusGranted: {}", result2)
					resolve(result2)

					return
				end

				v47:info("CEV requestAudioFocusWithPromise - rejected")
				reject("Failed to call RequestFocus due to an error")
			end):andThen(function(p51) -- line: 964
				-- upvalues: v47 (copy), default2 (copy), v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy)
				if p51 then
					v47:info("CEV audio focus request granted, preparing to undeafen.")
					default2.muteChanged.Event:Once(function(p52) -- line: 967
						-- upvalues: v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy), default2 (copy)
						if p52 ~= nil and (v39 and (not GetFFlagEnableCrossExperienceVoiceCaptureMute() or (not v30 or not v30:IsCapturingVideo()))) or not v81 then
							default2:MuteAll(false, "AudioFocusManagement CEV")
						end
					end)

					return
				end

				v47:info("CEV audio focus request denied, preparing to deafen.")
				default2.muteChanged.Event:Once(function(p53) -- line: 977
					-- upvalues: v39 (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), v30 (copy), v81 (copy), default2 (copy)
					if p53 ~= nil and (v39 and (not GetFFlagEnableCrossExperienceVoiceCaptureMute() or (not v30 or not v30:IsCapturingVideo()))) or not v81 then
						default2:MuteAll(true, "AudioFocusManagement CEV")
					end
				end)
			end):catch(function() -- line: 987
				-- upvalues: v47 (copy)
				v47:info("[CEV] Error requesting focus inside CEV")
			end)

			return
		end

		v47:info("AudioFocusService did not initialize")
	end
end
function initializeVoice() -- line: 996
	-- upvalues: Constants (copy), v18 (copy), CrossExperience (copy), default2 (copy), initializeDefaultChannel (copy), v47 (copy)
	local VOICE_CONNECTING = Constants.VOICE_STATUS.VOICE_CONNECTING

	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
		detail = nil,
		status = VOICE_CONNECTING
	})
	default2:asyncInit():andThen(function() -- line: 999
		-- upvalues: initializeDefaultChannel (copy), Constants (copy), v18 (copy), CrossExperience (copy)
		if initializeDefaultChannel(false) == false then
			local ERROR_VOICE_JOIN = Constants.VOICE_STATUS.ERROR_VOICE_JOIN

			v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				detail = "Initial Join failed",
				status = ERROR_VOICE_JOIN
			})
		else
			onCoreVoiceManagerInitialized()
		end

		initializeAFM()
	end):catch(function(p54) -- line: 1008
		-- upvalues: v47 (copy), Constants (copy), v18 (copy), CrossExperience (copy)
		v47:info("CoreVoiceManager did not initialize {}", p54)

		local s3 = "INIT_ERROR_UNKNOWN"

		if p54 then
			s3 = p54.code or p54
		end

		local ERROR_VOICE_INIT = Constants.VOICE_STATUS.ERROR_VOICE_INIT

		v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
			status = ERROR_VOICE_INIT,
			detail = s3
		})
	end)
end
function rejoinVoice() -- line: 1022
	-- upvalues: Constants (copy), v18 (copy), CrossExperience (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), default2 (copy), t2 (ref)
	local VOICE_CONNECTING = Constants.VOICE_STATUS.VOICE_CONNECTING

	v18:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
		detail = nil,
		status = VOICE_CONNECTING
	})

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		default2:RejoinVoice()
	else
		default2:RejoinChannel(t2.previousGroupId, t2.previousMutedState)
	end

	t2 = {
		previousGroupId = nil,
		previousMutedState = nil
	}
end
function startVoice() -- line: 1035
	-- upvalues: validateSetup (copy), FStringTimeoutLoadingLocalPlayerInBackgroundDM (copy), LOCAL_PLAYER_LOADING_TIMEOUT_ENUM (copy), u16 (ref), ensureLocalPlayerWithTimeout (copy), v47 (copy), setupListeners (copy)
	if validateSetup() then
		if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
			u16 = ensureLocalPlayerWithTimeout()
			v47:info("Delayed loading of LocalPlayer loaded with UserId: {}", u16)
		end

		setupListeners()
		initializeVoice()
	end
end

v18:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_RECONNECT_REQUESTED, function() -- line: 1047
	-- upvalues: v64 (copy), VOICE_STATUS (copy), v53 (copy)
	local voiceStatus = v64:getState().Squad.CrossExperienceVoice.Experience.voiceStatus

	if voiceStatus == VOICE_STATUS.ERROR_VOICE_SETUP then
		startVoice()

		return
	end

	if voiceStatus == VOICE_STATUS.ERROR_VOICE_INIT or v53 and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED then
		initializeVoice()

		return
	end

	if voiceStatus == VOICE_STATUS.ERROR_VOICE_JOIN or (not v53 and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED or voiceStatus == VOICE_STATUS.ERROR_VOICE_MODERATED or voiceStatus == VOICE_STATUS.ERROR_VOICE_FAILED or voiceStatus == VOICE_STATUS.ERROR_VOICE_DISCONNECTED) then
		rejoinVoice()
	end
end)

local u92 = false

local function doStartVoice() -- line: 1070
	-- upvalues: u92 (ref), u63 (ref), v18 (copy), CrossExperience (copy), v47 (copy)
	if u92 then
		return
	end

	u92 = true

	if u63 then
		v18:removeObserver(u63, CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY)
		u63 = nil
	end

	v47:info("Proceeding to start voice connection.")
	startVoice()
end

sendAnalyticsEvent("startingVoiceFromCEVDefaultChannel")

if EngineFeature4 then
	if u62 then
		v47:info("Foreground was ready before setup finished. Starting voice now.")

		if not u92 then
			u92 = true

			if u63 then
				v18:removeObserver(u63, CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY)
				u63 = nil
			end

			v47:info("Proceeding to start voice connection.")
			startVoice()
		end
	else
		v47:info("Waiting for foreground UI readiness signal (with promise race)...")

		local v94 = Promise.new(function(resolve) -- line: 1095
			-- upvalues: BindableEvent (copy)
			BindableEvent.Event:Once(function() -- line: 1096
				-- upvalues: resolve (copy)
				resolve("signal")
			end)
		end)
		local v95 = Promise.delay(v42):andThen(function() -- line: 1102
			return "timeout"
		end)

		Promise.race({
			v94,
			v95
		}):andThen(function(p55) -- line: 1106
			-- upvalues: v47 (copy), sendAnalyticsEvent (copy), v42 (copy), u92 (ref), u63 (ref), v18 (copy), CrossExperience (copy)
			if p55 == "signal" then
				v47:info("Readiness signal received within timeout.")
			else
				v47:info("Timed out waiting for readiness signal. Starting voice anyway.")
				sendAnalyticsEvent("partyVoiceInitTimedOut", {
					timeout = v42
				})
			end

			if u92 then
				return
			end

			u92 = true

			if u63 then
				v18:removeObserver(u63, CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY)
				u63 = nil
			end

			v47:info("Proceeding to start voice connection.")
			startVoice()
		end)
	end
else
	v47:info("Foreground UI not using readiness sync. Starting voice connection immediately.")
	startVoice()
end
