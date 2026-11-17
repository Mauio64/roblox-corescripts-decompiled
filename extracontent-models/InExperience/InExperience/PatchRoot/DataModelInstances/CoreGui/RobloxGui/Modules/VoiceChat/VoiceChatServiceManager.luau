local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local Workspace = game:GetService("Workspace")
local LocalizationService = game:GetService("LocalizationService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local NotificationService = game:GetService("NotificationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local SocialUpsell = require(CorePackages.Workspace.Packages.SocialUpsell)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local default = LoggingProtocol.default
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local ExperimentLayers = require(CorePackages.Workspace.Packages.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local default2 = VoiceChat.GlobalVoiceManager.default
local createVoiceRestrictionController = require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController)

local createVoiceRestrictionController_DEPRECATED = require(CorePackages.Workspace.Packages.VoiceChat.createVoiceRestrictionController_DEPRECATED)
local showLegacyVoiceRestriction = require(script.Parent.Helpers.showLegacyVoiceRestriction)
local showUFRVoiceRestriction = require(script.Parent.Helpers.showUFRVoiceRestriction)
local getActiveInterventionTimeoutEnd = require(script.Parent.Helpers.getActiveInterventionTimeoutEnd)
local getServerNow = require(script.Parent.Helpers.getServerNow)

local InterventionShared = require(CorePackages.Workspace.Packages.InterventionShared)
local voiceInterventionReceivedSignal = InterventionShared.Signals.voiceInterventionReceivedSignal
local InterventionShared2 = require(CorePackages.Workspace.Packages.InterventionShared)
local Constants = InterventionShared2.Utils.Constants

local FFlagVoiceChatBanDurationUseServerTime = require(script.Parent.Flags.FFlagVoiceChatBanDurationUseServerTime)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagProactiveVoiceRestrictionsUFR = SharedFlags.FFlagProactiveVoiceRestrictionsUFR

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagReactiveVoiceRestrictionsUFR = SharedFlags2.FFlagReactiveVoiceRestrictionsUFR

local FFlagProactiveVoiceRestrictionsUFRIXPExposure = require(script.Parent.Flags.FFlagProactiveVoiceRestrictionsUFRIXPExposure)

local GetFFlagDisableConsentModalForExistingUsers = require(script.Parent.Flags.GetFFlagDisableConsentModalForExistingUsers)

require(script.Parent.Flags.GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses)

local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableVoicePromptReasonText = require(RobloxGui.Modules.Flags.GetFFlagEnableVoicePromptReasonText)

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags3.GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = VoiceChatCore.Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat
local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagNonVoiceFTUX = SharedFlags4.GetFFlagNonVoiceFTUX

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagJoinWithoutMicPermissions = SharedFlags5.GetFFlagJoinWithoutMicPermissions

local GetFIntVoiceReverseNudgeUXDisplayTimeSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceReverseNudgeUXDisplayTimeSeconds)

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local GetFFlagEnableSeamlessVoiceDataConsentToast = require(RobloxGui.Modules.Flags.GetFFlagEnableSeamlessVoiceDataConsentToast)

local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagSeamlessVoiceConsentToastPolicy = SharedFlags6.GetFFlagSeamlessVoiceConsentToastPolicy
local GetFFlagEnableFtuxExitOnMuteToggle = VoiceChatCore.Flags.GetFFlagEnableFtuxExitOnMuteToggle
local GetFFlagMicConsumerRegistry = VoiceChatCore.Flags.GetFFlagMicConsumerRegistry

local SharedFlags7 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableVoiceChatMuteForVideoCaptures = SharedFlags7.GetFFlagEnableVoiceChatMuteForVideoCaptures

local SharedFlags8 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableCrossExperienceVoiceCaptureMute = SharedFlags8.GetFFlagEnableCrossExperienceVoiceCaptureMute

local SharedFlags9 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagExpChatUseVoiceParticipantsStore = SharedFlags9.GetFFlagExpChatUseVoiceParticipantsStore

local SharedFlags10 = require(CorePackages.Workspace.Packages.SharedFlags)
local fFlagDebugShowAudioDeviceInputDebugger = SharedFlags10.GetFFlagDebugShowAudioDeviceInputDebugger()
local GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 = require(script.Parent.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2)
local VoiceNudgeUseNewDACopy = require(script.Parent.Helpers.VoiceNudgeUseNewDACopy)

local defineFastFlag = game:DefineFastFlag("DebugSkipVoicePermissionCheck", false)
local defineFastFlag2 = game:DefineFastFlag("DebugSimulateConnectDisconnect", false)
local defineFastFlag3 = game:DefineFastFlag("DebugSkipSeamlessVoiceAPICheck", false)
local defineFastFlag4 = game:DefineFastFlag("FixSTUXShowingIncorrectly", false)
local defineFastInt = game:DefineFastInt("DebugConnectDisconnectInterval", 15)
local defineFastFlag5 = game:DefineFastFlag("DisablePermissionPromptDeeplink", false)
local defineFastFlag6 = game:DefineFastFlag("VoiceEndedCheckDisregardIdleState", false)
local defineFastFlag7 = game:DefineFastFlag("DisableLeaveToastInStudio", false)
local defineFastFlag8 = game:DefineFastFlag("EnableVerifiedCheckViaOverlay", false)
local GetFIntThrottleParticipantsUpdateMs = VoiceChatCore.Flags.GetFIntThrottleParticipantsUpdateMs

local defineFastString = game:DefineFastString("VoiceUIImprovementsIXPLayerName", "Voice.Exposure")

local defineFastString2 = game:DefineFastString("ThrottleParticipantsUpdateIXPLayerValue", "ThrottleParticipantsUpdate")

local defineFastFlag9 = game:DefineFastFlag("VoiceVolumeControlsGlobalVoiceVolumeSliderIxpExposure", false)

local defineFastString3 = game:DefineFastString(
	"VoiceVolumeControlsGlobalVoiceVolumeSliderIxpLayer",
	"Voice.VolumeControls"
)
local defineFastInt2 = game:DefineFastInt("SeamlessVoiceSTUXDisplayCount", 3)

local SharedFlags11 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = SharedFlags11.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints

local SharedFlags12 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagShowDevicePermissionsModal = SharedFlags12.GetFFlagShowDevicePermissionsModal

local SharedFlags13 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableRetryForLinkingProtocolFetch = SharedFlags13.FFlagEnableRetryForLinkingProtocolFetch
local defineFastFlag10 = game:DefineFastFlag("ShowJoinVoiceWhenDisconnectedV3", false)
local defineFastFlag11 = game:DefineFastFlag("EnableVoiceRewarmReArmV2", false)
local FFlagVoiceRewarmGrafanaMetrics = require(script.Parent.Flags.FFlagVoiceRewarmGrafanaMetrics)
local defineFastFlag12 = game:DefineFastFlag("VoiceConnectDisconnectGrafanaMetrics", false)

local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)

local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(script.Parent.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)

local SharedFlags14 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagVoiceRewarmTelemetry = SharedFlags14.FFlagVoiceRewarmTelemetry
local defineFastFlag13 = game:DefineFastFlag("GuardVoiceInExpUpsellVariant", false)
local defineFastFlag14 = game:DefineFastFlag("AlwaysSetJoinVoiceButtonContext", false)

local _ = {
	FAE_UPSELL = "FaeUpsell",
	VOICE_FTUX = "VoiceFtux",
	REWARM = "Rewarm",
	AGE_CHECK_TOAST = "AgeCheckToast",
	PHONE_UPSELL = "PhoneUpsell",
	IN_EXP_UPSELL = "InExpUpsell"
}

local _ = {
	REJOIN_PREVIOUS_CHANNEL = "RejoinPreviousChannel",
	EXIT_FTUX = "ExitFtux",
	MIC_PERMISSION_PROMPT = "MicPermissionPrompt",
	FIRST_JOIN_SESSION = "FirstJoinSession",
	CONSENT_MODAL = "ConsentModal",
	AGE_CHECK_TOAST = "AgeCheckToast",
	PHONE_UPSELL = "PhoneUpsell",
	FAE_UPSELL = "FaeUpsell"
}

local SharedFlags15 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagIntegratePhoneUpsellJoinVoice = SharedFlags15.GetFFlagIntegratePhoneUpsellJoinVoice

local SharedFlags16 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagInExperiencePhoneUpsellNewCopy = SharedFlags16.GetFFlagInExperiencePhoneUpsellNewCopy

local SharedFlags17 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagCheckUniversePlaceBeforeSuspending = SharedFlags17.GetFFlagCheckUniversePlaceBeforeSuspending

local SharedFlags18 = require(CorePackages.Workspace.Packages.SharedFlags)
local FIntLinkingProtocolFetchRetries = SharedFlags18.FIntLinkingProtocolFetchRetries

local SharedFlags19 = require(CorePackages.Workspace.Packages.SharedFlags)
local FIntLinkingProtocolFetchTimeoutMS = SharedFlags19.FIntLinkingProtocolFetchTimeoutMS
local VoiceChat2 = require(CorePackages.Workspace.Packages.VoiceChat)
local constants = VoiceChat2.Constants
local PostRecordUserSeenGeneralModal = VoiceChat2.AgeVerificationOverlay.PostRecordUserSeenGeneralModal
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatPrompt = require(RobloxGui.Modules.VoiceChatPrompt.Components.VoiceChatPrompt)
local AudioDeviceInputDebugger = require(RobloxGui.Modules.VoiceChat.Components.AudioDeviceInputDebugger)
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)
local GetUserSettings = VoiceChat2.GetUserSettings
local GetInformedOfBan = VoiceChat2.GetInformedOfBan
local PostInformedOfBan = VoiceChat2.PostInformedOfBan
local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local BAN_REASON = Constants2.BAN_REASON
local SeamlessVoiceStatus = require(RobloxGui.Modules.Settings.Enum.SeamlessVoiceStatus)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

local SharedFlags20 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagVoiceChatClientRewriteMasterLua = SharedFlags20.GetFFlagVoiceChatClientRewriteMasterLua

local Analytics = VoiceChatCore.Analytics

local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)

local MicrophoneDevicePermissionsLogging = require(RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)
local AvatarChatService

if GetFFlagAvatarChatServiceEnabled() then
	AvatarChatService = game:GetService("AvatarChatService")
end

local CaptureService

if GetFFlagEnableVoiceChatMuteForVideoCaptures() then
	CaptureService = game:GetService("CaptureService")
end

local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
local default3 = LinkingProtocol.LinkingProtocol.default
local LinkingProtocol2 = require(CorePackages.Workspace.Packages.LinkingProtocol)
local SettingsRoute = LinkingProtocol2.Enums.SettingsRoute
local phoneUpsellController

if GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then
	local PhoneUpsell = require(CorePackages.Workspace.Packages.PhoneUpsell)
	phoneUpsellController = PhoneUpsell.PhoneUpsellController
else
	phoneUpsellController = nil
end

local postPhoneUpsellDisplayed

if GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then
	local PhoneUpsell = require(CorePackages.Workspace.Packages.PhoneUpsell)
	postPhoneUpsellDisplayed = PhoneUpsell.Http.Requests.PostPhoneUpsellDisplayed
else
	postPhoneUpsellDisplayed = nil
end

local CoreVoiceManager = VoiceChatCore.CoreVoiceManager
local constants2 = VoiceChatCore.Constants

local getOverlayStore = SocialUpsell.Overlay.getOverlayStore
local OverlayTypes = SocialUpsell.Overlay.OverlayTypes
local SocialUpsellType = SocialUpsell.Enum.SocialUpsellType
local enum = SocialUpsell.Analytics.Enum
local SocialExperiments = require(CorePackages.Workspace.Packages.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE

local engineFeature2 = game:GetEngineFeature("EnableMutedByLocalUser")

local SharedFlags21 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags21.FFlagEnablePartyVoiceChangersInLua

local VoiceVolumeControlsEligibility = VoiceChatCore.VoiceVolumeControlsEligibility

local VOICE_STATE = constants.VOICE_STATE
local VOICE_CHAT_DEVICE_TYPE = constants.VOICE_CHAT_DEVICE_TYPE
local VOICE_CHAT_AVAILABILITY = constants.VOICE_CHAT_AVAILABILITY
local MIN_VOICE_CHAT_API_VERSION = constants.MIN_VOICE_CHAT_API_VERSION
local WATCHED_MESSAGE_TYPES = constants.WATCHED_MESSAGE_TYPES
local PERMISSION_STATE = constants.PERMISSION_STATE

local VOICE_JOIN_PROGRESS = constants2.VOICE_JOIN_PROGRESS

local VoiceChatServiceManager = {
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
	version = nil,
	participants = nil,
	recentUsersInteractionData = nil,
	permissionPromise = nil,
	canUseServicePromise = nil,
	localMuted = nil,
	isTalking = false,
	previousGroupId = nil,
	previousMutedState = nil,
	pendingDisconnectReason = nil,
	userEligible = false,
	HttpRbxApiService = HttpRbxApiService,
	NotificationService = NotificationService,
	runService = RunService,
	PermissionsService = permissionsProtocol.default,
	communicationPermissionsResult = nil,
	VoiceJoinProgress = VOICE_JOIN_PROGRESS.Idle,
	VoiceJoinProgressChanged = Instance.new("BindableEvent"),
	participantJoined = Instance.new("BindableEvent"),
	participantLeft = Instance.new("BindableEvent"),
	participantsUpdate = Instance.new("BindableEvent"),
	muteChanged = Instance.new("BindableEvent"),
	muteAllChanged = Instance.new("BindableEvent"),
	attemptVoiceRejoin = Instance.new("BindableEvent"),
	showVoiceUI = Instance.new("BindableEvent"),
	hideVoiceUI = Instance.new("BindableEvent"),
	voiceUIVisible = false,
	mutedNonFriends = Instance.new("BindableEvent"),
	userAgencySelected = Instance.new("BindableEvent"),
	sendMuteEvent = nil,
	muteAll = false,
	mutedPlayers = {},
	talkingChanged = Instance.new("BindableEvent"),
	SignalREventTable = {},
	audioDevices = {},
	service = nil,
	previousSessionId = nil,
	voiceEnabled = false,
	VOICE_STATE = VOICE_STATE
}
local permissionState

if GetFFlagJoinWithoutMicPermissions() then
	permissionState = PERMISSION_STATE.IDLE
end

VoiceChatServiceManager.permissionState = permissionState
VoiceChatServiceManager.isBanned = false
VoiceChatServiceManager.bannedUntil = nil
VoiceChatServiceManager.errorText = nil
VoiceChatServiceManager.BlockStatusChanged = nil
VoiceChatServiceManager.isInCall = false
VoiceChatServiceManager.callMutedState = false
VoiceChatServiceManager.banReason = nil
VoiceChatServiceManager._mutedAnyone = false
VoiceChatServiceManager.VOICE_CHAT_DEVICE_TYPE = VOICE_CHAT_DEVICE_TYPE
VoiceChatServiceManager.getPermissionsFunction = getCamMicPermissions
VoiceChatServiceManager.AvatarChatService = AvatarChatService
VoiceChatServiceManager.inExpUpsellEntrypoint = nil
VoiceChatServiceManager.seamlessVoiceStatus = nil
VoiceChatServiceManager.isShowingFTUX = false
VoiceChatServiceManager.hideFTUXSignal = Instance.new("BindableEvent")
VoiceChatServiceManager.settingsAppAvailable = nil
VoiceChatServiceManager.hasLeftFTUX = false
VoiceChatServiceManager.deniedMicPermissions = nil
VoiceChatServiceManager.isInitialJoin = false
VoiceChatServiceManager.joinVoiceButtonContext = nil
VoiceChatServiceManager.hasReportedRewarmShown = false
VoiceChatServiceManager.pendingConnectionSource = nil
VoiceChatServiceManager.joinVoiceButtonConsequence = nil
VoiceChatServiceManager.CaptureService = CaptureService

local set = LuauPolyfill.Set.new({
	"available",
	"participants",
	"recentUsersInteractionData",
	"permissionPromise",
	"canUseServicePromise",
	"localMuted",
	"isTalking",
	"previousGroupId",
	"previousMutedState",
	"userEligible",
	"sendMuteEvent",
	"mutedPlayers",
	"SignalREventTable",
	"audioDevices",
	"service",
	"previousSessionId",
	"voiceEnabled",
	"permissionState",
	"BlockStatusChanged",
	"isInCall",
	"callMutedState",
	"attemptVoiceRejoin",
	"VoiceJoinProgressChanged",
	"participantJoined",
	"participantLeft",
	"participantsUpdate",
	"muteChanged",
	"audioDeviceInputAdded",
	"talkingChanged",
	"canUseServiceResult"
})

set:add("_mutedAnyone")
set:add("muteAllChanged")

local v2 = {}
local v3 = {
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT1] = PromptType.VoiceConsentModalV1,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT2] = PromptType.VoiceConsentModalV2,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3] = PromptType.VoiceConsentModalV3
}

function getIconSrc(p, p2)
	return "rbxasset://textures/ui/VoiceChat/" .. (p2 and p2 .. "/" or "") .. p .. ".png"
end

function getIcon(p, p2, p3)
	if p == VOICE_STATE.MUTED then
		return getIconSrc("Muted", p3)
	end

	if p == VOICE_STATE.CONNECTING then
		return getIconSrc("Connecting", p3)
	end

	if p == VOICE_STATE.INACTIVE then
		return getIconSrc("Blank", p3)
	end

	if p ~= VOICE_STATE.TALKING then
		return getIconSrc("Error", p3)
	end

	local v4 = math.floor(0.5 + 5 * (p2 or math.random())) * 20
	return p2 and getIconSrc("Unmuted" .. tostring(v4), p3) or getIconSrc("Blank", p3)
end

VoiceChatServiceManager.__index = VoiceChatServiceManager

function VoiceChatServiceManager.__index(p, p2)
	if set:has(p2) then
		return p.coreVoiceManager[p2]
	end

	return (rawget(VoiceChatServiceManager, p2))
end

function VoiceChatServiceManager.__newindex(p, p2, p3)
	if set:has(p2) then
		p.coreVoiceManager[p2] = p3
	else
		rawset(VoiceChatServiceManager, p2, p3)
	end
end

local function bind(p, p2) -- 8 equivalent calls inferred from this helper
	return function(...)
		return p[p2](p, ...)
	end
end

local function getEnumName(items, p: number?) -- 5 equivalent calls inferred from this helper
	for k, item in items do
		if item == p then
			return k
		end
	end

	return nil
end

