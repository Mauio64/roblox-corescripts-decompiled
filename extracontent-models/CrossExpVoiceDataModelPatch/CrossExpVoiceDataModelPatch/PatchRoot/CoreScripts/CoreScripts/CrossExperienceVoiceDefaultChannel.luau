local CorePackages = game:GetService("CorePackages")
local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringTimeoutLoadingLocalPlayerInBackgroundDM = SharedFlags.FStringTimeoutLoadingLocalPlayerInBackgroundDM

local getMemStorageKey = CrossExperience.Utils.getMemStorageKey
local CEV_JOIN_ATTEMPT_ID_KEY = CrossExperience.Constants.CEV_JOIN_ATTEMPT_ID_KEY
local LOCAL_PLAYER_LOADING_TIMEOUT_ENUM = CrossExperience.Constants.LOCAL_PLAYER_LOADING_TIMEOUT_ENUM

local defineFastInt = game:DefineFastInt("BackgroundDMLocalPlayerLoadingTimeoutSeconds", 12)
local defineFastFlag = game:DefineFastFlag("DelayAudioFocusReplication", false)

local defineFastInt2 = game:DefineFastInt("PlayerAudioFocusReplicationTimeoutSeconds", 10)

local userId2 = FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable
	and (Players.LocalPlayer and Players.LocalPlayer.UserId or -1)
	or nil

local function sendAnalyticsEvent(p: string, options)
	local v = options or {}

	v.cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
	v.clientTimeStamp = os.time()
	local userId

	if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
		userId = userId2
	end

	v.userId = userId

	RbxAnalyticsService:SendEventDeferred("client", "partyVoice", p, v)
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	sendAnalyticsEvent("partyVoiceCEVChannelFileLoaded")
end

local eventManager = CrossExperience.EventManager.new(CrossExperience.Constants.EXPERIENCE_TYPE_VOICE, true)

local function notifyVoiceStatusChange(status, detail: string?) -- 14 equivalent calls inferred from this helper
	eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
		status = status,
		detail = detail
	})
end

local function ensureLocalPlayerWithTimeout()
	local localPlayer = Players.LocalPlayer

	if not localPlayer then
		local v = {
			Promise.new(function(callback)
				if Players.LocalPlayer then
					callback("loaded")
					return
				end

				local localPlayerChangedConnection = nil
				localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
					if Players.LocalPlayer then
						localPlayerChangedConnection:Disconnect()
						callback("loaded")
					end
				end)
			end),
			(Promise.delay(defineFastInt):andThen(function(): string
				return "timeout"
			end))
		}
		Promise.race(v):andThen(function(p)
			if p == "loaded" then
				localPlayer = Players.LocalPlayer

				sendAnalyticsEvent("cevDefaultChannelBackgroundDMLocalPlayerLoaded", {
					timeoutSeconds = defineFastInt
				})
			else
				sendAnalyticsEvent("backgroundDMLocalPlayerLoadingTimeout", {
					timeoutSeconds = defineFastInt
				})

				notifyVoiceStatusChange( -- inferred equivalent call
					CrossExperience.Constants.VOICE_STATUS.ERROR_BACKGROUND_DM_LOAD_LOCALPLAYER_TIMEOUT,
					"LocalPlayer loading timed out after " .. defineFastInt .. " seconds"
				)

				localPlayer = nil
			end
		end):await()
	end

	if not localPlayer then
		Promise.new(function() end):await()
	end

	return localPlayer.UserId
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	userId2 = -1
end

if FStringTimeoutLoadingLocalPlayerInBackgroundDM == LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
	sendAnalyticsEvent("partyVoiceCEVChannelFileLoaded")
end

local playerAudioFocusChanged

if defineFastFlag then
	playerAudioFocusChanged = nil
else
	playerAudioFocusChanged = ReplicatedStorage:WaitForChild("PlayerAudioFocusChanged")

	sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedLoaded")
end

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local default2 = VoiceChatCore.CoreVoiceManager.default
local createPersistenceMiddleware = CrossExperience.Middlewares.createPersistenceMiddleware

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local CaptureService

if SharedFlags2.GetFFlagEnableVoiceChatMuteForVideoCaptures() then
	CaptureService = game:GetService("CaptureService")
else
	CaptureService = nil
