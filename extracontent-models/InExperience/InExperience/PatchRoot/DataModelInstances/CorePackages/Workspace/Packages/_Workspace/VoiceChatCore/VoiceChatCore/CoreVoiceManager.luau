local RunService = game:GetService("RunService")

local parent = script.Parent
local parent2 = parent.Parent

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local HttpService = game:GetService("HttpService")
local SharedFlags = require(parent2.SharedFlags)
local FFlagUseAudioDeviceInputAddedSignal = SharedFlags.FFlagUseAudioDeviceInputAddedSignal
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local AppStorageService = game:GetService("AppStorageService")
local NotificationService = game:GetService("NotificationService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local Players2 = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local AdService = game:GetService("AdService")
local Chat = game:GetService("Chat")

local Constants = require(script.Parent.Constants)
local Utils = require(script.Parent.Utils)
local Flags = script.Parent.Flags
local Analytics = require(script.Parent.Analytics)
local Requests = script.Parent.Requests

local Promise = require(parent2.Promise)
local Cryo = require(parent2.Cryo)
local CallProtocol = require(parent2.CallProtocol)
local default = CallProtocol.CallProtocol.default
local CallProtocol2 = require(parent2.CallProtocol)
local Enums = CallProtocol2.Enums
local PermissionsProtocol = require(parent2.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local BlockingUtility = require(parent2.BlockingUtility)

local CoreGui = game:GetService("CoreGui")

local CoreScriptsInitializer = require(parent2.CoreScriptsInitializer)
local log = CoreScriptsInitializer.CoreLogger:new(script.Name)

local defineFastFlag = game:DefineFastFlag("StringKeyFixForParticipantsTable", false)
local defineFastFlag2 = game:DefineFastFlag("ConsoleVoiceIXPEnabled", false)
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagExpChatDictation = SharedFlags2.FFlagExpChatDictation

local defineFastString = game:DefineFastString("ConsoleVoiceIXPLayerName", "User.Communication.ConsoleVoice")

local defineFastString2 = game:DefineFastString("ConsoleVoiceEnabledIXPLayerValue", "ConsoleVoiceEnabled")

local defineFastFlag3 = game:DefineFastFlag("SendVoiceCapturedDuringVideoCaptureEvent", false)

game:DefineFastInt("VoiceRewarmReArmCount", 0)

local SharedFlags3 = require(parent2.SharedFlags)
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags3.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagLuaConsumePlayerModerated = require(Flags.GetFFlagLuaConsumePlayerModerated)
local SharedFlags4 = require(parent2.SharedFlags)
local GetFFlagLocalMutedNilFix = SharedFlags4.GetFFlagLocalMutedNilFix
local GetFFlagEnableVoiceReverseNudge = require(Flags.GetFFlagEnableVoiceReverseNudge)
local GetFFlagClearUserFromRecentVoiceDataOnLeave = require(Flags.GetFFlagClearUserFromRecentVoiceDataOnLeave)
local GetFIntVoiceUsersInteractionExpiryTimeSeconds = require(Flags.GetFIntVoiceUsersInteractionExpiryTimeSeconds)
local SharedFlags5 = require(parent2.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags5.GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = require(Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat)
local SharedFlags6 = require(parent2.SharedFlags)
local GetFFlagJoinWithoutMicPermissions = SharedFlags6.GetFFlagJoinWithoutMicPermissions
local GetFFlagBatchVoiceParticipantsUpdates = require(Flags.GetFFlagBatchVoiceParticipantsUpdates)
local GetFIntThrottleParticipantsUpdateMs = require(Flags.GetFIntThrottleParticipantsUpdateMs)
local SharedFlags7 = require(parent2.SharedFlags)
local GetFFlagSeamlessVoiceFTUX = SharedFlags7.GetFFlagSeamlessVoiceFTUX
local GetFFlagEnableFtuxExitOnMuteToggle = require(Flags.GetFFlagEnableFtuxExitOnMuteToggle)
local GetFFlagEnableSeamlessVoiceFeature = require(Flags.GetFFlagEnableSeamlessVoiceFeature)
local GetFFlagFixGetPlayerByUserIdStringCast = require(Flags.GetFFlagFixGetPlayerByUserIdStringCast)
local SharedFlags8 = require(parent2.SharedFlags)
local fFlagDebugShowAudioDeviceInputDebugger = SharedFlags8.GetFFlagDebugShowAudioDeviceInputDebugger()

local defineFastString3 = game:DefineFastString("VoicePerformanceThrottlingIXPLayerName", "Voice.Performance")

local defineFastString4 = game:DefineFastString("ThrottleParticipantsUpdateIXPLayerValue", "ThrottleParticipantsUpdate")
local GetFFlagUseAudioAnalyzerForLocalMetering2 = require(Flags.GetFFlagUseAudioAnalyzerForLocalMetering2)
local fFlagUseAudioAnalyzerForLocalMetering2 = GetFFlagUseAudioAnalyzerForLocalMetering2()
local defineFastFlag4 = game:DefineFastFlag("StopModerationConnectionOnLeave", false)

local engineFeature = game:GetEngineFeature("VoiceVolumeControlsApplyGameSettingsVoiceVolume")

local defineFastFlag5 = game:DefineFastFlag("VoiceVolumeControlsEnableVoiceVolumeEligibilityTelemetry", false)

local GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = require(Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry)
local fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()
local VoiceVolumeControlsEligibility = require(parent.VoiceVolumeControlsEligibility)

local engineFeature2 = game:GetEngineFeature("EnableMutedByLocalUser")
local defineFastFlag6 = game:DefineFastFlag("VoiceChatMuteAllSyncMutedPlayers", false)

local engineFeature3 = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local SharedFlags9 = require(parent2.SharedFlags)
local GetFFlagEnableVoiceChatMuteForVideoCaptures = SharedFlags9.GetFFlagEnableVoiceChatMuteForVideoCaptures

local v = defineFastFlag3 and GetFFlagEnableVoiceChatMuteForVideoCaptures()
local GetFFlagDebugVoiceChatMicPermissionCliBypass = require(Flags.GetFFlagDebugVoiceChatMicPermissionCliBypass)

local SharedFlags10 = require(parent2.SharedFlags)
local GetFFlagEnableVoiceSignal = SharedFlags10.GetFFlagEnableVoiceSignal

local SharedFlags11 = require(parent2.SharedFlags)
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = SharedFlags11.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local SharedFlags12 = require(parent2.SharedFlags)
local GetFFlagVoiceChatClientRewriteMasterLua = SharedFlags12.GetFFlagVoiceChatClientRewriteMasterLua

local SharedFlags13 = require(parent2.SharedFlags)
local GetFFlagCheckUniversePlaceBeforeSuspending = SharedFlags13.GetFFlagCheckUniversePlaceBeforeSuspending
local SharedFlags14 = require(parent2.SharedFlags)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags14.FFlagEnablePartyVoiceChangersInLua
local FFlagSkipVoiceInTeamCreateViewer = require(Flags.FFlagSkipVoiceInTeamCreateViewer)
local GetFFlagCoreMicManagerRefactor = require(Flags.GetFFlagCoreMicManagerRefactor)
local GetFFlagMicConsumerRegistry = require(Flags.GetFFlagMicConsumerRegistry)
local MicInputManager

if GetFFlagCoreMicManagerRefactor() then
	MicInputManager = require(script.Parent.MicInputManager)
else
	MicInputManager = nil
end

local WATCHED_NAMESPACES = Constants.WATCHED_NAMESPACES
local WATCHED_MESSAGE_TYPES = Constants.WATCHED_MESSAGE_TYPES
local VOICE_CHAT_AVAILABILITY = Constants.VOICE_CHAT_AVAILABILITY
local MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED = Constants.MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED
local MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = Constants.MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY
local PERMISSION_STATE = Constants.PERMISSION_STATE
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local FAE_ENABLED = Constants.FAE_ENABLED
local FAE_SETTINGS_TOAST = Constants.FAE_SETTINGS_TOAST

local GetShowAgeVerificationOverlay = require(Requests.GetShowAgeVerificationOverlay)
local GetShowPhoneVerificationUpsell = require(Requests.GetShowPhoneVerificationUpsell)

local v2 = {
	eventName = "VoiceCapturedDuringVideoCapture",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("VoiceCapturedDuringVideoCaptureThrottlingPercentage", 10000),
	lastUpdated = { 26, 1, 28 },
	description = "Event fired when a video capture has stopped logging if voice was captured",
	links = ""
}
local AvatarChatService

if GetFFlagAvatarChatServiceEnabled() then
	AvatarChatService = game:GetService("AvatarChatService")
end

local CaptureService

if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
	CaptureService = game:GetService("CaptureService")
end

local TelemetryService

if v then
	TelemetryService = game:GetService("TelemetryService")
end

local CoreVoiceManager = {
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	["available"] = nil,
	available = nil,
	canUseServicePromise = nil,
	userEligible = false,
	participants = nil,
	localMuted = nil,
	isVoiceChangerActive = false,
	isVoiceChangerHearMyselfActive = false,
	currentVoicePack = nil,
	isTalking = false,
	previousGroupId = nil,
	muteAll = false,
	previousMutedState = nil,
	permissionPromise = nil,
	hasOptedToJoinVoiceOnAgeVerification = false
}
local permissionState

if GetFFlagJoinWithoutMicPermissions() then
	permissionState = PERMISSION_STATE.IDLE
end

CoreVoiceManager.permissionState = permissionState
CoreVoiceManager.recentUsersInteractionData = nil
CoreVoiceManager.NotificationService = NotificationService
CoreVoiceManager.PermissionsService = permissionsProtocol.default
CoreVoiceManager.ChatService = Chat
CoreVoiceManager.voiceEnabled = false
CoreVoiceManager.service = nil
CoreVoiceManager.SignalREventTable = {}
CoreVoiceManager.isInCall = false
CoreVoiceManager.callMutedState = false
CoreVoiceManager.audioDeviceInputAdded = nil
CoreVoiceManager.muteChanged = Instance.new("BindableEvent")
CoreVoiceManager.voiceChangerChanged = Instance.new("BindableEvent")
CoreVoiceManager.voiceChangerHearMyselfChanged = Instance.new("BindableEvent")
CoreVoiceManager.muteAllChanged = Instance.new("BindableEvent")
CoreVoiceManager.participantLeft = Instance.new("BindableEvent")
CoreVoiceManager.participantJoined = Instance.new("BindableEvent")
CoreVoiceManager.participantsUpdate = Instance.new("BindableEvent")
CoreVoiceManager.talkingChanged = Instance.new("BindableEvent")
CoreVoiceManager.attemptVoiceRejoin = Instance.new("BindableEvent")
CoreVoiceManager.onPlayerMuteToggled = Instance.new("BindableEvent")
CoreVoiceManager.setVoiceUIVisibility = Instance.new("BindableEvent")
CoreVoiceManager.communicationPermissionsResult = nil
CoreVoiceManager.VoiceJoinProgress = VOICE_JOIN_PROGRESS.Idle
CoreVoiceManager.VoiceJoinProgressChanged = Instance.new("BindableEvent")
CoreVoiceManager._voiceVolumeEligibilityReported = false
CoreVoiceManager.mutedPlayers = {}
CoreVoiceManager.voiceChangerActivePlayers = {}
CoreVoiceManager.BlockStatusChanged = nil
CoreVoiceManager.AvatarChatService = AvatarChatService
CoreVoiceManager.HttpRbxApiService = HttpRbxApiService
CoreVoiceManager.ThirdPartyUserService = ThirdPartyUserService
CoreVoiceManager.CaptureService = CaptureService
CoreVoiceManager.TelemetryService = TelemetryService
CoreVoiceManager.SendMuteEvent = nil
CoreVoiceManager.SetVoicePackEvent = nil
CoreVoiceManager.VoiceChangerWasToggledEvent = nil
CoreVoiceManager.InputToModifierWire = nil
CoreVoiceManager.PartyVoiceDeviceInput = nil
CoreVoiceManager._mutedAnyone = false
CoreVoiceManager.canUseServiceResult = nil
CoreVoiceManager.signalRConnectionChanged = nil
CoreVoiceManager.signalRConnection = nil
CoreVoiceManager.AdService = AdService
CoreVoiceManager.isPlayerWatchingAd = false
CoreVoiceManager.options = {
	allowSeamlessVoice = true,
	passInitErrorInPromiseReject = false,
	forceVoiceEnabled = false
}

CoreVoiceManager.initializedPostSuspension = false
CoreVoiceManager.voiceCapturedDuringVideoCapture = false
CoreVoiceManager._voiceJoinTimestampMs = nil
CoreVoiceManager._voiceVolumeSliderEligibleAtJoin = false
CoreVoiceManager._gameSettingsOpenedTimestampMs = nil

local v3 = { localMuted = true, isTalking = true, permissionState = true }

function CoreVoiceManager.__index(p, p2)
	if GetFFlagCoreMicManagerRefactor() then
		local v4 = rawget(p, "micManager")

		if v4 and v3[p2] then
			return v4[p2]
		end
	end

	return CoreVoiceManager[p2]
end

function CoreVoiceManager.__newindex(p, p2, p3)
	if GetFFlagCoreMicManagerRefactor() then
		local v4 = rawget(p, "micManager")

		if v4 and v3[p2] then
			v4[p2] = p3
			return
		end
	end

	rawset(p, p2, p3)
end

function CoreVoiceManager.new(blockStatusChanged, permissionsService, httpRbxApiService, service, p, notificationService, avatarChatService, p2, thirdPartyUserService, captureService, adService)
	local object = setmetatable({
		previousSessionId = nil,
		HttpRbxApiService = httpRbxApiService,
		eventEmitter = Utils.EventEmitter.new(),
		service = service,
		PermissionsService = permissionsService,
		NotificationService = notificationService,
		AvatarChatService = avatarChatService,
		Analytics = Analytics.new(p),
		SequenceNumbers = {},
		SignalREventTable = {},
		audioDevices = {},
		BlockStatusChanged = blockStatusChanged,
		AppStorageService = p2 or AppStorageService,
		ThirdPartyUserService = thirdPartyUserService,
		CaptureService = captureService,
		AdService = adService
	}, CoreVoiceManager)

	for _, v4 in WATCHED_MESSAGE_TYPES do
		object.SignalREventTable[v4] = Instance.new("BindableEvent")
	end

	object.shouldThrottleParticipantUpdate = false
	object.participantsStateThrottleTime = 0
	object.lastParticipantsStateUpdate = 0
	object.lastStateUpdateCounter = 0

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		task.spawn(function()
			local success, result = pcall(function()
				if Players2.LocalPlayer then
					return service:IsVoiceEnabledForUserIdAsync(Players2.LocalPlayer.UserId)
				end

				return false
			end)

			if not success then
				log:debug("Unable to get voice enabled status: ", result)
			elseif result then
				ixpServiceWrapper:LogUserLayerExposure(defineFastString3)
			end
		end)
		object.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000
		local success, result = pcall(function()
			return ixpServiceWrapper:GetLayerData(defineFastString3)
		end)

		if success and result and result[defineFastString4] then
			object.shouldThrottleParticipantUpdate = true
		end
	end

	if not GetFFlagCoreMicManagerRefactor() then
		return object
	end

	object.micManager = MicInputManager.new({
		log = log,
		callbacks = {
			emitGetPermissions = function(p3, p4, p5, p6)
				object:emit("GetPermissions", p3, p4, p5, p6)
			end,
			emitOnPermissionRequested = function()
				object:emit("OnPermissionRequested")
			end,
			emitOnRequestMicPermissionResolved = function()
				object:emit("OnRequestMicPermissionResolved")
			end,
			emitOnRequestMicPermissionRejected = function()
				object:emit("OnRequestMicPermissionRejected")
			end,
			emitOnShowDataConsentToast = function()
				object:emit("OnShowDataConsentToast")
			end,
			emitOnMicPermissionDeniedToast = function()
				object:emit("OnMicPermissionDeniedToast")
			end,
			emitOnMicFirstUnmutePrivacy = function()
				object:emit("OnMicFirstUnmutePrivacy")
			end,
			getAudioDevices = function()
				return object.audioDevices
			end,
			getSendMuteEvent = function()
				return object:GetSendMuteEvent()
			end,
			isSignalActive = function(p3)
				return object:IsSignalActive(p3)
			end,
			reportVoiceMuteSelf = function(self)
				object.Analytics:reportVoiceMuteSelf(self)
			end,
			getJoinWithVoiceMuteData = function(p3)
				return object:JoinWithVoiceMuteData(p3)
			end,
			recordExperienceJoinMicPerm = function(p3)
				object:RecordExperienceJoinMicPermissionStatus(p3)
			end,
			reportJoinFailed = function(p3, p4)
				object:_reportJoinFailed(p3, p4 or Analytics.ERROR)
			end,
			requestPermissions = function(self)
				return object.PermissionsService:requestPermissions(self)
			end,
			getPassInitErrorInPromiseReject = function()
				return object.options.passInitErrorInPromiseReject
			end,
			onVoiceCapturedDuringVideoCapture = function(p3)
				if v and object.CaptureService:IsCapturingVideo() then
					object.voiceCapturedDuringVideoCapture = object.voiceCapturedDuringVideoCapture or p3
				end
			end,
			getService = function()
				return object.service
			end
		}
	})

	object.muteChanged = object.micManager.muteChanged
	object.talkingChanged = object.micManager.talkingChanged

	if GetFFlagMicConsumerRegistry() then
		object.hasConsumersChanged = object.micManager.hasConsumersChanged
		object.micManager:SetupDeveloperDeviceTracking()
	end

	return object
end

function CoreVoiceManager:emit(p: string, ...)
	self.eventEmitter:emit(p, ...)
end

function CoreVoiceManager.subscribe(p, p2: string, p3)
	p.eventEmitter:addListener(p2, p3)
end

function CoreVoiceManager.unsubscribe(p, p2: string, p3)
	p.eventEmitter:removeListener(p2, p3)
end

function CoreVoiceManager.unsubscribeAll(p)
	p.eventEmitter:removeAllListeners()
end

function CoreVoiceManager:CheckCallStateWithPromise()
	return default:getCallState():andThen(function(p)
		log:trace("Got user call state")

		if p.status ~= Enums.CallStatus.Idle.rawValue() and p.status ~= Enums.CallStatus.Ringing.rawValue() then
			self.isInCall = true
			self.callMutedState = p.muted
			log:trace("Changing call muted state to {}", p.muted)
		end
	end):catch(function(p)
		log:trace("User not in call {}", p)
	end)
end

function CoreVoiceManager:CheckCallState()
	log:trace("Checking user call state")
	local success, result = pcall(function()
		default:getCallState():andThen(function(p)
			log:trace("Got user call state")

			if p.status ~= Enums.CallStatus.Idle.rawValue() and p.status ~= Enums.CallStatus.Ringing.rawValue() then
				self.isInCall = true
				self.callMutedState = p.muted
				log:trace("Changing call muted state to {}", p.muted)
			end
		end):catch(function(p)
			log:trace("User not in call {}", p)
		end)
	end)

	if not success then
		log:debug("Error checking user call state {}", result)
	end
end

function CoreVoiceManager:_GetShowAgeVerificationOverlay(p)
	return GetShowAgeVerificationOverlay(
		Utils.bind(self, "GetRequest"),
		tostring(game.GameId),
		tostring(game.PlaceId),
		p
	)
end

function CoreVoiceManager:FetchAgeVerificationOverlay(p)
	if not self._getShowAgeVerificationOverlayResult then
		if not self._getShowAgeVerificationOverlayPromise then
			self._getShowAgeVerificationOverlayPromise = Promise.new(function(callback, _)
				self._getShowAgeVerificationOverlayResult = self:_GetShowAgeVerificationOverlay(p)
				callback(self._getShowAgeVerificationOverlayResult)
			end)
		end

		self._getShowAgeVerificationOverlayPromise:await()
	end

	return self._getShowAgeVerificationOverlayResult
end

function CoreVoiceManager:_GetShowPhoneVerificationUpsell(p: string, p2: number?)
	return (GetShowPhoneVerificationUpsell(Utils.bind(self, "GetRequest"), tostring(game.GameId), p, p2))
end

function CoreVoiceManager:FetchPhoneVerificationUpsell(p: string, p2: number?, flag: boolean?)
	if not self._getShowPhoneVerificationUpsellResult then
		self._getShowPhoneVerificationUpsellResult = {}
		self._getShowPhoneVerificationUpsellPromise = {}
	end

	if not self._getShowPhoneVerificationUpsellResult[p] or flag then
		if not self._getShowPhoneVerificationUpsellPromise[p] or flag then
			self._getShowPhoneVerificationUpsellPromise[p] = Promise.new(function(callback, _)
				local showPhoneVerificationUpsell = self:_GetShowPhoneVerificationUpsell(p, p2)
				local getShowPhoneVerificationUpsellResult = self._getShowPhoneVerificationUpsellResult
				local v4

				if type(showPhoneVerificationUpsell) == "table" and showPhoneVerificationUpsell.valueProp ~= nil then
					v4 = showPhoneVerificationUpsell.valueProp
				else
					v4 = Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
				end

				getShowPhoneVerificationUpsellResult[p] = v4

				callback()
			end)
		end

		self._getShowPhoneVerificationUpsellPromise[p]:await()
	end

	return self._getShowPhoneVerificationUpsellResult[p]
end

function CoreVoiceManager:DisablePhoneVerificationUpsell()
	self._getShowPhoneVerificationUpsellResult = Cryo.Dictionary.map(
		self._getShowPhoneVerificationUpsellResult,
		function()
			return Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
		end
	)
end

function CoreVoiceManager:GetNudgeAnalyticsData()
	return Players.LocalPlayer.UserId, self:GetSessionId()
end

function CoreVoiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p)
	local universePlaceVoiceEnabledSettings = {
		isUniverseEnabledForVoice = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UniverseAudio),
		isPlaceEnabledForVoice = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.PlaceAudio),
		isUniverseEnabledForAvatarVideo = self.AvatarChatService:IsEnabled(
			p,
			Enum.AvatarChatServiceFeature.UniverseVideo
		),
		isPlaceEnabledForAvatarVideo = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.PlaceVideo)
	}

	local voiceSettings = {
		isUserEligible = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserAudioEligible),
		isVoiceEnabled = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserAudio),
		isAvatarVideoEligible = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserVideoEligible),
		isAvatarVideoEnabled = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserVideo),
		isUserVerifiedForVoice = 0,
		isBanned = 0,
		bannedUntil = nil
	}
	local isUserVerifiedForVoice

	if GetFFlagEnableVoiceSignal() then
		isUserVerifiedForVoice = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserVerifiedForVoice)
	end

	voiceSettings.isUserVerifiedForVoice = isUserVerifiedForVoice

	voiceSettings.isBanned = self.AvatarChatService:IsEnabled(p, Enum.AvatarChatServiceFeature.UserBanned)

	return {
		universePlaceVoiceEnabledSettings = universePlaceVoiceEnabledSettings,
		voiceSettings = voiceSettings
	}