function VoiceChatServiceManager.new(coreVoiceManager, service, httpRbxApiService, permissionsService, blockStatusChanged, p, notificationService, p2, avatarChatService, captureService)
	local object = setmetatable({
		service = service,
		HttpRbxApiService = httpRbxApiService,
		NotificationService = notificationService,
		PermissionsService = permissionsService,
		BlockStatusChanged = blockStatusChanged,
		Analytics = Analytics.new(p),
		getPermissionsFunction = p2 or getCamMicPermissions,
		AvatarChatService = avatarChatService,
		SequenceNumbers = {},
		SignalREventTable = {},
		coreVoiceManager = coreVoiceManager,
		_mutedAnyone = false,
		CaptureService = captureService,
		voiceConnectEventReportedForActiveSession = false
	}, VoiceChatServiceManager)

	if FFlagProactiveVoiceRestrictionsUFR then
		local v4

		if FFlagReactiveVoiceRestrictionsUFR then
			v4 = createVoiceRestrictionController
		else
			v4 = createVoiceRestrictionController_DEPRECATED
		end

		local v5 = {
			getSettings = function()
				return GetUserSettings(bind(object, "GetRequest")) or nil -- inferred equivalent call
			end,
			getInformedOfBan = function()
				local informedOfBan = GetInformedOfBan(bind(object, "GetRequest")) -- inferred equivalent call

				if informedOfBan then
					return informedOfBan.informedOfBan
				end

				return nil
			end,
			showLegacyRestriction = function(settings, trigger, isCurrent)
				object.bannedUntil = settings.bannedUntil
				object.banReason = settings.banReason
				showLegacyVoiceRestriction({
					manager = object,
					settings = settings,
					trigger = trigger,
					isCurrent = isCurrent
				})
			end,
			onError = function(p3)
				object:_reportJoinFailed(p3, Analytics.ERROR)
			end,
			showUFRRestriction = function(settings, _, onAcknowledgementSuccess)
				showUFRVoiceRestriction({
					manager = object,
					settings = settings,
					onAcknowledgementSuccess = onAcknowledgementSuccess
				})
			end,
			getNow = 0
		}
		local getNow

		if FFlagReactiveVoiceRestrictionsUFR then
			getNow = getServerNow
		end

		v5.getNow = getNow
		rawset(object, "voiceRestrictionController", v4(v5))
	end

	if FFlagProactiveVoiceRestrictionsUFR and FFlagReactiveVoiceRestrictionsUFR then
		rawset(object, "voiceInterventionConnection", voiceInterventionReceivedSignal:connect(function(p3)
			object:_onUFRInterventionReceived(p3)
		end))
	end

	for _, v4 in WATCHED_MESSAGE_TYPES do
		object.SignalREventTable[v4] = Instance.new("BindableEvent")
	end

	object.shouldThrottleParticipantUpdate = false
	object.participantsStateThrottleTime = 0
	object.lastParticipantsStateUpdate = 0
	object.lastStateUpdateCounter = 0
	object.reverseNudgeToxicUserRemovalCallbacks = {}

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		object.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000
		local success, result = pcall(function()
			return IXPServiceWrapper:GetLayerData(defineFastString)
		end)

		if success and result and result[defineFastString2] then
			object.shouldThrottleParticipantUpdate = true
		end
	end

	object.MuteStatusIcons = {
		MicOn = object:GetIcon("Unmuted0", "SpeakerLight"),
		MicOff = object:GetIcon("Muted", "SpeakerLight"),
		MicDisabled = object:GetIcon("Muted", "SpeakerLight"),
		Loading = object:GetIcon("Connecting", "SpeakerLight"),
		Error = object:GetIcon("Error", "SpeakerLight")
	}

	object.PlayerMuteStatusIcons = {
		MicOn = object:GetIcon("Unmuted0", "MicLight"),
		MicOff = object:GetIcon("Muted", "MicLight"),
		MicDisabled = object:GetIcon("Muted", "MicLight"),
		Loading = object:GetIcon("Connecting", "MicLight"),
		Error = object:GetIcon("Error", "MicLight")
	}

	local flag = false
	local eventConnection = object.attemptVoiceRejoin.Event:Connect(function()
		flag = true
	end)
	local v4

	if GetFFlagExpChatUseVoiceParticipantsStore() then
		v4 = ExpChat.Stores.GetVoiceStore(false)
	else
		v4 = nil
	end

	object.coreVoiceManager:subscribe("GetPermissions", function(p3, p4, p5, p6)
		local v5 = object.inExpUpsellEntrypoint == nil and "VoiceChatServiceManager.requestMicPermission"
			or object.inExpUpsellEntrypoint

		object.getPermissionsFunction(p3, p4, p5, v5, p6)
	end)
	object.coreVoiceManager:subscribe("OnVoiceParticipantRemoved", function(p3)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v4.handleVoiceParticipantRemoved(p3)
		elseif ExpChat.Events.VoiceParticipantRemoved then
			ExpChat.Events.VoiceParticipantRemoved((tostring(p3)))
		end
	end)
	object.coreVoiceManager:subscribe("OnVoiceParticipantAdded", function(p3)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v4.handleVoiceParticipantAdded(p3)
		elseif ExpChat.Events.VoiceParticipantAdded then
			ExpChat.Events.VoiceParticipantAdded((tostring(p3)))
		end
	end)
	object.coreVoiceManager:subscribe("OnVoiceParticipantToggleMuted", function(p3, p4)
		if ExpChat.Events.VoiceParticipantToggleMuted then
			ExpChat.Events.VoiceParticipantToggleMuted(tostring(p3), p4)
		end
	end)
	object.coreVoiceManager:subscribe("OnUserAndPlaceCanUseVoiceResolved", function(p3, p4)
		object:_onUserAndPlaceCanUseVoiceResolved(p3, p4)
	end)

	if FFlagReactiveVoiceRestrictionsUFR then
		object.coreVoiceManager:subscribe("OnJoinAgeVerificationOverlayFetched", function(p3)
			object:_onJoinAgeVerificationOverlayFetched(p3)
		end)
	end

	object.coreVoiceManager:subscribe("OnRequestMicPermissionResolved", function()
		if not GetFFlagEnableUniveralVoiceToasts() then
			return
		end

		if
			FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast
			and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider
		then
			return object:CheckAndShowNotAudiblePrompt():andThen(function()
				return object:ShowNotAudiblePromptVoiceChatVolume()
			end)
		end

		return object:CheckAndShowNotAudiblePrompt()
	end)
	object.coreVoiceManager:subscribe("OnRequestMicPermissionRejected", function()
		if object:IsSeamlessVoice() then
			object.deniedMicPermissions = true
		end

		if GetFFlagEnableUniveralVoiceToasts() and not defineFastFlag then
			return object:CheckAndShowPermissionPrompt()
		end
	end)

	if GetFFlagMicConsumerRegistry() then
		object.coreVoiceManager:subscribe("OnMicPermissionDeniedToast", function()
			object:showPrompt("MicPermissionDenied")
		end)

		object.coreVoiceManager:subscribe("OnMicFirstUnmutePrivacy", function()
			object:showPrompt("MicFirstUnmutePrivacy")
		end)
	end

	if fFlagDebugShowAudioDeviceInputDebugger then
		object.coreVoiceManager:subscribe("OnDevicePlayerChanged", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
		object.coreVoiceManager:subscribe("OnDeviceActiveChanged", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
		object.coreVoiceManager:subscribe("OnDeviceMuteChanged", function()
			object:UpdateAudioDeviceInputDebugger()
		end)

		if FFlagEnablePartyVoiceChangersInLua then
			object.coreVoiceManager:subscribe("OnVoiceChangerChanged", function()
				object:UpdateAudioDeviceInputDebugger()
			end)
		end

		object.coreVoiceManager:subscribe("OnPlayerMuted", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
		object.coreVoiceManager:subscribe("OnAudioDeviceInputAdded", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
		object.coreVoiceManager:subscribe("OnAudioDeviceInputRemoved", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
		object.coreVoiceManager:subscribe("OnDeviceMutedByLocalUserChanged", function()
			object:UpdateAudioDeviceInputDebugger()
		end)
	end

	object.coreVoiceManager:subscribe("OnStateChanged", function(_, p3)
		MicrophoneDevicePermissionsLogging:setClientSessionId(object.coreVoiceManager:GetSessionId())

		if p3 == Enum.VoiceChatState.Ended or p3 == Enum.VoiceChatState.Failed then
			object.voiceConnectEventReportedForActiveSession = false
		end

		if p3 == Enum.VoiceChatState.Joined and defineFastFlag9 then
			local isVoiceChatVolumeSliderVisible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible

			local VoiceChatService2 = game:GetService("VoiceChatService")

			if isVoiceChatVolumeSliderVisible(true, VoiceChatService2.UseNewAudioApi) then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString3)
			end
		end

		if defineFastFlag10 and defineFastFlag11 and p3 == Enum.VoiceChatState.Joined and object:ShouldRewarmUser() then
			object:ConsumeVoiceRewarm()
		end

		if
			p3 == Enum.VoiceChatState.Joined
			and object:GetVoiceJoinProgress() == VOICE_JOIN_PROGRESS.Idle
			and not object.voiceConnectEventReportedForActiveSession
		then
			local connectDisconnectAnalyticsData = object:GetConnectDisconnectAnalyticsData()
			connectDisconnectAnalyticsData.connectionSource = Constants2.VOICE_CONNECTION_SOURCE.AUTO_CONNECT
			object.pendingConnectionSource = nil
			object.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", connectDisconnectAnalyticsData)

			if defineFastFlag12 then
				object.Analytics:reportVoiceConnected(getEnumName( -- inferred equivalent call
					Constants2.VOICE_CONNECTION_SOURCE,
					connectDisconnectAnalyticsData.connectionSource
				))
			end

			object.voiceConnectEventReportedForActiveSession = true
			flag = false
			eventConnection:Disconnect()
		end

		local v5 = p3 == Enum.VoiceChatState.Ended

		if v5 then
			local connectDisconnectAnalyticsData = object:GetConnectDisconnectAnalyticsData()
			connectDisconnectAnalyticsData.disconnectReason = object.pendingDisconnectReason
				or Constants2.VOICE_DISCONNECT_REASON.SYSTEM
			object.Analytics:reportConnectDisconnectEvents("voiceDisconnectReasonEvent", connectDisconnectAnalyticsData)

			if defineFastFlag12 then
				object.Analytics:reportVoiceDisconnected(getEnumName( -- inferred equivalent call
					Constants2.VOICE_DISCONNECT_REASON,
					connectDisconnectAnalyticsData.disconnectReason
				))
			end

			object.pendingDisconnectReason = nil
		end

		if
			v5
			and object.bannedUntil == nil
			and (not FFlagProactiveVoiceRestrictionsUFR or object:GetVoiceRestrictionState(false) == "normal")
		then
			if defineFastFlag7 and object.runService:IsStudio() then
				return
			end

			object:showPrompt(PromptType.LeaveVoice)
		end
	end)

	object.coreVoiceManager:subscribe("OnVoiceChatServiceInitialized", function()
		object:ShowVoiceUI()

		if defineFastFlag2 then
			v:debug("Simulating join voice")
			object:simulateVoiceConnectDisconnect()
		end

		if not object.coreVoiceManager.initializedPostSuspension then
			local success, result = pcall(function(): boolean
				return AppStorageService:GetItem(Constants2.VOICE_WITH_TC_TOAST_KEY) == "true"
			end)

			if success and not result then
				object:showPrompt(PromptType.UpdateOnAutoJoinToast)
				pcall(function()
					AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
					AppStorageService:Flush()
				end)
			end
		end
	end)

	object.coreVoiceManager:subscribe("OnInitialJoinFailed", function()
		object:InitialJoinFailedPrompt()
	end)
	object.coreVoiceManager:subscribe("OnPlayerModerated", function()
		object.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.MODERATED
		object:ShowPlayerModeratedMessage()
	end)

	object.coreVoiceManager:subscribe("OnRetryRequested", function()
		object:showPrompt(PromptType.Retry)
	end)
	object.coreVoiceManager:subscribe("OnVoiceToxicityModal", function()
		v:debug("Showing Voice Toxicity Modal")

		if FFlagProactiveVoiceRestrictionsUFRIXPExposure then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.VoiceUserIDLayer)
		end

		if FFlagProactiveVoiceRestrictionsUFR then
			showLegacyVoiceRestriction({
				manager = object,
				settings = nil,
				trigger = "toxicityModal",
				isCurrent = function(): boolean
					return true
				end
			})
		elseif GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			object:showPrompt(PromptType.VoiceToxicityModalV2)
		else
			object:showPrompt(PromptType.VoiceToxicityModal)
		end
	end)
	object.coreVoiceManager:subscribe("OnVoiceToxicityToast", function()
		v:debug("Showing Voice Toxicity Toast")

		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			object:showPrompt(PromptType.VoiceToxicityToastV2)
		else
			object:showPrompt(PromptType.VoiceToxicityToast)
		end
	end)
	object.coreVoiceManager:subscribe("OnPermissionRequested", function()
		if GetFFlagShowDevicePermissionsModal() then
			object:showPrompt(PromptType.DevicePermissionsModal)
		else
			object:showPrompt(PromptType.Permission)
		end
	end)
	object.coreVoiceManager:subscribe("OnShowDataConsentToast", function()
		if GetFFlagEnableSeamlessVoiceDataConsentToast() then
			object:showDataConsentToast()
		end
	end)
	object.coreVoiceManager:subscribe("OnVoiceReverseNudgeIconColorChange", function(p3)
		v:debug("Showing Reverse Nudge Icon Color Change")

		if ExpChat.Events.AddReverseNudgeToxicUser and ExpChat.Events.RemoveReverseNudgeToxicUser then
			object:AddReverseNudgeToxicUser(
				p3.toxicUserId,
				ExpChat.Events.AddReverseNudgeToxicUser,
				ExpChat.Events.RemoveReverseNudgeToxicUser
			)
		end
	end)
	object.coreVoiceManager.setVoiceUIVisibility.Event:Connect(function(flag2: boolean)
		if flag2 then
			object:ShowVoiceUI()
		else
			object:HideVoiceUI()
		end
	end)
	object.coreVoiceManager:subscribe("OnVoiceJoin", function()
		if GetFFlagNonVoiceFTUX() and object.hasLeftFTUX then
			object.hasLeftFTUX = false
			object:showJoinVoicePrompt()

			object.Analytics:reportConnectDisconnectEvents(
				"voiceConnectFtuxLeaveEvent",
				object:GetConnectDisconnectAnalyticsData()
			)
		elseif object:IsSeamlessVoice() then
			object:showJoinVoicePrompt()
			object:SetVoiceConnectCookieValue(true)
		else
			object:showPrompt(PromptType.VoiceConsentAcceptedToast)
		end

		if GetFFlagEnableVoiceChatMuteForVideoCaptures() and object.CaptureService:IsCapturingVideo() then
			if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
				default2:MuteAll("Capture")
			else
				object:MuteAll(true, "Capture")
			end

			object:HideVoiceUI()
		end

		if flag then
			local connectDisconnectAnalyticsData = object:GetConnectDisconnectAnalyticsData()
			connectDisconnectAnalyticsData.connectionSource = object.pendingConnectionSource
			object.pendingConnectionSource = nil
			object.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", connectDisconnectAnalyticsData)

			if defineFastFlag12 then
				object.Analytics:reportVoiceConnected(getEnumName( -- inferred equivalent call
					Constants2.VOICE_CONNECTION_SOURCE,
					connectDisconnectAnalyticsData.connectionSource
				))
			end

			object.voiceConnectEventReportedForActiveSession = true
			flag = false
			eventConnection:Disconnect()
		end
	end)
	return object
end

local function shorten(p) -- 1 equivalent call inferred from this helper
	return "..." .. string.sub(tostring(p), -4)
end

function VoiceChatServiceManager:subscribe(p, p2)
	return self.coreVoiceManager:subscribe(p, p2)
end

function VoiceChatServiceManager:unsubscribe(p, p2)
	self.coreVoiceManager:unsubscribe(p, p2)
end

function VoiceChatServiceManager:_reportJoinFailed(p, p2)
	return self.coreVoiceManager:_reportJoinFailed(p, p2)
end

function VoiceChatServiceManager:_asyncInit()
	return self.coreVoiceManager:_asyncInit()
end

function VoiceChatServiceManager:asyncInit()
	return self.coreVoiceManager:asyncInit()
end

function VoiceChatServiceManager:CheckAudioInputExists()
	return self.coreVoiceManager:CheckAudioInputExists()
end

function VoiceChatServiceManager:getService()
	return self.service
end

function VoiceChatServiceManager.GetMicManager(p)
	return p.coreVoiceManager and p.coreVoiceManager.micManager or nil
end

function VoiceChatServiceManager:GetMutedAnyone()
	return self.coreVoiceManager:GetMutedAnyone()
end

function VoiceChatServiceManager:RecordGameSettingsOpened()
	self.coreVoiceManager:RecordGameSettingsOpened()
end

function VoiceChatServiceManager:ReportVoiceVolumeImpressionsIfNeeded()
	self.coreVoiceManager:ReportVoiceVolumeImpressionsIfNeeded()
end

function VoiceChatServiceManager:GetRequest(p, p2)
	return self.coreVoiceManager:GetRequest(p, p2)
end

function VoiceChatServiceManager.PostRequest(p, p2, _, p3)
	local success, result = pcall(function()
		return HttpService:JSONDecode((p.HttpRbxApiService:PostAsyncFullUrl(
			p2,
			p3,
			Enum.ThrottlingPriority.Default,
			Enum.HttpContentType.ApplicationJson,
			Enum.HttpRequestType.Players
		)))
	end)

	return success and result
end

function VoiceChatServiceManager:_GetShowAgeVerificationOverlay(p)
	return self.coreVoiceManager:_GetShowAgeVerificationOverlay(p)
end

function VoiceChatServiceManager:simulateVoiceConnectDisconnect()
	task.spawn(function()
		while true do
			task.wait(defineFastInt)

			if self.voiceUIVisible then
				v:debug("Hiding Voice")
				self:HideVoiceUI()
			else
				v:debug("Showing Voice")
				self:ShowVoiceUI()
			end
		end
	end)
end

function VoiceChatServiceManager:FetchAgeVerificationOverlay(p)
	return self.coreVoiceManager:FetchAgeVerificationOverlay(p)
end

function VoiceChatServiceManager:FetchPhoneVerificationUpsell(p: string, p2: number?, flag: boolean?)
	return self.coreVoiceManager:FetchPhoneVerificationUpsell(p, p2, flag)
end

function VoiceChatServiceManager:RecordUserSeenModal(p: string)
	return PostRecordUserSeenGeneralModal(bind(self, "PostRequest"), p) -- inferred equivalent call
end

function VoiceChatServiceManager:checkAndUpdateSequence(p: string, p2: number)
	return self.coreVoiceManager:checkAndUpdateSequence(p, p2)
end

function VoiceChatServiceManager:onMissedSequence(p)
	return self.coreVoiceManager:onMissedSequence(p)
end

function VoiceChatServiceManager:watchSignalR()
	return self.coreVoiceManager:watchSignalR()
end

function VoiceChatServiceManager:voicePermissionGranted(p)
	return self.coreVoiceManager:voicePermissionGranted(p)
end

function VoiceChatServiceManager:GetSignalREvent(p)
	return self.coreVoiceManager:GetSignalREvent(p)
end

function VoiceChatServiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p)
	return self.coreVoiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p)
end

function VoiceChatServiceManager:resolveAvatarChatUserAndPlaceSettings()
	return self.coreVoiceManager:resolveAvatarChatUserAndPlaceSettings()
end

function VoiceChatServiceManager:EnableVoice()
	return self.coreVoiceManager:EnableVoice()
end

function VoiceChatServiceManager:_VoiceChatFirstTimeUX(object)
	local v4 = nil
	local v5 = nil

	if not pcall(function()
		local item = object:GetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY)
		local item2 = object:GetItem(Constants2.SEAMLESS_VOICE_STUX_KEY)
		v4 = item == "true"
		v5 = item2 == nil and 0 or tonumber(item2)
	end) then
		v:warning("Failed to read FTUX/STUX from AppStorage")
		return
	end

	v:trace("hasShownFTUX: {}. STUXCount: {}", v4, v5)

	if v4 then
		if v5 < defineFastInt2 and (not defineFastFlag4 or self:GetVoiceConnectCookieValue()) then
			v:debug("Showing STUX")
			self:showPrompt(PromptType.JoinVoiceSTUX)
			pcall(function()
				object:SetItem(Constants2.SEAMLESS_VOICE_STUX_KEY, (tostring(v5 + 1)))
				object:Flush()
			end)
		end
	else
		v:debug("Showing FTUX")
		self.isShowingFTUX = true
		self.Analytics:reportConnectDisconnectEvents(
			"voiceConnectFtuxJoinEvent",
			self:GetConnectDisconnectAnalyticsData()
		)

		if GetFFlagNonVoiceFTUX() then
			ExpChat.Events.VoiceUIVisibilityChanged(true)
		else
			self:MuteAll(true, "FTUX")
			self.muteAllChanged.Event:Once(function()
				self:HideFTUX(object)
				self.Analytics:reportConnectDisconnectEvents(
					"voiceConnectFtuxLeaveEvent",
					self:GetConnectDisconnectAnalyticsData()
				)
			end)
			self.talkingChanged.Event:Once(function()
				self:HideFTUX(object)
			end)

			if GetFFlagEnableFtuxExitOnMuteToggle() then
				self.coreVoiceManager.onPlayerMuteToggled.Event:Once(function()
					self:HideFTUX(object)
				end)
			end
		end
	end
