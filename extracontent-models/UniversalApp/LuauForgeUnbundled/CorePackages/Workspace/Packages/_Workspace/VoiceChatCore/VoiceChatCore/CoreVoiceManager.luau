local RunService = game:GetService("RunService")

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local VoiceChatService = game:GetService("VoiceChatService")
local HttpService = game:GetService("HttpService")
local fFlagUseAudioDeviceInputAddedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").FFlagUseAudioDeviceInputAddedSignal
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local AppStorageService = game:GetService("AppStorageService")
local NotificationService = game:GetService("NotificationService")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/IxpServiceWrapper").IXPServiceWrapper
local Players2 = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ThirdPartyUserService = game:GetService("ThirdPartyUserService")
local AdService = game:GetService("AdService")
local Chat = game:GetService("Chat")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Constants")
local Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Utils")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Analytics")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/Promise")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/Cryo")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/CallProtocol").CallProtocol.default
local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/CallProtocol").Enums
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/PermissionsProtocol").PermissionsProtocol
local BlockingUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/BlockingUtility")

local CoreGui = game:GetService("CoreGui")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/CoreScriptsInitializer").CoreLogger:new("CoreVoiceManager")

local defineFastFlag = game:DefineFastFlag("StringKeyFixForParticipantsTable", false)
local defineFastFlag2 = game:DefineFastFlag("ConsoleVoiceIXPEnabled", false)
local fFlagExpChatDictation = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").FFlagExpChatDictation

local defineFastString = game:DefineFastString(
	"ConsoleVoiceIXPLayerName",
	"User.Communication.ConsoleVoice"
)

local defineFastString2 = game:DefineFastString("ConsoleVoiceEnabledIXPLayerValue", "ConsoleVoiceEnabled")

local defineFastFlag3 = game:DefineFastFlag("SendVoiceCapturedDuringVideoCaptureEvent", false)

game:DefineFastInt("VoiceRewarmReArmCount", 0)

local getFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local GetFFlagLuaConsumePlayerModerated = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagLuaConsumePlayerModerated")
local getFFlagLocalMutedNilFix = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagLocalMutedNilFix
local GetFFlagEnableVoiceReverseNudge = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagEnableVoiceReverseNudge")
local GetFFlagClearUserFromRecentVoiceDataOnLeave = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagClearUserFromRecentVoiceDataOnLeave")
local GetFIntVoiceUsersInteractionExpiryTimeSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFIntVoiceUsersInteractionExpiryTimeSeconds")
local getFFlagAvatarChatServiceEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagVoiceChatServiceManagerUseAvatarChat")
local getFFlagJoinWithoutMicPermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagJoinWithoutMicPermissions
local GetFFlagBatchVoiceParticipantsUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagBatchVoiceParticipantsUpdates")
local GetFIntThrottleParticipantsUpdateMs = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFIntThrottleParticipantsUpdateMs")
local getFFlagSeamlessVoiceFTUX = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagSeamlessVoiceFTUX
local GetFFlagEnableFtuxExitOnMuteToggle = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagEnableFtuxExitOnMuteToggle")
local GetFFlagEnableSeamlessVoiceFeature = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagEnableSeamlessVoiceFeature")
local GetFFlagFixGetPlayerByUserIdStringCast = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagFixGetPlayerByUserIdStringCast")
local fFlagDebugShowAudioDeviceInputDebugger = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagDebugShowAudioDeviceInputDebugger()

local defineFastString3 = game:DefineFastString(
	"VoicePerformanceThrottlingIXPLayerName",
	"Voice.Performance"
)

local defineFastString4 = game:DefineFastString(
	"ThrottleParticipantsUpdateIXPLayerValue",
	"ThrottleParticipantsUpdate"
)
local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagUseAudioAnalyzerForLocalMetering2")()
local defineFastFlag4 = game:DefineFastFlag("StopModerationConnectionOnLeave", false)

local engineFeature = game:GetEngineFeature("VoiceVolumeControlsApplyGameSettingsVoiceVolume")

local defineFastFlag5 = game:DefineFastFlag(
	"VoiceVolumeControlsEnableVoiceVolumeEligibilityTelemetry",
	false
)

local v7 = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry")()
local VoiceVolumeControlsEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/VoiceVolumeControlsEligibility")

local engineFeature2 = game:GetEngineFeature("EnableMutedByLocalUser")
local defineFastFlag6 = game:DefineFastFlag("VoiceChatMuteAllSyncMutedPlayers", false)

local engineFeature3 = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local getFFlagEnableVoiceChatMuteForVideoCaptures = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagEnableVoiceChatMuteForVideoCaptures

local v8 = defineFastFlag3 and getFFlagEnableVoiceChatMuteForVideoCaptures()
local GetFFlagDebugVoiceChatMicPermissionCliBypass = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagDebugVoiceChatMicPermissionCliBypass")

local getFFlagEnableVoiceSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagEnableVoiceSignal

local getFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local getFFlagVoiceChatClientRewriteMasterLua = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagVoiceChatClientRewriteMasterLua

local getFFlagCheckUniversePlaceBeforeSuspending = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").GetFFlagCheckUniversePlaceBeforeSuspending
local fFlagEnablePartyVoiceChangersInLua = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/SharedFlags").FFlagEnablePartyVoiceChangersInLua
local FFlagSkipVoiceInTeamCreateViewer = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/FFlagSkipVoiceInTeamCreateViewer")
local GetFFlagCoreMicManagerRefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagCoreMicManagerRefactor")
local GetFFlagMicConsumerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Flags/GetFFlagMicConsumerRegistry")
local v9 = if GetFFlagCoreMicManagerRefactor() then require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/MicInputManager") else nil

local WATCHED_NAMESPACES = Constants.WATCHED_NAMESPACES
local WATCHED_MESSAGE_TYPES = Constants.WATCHED_MESSAGE_TYPES
local VOICE_CHAT_AVAILABILITY = Constants.VOICE_CHAT_AVAILABILITY
local MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED = Constants.MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED
local MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY = Constants.MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY
local PERMISSION_STATE = Constants.PERMISSION_STATE
local VOICE_JOIN_PROGRESS = Constants.VOICE_JOIN_PROGRESS
local FAE_ENABLED = Constants.FAE_ENABLED
local FAE_SETTINGS_TOAST = Constants.FAE_SETTINGS_TOAST

local GetShowAgeVerificationOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Requests/GetShowAgeVerificationOverlay")
local GetShowPhoneVerificationUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/VoiceChatCore/VoiceChatCore/Requests/GetShowPhoneVerificationUpsell")

local v10 = {
	eventName = "VoiceCapturedDuringVideoCapture",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("VoiceCapturedDuringVideoCaptureThrottlingPercentage", 10000),
	lastUpdated = { 26, 1, 28 },
	description = "Event fired when a video capture has stopped logging if voice was captured",
	links = ""
}

local AvatarChatService = if getFFlagAvatarChatServiceEnabled() then game:GetService("AvatarChatService") else nil
local CaptureService

if getFFlagEnableVoiceChatMuteForVideoCaptures() then
	CaptureService = game:GetService("CaptureService")
end

local TelemetryService = if v8 then game:GetService("TelemetryService") else nil