end

function CoreVoiceManager:resolveAvatarChatUserAndPlaceSettings()
	local success, clientFeaturesAsync = pcall(self.AvatarChatService.GetClientFeaturesAsync, self.AvatarChatService)

	if success then
		return self:avatarChatUserAndPlaceSettingsValueOfClientFeatures(clientFeaturesAsync)
	end

	return nil
end

function CoreVoiceManager.GetRequest(p, p2, _)
	local success, result = pcall(function()
		return HttpService:JSONDecode((p.HttpRbxApiService:GetAsyncFullUrl(
			p2,
			Enum.ThrottlingPriority.Default,
			Enum.HttpRequestType.Players
		)))
	end)

	return success and result
end

function CoreVoiceManager.PostUserVoiceConnectionStatus(p, isUserVoiceConnected)
	local success, _ = pcall(function()
		local jsonEncode = HttpService:JSONEncode({ IsUserVoiceConnected = isUserVoiceConnected })

		return HttpService:JSONDecode((p.HttpRbxApiService:PostAsyncFullUrl(
			Constants.VOICE_URL .. "/v1/user-voice-connection-state",
			jsonEncode
		)))
	end)

	return success
end

function CoreVoiceManager:GetVoiceAnalyticsData()
	return {
		universeId = game.GameId,
		placeId = game.PlaceId,
		playSessionId = not engineFeature3 and "" or RbxAnalyticsService:GetPlaySessionId(),
		voiceSessionId = not self.service and "" or self:GetSessionId(),
		micAvailability = ""
	}