end

function VoiceChatServiceManager:VoiceChatFirstTimeUX(p)
	if defineFastFlag4 and not self:verifyUniverseAndPlaceCanUseVoice() then
		v:debug("Universe/place is not voice enabled, do not run FTUX/STUX")
		return
	end

	if not defineFastFlag3 then
		local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

		if
			type(ageVerificationOverlay) == "table"
			and ageVerificationOverlay.voiceSettings
			and ageVerificationOverlay.voiceSettings.seamlessVoiceStatus ~= Constants2.SEAMLESS_VOICE_STATUS_ENABLED_NEW_USER
		then
			v:debug("User not eligible for FTUX/STUX")
			return
		end
	end

	local function startFTUX() -- 3 equivalent calls inferred from this helper
		v:debug("Starting FTUX")
		self:_VoiceChatFirstTimeUX(p)
	end

	if not GetFFlagNonVoiceFTUX() then
		self:asyncInit():andThen(function()
			local stateChangedConnection = nil

			if self.service.VoiceChatState and self.service.VoiceChatState == Enum.VoiceChatState.Joined then
				startFTUX() -- inferred equivalent call
			end

			stateChangedConnection = self.service.StateChanged:Connect(function(_, p2)
				if p2 == Enum.VoiceChatState.Joined then
					startFTUX() -- inferred equivalent call
					stateChangedConnection:Disconnect()
				end
			end)
		end):catch(function(p2)
			v:trace("Failed to start FTUX: {}", p2)
		end)

		return
	end

	startFTUX() -- inferred equivalent call
end

function VoiceChatServiceManager:HideFTUX(object)
	self.isShowingFTUX = false
	self.hideFTUXSignal:Fire()
	pcall(function()
		object:SetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY, "true")
		object:Flush()
	end)

	if GetFFlagNonVoiceFTUX() then
		self.hasLeftFTUX = true
		self.attemptVoiceRejoin:Fire()
	end

	if not GetFFlagNonVoiceFTUX() then
		self:MuteAll(false, "FTUX")
		self:showPrompt(PromptType.JoinedVoiceToast)
	end
end

function VoiceChatServiceManager:_onUserAndPlaceCanUseVoiceResolved(data, p)
	self.bannedUntil = nil

	if data and data.isBanned then
		if FFlagProactiveVoiceRestrictionsUFRIXPExposure then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.VoiceUserIDLayer)
		end

		if FFlagProactiveVoiceRestrictionsUFR then
			self.voiceRestrictionController.check("gameJoin", data)
			return
		end

		local informedOfBan = GetInformedOfBan(bind(self, "GetRequest")) -- inferred equivalent call

		if informedOfBan and not informedOfBan.informedOfBan then
			if
				GetFFlagAvatarChatServiceEnabled()
				and GetFFlagVoiceChatServiceManagerUseAvatarChat()
				and data.bannedUntil == nil
			then
				self:ShowPlayerModeratedMessage()
			elseif data.bannedUntil == nil then
				self:showPrompt(PromptType.VoiceChatSuspendedPermanent)
			else
				self.bannedUntil = data.bannedUntil

				if data.banReason == BAN_REASON.NUDGE_V3 then
					if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
						self:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)
					else
						self:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)
					end
				else
					self:showPrompt(PromptType.VoiceChatSuspendedTemporary)
				end
			end
		end

		if informedOfBan and informedOfBan.informedOfBan then
			self:ShowPlayerModeratedMessage(true)
		end
	elseif self.runService:IsStudio() and data and not data.isVoiceEnabled then
		self:showPrompt(PromptType.User)
	elseif self.runService:IsStudio() and p and not p.isPlaceEnabledForVoice then
		local place = PromptType.Place
		local v4

		if GetFFlagEnableVoicePromptReasonText() then
			v4 = table.concat(p.reasons or {}, "") or nil
		end

		self:showPrompt(place, v4)
	end