local v11 = {
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

local v12 = if getFFlagJoinWithoutMicPermissions() then PERMISSION_STATE.IDLE else nil
v11.permissionState = v12
v11.recentUsersInteractionData = nil
v11.NotificationService = NotificationService
v11.PermissionsService = permissionsProtocol.default
v11.ChatService = Chat
v11.voiceEnabled = false
v11.service = nil
v11.SignalREventTable = {}
v11.isInCall = false
v11.callMutedState = false
v11.audioDeviceInputAdded = nil
v11.muteChanged = Instance.new("BindableEvent")
v11.voiceChangerChanged = Instance.new("BindableEvent")
v11.voiceChangerHearMyselfChanged = Instance.new("BindableEvent")
v11.muteAllChanged = Instance.new("BindableEvent")
v11.participantLeft = Instance.new("BindableEvent")
v11.participantJoined = Instance.new("BindableEvent")
v11.participantsUpdate = Instance.new("BindableEvent")
v11.talkingChanged = Instance.new("BindableEvent")
v11.attemptVoiceRejoin = Instance.new("BindableEvent")
v11.onPlayerMuteToggled = Instance.new("BindableEvent")
v11.setVoiceUIVisibility = Instance.new("BindableEvent")
v11.communicationPermissionsResult = nil
v11.VoiceJoinProgress = VOICE_JOIN_PROGRESS.Idle
v11.VoiceJoinProgressChanged = Instance.new("BindableEvent")
v11._voiceVolumeEligibilityReported = false
v11.mutedPlayers = {}
v11.voiceChangerActivePlayers = {}
v11.BlockStatusChanged = nil
v11.AvatarChatService = AvatarChatService
v11.HttpRbxApiService = HttpRbxApiService
v11.ThirdPartyUserService = ThirdPartyUserService
v11.CaptureService = CaptureService
v11.TelemetryService = TelemetryService
v11.SendMuteEvent = nil
v11.SetVoicePackEvent = nil
v11.VoiceChangerWasToggledEvent = nil
v11.InputToModifierWire = nil
v11.PartyVoiceDeviceInput = nil
v11._mutedAnyone = false
v11.canUseServiceResult = nil
v11.signalRConnectionChanged = nil
v11.signalRConnection = nil
v11.AdService = AdService
v11.isPlayerWatchingAd = false
v11.options = {
	allowSeamlessVoice = true,
	passInitErrorInPromiseReject = false,
	forceVoiceEnabled = false
}

v11.initializedPostSuspension = false
v11.voiceCapturedDuringVideoCapture = false
v11._voiceJoinTimestampMs = nil
v11._voiceVolumeSliderEligibleAtJoin = false
v11._gameSettingsOpenedTimestampMs = nil

local v13 = { localMuted = true, isTalking = true, permissionState = true }

function v11.__index(p2, p3)
	if GetFFlagCoreMicManagerRefactor() then
		local v14 = rawget(p2, "micManager")

		if v14 and v13[p3] then
			return v14[p3]
		end
	end

	return v11[p3]
end

function v11.__newindex(p2, p3, p4)
	if GetFFlagCoreMicManagerRefactor() then
		local v14 = rawget(p2, "micManager")

		if v14 and v13[p3] then
			v14[p3] = p4
			return
		end
	end

	rawset(p2, p3, p4)
end

function v11.new(p2, p3, p4, object, p5, p6, p7, p8, p9, p10, p11)
	local object2 = setmetatable({
		previousSessionId = nil,
		HttpRbxApiService = p4,
		eventEmitter = Utils.EventEmitter.new(),
		service = object,
		PermissionsService = p3,
		NotificationService = p6,
		AvatarChatService = p7,
		Analytics = module3.new(p5),
		SequenceNumbers = {},
		SignalREventTable = {},
		audioDevices = {},
		BlockStatusChanged = p2,
		AppStorageService = p8 or AppStorageService,
		ThirdPartyUserService = p9,
		CaptureService = p10,
		AdService = p11
	}, v11)

	for k, v14 in WATCHED_MESSAGE_TYPES do
		object2.SignalREventTable[v14] = Instance.new("BindableEvent")
	end

	object2.shouldThrottleParticipantUpdate = false
	object2.participantsStateThrottleTime = 0
	object2.lastParticipantsStateUpdate = 0
	object2.lastStateUpdateCounter = 0

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		task.spawn(function()
			local success, result = pcall(function()
				if Players2.LocalPlayer then
					return object:IsVoiceEnabledForUserIdAsync(Players2.LocalPlayer.UserId)
				end

				return false
			end)

			if not success then
				v5:debug("Unable to get voice enabled status: ", result)
			elseif result then
				ixpServiceWrapper:LogUserLayerExposure(defineFastString3)
			end
		end)
		object2.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000
		local success, result = pcall(function()
			return ixpServiceWrapper:GetLayerData(defineFastString3)
		end)

		if success and result and result[defineFastString4] then
			object2.shouldThrottleParticipantUpdate = true
		end
	end

	if not GetFFlagCoreMicManagerRefactor() then
		return object2
	end

	object2.micManager = v9.new({
		log = v5,
		callbacks = {
			emitGetPermissions = function(p12, p13, p14, p15)
				object2:emit("GetPermissions", p12, p13, p14, p15)
			end,
			emitOnPermissionRequested = function()
				object2:emit("OnPermissionRequested")
			end,
			emitOnRequestMicPermissionResolved = function()
				object2:emit("OnRequestMicPermissionResolved")
			end,
			emitOnRequestMicPermissionRejected = function()
				object2:emit("OnRequestMicPermissionRejected")
			end,
			emitOnShowDataConsentToast = function()
				object2:emit("OnShowDataConsentToast")
			end,
			emitOnMicPermissionDeniedToast = function()
				object2:emit("OnMicPermissionDeniedToast")
			end,
			emitOnMicFirstUnmutePrivacy = function()
				object2:emit("OnMicFirstUnmutePrivacy")
			end,
			getAudioDevices = function()
				return object2.audioDevices
			end,
			getSendMuteEvent = function()
				return object2:GetSendMuteEvent()
			end,
			isSignalActive = function(p12)
				return object2:IsSignalActive(p12)
			end,
			reportVoiceMuteSelf = function(p12)
				object2.Analytics:reportVoiceMuteSelf(p12)
			end,
			getJoinWithVoiceMuteData = function(p12)
				return object2:JoinWithVoiceMuteData(p12)
			end,
			recordExperienceJoinMicPerm = function(p12)
				object2:RecordExperienceJoinMicPermissionStatus(p12)
			end,
			reportJoinFailed = function(p12, p13)
				object2:_reportJoinFailed(p12, p13 or module3.ERROR)
			end,
			requestPermissions = function(p12)
				return object2.PermissionsService:requestPermissions(p12)
			end,
			getPassInitErrorInPromiseReject = function()
				return object2.options.passInitErrorInPromiseReject
			end,
			onVoiceCapturedDuringVideoCapture = function(p12)
				if v8 and object2.CaptureService:IsCapturingVideo() then
					object2.voiceCapturedDuringVideoCapture = object2.voiceCapturedDuringVideoCapture or p12
				end
			end,
			getService = function()
				return object2.service
			end
		}
	})

	object2.muteChanged = object2.micManager.muteChanged
	object2.talkingChanged = object2.micManager.talkingChanged

	if GetFFlagMicConsumerRegistry() then
		object2.hasConsumersChanged = object2.micManager.hasConsumersChanged
		object2.micManager:SetupDeveloperDeviceTracking()
	end

	return object2
end

function v11.emit(p2, p3, ...)
	p2.eventEmitter:emit(p3, ...)
end

function v11.subscribe(p2, p3, p4)
	p2.eventEmitter:addListener(p3, p4)
end

function v11.unsubscribe(p2, p3, p4)
	p2.eventEmitter:removeListener(p3, p4)
end

function v11.unsubscribeAll(p2)
	p2.eventEmitter:removeAllListeners()
end

function v11:CheckCallStateWithPromise()
	return default:getCallState():andThen(function(p3)
		v5:trace("Got user call state")

		if
			p3.status ~= enums.CallStatus.Idle.rawValue()
			and p3.status ~= enums.CallStatus.Ringing.rawValue()
		then
			self.isInCall = true
			self.callMutedState = p3.muted
			v5:trace("Changing call muted state to {}", p3.muted)
		end
	end):catch(function(p3)
		v5:trace("User not in call {}", p3)
	end)
end

function v11:CheckCallState()
	v5:trace("Checking user call state")
	local success, result = pcall(function()
		default:getCallState():andThen(function(p3)
			v5:trace("Got user call state")

			if
				p3.status ~= enums.CallStatus.Idle.rawValue()
				and p3.status ~= enums.CallStatus.Ringing.rawValue()
			then
				self.isInCall = true
				self.callMutedState = p3.muted
				v5:trace("Changing call muted state to {}", p3.muted)
			end
		end):catch(function(p3)
			v5:trace("User not in call {}", p3)
		end)
	end)

	if not success then
		v5:debug("Error checking user call state {}", result)
	end
end

function v11:_GetShowAgeVerificationOverlay(p3)
	return GetShowAgeVerificationOverlay(Utils.bind(self, "GetRequest"), tostring(game.GameId), tostring(game.PlaceId), p3)
end

function v11:FetchAgeVerificationOverlay(p2)
	if not self._getShowAgeVerificationOverlayResult then
		if not self._getShowAgeVerificationOverlayPromise then
			self._getShowAgeVerificationOverlayPromise = Promise.new(function(callback, p3)
				self._getShowAgeVerificationOverlayResult = self:_GetShowAgeVerificationOverlay(p2)
				callback(self._getShowAgeVerificationOverlayResult)
			end)
		end

		self._getShowAgeVerificationOverlayPromise:await()
	end

	return self._getShowAgeVerificationOverlayResult
end

function v11:_GetShowPhoneVerificationUpsell(p3, p4)
	return (GetShowPhoneVerificationUpsell(Utils.bind(self, "GetRequest"), tostring(game.GameId), p3, p4))
end

function v11:FetchPhoneVerificationUpsell(p2, p3, p4)
	if not self._getShowPhoneVerificationUpsellResult then
		self._getShowPhoneVerificationUpsellResult = {}
		self._getShowPhoneVerificationUpsellPromise = {}
	end

	if not self._getShowPhoneVerificationUpsellResult[p2] or p4 then
		if not self._getShowPhoneVerificationUpsellPromise[p2] or p4 then
			self._getShowPhoneVerificationUpsellPromise[p2] = Promise.new(function(callback, p5)
				local showPhoneVerificationUpsell = self:_GetShowPhoneVerificationUpsell(p2, p3)
				local getShowPhoneVerificationUpsellResult = self._getShowPhoneVerificationUpsellResult
				local v15 = if type(showPhoneVerificationUpsell) == "table" and showPhoneVerificationUpsell.valueProp ~= nil then showPhoneVerificationUpsell.valueProp else Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
				getShowPhoneVerificationUpsellResult[p2] = v15

				callback()
			end)
		end

		self._getShowPhoneVerificationUpsellPromise[p2]:await()
	end

	return self._getShowPhoneVerificationUpsellResult[p2]
end

function v11:DisablePhoneVerificationUpsell()
	self._getShowPhoneVerificationUpsellResult = Cryo.Dictionary.map(
		self._getShowPhoneVerificationUpsellResult,
		function()
			return Constants.PHONE_UPSELL_VOICE_CHAT_PROP.None
		end
	)
end

function v11:GetNudgeAnalyticsData()
	return Players.LocalPlayer.UserId, self:GetSessionId()
end

function v11:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p3)
	local v14 = {
		isUniverseEnabledForVoice = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.UniverseAudio
		),
		isPlaceEnabledForVoice = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.PlaceAudio
		),
		isUniverseEnabledForAvatarVideo = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.UniverseVideo
		),
		isPlaceEnabledForAvatarVideo = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.PlaceVideo
		)
	}

	local v15 = {
		isUserEligible = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.UserAudioEligible
		),
		isVoiceEnabled = self.AvatarChatService:IsEnabled(p3, Enum.AvatarChatServiceFeature.UserAudio),
		isAvatarVideoEligible = self.AvatarChatService:IsEnabled(
			p3,
			Enum.AvatarChatServiceFeature.UserVideoEligible
		),
		isAvatarVideoEnabled = self.AvatarChatService:IsEnabled(p3, Enum.AvatarChatServiceFeature.UserVideo),
		isUserVerifiedForVoice = 0,
		isBanned = 0,
		bannedUntil = nil
	}

	local v16 = if getFFlagEnableVoiceSignal() then self.AvatarChatService:IsEnabled(
		p3,
		Enum.AvatarChatServiceFeature.UserVerifiedForVoice
	) else nil
	v15.isUserVerifiedForVoice = v16

	v15.isBanned = self.AvatarChatService:IsEnabled(p3, Enum.AvatarChatServiceFeature.UserBanned)

	return { universePlaceVoiceEnabledSettings = v14, voiceSettings = v15 }
end

function v11:resolveAvatarChatUserAndPlaceSettings()
	local success, clientFeaturesAsync = pcall(
		self.AvatarChatService.GetClientFeaturesAsync,
		self.AvatarChatService
	)

	if success then
		return self:avatarChatUserAndPlaceSettingsValueOfClientFeatures(clientFeaturesAsync)
	end

	return nil
end