end

function CoreVoiceManager:RecordExperienceJoinMicPermissionStatus(p)
	local voiceAnalyticsData = self:GetVoiceAnalyticsData()

	if p == nil or typeof(p) ~= "table" then
		if self.permissionState then
			if self.permissionState == PERMISSION_STATE.LISTEN_AND_TALK then
				voiceAnalyticsData.micAvailability = "Granted"
			else
				voiceAnalyticsData.micAvailability = "Denied"
			end
		end
	elseif p.status == permissionsProtocol.Status.AUTHORIZED then
		voiceAnalyticsData.micAvailability = "Granted"
	else
		voiceAnalyticsData.micAvailability = "Denied"
	end

	self.Analytics:reportVoiceEvents("experienceJoinDeviceMicPermissionEvent", voiceAnalyticsData)
end

function CoreVoiceManager:CheckCaptureMute()
	if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
		return self.CaptureService:IsCapturingVideo()
	end

	return false
end

function CoreVoiceManager:ToggleMuteSome(items, flag: boolean, groupType: string, context: string)
	self:ensureInitialized("mute some players")
	self._mutedAnyone = true

	local v4 = flag or self:CheckCaptureMute()
	local set = {}

	for _, item in items do
		if VoiceChatService.UseNewAudioApi then
			set[item] = true
			self.mutedPlayers[item] = v4
		else
			self.service:SubscribePause(item, v4)
		end

		local participant = self.participants[tostring(item)]

		if not participant then
			continue
		end

		participant.isMutedLocally = v4
		self.participantsUpdate:Fire(self.participants)
	end

	if VoiceChatService.UseNewAudioApi then
		for k in self.audioDevices do
			if not (k.Player and set[k.Player.UserId]) then
				continue
			end

			if engineFeature2 and k.Player ~= Players.LocalPlayer then
				k.MutedByLocalUser = v4
			else
				k.Active = not v4
			end
		end
	end

	if groupType and context then
		self.Analytics:reportVoiceMuteGroup((self:JoinWithVoiceMuteData({
			groupType = groupType,
			context = context,
			muted = v4
		})))
	end
end

function CoreVoiceManager:GetMutedAnyone()
	return self._mutedAnyone
end

function CoreVoiceManager:RecordGameSettingsOpened()
	if
		fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry
		and engineFeature
		and self._voiceJoinTimestampMs
		and not self._gameSettingsOpenedTimestampMs
	then
		self._gameSettingsOpenedTimestampMs = DateTime.now().UnixTimestampMillis
	end
end

function CoreVoiceManager:ResetVoiceVolumeImpressionsSession()
	if fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry and engineFeature then
		self._voiceJoinTimestampMs = nil
		self._voiceVolumeSliderEligibleAtJoin = false
		self._gameSettingsOpenedTimestampMs = nil
	end
end

function CoreVoiceManager:ReportVoiceVolumeImpressionsIfNeeded()
	if not (fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry and engineFeature and self._voiceJoinTimestampMs and self._voiceVolumeSliderEligibleAtJoin) then
		return
	end

	local sliderSeen = self._gameSettingsOpenedTimestampMs ~= nil
	local voiceAnalyticsData = self:GetVoiceAnalyticsData()
	self.Analytics:reportVoiceVolumeImpressions({
		playSessionId = voiceAnalyticsData.playSessionId,
		voiceSessionId = voiceAnalyticsData.voiceSessionId,
		sliderSeen = sliderSeen,
		voiceJoinTimestampMs = self._voiceJoinTimestampMs,
		sliderSeenTimestampMs = self._gameSettingsOpenedTimestampMs
	})

	self:ResetVoiceVolumeImpressionsSession()
end

function CoreVoiceManager:ToggleMutePlayer(p: number, context: string)
	self:ensureInitialized("mute player " .. p)
	self._mutedAnyone = true
	local v4

	if VoiceChatService.UseNewAudioApi then
		v4 = not self.mutedPlayers[p]
	else
		v4 = not self.service:IsSubscribePaused(p)
	end

	local v5 = v4 or self:CheckCaptureMute()
	log:trace("Setting mute for {} to {}", Utils.shorten(p), v5)

	if GetFFlagEnableFtuxExitOnMuteToggle() then
		self.onPlayerMuteToggled:Fire()
	end

	if VoiceChatService.UseNewAudioApi then
		self.mutedPlayers[p] = v5

		for k in self.audioDevices do
			if not (k.Player and k.Player.UserId == p) then
				continue
			end

			if engineFeature2 and k.Player ~= Players.LocalPlayer then
				k.MutedByLocalUser = v5
			else
				local participant = self.participants[tostring(p)]
				local active = participant and not participant.isMuted

				if v5 then
					active = false
				end

				k.Active = active
			end
		end

		self:emit("OnPlayerMuted")
	else
		self.service:SubscribePause(p, v5)
	end

	for _, participant in pairs(self.participants) do
		if participant.userId ~= p then
			continue
		end

		participant.isMutedLocally = v5
		self.participantsUpdate:Fire(self.participants)
	end

	if context then
		self.Analytics:reportVoiceMuteIndividual((self:JoinWithVoiceMuteData({
			targetUserId = tonumber(p),
			context = context,
			muted = v5
		})))
	end
end

function CoreVoiceManager:MuteAll(flag: boolean, context: string)
	self:ensureInitialized("mute all")
	self._mutedAnyone = true
	flag = flag or self:CheckCaptureMute()

	if VoiceChatService.UseNewAudioApi then
		self.muteAll = flag
		log:trace("Setting self mute all to {} context: {}", flag, context)

		if defineFastFlag6 and not flag then
			table.clear(self.mutedPlayers)
		end

		for k in self.audioDevices do
			if not (k.Player and k.Player ~= Players.LocalPlayer) then
				continue
			end

			log:debug("Local muting {} to '{} = {}'", k.Player.Name, k.Active, flag)

			if engineFeature2 then
				k.MutedByLocalUser = flag

				if defineFastFlag6 then
					self.mutedPlayers[k.Player.UserId] = flag
				end
			else
				local userId = k.Player.UserId
				self.mutedPlayers[userId] = flag
				local participant = self.participants[tostring(userId)]
				local active = participant and not participant.isMuted

				if flag then
					active = false
				end

				k.Active = active
			end
		end
	else
		self.service:SubscribePauseAll(flag)
	end

	for _, participant in pairs(self.participants) do
		participant.isMutedLocally = flag
		self.participantsUpdate:Fire(self.participants)
	end

	self.muteAllChanged:Fire(flag)

	if context then
		self.Analytics:reportVoiceMuteGroup((self:JoinWithVoiceMuteData({
			groupType = Constants.VOICE_GROUP_TYPE.ALL,
			context = context,
			muted = flag
		})))
	end
end

function CoreVoiceManager:FetchVoicePermissions()
	if not self.communicationPermissionsResult then
		self.communicationPermissionsResult = self:resolveAvatarChatUserAndPlaceSettings()
	end

	return self.communicationPermissionsResult
end

function CoreVoiceManager:verifyUniverseAndPlaceCanUseVoice()
	local v4

	if GetFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() then
		v4 = self:resolveAvatarChatUserAndPlaceSettings()
	else
		v4 = self:FetchAgeVerificationOverlay()
	end

	if v4 then
		local universePlaceVoiceEnabledSettings = v4.universePlaceVoiceEnabledSettings

		return universePlaceVoiceEnabledSettings
			and universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
			and universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice
	end

	self:_reportJoinFailed("invalidResponse", Analytics.ERROR)
	return false
end

function CoreVoiceManager:IsUserInFTUX(): boolean
	if
		not GetFFlagSeamlessVoiceFTUX()
		or GetFFlagCheckUniversePlaceBeforeSuspending() and not self:verifyUniverseAndPlaceCanUseVoice()
	then
		return false
	end

	local AppStorageService2 = game:GetService("AppStorageService")
	local v4 = nil

	if not pcall(function()
		v4 = AppStorageService2:GetItem("SeamlessVoiceFTUX") == "true"
	end) then
		log:warning("Failed to read FTUX/STUX from AppStorage")
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if
		type(ageVerificationOverlay) ~= "table"
		or not ageVerificationOverlay.voiceSettings
		or ageVerificationOverlay.voiceSettings.seamlessVoiceStatus == 3
	then
		return not v4
	end

	log:debug("User not eligible for FTUX/STUX")
	return false
end

function CoreVoiceManager:isEnableDefaultVoiceOnForPlace()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	return VoiceChatService.UseNewAudioApi or VoiceChatService.EnableDefaultVoice
end

function CoreVoiceManager:verifyPlaceCanUseVoice(p, p2): boolean
	if not (p and p2) then
		self:_reportJoinFailed("invalidResponse", Analytics.ERROR)
		return false
	end

	if not p.isUniverseEnabledForVoice then
		self:_reportJoinFailed("universeNotEnabled")
		return false
	end

	self:emit("OnUserAndPlaceCanUseVoiceResolved", p2, p)

	if not p.isPlaceEnabledForVoice then
		self:_reportJoinFailed("placeNotEnabled")
		return false
	end

	return if self:isEnableDefaultVoiceOnForPlace() then true else false
end

function CoreVoiceManager:EligibleForFaeUpsell()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay or type(ageVerificationOverlay) ~= "table" then
		return false
	end

	local v4 = ageVerificationOverlay.inExperienceFaeUpsell == FAE_ENABLED
	local isPlaceEnabledForVoice = ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	return v4 and isPlaceEnabledForVoice
end

function CoreVoiceManager:OptUserToJoinVoice()
	log:debug("Opting user to join voice on age verification")
	self.hasOptedToJoinVoiceOnAgeVerification = true
end

function CoreVoiceManager:SetupFAECompleteListener()
	log:debug("Setting up FAE complete listener")

	if game:GetEngineFeature("ChatReconcileAccess") then
		log:debug("Using ChatService ReconcileCommunicationAccessCompleted event")
		self.ChatService.ReconcileCommunicationAccessCompleted:Connect(function()
			log:debug("FAE complete listener triggered, re-fetching voice permissions")

			self.communicationPermissionsResult = nil
			self:FetchVoicePermissions()
			self._getShowAgeVerificationOverlayResult = self:_GetShowAgeVerificationOverlay()

			if self.hasOptedToJoinVoiceOnAgeVerification then
				log:debug("FAE complete listener triggered, attempting voice rejoin")

				if self:IsSeamlessVoice() then
					log:debug("Opting-in user to voice")
					self.AvatarChatService:EnableVoice()
					self.attemptVoiceRejoin:Fire()
				end
			end
		end)
	end
end

function CoreVoiceManager:EligibleForAgeCheckToast()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay or type(ageVerificationOverlay) ~= "table" then
		return false
	end

	local isPlaceEnabledForVoice = ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	local v4 = ageVerificationOverlay.inExperienceFaeUpsell == FAE_SETTINGS_TOAST
	return isPlaceEnabledForVoice and self:isEnableDefaultVoiceOnForPlace() and v4
end