end

function VoiceChatServiceManager:_onJoinAgeVerificationOverlayFetched(p)
	local voiceSettings

	if type(p) == "table" then
		voiceSettings = p.voiceSettings
	end

	if
		not voiceSettings
		or voiceSettings.isBanned
		or voiceSettings.banReason ~= BAN_REASON.UFR_UNACKNOWLEDGED_EXPIRED
	then
		return
	end

	if FFlagProactiveVoiceRestrictionsUFRIXPExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.VoiceUserIDLayer)
	end

	if FFlagProactiveVoiceRestrictionsUFR then
		self.voiceRestrictionController.showPendingAcknowledgement(voiceSettings)
	end
end

function VoiceChatServiceManager:ChangeVoiceJoinProgress(p)
	return self.coreVoiceManager:ChangeVoiceJoinProgress(p)
end

function VoiceChatServiceManager:GetVoiceJoinProgress()
	return self.coreVoiceManager.VoiceJoinProgress
end

function VoiceChatServiceManager:UserOnlyEligibleForVoice()
	return self.coreVoiceManager:UserOnlyEligibleForVoice()
end

function VoiceChatServiceManager:UserOnlyEligibleForVoiceViaOverlay()
	return self.coreVoiceManager:UserOnlyEligibleForVoiceViaOverlay()
end

function VoiceChatServiceManager:UserVoiceEnabled()
	return self.coreVoiceManager:UserVoiceEnabled()
end

function VoiceChatServiceManager:UserInInExperienceUpsellTreatment()
	return self.coreVoiceManager:UserInInExperienceUpsellTreatment()
end

function VoiceChatServiceManager:UserEligibleForInExperienceUpsell()
	return self.coreVoiceManager:UserEligibleForInExperienceUpsell()
end

function VoiceChatServiceManager:ShowInExperienceVoiceUpsell(p: string)
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if defineFastFlag13 and type(ageVerificationOverlay) ~= "table" then
		return
	end

	local showVoiceInExperienceUpsellVariant = ageVerificationOverlay.showVoiceInExperienceUpsellVariant

	self:SetInExpUpsellEntrypoint(p)

	self:showPrompt((self:GetInExpUpsellPromptFromEnum(showVoiceInExperienceUpsellVariant)))
end

function VoiceChatServiceManager:ShowInExperiencePhoneVoiceUpsell(p: string, p2: string)
	self:SetInExpUpsellEntrypoint(p)

	phoneUpsellController.openPhoneUpsell({
		origin = "inExperience",
		eventContext = "verificationUpsell",
		entryConfig = {
			titleKey = "Feature.VerificationUpsell.Heading.UnlockVoiceChat",
			descriptionKey = "Feature.VerificationUpsell.Description.UnlockVoiceChatBody",
			buttonKey = GetFFlagInExperiencePhoneUpsellNewCopy() and "Feature.AccountSettings.Action.Verify" or "Feature.VerificationUpsell.Action.AddPhoneNumber",
			extraButtonConfig = { extraButtonKey = "Feature.VerificationUpsell.Action.NotNow" },
			legalTextKey = "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer2"
		},
		onSuccessBeforeToast = function()
			self.coreVoiceManager:DisablePhoneVerificationUpsell()
			postPhoneUpsellDisplayed(bind(self, "PostRequest"), p2, os.time(), false) -- inferred equivalent call
		end,
		onSuccess = function()
			if self.pendingConnectionSource == nil then
				self.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			self:EnableVoice()
		end,
		closeUpsell = function()
			if p ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				self:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end

			postPhoneUpsellDisplayed(bind(self, "PostRequest"), p2, os.time(), true) -- inferred equivalent call
		end
	})
end

function VoiceChatServiceManager:DisablePhoneVerificationUpsell()
	self.coreVoiceManager:DisablePhoneVerificationUpsell()
end

function VoiceChatServiceManager:SetInExpUpsellEntrypoint(inExpUpsellEntrypoint: string)
	self.inExpUpsellEntrypoint = inExpUpsellEntrypoint
end

function VoiceChatServiceManager:userAndPlaceCanUseVoice()
	return self.coreVoiceManager:userAndPlaceCanUseVoice()
end

function VoiceChatServiceManager:verifyUniverseAndPlaceCanUseVoice()
	return self.coreVoiceManager:verifyUniverseAndPlaceCanUseVoice()
end

function VoiceChatServiceManager:GetVoiceConnectCookieValue()
	return self.coreVoiceManager:GetVoiceConnectCookieValue()
end

function VoiceChatServiceManager:GetVoiceConnectCookie()
	return self.coreVoiceManager:GetVoiceConnectCookie()
end

function VoiceChatServiceManager:SetVoiceConnectCookieValue(flag: boolean)
	return self.coreVoiceManager:SetVoiceConnectCookieValue(flag)
end

function VoiceChatServiceManager:GetVoiceRewarmCookie()
	return self.coreVoiceManager:GetVoiceRewarmCookie()
end

function VoiceChatServiceManager:SetVoiceRewarmCookie(p: string)
	self.coreVoiceManager:SetVoiceRewarmCookie(p)
end

function VoiceChatServiceManager:ShouldRewarmUser()
	return self.coreVoiceManager:ShouldRewarmUser()
end

function VoiceChatServiceManager:ConsumeVoiceRewarm()
	self.coreVoiceManager:ConsumeVoiceRewarm()
end

function VoiceChatServiceManager:SetNewUserFTUXCookieValue(flag: boolean)
	return self.coreVoiceManager:SetNewUserFTUXCookieValue(flag)
end

function VoiceChatServiceManager:ShowPlayerModeratedMessage(flag: boolean?)
	if FFlagProactiveVoiceRestrictionsUFRIXPExposure then
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(AppUserLayers.VoiceUserIDLayer)
	end

	if FFlagProactiveVoiceRestrictionsUFR then
		self.voiceRestrictionController.check("removedFromVoice")
		return
	end

	local userSettings = GetUserSettings(bind(self, "GetRequest")) -- inferred equivalent call

	if not (userSettings and userSettings.isBanned) then
		self:_reportJoinFailed("PlayerModeratedBadState", Analytics.ERROR)
		return
	end

	self.banReason = userSettings.banReason

	if userSettings.bannedUntil == nil then
		self:showPrompt(PromptType.VoiceChatSuspendedPermanent)
		return
	end

	self.bannedUntil = userSettings.bannedUntil

	if flag then
		self:showPrompt(PromptType.VoiceChatSuspendedTemporaryToast)
	elseif self.banReason ~= BAN_REASON.NUDGE_V3 then
		self:showPrompt(PromptType.VoiceChatSuspendedTemporary)
	elseif GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
		self:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)
	else
		self:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)
	end
end

function VoiceChatServiceManager:GetVoiceRestrictionState(p)
	return self.voiceRestrictionController.getPresentationState(p)
end

function VoiceChatServiceManager.ShowVoiceRestriction(p)
	p.voiceRestrictionController.check("micTap")
end

function VoiceChatServiceManager:_onUFRInterventionReceived(p)
	if p.type ~= Constants.NotificationDialogType.ChatTimeout then
		return
	end

	local activeInterventionTimeoutEnd, v4 = getActiveInterventionTimeoutEnd(p, getServerNow())

	if not activeInterventionTimeoutEnd then
		return
	end

	self.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.MODERATED
	self.voiceRestrictionController.applyUFRTimeout(v4)
	self.coreVoiceManager:LeaveVoiceForRestriction()
end

function VoiceChatServiceManager:CheckCallState()
	return self.coreVoiceManager:CheckCallState()
end

function VoiceChatServiceManager:ShowVoiceChatLoadingMessage()
	self:showPrompt(PromptType.VoiceLoading)
end

function VoiceChatServiceManager:requestMicPermission()
	return self.coreVoiceManager:requestMicPermission()
end

function VoiceChatServiceManager:canUseServiceAsync()
	return self.coreVoiceManager:canUseServiceAsync()
end

function VoiceChatServiceManager:canUseService()
	if self.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		return false
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(
			"https://voice.roblox.com/v1/settings",
			Enum.ThrottlingPriority.Default,
			Enum.HttpRequestType.Players
		)))
	end)

	local isVoiceEnabled = success and result.isVoiceEnabled

	if not isVoiceEnabled then
		self.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable
	end

	return isVoiceEnabled
end

function VoiceChatServiceManager:ensureInitialized(p)
	return self.coreVoiceManager:ensureInitialized(p)
end

function VoiceChatServiceManager:GetSessionId()
	return self.coreVoiceManager:GetSessionId()
end

function VoiceChatServiceManager:GetChannelId()
	return self.coreVoiceManager:GetChannelId()
end

function VoiceChatServiceManager:JoinWithVoiceMuteData(p)
	return self.coreVoiceManager:JoinWithVoiceMuteData(p)
end

function VoiceChatServiceManager:calculateBanDuration(p: number, p2: number)
	return (math.ceil((p2 - p) / 60))
end

function VoiceChatServiceManager:getBanEnd(p: number, absoluteSeconds: number)
	return {
		minutes = self:calculateBanDuration(p, absoluteSeconds),
		absoluteSeconds = absoluteSeconds
	}
end

function VoiceChatServiceManager:ShowVoiceUI()
	self.voiceUIVisible = true
	self.showVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(true)
	end
end

function VoiceChatServiceManager:HideVoiceUI()
	self.voiceUIVisible = false
	self.hideVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(false)
	end
end