end

require(CorePackages.Packages.LuauPolyfill)
local FFlagPartyVoiceBlockSync = SharedFlags2.FFlagPartyVoiceBlockSync
local GetFFlagVoiceChatClientRewriteMasterLua = SharedFlags2.GetFFlagVoiceChatClientRewriteMasterLua

local defineFastFlag2 = game:DefineFastFlag("UseNotificationServiceIsConnected", false)
local defineFastFlag3 = game:DefineFastFlag("DefaultChannelEnableDefaultVoice", true)
local defineFastFlag4 = game:DefineFastFlag("EnableCrossExpVoiceDebug", false)

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags3.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags4.GetFFlagEnableCrossExperienceVoiceCaptureMute
local defineFastFlag5 = game:DefineFastFlag("PartyVoiceFixCaptureVideoCheck", false)
local FIntPartyVoiceUndeafenDelayMS = SharedFlags2.FIntPartyVoiceUndeafenDelayMS
local defineFastInt3 = game:DefineFastInt("VoiceJoinTimeoutInSeconds", 15)

local engineFeature = game:GetEngineFeature("VoiceServiceEnableDefaultVoiceAvailable")
local engineFeature2 = game:GetEngineFeature("NotificationServiceIsConnectedAvailable")
local engineFeature3 = game:GetEngineFeature("AudioFocusManagement")
local engineFeature4 = game:GetEngineFeature("CevReadinessSync")

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)
local analytics = VoiceChatCore.Analytics.new()
local observeCurrentContextId = CrossExperience.Utils.observeCurrentContextId

local VoiceChatService = game:GetService("VoiceChatService")

local Constants = CrossExperience.Constants
local VOICE_STATUS = Constants.VOICE_STATUS

local fFlagFixPartyVoiceGetPermissions = SharedFlags2.GetFFlagFixPartyVoiceGetPermissions()
local FFlagEnablePartyVoiceChangersInLua = SharedFlags2.FFlagEnablePartyVoiceChangersInLua
local defineFastFlag6 = game:DefineFastFlag("EnableCEVPersistMuteStateForAFM", false)

local thread = nil

if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
	default2:setOptions({
		allowSeamlessVoice = false,
		passInitErrorInPromiseReject = true,
		forceVoiceEnabled = true
	})
end

local persistenceMiddleware = createPersistenceMiddleware({
	storeKey = CrossExperience.Constants.STORAGE_CEV_STORE_KEY
})

sendAnalyticsEvent("partyVoicePersistenceMiddlewareCreated")

local default3 = CrossExperience.PartyAudioPlayer.default

local function fn()
	return Rodux.combineReducers({
		Squad = Rodux.combineReducers({
			CrossExperienceVoice = CrossExperience.installReducer()
		})
	})
end

sendAnalyticsEvent("partyVoiceCrossExperienceReducerLoaded")

local function fn2(fn3)
	default2:asyncInit():andThen(function()
		fn3()
	end):catch(function(p)
		v:info("CoreVoiceManager did not initialize {}", p)
	end)
end

local v2 = { previousGroupId = nil, previousMutedState = false }

local bindableEvent = Instance.new("BindableEvent")
local flag = false
local v3

if engineFeature4 then
	v:info("Registering early observer for foreground readiness signal.")
	v3 = eventManager:addObserver(CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY, function()
		if not flag then
			v:info("Received foreground UI readiness signal.")
			flag = true
			bindableEvent:Fire()
		end
	end)
else
	v3 = nil
end

local store = Rodux.Store.new(fn(), nil, { Rodux.thunkMiddleware, persistenceMiddleware.getMiddleware() })

sendAnalyticsEvent("partyVoicePersistenceMiddlewareReducerLoaded")

eventManager:subscribe(store)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

sendAnalyticsEvent("partyVoiceGameLoaded")

notifyVoiceStatusChange(Constants.VOICE_STATUS.RCC_CONNECTED) -- inferred equivalent call

sendAnalyticsEvent("partyVoiceRCCConnectedSignalFired")

local PARTY_VOICE_EXPERIENCE_JOINED = CrossExperience.Constants.EVENTS.PARTY_VOICE_EXPERIENCE_JOINED
local jobId

if game.JobId == "" or game.JobId == nil then
	jobId = HttpService:GenerateGUID(true)