function CoreVoiceManager:userAndPlaceCanUseVoice()
	if
		self.ThirdPartyUserService ~= nil
		and self.ThirdPartyUserService:IsChatRestrictionSupported()
		and self.ThirdPartyUserService:GetVoiceChatRestrictionStatus() ~= Enum.ChatRestrictionStatus.NotRestricted
	then
		return false
	end

	local communicationPermissionsResult

	if GetFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() then
		communicationPermissionsResult = self:resolveAvatarChatUserAndPlaceSettings()
	else
		communicationPermissionsResult = GetShowAgeVerificationOverlay(
			Utils.bind(self, "GetRequest"),
			tostring(game.GameId),
			(tostring(game.PlaceId))
		)
	end

	if not communicationPermissionsResult then
		self:_reportJoinFailed("invalidResponse", Analytics.ERROR)
		return false
	end

	if self.options.forceVoiceEnabled then
		communicationPermissionsResult.voiceSettings.isVoiceEnabled = true
		log:debug("bypassing voice permissions check")
	end

	local universePlaceVoiceEnabledSettings = communicationPermissionsResult.universePlaceVoiceEnabledSettings
	local voiceSettings = communicationPermissionsResult.voiceSettings
	log:trace("Voice settings endpoint returned {}", communicationPermissionsResult)

	if not self:verifyPlaceCanUseVoice(universePlaceVoiceEnabledSettings, voiceSettings) then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		self.communicationPermissionsResult = communicationPermissionsResult
		local now = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and os.time()

		local v4 = GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints()
			and not self:UserVoiceEnabled()
			and not voiceSettings.isUserVerifiedForVoice
			and (self:FetchPhoneVerificationUpsell(Constants.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat or now and self:FetchPhoneVerificationUpsell(
				Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER,
				now
			) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat)

		if self:UserEligibleForInExperienceUpsell() or v4 then
			self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		end

		local voiceConnectCookie = self:GetVoiceConnectCookie()
		local v5 = self:HasSeamlessVoiceFeature(Constants.SeamlessVoiceFeatures.DeferConnection)
			and voiceConnectCookie == ""

		local v6 = self:IsSeamlessVoice() and voiceConnectCookie == "false"

		if v5 or v6 then
			self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		elseif self:EligibleForFaeUpsell() then
			log:debug("Suspending voice join for FAE Eligible user")
			self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
			self:SetupFAECompleteListener()
		end

		task.spawn(function()
			self:FetchAgeVerificationOverlay()
		end)
	end

	if not voiceSettings.isVoiceEnabled then
		self:_reportJoinFailed("userNotEnabled")
	end

	return voiceSettings.isVoiceEnabled
end

function CoreVoiceManager.voicePermissionGranted(_, p): boolean
	if typeof(p) == "table" then
		return p.status == permissionsProtocol.Status.AUTHORIZED
			or not Cryo.List.find(p.missingPermissions, permissionsProtocol.Permissions.MICROPHONE_ACCESS)
	end

	return p == permissionsProtocol.Status.AUTHORIZED
end

function CoreVoiceManager:RawGetPermissions(p)
	return Promise.new(function(callback, _)
		self:emit("GetPermissions", function(p2)
			callback(p2)
		end, p, true, true)
	end)
end

function CoreVoiceManager:requestMicPermission()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:RequestMicPermission()
	end

	if GetFFlagDebugVoiceChatMicPermissionCliBypass() then
		self.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
		return Promise.resolve()
	end

	if self.permissionPromise then
		log:trace("PermissionProtocol already invoked")

		return self.permissionPromise
	end

	local v4 = { permissionsProtocol.Permissions.MICROPHONE_ACCESS }

	self.permissionPromise = self.PermissionsService:requestPermissions(v4):andThen(function(p)
		self:RecordExperienceJoinMicPermissionStatus(p)

		if p or p.status then
			log:debug("Permission status {}", p.status)

			local v5 = p.status == permissionsProtocol.Status.AUTHORIZED

			if self.options.passInitErrorInPromiseReject and not v5 then
				return Promise.reject({ code = "INIT_ERROR_PERM_NOT_GRANTED" })
			end

			return v5 and Promise.resolve() or Promise.reject()
		end

		log:debug("No permission response, rejecting access")
		self:_reportJoinFailed("noPermissionResponse", Analytics.ERROR)

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_NO_PERM_RESPONSE" })
		end

		return Promise.reject()
	end):andThen(function()
		self:emit("OnRequestMicPermissionResolved")
		return Promise.resolve()
	end):catch(function()
		self:emit("OnRequestMicPermissionRejected")

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_MIC_PERM_REJECTED" })
		end

		return Promise.reject()
	end)

	return self.permissionPromise
end

function CoreVoiceManager:JoinByGroupIdToken(previousGroupId, previousMutedState)
	self.previousGroupId = previousGroupId
	self.previousMutedState = previousMutedState
	return self.service:JoinByGroupIdToken(previousGroupId, previousMutedState)
end

function CoreVoiceManager:EnableVoice()
	log:trace("Enabling voice")

	self.AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Once(function()
		self.attemptVoiceRejoin:Fire()
	end)
	self.AvatarChatService:EnableVoice()
end

function CoreVoiceManager:ChangeVoiceJoinProgress(voiceJoinProgress)
	self.VoiceJoinProgress = voiceJoinProgress
	self.VoiceJoinProgressChanged:Fire(self.VoiceJoinProgress)
end

function CoreVoiceManager:setOptions(options)
	self.options = options
end

function CoreVoiceManager:ShouldShowJoinVoiceOnDisconnect()
	return self:IsSeamlessVoice() and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
end

function CoreVoiceManager:IsSeamlessVoice(): boolean
	if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and not self.options.allowSeamlessVoice then
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if
		type(ageVerificationOverlay) ~= "table"
		or not (ageVerificationOverlay and ageVerificationOverlay.voiceSettings)
		or GetFFlagCheckUniversePlaceBeforeSuspending() and not self:verifyUniverseAndPlaceCanUseVoice()
	then
		return false
	end

	local seamlessVoiceStatus = ageVerificationOverlay.voiceSettings.seamlessVoiceStatus
	return seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledExistingUser
		or seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser
end

function CoreVoiceManager:HasSeamlessVoiceFeature(value)
	if not (self.options.allowSeamlessVoice and self:verifyUniverseAndPlaceCanUseVoice()) then
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not self:_isValidAgeVerificationOverlayData(ageVerificationOverlay) then
		return false
	end

	local seamlessVoiceVariant = ageVerificationOverlay.voiceSettings.seamlessVoiceVariant

	if not seamlessVoiceVariant then
		return false
	end

	if GetFFlagEnableSeamlessVoiceFeature() then
		local v4 = type(value) == "string" and { value } or value

		if GetFFlagEnableSeamlessVoiceFeature(v4) then
			local jsonDecode = Utils.jsonDecode(seamlessVoiceVariant)
			local set = {}

			for _, v5 in pairs(jsonDecode) do
				set[v5] = true
			end

			if
				#v4 == 1
				and v4[1] == Constants.SeamlessVoiceFeatures.ConnectDisconnect
				and seamlessVoiceVariant == Constants.SeamlessVoiceVariants.OnlyConnectDisconnect
			then
				return true
			end

			for _, v5 in pairs(v4) do
				if not set[v5] then
					return false
				end
			end

			return true
		end
	else
		local v4 = ({
			[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function(p): boolean
				return p ~= Constants.SeamlessVoiceVariants.Control
			end,
			[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function(p): boolean
				return p == Constants.SeamlessVoiceVariants.HearingWithoutMicPermissions
			end
		})[value]

		if v4 then
			return v4(seamlessVoiceVariant)
		end
	end

	return false
end

function CoreVoiceManager:IsNewSeamlessVoiceUserDisconnect()
	if not (self.options.allowSeamlessVoice and self:verifyUniverseAndPlaceCanUseVoice()) then
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not (self:_isValidAgeVerificationOverlayData(ageVerificationOverlay) and ageVerificationOverlay.voiceSettings.seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser) then
		return false
	end

	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.SEAMLESS_VOICE_FTUX_KEY)
	end)

	return success and result == "false"
end

function CoreVoiceManager:_isValidAgeVerificationOverlayData(p)
	return type(p) == "table" and p and p.voiceSettings
end

function CoreVoiceManager:UserInInExperienceUpsellTreatment(): boolean
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay then
		return false
	end

	local showVoiceInExperienceUpsellVariant = ageVerificationOverlay.showVoiceInExperienceUpsellVariant
	return showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT1
		or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT2
		or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT3
end

function CoreVoiceManager:UserOnlyEligibleForVoice()
	local communicationPermissionsResult = self.communicationPermissionsResult

	if not (communicationPermissionsResult and communicationPermissionsResult.voiceSettings and communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		self:FetchVoicePermissions()
		communicationPermissionsResult = self.communicationPermissionsResult
	end

	return communicationPermissionsResult.voiceSettings.isUserVerifiedForVoice
		and not communicationPermissionsResult.voiceSettings.isVoiceEnabled
		and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
end

function CoreVoiceManager:UserOnlyEligibleForVoiceViaOverlay()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if self:_isValidAgeVerificationOverlayData(ageVerificationOverlay) then
		return ageVerificationOverlay.voiceSettings.isVerifiedForVoice
			and not ageVerificationOverlay.voiceSettings.isVoiceEnabled
			and ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	end

	return false
end

function CoreVoiceManager:UserVoiceEnabled()
	local communicationPermissionsResult = self.communicationPermissionsResult

	if
		communicationPermissionsResult
		and communicationPermissionsResult.voiceSettings
		and communicationPermissionsResult.universePlaceVoiceEnabledSettings
	then
		return communicationPermissionsResult.voiceSettings.isVoiceEnabled
			and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	end

	return false
end

function CoreVoiceManager:UserEligibleForInExperienceUpsell()
	local userOnlyEligibleForVoice = self:UserOnlyEligibleForVoice()

	if not userOnlyEligibleForVoice then
		return false
	end

	if GetFFlagEnableVoiceSignal() then
		local userInInExperienceUpsellTreatment = self:UserInInExperienceUpsellTreatment()
		return userOnlyEligibleForVoice and userInInExperienceUpsellTreatment
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	return userOnlyEligibleForVoice and ageVerificationOverlay and ageVerificationOverlay.showVoiceInExperienceUpsell
end

function CoreVoiceManager:canUseServiceAsync()
	if FFlagSkipVoiceInTeamCreateViewer and RunService:IsTeamCreateViewer() then
		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_CONTEXT_NOT_ENABLED" })
		end

		return Promise.reject()
	elseif self.available == nil and game:GetEngineFeature("VoiceChatSupported") then
		if not self.canUseServicePromise then
			self.canUseServicePromise = Promise.defer(function(callback, callback2)
				local userAndPlaceCanUseVoice = self:userAndPlaceCanUseVoice()

				if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
					self.canUseServiceResult = userAndPlaceCanUseVoice
					self:emit("OnCanUseServiceResult", userAndPlaceCanUseVoice)
				end

				if GetFFlagEnableVoiceSignal() and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended then
					log:debug("Place is voice enabled but user is not, delaying voice rejection")
					self.attemptVoiceRejoin.Event:Wait()
					log:debug("Attempting voice rejoin")

					self.communicationPermissionsResult.voiceSettings.isVoiceEnabled = true
					self.userEligible = true
					self.initializedPostSuspension = true
					callback()
					self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joining)
				elseif userAndPlaceCanUseVoice then
					if
						game:GetEngineFeature("VoiceChatEnabledRccProperties")
						and not (VoiceChatService.VoiceChatEnabledForUniverseOnRcc and VoiceChatService.VoiceChatEnabledForPlaceOnRcc)
					then
						log:debug(
							"Disabling voice chat due to RCC Response. Universe: {}, Place: {}",
							VoiceChatService.VoiceChatEnabledForUniverseOnRcc,
							VoiceChatService.VoiceChatEnabledForPlaceOnRcc
						)

						if VoiceChatService.VoiceChatEnabledForUniverseOnRcc then
							if not VoiceChatService.VoiceChatEnabledForPlaceOnRcc then
								self:_reportJoinFailed("placeNotEnabled")
							end
						else
							self:_reportJoinFailed("universeNotEnabled")
						end

						self.available = VOICE_CHAT_AVAILABILITY.PlaceNotAvailable

						if self.options.passInitErrorInPromiseReject then
							callback2({ code = "INIT_ERROR_PLACE_NOT_AVAILABLE" })
						else
							callback2()
						end
					elseif defineFastFlag2 then
						ixpServiceWrapper:WaitForInitialization()
						local success, result = pcall(function()
							return ixpServiceWrapper:GetLayerData(defineFastString)
						end)

						if success and result and result[defineFastString2] ~= nil then
							self.userEligible = result[defineFastString2]
							ixpServiceWrapper:LogUserLayerExposure(defineFastString)
						end

						if self.userEligible then
							callback()
						elseif self.options.passInitErrorInPromiseReject then
							callback2({ code = "INIT_ERROR_IXP_NOT_ELIGIBLE" })
						else
							callback2()
						end
					else
						self.userEligible = true
						callback()
					end
				else
					log:info("Voice access denied")

					self.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable

					if self.options.passInitErrorInPromiseReject then
						callback2({ code = "INIT_ERROR_USER_NOT_AVAILABLE" })
					else
						callback2()
					end
				end
			end):andThen(function()
				return self:requestMicPermission()
			end)
		end

		return self.canUseServicePromise
	else
		log:debug("Voice Chat is not Available, rejecting canUseService promise")

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_VOICE_NOT_SUPPORTED" })
		end

		return Promise.reject()
	end
end

function CoreVoiceManager:_setRecentUserState(p, p2)
	local v4 = self.recentUsersInteractionData[tostring(p)] or {}
	local joined = Cryo.Dictionary.join(v4, p2)

	self.recentUsersInteractionData = Cryo.Dictionary.join(self.recentUsersInteractionData, {
		[tostring(p)] = joined
	})
end

function CoreVoiceManager:getRecentUsersInteractionData()
	self:_updateRecentUsersInteractionData()
	return self.recentUsersInteractionData
end

function CoreVoiceManager:GetSignalREvent(p)
	return self.SignalREventTable[p].Event
end

function CoreVoiceManager:StartModerationSignal()
	if not self.playerModeratedConnection then
		self.playerModeratedConnection = self:GetSignalREvent("ParticipantModeratedFromVoice"):Connect(function()
			log:debug("User Moderated")
			self.previousSessionId = self.service:GetSessionId()
			self:emit("OnPlayerModerated")

			if GetFFlagVoiceChatClientRewriteMasterLua() then
				VoiceChatService:notifyServerACSCleanup()
				VoiceChatService:leaveVoice()
			else
				VoiceChatService:notifyServerACSCleanup()
				self.service:Leave()
			end
		end)
	end
end

function CoreVoiceManager:LeaveVoiceForRestriction()
	if not self.service then
		return
	end

	self.previousSessionId = self.service:GetSessionId()
	VoiceChatService:notifyServerACSCleanup()

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		VoiceChatService:leaveVoice()
	else
		self.service:Leave()
	end
end

function CoreVoiceManager:StopModerationSignal()
	if self.playerModeratedConnection then
		self.playerModeratedConnection:Disconnect()
		self.playerModeratedConnection = nil
	end
end

function CoreVoiceManager:_updateRecentUsersInteractionData()
	local now = os.time()
	local nones = {}

	if self.recentUsersInteractionData then
		for k, v4 in pairs(self.recentUsersInteractionData) do
			local v5

			if defineFastFlag then
				v5 = self.participants[tostring(k)]
			else
				v5 = self.participants[k]
			end

			local v6 = GetFFlagClearUserFromRecentVoiceDataOnLeave() and not Players:GetPlayerByUserId((tonumber(k)))
			local v7 = now - v4.lastHeardTime >= GetFIntVoiceUsersInteractionExpiryTimeSeconds()
			local v8 = not v5 or v5.isMuted

			if v7 and v8 or v6 then
				nones[k] = Cryo.None
			end
		end

		self.recentUsersInteractionData = Cryo.Dictionary.join(self.recentUsersInteractionData, nones)
	end
end

function CoreVoiceManager:SetupParticipantListeners()
	self:ensureInitialized("setup participant listeners")

	if not self.participants then
		self.participants = {}
		self.recentUsersInteractionData = {}
		self.updatedParticipants = {}

		self.participantConnection = self.service.ParticipantsStateChanged:Connect(function(list, list2, list3)
			log:trace("Participants state changed")

			for _, item in ipairs(list) do
				if not (GetFFlagClearUserFromRecentVoiceDataOnLeave() or self.participants[tostring(item)].isMuted) then
					self:_setRecentUserState(item, { lastHeardTime = os.time() })
				end

				self.participants[tostring(item)] = nil
				self.participantLeft:Fire(self.participants, item)
				self:emit("OnVoiceParticipantRemoved", item)
			end

			for _, item in ipairs(list2) do
				self.participantJoined:Fire(self.participants, item)
				self:emit("OnVoiceParticipantAdded", item)
			end

			for _, item in pairs(list3) do
				local userId = item.userId
				local v4

				if defineFastFlag then
					v4 = self.participants[tostring(userId)]
				else
					v4 = self.participants[userId]
				end

				if not item.isMuted or v4 and not v4.isMuted then
					local v5 = { lastHeardTime = os.time(), player = 0 }
					local player

					if GetFFlagFixGetPlayerByUserIdStringCast() then
						player = Players:GetPlayerByUserId((tonumber(userId)))
					else
						player = Players:GetPlayerByUserId(userId)
					end

					v5.player = player
					self:_setRecentUserState(userId, v5)
				end

				if not v4 or v4.isMuted ~= item.isMuted then
					self:emit("OnVoiceParticipantToggleMuted", userId, item.isMuted)
				end

				if VoiceChatService.UseNewAudioApi then
					item.isMutedLocally = self.mutedPlayers[userId] and true or false
				end

				if VoiceChatService.UseNewAudioApi then
					local isMutedLocally

					if self.mutedPlayers[userId] then
						isMutedLocally = self.mutedPlayers[userId] and true or false
					else
						isMutedLocally = item.isMutedLocally
					end

					item.isMutedLocally = isMutedLocally
				end

				if FFlagEnablePartyVoiceChangersInLua and VoiceChatService.UseNewAudioApi then
					local isVoiceChangerActive

					if self.voiceChangerActivePlayers[userId] then
						isVoiceChangerActive = self.voiceChangerActivePlayers[userId]
					else
						isVoiceChangerActive = item.isVoiceChangerActive
					end

					item.isVoiceChangerActive = isVoiceChangerActive
				end

				if self.muteAll then
					item.isMutedLocally = true
				end

				self.participants[tostring(userId)] = item

				if GetFFlagBatchVoiceParticipantsUpdates() then
					self.updatedParticipants[tostring(userId)] = item
				end

				if v and self.CaptureService:IsCapturingVideo() then
					self.voiceCapturedDuringVideoCapture = self.voiceCapturedDuringVideoCapture or item.isSignalActive
				end
			end

			self:_updateRecentUsersInteractionData()

			if self.shouldThrottleParticipantUpdate then
				local now = tick()

				if now - self.lastParticipantsStateUpdate >= self.participantsStateThrottleTime and #list3 > 0 then
					self.lastParticipantsStateUpdate = now
					local participantsUpdate = self.participantsUpdate
					local v4

					if GetFFlagBatchVoiceParticipantsUpdates() then
						v4 = self.updatedParticipants
					else
						v4 = self.participants
					end

					participantsUpdate:Fire(v4)

					self.updatedParticipants = {}
				elseif #list3 > 0 then
					local v4 = self.participantsStateThrottleTime - (now - self.lastParticipantsStateUpdate)
					self.lastStateUpdateCounter = (self.lastStateUpdateCounter + 1) % 100
					local lastStateUpdateCounter = self.lastStateUpdateCounter
					task.wait(v4)

					if lastStateUpdateCounter == self.lastStateUpdateCounter then
						local participantsUpdate = self.participantsUpdate
						local v5

						if GetFFlagBatchVoiceParticipantsUpdates() then
							v5 = self.updatedParticipants
						else
							v5 = self.participants
						end

						participantsUpdate:Fire(v5)

						self.updatedParticipants = {}
					end
				end
			elseif #list3 > 0 then
				local participantsUpdate = self.participantsUpdate
				local v4

				if GetFFlagBatchVoiceParticipantsUpdates() then
					v4 = self.updatedParticipants
				else
					v4 = self.participants
				end

				participantsUpdate:Fire(v4)

				self.updatedParticipants = {}
			end
		end)

		local v4 = GetFFlagMicConsumerRegistry() and GetFFlagCoreMicManagerRefactor()

		local function onStateChanged(p, joined)
			self:emit("OnStateChanged", p, joined)

			local v5 = joined == Enum.VoiceChatState.Failed
			local v6 = joined == Enum.VoiceChatState.Joining
			local v7 = joined == Enum.VoiceChatState.Leaving
			local v8 = joined == Enum.VoiceChatState.Ended
			local isPublishPaused = self.service:IsPublishPaused()

			if isPublishPaused == self.localMuted or v5 or v6 or v7 or v8 then
				if v6 or v7 or v8 then
					self.localMuted = nil
				end
			else
				self.localMuted = isPublishPaused
				self.muteChanged:Fire(isPublishPaused)
			end

			if
				GetFFlagVoiceChatClientRewriteMasterLua()
				and joined == Enum.VoiceChatState.Joined
				and self.isInCall
				and isPublishPaused ~= self.callMutedState
			then
				log:debug("In call, setting local muted to call muted state {}", self.callMutedState)
				self:ToggleMic("InitInCall")
			end

			if defineFastFlag4 and joined == Enum.VoiceChatState.Joined then
				self:StartModerationSignal()
			end

			if joined == Enum.VoiceChatState.Joined then
				self:_syncLocalAudioDeviceActive()
			end

			if joined == Enum.VoiceChatState.Leaving then
				if not self.previousGroupId then
					self.previousGroupId = self.service:GetGroupId()
				end

				self.previousMutedState = self.service:IsPublishPaused()
			end

			if joined == Enum.VoiceChatState.Ended or v5 then
				self.participants = {}
				self.localMuted = nil

				if v4 then
					self.micManager:UnregisterConsumer("voice_chat")
				end

				if defineFastFlag5 then
					self._voiceVolumeEligibilityReported = false
				end

				self.participantsUpdate:Fire(self.participants)

				if defineFastFlag4 then
					self:StopModerationSignal()
				end

				self:_syncLocalAudioDeviceActive()

				if v5 then
					log:debug("State Changed to Failed. Reason: {}", self.service:GetAndClearCallFailureMessage())
				end

				if
					p == Enum.VoiceChatState.Joining
					or p == Enum.VoiceChatState.JoiningRetry
					or p == Enum.VoiceChatState.Joined
				then
					if joined == Enum.VoiceChatState.Ended then
						log:debug("State Changed to Ended from {}", p)
					end

					if not self:IsSeamlessVoice() or self:GetVoiceConnectCookieValue() then
						self:emit("OnRetryRequested")
					end
				end

				if fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry and engineFeature then
					self:ReportVoiceVolumeImpressionsIfNeeded()
				end
			end

			if
				GetFFlagEnableVoiceSignal()
				and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Joining
				and joined == Enum.VoiceChatState.Joined
			then
				self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joined)
				self:emit("OnVoiceJoin")
			end

			if
				fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry
				and engineFeature
				and joined == Enum.VoiceChatState.Joined
			then
				self._voiceJoinTimestampMs = DateTime.now().UnixTimestampMillis
				self._voiceVolumeSliderEligibleAtJoin = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(
					true,
					VoiceChatService.UseNewAudioApi
				)
			end

			if
				defineFastFlag5
				and engineFeature
				and joined == Enum.VoiceChatState.Joined
				and not self._voiceVolumeEligibilityReported
			then
				local success, result = pcall(function()
					local UserGameSettings = UserSettings():GetService("UserGameSettings")
					return UserGameSettings.VoiceChatVolume
				end)

				local useNewAudioApi = VoiceChatService.UseNewAudioApi
				local creatorVoiceVolumeControlsEnabled = VoiceVolumeControlsEligibility.isCreatorVoiceVolumeControlsEnabled()
				local voiceAnalyticsData = self:GetVoiceAnalyticsData()
				local analytics = self.Analytics
				local v9 = {
					playSessionId = voiceAnalyticsData.playSessionId,
					voiceSessionId = voiceAnalyticsData.voiceSessionId,
					voiceChatVolume = 0,
					usesNewAudioApi = 0,
					enablesVoiceVolumeControls = 0,
					isEligible = 0
				}

				if not success then
					result = nil
				end

				v9.voiceChatVolume = result
				v9.usesNewAudioApi = useNewAudioApi
				v9.enablesVoiceVolumeControls = creatorVoiceVolumeControlsEnabled
				v9.isEligible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, useNewAudioApi)
				analytics:reportVoiceVolumeEligibility(v9)

				self._voiceVolumeEligibilityReported = true
			end
		end

		if self.service.VoiceChatState and self.service.VoiceChatState == Enum.VoiceChatState.Joined then
			log:debug("Joined voice chat {}", self.service.VoiceChatState)
			onStateChanged(nil, Enum.VoiceChatState.Joined)
		end

		self.stateConnection = self.service.StateChanged:Connect(onStateChanged)

		if GetFFlagCoreMicManagerRefactor() then
			self.micManager:SetupMicActivityListener(self.service)

			if GetFFlagMicConsumerRegistry() then
				local localPlayer = Players.LocalPlayer
				local device

				if localPlayer then
					device = localPlayer:FindFirstChildOfClass("AudioDeviceInput")
				end

				self.micManager:RegisterConsumer({
					id = "voice_chat",
					consumerType = "VoiceChat",
					device = device
				})
			end
		elseif fFlagUseAudioAnalyzerForLocalMetering2 and VoiceChatService.UseNewAudioApi then
			if not self.localMeteringTask then
				self.localMeteringTask = task.spawn(function()
					while true do
						self:UpdateLocalMetering()
						task.wait()
					end
				end)
			end
		elseif MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY <= self.service:GetVoiceChatApiVersion() then
			self.micConnection = self.service.PlayerMicActivitySignalChange:Connect(function(p)
				if v and self.CaptureService:IsCapturingVideo() then
					self.voiceCapturedDuringVideoCapture = self.voiceCapturedDuringVideoCapture or p.isActive
				end

				self.isTalking = p.isActive

				if GetFFlagLocalMutedNilFix() then
					if self.localMuted == false then
						self.talkingChanged:Fire(self.isTalking)
					end
				elseif not self.localMuted then
					self.talkingChanged:Fire(self.isTalking)
				end
			end)
		end

		if GetFFlagLuaConsumePlayerModerated() then
			self:StartModerationSignal()
		elseif game:GetEngineFeature("VoiceChatServicePlayerModeratedEvent") then
			self.playerModeratedConnection = self.service.LocalPlayerModerated:connect(function()
				log:debug("User Moderated old")
				self.previousSessionId = self.service:GetSessionId()
				self:emit("OnPlayerModerated")

				if GetFFlagVoiceChatClientRewriteMasterLua() then
					VoiceChatService:leaveVoice()
				else
					self.service:Leave()
				end
			end)
		end

		log:trace("Setting up voice nudge handlers")
		self.voiceToxicityModalConnection = self:GetSignalREvent("VoiceToxicityModal"):Connect(function(p)
			self.Analytics:reportReceivedNudge(p, self:GetNudgeAnalyticsData())
			self:emit("OnVoiceToxicityModal")
		end)

		self.VoiceToxicityToastConnection = self:GetSignalREvent("VoiceToxicityToast"):Connect(function(p)
			self.Analytics:reportReceivedNudge(p, self:GetNudgeAnalyticsData())
			self:emit("OnVoiceToxicityToast")
		end)

		if GetFFlagEnableVoiceReverseNudge() then
			log:trace("Setting up voice reverse nudge handlers")
			self.voiceReverseNudgeConnection = self:GetSignalREvent("VoiceReverseNudgeIconColorChange"):Connect(function(p)
				self:emit("OnVoiceReverseNudgeIconColorChange", p)
			end)
		end

		self.blockConnection = self.BlockStatusChanged:Connect(function(p: number, flag: boolean)
			if flag then
				if self.participants[tostring(p)] then
					log:debug("Blocking {}", Utils.shorten(p))
					self.service:SubscribeBlock(p)
				end
			else
				log:debug("UnBlocking {}", Utils.shorten(p))
				self.service:SubscribeUnblock(p)
			end
		end)

		if VoiceChatService.UseNewAudioApi then
			self:hookupAudioDeviceInputListener()
		end

		if self.service.TempSetMicMutedToggleMic then
			self.tempSetMicMutedToggleMicConnection = self.service.TempSetMicMutedToggleMic:connect(function()
				self:ToggleMic("TempSetMicMutedToggleMic")
			end)
		end

		if v then
			self.videoCaptureInProgressConnection = self.CaptureService.VideoCaptureInProgress:connect(function(flag: boolean)
				if flag then
					self.voiceCapturedDuringVideoCapture = false
				else
					self.TelemetryService:LogEvent(v2, {
						customFields = { voiceCaptured = self.voiceCapturedDuringVideoCapture }
					})
				end
			end)
		end
	end