function v11.GetRequest(p2, p3, p4)
	local success, result = pcall(function()
		return HttpService:JSONDecode((p2.HttpRbxApiService:GetAsyncFullUrl(
			p3,
			Enum.ThrottlingPriority.Default,
			Enum.HttpRequestType.Players
		)))
	end)

	return success and result
end

function v11.PostUserVoiceConnectionStatus(p2, p3)
	local success, result = pcall(function()
		local jsonEncode = HttpService:JSONEncode({ IsUserVoiceConnected = p3 })

		return HttpService:JSONDecode((p2.HttpRbxApiService:PostAsyncFullUrl(
			Constants.VOICE_URL .. "/v1/user-voice-connection-state",
			jsonEncode
		)))
	end)

	return success
end

function v11:GetVoiceAnalyticsData()
	return {
		universeId = game.GameId,
		placeId = game.PlaceId,
		playSessionId = not engineFeature3 and "" or RbxAnalyticsService:GetPlaySessionId(),
		voiceSessionId = not self.service and "" or self:GetSessionId(),
		micAvailability = ""
	}
end

function v11:RecordExperienceJoinMicPermissionStatus(p2)
	local voiceAnalyticsData = self:GetVoiceAnalyticsData()

	if p2 == nil or typeof(p2) ~= "table" then
		if self.permissionState then
			if self.permissionState == PERMISSION_STATE.LISTEN_AND_TALK then
				voiceAnalyticsData.micAvailability = "Granted"
			else
				voiceAnalyticsData.micAvailability = "Denied"
			end
		end
	elseif p2.status == permissionsProtocol.Status.AUTHORIZED then
		voiceAnalyticsData.micAvailability = "Granted"
	else
		voiceAnalyticsData.micAvailability = "Denied"
	end

	self.Analytics:reportVoiceEvents("experienceJoinDeviceMicPermissionEvent", voiceAnalyticsData)
end

function v11:CheckCaptureMute()
	if getFFlagEnableVoiceChatMuteForVideoCaptures() then
		return self.CaptureService:IsCapturingVideo()
	end

	return false
end

function v11:ToggleMuteSome(items, p2, p3, p4)
	self:ensureInitialized("mute some players")
	self._mutedAnyone = true

	local v14 = p2 or self:CheckCaptureMute()
	local set = {}

	for k, item in items do
		if VoiceChatService.UseNewAudioApi then
			set[item] = true
			self.mutedPlayers[item] = v14
		else
			self.service:SubscribePause(item, v14)
		end

		local participant = self.participants[tostring(item)]

		if not participant then
			continue
		end

		participant.isMutedLocally = v14
		self.participantsUpdate:Fire(self.participants)
	end

	if VoiceChatService.UseNewAudioApi then
		for k in self.audioDevices do
			if not (k.Player and set[k.Player.UserId]) then
				continue
			end

			if engineFeature2 and k.Player ~= Players.LocalPlayer then
				k.MutedByLocalUser = v14
			else
				k.Active = not v14
			end
		end
	end

	if p3 and p4 then
		self.Analytics:reportVoiceMuteGroup(self:JoinWithVoiceMuteData({
			groupType = p3,
			context = p4,
			muted = v14
		}))
	end
end

function v11:GetMutedAnyone()
	return self._mutedAnyone
end

function v11:RecordGameSettingsOpened()
	if v7 and engineFeature and self._voiceJoinTimestampMs and not self._gameSettingsOpenedTimestampMs then
		self._gameSettingsOpenedTimestampMs = DateTime.now().UnixTimestampMillis
	end
end

function v11:ResetVoiceVolumeImpressionsSession()
	if v7 and engineFeature then
		self._voiceJoinTimestampMs = nil
		self._voiceVolumeSliderEligibleAtJoin = false
		self._gameSettingsOpenedTimestampMs = nil
	end
end

function v11:ReportVoiceVolumeImpressionsIfNeeded()
	if not (v7 and engineFeature and self._voiceJoinTimestampMs and self._voiceVolumeSliderEligibleAtJoin) then
		return
	end

	local v14 = self._gameSettingsOpenedTimestampMs ~= nil
	local voiceAnalyticsData = self:GetVoiceAnalyticsData()
	self.Analytics:reportVoiceVolumeImpressions({
		playSessionId = voiceAnalyticsData.playSessionId,
		voiceSessionId = voiceAnalyticsData.voiceSessionId,
		sliderSeen = v14,
		voiceJoinTimestampMs = self._voiceJoinTimestampMs,
		sliderSeenTimestampMs = self._gameSettingsOpenedTimestampMs
	})

	self:ResetVoiceVolumeImpressionsSession()
end

function v11:ToggleMutePlayer(p2, p3)
	self:ensureInitialized("mute player " .. p2)
	self._mutedAnyone = true
	local v15 = (if VoiceChatService.UseNewAudioApi then not self.mutedPlayers[p2] else not self.service:IsSubscribePaused(p2))
		or self:CheckCaptureMute()
	v5:trace("Setting mute for {} to {}", Utils.shorten(p2), v15)

	if GetFFlagEnableFtuxExitOnMuteToggle() then
		self.onPlayerMuteToggled:Fire()
	end

	if VoiceChatService.UseNewAudioApi then
		self.mutedPlayers[p2] = v15

		for k in self.audioDevices do
			if not (k.Player and k.Player.UserId == p2) then
				continue
			end

			if engineFeature2 and k.Player ~= Players.LocalPlayer then
				k.MutedByLocalUser = v15
			else
				local participant = self.participants[tostring(p2)]
				local v16 = participant and not participant.isMuted

				if v15 then
					v16 = false
				end

				k.Active = v16
			end
		end

		self:emit("OnPlayerMuted")
	else
		self.service:SubscribePause(p2, v15)
	end

	for k, participant in pairs(self.participants) do
		if participant.userId ~= p2 then
			continue
		end

		participant.isMutedLocally = v15
		self.participantsUpdate:Fire(self.participants)
	end

	if p3 then
		self.Analytics:reportVoiceMuteIndividual(self:JoinWithVoiceMuteData({
			targetUserId = tonumber(p2),
			context = p3,
			muted = v15
		}))
	end
end

function v11:MuteAll(p2, p3)
	self:ensureInitialized("mute all")
	self._mutedAnyone = true
	local v14 = p2 or self:CheckCaptureMute()

	if VoiceChatService.UseNewAudioApi then
		self.muteAll = v14
		v5:trace("Setting self mute all to {} context: {}", v14, p3)

		if defineFastFlag6 and not v14 then
			table.clear(self.mutedPlayers)
		end

		for k in self.audioDevices do
			if not (k.Player and k.Player ~= Players.LocalPlayer) then
				continue
			end

			v5:debug("Local muting {} to '{} = {}'", k.Player.Name, k.Active, v14)

			if engineFeature2 then
				k.MutedByLocalUser = v14

				if defineFastFlag6 then
					self.mutedPlayers[k.Player.UserId] = v14
				end
			else
				local userId = k.Player.UserId
				self.mutedPlayers[userId] = v14
				local participant = self.participants[tostring(userId)]
				local v15 = participant and not participant.isMuted

				if v14 then
					v15 = false
				end

				k.Active = v15
			end
		end
	else
		self.service:SubscribePauseAll(v14)
	end

	for k, participant in pairs(self.participants) do
		participant.isMutedLocally = v14
		self.participantsUpdate:Fire(self.participants)
	end

	self.muteAllChanged:Fire(v14)

	if p3 then
		self.Analytics:reportVoiceMuteGroup(self:JoinWithVoiceMuteData({
			groupType = Constants.VOICE_GROUP_TYPE.ALL,
			context = p3,
			muted = v14
		}))
	end
end

function v11:FetchVoicePermissions()
	if not self.communicationPermissionsResult then
		self.communicationPermissionsResult = self:resolveAvatarChatUserAndPlaceSettings()
	end

	return self.communicationPermissionsResult
end

function v11:verifyUniverseAndPlaceCanUseVoice()
	local v14

	if getFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() then
		v14 = self:resolveAvatarChatUserAndPlaceSettings()
	else
		v14 = self:FetchAgeVerificationOverlay()
	end

	if v14 then
		local universePlaceVoiceEnabledSettings = v14.universePlaceVoiceEnabledSettings

		return universePlaceVoiceEnabledSettings
			and universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
			and universePlaceVoiceEnabledSettings.isUniverseEnabledForVoice
	end

	self:_reportJoinFailed("invalidResponse", module3.ERROR)
	return false
end

function v11:IsUserInFTUX(): boolean
	if
		not getFFlagSeamlessVoiceFTUX()
		or getFFlagCheckUniversePlaceBeforeSuspending() and not self:verifyUniverseAndPlaceCanUseVoice()
	then
		return false
	end

	local AppStorageService2 = game:GetService("AppStorageService")
	local v14 = nil

	if not pcall(function()
		v14 = AppStorageService2:GetItem("SeamlessVoiceFTUX") == "true"
	end) then
		v5:warning("Failed to read FTUX/STUX from AppStorage")
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if
		type(ageVerificationOverlay) ~= "table"
		or not ageVerificationOverlay.voiceSettings
		or ageVerificationOverlay.voiceSettings.seamlessVoiceStatus == 3
	then
		return not v14
	end

	v5:debug("User not eligible for FTUX/STUX")
	return false
end

function v11:isEnableDefaultVoiceOnForPlace()
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end

	return VoiceChatService.UseNewAudioApi or VoiceChatService.EnableDefaultVoice
end

function v11:verifyPlaceCanUseVoice(p2, p3): boolean
	if not (p2 and p3) then
		self:_reportJoinFailed("invalidResponse", module3.ERROR)
		return false
	end

	if not p2.isUniverseEnabledForVoice then
		self:_reportJoinFailed("universeNotEnabled")
		return false
	end

	self:emit("OnUserAndPlaceCanUseVoiceResolved", p3, p2)

	if not p2.isPlaceEnabledForVoice then
		self:_reportJoinFailed("placeNotEnabled")
		return false
	end

	if self:isEnableDefaultVoiceOnForPlace() then
		return true
	end

	return false
end

function v11:EligibleForFaeUpsell()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay or type(ageVerificationOverlay) ~= "table" then
		return false
	end

	local v14 = ageVerificationOverlay.inExperienceFaeUpsell == FAE_ENABLED
	local isPlaceEnabledForVoice = ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	return v14 and isPlaceEnabledForVoice