else
	jobId = game.JobId
end

eventManager:notify(PARTY_VOICE_EXPERIENCE_JOINED, {
	jobId = jobId,
	placeId = game.PlaceId,
	gameId = game.GameId
})

if defineFastFlag then
	local v4 = nil
	local v5 = false

	observeCurrentContextId(function(p)
		v4 = p

		print("CurrentContextId changed to", p, "isReplicationReady:", v5)

		if v5 and playerAudioFocusChanged then
			playerAudioFocusChanged:FireServer(p)
			print("Fired PlayerAudioFocusChanged with contextId:", p)
		end
	end)

	print("Waiting for PlayerAudioFocusChanged to replicate...")

	playerAudioFocusChanged = ReplicatedStorage:WaitForChild("PlayerAudioFocusChanged", defineFastInt2)

	if playerAudioFocusChanged then
		print("PlayerAudioFocusChanged replicated successfully.")
		sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedLoaded")

		playerAudioFocusChanged.OnClientEvent:Connect(function(userId, contextId, contextIds)
			print("Received PlayerAudioFocusChanged OnClientEvent:", userId, contextId)
			eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, {
				userId = userId,
				contextId = contextId,
				contextIds = contextIds
			})
		end)

		v5 = true

		if v4 then
			playerAudioFocusChanged:FireServer(v4)
			print("Fired PlayerAudioFocusChanged with latestContextId:", v4)
		end
	else
		print("PlayerAudioFocusChanged did not replicate within timeout of ", defineFastInt2, " seconds.")

		sendAnalyticsEvent("partyVoicePlayerAudioFocusChangedReplicationTimeout", {
			timeoutSeconds = defineFastInt2
		})
	end
else
	observeCurrentContextId(function(p)
		playerAudioFocusChanged:FireServer(p)
	end)

	playerAudioFocusChanged.OnClientEvent:Connect(function(userId, contextId, contextIds)
		eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_AUDIO_FOCUS_CHANGED, {
			userId = userId,
			contextId = contextId,
			contextIds = contextIds
		})
	end)
end

local function fn3(player)
	eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_ADDED, {
		userId = player.UserId,
		isLocalUser = player.UserId == userId2,
		username = player.Name,
		displayname = player.DisplayName,
		isVoiceChangerActive = not FFlagEnablePartyVoiceChangersInLua and nil,
		isVoiceChangerHearMyselfActive = not FFlagEnablePartyVoiceChangersInLua and nil,
		selectedVoicePack = FFlagEnablePartyVoiceChangersInLua and "None" or nil
	})
end

local function onPlayerRemoving(p)
	eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_REMOVED, {
		userId = p.UserId,
		isLocalUser = p.UserId == userId2
	})

	default3:playSound("leave")
end

local function onPlayerMicActivitySignalChange(p)
	local v4

	if p.isActive then
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE
	else
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE
	end

	eventManager:notify(v4, { userId = userId2, isLocalUser = true })
end

local function onEvent(previousMutedState)
	if not defineFastFlag6 then
		v2.previousMutedState = previousMutedState
	end

	local v4

	if previousMutedState then
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED
	else
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED
	end

	fn2(function()
		eventManager:notify(v4, { userId = userId2, isLocalUser = true })
	end)
end

local function onLocalVoiceChangerChanged(p)
	local v4

	if p then
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED
	else
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED
	end

	eventManager:notify(v4, { userId = userId2, isLocalUser = true })
end

local function onLocalVoiceChangerHearMyselfChanged(p)
	local v4

	if p then
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_ENABLED
	else
		v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_FEEDBACK_WAS_DISABLED
	end

	eventManager:notify(v4, { userId = userId2, isLocalUser = true })
end