end

local v4 = nil
function CoreVoiceManager.CheckAudioInputExists(p)
	log:trace("Checking for AudioDeviceInput")

	if not v4 then
		v4 = Promise.new(function(callback, _)
			if #Cryo.Dictionary.keys(p.audioDevices) > 0 then
				log:trace("Found existing AudioDeviceInput")
				callback()
			else
				p.audioDeviceInputAdded.Event:Connect(function()
					log:trace("Found new AudioDeviceInput")
					callback()
				end)
			end
		end)
	end

	return v4
end

function CoreVoiceManager:checkAndUpdateSequence(p: string, p2: number)
	if not p2 then
		return 0
	end

	if not self.SequenceNumbers[p] then
		self.SequenceNumbers[p] = p2
		return 0
	end

	local v5 = p2 - self.SequenceNumbers[p]

	if v5 > 0 then
		self.SequenceNumbers[p] = p2
	end

	return v5 - 1
end

local function isIgnoredAudioInput(instance) -- 3 equivalent calls inferred from this helper
	return instance:IsDescendantOf(CoreGui)
end

function CoreVoiceManager:_onAudioDeviceInputAdded(instance)
	if FFlagExpChatDictation and isIgnoredAudioInput(instance) then -- inferred equivalent call
		return
	end

	log:debug("Found new audio device instance for {}", instance.Player and instance.Player.Name)
	self.audioDevices[instance] = self:CreateAudioDeviceData(instance)
	self:emit("OnAudioDeviceInputAdded")
	self:StartAnalysis(instance)