end

function v11:OptUserToJoinVoice()
	v5:debug("Opting user to join voice on age verification")
	self.hasOptedToJoinVoiceOnAgeVerification = true
end

function v11:SetupFAECompleteListener()
	v5:debug("Setting up FAE complete listener")

	if game:GetEngineFeature("ChatReconcileAccess") then
		v5:debug("Using ChatService ReconcileCommunicationAccessCompleted event")
		self.ChatService.ReconcileCommunicationAccessCompleted:Connect(function()
			v5:debug("FAE complete listener triggered, re-fetching voice permissions")

			self.communicationPermissionsResult = nil
			self:FetchVoicePermissions()
			self._getShowAgeVerificationOverlayResult = self:_GetShowAgeVerificationOverlay()

			if self.hasOptedToJoinVoiceOnAgeVerification then
				v5:debug("FAE complete listener triggered, attempting voice rejoin")

				if self:IsSeamlessVoice() then
					v5:debug("Opting-in user to voice")
					self.AvatarChatService:EnableVoice()
					self.attemptVoiceRejoin:Fire()
				end
			end
		end)
	end
end

function v11:EligibleForAgeCheckToast()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay or type(ageVerificationOverlay) ~= "table" then
		return false
	end

	local isPlaceEnabledForVoice = ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	local v14 = ageVerificationOverlay.inExperienceFaeUpsell == FAE_SETTINGS_TOAST
	return isPlaceEnabledForVoice and self:isEnableDefaultVoiceOnForPlace() and v14
end

function v11:userAndPlaceCanUseVoice()
	if
		self.ThirdPartyUserService ~= nil
		and self.ThirdPartyUserService:IsChatRestrictionSupported()
		and self.ThirdPartyUserService:GetVoiceChatRestrictionStatus() ~= Enum.ChatRestrictionStatus.NotRestricted
	then
		return false
	end

	local v14

	if getFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() then
		v14 = self:resolveAvatarChatUserAndPlaceSettings()
	else
		v14 = GetShowAgeVerificationOverlay(Utils.bind(self, "GetRequest"), tostring(game.GameId), (tostring(game.PlaceId)))
	end

	if not v14 then
		self:_reportJoinFailed("invalidResponse", module3.ERROR)
		return false
	end

	if self.options.forceVoiceEnabled then
		v14.voiceSettings.isVoiceEnabled = true
		v5:debug("bypassing voice permissions check")
	end

	local universePlaceVoiceEnabledSettings = v14.universePlaceVoiceEnabledSettings
	local voiceSettings = v14.voiceSettings
	v5:trace("Voice settings endpoint returned {}", v14)

	if not self:verifyPlaceCanUseVoice(universePlaceVoiceEnabledSettings, voiceSettings) then
		return false
	end

	if getFFlagEnableVoiceSignal() then
		self.communicationPermissionsResult = v14
		local now = getFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and os.time()

		local v15 = getFFlagEnableInExpPhoneVoiceUpsellEntrypoints()
			and not self:UserVoiceEnabled()
			and not voiceSettings.isUserVerifiedForVoice
			and (self:FetchPhoneVerificationUpsell(Constants.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat or now and self:FetchPhoneVerificationUpsell(
				Constants.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER,
				now
			) == Constants.PHONE_UPSELL_VOICE_CHAT_PROP.VoiceChat)

		if self:UserEligibleForInExperienceUpsell() or v15 then
			self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		end

		local voiceConnectCookie = self:GetVoiceConnectCookie()
		local v16 = self:HasSeamlessVoiceFeature(Constants.SeamlessVoiceFeatures.DeferConnection)
			and voiceConnectCookie == ""

		local v17 = self:IsSeamlessVoice() and voiceConnectCookie == "false"

		if v16 or v17 then
			self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Suspended)
		elseif self:EligibleForFaeUpsell() then
			v5:debug("Suspending voice join for FAE Eligible user")
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

function v11.voicePermissionGranted(p2, p3): boolean
	if typeof(p3) == "table" then
		return p3.status == permissionsProtocol.Status.AUTHORIZED
			or not Cryo.List.find(
				p3.missingPermissions,
				permissionsProtocol.Permissions.MICROPHONE_ACCESS
			)
	end

	return p3 == permissionsProtocol.Status.AUTHORIZED
end

function v11:RawGetPermissions(p2)
	return Promise.new(function(callback, p3)
		self:emit("GetPermissions", function(p4)
			callback(p4)
		end, p2, true, true)
	end)
end