local function onEvent2(items)
	for k, item in pairs(items) do
		local isSignalActive = item.isSignalActive
		local isMuted = item.isMuted
		local isVoiceChangerActive

		if FFlagEnablePartyVoiceChangersInLua then
			isVoiceChangerActive = item.isVoiceChangerActive
		end

		local v4

		if isSignalActive then
			v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_ACTIVE
		else
			v4 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_IS_INACTIVE
		end

		local v5

		if isMuted then
			v5 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_MUTED
		else
			v5 = CrossExperience.Constants.EVENTS.PARTY_VOICE_PARTICIPANT_WAS_UNMUTED
		end

		local v6

		if FFlagEnablePartyVoiceChangersInLua then
			if isVoiceChangerActive then
				v6 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_ENABLED
			else
				v6 = CrossExperience.Constants.EVENTS.PARTY_VOICE_CHANGER_WAS_DISABLED
			end
		end

		local v7 = {
			userId = k,
			isLocalUser = k == userId2
		}

		eventManager:notify(v5, v7)
		eventManager:notify(v4, v7)

		if FFlagEnablePartyVoiceChangersInLua then
			eventManager:notify(v6, v7)
		end
	end
end

local function fn4(p)
	local userId = tonumber(p.userId)
	local v4 = userId2 == userId
	fn2(function()
		if not v4 then
			default2:ToggleMutePlayer(userId)

			return
		end

		if defineFastFlag6 then
			v2.previousMutedState = not default2.localMuted
		end

		default2:ToggleMic("Squads")
	end)
end

local function setVoicePack(p)
	local voicePackName = p.voicePackName
	default2:SetVoicePack(voicePackName)
	eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_PACK_WAS_SET, {
		userId = userId2,
		isLocalUser = true,
		voicePackName = voicePackName
	})
end

local function toggleVoiceChanger(p)
	local userId = tonumber(p.userId)

	if userId2 == userId then
		default2:ToggleVoiceChanger("Squads")
	else
		default2:ToggleVoiceChanger(userId)
	end
end

local function toggleVoiceChangerHearMyself(p)
	local userId = tonumber(p.userId)

	if userId2 == userId then
		default2:ToggleVoiceChangerHearMyself("Squads")
	else
		default2:ToggleVoiceChangerHearMyself(userId)
	end
end

function handleParticipants()
	Players.PlayerAdded:Connect(function(player)
		fn3(player)
		default3:playSound("join")
	end)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	for _, player in pairs(Players:GetPlayers()) do
		if not player:IsA("Player") then
			continue
		end

		fn3(player)

		if player.UserId == userId2 then
			default3:playSound("join")
		end
	end
end

function handleMicrophone()
	default2.muteChanged.Event:Connect(onEvent)
	eventManager:addObserver(CrossExperience.Constants.EVENTS.MUTE_PARTY_VOICE_PARTICIPANT, fn4)
	eventManager:addObserver(CrossExperience.Constants.EVENTS.UNMUTE_PARTY_VOICE_PARTICIPANT, fn4)
end

function handleVoiceChanger()
	default2.voiceChangerChanged.Event:Connect(onLocalVoiceChangerChanged)
	eventManager:addObserver(CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER, toggleVoiceChanger)
	eventManager:addObserver(CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER, toggleVoiceChanger)
	eventManager:addObserver(CrossExperience.Constants.EVENTS.SET_PARTY_VOICE_PACK, setVoicePack)
	default2.voiceChangerHearMyselfChanged.Event:Connect(onLocalVoiceChangerHearMyselfChanged)
	eventManager:addObserver(
		CrossExperience.Constants.EVENTS.ENABLE_PARTY_VOICE_CHANGER_FEEDBACK,
		toggleVoiceChangerHearMyself
	)

	eventManager:addObserver(
		CrossExperience.Constants.EVENTS.DISABLE_PARTY_VOICE_CHANGER_FEEDBACK,
		toggleVoiceChangerHearMyself
	)
end

local function fn5(p)
	local playerByUserId = Players:GetPlayerByUserId(tonumber(p.userId) or 0)

	if playerByUserId then
		coroutine.wrap(function()
			if BlockingUtility:AddPlayerToBlockList(playerByUserId) then
				v:info("Participant {} was blocked from party voice", playerByUserId.DisplayName)
			end
		end)()
	end
end

local function fn6(p)
	local playerByUserId = Players:GetPlayerByUserId(tonumber(p.userId) or 0)

	if playerByUserId then
		coroutine.wrap(function()
			if BlockingUtility:RemovePlayerFromBlockList(playerByUserId) then
				v:info("Participant {} was unblocked from party voice", playerByUserId.DisplayName)
			end
		end)()
	end
end