function VoiceChatServiceManager:createPromptInstance(onReadyForSignal, p)
	if self.promptSignal then
		self.promptSignal:Destroy()
		self.promptSignal = nil
	end

	self.promptSignal = Instance.new("BindableEvent")
	local errorText

	if GetFFlagEnableVoicePromptReasonText() then
		errorText = self.errorText
	end

	local v4 = p == PromptType.VoiceChatSuspendedTemporaryB

	if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
		v4 = v4 or p == PromptType.VoiceChatSuspendedTemporaryBV2
	end

	local bannedUntil = not FFlagVoiceChatBanDurationUseServerTime and "" or nil

	if self.bannedUntil ~= nil then
		if FFlagVoiceChatBanDurationUseServerTime then
			bannedUntil = self:getBanEnd(Workspace:GetServerTimeNow(), self.bannedUntil.Seconds)
		elseif v4 then
			bannedUntil = tostring((self:calculateBanDuration(DateTime.now().UnixTimestamp, self.bannedUntil.Seconds)))
		else
			bannedUntil = DateTime.fromUnixTimestamp(self.bannedUntil.Seconds):FormatLocalTime(
				"l LT",
				LocalizationService.RobloxLocaleId
			)
		end
	end

	local v5 = p == PromptType.VoiceToxicityModal
		or p == PromptType.VoiceToxicityToast
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
		and (p == PromptType.VoiceToxicityModalV2 or p == PromptType.VoiceToxicityToastV2)

	local v6 = p == PromptType.VoiceConsentModalV1
		or p == PromptType.VoiceConsentModalV2
		or p == PromptType.VoiceConsentModalV3

	local v7 = false
	local v8 = nil

	if
		GetFFlagShowDevicePermissionsModal()
		and p == PromptType.DevicePermissionsModal
		and self.settingsAppAvailable == nil
	then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function()
					v7, v8 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()
				end)
				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if v8 ~= nil then
					break
				end
			end
		else
			v7, v8 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()
		end

		self.settingsAppAvailable = v7 and v8
	end

	local mount = Roact.mount
	local createElement = Roact.createElement
	local v9 = {
		Analytics = Analytics.new(),
		promptSignal = self.promptSignal.Event,
		bannedUntil = bannedUntil,
		policyMapper = self.policyMapper,
		errorText = errorText,
		onReadyForSignal = onReadyForSignal,
		VoiceChatServiceManager = self,
		settingsAppAvailable = self.settingsAppAvailable ~= nil and self.settingsAppAvailable,
		onContinueFunc = 0,
		onPrimaryActivated = 0,
		onSecondaryActivated = 0
	}
	local onContinueFunc

	if p == PromptType.VoiceChatSuspendedTemporary or v4 then
		onContinueFunc = function()
			PostInformedOfBan(bind(self, "PostRequest"), true) -- inferred equivalent call
		end
	else
		onContinueFunc = v5 and function()
			self.Analytics:reportClosedNudge(self:GetNudgeAnalyticsData())
		end or v6 and function()
			self:RecordUserSeenModal(Constants2.MODAL_IDS.IN_EXP_UPSELL)
		end or nil
	end

	v9.onContinueFunc = onContinueFunc
	local fn

	if v5 then
		fn = function()
			self.Analytics:reportAcknowledgedNudge(self:GetNudgeAnalyticsData())
		end
	elseif defineFastFlag5 or not GetFFlagJoinWithoutMicPermissions() or p ~= PromptType.Permission then
		if
			GetFFlagJoinWithoutMicPermissions()
			and GetFFlagShowDevicePermissionsModal()
			and p == PromptType.DevicePermissionsModal
		then
			fn = function()
				v:debug("Settings app available: {}", self.settingsAppAvailable)
				self.Analytics:reportDevicePermissionsModalEvent(
					self.settingsAppAvailable and "OpenedSettings" or "Acknowledged",
					self:GetSessionId(),
					self:GetInExpUpsellAnalyticsData()
				)

				if not self.settingsAppAvailable then
					v:debug("Current platform does not support switching to settings app")

					return
				end

				v:debug("Switching to settings app")
				default3:switchToSettingsApp(SettingsRoute.Microphone):andThen(function()
					v:debug("Successfully switched to settings app")
				end):catch(function()
					v:error("Error switching to settings app")
				end)
			end
		else
			fn = v4 and function()
				self:reportBanMessage("Understood")
				self.Analytics:reportBanMessageEvent("Understood")
			end or v6 and function()
				self.Analytics:reportInExpConsent(
					"accepted",
					self.inExpUpsellEntrypoint,
					self:GetInExpUpsellAnalyticsData()
				)

				if self.pendingConnectionSource == nil then
					self.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
				end

				self:EnableVoice()
			end or nil
		end
	else
		fn = function()
			local microphone = SettingsRoute.Microphone

			local v10 = default3:supportsSwitchToSettingsApp(microphone):await()
			v:debug("Settings app available: {}", v10)

			if not v10 then
				v:debug("Current platform does not support switching to settings app")

				return
			end

			v:debug("Switching to settings app")
			default3:switchToSettingsApp(microphone):andThen(function()
				v:debug("Successfully switched to settings app")
			end):catch(function()
				v:error("Error switching to settings app")
			end)
		end
	end

	v9.onPrimaryActivated = fn
	local fn2

	if
		p == PromptType.VoiceToxicityModal
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p == PromptType.VoiceToxicityModalV2
	then
		fn2 = function()
			self:ShowVoiceToxicityFeedbackToast()
			self.Analytics:reportDeniedNudge(self:GetNudgeAnalyticsData())
		end
	elseif v5 then
		fn2 = function()
			self.Analytics:reportDeniedNudge(self:GetNudgeAnalyticsData())
		end
	elseif v4 then
		fn2 = function()
			self:ShowVoiceToxicityFeedbackToast()
			self:reportBanMessage("Denied")
			self.Analytics:reportBanMessageEvent("Denied")
		end
	elseif v6 then
		fn2 = function()
			self.Analytics:reportInExpConsent("denied", self.inExpUpsellEntrypoint, self:GetInExpUpsellAnalyticsData())

			if self.inExpUpsellEntrypoint ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				self:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end
		end
	else
		fn2 = p == PromptType.DevicePermissionsModal and function()
			self.Analytics:reportDevicePermissionsModalEvent(
				"Denied",
				self:GetSessionId(),
				self:GetInExpUpsellAnalyticsData()
			)
		end or nil
	end

	v9.onSecondaryActivated = fn2
	self.voiceChatPromptInstance = mount(createElement(VoiceChatPrompt, v9), CoreGui, "RobloxVoiceChatPromptGui")
end

function VoiceChatServiceManager:showPrompt(p, p2)
	if GetFFlagEnableVoicePromptReasonText() then
		self.errorText = p2 or nil
	end

	self:createPromptInstance(function()
		v:debug("Show Prompt: {}", p)
		self.promptSignal:fire(p)
	end, p)
end

function VoiceChatServiceManager:showJoinVoicePrompt()
	self:showPrompt(PromptType.UnifiedJoinVoiceToast)
	pcall(function()
		AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
		AppStorageService:Flush()
	end)
end

function VoiceChatServiceManager:CheckAndShowPermissionPrompt()
	local function showPrompt()
		local userEligible = self.userEligible

		if self.voiceEnabled or userEligible then
			return self.PermissionsService:hasPermissions({ permissionsProtocol.Permissions.MICROPHONE_ACCESS }):andThen(function(p)
				if p and p.status == permissionsProtocol.Status.DENIED then
					self:showPrompt(PromptType.Permission)
				end
			end)
		end

		return Promise.resolve()
	end

	if GetFFlagEnableUniveralVoiceToasts() then
		return showPrompt()
	end

	return self:asyncInit():andThen(function() end):catch(function()
		return showPrompt()
	end)
end

function VoiceChatServiceManager:showDataConsentToast()
	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()
	local v4

	if GetFFlagSeamlessVoiceConsentToastPolicy() then
		v4 = UniversalAppPolicy.getAppFeaturePolicies().getDisplayCheckboxInVoiceConsent() or false
	else
		v4 = false
	end

	local v5, v6

	if type(ageVerificationOverlay) == "table" then
		if ageVerificationOverlay.voiceSettings then
			v5 = ageVerificationOverlay.voiceSettings.seamlessVoiceStatus
		else
			v5 = SeamlessVoiceStatus.Invalid
		end

		v6 = ageVerificationOverlay.showDataConsentToast
	else
		v5 = SeamlessVoiceStatus.Invalid
		v6 = false
	end

	if v6 and v4 then
		if type(self:_GetShowAgeVerificationOverlay()) == "table" then
			v6 = self:_GetShowAgeVerificationOverlay().showDataConsentToast
		else
			v6 = false
		end
	end

	if v5 ~= SeamlessVoiceStatus.EnabledExistingUser or not (v6 and v4) then
		return
	end

	self:RecordUserSeenModal(Constants2.MODAL_IDS.DATA_CONSENT_TOAST)
	return self:showPrompt(PromptType.VoiceDataConsentOptOutToast)
end

function VoiceChatServiceManager:CheckAndShowNotAudiblePrompt()
	if game:GetEngineFeature("VoiceChatSupported") then
		return self:asyncInit():andThen(function()
			if UserSettings().GameSettings.MasterVolume == 0 then
				self:showPrompt(PromptType.NotAudible)
			end
		end):catch(function() end)
	end

	return Promise.resolve()
end

function VoiceChatServiceManager:ShowNotAudiblePromptVoiceChatVolume()
	if
		FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast
		and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider
		and game:GetEngineFeature("VoiceChatSupported")
	then
		return self:asyncInit():andThen(function()
			if
				UserSettings().GameSettings.MasterVolume > 0
				and VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi)
				and UserSettings().GameSettings.VoiceChatVolume == 0
			then
				self:showPrompt(PromptType.NotAudibleVoiceChatVolume)
			end
		end):catch(function() end)
	end

	return Promise.resolve()
end

function VoiceChatServiceManager:InitialJoinFailedPrompt()
	v:debug("JoinByGroupIdToken returns false")

	if not GetFFlagVoiceChatClientRewriteMasterLua then
		self:showPrompt(PromptType.Retry)
	end
end

function VoiceChatServiceManager:ShowVoiceToxicityFeedbackToast()
	v:debug("Sending feedback toast")
	self:showPrompt(PromptType.VoiceToxicityFeedbackToast)
end

function VoiceChatServiceManager:GetNudgeAnalyticsData()
	return Players.LocalPlayer.UserId, self:GetSessionId()
end

function VoiceChatServiceManager:GetInExpUpsellAnalyticsData()
	local v4 = not engineFeature and "" or RbxAnalyticsService:GetPlaySessionId()

	return game.GameId, game.PlaceId, v4
end

function VoiceChatServiceManager:reportBanMessage(p: string)
	self.Analytics:reportBanMessageEventV2(
		p,
		self.banReason,
		Players.LocalPlayer.UserId,
		not self.service and "" or self.previousSessionId
	)
end

function VoiceChatServiceManager:reportJoinVoiceUpsellEvent(p: string, p2: string?, p3: string?)
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	if FFlagVoiceRewarmTelemetry then
		self.Analytics:reportJoinVoiceUpsellEvent(p, playSessionId, self:UserVoiceEnabled(), p2, p3)
	else
		self.Analytics:reportJoinVoiceUpsellEvent(p, playSessionId, self:UserVoiceEnabled())
	end
end

function VoiceChatServiceManager:reportVoiceRewarmShown()
	if self.joinVoiceButtonContext ~= "Rewarm" or self.hasReportedRewarmShown then
		return
	end

	self.hasReportedRewarmShown = true
	self.Analytics:reportVoiceRewarmShown(self:GetVoiceRewarmCookie() ~= "")
end

function VoiceChatServiceManager:SetAndSyncActive(p, flag: boolean)
	self.coreVoiceManager:SetAndSyncActive(p, flag)
end

function VoiceChatServiceManager:CreateAudioDeviceData(p)
	return self.coreVoiceManager:CreateAudioDeviceData(p)
end