end

function CoreVoiceManager:onInstanceAdded(audioDeviceInput)
	if audioDeviceInput:IsA("AudioDeviceInput") then
		self:_onAudioDeviceInputAdded(audioDeviceInput)
	end
end

function CoreVoiceManager:GetSendMuteEvent()
	if not self.SendMuteEvent then
		self.SendMuteEvent = RobloxReplicatedStorage:WaitForChild("SetUserActive", 10)
	end

	return self.SendMuteEvent
end

function CoreVoiceManager:GetToggleVoiceChangerEvent()
	if not self.SendVoiceChangerEvent then
		self.SendVoiceChangerEvent = ReplicatedStorage:WaitForChild("ToggleUserVoiceChanger", 10)
	end

	return self.SendVoiceChangerEvent
end

function CoreVoiceManager:GetInputToModifierWire()
	if not self.InputToModifierWire then
		self.InputToModifierWire = Players.LocalPlayer:FindFirstChild("InputToModifier")
	end

	return self.InputToModifierWire
end

function CoreVoiceManager:GetPartyVoiceDeviceInput()
	if not self.PartyVoiceDeviceInput then
		self.PartyVoiceDeviceInput = Players.LocalPlayer:FindFirstChild("PartyVoiceDeviceInput")
	end

	return self.PartyVoiceDeviceInput
end

function CoreVoiceManager:GetSetVoicePackEvent()
	if not self.SetVoicePackEvent then
		self.SetVoicePackEvent = ReplicatedStorage:WaitForChild("SetVoicePack", 10)
	end

	return self.SetVoicePackEvent
end

function CoreVoiceManager:GetVoiceChangerWasToggledEvent()
	if not self.VoiceChangerWasToggledEvent then
		self.VoiceChangerWasToggledEvent = ReplicatedStorage:WaitForChild("VoiceChangerWasToggled", 3)
	end

	return self.VoiceChangerWasToggledEvent
end

local function WireUp(sourceInstance, analyzer) -- 1 equivalent call inferred from this helper
	local wire = Instance.new("Wire")
	wire.SourceInstance = sourceInstance
	wire.TargetInstance = analyzer
	wire.Parent = analyzer
	return wire
end

local function GetAnalysisHost() -- 1 equivalent call inferred from this helper
	return RobloxReplicatedStorage
end

function CoreVoiceManager:GetAnalyzer(p)
	local name = p.Name .. "_Analyzer"
	local parent3 = GetAnalysisHost() -- inferred equivalent call
	local v5 = parent3:FindFirstChild(name)

	if v5 then
		return v5
	end

	v5 = Instance.new("AudioAnalyzer")
	v5.SpectrumEnabled = false
	v5.Name = name
	v5.Parent = parent3

	return v5
end

local function toDecibels(peakLevel: number) -- 1 equivalent call inferred from this helper
	return math.log10(peakLevel) * 20
end

function CoreVoiceManager:IsSignalActive(p: number): boolean
	if not fFlagUseAudioAnalyzerForLocalMetering2 then
		return false
	end

	local playerByUserId = Players:GetPlayerByUserId(p)

	if playerByUserId then
		return toDecibels(self:GetAnalyzer(playerByUserId).PeakLevel) > -36 -- inferred equivalent call
	end

	return false
end

function CoreVoiceManager:StopAnalysis(object)
	if not fFlagUseAudioAnalyzerForLocalMetering2 then
		return
	end

	for _, v5 in object:GetConnectedWires("Output") do
		local targetInstance = v5.TargetInstance

		if targetInstance and targetInstance:IsDescendantOf(RobloxReplicatedStorage) then
			v5:Destroy()
		end
	end
end

function CoreVoiceManager:StartAnalysis(sourceInstance)
	if not fFlagUseAudioAnalyzerForLocalMetering2 then
		return
	end

	self:StopAnalysis(sourceInstance)

	local player = sourceInstance.Player

	if not player then
		return
	end

	WireUp(sourceInstance, self:GetAnalyzer(player)) -- inferred equivalent call
end

function CoreVoiceManager:GetVoiceConnectCookie()
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)
	return if success and result then result else ""
end

function CoreVoiceManager:GetVoiceConnectCookieValue(): boolean
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)
	return not success or result == "true"
end

function CoreVoiceManager.SetVoiceConnectCookieValue(p, flag: boolean)
	return (pcall(function()
		p.AppStorageService:SetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3, (tostring(flag)))
		p.AppStorageService:Flush()
	end))
end

function CoreVoiceManager:GetVoiceRewarmCookie()
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_REWARM_KEY)
	end)

	if success and result then
		log:debug("Got voice re-warm cookie: {}", result)
		return result
	end

	log:debug("Voice re-warm cookie not set, returning empty string")
	return ""
end

function CoreVoiceManager:SetVoiceRewarmCookie(p: string)
	log:debug("Setting voice re-warm cookie to {}", p)
	pcall(function()
		self.AppStorageService:SetItem(Constants.VOICE_REWARM_KEY, (tostring(p)))
		self.AppStorageService:Flush()
	end)
end

function CoreVoiceManager:ShouldRewarmUser(): boolean
	local voiceRewarmCookie = self:GetVoiceRewarmCookie()

	if voiceRewarmCookie == "" then
		return true
	end

	return (tonumber(voiceRewarmCookie) or 0) < game:GetFastInt("VoiceRewarmReArmCount")
end

function CoreVoiceManager:ConsumeVoiceRewarm()
	self:SetVoiceRewarmCookie((tostring(game:GetFastInt("VoiceRewarmReArmCount"))))
end

function CoreVoiceManager.SetNewUserFTUXCookieValue(p, flag: boolean)
	return (pcall(function()
		p.AppStorageService:SetItem(Constants.SEAMLESS_VOICE_FTUX_KEY, (tostring(flag)))
		p.AppStorageService:Flush()
	end))
end

function CoreVoiceManager:SetAndSyncActive(p, active: boolean)
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetAndSyncActive(p, active)
	end

	p.Active = active
	local sendMuteEvent = self:GetSendMuteEvent()

	if sendMuteEvent and p.Player == Players.LocalPlayer then
		sendMuteEvent:FireServer(active)
	end