local function fn7() -- 2 equivalent calls inferred from this helper
	return GetFFlagEnableCrossExperienceVoiceCaptureMute() and CaptureService and CaptureService:IsCapturingVideo()
end

local function isAuthorizedPermission(p, MICROPHONE_ACCESS): boolean -- 2 equivalent calls inferred from this helper
	if p.missingPermissions then
		return not Cryo.List.find(p.missingPermissions, MICROPHONE_ACCESS)
	end

	return false
end

local function requestPermissions(p) -- 1 equivalent call inferred from this helper
	local v4 = { hasMicPermissions = false }

	return Promise.new(function(callback, _)
		default:requestPermissions(p):andThen(function(p2)
			v4.hasMicPermissions = isAuthorizedPermission(p2, default.Permissions.MICROPHONE_ACCESS) -- inferred equivalent call
			callback(v4)
		end):catch(function()
			callback(v4)
		end)
	end)
end

local function initializeParticipantBlockListener() -- 1 equivalent call inferred from this helper
	eventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_BLOCK_PARTICIPANT, fn5)

	eventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNBLOCK_PARTICIPANT, fn6)
end

function onCoreVoiceManagerInitialized()
	default2:getService().PlayerMicActivitySignalChange:Connect(onPlayerMicActivitySignalChange)
	default2.participantsUpdate.Event:Connect(onEvent2)
end

local function unmuteMicrophoneOnce()
	default2.muteChanged.Event:Once(function(p)
		if p ~= nil then
			fn2(function()
				default2:ToggleMic("BackgroundDM")
			end)
		end
	end)
end

local function initializeDefaultChannel(p)
	local service = default2:getService()

	if not service then
		return nil
	end

	v:info("Joining default channel")

	local joinByGroupIdToken = service:JoinByGroupIdToken("default", p)

	if joinByGroupIdToken then
		analytics:reportVoiceChatJoinResult(true, "defaultJoinSuccess")
		return joinByGroupIdToken
	end

	analytics:reportVoiceChatJoinResult(false, "defaultJoinFailed", "error")

	return joinByGroupIdToken
end

local function validateSetup(): boolean
	if engineFeature2 and defineFastFlag2 then
		if not NotificationService.IsConnected then
			v:debug("NotificationService is not yet connected")
			NotificationService:GetPropertyChangedSignal("IsConnected"):Wait()
		end

		v:debug("NotificationService connected")
	end

	if not VoiceChatService.UseNewAudioApi then
		if Players.LocalPlayer.Character then
			v:debug("Player character already loaded")
		else
			Players.LocalPlayer.CharacterAdded:Wait()
			v:debug("Player character loaded")
		end
	end

	if not (engineFeature and defineFastFlag3) then
		return true
	end

	local service = game:FindService("VoiceChatService")

	if service then
		if not (service.EnableDefaultVoice or service.UseNewAudioApi) then
			v:debug("Default channel is disabled.")
			analytics:reportVoiceChatJoinResult(false, "defaultDisabled")
			notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_SETUP, "Default channel disabled") -- inferred equivalent call
			return false
		end
	else
		v:info("VoiceChatService not found. Assuming default values.")
	end

	return true
end

local function getPlayerUsersIds()
	local userIds = {}

	for _, v4 in ipairs(Players:GetPlayers()) do
		table.insert(userIds, v4.UserId)
	end

	return table.concat(userIds, ", ")
end

local function getPermissions(p) -- 1 equivalent call inferred from this helper
	local v4 = { hasMicPermissions = false }

	return Promise.new(function(callback, _)
		default:hasPermissions(p):andThen(function(p2)
			v4.hasMicPermissions = isAuthorizedPermission(p2, default.Permissions.MICROPHONE_ACCESS) -- inferred equivalent call

			if v4.hasMicPermissions then
				callback(v4)

				return
			end

			requestPermissions(p):andThen(callback) -- inferred equivalent call
		end):catch(function()
			callback(v4)
		end)
	end)
end

local flag2 = false