function VoiceChatServiceManager:onInstanceAdded(p)
	return self.coreVoiceManager:onInstanceAdded(p)
end

function VoiceChatServiceManager:UpdateAudioDeviceInputDebugger()
	if fFlagDebugShowAudioDeviceInputDebugger then
		if self.voiceDebuggerInstance then
			Roact.update(
				self.voiceDebuggerInstance,
				Roact.createElement(AudioDeviceInputDebugger, {
					instances = self.audioDevices,
					mutedPlayers = self.mutedPlayers
				})
			)
		else
			v:debug("Mounting AudioDeviceInput Debugger")
			self.voiceDebuggerInstance = Roact.mount(
				Roact.createElement(AudioDeviceInputDebugger, {
					instances = self.audioDevices,
					mutedPlayers = self.mutedPlayers
				}),
				CoreGui,
				"RobloxVoiceChatPromptGui"
			)
		end
	end
end

function VoiceChatServiceManager:AddReverseNudgeToxicUser(p: string, callback, callback2)
	callback(p, "iconColorChange")

	local reverseNudgeToxicUserRemovalCallback = self.reverseNudgeToxicUserRemovalCallbacks[p]

	if reverseNudgeToxicUserRemovalCallback ~= nil then
		task.cancel(reverseNudgeToxicUserRemovalCallback)
	end

	local thread = task.delay(GetFIntVoiceReverseNudgeUXDisplayTimeSeconds(), function()
		callback2(p)
		self.reverseNudgeToxicUserRemovalCallbacks[p] = nil
	end)
	self.reverseNudgeToxicUserRemovalCallbacks[p] = thread
end

function VoiceChatServiceManager:onInstanceRemove(p)
	return self.coreVoiceManager:onInstanceRemove(p)
end

function VoiceChatServiceManager:hookupAudioDeviceInputListener()
	return self.coreVoiceManager:hookupAudioDeviceInputListener()
end

function VoiceChatServiceManager:ToggleMutePlayer(p: number, p2: string)
	return self.coreVoiceManager:ToggleMutePlayer(p, p2)
end

function VoiceChatServiceManager:MuteAll(flag: boolean, p: string)
	return self.coreVoiceManager:MuteAll(flag, p)
end

function VoiceChatServiceManager:ToggleMuteSome(p, flag: boolean, p2: string, p3: string)
	return self.coreVoiceManager:ToggleMuteSome(p, flag, p2, p3)
end

function VoiceChatServiceManager.FireMuteNonFriendsEvent(p)
	p.mutedNonFriends:Fire()
end

function VoiceChatServiceManager.EnsureCorrectMuteState(data, items, flag: boolean)
	local set2 = {}

	for _, item in items do
		local participant = data.participants[tostring(item)]

		if not (participant and participant.isMutedLocally ~= flag) then
			continue
		end

		if VoiceChatService.UseNewAudioApi then
			set2[item] = true
			data.mutedPlayers[item] = flag
		else
			data.service:SubscribePause(item, flag)
		end

		participant.isMutedLocally = flag
		data.participantsUpdate:Fire(data.participants)
	end

	if VoiceChatService.UseNewAudioApi then
		for k in data.audioDevices do
			if not (k.Player and set2[k.Player.UserId]) then
				continue
			end

			if engineFeature2 and k.Player ~= Players.LocalPlayer then
				k.MutedByLocalUser = flag
			else
				k.Active = not flag
			end
		end
	end
end

function VoiceChatServiceManager.FireUserAgencySelectedEvent(p, flag: boolean)
	p.userAgencySelected:Fire(flag)
end

function VoiceChatServiceManager.ParticipantStateToIcon(_, data, p)
	local v4 = VOICE_STATE.INACTIVE

	if data.subscriptionCompleted then
		if data.isMutedLocally then
			v4 = VOICE_STATE.LOCAL_MUTED
		elseif data.isMuted then
			v4 = VOICE_STATE.MUTED
		elseif data.isSignalActive then
			v4 = VOICE_STATE.TALKING
		end
	else
		v4 = VOICE_STATE.CONNECTING
	end

	return getIcon(v4, p)
end

function VoiceChatServiceManager.VoiceStateToIcon(_, p, p2, p3)
	return getIcon(p, p2, p3)
end

function VoiceChatServiceManager:GetIcon(p, p2)
	return getIconSrc(p, p2)
end

function VoiceChatServiceManager:JoinVoice(object)
	local v4 = nil
	local joinVoiceButtonContext

	if FFlagVoiceRewarmTelemetry then
		joinVoiceButtonContext = self.joinVoiceButtonContext
		self.joinVoiceButtonContext = nil
	end

	local v5

	if FFlagVoiceRewarmGrafanaMetrics and joinVoiceButtonContext == "Rewarm" then
		v5 = self:GetVoiceRewarmCookie() ~= ""
	end

	if defineFastFlag10 and not defineFastFlag11 then
		v:debug("Consuming voice re-warm cookie on JoinVoice")
		self:SetVoiceRewarmCookie("true")
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()
	local showVoiceInExperienceUpsellVariant

	if defineFastFlag13 then
		if type(ageVerificationOverlay) == "table" then
			showVoiceInExperienceUpsellVariant = ageVerificationOverlay.showVoiceInExperienceUpsellVariant
		end
	else
		showVoiceInExperienceUpsellVariant = ageVerificationOverlay.showVoiceInExperienceUpsellVariant
	end

	local v6 = showVoiceInExperienceUpsellVariant or Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3

	if not FFlagVoiceRewarmTelemetry then
		self.Analytics:reportJoinVoiceButtonEvent("clicked", self:GetInExpUpsellAnalyticsData())
	end

	if self.previousGroupId then
		v4 = FFlagVoiceRewarmTelemetry and "RejoinPreviousChannel" or v4
		self:RejoinPreviousChannel()
		self:showJoinVoicePrompt()
		self:ShowVoiceUI()
		self:SetVoiceConnectCookieValue(true)
	elseif GetFFlagNonVoiceFTUX() and self.isShowingFTUX then
		v4 = FFlagVoiceRewarmTelemetry and "ExitFtux" or v4
		self:HideFTUX(AppStorageService)
	elseif self.deniedMicPermissions then
		v4 = FFlagVoiceRewarmTelemetry and "MicPermissionPrompt" or v4
		self:CheckAndShowPermissionPrompt()
	elseif self:UserVoiceEnabled() then
		v4 = FFlagVoiceRewarmTelemetry and "FirstJoinSession" or v4
		self.isInitialJoin = true
		self.attemptVoiceRejoin:Fire()

		if self:IsNewSeamlessVoiceUserDisconnect() then
			self:SetVoiceConnectCookieValue(true)
			self:SetNewUserFTUXCookieValue(true)
		end
	elseif defineFastFlag8 and self:UserOnlyEligibleForVoiceViaOverlay() or self:UserOnlyEligibleForVoice() then
		v4 = FFlagVoiceRewarmTelemetry and "ConsentModal" or v4

		if GetFFlagDisableConsentModalForExistingUsers() and self:IsSeamlessVoice() then
			self:EnableVoice()
		else
			self:SetInExpUpsellEntrypoint(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE)

			self:showPrompt((self:GetInExpUpsellPromptFromEnum(v6)))
		end
	elseif self:EligibleForAgeCheckToast() then
		v4 = FFlagVoiceRewarmTelemetry and "AgeCheckToast" or v4
		self:showPrompt(PromptType.AgeCheckForVoiceToast)
	elseif
		GetFFlagIntegratePhoneUpsellJoinVoice()
		and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints()
		and not self:UserVoiceEnabled()
		and self:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat
	then
		v4 = FFlagVoiceRewarmTelemetry and "PhoneUpsell" or v4

		if object then
			object:SetVisibility(false, true)
		end

		self:ShowInExperiencePhoneVoiceUpsell(
			Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE,
			Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER
		)
	elseif self:EligibleForFaeUpsell() then
		v4 = FFlagVoiceRewarmTelemetry and "FaeUpsell" or v4

		if self.pendingConnectionSource == nil then
			self.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		end

		self.coreVoiceManager:OptUserToJoinVoice()
		local overlayStore = getOverlayStore(false)

		if not FFlagVoiceRewarmTelemetry then
			self:reportJoinVoiceUpsellEvent("Click")
		end

		overlayStore.setCurrentOverlay(OverlayTypes.SocialUpsell, {
			upsellType = SocialUpsellType.FacialAgeEstimation,
			data = {
				isInExperience = true,
				countDownBadgeText = nil,
				isPhase2 = true,
				upsellEntrySurface = enum.UpsellEntrySurfaceType.InExperienceVoiceChatIcon,
				upsellEntryComponent = enum.UpsellComponent.Modal,
				upsellPurpose = enum.UpsellStage.Fae
			}
		})
	end

	if FFlagVoiceRewarmTelemetry then
		local inExpUpsellAnalyticsData, v7, v8 = self:GetInExpUpsellAnalyticsData()
		self.Analytics:reportJoinVoiceButtonEvent(
			"clicked",
			inExpUpsellAnalyticsData,
			v7,
			v8,
			joinVoiceButtonContext,
			v4
		)
		self:reportJoinVoiceUpsellEvent("Click", joinVoiceButtonContext, v4)
	end

	if FFlagVoiceRewarmGrafanaMetrics and v5 ~= nil then
		self.Analytics:reportVoiceRewarmClicked(v5, v4)
	end

	if self:IsSeamlessVoice() then
		task.spawn(function()
			self.coreVoiceManager:PostUserVoiceConnectionStatus(true)
		end)
	end
end

function VoiceChatServiceManager:EligibleForFaeUpsell()
	local v4 = self.coreVoiceManager:EligibleForFaeUpsell()
		and self.AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

	if not v4 then
		return v4
	end

	if FFlagTestDeviceForFAEUpsell then
		return (deviceMeetsRequirementsForFAE())
	end

	v4 = true
	return true
end

function VoiceChatServiceManager:EligibleForAgeCheckToast()
	return self.coreVoiceManager:EligibleForAgeCheckToast()
end