end

function CoreVoiceManager:CreateAudioDeviceData(instance)
	local v5 = instance.Player == Players.LocalPlayer

	if engineFeature2 then
		if not instance.MutedByLocalUser then
			if self.muteAll and not v5 then
				instance.MutedByLocalUser = true
			end

			if instance.Player and self.mutedPlayers[instance.Player.UserId] then
				instance.MutedByLocalUser = true
			end
		end
	elseif instance.Active then
		if self.muteAll and not v5 then
			instance.Active = false
		end

		if instance.Player and self.mutedPlayers[instance.Player.UserId] then
			instance.Active = false
		end
	end

	if instance.Active and v5 and self.localMuted == nil then
		self:SetAndSyncActive(instance, false)
	end

	if v5 and self.localMuted ~= nil and self.localMuted ~= not instance.Active and not self.isInCall then
		log:debug("Mismatch between LocalMuted and device.Active")
		local active = not self.localMuted
		instance.Active = active
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(active)
		end
	elseif self.isInCall and v5 then
		local active = not self.callMutedState
		log:debug("Overwriting Active State to match Iris call. .Active = {}", active)
		instance.Active = active
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(active)
		end
	end

	local audioDeviceData = {}

	audioDeviceData.onPlayerChanged = instance:GetPropertyChangedSignal("Player"):Connect(function()
		v5 = instance.Player == Players.LocalPlayer

		if v5 then
			if instance.Active and self.localMuted == nil then
				log:debug("Player is still in connecting state, setting Active to false")
				self:SetAndSyncActive(instance, false)
			elseif self.localMuted ~= nil and self.localMuted ~= not instance.Active then
				log:debug("Mismatch between LocalMuted and device.Active")
				self:SetAndSyncActive(instance, not self.localMuted)
			end
		elseif self.muteAll or instance.Player and self.mutedPlayers[instance.Player.UserId] then
			if engineFeature2 then
				instance.MutedByLocalUser = true
			else
				instance.Active = false
			end
		end

		self:emit("OnDevicePlayerChanged")
		self:StartAnalysis(instance)
	end)

	audioDeviceData.onMutedChanged = instance:GetPropertyChangedSignal("Muted"):Connect(function()
		self:emit("OnDeviceMuteChanged")
	end)

	if engineFeature2 then
		if fFlagDebugShowAudioDeviceInputDebugger then
			audioDeviceData.onActiveChanged = instance:GetPropertyChangedSignal("Active"):Connect(function()
				self:emit("OnDeviceActiveChanged")
			end)
			audioDeviceData.onMutedByLocalUserChanged = instance:GetPropertyChangedSignal("MutedByLocalUser"):Connect(function()
				self:emit("OnDeviceMutedByLocalUserChanged")
			end)
		end
	else
		audioDeviceData.onActiveChanged = instance:GetPropertyChangedSignal("Active"):Connect(function()
			self:emit("OnDeviceActiveChanged")

			if self.muteAll and not v5 then
				instance.Active = false
			end

			if instance.Player and self.mutedPlayers[instance.Player.UserId] then
				instance.Active = false
			end
		end)
	end

	if VoiceChatService.UseNewAudioApi then
		audioDeviceData.onActiveChangedDisconnectGuard = instance:GetPropertyChangedSignal("Active"):Connect(function()
			if instance.Active and instance.Player == Players.LocalPlayer and self.localMuted == nil then
				self:SetAndSyncActive(instance, false)
			end
		end)
	end

	return audioDeviceData
end

function CoreVoiceManager:onInstanceRemove(audioDeviceInput)
	if audioDeviceInput:IsA("AudioDeviceInput") then
		if FFlagExpChatDictation and isIgnoredAudioInput(audioDeviceInput) then -- inferred equivalent call
			return
		end

		self:StopAnalysis(audioDeviceInput)
		log:trace(
			"Removing AudioDeviceInput {} {} {}",
			audioDeviceInput,
			"for user",
			audioDeviceInput.Player and audioDeviceInput.Player.UserId
		)
		local audioDevice = self.audioDevices[audioDeviceInput]

		if audioDevice then
			if engineFeature2 then
				if fFlagDebugShowAudioDeviceInputDebugger then
					if audioDevice.onActiveChanged then
						audioDevice.onActiveChanged:Disconnect()
					end

					if audioDevice.onMutedByLocalUserChanged then
						audioDevice.onMutedByLocalUserChanged:Disconnect()
					end
				end
			else
				audioDevice.onActiveChanged:Disconnect()
			end

			audioDevice.onMutedChanged:Disconnect()
			audioDevice.onPlayerChanged:Disconnect()

			if audioDevice.onActiveChangedDisconnectGuard then
				audioDevice.onActiveChangedDisconnectGuard:Disconnect()
			end
		end

		self.audioDevices[audioDeviceInput] = nil
		self:emit("OnAudioDeviceInputRemoved")

		if fFlagUseAudioAnalyzerForLocalMetering2 and audioDeviceInput.Player then
			self:GetAnalyzer(audioDeviceInput.Player):Destroy()
		end
	end
end

function CoreVoiceManager:hookupAudioDeviceInputListener()
	log:debug("Hooking up audio device listeners")
	local localPlayer = Players.LocalPlayer

	if FFlagUseAudioDeviceInputAddedSignal then
		SoundService.AudioDeviceInputAdded:Connect(function(p)
			self:_onAudioDeviceInputAdded(p)
		end)
	else
		SoundService.AudioInstanceAdded:Connect(function(p)
			self:onInstanceAdded(p)
		end)
	end

	local audioDeviceInput = localPlayer:FindFirstChildOfClass("AudioDeviceInput")
	log:debug("Found local user audio device {}", audioDeviceInput)

	if audioDeviceInput then
		self:onInstanceAdded(audioDeviceInput)
	end

	if VoiceChatService.EnableDefaultVoice then
		log:debug("Creating default voice listener")

		if not game:GetEngineFeature("SoundServiceControlsDefaultListenerLocation") then
			local audioListener = Instance.new("AudioListener")

			audioListener.Parent = workspace.CurrentCamera
			local wire = Instance.new("Wire")
			wire.Parent = audioListener
			local audioDeviceOutput = Instance.new("AudioDeviceOutput")
			audioDeviceOutput.Parent = wire
			wire.SourceInstance = audioListener
			wire.TargetInstance = audioDeviceOutput
		end

		for _, v5 in CollectionService:GetTagged("RbxDefaultVoiceEmitter") do
			Utils.destroyDefaultEmitter(v5)
		end

		CollectionService:GetInstanceAddedSignal("RbxDefaultVoiceEmitter"):Connect(Utils.destroyDefaultEmitter)

		localPlayer.CharacterAdded:Connect(Utils.avoidEmitting)

		if localPlayer.Character then
			Utils.avoidEmitting(localPlayer.Character)
		end
	end

	game.DescendantRemoving:Connect(function(descendant)
		self:onInstanceRemove(descendant)
	end)

	for _, descendant in game:GetDescendants() do
		self:onInstanceAdded(descendant)
	end

	Players.PlayerRemoving:Connect(function(player)
		for k in self.audioDevices do
			if k.Player and k.Player == player then
				self:onInstanceRemove(k)
			end
		end
	end)
end

function CoreVoiceManager:RejoinCurrentChannel()
	pcall(function()
		local groupId = self.service:GetGroupId()

		if groupId and groupId ~= "" then
			local isPublishPaused = self.service:IsPublishPaused()
			self.service:Leave()
			log:debug("Rejoining current channel {}", groupId)
			self.participants = {}
			self.participantsUpdate:Fire(self.participants)

			if not self.service:JoinByGroupIdToken(groupId, isPublishPaused, true) then
				self:emit("OnInitialJoinFailed")
			end
		end
	end)
end

function CoreVoiceManager:RejoinChannel(p, p2)
	log:debug("Rejoining previous channel {} with mute status {}", p, p2)

	if p and p ~= "" then
		pcall(function()
			self.service:Leave()
			self.participants = {}
			self.participantsUpdate:Fire(self.participants)

			if not self.service:JoinByGroupIdToken(p, p2, true) then
				self:emit("OnInitialJoinFailed")
			end
		end)
	end
end

function CoreVoiceManager:RejoinVoice()
	if GetFFlagVoiceChatClientRewriteMasterLua() then
		log:debug("Rejoining voice")

		self.participants = {}
		self.participantsUpdate:Fire(self.participants)
		VoiceChatService:rejoinVoice()
	end
end

function CoreVoiceManager:watchSignalR()
	self.signalRConnection = self.NotificationService.RobloxEventReceived:Connect(function(p)
		local namespace = p.namespace

		if not WATCHED_NAMESPACES[namespace] then
			return
		end

		local jsonDecode = Utils.jsonDecode(p.detail)

		local v5 = self.SignalREventTable[jsonDecode.type]

		if v5 then
			v5:Fire(jsonDecode)
		end

		local sequenceNumber = jsonDecode.SequenceNumber
		log:trace("SignalR message {}: {}", namespace, sequenceNumber)

		local v6 = self:checkAndUpdateSequence(namespace, sequenceNumber)

		if v6 > 0 then
			self.Analytics:reportReconnectDueToMissedSequence()
		elseif v6 < -1 then
			self.Analytics:reportOutOfOrderSequence()
		end
	end)

	self.signalRConnectionChanged = self.NotificationService.RobloxConnectionChanged:Connect(function(p, p2, _, p3)
		if p == "signalR" then
			if p2 ~= Enum.ConnectionState.Connected then
				log:info("SignalR disconnected")
				return
			end

			for k, v5 in pairs(Utils.jsonDecode(p3)) do
				if not WATCHED_NAMESPACES[k] then
					continue
				end

				log:trace("SignalR message {}: {}", k, v5)

				local v6 = self:checkAndUpdateSequence(k, v5)

				if v6 > 0 then
					self.Analytics:reportReconnectDueToMissedSequence()
				elseif v6 < -1 then
					self.Analytics:reportOutOfOrderSequence()
				end
			end
		end
	end)
end

function CoreVoiceManager:StopSignalRConnection()
	if self.signalRConnectionChanged then
		self.signalRConnectionChanged:Disconnect()
		self.signalRConnectionChanged = nil
	end

	if self.signalRConnection then
		self.signalRConnection:Disconnect()
		self.signalRConnection = nil
	end
end

function CoreVoiceManager.getService(p)
	return p.service
end