local function setupListeners()
	if flag2 then
		v:debug("listeners already registered, skipping duplicate setup")
		return
	end

	flag2 = true

	v:debug("setting up listeners for the first time")
	default2:subscribe("GetPermissions", function(callback, p)
		if not fFlagFixPartyVoiceGetPermissions then
			callback({ hasMicPermissions = true })

			return
		end

		getPermissions(p):andThen(callback) -- inferred equivalent call
	end)

	handleParticipants()
	handleMicrophone()

	if FFlagEnablePartyVoiceChangersInLua then
		handleVoiceChanger()
	end

	if FFlagPartyVoiceBlockSync then
		initializeParticipantBlockListener() -- inferred equivalent call
	end

	if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
		eventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_MUTE_ALL, function(p)
			fn2(function()
				default2:MuteAll(true, p.context)
			end)
		end)
		eventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_UNMUTE_ALL, function(p)
			fn2(function()
				default2:MuteAll(false, p.context)
			end)
		end)
	end

	if defineFastFlag4 then
		eventManager:addObserver(CrossExperience.Constants.EVENTS.DEBUG_COMMAND, function(p)
			if p.name == "dump_session" then
				print("----------- CEV BACKGROUND -----------")
				print("Store State", HttpService:JSONEncode(store:getState()))
				print("--------------------------------------")
				print("CoreVoiceManager State:")
				print("Participants", HttpService:JSONEncode(default2.participants))
				print("Local Muted", HttpService:JSONEncode({ value = default2.localMuted }))
				print("Mute All", HttpService:JSONEncode({ value = default2.muteAll }))
				print("Muted Anyone", HttpService:JSONEncode({ value = default2._mutedAnyone }))
				print("Is Talking", HttpService:JSONEncode({ value = default2.isTalking }))
				print("Muted Players", HttpService:JSONEncode(default2.mutedPlayers))

				for k in default2.audioDevices do
					if k.Player then
						print(
							"Audio Device ",
							k.Player.UserId,
							" Active:",
							k.Active,
							" MutedByLocalPlayer:",
							k.MutedByLocalUser
						)
					end
				end

				print("Voice Enabled", HttpService:JSONEncode({ value = default2.voiceEnabled }))
				print("Permissions Result", HttpService:JSONEncode(default2.communicationPermissionsResult))
				print("Voice Join Progress", HttpService:JSONEncode({
					value = default2.VoiceJoinProgress
				}))
				print("-----------------------------")
			end
		end)
	end

	default2:subscribe("OnRequestMicPermissionRejected", function()
		notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_MIC_REJECTED) -- inferred equivalent call
	end)

	default2:subscribe("OnPlayerModerated", function()
		notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_MODERATED, "On Player Moderated") -- inferred equivalent call
	end)

	default2:subscribe("OnInitialJoinFailed", function()
		notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_JOIN, "Initial Join failed") -- inferred equivalent call
	end)

	default2:subscribe("OnRetryRequested", function()
		notifyVoiceStatusChange(Constants.VOICE_STATUS.VOICE_RECONNECTING, "Retry requested") -- inferred equivalent call
	end)

	default2:subscribe("OnStateChanged", function(_, p)
		if p == Enum.VoiceChatState.Joined then
			local channelId = default2:GetChannelId()
			local sessionId = default2:GetSessionId()

			local playerUsersIds = getPlayerUsersIds()
			eventManager:notify(CrossExperience.Constants.EVENTS.PARTY_VOICE_STATUS_CHANGED, {
				userId = userId2,
				status = Constants.VOICE_STATUS.VOICE_CONNECTED,
				voiceChannelId = channelId,
				voiceSessionId = sessionId,
				voicePlaySessionId = RbxAnalyticsService:GetPlaySessionId(),
				participants = playerUsersIds,
				numberActive = #Players:GetPlayers(),
				cevJoinAttemptId = getMemStorageKey(CEV_JOIN_ATTEMPT_ID_KEY)
			})

			v2.previousGroupId = default2.service:GetGroupId()
		elseif p == Enum.VoiceChatState.Failed then
			notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_FAILED) -- inferred equivalent call
		elseif p == Enum.VoiceChatState.Ended then
			notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_DISCONNECTED) -- inferred equivalent call
		end
	end)

	default2:subscribe("OnReportJoinFailed", function(detail)
		v:error("CEV OnReportJoinFailed " .. detail)

		notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_JOIN, detail) -- inferred equivalent call
	end)
end