function v11:requestMicPermission()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:RequestMicPermission()
	end

	if GetFFlagDebugVoiceChatMicPermissionCliBypass() then
		self.permissionState = PERMISSION_STATE.LISTEN_AND_TALK
		return Promise.resolve()
	end

	if self.permissionPromise then
		v5:trace("PermissionProtocol already invoked")

		return self.permissionPromise
	end

	local v14 = { permissionsProtocol.Permissions.MICROPHONE_ACCESS }

	self.permissionPromise = self.PermissionsService:requestPermissions(v14):andThen(function(p2)
		self:RecordExperienceJoinMicPermissionStatus(p2)

		if p2 or p2.status then
			v5:debug("Permission status {}", p2.status)

			local v15 = p2.status == permissionsProtocol.Status.AUTHORIZED

			if self.options.passInitErrorInPromiseReject and not v15 then
				return Promise.reject({ code = "INIT_ERROR_PERM_NOT_GRANTED" })
			end

			return v15 and Promise.resolve() or Promise.reject()
		end

		v5:debug("No permission response, rejecting access")
		self:_reportJoinFailed("noPermissionResponse", module3.ERROR)

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

function v11:JoinByGroupIdToken(previousGroupId, previousMutedState)
	self.previousGroupId = previousGroupId
	self.previousMutedState = previousMutedState
	return self.service:JoinByGroupIdToken(previousGroupId, previousMutedState)
end

function v11:EnableVoice()
	v5:trace("Enabling voice")

	self.AvatarChatService:GetPropertyChangedSignal("ClientFeatures"):Once(function()
		self.attemptVoiceRejoin:Fire()
	end)
	self.AvatarChatService:EnableVoice()
end

function v11:ChangeVoiceJoinProgress(voiceJoinProgress)
	self.VoiceJoinProgress = voiceJoinProgress
	self.VoiceJoinProgressChanged:Fire(self.VoiceJoinProgress)
end

function v11:setOptions(options)
	self.options = options
end

function v11:ShouldShowJoinVoiceOnDisconnect()
	return self:IsSeamlessVoice() and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
end

function v11:IsSeamlessVoice(): boolean
	if getFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and not self.options.allowSeamlessVoice then
		return false
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if
		type(ageVerificationOverlay) ~= "table"
		or not (ageVerificationOverlay and ageVerificationOverlay.voiceSettings)
		or getFFlagCheckUniversePlaceBeforeSuspending() and not self:verifyUniverseAndPlaceCanUseVoice()
	then
		return false
	end

	local seamlessVoiceStatus = ageVerificationOverlay.voiceSettings.seamlessVoiceStatus
	return seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledExistingUser
		or seamlessVoiceStatus == Constants.SeamlessVoiceStatus.EnabledNewUser
end

function v11:HasSeamlessVoiceFeature(value)
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
		local v14 = type(value) == "string" and { value } or value

		if GetFFlagEnableSeamlessVoiceFeature(v14) then
			local jsonDecode = Utils.jsonDecode(seamlessVoiceVariant)
			local set = {}

			for k, v15 in pairs(jsonDecode) do
				set[v15] = true
			end

			if
				#v14 == 1
				and v14[1] == Constants.SeamlessVoiceFeatures.ConnectDisconnect
				and seamlessVoiceVariant == Constants.SeamlessVoiceVariants.OnlyConnectDisconnect
			then
				return true
			end

			for k, v15 in pairs(v14) do
				if not set[v15] then
					return false
				end
			end

			return true
		end
	else
		local v15 = ({
			[Constants.SeamlessVoiceFeatures.ConnectDisconnect] = function(p2): boolean
				return p2 ~= Constants.SeamlessVoiceVariants.Control
			end,
			[Constants.SeamlessVoiceFeatures.HearingWithoutMicPermissions] = function(p2): boolean
				return p2 == Constants.SeamlessVoiceVariants.HearingWithoutMicPermissions
			end
		})[value]

		if v15 then
			return v15(seamlessVoiceVariant)
		end
	end

	return false
end

function v11:IsNewSeamlessVoiceUserDisconnect()
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

function v11:_isValidAgeVerificationOverlayData(p3)
	return type(p3) == "table" and p3 and p3.voiceSettings
end

function v11:UserInInExperienceUpsellTreatment(): boolean
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if not ageVerificationOverlay then
		return false
	end

	local showVoiceInExperienceUpsellVariant = ageVerificationOverlay.showVoiceInExperienceUpsellVariant
	return showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT1
		or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT2
		or showVoiceInExperienceUpsellVariant == Constants.IN_EXP_UPSELL_VARIANT.VARIANT3
end

function v11:UserOnlyEligibleForVoice()
	local communicationPermissionsResult = self.communicationPermissionsResult

	if not (communicationPermissionsResult and communicationPermissionsResult.voiceSettings and communicationPermissionsResult.universePlaceVoiceEnabledSettings) then
		self:FetchVoicePermissions()
		communicationPermissionsResult = self.communicationPermissionsResult
	end

	return communicationPermissionsResult.voiceSettings.isUserVerifiedForVoice
		and not communicationPermissionsResult.voiceSettings.isVoiceEnabled
		and communicationPermissionsResult.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
end

function v11:UserOnlyEligibleForVoiceViaOverlay()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if self:_isValidAgeVerificationOverlayData(ageVerificationOverlay) then
		return ageVerificationOverlay.voiceSettings.isVerifiedForVoice
			and not ageVerificationOverlay.voiceSettings.isVoiceEnabled
			and ageVerificationOverlay.universePlaceVoiceEnabledSettings.isPlaceEnabledForVoice
	end

	return false
end

function v11:UserVoiceEnabled()
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

function v11:UserEligibleForInExperienceUpsell()
	local userOnlyEligibleForVoice = self:UserOnlyEligibleForVoice()

	if not userOnlyEligibleForVoice then
		return false
	end

	if getFFlagEnableVoiceSignal() then
		local userInInExperienceUpsellTreatment = self:UserInInExperienceUpsellTreatment()
		return userOnlyEligibleForVoice and userInInExperienceUpsellTreatment
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	return userOnlyEligibleForVoice
		and ageVerificationOverlay
		and ageVerificationOverlay.showVoiceInExperienceUpsell
end

function v11:canUseServiceAsync()
	if FFlagSkipVoiceInTeamCreateViewer and RunService:IsTeamCreateViewer() then
		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_CONTEXT_NOT_ENABLED" })
		end

		return Promise.reject()
	elseif self.available == nil and game:GetEngineFeature("VoiceChatSupported") then
		if not self.canUseServicePromise then
			self.canUseServicePromise = Promise.defer(function(callback, callback2)
				local userAndPlaceCanUseVoice = self:userAndPlaceCanUseVoice()

				if getFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
					self.canUseServiceResult = userAndPlaceCanUseVoice
					self:emit("OnCanUseServiceResult", userAndPlaceCanUseVoice)
				end

				if
					getFFlagEnableVoiceSignal()
					and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Suspended
				then
					v5:debug("Place is voice enabled but user is not, delaying voice rejection")
					self.attemptVoiceRejoin.Event:Wait()
					v5:debug("Attempting voice rejoin")

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
						v5:debug(
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
					v5:info("Voice access denied")

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
		v5:debug("Voice Chat is not Available, rejecting canUseService promise")

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_VOICE_NOT_SUPPORTED" })
		end

		return Promise.reject()
	end
end

function v11:_setRecentUserState(p3, p4)
	local v14 = self.recentUsersInteractionData[tostring(p3)] or {}
	local joined = Cryo.Dictionary.join(v14, p4)

	self.recentUsersInteractionData = Cryo.Dictionary.join(self.recentUsersInteractionData, {
		[tostring(p3)] = joined
	})
end
function v11:getRecentUsersInteractionData()
	self:_updateRecentUsersInteractionData()
	return self.recentUsersInteractionData
end

function v11:GetSignalREvent(p3)
	return self.SignalREventTable[p3].Event
end

function v11:StartModerationSignal()
	if not self.playerModeratedConnection then
		self.playerModeratedConnection = self:GetSignalREvent("ParticipantModeratedFromVoice"):Connect(function()
			v5:debug("User Moderated")
			self.previousSessionId = self.service:GetSessionId()
			self:emit("OnPlayerModerated")

			if getFFlagVoiceChatClientRewriteMasterLua() then
				VoiceChatService:notifyServerACSCleanup()
				VoiceChatService:leaveVoice()
			else
				VoiceChatService:notifyServerACSCleanup()
				self.service:Leave()
			end
		end)
	end
end

function v11:LeaveVoiceForRestriction()
	if not self.service then
		return
	end

	self.previousSessionId = self.service:GetSessionId()
	VoiceChatService:notifyServerACSCleanup()

	if getFFlagVoiceChatClientRewriteMasterLua() then
		VoiceChatService:leaveVoice()
	else
		self.service:Leave()
	end
end

function v11:StopModerationSignal()
	if self.playerModeratedConnection then
		self.playerModeratedConnection:Disconnect()
		self.playerModeratedConnection = nil
	end
end

function v11:_updateRecentUsersInteractionData()
	local now = os.time()
	local nones = {}

	if self.recentUsersInteractionData then
		for k, v14 in pairs(self.recentUsersInteractionData) do
			local v15 = if defineFastFlag then self.participants[tostring(k)] else self.participants[k]
			local v16 = GetFFlagClearUserFromRecentVoiceDataOnLeave() and not Players:GetPlayerByUserId((tonumber(k)))
			local v17 = now - v14.lastHeardTime >= GetFIntVoiceUsersInteractionExpiryTimeSeconds()
			local v18 = not v15 or v15.isMuted

			if v17 and v18 or v16 then
				nones[k] = Cryo.None
			end
		end

		self.recentUsersInteractionData = Cryo.Dictionary.join(self.recentUsersInteractionData, nones)
	end
end

function v11:SetupParticipantListeners()
	self:ensureInitialized("setup participant listeners")

	if not self.participants then
		self.participants = {}
		self.recentUsersInteractionData = {}
		self.updatedParticipants = {}

		self.participantConnection = self.service.ParticipantsStateChanged:Connect(function(list, list2, list3)
			v5:trace("Participants state changed")

			for i, item in ipairs(list) do
				if not (GetFFlagClearUserFromRecentVoiceDataOnLeave() or self.participants[tostring(item)].isMuted) then
					self:_setRecentUserState(item, { lastHeardTime = os.time() })
				end

				self.participants[tostring(item)] = nil
				self.participantLeft:Fire(self.participants, item)
				self:emit("OnVoiceParticipantRemoved", item)
			end

			for i, item in ipairs(list2) do
				self.participantJoined:Fire(self.participants, item)
				self:emit("OnVoiceParticipantAdded", item)
			end

			for k, item in pairs(list3) do
				local userId = item.userId

				local v14 = if defineFastFlag then self.participants[tostring(userId)] else self.participants[userId]

				if not item.isMuted or v14 and not v14.isMuted then
					local v16 = { lastHeardTime = os.time(), player = 0 }
					local v17 = if GetFFlagFixGetPlayerByUserIdStringCast() then Players:GetPlayerByUserId((tonumber(userId))) else Players:GetPlayerByUserId(userId)
					v16.player = v17
					self:_setRecentUserState(userId, v16)
				end

				if not v14 or v14.isMuted ~= item.isMuted then
					self:emit("OnVoiceParticipantToggleMuted", userId, item.isMuted)
				end

				if VoiceChatService.UseNewAudioApi then
					item.isMutedLocally = self.mutedPlayers[userId] and true or false
				end

				if VoiceChatService.UseNewAudioApi then
					local v15 = if self.mutedPlayers[userId] then self.mutedPlayers[userId] and true or false else item.isMutedLocally
					item.isMutedLocally = v15
				end

				if fFlagEnablePartyVoiceChangersInLua and VoiceChatService.UseNewAudioApi then
					local v15 = if self.voiceChangerActivePlayers[userId] then self.voiceChangerActivePlayers[userId] else item.isVoiceChangerActive
					item.isVoiceChangerActive = v15
				end

				if self.muteAll then
					item.isMutedLocally = true
				end

				self.participants[tostring(userId)] = item

				if GetFFlagBatchVoiceParticipantsUpdates() then
					self.updatedParticipants[tostring(userId)] = item
				end

				if v8 and self.CaptureService:IsCapturingVideo() then
					self.voiceCapturedDuringVideoCapture = self.voiceCapturedDuringVideoCapture
						or item.isSignalActive
				end
			end

			self:_updateRecentUsersInteractionData()

			if self.shouldThrottleParticipantUpdate then
				local now = tick()

				if
					now - self.lastParticipantsStateUpdate >= self.participantsStateThrottleTime
					and #list3 > 0
				then
					self.lastParticipantsStateUpdate = now
					local participantsUpdate = self.participantsUpdate
					local v14 = if GetFFlagBatchVoiceParticipantsUpdates() then self.updatedParticipants else self.participants
					participantsUpdate:Fire(v14)

					self.updatedParticipants = {}
				elseif #list3 > 0 then
					local v14 = self.participantsStateThrottleTime - (now - self.lastParticipantsStateUpdate)
					self.lastStateUpdateCounter = (self.lastStateUpdateCounter + 1) % 100
					local lastStateUpdateCounter = self.lastStateUpdateCounter
					task.wait(v14)

					if lastStateUpdateCounter == self.lastStateUpdateCounter then
						local participantsUpdate = self.participantsUpdate
						local v15 = if GetFFlagBatchVoiceParticipantsUpdates() then self.updatedParticipants else self.participants
						participantsUpdate:Fire(v15)

						self.updatedParticipants = {}
					end
				end
			elseif #list3 > 0 then
				local participantsUpdate = self.participantsUpdate
				local v14 = if GetFFlagBatchVoiceParticipantsUpdates() then self.updatedParticipants else self.participants
				participantsUpdate:Fire(v14)

				self.updatedParticipants = {}
			end
		end)

		local v14 = GetFFlagMicConsumerRegistry() and GetFFlagCoreMicManagerRefactor()

		local function onStateChanged(p2, joined)
			self:emit("OnStateChanged", p2, joined)

			local v15 = joined == Enum.VoiceChatState.Failed
			local v16 = joined == Enum.VoiceChatState.Joining
			local v17 = joined == Enum.VoiceChatState.Leaving
			local v18 = joined == Enum.VoiceChatState.Ended
			local isPublishPaused = self.service:IsPublishPaused()

			if isPublishPaused == self.localMuted or v15 or v16 or v17 or v18 then
				if v16 or v17 or v18 then
					self.localMuted = nil
				end
			else
				self.localMuted = isPublishPaused
				self.muteChanged:Fire(isPublishPaused)
			end

			if
				getFFlagVoiceChatClientRewriteMasterLua()
				and joined == Enum.VoiceChatState.Joined
				and self.isInCall
				and isPublishPaused ~= self.callMutedState
			then
				v5:debug("In call, setting local muted to call muted state {}", self.callMutedState)
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

			if joined == Enum.VoiceChatState.Ended or v15 then
				self.participants = {}
				self.localMuted = nil

				if v14 then
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

				if v15 then
					v5:debug(
						"State Changed to Failed. Reason: {}",
						self.service:GetAndClearCallFailureMessage()
					)
				end

				if
					p2 == Enum.VoiceChatState.Joining
					or p2 == Enum.VoiceChatState.JoiningRetry
					or p2 == Enum.VoiceChatState.Joined
				then
					if joined == Enum.VoiceChatState.Ended then
						v5:debug("State Changed to Ended from {}", p2)
					end

					if not self:IsSeamlessVoice() or self:GetVoiceConnectCookieValue() then
						self:emit("OnRetryRequested")
					end
				end

				if v7 and engineFeature then
					self:ReportVoiceVolumeImpressionsIfNeeded()
				end
			end

			if
				getFFlagEnableVoiceSignal()
				and self.VoiceJoinProgress == VOICE_JOIN_PROGRESS.Joining
				and joined == Enum.VoiceChatState.Joined
			then
				self:ChangeVoiceJoinProgress(VOICE_JOIN_PROGRESS.Joined)
				self:emit("OnVoiceJoin")
			end

			if v7 and engineFeature and joined == Enum.VoiceChatState.Joined then
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
				local v19 = {
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

				v19.voiceChatVolume = result
				v19.usesNewAudioApi = useNewAudioApi
				v19.enablesVoiceVolumeControls = creatorVoiceVolumeControlsEnabled
				v19.isEligible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, useNewAudioApi)
				analytics:reportVoiceVolumeEligibility(v19)

				self._voiceVolumeEligibilityReported = true
			end
		end

		if self.service.VoiceChatState and self.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v5:debug("Joined voice chat {}", self.service.VoiceChatState)
			onStateChanged(nil, Enum.VoiceChatState.Joined)
		end

		self.stateConnection = self.service.StateChanged:Connect(onStateChanged)

		if GetFFlagCoreMicManagerRefactor() then
			self.micManager:SetupMicActivityListener(self.service)

			if GetFFlagMicConsumerRegistry() then
				local localPlayer = Players.LocalPlayer
				local v15 = if localPlayer then localPlayer:FindFirstChildOfClass("AudioDeviceInput") else nil
				self.micManager:RegisterConsumer({
					id = "voice_chat",
					consumerType = "VoiceChat",
					device = v15
				})
			end
		elseif v6 and VoiceChatService.UseNewAudioApi then
			if not self.localMeteringTask then
				self.localMeteringTask = task.spawn(function()
					while true do
						self:UpdateLocalMetering()
						task.wait()
					end
				end)
			end
		elseif MIN_VOICE_CHAT_API_VERSION_LOCAL_MIC_ACTIVITY <= self.service:GetVoiceChatApiVersion() then
			self.micConnection = self.service.PlayerMicActivitySignalChange:Connect(function(p2)
				if v8 and self.CaptureService:IsCapturingVideo() then
					self.voiceCapturedDuringVideoCapture = self.voiceCapturedDuringVideoCapture
						or p2.isActive
				end

				self.isTalking = p2.isActive

				if getFFlagLocalMutedNilFix() then
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
				v5:debug("User Moderated old")
				self.previousSessionId = self.service:GetSessionId()
				self:emit("OnPlayerModerated")

				if getFFlagVoiceChatClientRewriteMasterLua() then
					VoiceChatService:leaveVoice()
				else
					self.service:Leave()
				end
			end)
		end

		v5:trace("Setting up voice nudge handlers")
		self.voiceToxicityModalConnection = self:GetSignalREvent("VoiceToxicityModal"):Connect(function(p2)
			self.Analytics:reportReceivedNudge(p2, self:GetNudgeAnalyticsData())
			self:emit("OnVoiceToxicityModal")
		end)

		self.VoiceToxicityToastConnection = self:GetSignalREvent("VoiceToxicityToast"):Connect(function(p2)
			self.Analytics:reportReceivedNudge(p2, self:GetNudgeAnalyticsData())
			self:emit("OnVoiceToxicityToast")
		end)

		if GetFFlagEnableVoiceReverseNudge() then
			v5:trace("Setting up voice reverse nudge handlers")
			self.voiceReverseNudgeConnection = self:GetSignalREvent("VoiceReverseNudgeIconColorChange"):Connect(function(p2)
				self:emit("OnVoiceReverseNudgeIconColorChange", p2)
			end)
		end

		self.blockConnection = self.BlockStatusChanged:Connect(function(p2, p3)
			if p3 then
				if self.participants[tostring(p2)] then
					v5:debug("Blocking {}", Utils.shorten(p2))
					self.service:SubscribeBlock(p2)
				end
			else
				v5:debug("UnBlocking {}", Utils.shorten(p2))
				self.service:SubscribeUnblock(p2)
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

		if v8 then
			self.videoCaptureInProgressConnection = self.CaptureService.VideoCaptureInProgress:connect(function(p2)
				if p2 then
					self.voiceCapturedDuringVideoCapture = false
				else
					self.TelemetryService:LogEvent(v10, {
						customFields = {
							voiceCaptured = self.voiceCapturedDuringVideoCapture
						}
					})
				end
			end)
		end
	end
end

local v14 = nil
function v11.CheckAudioInputExists(p2)
	v5:trace("Checking for AudioDeviceInput")

	if not v14 then
		v14 = Promise.new(function(callback, p3)
			if #Cryo.Dictionary.keys(p2.audioDevices) > 0 then
				v5:trace("Found existing AudioDeviceInput")
				callback()
			else
				p2.audioDeviceInputAdded.Event:Connect(function()
					v5:trace("Found new AudioDeviceInput")
					callback()
				end)
			end
		end)
	end

	return v14
end

function v11:checkAndUpdateSequence(p3, p4)
	if not p4 then
		return 0
	end

	if not self.SequenceNumbers[p3] then
		self.SequenceNumbers[p3] = p4
		return 0
	end

	local v15 = p4 - self.SequenceNumbers[p3]

	if v15 > 0 then
		self.SequenceNumbers[p3] = p4
	end

	return v15 - 1
end

local function isIgnoredAudioInput(instance)
	return instance:IsDescendantOf(CoreGui)
end

function v11:_onAudioDeviceInputAdded(instance)
	if fFlagExpChatDictation and instance:IsDescendantOf(CoreGui) then
		return
	end

	v5:debug("Found new audio device instance for {}", instance.Player and instance.Player.Name)
	self.audioDevices[instance] = self:CreateAudioDeviceData(instance)
	self:emit("OnAudioDeviceInputAdded")
	self:StartAnalysis(instance)
end

function v11:onInstanceAdded(audioDeviceInput)
	if audioDeviceInput:IsA("AudioDeviceInput") then
		self:_onAudioDeviceInputAdded(audioDeviceInput)
	end
end

function v11:GetSendMuteEvent()
	if not self.SendMuteEvent then
		self.SendMuteEvent = RobloxReplicatedStorage:WaitForChild("SetUserActive", 10)
	end

	return self.SendMuteEvent
end

function v11:GetToggleVoiceChangerEvent()
	if not self.SendVoiceChangerEvent then
		self.SendVoiceChangerEvent = ReplicatedStorage:WaitForChild("ToggleUserVoiceChanger", 10)
	end

	return self.SendVoiceChangerEvent
end

function v11:GetInputToModifierWire()
	if not self.InputToModifierWire then
		self.InputToModifierWire = Players.LocalPlayer:FindFirstChild("InputToModifier")
	end

	return self.InputToModifierWire
end

function v11:GetPartyVoiceDeviceInput()
	if not self.PartyVoiceDeviceInput then
		self.PartyVoiceDeviceInput = Players.LocalPlayer:FindFirstChild("PartyVoiceDeviceInput")
	end

	return self.PartyVoiceDeviceInput
end

function v11:GetSetVoicePackEvent()
	if not self.SetVoicePackEvent then
		self.SetVoicePackEvent = ReplicatedStorage:WaitForChild("SetVoicePack", 10)
	end

	return self.SetVoicePackEvent
end

function v11:GetVoiceChangerWasToggledEvent()
	if not self.VoiceChangerWasToggledEvent then
		self.VoiceChangerWasToggledEvent = ReplicatedStorage:WaitForChild("VoiceChangerWasToggled", 3)
	end

	return self.VoiceChangerWasToggledEvent
end

local function WireUp(sourceInstance, p2)
	local wire = Instance.new("Wire")
	wire.SourceInstance = sourceInstance
	wire.TargetInstance = p2
	wire.Parent = p2
	return wire
end

local function GetAnalysisHost()
	return RobloxReplicatedStorage
end

function v11:GetAnalyzer(p3)
	local v15 = p3.Name .. "_Analyzer"
	local v16 = RobloxReplicatedStorage

	local v17 = v16:FindFirstChild(v15)

	if v17 then
		return v17
	end

	v17 = Instance.new("AudioAnalyzer")
	v17.SpectrumEnabled = false
	v17.Name = v15
	v17.Parent = v16

	return v17
end

local function toDecibels(p2)
	return math.log10(p2) * 20
end

function v11:IsSignalActive(p2): boolean
	if not v6 then
		return false
	end

	local playerByUserId = Players:GetPlayerByUserId(p2)

	if playerByUserId then
		return math.log10(self:GetAnalyzer(playerByUserId).PeakLevel) * 20 > -36
	end

	return false
end

function v11:StopAnalysis(object)
	if not v6 then
		return
	end

	for k, v15 in object:GetConnectedWires("Output") do
		local targetInstance = v15.TargetInstance

		if targetInstance and targetInstance:IsDescendantOf(RobloxReplicatedStorage) then
			v15:Destroy()
		end
	end
end

function v11:StartAnalysis(sourceInstance)
	if not v6 then
		return
	end

	self:StopAnalysis(sourceInstance)

	local player = sourceInstance.Player

	if not player then
		return
	end

	local analyzer = self:GetAnalyzer(player)
	local wire = Instance.new("Wire")
	wire.SourceInstance = sourceInstance
	wire.TargetInstance = analyzer
	wire.Parent = analyzer
end

function v11:GetVoiceConnectCookie()
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)

	if success and result then
		return result
	end

	return ""
end

function v11:GetVoiceConnectCookieValue(): boolean
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3)
	end)

	if success then
		return result == "true"
	end

	return true
end

function v11.SetVoiceConnectCookieValue(p2, p3)
	return (pcall(function()
		p2.AppStorageService:SetItem(Constants.VOICE_CONNECT_DISCONNECT_KEY_V3, (tostring(p3)))
		p2.AppStorageService:Flush()
	end))
end

function v11:GetVoiceRewarmCookie()
	local success, result = pcall(function()
		return self.AppStorageService:GetItem(Constants.VOICE_REWARM_KEY)
	end)

	if success and result then
		v5:debug("Got voice re-warm cookie: {}", result)
		return result
	end

	v5:debug("Voice re-warm cookie not set, returning empty string")
	return ""
end

function v11:SetVoiceRewarmCookie(p3)
	v5:debug("Setting voice re-warm cookie to {}", p3)
	pcall(function()
		self.AppStorageService:SetItem(Constants.VOICE_REWARM_KEY, (tostring(p3)))
		self.AppStorageService:Flush()
	end)
end

function v11:ShouldRewarmUser(): boolean
	local voiceRewarmCookie = self:GetVoiceRewarmCookie()

	if voiceRewarmCookie == "" then
		return true
	end

	return (tonumber(voiceRewarmCookie) or 0) < game:GetFastInt("VoiceRewarmReArmCount")
end

function v11:ConsumeVoiceRewarm()
	self:SetVoiceRewarmCookie((tostring(game:GetFastInt("VoiceRewarmReArmCount"))))
end

function v11.SetNewUserFTUXCookieValue(p2, p3)
	return (pcall(function()
		p2.AppStorageService:SetItem(Constants.SEAMLESS_VOICE_FTUX_KEY, (tostring(p3)))
		p2.AppStorageService:Flush()
	end))
end

function v11:SetAndSyncActive(p2, active)
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetAndSyncActive(p2, active)
	end

	p2.Active = active
	local sendMuteEvent = self:GetSendMuteEvent()

	if sendMuteEvent and p2.Player == Players.LocalPlayer then
		sendMuteEvent:FireServer(active)
	end
end

function v11:CreateAudioDeviceData(instance)
	local v15 = instance.Player == Players.LocalPlayer

	if engineFeature2 then
		if not instance.MutedByLocalUser then
			if self.muteAll and not v15 then
				instance.MutedByLocalUser = true
			end

			if instance.Player and self.mutedPlayers[instance.Player.UserId] then
				instance.MutedByLocalUser = true
			end
		end
	elseif instance.Active then
		if self.muteAll and not v15 then
			instance.Active = false
		end

		if instance.Player and self.mutedPlayers[instance.Player.UserId] then
			instance.Active = false
		end
	end

	if instance.Active and v15 and self.localMuted == nil then
		self:SetAndSyncActive(instance, false)
	end

	if v15 and self.localMuted ~= nil and self.localMuted ~= not instance.Active and not self.isInCall then
		v5:debug("Mismatch between LocalMuted and device.Active")
		local v16 = not self.localMuted
		instance.Active = v16
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(v16)
		end
	elseif self.isInCall and v15 then
		local v16 = not self.callMutedState
		v5:debug("Overwriting Active State to match Iris call. .Active = {}", v16)
		instance.Active = v16
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(v16)
		end
	end

	local audioDeviceData = {}

	audioDeviceData.onPlayerChanged = instance:GetPropertyChangedSignal("Player"):Connect(function()
		v15 = instance.Player == Players.LocalPlayer

		if v15 then
			if instance.Active and self.localMuted == nil then
				v5:debug("Player is still in connecting state, setting Active to false")
				self:SetAndSyncActive(instance, false)
			elseif self.localMuted ~= nil and self.localMuted ~= not instance.Active then
				v5:debug("Mismatch between LocalMuted and device.Active")
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

			if self.muteAll and not v15 then
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

function v11:onInstanceRemove(audioDeviceInput)
	if audioDeviceInput:IsA("AudioDeviceInput") then
		if fFlagExpChatDictation and audioDeviceInput:IsDescendantOf(CoreGui) then
			return
		end

		self:StopAnalysis(audioDeviceInput)
		v5:trace(
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

		if v6 and audioDeviceInput.Player then
			self:GetAnalyzer(audioDeviceInput.Player):Destroy()
		end
	end
end

function v11:hookupAudioDeviceInputListener()
	v5:debug("Hooking up audio device listeners")
	local localPlayer = Players.LocalPlayer

	if fFlagUseAudioDeviceInputAddedSignal then
		SoundService.AudioDeviceInputAdded:Connect(function(p2)
			self:_onAudioDeviceInputAdded(p2)
		end)
	else
		SoundService.AudioInstanceAdded:Connect(function(p2)
			self:onInstanceAdded(p2)
		end)
	end

	local audioDeviceInput = localPlayer:FindFirstChildOfClass("AudioDeviceInput")
	v5:debug("Found local user audio device {}", audioDeviceInput)

	if audioDeviceInput then
		self:onInstanceAdded(audioDeviceInput)
	end

	if VoiceChatService.EnableDefaultVoice then
		v5:debug("Creating default voice listener")

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

		for k, v15 in CollectionService:GetTagged("RbxDefaultVoiceEmitter") do
			Utils.destroyDefaultEmitter(v15)
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

	for i, descendant in game:GetDescendants() do
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

function v11:RejoinCurrentChannel()
	pcall(function()
		local groupId = self.service:GetGroupId()

		if groupId and groupId ~= "" then
			local isPublishPaused = self.service:IsPublishPaused()
			self.service:Leave()
			v5:debug("Rejoining current channel {}", groupId)
			self.participants = {}
			self.participantsUpdate:Fire(self.participants)

			if not self.service:JoinByGroupIdToken(groupId, isPublishPaused, true) then
				self:emit("OnInitialJoinFailed")
			end
		end
	end)
end

function v11:RejoinChannel(p2, p3)
	v5:debug("Rejoining previous channel {} with mute status {}", p2, p3)

	if p2 and p2 ~= "" then
		pcall(function()
			self.service:Leave()
			self.participants = {}
			self.participantsUpdate:Fire(self.participants)

			if not self.service:JoinByGroupIdToken(p2, p3, true) then
				self:emit("OnInitialJoinFailed")
			end
		end)
	end
end

function v11:RejoinVoice()
	if getFFlagVoiceChatClientRewriteMasterLua() then
		v5:debug("Rejoining voice")

		self.participants = {}
		self.participantsUpdate:Fire(self.participants)
		VoiceChatService:rejoinVoice()
	end
end
function v11:watchSignalR()
	self.signalRConnection = self.NotificationService.RobloxEventReceived:Connect(function(p2)
		local namespace = p2.namespace

		if not WATCHED_NAMESPACES[namespace] then
			return
		end

		local jsonDecode = Utils.jsonDecode(p2.detail)

		local v15 = self.SignalREventTable[jsonDecode.type]

		if v15 then
			v15:Fire(jsonDecode)
		end

		local sequenceNumber = jsonDecode.SequenceNumber
		v5:trace("SignalR message {}: {}", namespace, sequenceNumber)

		local v16 = self:checkAndUpdateSequence(namespace, sequenceNumber)

		if v16 > 0 then
			self.Analytics:reportReconnectDueToMissedSequence()
		elseif v16 < -1 then
			self.Analytics:reportOutOfOrderSequence()
		end
	end)

	self.signalRConnectionChanged = self.NotificationService.RobloxConnectionChanged:Connect(function(p2, p3, p4, p5)
		if p2 == "signalR" then
			if p3 ~= Enum.ConnectionState.Connected then
				v5:info("SignalR disconnected")
				return
			end

			for k, v15 in pairs(Utils.jsonDecode(p5)) do
				if not WATCHED_NAMESPACES[k] then
					continue
				end

				v5:trace("SignalR message {}: {}", k, v15)

				local v16 = self:checkAndUpdateSequence(k, v15)

				if v16 > 0 then
					self.Analytics:reportReconnectDueToMissedSequence()
				elseif v16 < -1 then
					self.Analytics:reportOutOfOrderSequence()
				end
			end
		end
	end)
end

function v11:StopSignalRConnection()
	if self.signalRConnectionChanged then
		self.signalRConnectionChanged:Disconnect()
		self.signalRConnectionChanged = nil
	end

	if self.signalRConnection then
		self.signalRConnection:Disconnect()
		self.signalRConnection = nil
	end
end

function v11.getService(p2)
	return p2.service
end

function v11:ToggleMic(p2)
	self:ensureInitialized("toggle mic")

	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetMicActive(self.micManager.localMuted, p2)
	end

	if self.localMuted == nil then
		v5:trace("ToggleMic context: {} - Voice not connected yet", p2)
		return
	end

	v5:trace("ToggleMic context: {}", p2)

	if getFFlagJoinWithoutMicPermissions() then
		if self.permissionState == PERMISSION_STATE.PENDING_MIC then
			v5:debug("In pending mic mode, requesting permission")
			self:emit("GetPermissions", function(p3)
				local v15 = self
				local v16 = if p3.hasMicPermissions then PERMISSION_STATE.LISTEN_AND_TALK else PERMISSION_STATE.LISTEN_ONLY
				v15.permissionState = v16

				v5:debug("Got permissions, setting state to {}", self.permissionState)
				self:ToggleMic(p2)
			end, { permissionsProtocol.Permissions.MICROPHONE_ACCESS }, false)
			return
		elseif self.permissionState == PERMISSION_STATE.LISTEN_ONLY then
			v5:debug("User tried to unmute despite being in listen only mode")
			self:emit("OnPermissionRequested")
			return
		end
	end

	if self.isPlayerWatchingAd then
		v5:trace("User is watching an ad, skipping toggling mic")
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.localMuted = not self.localMuted
		local v15 = not self.localMuted
		v5:trace("Setting self mute to {} context: {}", v15, p2)
		local sendMuteEvent = self:GetSendMuteEvent()

		if sendMuteEvent then
			sendMuteEvent:FireServer(v15)

			for k in self.audioDevices do
				if k.Player and k.Player == Players.LocalPlayer then
					k.Active = v15
				end
			end

			self.muteChanged:Fire(self.localMuted)
		else
			v5:error("Could not find SendMuteEvent")
		end
	else
		local v15 = not self.service:IsPublishPaused()
		v5:trace("Setting self mute to {} context: {}", v15, p2)

		self.service:PublishPause(v15)
		self.localMuted = v15
		self.muteChanged:Fire(v15)
	end

	if not self.localMuted then
		self.talkingChanged:Fire(self.isTalking)
		self:emit("OnShowDataConsentToast")
	end

	if p2 then
		self.Analytics:reportVoiceMuteSelf(self:JoinWithVoiceMuteData({
			context = p2,
			muted = self.localMuted
		}))
	end
end

function v11:ToggleVoiceChanger(p2)
	self:ensureInitialized("toggle voice changer")

	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.isVoiceChangerActive = not self.isVoiceChangerActive
		v5:trace("setting voice changer active to {}", self.isVoiceChangerActive)
	else
		self.isVoiceChangerActive = false
		v5:trace("forcibly disabling voice changer since using old audio api", self.isVoiceChangerActive)
	end

	local toggleVoiceChangerEvent = self:GetToggleVoiceChangerEvent()

	if not toggleVoiceChangerEvent then
		v5:error("Could not find ToggleVoiceChangerEvent")
		return
	end

	toggleVoiceChangerEvent:FireServer(self.isVoiceChangerActive)
	self.voiceChangerChanged:Fire(self.isVoiceChangerActive)
end

function v11:ToggleVoiceChangerHearMyself(p2)
	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.isVoiceChangerHearMyselfActive = not self.isVoiceChangerHearMyselfActive
		local inputToModifierWire = self:GetInputToModifierWire()
		local partyVoiceDeviceInput = self:GetPartyVoiceDeviceInput()

		if inputToModifierWire and partyVoiceDeviceInput then
			v5:trace("setting voice changer hear myself active to {}", self.isVoiceChangerHearMyselfActive)

			if self.isVoiceChangerHearMyselfActive then
				inputToModifierWire.SourceInstance = partyVoiceDeviceInput
			else
				inputToModifierWire.SourceInstance = nil
			end

			self.voiceChangerHearMyselfChanged:Fire(self.isVoiceChangerHearMyselfActive)
		else
			v5:error("Could not find InputToModifierWire or PartyVoiceDeviceInput")
		end
	end
end

function v11:SetVoicePack(currentVoicePack)
	self:ensureInitialized("set voice pack")

	if self.localMuted == nil then
		return
	end

	if VoiceChatService.UseNewAudioApi then
		self.currentVoicePack = currentVoicePack
		v5:trace("setting current voice pack to {}", self.currentVoicePack)
		local setVoicePackEvent = self:GetSetVoicePackEvent()

		if setVoicePackEvent then
			setVoicePackEvent:FireServer("VoicePack_" .. self.currentVoicePack)
		else
			v5:error("Could not find SetVoicePackEvent")
		end
	end
end

function v11:JoinWithVoiceMuteData(p2)
	local localPlayer = Players.LocalPlayer
	return Cryo.Dictionary.join(
		{
			userId = localPlayer.UserId,
			clientSessionId = self:GetSessionId(),
			channelId = self:GetChannelId()
		},
		p2
	)
end

function v11:_reportJoinFailed(p2, p3)
	self.Analytics:reportVoiceChatJoinResult(false, p2, p3)
	self:emit("OnReportJoinFailed", p2)
end

function v11:_syncLocalAudioDeviceActive()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SyncLocalAudioDeviceActive()
	end

	if not VoiceChatService.UseNewAudioApi then
		return
	end

	local v15 = not (self.localMuted == nil) and not self.localMuted

	for k in self.audioDevices do
		if k.Player and k.Player == Players.LocalPlayer then
			k.Active = v15
		end
	end
end

function v11:_setupEarlyAudioDeviceGuard()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:SetupEarlyAudioDeviceGuard()
	end

	local function shouldDeactivate(instance)
		local v15 = VoiceChatService.UseNewAudioApi
			and not (fFlagExpChatDictation and instance:IsDescendantOf(CoreGui))

		if v15 then
			v15 = instance.Player == Players.LocalPlayer and (instance.Active and self.localMuted == nil)
		end

		return v15
	end

	local function guardDevice(instance)
		local v15 = VoiceChatService.UseNewAudioApi
			and not (fFlagExpChatDictation and instance:IsDescendantOf(CoreGui))

		if v15 then
			v15 = instance.Player == Players.LocalPlayer and (instance.Active and self.localMuted == nil)
		end

		if v15 then
			instance.Active = false
		end

		instance:GetPropertyChangedSignal("Player"):Connect(function()
			local v16 = instance
			local v17 = VoiceChatService.UseNewAudioApi
				and not (fFlagExpChatDictation and v16:IsDescendantOf(CoreGui))

			if v17 then
				v17 = v16.Player == Players.LocalPlayer and (v16.Active and self.localMuted == nil)
			end

			if v17 then
				instance.Active = false
			end
		end)

		instance:GetPropertyChangedSignal("Active"):Connect(function()
			local v16 = instance
			local v17 = VoiceChatService.UseNewAudioApi
				and not (fFlagExpChatDictation and v16:IsDescendantOf(CoreGui))

			if v17 then
				v17 = v16.Player == Players.LocalPlayer and (v16.Active and self.localMuted == nil)
			end

			if v17 then
				instance.Active = false
			end
		end)
	end

	if fFlagUseAudioDeviceInputAddedSignal then
		SoundService.AudioDeviceInputAdded:Connect(function(p3)
			guardDevice(p3)
		end)
	else
		SoundService.AudioInstanceAdded:Connect(function(audioDeviceInput)
			if audioDeviceInput:IsA("AudioDeviceInput") then
				guardDevice(audioDeviceInput)
			end
		end)
	end

	for i, audioDeviceInput in game:GetDescendants() do
		if audioDeviceInput:IsA("AudioDeviceInput") then
			guardDevice(audioDeviceInput)
		end
	end
end

function v11:_asyncInit()
	self:CheckCallState()
	self:_setupEarlyAudioDeviceGuard()

	return self:canUseServiceAsync():andThen(function(p2)
		local v15

		if game:GetEngineFeature("UseNewVoiceChatService") then
			v5:debug("Using VoiceChatInternal")
			v15 = "VoiceChatInternal"
		else
			v15 = "VoiceChatService"
		end

		local success, result = pcall(function()
			local service = game:GetService(v15)

			if
				service
				and (service:GetVoiceChatApiVersion() < MIN_VOICE_CHAT_API_VERSION_IS_CONTEXT_ENABLED or service:IsContextVoiceEnabled())
			then
				self.voiceEnabled = true
				self.service = service

				self:SetupParticipantListeners()
			end
		end)

		if getFFlagVoiceChatClientRewriteMasterLua() then
			VoiceChatService:joinVoice()
			v5:debug("Starting Voice Chat Client Join Operation")
		else
			local VoiceChatService2 = game:GetService("VoiceChatService")

			if VoiceChatService2 then
				VoiceChatService2:joinVoice()
				v5:debug("Starting Voice Chat Client Join Operation")
			end
		end

		if success then
			if self.service then
				self:emit("OnVoiceChatServiceInitialized")
				self:watchSignalR()
				return Promise.resolve()
			end

			v5:debug("VoiceChatService is not set after init")
			self:_reportJoinFailed("contextNotEnabled")

			if self.options.passInitErrorInPromiseReject then
				return Promise.reject({ code = "INIT_ERROR_CONTEXT_NOT_ENABLED" })
			end

			return Promise.reject()
		end

		v5:warning("EnableVoiceChat flag is enabled but GetService panicked {}", result)
		self:_reportJoinFailed("getServiceFailed", module3.ERROR)

		if self.options.passInitErrorInPromiseReject then
			return Promise.reject({ code = "INIT_ERROR_GET_SERVICE_FAILED" })
		end

		return Promise.reject()
	end)
end

function v11:UpdateLocalMetering()
	if GetFFlagCoreMicManagerRefactor() then
		return self.micManager:UpdateLocalMetering()
	end

	self.isTalking = self:IsSignalActive(Players.LocalPlayer.UserId)

	if self.localMuted == false then
		self.talkingChanged:Fire(self.isTalking)
	end
end

function v11:asyncInit()
	if self.service then
		v5:trace("Manager already initialized")
		return Promise.resolve()
	end

	if self.initPromise then
		return self.initPromise
	end

	self.initPromise = self:_asyncInit()

	if self.AdService then
		local function setupRewardedAdMuting(object2)
			local v15 = false
			object2.AdService.RewardedVideoAdStarted:Connect(function()
				if object2.localMuted == nil then
					return
				end

				v15 = object2.localMuted

				if not object2.localMuted then
					object2:ToggleMic(Constants.REWARDED_VIDEO_AD_STARTED)
				end

				object2.isPlayerWatchingAd = true

				if GetFFlagCoreMicManagerRefactor() then
					object2.micManager:SetAdMuteBlocked(true)
				end
			end)

			object2.AdService.RewardedVideoAdEnded:Connect(function()
				if object2.localMuted == nil then
					return
				end

				object2.isPlayerWatchingAd = false

				if GetFFlagCoreMicManagerRefactor() then
					object2.micManager:SetAdMuteBlocked(false)
				end

				if v15 ~= object2.localMuted then
					object2:ToggleMic(Constants.REWARDED_VIDEO_AD_ENDED)
				end
			end)
		end

		setupRewardedAdMuting(self)
	end

	if fFlagEnablePartyVoiceChangersInLua and not self.voiceChangerWasToggledEvent then
		task.spawn(function()
			local voiceChangerWasToggledEvent = self:GetVoiceChangerWasToggledEvent()

			if voiceChangerWasToggledEvent then
				voiceChangerWasToggledEvent.OnClientEvent:Connect(function(p2, isVoiceChangerActive)
					local v15 = if defineFastFlag then self.participants[tostring(p2)] else self.participants[p2]

					if v15 then
						v15.isVoiceChangerActive = isVoiceChangerActive
						self.voiceChangerActivePlayers[p2] = isVoiceChangerActive
						self.participantsUpdate:Fire(self.participants)
					end
				end)
			end
		end)
	end

	return self.initPromise
end

function v11:IsInitialized(): boolean
	if self.service then
		return true
	end

	return false
end

function v11.ensureInitialized(p2, p3)
	if not p2.service then
		error("[corescripts VCS Manager] " .. "Attempting to " .. p3 .. " before calling init")
	end
end

function v11:GetSessionId()
	self:ensureInitialized("get session id")
	return self.service:GetSessionId()
end

function v11:GetChannelId()
	self:ensureInitialized("get channel id")
	return self.service:GetChannelId()
end

function v11:Disconnect()
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

	if v8 and self.videoCaptureInProgressConnection then
		self.videoCaptureInProgressConnection:Disconnect()
		self.videoCaptureInProgressConnection = nil
	end
end

function v11.RequestHidePublicVoiceUI(p2)
	task.defer(function()
		p2.setVoiceUIVisibility:Fire(false)
	end)
end

function v11.RequestShowPublicVoiceUI(p2)
	task.defer(function()
		p2.setVoiceUIVisibility:Fire(true)
	end)
end

v11.default = v11.new(
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

local localPlayer = v7 and engineFeature and Players.LocalPlayer

if localPlayer then
	localPlayer.AncestryChanged:Connect(function(p2, parent)
		if parent == nil then
			v11.default:ReportVoiceVolumeImpressionsIfNeeded()
		end
	end)
end

return v11