function CoreVoiceManager:ToggleMic(context: string?)
	self:ensureInitialized("toggle mic")

	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetMicActive(self.micManager.localMuted, context)
	end

	if self.localMuted == nil then
		log:trace("ToggleMic context: {} - Voice not connected yet", context)
		return
	end

	log:trace("ToggleMic context: {}", context)

	if GetFFlagJoinWithoutMicPermissions() then
		if self.permissionState == PERMISSION_STATE.PENDING_MIC then
			log:debug("In pending mic mode, requesting permission")
			self:emit("GetPermissions", function(p)
				local permissionState2

				if p.hasMicPermissions then
					permissionState2 = PERMISSION_STATE.LISTEN_AND_TALK
				else
					permissionState2 = PERMISSION_STATE.LISTEN_ONLY
				end

				self.permissionState = permissionState2

				log:debug("Got permissions, setting state to {}", self.permissionState)
				self:ToggleMic(context)
			end, { permissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)
			return
		elseif self.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			log:debug("User tried to unmute despite being in listen only mode")
			self:emit("OnPermissionRequested")
			return
		end
	end

	if self.isPlayerWatchingAd then
		log:trace("User is watching an ad, skipping toggling mic")
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.localMuted = not self.localMuted
		local active = not self.localMuted
		log:trace("Setting self mute to {} context: {}", active, context)
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(active)

			for k in self.audioDevices do
				if k.Player and k.Player == Players.LocalPlayer then
					k.Active = active
				end
			end

			self.muteChanged:Fire(self.localMuted)
		else
			log:error("Could not find SendMuteEvent")
		end
	else
		local localMuted = not self.service:IsPublishPaused()
		log:trace("Setting self mute to {} context: {}", localMuted, context)

		self.service:PublishPause(localMuted)
		self.localMuted = localMuted
		self.muteChanged:Fire(localMuted)
	end

	if not self.localMuted then
		self.talkingChanged:Fire(self.isTalking)
		self:emit("OnShowDataConsentToast")
	end

	if context then
		self.Analytics:reportVoiceMuteSelf((self:JoinWithVoiceMuteData({
			context = context,
			muted = self.localMuted
		})))
	end
end

function CoreVoiceManager:ToggleVoiceChanger(_: string?)
	self:ensureInitialized("toggle voice changer")

	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.isVoiceChangerActive = not self.isVoiceChangerActive
		log:trace("setting voice changer active to {}", self.isVoiceChangerActive)
	else
		self.isVoiceChangerActive = false
		log:trace("forcibly disabling voice changer since using old audio api", self.isVoiceChangerActive)
	end

	local toggleVoiceChangerEvent = self:GetToggleVoiceChangerEvent()

	if not toggleVoiceChangerEvent then
		log:error("Could not find ToggleVoiceChangerEvent")
		return
	end

	toggleVoiceChangerEvent:FireServer(self.isVoiceChangerActive)
	self.voiceChangerChanged:Fire(self.isVoiceChangerActive)
end

function CoreVoiceManager:ToggleVoiceChangerHearMyself(_: string?)
	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.isVoiceChangerHearMyselfActive = not self.isVoiceChangerHearMyselfActive
		local inputToModifierWire = self:GetInputToModifierWire()
		local partyVoiceDeviceInput = self:GetPartyVoiceDeviceInput()

		if inputToModifierWire and partyVoiceDeviceInput then
			log:trace("setting voice changer hear myself active to {}", self.isVoiceChangerHearMyselfActive)

			if self.isVoiceChangerHearMyselfActive then
				inputToModifierWire.SourceInstance = partyVoiceDeviceInput
			else
				inputToModifierWire.SourceInstance = nil
			end

			self.voiceChangerHearMyselfChanged:Fire(self.isVoiceChangerHearMyselfActive)
		else
			log:error("Could not find InputToModifierWire or PartyVoiceDeviceInput")
		end
	end
end

function CoreVoiceManager:SetVoicePack(currentVoicePack: string)
	self:ensureInitialized("set voice pack")

	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.currentVoicePack = currentVoicePack
		log:trace("setting current voice pack to {}", self.currentVoicePack)
		local setVoicePackEvent = self:GetSetVoicePackEvent()

		if setVoicePackEvent then
			setVoicePackEvent:FireServer("VoicePack_" .. self.currentVoicePack)
		else
			log:error("Could not find SetVoicePackEvent")
		end
	end
end

function CoreVoiceManager:JoinWithVoiceMuteData(p)
	local localPlayer = Players.LocalPlayer
	return Cryo.Dictionary.join(
		{
			userId = localPlayer.UserId,
			clientSessionId = self:GetSessionId(),
			channelId = self:GetChannelId()
		},
		p
	)
end

function CoreVoiceManager:_reportJoinFailed(p, p2)
	self.Analytics:reportVoiceChatJoinResult(false, p, p2)
	self:emit("OnReportJoinFailed", p)
end

function CoreVoiceManager:_syncLocalAudioDeviceActive()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SyncLocalAudioDeviceActive()
	end

	if not VoiceChatService.UseNewAudioApi then
		return
	end

	local active

	if self.localMuted == nil then
		active = false
	else
		active = not self.localMuted
	end

	for k in self.audioDevices do
		if k.Player and k.Player == Players.LocalPlayer then
			k.Active = active
		end
	end
end

function CoreVoiceManager:_setupEarlyAudioDeviceGuard()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetupEarlyAudioDeviceGuard()
	end

	local function shouldDeactivate(instance) -- 3 equivalent calls inferred from this helper
		local v5 = VoiceChatService.UseNewAudioApi and not (FFlagExpChatDictation and isIgnoredAudioInput(instance)) -- inferred equivalent call

		if v5 then
			if instance.Player == Players.LocalPlayer then
				return instance.Active and self.localMuted == nil
			end

			return false
		end

		return v5
	end

	local function guardDevice(instance)
		if shouldDeactivate(instance) then -- inferred equivalent call
			instance.Active = false
		end

		instance:GetPropertyChangedSignal("Player"):Connect(function()
			if shouldDeactivate(instance) then -- inferred equivalent call
				instance.Active = false
			end
		end)

		instance:GetPropertyChangedSignal("Active"):Connect(function()
			if shouldDeactivate(instance) then -- inferred equivalent call
				instance.Active = false
			end
		end)
	end

	if FFlagUseAudioDeviceInputAddedSignal then
		SoundService.AudioDeviceInputAdded:Connect(function(p)
			guardDevice(p)
		end)
	else
		SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				guardDevice(audioDeviceInput)
			end
		end)
	end

	for _, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			guardDevice(audioDeviceInput)
		end
	end
end

function CoreVoiceManager:_asyncInit()
	self:CheckCallState()
	self:_setupEarlyAudioDeviceGuard()

	return self:canUseServiceAsync():andThen(function(_)
		local v5

		if game:GetEngineFeature("UseNewVoiceChatService") then
			log:debug("Using VoiceChatInternal")
			v5 = "VoiceChatInternal"
		else
			v5 = "VoiceChatService"
		end

		local success, result = pcall(function()
			local service = game:GetService(v5)

			if
				service
				and (service:GetVoiceChatApiVersion() < MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED or service:IsContextVoiceEnabled())
			then
				self.voiceEnabled = true
				self.service = service

				self:SetupParticipantListeners()
			end
		end)

		if GetFFlagVoiceChatClientRewriteMasterLua() then
			VoiceChatService:joinVoice()
			log:debug("Starting Voice Chat Client Join Operation")
		else
			local VoiceChatService2 = game:GetService("VoiceChatService")

			if VoiceChatService2 then
				VoiceChatService2:joinVoice()
				log:debug("Starting Voice Chat Client Join Operation")
			end
		end

		if success then
			if self.service then
				self:emit("OnVoiceChatServiceInitialized")
				self:watchSignalR()
				return Promise.resolve()
			end

			log:debug("VoiceChatService is not set after init")
			self:_reportJoinFailed("contextNotEnabled")

			if self.options.passInitErrorInPromiseReject then
				return Promise.reject({ code = "INIT_ERROR_CONTEXT_NOT_ENABLED" })
			end

			return Promise.reject()
		end

		log:warning("EnableVoiceChat flag is enabled but GetService panicked {}", result)
		self:_reportJoinFailed("getServiceFailed", Analytics.ERROR)

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_GET_SERVICE_FAILED" })
		end

		return Promise.reject()
	end)
end

function CoreVoiceManager:UpdateLocalMetering()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:UpdateLocalMetering()
	end

	self.isTalking = self:IsSignalActive(Players.LocalPlayer.UserId)

	if self.localMuted == false then
		self.talkingChanged:Fire(self.isTalking)
	end
end

function CoreVoiceManager:asyncInit()
	if self.service then
		log:trace("Manager already initialized")
		return Promise.resolve()
	end

	if self.initPromise then
		return self.initPromise
	end

	self.initPromise = self:_asyncInit()

	if self.AdService then
		local function setupRewardedAdMuting(object)
			local v5 = false
			object.AdService.RewardedVideoAdStarted:Connect(function()
				if object.localMuted == nil then
					return
				end

				v5 = object.localMuted

				if not object.localMuted then
					object:ToggleMic(Constants.REWARDED_VIDEO_AD_STARTED)
				end

				object.isPlayerWatchingAd = true

				if GetFFlagCoreMicManagerRefactor() then
					object.micManager:SetAdMuteBlocked(true)
				end
			end)

			object.AdService.RewardedVideoAdEnded:Connect(function()
				if object.localMuted == nil then
					return
				end

				object.isPlayerWatchingAd = false

				if GetFFlagCoreMicManagerRefactor() then
					object.micManager:SetAdMuteBlocked(false)
				end

				if v5 ~= object.localMuted then
					object:ToggleMic(Constants.REWARDED_VIDEO_AD_ENDED)
				end
			end)
		end

		setupRewardedAdMuting(self)
	end

	if FFlagEnablePartyVoiceChangersInLua and not self.voiceChangerWasToggledEvent then
		task.spawn(function()
			local voiceChangerWasToggledEvent = self:GetVoiceChangerWasToggledEvent()

			if voiceChangerWasToggledEvent then
				voiceChangerWasToggledEvent.OnClientEvent:Connect(function(p: number, isVoiceChangerActive: boolean)
					local v5

					if defineFastFlag then
						v5 = self.participants[tostring(p)]
					else
						v5 = self.participants[p]
					end

					if v5 then
						v5.isVoiceChangerActive = isVoiceChangerActive
						self.voiceChangerActivePlayers[p] = isVoiceChangerActive
						self.participantsUpdate:Fire(self.participants)
					end
				end)
			end
		end)
	end

	return self.initPromise
end

function CoreVoiceManager.IsInitialized(p): boolean
	return if p.service then true else false
end

function CoreVoiceManager:ensureInitialized(p)
	if not self.service then
		error("[corescripts VCS Manager] " .. "Attempting to " .. p .. " before calling init")
	end
end

function CoreVoiceManager:GetSessionId()
	self:ensureInitialized("get session id")
	return self.service:GetSessionId()
end

function CoreVoiceManager:GetChannelId()
	self:ensureInitialized("get channel id")
	return self.service:GetChannelId()
end

function CoreVoiceManager:Disconnect()
	if GetFFlagCoreMicManagerRefactor() then
		if GetFFlagMicConsumerRegistry() then
			self.micManager:UnregisterConsumer("voice_chat")
		end

		self.micManager:Disconnect()
	end

	if self.participantConnection then
		self.participantConnection:Disconnect()
		self.participantConnection = nil
	end

	if self.stateConnection then
		self.stateConnection:Disconnect()
		self.stateConnection = nil
	end

	if self.micConnection then
		self.micConnection:Disconnect()
		self.micConnection = nil
	end

	if self.blockConnection then
		self.blockConnection:Disconnect()
		self.blockConnection = nil
	end

	if self.playerModeratedConnection then
		self.playerModeratedConnection:Disconnect()
		self.playerModeratedConnection = nil
	end

	if self.voiceToxicityModalConnection then
		self.voiceToxicityModalConnection:Disconnect()
		self.voiceToxicityModalConnection = nil
	end

	if self.VoiceToxicityToastConnection then
		self.VoiceToxicityToastConnection:Disconnect()
		self.VoiceToxicityToastConnection = nil
	end

	if self.voiceReverseNudgeConnection then
		self.voiceReverseNudgeConnection:Disconnect()
		self.voiceReverseNudgeConnection = nil
	end

	if self.tempSetMicMutedToggleMicConnection then
		self.tempSetMicMutedToggleMicConnection:Disconnect()
		self.tempSetMicMutedToggleMicConnection = nil
	end

	if v and self.videoCaptureInProgressConnection then
		self.videoCaptureInProgressConnection:Disconnect()
		self.videoCaptureInProgressConnection = nil
	end
end

function CoreVoiceManager.RequestHidePublicVoiceUI(p)
	task.defer(function()
		p.setVoiceUIVisibility:Fire(false)
	end)
end

function CoreVoiceManager.RequestShowPublicVoiceUI(p)
	task.defer(function()
		p.setVoiceUIVisibility:Fire(true)
	end)
end

CoreVoiceManager.default = CoreVoiceManager.new(
	BlockingUtility:GetAfterBlockedStatusChangedEvent(),
	permissionsProtocol.default,
	HttpRbxApiService,
	nil,
	nil,
	nil,
	nil,
	nil,
	ThirdPartyUserService,
	nil,
	AdService
)

local localPlayer = fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry
	and engineFeature
	and Players.LocalPlayer

if localPlayer then
	localPlayer.AncestryChanged:Connect(function(_, parent3)
		if parent3 == nil then
			CoreVoiceManager.default:ReportVoiceVolumeImpressionsIfNeeded()
		end
	end)
end

return CoreVoiceManager