function initializeAFM()
	local v4 = result

	local function fn8(CONTEXT_ID, FOCUS_PRIORITY) -- 1 equivalent call inferred from this helper
		v:info("CEV requestAudioFocusWithPromise - id: {} - priority: {}", CONTEXT_ID, FOCUS_PRIORITY)
		return Promise.new(function(callback, callback2)
			local success, result = pcall(v4.RequestFocus, v4, CONTEXT_ID, FOCUS_PRIORITY)

			if success then
				v:info("CEV requestAudioFocusWithPromise - focusGranted: {}", result)
				callback(result)
			else
				v:info("CEV requestAudioFocusWithPromise - rejected")
				callback2("Failed to call RequestFocus due to an error")
			end
		end)
	end

	if engineFeature3 then
		local success, result = pcall(function()
			return game:GetService("AudioFocusService")
		end)

		if success and result then
			local CONTEXT_ID = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT.CEV.CONTEXT_ID
			local FOCUS_PRIORITY = CrossExperience.Constants.AUDIO_FOCUS_MANAGEMENT.CEV.FOCUS_PRIORITY
			result:RegisterContextIdFromLua(CONTEXT_ID)

			local function fn9()
				if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
					task.cancel(thread)
					thread = nil
				end

				if defineFastFlag5 and not fn7() or not fn7 then -- inferred equivalent call
					default2:MuteAll(true, "AudioFocusManagement - CEV deafenAll")
				end

				if
					not default2.localMuted
					and (not defineFastFlag6 or v2.previousMutedState == default2.localMuted)
				then
					default2:ToggleMic("AudioFocusManagement - CEV deafenAll")
				end
			end

			local function fn10()
				if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
					task.cancel(thread)
					thread = nil
				end

				if defineFastFlag5 and not fn7() or not fn7 then -- inferred equivalent call
					default2:MuteAll(false, "AudioFocusManagement - CEV Mute All")
				end

				if default2.localMuted == nil then
					v:info("CEV undeafenAll - Voice not connected yet - calling unmuteMicrophoneOnce")
					default2.muteChanged.Event:Once(function(p)
						if p ~= nil then
							fn2(function()
								default2:ToggleMic("BackgroundDM")
							end)
						end
					end)
				elseif
					default2.localMuted
					and (not defineFastFlag6 or v2.previousMutedState ~= default2.localMuted)
				then
					v:info("CEV undeafenAll - Voice connected and muted - unmuting immediately")
					default2:ToggleMic("AudioFocusManagement - CEV undeafenAll")
				end
			end

			result.OnDeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					if FIntPartyVoiceUndeafenDelayMS > 0 and thread then
						task.cancel(thread)
						thread = nil
					end

					v:info("CEV OnDeafenVoiceAudio fired" .. p)
					fn9()
				end
			end)

			result.OnUndeafenVoiceAudio:Connect(function(p)
				if p == CONTEXT_ID then
					v:info("CEV OnUndeafenVoiceAudio fired for context: {} - expected: {}", p, CONTEXT_ID)

					if FIntPartyVoiceUndeafenDelayMS > 0 then
						if thread then
							task.cancel(thread)
						end

						thread = task.delay(FIntPartyVoiceUndeafenDelayMS / 1000, function()
							thread = nil
							v:info("CEV OnUndeafenVoiceAudio fired delayed" .. p)
							fn10()
						end)
					else
						v:info("CEV OnUndeafenVoiceAudio fired" .. p)
						fn10()
					end
				end
			end)

			fn8(CONTEXT_ID, FOCUS_PRIORITY):andThen(function(p) -- inferred equivalent call
				if p then
					v:info("CEV audio focus request granted, preparing to undeafen.")
					default2.muteChanged.Event:Once(function(p2)
						if
							p2 ~= nil
							and defineFastFlag5
							and not (GetFFlagEnableCrossExperienceVoiceCaptureMute() and CaptureService and CaptureService:IsCapturingVideo())
							or not fn7
						then
							default2:MuteAll(false, "AudioFocusManagement CEV")
						end
					end)
				else
					v:info("CEV audio focus request denied, preparing to deafen.")
					default2.muteChanged.Event:Once(function(p2)
						if
							p2 ~= nil
							and defineFastFlag5
							and not (GetFFlagEnableCrossExperienceVoiceCaptureMute() and CaptureService and CaptureService:IsCapturingVideo())
							or not fn7
						then
							default2:MuteAll(true, "AudioFocusManagement CEV")
						end
					end)
				end
			end):catch(function()
				v:info("[CEV] Error requesting focus inside CEV")
			end)
		else
			v:info("AudioFocusService did not initialize")
		end
	end