function VoiceChatServiceManager:ShouldShowJoinVoice()
	if FFlagVoiceRewarmTelemetry then
		if self:EligibleForFaeUpsell() then
			self.joinVoiceButtonContext = "FaeUpsell"
			return true
		end

		if
			self:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice)
			and self:GetVoiceConnectCookie() == ""
		then
			self.joinVoiceButtonContext = "VoiceFtux"
			return true
		end

		if defineFastFlag10 then
			local v4

			if defineFastFlag11 then
				v4 = self:ShouldRewarmUser()
			else
				v4 = self:GetVoiceRewarmCookie() == ""
			end

			if v4 and self:GetVoiceConnectCookie() == "false" and self:UserVoiceEnabled() then
				self.joinVoiceButtonContext = "Rewarm"
				return true
			end
		end
	else
		if
			self:EligibleForFaeUpsell()
			or self:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice)
			and self:GetVoiceConnectCookie() == ""
		then
			return true
		end

		if defineFastFlag10 then
			local v4

			if defineFastFlag11 then
				v4 = self:ShouldRewarmUser()
			else
				v4 = self:GetVoiceRewarmCookie() == ""
			end

			if v4 and self:VoiceChatEnded() then
				return true
			end
		end
	end

	if self:EligibleForAgeCheckToast() then
		if defineFastFlag14 then
			self.joinVoiceButtonContext = "AgeCheckToast"
		end

		return true
	else
		local userInInExperienceUpsellTreatment = self:UserInInExperienceUpsellTreatment()
		local v4 = self:UserOnlyEligibleForVoice() or self:UserVoiceEnabled()

		if
			GetFFlagIntegratePhoneUpsellJoinVoice()
			and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints()
			and not v4
			and not self:UserVoiceEnabled()
			and self:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat
		then
			if defineFastFlag14 then
				self.joinVoiceButtonContext = "PhoneUpsell"
			end

			return true
		end

		if defineFastFlag14 and userInInExperienceUpsellTreatment and v4 then
			self.joinVoiceButtonContext = "InExpUpsell"
		end

		return userInInExperienceUpsellTreatment and v4
	end
end

function VoiceChatServiceManager:ShouldShowJoinVoiceOnDisconnect()
	return self.coreVoiceManager:ShouldShowJoinVoiceOnDisconnect()
end

function VoiceChatServiceManager:IsSeamlessVoice()
	if GetFFlagCheckUniversePlaceBeforeSuspending() then
		return self.coreVoiceManager:IsSeamlessVoice()
	end

	local ageVerificationOverlay = self:FetchAgeVerificationOverlay()

	if ageVerificationOverlay and ageVerificationOverlay.voiceSettings then
		local seamlessVoiceStatus = ageVerificationOverlay.voiceSettings.seamlessVoiceStatus
		return seamlessVoiceStatus == SeamlessVoiceStatus.EnabledExistingUser
			or seamlessVoiceStatus == SeamlessVoiceStatus.EnabledNewUser
	end

	v:error("VoiceChatServiceManager:IsSeamlessVoice() - ageVerificationOverlayData or voiceSettings is nil")
	return false
end

function VoiceChatServiceManager:HasSeamlessVoiceFeature(p)
	return self.coreVoiceManager:HasSeamlessVoiceFeature(p)
end

function VoiceChatServiceManager:IsNewSeamlessVoiceUserDisconnect()
	return self.coreVoiceManager:IsNewSeamlessVoiceUserDisconnect()
end

function VoiceChatServiceManager:GetConnectDisconnectButtonAnalyticsData(flag: boolean)
	local v4 = not engineFeature and "" or RbxAnalyticsService:GetPlaySessionId()

	local sessionIds = { game.GameId, game.PlaceId, v4 }

	if flag and self:getService() then
		table.insert(sessionIds, self:GetSessionId())
	end

	return unpack(sessionIds)
end

function VoiceChatServiceManager:GetConnectDisconnectAnalyticsData()
	local playSessionId = not engineFeature and "" or RbxAnalyticsService:GetPlaySessionId()
	local connectDisconnectAnalyticsData = {}

	connectDisconnectAnalyticsData.universeId = game.GameId
	connectDisconnectAnalyticsData.placeId = game.PlaceId
	connectDisconnectAnalyticsData.playSessionId = playSessionId

	if GetFFlagNonVoiceFTUX() then
		connectDisconnectAnalyticsData.voiceSessionId = not self.service and "" or self:GetSessionId()
	else
		connectDisconnectAnalyticsData.voiceSessionId = self:GetSessionId()
	end

	connectDisconnectAnalyticsData.durationTimestamp = default:getTimestamp()

	return connectDisconnectAnalyticsData
end

function VoiceChatServiceManager:Leave()
	self:ensureInitialized("leave")
	self:SetVoiceConnectCookieValue(false)
	self.Analytics:reportConnectDisconnectEvents("voiceDisconnectEvent", self:GetConnectDisconnectAnalyticsData())
	local groupId = self.service:GetGroupId()
	local isPublishPaused = self.service:IsPublishPaused()

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		local VoiceChatService2 = game:GetService("VoiceChatService")

		if VoiceChatService2 then
			VoiceChatService2:leaveVoice()
		end
	else
		self.service:Leave()
	end

	self:HideVoiceUI()
	self.previousGroupId = groupId
	self.previousMutedState = isPublishPaused

	if self:IsSeamlessVoice() then
		task.spawn(function()
			self.coreVoiceManager:PostUserVoiceConnectionStatus(false)
		end)
	end
end

function VoiceChatServiceManager.GetVoiceStateFromEnum(_, p)
	if v2[p] then
		return v2[p]
	end

	v2 = {
		[Enum.VoiceChatState.Idle] = VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Joining] = VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.JoiningRetry] = VOICE_STATE.CONNECTING,
		[Enum.VoiceChatState.Joined] = VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Leaving] = VOICE_STATE.MUTED,
		[Enum.VoiceChatState.Ended] = VOICE_STATE.HIDDEN,
		[Enum.VoiceChatState.Failed] = VOICE_STATE.ERROR
	}

	return v2[p]
end

function VoiceChatServiceManager:GetInExpUpsellPromptFromEnum(p: string)
	return v3[p]
end

function VoiceChatServiceManager:getRecentUsersInteractionData()
	return self.coreVoiceManager:getRecentUsersInteractionData()
end

function VoiceChatServiceManager:_setRecentUserState(p, p2)
	return self.coreVoiceManager:_setRecentUserState(p, p2)
end

function VoiceChatServiceManager:_updateRecentUsersInteractionData()
	return self.coreVoiceManager:_updateRecentUsersInteractionData()
end

function VoiceChatServiceManager:SetupParticipantListeners()
	return self.coreVoiceManager:SetupParticipantListeners()
end

function VoiceChatServiceManager:Disconnect()
	if FFlagProactiveVoiceRestrictionsUFR then
		self.voiceRestrictionController.dispose()
	end

	if FFlagProactiveVoiceRestrictionsUFR and FFlagReactiveVoiceRestrictionsUFR then
		self.voiceInterventionConnection:disconnect()
	end

	self.coreVoiceManager:Disconnect()
	self.coreVoiceManager:unsubscribeAll()
end

function VoiceChatServiceManager:GetSendMuteEvent()
	return self.coreVoiceManager:GetSendMuteEvent()
end

function VoiceChatServiceManager:ToggleMic(p: string?)
	return self.coreVoiceManager:ToggleMic(p)
end

function VoiceChatServiceManager:SubscribeRetry(p: number)
	self:ensureInitialized("subscribe retry")
	v:debug("Attempting to retry connection to user: {}", shorten(p)) -- inferred equivalent call
	self.service:SubscribeRetry(p)
end

function VoiceChatServiceManager:JoinByGroupIdToken(p, p2)
	return self.coreVoiceManager:JoinByGroupIdToken(p, p2)
end

function VoiceChatServiceManager:RejoinPreviousChannel()
	local previousGroupId = self.previousGroupId
	local previousMutedState = self.previousMutedState
	v:debug("Rejoining previous channel {} with mute status {}", previousGroupId, previousMutedState)

	pcall(function()
		if GetFFlagVoiceChatClientRewriteMasterLua() then
			self.coreVoiceManager:RejoinVoice()
			local connectDisconnectAnalyticsData = self:GetConnectDisconnectAnalyticsData()
			connectDisconnectAnalyticsData.connectionSource = self.pendingConnectionSource
			self.pendingConnectionSource = nil
			self.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", connectDisconnectAnalyticsData)

			if defineFastFlag12 then
				self.Analytics:reportVoiceConnected(getEnumName( -- inferred equivalent call
					Constants2.VOICE_CONNECTION_SOURCE,
					connectDisconnectAnalyticsData.connectionSource
				))
			end

			self.voiceConnectEventReportedForActiveSession = true
		elseif previousGroupId and previousGroupId ~= "" then
			self.service:Leave()

			if not self.service:JoinByGroupIdToken(previousGroupId, previousMutedState, true) then
				self:InitialJoinFailedPrompt()
				return
			end

			local connectDisconnectAnalyticsData = self:GetConnectDisconnectAnalyticsData()
			connectDisconnectAnalyticsData.connectionSource = self.pendingConnectionSource
			self.pendingConnectionSource = nil
			self.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", connectDisconnectAnalyticsData)

			if defineFastFlag12 then
				self.Analytics:reportVoiceConnected(getEnumName( -- inferred equivalent call
					Constants2.VOICE_CONNECTION_SOURCE,
					connectDisconnectAnalyticsData.connectionSource
				))
			end

			self.voiceConnectEventReportedForActiveSession = true
		end
	end)
end

function VoiceChatServiceManager.SwitchDevice(_, p, p2, p3)
	if p == VOICE_CHAT_DEVICE_TYPE.Input then
		SoundService:SetInputDevice(p2, p3)
		v:info("[InputDeviceSelection] Setting SS Mic Device To {} {}", p2, p3)
	else
		SoundService:SetOutputDevice(p2, p3)
		v:info("[OutputDeviceSelection] Setting SS Speaker Device To {} {}", p2, p3)
	end
end

function VoiceChatServiceManager.GetDevices(_, p)
	local success, result, v4, v5 = pcall(function()
		if p == VOICE_CHAT_DEVICE_TYPE.Input then
			return SoundService:GetInputDevices()
		end

		return SoundService:GetOutputDevices()
	end)

	return success, result, v4, v5
end

function VoiceChatServiceManager:VoiceChatAvailable(): boolean
	local service = self.service

	if self.available == nil and service then
		self.version = service:GetVoiceChatApiVersion()

		if MIN_VOICE_CHAT_API_VERSION <= self.version then
			self.available = service:GetVoiceChatAvailable()

			while self.available == VOICE_CHAT_AVAILABILITY.Checking do
				wait(1)
				self.available = service:GetVoiceChatAvailable()
			end
		end
	end

	if not service then
		return false
	end

	return MIN_VOICE_CHAT_API_VERSION <= self.version and self.available == VOICE_CHAT_AVAILABILITY.Available
end

function VoiceChatServiceManager:VoiceChatEnded(): boolean
	if not self.service then
		return true
	end

	local voiceChatState = self.service.VoiceChatState

	if defineFastFlag6 then
		return voiceChatState == Enum.VoiceChatState.Ended
	end

	return voiceChatState == Enum.VoiceChatState.Ended or voiceChatState == Enum.VoiceChatState.Idle
end

function VoiceChatServiceManager:UnmountPrompt()
	if self.voiceChatPromptInstance ~= nil then
		Roact.unmount(self.voiceChatPromptInstance)
		self.voiceChatPromptInstance = nil
	end
end

VoiceChatServiceManager.default = VoiceChatServiceManager.new(
	CoreVoiceManager.default,
	nil,
	HttpRbxApiService,
	permissionsProtocol.default,
	BlockingUtility:GetAfterBlockedStatusChangedEvent()
)

return VoiceChatServiceManager