end

function initializeVoice()
	notifyVoiceStatusChange(Constants.VOICE_STATUS.VOICE_CONNECTING) -- inferred equivalent call
	default2:asyncInit():andThen(function()
		if initializeDefaultChannel(false) == false then
			notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_JOIN, "Initial Join failed") -- inferred equivalent call
		else
			onCoreVoiceManagerInitialized()
		end

		initializeAFM()
	end):catch(function(p)
		v:info("CoreVoiceManager did not initialize {}", p)

		local detail = not p and "INIT_ERROR_UNKNOWN" or p.code or p

		notifyVoiceStatusChange(Constants.VOICE_STATUS.ERROR_VOICE_INIT, detail) -- inferred equivalent call
	end)
end

function rejoinVoice()
	notifyVoiceStatusChange(Constants.VOICE_STATUS.VOICE_CONNECTING) -- inferred equivalent call

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		default2:RejoinVoice()
	else
		default2:RejoinChannel(v2.previousGroupId, v2.previousMutedState)
	end

	v2 = { previousGroupId = nil, previousMutedState = nil }
end

function startVoice()
	if validateSetup() then
		if FStringTimeoutLoadingLocalPlayerInBackgroundDM ~= LOCAL_PLAYER_LOADING_TIMEOUT_ENUM.Disable then
			userId2 = ensureLocalPlayerWithTimeout()
			v:info("Delayed loading of LocalPlayer loaded with UserId: {}", userId2)
		end

		setupListeners()
		initializeVoice()
	end
end

eventManager:addObserver(CrossExperience.Constants.EVENTS.PARTY_VOICE_RECONNECT_REQUESTED, function()
	local voiceStatus = store:getState().Squad.CrossExperienceVoice.Experience.voiceStatus

	if voiceStatus == VOICE_STATUS.ERROR_VOICE_SETUP then
		startVoice()
	elseif
		voiceStatus == VOICE_STATUS.ERROR_VOICE_INIT
		or fFlagFixPartyVoiceGetPermissions and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
	then
		initializeVoice()
	elseif
		voiceStatus == VOICE_STATUS.ERROR_VOICE_JOIN
		or not fFlagFixPartyVoiceGetPermissions and voiceStatus == VOICE_STATUS.ERROR_VOICE_MIC_REJECTED
		or voiceStatus == VOICE_STATUS.ERROR_VOICE_MODERATED
		or voiceStatus == VOICE_STATUS.ERROR_VOICE_FAILED
		or voiceStatus == VOICE_STATUS.ERROR_VOICE_DISCONNECTED
	then
		rejoinVoice()
	end
end)
local flag3 = false
local function doStartVoice() -- 2 equivalent calls inferred from this helper
	if flag3 then
		return
	end

	flag3 = true

	if v3 then
		eventManager:removeObserver(v3, CrossExperience.Constants.EVENTS.FOREGROUND_UI_READY)
		v3 = nil
	end

	v:info("Proceeding to start voice connection.")
	startVoice()
end

sendAnalyticsEvent("startingVoiceFromCEVDefaultChannel")

if engineFeature4 then
	if flag then
		v:info("Foreground was ready before setup finished. Starting voice now.")
		doStartVoice() -- inferred equivalent call
	else
		v:info("Waiting for foreground UI readiness signal (with promise race)...")

		local v4 = {
			Promise.new(function(callback)
				bindableEvent.Event:Once(function()
					callback("signal")
				end)
			end),
			(Promise.delay(defineFastInt3):andThen(function(): string
				return "timeout"
			end))
		}
		Promise.race(v4):andThen(function(p)
			if p == "signal" then
				v:info("Readiness signal received within timeout.")
			else
				v:info("Timed out waiting for readiness signal. Starting voice anyway.")
				sendAnalyticsEvent("partyVoiceInitTimedOut", { timeout = defineFastInt3 })
			end

			doStartVoice() -- inferred equivalent call
		end)
	end
else
	v:info("Foreground UI not using readiness sync. Starting voice connection immediately.")
	startVoice()
end
