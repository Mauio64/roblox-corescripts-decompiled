local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local VoiceChatService = game:GetService("VoiceChatService")
local Promise = require(CorePackages.Packages.Promise)
local Roact = require(CorePackages.Packages.Roact)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local NotificationService = game:GetService("NotificationService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppStorageService = game:GetService("AppStorageService")
local SocialUpsell = require(CorePackages.Workspace.Packages.SocialUpsell)
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local v18 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local default2 = require(CorePackages.Workspace.Packages.VoiceChat).GlobalVoiceManager.default
local GetFFlagDisableConsentModalForExistingUsers = require(script.Parent.Flags.GetFFlagDisableConsentModalForExistingUsers)
local GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses = require(script.Parent.Flags.GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses)
local GetFFlagUpdateVoiceConnectionToasts = require(script.Parent.Flags.GetFFlagUpdateVoiceConnectionToasts)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableVoicePromptReasonText = require(RobloxGui.Modules.Flags.GetFFlagEnableVoicePromptReasonText)
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local GetFFlagVoiceChatServiceManagerUseAvatarChat = VoiceChatCore.Flags.GetFFlagVoiceChatServiceManagerUseAvatarChat
local GetFFlagNonVoiceFTUX = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagNonVoiceFTUX
local GetFFlagJoinWithoutMicPermissions = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagJoinWithoutMicPermissions
local GetFIntVoiceReverseNudgeUXDisplayTimeSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceReverseNudgeUXDisplayTimeSeconds)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFFlagEnableSeamlessVoiceDataConsentToast = require(RobloxGui.Modules.Flags.GetFFlagEnableSeamlessVoiceDataConsentToast)
local GetFFlagSeamlessVoiceConsentToastPolicy = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagSeamlessVoiceConsentToastPolicy
local GetFFlagEnableFtuxExitOnMuteToggle = VoiceChatCore.Flags.GetFFlagEnableFtuxExitOnMuteToggle
local GetFFlagEnableVoiceChatMuteForVideoCaptures = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVoiceChatMuteForVideoCaptures
local GetFFlagEnableCrossExperienceVoiceCaptureMute = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExperienceVoiceCaptureMute
local GetFFlagExpChatUseVoiceParticipantsStore = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagExpChatUseVoiceParticipantsStore
local GetFFlagEnableVoiceUxUpdates = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVoiceUxUpdates
local GetFFlagEnableVoiceTrustedConnectionsToasts = require(script.Parent.Flags.GetFFlagEnableVoiceTrustedConnectionsToasts)
local v41 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDebugShowAudioDeviceInputDebugger()
local GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 = require(script.Parent.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2)
local VoiceNudgeUseNewDACopy = require(script.Parent.Helpers.VoiceNudgeUseNewDACopy)
local v44 = game:DefineFastFlag("DebugSkipVoicePermissionCheck", false)
local v45 = game:DefineFastFlag("DebugSimulateConnectDisconnect", false)
local v46 = game:DefineFastFlag("DebugSkipSeamlessVoiceAPICheck", false)
local v47 = game:DefineFastFlag("FixSTUXShowingIncorrectly", false)
local v48 = game:DefineFastFlag("SendUserConnectionStatus", false)
local v49 = game:DefineFastInt("DebugConnectDisconnectInterval", 15)
local v50 = game:DefineFastFlag("SeamlessVoiceV2JoinVoiceToast", false)
local v51 = game:DefineFastFlag("DisablePermissionPromptDeeplink", false)
local v52 = game:DefineFastFlag("VoiceEndedCheckDisregardIdleState", false)
local v53 = game:DefineFastFlag("DisableLeaveToastInStudio", false)
local v54 = game:DefineFastFlag("EnableVerifiedCheckViaOverlay", false)
local GetFIntThrottleParticipantsUpdateMs = VoiceChatCore.Flags.GetFIntThrottleParticipantsUpdateMs
local GetFFlagEnableConnectDisconnectInSettingsAndChrome = require(RobloxGui.Modules.Flags.GetFFlagEnableConnectDisconnectInSettingsAndChrome)
local v57 = game:DefineFastString("VoiceUIImprovementsIXPLayerName", "Voice.Exposure")
local v58 = game:DefineFastString("ThrottleParticipantsUpdateIXPLayerValue", "ThrottleParticipantsUpdate")
local v59 = game:DefineFastFlag("VoiceVolumeControlsGlobalVoiceVolumeSliderIxpExposure", false)
local v60 = game:DefineFastString("VoiceVolumeControlsGlobalVoiceVolumeSliderIxpLayer", "Voice.VolumeControls")
local v61 = game:DefineFastInt("SeamlessVoiceSTUXDisplayCount", 3)
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local GetFFlagShowDevicePermissionsModal = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagShowDevicePermissionsModal
local FFlagEnableRetryForLinkingProtocolFetch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableRetryForLinkingProtocolFetch
local v65 = game:DefineFastFlag("ShowJoinVoiceWhenDisconnectedV3", false)
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(script.Parent.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)
local FFlagVoiceRewarmTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagVoiceRewarmTelemetry
local v69 = game:DefineFastFlag("GuardVoiceInExpUpsellVariant", false)
local _ = {
	FAE_UPSELL = "FaeUpsell",
	VOICE_FTUX = "VoiceFtux",
	REWARM = "Rewarm"
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
local GetFFlagIntegratePhoneUpsellJoinVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIntegratePhoneUpsellJoinVoice
local GetFFlagInExperiencePhoneUpsellNewCopy = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagInExperiencePhoneUpsellNewCopy
local GetFFlagCheckUniversePlaceBeforeSuspending = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagCheckUniversePlaceBeforeSuspending
local FIntLinkingProtocolFetchRetries = require(CorePackages.Workspace.Packages.SharedFlags).FIntLinkingProtocolFetchRetries
local FIntLinkingProtocolFetchTimeoutMS = require(CorePackages.Workspace.Packages.SharedFlags).FIntLinkingProtocolFetchTimeoutMS
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)
local Constants = VoiceChat.Constants
local PostRecordUserSeenGeneralModal = VoiceChat.AgeVerificationOverlay.PostRecordUserSeenGeneralModal
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local VoiceChatPrompt = require(RobloxGui.Modules.VoiceChatPrompt.Components.VoiceChatPrompt)
local AudioDeviceInputDebugger = require(RobloxGui.Modules.VoiceChat.Components.AudioDeviceInputDebugger)
local PromptType = require(RobloxGui.Modules.VoiceChatPrompt.PromptType)
local GetUserSettings = VoiceChat.GetUserSettings
local GetInformedOfBan = VoiceChat.GetInformedOfBan
local PostInformedOfBan = VoiceChat.PostInformedOfBan
local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local BAN_REASON = Constants2.BAN_REASON
local SeamlessVoiceStatus = require(RobloxGui.Modules.Settings.Enum.SeamlessVoiceStatus)
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local GetFFlagVoiceChatClientRewriteMasterLua = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagVoiceChatClientRewriteMasterLua
local GetFFlagEnableSeamlessVoiceV2 = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableSeamlessVoiceV2
local GetFFlagDisconnectToastClientRewrite = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagDisconnectToastClientRewrite
local GetFFlagEnableVrVoiceParity = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableVrVoiceParity
local Analytics = VoiceChatCore.Analytics
local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local MicrophoneDevicePermissionsLogging = require(RobloxGui.Modules.Settings.Resources.MicrophoneDevicePermissionsLogging)
local v100 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local v101 = if not GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local default3 = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol.default
local SettingsRoute = require(CorePackages.Workspace.Packages.LinkingProtocol).Enums.SettingsRoute
local v105 = if not GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then nil else require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneUpsellController
local v106 = if not GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then nil else require(CorePackages.Workspace.Packages.PhoneUpsell).Http.Requests.PostPhoneUpsellDisplayed
local CoreVoiceManager = VoiceChatCore.CoreVoiceManager
local Constants3 = VoiceChatCore.Constants
local getOverlayStore = SocialUpsell.Overlay.getOverlayStore
local OverlayTypes = SocialUpsell.Overlay.OverlayTypes
local SocialUpsellType = SocialUpsell.Enum.SocialUpsellType
local Enum2 = SocialUpsell.Analytics.Enum
local SocialExperiments = require(CorePackages.Workspace.Packages.SocialExperiments)
local FFlagTestDeviceForFAEUpsell = SocialExperiments.FFlagTestDeviceForFAEUpsell
local deviceMeetsRequirementsForFAE = SocialExperiments.deviceMeetsRequirementsForFAE
local EngineFeature2 = game:GetEngineFeature("EnableMutedByLocalUser")
local FFlagEnablePartyVoiceChangersInLua = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePartyVoiceChangersInLua
local VoiceVolumeControlsEligibility = VoiceChatCore.VoiceVolumeControlsEligibility
local VOICE_STATE = Constants.VOICE_STATE
local VOICE_CHAT_DEVICE_TYPE = Constants.VOICE_CHAT_DEVICE_TYPE
local VOICE_CHAT_AVAILABILITY = Constants.VOICE_CHAT_AVAILABILITY
local MIN_VOICE_CHAT_API_VERSION = Constants.MIN_VOICE_CHAT_API_VERSION
local WATCHED_MESSAGE_TYPES = Constants.WATCHED_MESSAGE_TYPES
local PERMISSION_STATE = Constants.PERMISSION_STATE
local VOICE_JOIN_PROGRESS = Constants3.VOICE_JOIN_PROGRESS
local t1 = {
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
	PermissionsService = PermissionsProtocol.default,
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
	VOICE_STATE = VOICE_STATE,
	permissionState = if not GetFFlagJoinWithoutMicPermissions() then nil else PERMISSION_STATE.IDLE,
	isBanned = false,
	bannedUntil = nil,
	errorText = nil,
	BlockStatusChanged = nil,
	isInCall = false,
	callMutedState = false,
	banReason = nil,
	_mutedAnyone = false,
	VOICE_CHAT_DEVICE_TYPE = VOICE_CHAT_DEVICE_TYPE,
	getPermissionsFunction = getCamMicPermissions,
	AvatarChatService = v100,
	inExpUpsellEntrypoint = nil,
	seamlessVoiceStatus = nil,
	isShowingFTUX = false,
	hideFTUXSignal = Instance.new("BindableEvent"),
	settingsAppAvailable = nil,
	hasLeftFTUX = false,
	deniedMicPermissions = nil,
	isInitialJoin = false,
	joinVoiceButtonContext = nil,
	pendingConnectionSource = nil,
	joinVoiceButtonConsequence = nil,
	CaptureService = v101
}
local v127 = LuauPolyfill.Set.new({
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

v127:add("_mutedAnyone")
v127:add("muteAllChanged")

local t2 = {}
local t3 = {
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT1] = PromptType.VoiceConsentModalV1,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT2] = PromptType.VoiceConsentModalV2,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3] = PromptType.VoiceConsentModalV3
}

function getIconSrc(p1, p2) -- line: 354
	return "rbxasset://textures/ui/VoiceChat/" .. (p2 and p2 .. "/" or "") .. p1 .. ".png"
end
function getIcon(p3, p4, p5) -- line: 359
	-- upvalues: VOICE_STATE (copy)
	if p3 == VOICE_STATE.MUTED then
		return getIconSrc("Muted", p5)
	end

	if p3 == VOICE_STATE.CONNECTING then
		return getIconSrc("Connecting", p5)
	end

	if p3 == VOICE_STATE.INACTIVE then
		return getIconSrc("Blank", p5)
	end

	if p3 == VOICE_STATE.TALKING then
		local v137 = math.floor(0.5 + 5 * (p4 or math.random())) * 20

		return p4 and getIconSrc("Unmuted" .. tostring(v137), p5) or getIconSrc("Blank", p5)
	end

	return getIconSrc("Error", p5)
end

t1.__index = t1

function t1.__index(p6, p7) -- line: 377
	-- upvalues: v127 (copy), t1 (copy)
	if v127:has(p7) then
		return p6.coreVoiceManager[p7]
	end

	return (rawget(t1, p7))
end
function t1.__newindex(p8, p9, p10) -- line: 384
	-- upvalues: v127 (copy), t1 (copy)
	if v127:has(p9) then
		p8.coreVoiceManager[p9] = p10

		return
	end

	rawset(t1, p9, p10)
end
function t1.new(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- line: 392
	-- upvalues: Analytics (copy), getCamMicPermissions (copy), t1 (copy), WATCHED_MESSAGE_TYPES (copy), GetFIntThrottleParticipantsUpdateMs (copy), IXPServiceWrapper (copy), v57 (copy), v58 (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), ExpChat (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v44 (copy), v41 (copy), FFlagEnablePartyVoiceChangersInLua (copy), MicrophoneDevicePermissionsLogging (copy), v59 (copy), VoiceVolumeControlsEligibility (copy), v60 (copy), VOICE_JOIN_PROGRESS (copy), Constants2 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), v53 (copy), PromptType (copy), v45 (copy), v18 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), AppStorageService (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagShowDevicePermissionsModal (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), GetFFlagNonVoiceFTUX (copy), GetFFlagUpdateVoiceConnectionToasts (copy), v50 (copy), GetFFlagEnableVoiceChatMuteForVideoCaptures (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), default2 (copy)
	local v153 = setmetatable({
		_mutedAnyone = false,
		voiceConnectEventReportedForActiveSession = false,
		service = p12,
		HttpRbxApiService = p13,
		NotificationService = p17,
		PermissionsService = p14,
		BlockStatusChanged = p15,
		Analytics = Analytics.new(p16),
		getPermissionsFunction = p18 or getCamMicPermissions,
		AvatarChatService = p19,
		SequenceNumbers = {},
		SignalREventTable = {},
		coreVoiceManager = p11,
		CaptureService = p20
	}, t1)

	for _, v155 in WATCHED_MESSAGE_TYPES do
		v153.SignalREventTable[v155] = Instance.new("BindableEvent")
	end

	v153.shouldThrottleParticipantUpdate = false
	v153.participantsStateThrottleTime = 0
	v153.lastParticipantsStateUpdate = 0
	v153.lastStateUpdateCounter = 0
	v153.reverseNudgeToxicUserRemovalCallbacks = {}

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		v153.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000

		local ok, result = pcall(function() -- line: 433
			-- upvalues: IXPServiceWrapper (copy), v57 (copy)
			return IXPServiceWrapper:GetLayerData(v57)
		end)

		if ok and result and result[v58] then
			v153.shouldThrottleParticipantUpdate = true
		end
	end

	v153.MuteStatusIcons = {
		MicOn = v153:GetIcon("Unmuted0", "SpeakerLight"),
		MicOff = v153:GetIcon("Muted", "SpeakerLight"),
		MicDisabled = v153:GetIcon("Muted", "SpeakerLight"),
		Loading = v153:GetIcon("Connecting", "SpeakerLight"),
		Error = v153:GetIcon("Error", "SpeakerLight")
	}
	v153.PlayerMuteStatusIcons = {
		MicOn = v153:GetIcon("Unmuted0", "MicLight"),
		MicOff = v153:GetIcon("Muted", "MicLight"),
		MicDisabled = v153:GetIcon("Muted", "MicLight"),
		Loading = v153:GetIcon("Connecting", "MicLight"),
		Error = v153:GetIcon("Error", "MicLight")
	}

	local u158 = false
	local connection = v153.attemptVoiceRejoin.Event:Connect(function() -- line: 459
		-- upvalues: u158 (ref)
		u158 = true
	end)
	local v160 = if not GetFFlagExpChatUseVoiceParticipantsStore() then nil else ExpChat.Stores.GetVoiceStore(false)

	v153.coreVoiceManager:subscribe("GetPermissions", function(p21, p22, p23, p24) -- line: 466
		-- upvalues: v153 (copy)
		local s1 = "VoiceChatServiceManager.requestMicPermission"

		if v153.inExpUpsellEntrypoint ~= nil then
			s1 = v153.inExpUpsellEntrypoint
		end

		v153.getPermissionsFunction(p21, p22, p23, s1, p24)
	end)
	v153.coreVoiceManager:subscribe("OnVoiceParticipantRemoved", function(p25) -- line: 473
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v160 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v160.handleVoiceParticipantRemoved(p25)

			return
		end

		if ExpChat.Events.VoiceParticipantRemoved then
			ExpChat.Events.VoiceParticipantRemoved((tostring(p25)))
		end
	end)
	v153.coreVoiceManager:subscribe("OnVoiceParticipantAdded", function(p26) -- line: 480
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v160 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v160.handleVoiceParticipantAdded(p26)

			return
		end

		if ExpChat.Events.VoiceParticipantAdded then
			ExpChat.Events.VoiceParticipantAdded((tostring(p26)))
		end
	end)
	v153.coreVoiceManager:subscribe("OnVoiceParticipantToggleMuted", function(p27, p28) -- line: 487
		-- upvalues: ExpChat (copy)
		if ExpChat.Events.VoiceParticipantToggleMuted then
			ExpChat.Events.VoiceParticipantToggleMuted(tostring(p27), p28)
		end
	end)
	v153.coreVoiceManager:subscribe("OnUserAndPlaceCanUseVoiceResolved", function(p29, p30) -- line: 492
		-- upvalues: v153 (copy)
		v153:_onUserAndPlaceCanUseVoiceResolved(p29, p30)
	end)
	v153.coreVoiceManager:subscribe("OnRequestMicPermissionResolved", function() -- line: 495
		-- upvalues: GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v153 (copy)
		if GetFFlagEnableUniveralVoiceToasts() then
			if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
				return v153:CheckAndShowNotAudiblePrompt():andThen(function() -- line: 498
					-- upvalues: v153 (copy)
					return v153:ShowNotAudiblePromptVoiceChatVolume()
				end)
			end

			return v153:CheckAndShowNotAudiblePrompt()
		end
	end)
	v153.coreVoiceManager:subscribe("OnRequestMicPermissionRejected", function() -- line: 506
		-- upvalues: GetFFlagEnableSeamlessVoiceV2 (copy), v153 (copy), GetFFlagEnableUniveralVoiceToasts (copy), v44 (copy)
		if GetFFlagEnableSeamlessVoiceV2() and v153:IsSeamlessVoice() then
			v153.deniedMicPermissions = true
		end

		if GetFFlagEnableUniveralVoiceToasts() and not v44 then
			return v153:CheckAndShowPermissionPrompt()
		end
	end)

	if v41 then
		v153.coreVoiceManager:subscribe("OnDevicePlayerChanged", function() -- line: 517
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
		v153.coreVoiceManager:subscribe("OnDeviceActiveChanged", function() -- line: 520
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
		v153.coreVoiceManager:subscribe("OnDeviceMuteChanged", function() -- line: 523
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)

		if FFlagEnablePartyVoiceChangersInLua then
			v153.coreVoiceManager:subscribe("OnVoiceChangerChanged", function() -- line: 527
				-- upvalues: v153 (copy)
				v153:UpdateAudioDeviceInputDebugger()
			end)
		end

		v153.coreVoiceManager:subscribe("OnPlayerMuted", function() -- line: 531
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
		v153.coreVoiceManager:subscribe("OnAudioDeviceInputAdded", function() -- line: 534
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
		v153.coreVoiceManager:subscribe("OnAudioDeviceInputRemoved", function() -- line: 537
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
		v153.coreVoiceManager:subscribe("OnDeviceMutedByLocalUserChanged", function() -- line: 540
			-- upvalues: v153 (copy)
			v153:UpdateAudioDeviceInputDebugger()
		end)
	end

	v153.coreVoiceManager:subscribe("OnStateChanged", function(_, p32) -- line: 544
		-- upvalues: MicrophoneDevicePermissionsLogging (copy), v153 (copy), v59 (copy), VoiceVolumeControlsEligibility (copy), IXPServiceWrapper (copy), v60 (copy), VOICE_JOIN_PROGRESS (copy), Constants2 (copy), u158 (ref), connection (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), v53 (copy), PromptType (copy)
		MicrophoneDevicePermissionsLogging:setClientSessionId(v153.coreVoiceManager:GetSessionId())

		if p32 == Enum.VoiceChatState.Ended or p32 == Enum.VoiceChatState.Failed then
			v153.voiceConnectEventReportedForActiveSession = false
		end

		if p32 == Enum.VoiceChatState.Joined and v59 and VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, game:GetService("VoiceChatService").UseNewAudioApi) then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v60)
		end

		if p32 == Enum.VoiceChatState.Joined and v153:GetVoiceJoinProgress() == VOICE_JOIN_PROGRESS.Idle and not v153.voiceConnectEventReportedForActiveSession then
			local ConnectDisconnectAnalyticsData = v153:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = Constants2.VOICE_CONNECTION_SOURCE.AUTO_CONNECT
			v153.pendingConnectionSource = nil
			v153.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			v153.voiceConnectEventReportedForActiveSession = true
			u158 = false
			connection:Disconnect()
		end

		local v456 = p32 == Enum.VoiceChatState.Ended

		if v456 then
			local ConnectDisconnectAnalyticsData = v153:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.disconnectReason = v153.pendingDisconnectReason or Constants2.VOICE_DISCONNECT_REASON.SYSTEM
			v153.Analytics:reportConnectDisconnectEvents("voiceDisconnectReasonEvent", ConnectDisconnectAnalyticsData)
			v153.pendingDisconnectReason = nil
		end

		if v456 and v153.bannedUntil == nil then
			if not GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
				v153:HideVoiceUI()
			end

			if v53 and v153.runService:IsStudio() then
				return
			end

			v153:showPrompt(PromptType.LeaveVoice)
		end
	end)
	v153.coreVoiceManager:subscribe("OnVoiceChatServiceInitialized", function() -- line: 595
		-- upvalues: v153 (copy), v45 (copy), v18 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), AppStorageService (copy), Constants2 (copy), PromptType (copy)
		v153:ShowVoiceUI()

		if v45 then
			v18:debug("Simulating join voice")
			v153:simulateVoiceConnectDisconnect()
		end

		if GetFFlagEnableVoiceTrustedConnectionsToasts() and not v153.coreVoiceManager.initializedPostSuspension then
			local ok, result = pcall(function() -- line: 603
				-- upvalues: AppStorageService (copy), Constants2 (copy)
				return AppStorageService:GetItem(Constants2.VOICE_WITH_TC_TOAST_KEY) == "true"
			end)

			if ok and not result then
				v153:showPrompt(PromptType.UpdateOnAutoJoinToast)
				pcall(function() -- line: 610
					-- upvalues: AppStorageService (copy), Constants2 (copy)
					AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
					AppStorageService:Flush()
				end)
			end
		end
	end)
	v153.coreVoiceManager:subscribe("OnInitialJoinFailed", function() -- line: 618
		-- upvalues: v153 (copy)
		v153:InitialJoinFailedPrompt()
	end)
	v153.coreVoiceManager:subscribe("OnPlayerModerated", function() -- line: 621
		-- upvalues: v153 (copy), Constants2 (copy)
		v153.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.MODERATED
		v153:ShowPlayerModeratedMessage()
	end)
	v153.coreVoiceManager:subscribe("OnRetryRequested", function() -- line: 626
		-- upvalues: v153 (copy), PromptType (copy)
		v153:showPrompt(PromptType.Retry)
	end)
	v153.coreVoiceManager:subscribe("OnVoiceToxicityModal", function() -- line: 629
		-- upvalues: v18 (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v153 (copy), PromptType (copy)
		v18:debug("Showing Voice Toxicity Modal")

		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			v153:showPrompt(PromptType.VoiceToxicityModalV2)

			return
		end

		v153:showPrompt(PromptType.VoiceToxicityModal)
	end)
	v153.coreVoiceManager:subscribe("OnVoiceToxicityToast", function() -- line: 637
		-- upvalues: v18 (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v153 (copy), PromptType (copy)
		v18:debug("Showing Voice Toxicity Toast")

		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			v153:showPrompt(PromptType.VoiceToxicityToastV2)

			return
		end

		v153:showPrompt(PromptType.VoiceToxicityToast)
	end)
	v153.coreVoiceManager:subscribe("OnPermissionRequested", function() -- line: 645
		-- upvalues: GetFFlagShowDevicePermissionsModal (copy), v153 (copy), PromptType (copy)
		if GetFFlagShowDevicePermissionsModal() then
			v153:showPrompt(PromptType.DevicePermissionsModal)

			return
		end

		v153:showPrompt(PromptType.Permission)
	end)
	v153.coreVoiceManager:subscribe("OnShowDataConsentToast", function() -- line: 652
		-- upvalues: GetFFlagEnableSeamlessVoiceDataConsentToast (copy), v153 (copy)
		if GetFFlagEnableSeamlessVoiceDataConsentToast() then
			v153:showDataConsentToast()
		end
	end)
	v153.coreVoiceManager:subscribe("OnVoiceReverseNudgeIconColorChange", function(p33) -- line: 657
		-- upvalues: v18 (copy), ExpChat (copy), v153 (copy)
		v18:debug("Showing Reverse Nudge Icon Color Change")

		if ExpChat.Events.AddReverseNudgeToxicUser and ExpChat.Events.RemoveReverseNudgeToxicUser then
			v153:AddReverseNudgeToxicUser(p33.toxicUserId, ExpChat.Events.AddReverseNudgeToxicUser, ExpChat.Events.RemoveReverseNudgeToxicUser)
		end
	end)
	v153.coreVoiceManager.setVoiceUIVisibility.Event:Connect(function(b1: boolean) -- line: 667
		-- upvalues: v153 (copy)
		if b1 then
			v153:ShowVoiceUI()

			return
		end

		v153:HideVoiceUI()
	end)
	v153.coreVoiceManager:subscribe("OnVoiceJoin", function() -- line: 674
		-- upvalues: GetFFlagNonVoiceFTUX (copy), v153 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), GetFFlagUpdateVoiceConnectionToasts (copy), PromptType (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v50 (copy), GetFFlagEnableVoiceChatMuteForVideoCaptures (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), default2 (copy), u158 (ref), connection (copy)
		if GetFFlagNonVoiceFTUX() and v153.hasLeftFTUX then
			v153.hasLeftFTUX = false

			if GetFFlagEnableVoiceTrustedConnectionsToasts() then
				v153:showJoinVoicePrompt()
			elseif GetFFlagUpdateVoiceConnectionToasts() then
				v153:showPrompt(PromptType.UnifiedJoinVoiceToast)
			else
				v153:showPrompt(PromptType.JoinedVoiceToast)
			end

			v153.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxLeaveEvent", v153:GetConnectDisconnectAnalyticsData())
		elseif GetFFlagEnableSeamlessVoiceV2() and v153:IsSeamlessVoice() then
			if GetFFlagEnableVoiceTrustedConnectionsToasts() then
				v153:showJoinVoicePrompt()
			elseif GetFFlagUpdateVoiceConnectionToasts() then
				v153:showPrompt(PromptType.UnifiedJoinVoiceToast)
			elseif v50 and v153.isInitialJoin then
				v153:showPrompt(PromptType.JoinedVoiceToast)
			else
				v153:showPrompt(PromptType.JoinVoice)
			end

			v153:SetVoiceConnectCookieValue(true)
		else
			v153:showPrompt(PromptType.VoiceConsentAcceptedToast)
		end

		if GetFFlagEnableVoiceChatMuteForVideoCaptures() and v153.CaptureService:IsCapturingVideo() then
			if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
				default2:MuteAll("Capture")
				v153:HideVoiceUI()
			else
				v153:MuteAll(true, "Capture")
				v153:HideVoiceUI()
			end
		end

		if u158 then
			local ConnectDisconnectAnalyticsData = v153:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = v153.pendingConnectionSource
			v153.pendingConnectionSource = nil
			v153.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			v153.voiceConnectEventReportedForActiveSession = true
			u158 = false
			connection:Disconnect()
		end
	end)

	return v153
end

local function shorten(p34) -- line: 730
	return "..." .. string.sub(tostring(p34), -4)
end
local function bind(p35, p36) -- line: 734
	return function(...) -- line: 735
		-- upvalues: p35 (copy), p36 (copy)
		return p35[p36](p35, ...)
	end
end

function t1.subscribe(p37, p38, p39) -- line: 740
	return p37.coreVoiceManager:subscribe(p38, p39)
end
function t1.unsubscribe(p40, p41, p42) -- line: 744
	p40.coreVoiceManager:unsubscribe(p41, p42)
end
function t1._reportJoinFailed(p43, p44, p45) -- line: 748
	return p43.coreVoiceManager:_reportJoinFailed(p44, p45)
end
function t1._asyncInit(p46) -- line: 752
	return p46.coreVoiceManager:_asyncInit()
end
function t1.asyncInit(p47) -- line: 756
	return p47.coreVoiceManager:asyncInit()
end
function t1.CheckAudioInputExists(p48) -- line: 760
	return p48.coreVoiceManager:CheckAudioInputExists()
end
function t1.getService(p49) -- line: 764
	return p49.service
end
function t1.GetMutedAnyone(p50) -- line: 768
	return p50.coreVoiceManager:GetMutedAnyone()
end
function t1.RecordGameSettingsOpened(p51) -- line: 772
	p51.coreVoiceManager:RecordGameSettingsOpened()
end
function t1.ReportVoiceVolumeImpressionsIfNeeded(p52) -- line: 776
	p52.coreVoiceManager:ReportVoiceVolumeImpressionsIfNeeded()
end
function t1.GetRequest(p53, p54, p55) -- line: 780
	return p53.coreVoiceManager:GetRequest(p54, p55)
end
function t1.PostRequest(p56, p57, _, p59) -- line: 784
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 785
		-- upvalues: p56 (copy), p57 (copy), p59 (copy), HttpService (copy)
		local v463 = p56.HttpRbxApiService:PostAsyncFullUrl(p57, p59, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(v463)
	end)

	return ok and result
end
function t1._GetShowAgeVerificationOverlay(p60, p61) -- line: 806
	return p60.coreVoiceManager:_GetShowAgeVerificationOverlay(p61)
end
function t1.simulateVoiceConnectDisconnect(p62) -- line: 810
	-- upvalues: v49 (copy), v18 (copy)
	task.spawn(function() -- line: 811
		-- upvalues: v49 (copy), p62 (copy), v18 (copy)
		while true do
			task.wait(v49)

			if p62.voiceUIVisible then
				v18:debug("Hiding Voice")
				p62:HideVoiceUI()
			else
				v18:debug("Showing Voice")
				p62:ShowVoiceUI()
			end
		end
	end)
end
function t1.FetchAgeVerificationOverlay(p63, p64) -- line: 825
	return p63.coreVoiceManager:FetchAgeVerificationOverlay(p64)
end
function t1.FetchPhoneVerificationUpsell(t4: {[any]: any}, s2: string, n1: number?, b2: boolean?) -- line: 829
	return t4.coreVoiceManager:FetchPhoneVerificationUpsell(s2, n1, b2)
end
function t1.RecordUserSeenModal(t5: {[any]: any}, s3: string) -- line: 837
	-- upvalues: PostRecordUserSeenGeneralModal (copy)
	local s4 = "PostRequest"

	return PostRecordUserSeenGeneralModal(function(...) -- line: 735
		-- upvalues: t5 (copy), s4 (copy)
		return t5[s4](t5, ...)
	end, s3)
end
function t1.checkAndUpdateSequence(t6: {[any]: any}, s5: string, n2: number) -- line: 841
	return t6.coreVoiceManager:checkAndUpdateSequence(s5, n2)
end
function t1.onMissedSequence(p65, p66) -- line: 845
	return p65.coreVoiceManager:onMissedSequence(p66)
end
function t1.watchSignalR(p67) -- line: 849
	return p67.coreVoiceManager:watchSignalR()
end
function t1.voicePermissionGranted(p68, p69) -- line: 857
	return p68.coreVoiceManager:voicePermissionGranted(p69)
end
function t1.GetSignalREvent(p70, p71) -- line: 861
	return p70.coreVoiceManager:GetSignalREvent(p71)
end
function t1.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p72, p73) -- line: 866
	return p72.coreVoiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p73)
end
function t1.resolveAvatarChatUserAndPlaceSettings(p74) -- line: 870
	return p74.coreVoiceManager:resolveAvatarChatUserAndPlaceSettings()
end
function t1.EnableVoice(p75) -- line: 874
	return p75.coreVoiceManager:EnableVoice()
end
function t1._VoiceChatFirstTimeUX(t7: {[any]: any}, p76) -- line: 878
	-- upvalues: Constants2 (copy), v18 (copy), GetFFlagNonVoiceFTUX (copy), ExpChat (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), v61 (copy), v47 (copy), PromptType (copy)
	local u217 = nil
	local u218 = nil

	if not pcall(function() -- line: 880
		-- upvalues: p76 (copy), Constants2 (copy), u217 (ref), u218 (ref)
		local Item = p76:GetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY)
		local Item2 = p76:GetItem(Constants2.SEAMLESS_VOICE_STUX_KEY)

		u217 = Item == "true"
		u218 = if Item2 ~= nil then tonumber(Item2) else 0
	end) then
		v18:warning("Failed to read FTUX/STUX from AppStorage")

		return
	end

	v18:trace("hasShownFTUX: {}. STUXCount: {}", u217, u218)

	if not u217 then
		v18:debug("Showing FTUX")
		t7.isShowingFTUX = true
		t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxJoinEvent", t7:GetConnectDisconnectAnalyticsData())

		if GetFFlagNonVoiceFTUX() then
			ExpChat.Events.VoiceUIVisibilityChanged(true)
		else
			t7:MuteAll(true, "FTUX")
			t7.muteAllChanged.Event:Once(function() -- line: 906
				-- upvalues: t7 (copy), p76 (copy)
				t7:HideFTUX(p76)
				t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxLeaveEvent", t7:GetConnectDisconnectAnalyticsData())
			end)
			t7.talkingChanged.Event:Once(function() -- line: 913
				-- upvalues: t7 (copy), p76 (copy)
				t7:HideFTUX(p76)
			end)

			if GetFFlagEnableFtuxExitOnMuteToggle() then
				t7.coreVoiceManager.onPlayerMuteToggled.Event:Once(function() -- line: 917
					-- upvalues: t7 (copy), p76 (copy)
					t7:HideFTUX(p76)
				end)
			end
		end
	elseif u218 < v61 and (not v47 or t7:GetVoiceConnectCookieValue()) then
		v18:debug("Showing STUX")
		t7:showPrompt(PromptType.JoinVoiceSTUX)
		pcall(function() -- line: 928
			-- upvalues: p76 (copy), Constants2 (copy), u218 (ref)
			p76:SetItem(Constants2.SEAMLESS_VOICE_STUX_KEY, (tostring(u218 + 1)))
			p76:Flush()
		end)
	end
end
function t1.VoiceChatFirstTimeUX(t8: {[any]: any}, p77) -- line: 935
	-- upvalues: v47 (copy), v18 (copy), v46 (copy), Constants2 (copy), GetFFlagNonVoiceFTUX (copy)
	if v47 and not t8:verifyUniverseAndPlaceCanUseVoice() then
		v18:debug("Universe/place is not voice enabled, do not run FTUX/STUX")

		return
	end

	if not v46 then
		local v221 = t8:FetchAgeVerificationOverlay()

		if type(v221) == "table" and v221.voiceSettings and v221.voiceSettings.seamlessVoiceStatus ~= Constants2.SEAMLESS_VOICE_STATUS_ENABLED_NEW_USER then
			v18:debug("User not eligible for FTUX/STUX")

			return
		end
	end

	local function startFTUX() -- line: 955
		-- upvalues: v18 (copy), t8 (copy), p77 (copy)
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p77)
	end

	if GetFFlagNonVoiceFTUX() then
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p77)

		return
	end

	t8:asyncInit():andThen(function() -- line: 963
		-- upvalues: t8 (copy), v18 (copy), p77 (copy)
		local connection = nil

		if t8.service.VoiceChatState and t8.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v18:debug("Starting FTUX")
			t8:_VoiceChatFirstTimeUX(p77)
		end

		connection = t8.service.StateChanged:Connect(function(_, newState) -- line: 971
			-- upvalues: v18 (copy), t8 (copy), p77 (copy), connection (ref)
			if newState == Enum.VoiceChatState.Joined then
				v18:debug("Starting FTUX")
				t8:_VoiceChatFirstTimeUX(p77)
				connection:Disconnect()
			end
		end)
	end):catch(function(p79) -- line: 978
		-- upvalues: v18 (copy)
		v18:trace("Failed to start FTUX: {}", p79)
	end)
end
function t1.HideFTUX(t9: {[any]: any}, p80) -- line: 984
	-- upvalues: Constants2 (copy), GetFFlagNonVoiceFTUX (copy), PromptType (copy)
	t9.isShowingFTUX = false
	t9.hideFTUXSignal:Fire()
	pcall(function() -- line: 987
		-- upvalues: p80 (copy), Constants2 (copy)
		p80:SetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY, "true")
		p80:Flush()
	end)

	if GetFFlagNonVoiceFTUX() then
		t9.hasLeftFTUX = true
		t9.attemptVoiceRejoin:Fire()
	end

	if not GetFFlagNonVoiceFTUX() then
		t9:MuteAll(false, "FTUX")
		t9:showPrompt(PromptType.JoinedVoiceToast)
	end
end
function t1._onUserAndPlaceCanUseVoiceResolved(p81, p82, p83) -- line: 1001
	-- upvalues: GetInformedOfBan (copy), GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagEnableVoicePromptReasonText (copy)
	p81.bannedUntil = nil

	if p82 and p82.isBanned then
		local s6 = "GetRequest"
		local v229 = GetInformedOfBan(function(...) -- line: 735
			-- upvalues: p81 (copy), s6 (copy)
			return p81[s6](p81, ...)
		end)

		if v229 and not v229.informedOfBan then
			if GetFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() and p82.bannedUntil == nil then
				p81:ShowPlayerModeratedMessage()
			elseif p82.bannedUntil == nil then
				p81:showPrompt(PromptType.VoiceChatSuspendedPermanent)
			else
				p81.bannedUntil = p82.bannedUntil

				if p82.banReason == BAN_REASON.NUDGE_V3 then
					if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
						p81:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)
					else
						p81:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)
					end
				else
					p81:showPrompt(PromptType.VoiceChatSuspendedTemporary)
				end
			end
		end

		if v229 and v229.informedOfBan then
			p81:ShowPlayerModeratedMessage(true)

			return
		end
	else
		if p81.runService:IsStudio() and p82 and not p82.isVoiceEnabled then
			p81:showPrompt(PromptType.User)

			return
		end

		if p81.runService:IsStudio() and p83 and not p83.isPlaceEnabledForVoice then
			p81:showPrompt(PromptType.Place, GetFFlagEnableVoicePromptReasonText() and table.concat(p83.reasons or {}, "") or nil)
		end
	end
end
function t1.ChangeVoiceJoinProgress(p84, p85) -- line: 1049
	return p84.coreVoiceManager:ChangeVoiceJoinProgress(p85)
end
function t1.GetVoiceJoinProgress(p86) -- line: 1053
	return p86.coreVoiceManager.VoiceJoinProgress
end
function t1.UserOnlyEligibleForVoice(p87) -- line: 1057
	return p87.coreVoiceManager:UserOnlyEligibleForVoice()
end
function t1.UserOnlyEligibleForVoiceViaOverlay(p88) -- line: 1061
	return p88.coreVoiceManager:UserOnlyEligibleForVoiceViaOverlay()
end
function t1.UserVoiceEnabled(p89) -- line: 1065
	return p89.coreVoiceManager:UserVoiceEnabled()
end
function t1.UserInInExperienceUpsellTreatment(p90) -- line: 1069
	return p90.coreVoiceManager:UserInInExperienceUpsellTreatment()
end
function t1.UserEligibleForInExperienceUpsell(p91) -- line: 1073
	return p91.coreVoiceManager:UserEligibleForInExperienceUpsell()
end
function t1.ShowInExperienceVoiceUpsell(t10: {[any]: any}, s7: string) -- line: 1078
	-- upvalues: v69 (copy)
	local v240 = t10:FetchAgeVerificationOverlay()

	if v69 and type(v240) ~= "table" then
		return
	end

	local showVoiceInExperienceUpsellVariant = v240.showVoiceInExperienceUpsellVariant

	t10:SetInExpUpsellEntrypoint(s7)
	t10:showPrompt((t10:GetInExpUpsellPromptFromEnum(showVoiceInExperienceUpsellVariant)))
end
function t1.ShowInExperiencePhoneVoiceUpsell(t11: {[any]: any}, s8: string, s9: string) -- line: 1092
	-- upvalues: v105 (copy), GetFFlagInExperiencePhoneUpsellNewCopy (copy), v106 (copy), Constants2 (copy), PromptType (copy)
	t11:SetInExpUpsellEntrypoint(s8)
	v105.openPhoneUpsell({
		origin = "inExperience",
		eventContext = "verificationUpsell",
		entryConfig = {
			titleKey = "Feature.VerificationUpsell.Heading.UnlockVoiceChat",
			descriptionKey = "Feature.VerificationUpsell.Description.UnlockVoiceChatBody",
			legalTextKey = "Feature.VerificationUpsell.Description.VoiceLegalDisclaimer2",
			buttonKey = not GetFFlagInExperiencePhoneUpsellNewCopy() and "Feature.VerificationUpsell.Action.AddPhoneNumber" or "Feature.AccountSettings.Action.Verify",
			extraButtonConfig = {
				extraButtonKey = "Feature.VerificationUpsell.Action.NotNow"
			}
		},
		onSuccessBeforeToast = function() -- line: 1109
			-- upvalues: t11 (copy), v106 (copy), s9 (copy)
			t11.coreVoiceManager:DisablePhoneVerificationUpsell()

			local v468 = v106
			local v469 = t11
			local s10 = "PostRequest"

			v468(function(...) -- line: 735
				-- upvalues: v469 (copy), s10 (copy)
				return v469[s10](v469, ...)
			end, s9, os.time(), false)
		end,
		onSuccess = function() -- line: 1113
			-- upvalues: t11 (copy), Constants2 (copy)
			if t11.pendingConnectionSource == nil then
				t11.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			t11:EnableVoice()
		end,
		closeUpsell = function() -- line: 1119
			-- upvalues: s8 (copy), Constants2 (copy), t11 (copy), PromptType (copy), v106 (copy), s9 (copy)
			if s8 ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				t11:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end

			local v471 = v106
			local v472 = t11
			local s11 = "PostRequest"

			v471(function(...) -- line: 735
				-- upvalues: v472 (copy), s11 (copy)
				return v472[s11](v472, ...)
			end, s9, os.time(), true)
		end
	})
end
function t1.DisablePhoneVerificationUpsell(p92) -- line: 1128
	p92.coreVoiceManager:DisablePhoneVerificationUpsell()
end
function t1.SetInExpUpsellEntrypoint(t12: {[any]: any}, s12: string) -- line: 1132
	t12.inExpUpsellEntrypoint = s12
end
function t1.userAndPlaceCanUseVoice(p93) -- line: 1136
	return p93.coreVoiceManager:userAndPlaceCanUseVoice()
end
function t1.verifyUniverseAndPlaceCanUseVoice(p94) -- line: 1140
	return p94.coreVoiceManager:verifyUniverseAndPlaceCanUseVoice()
end
function t1.GetVoiceConnectCookieValue(p95) -- line: 1144
	return p95.coreVoiceManager:GetVoiceConnectCookieValue()
end
function t1.GetVoiceConnectCookie(p96) -- line: 1148
	return p96.coreVoiceManager:GetVoiceConnectCookie()
end
function t1.SetVoiceConnectCookieValue(t13: {[any]: any}, b3: boolean) -- line: 1152
	return t13.coreVoiceManager:SetVoiceConnectCookieValue(b3)
end
function t1.GetVoiceRewarmCookie(p97) -- line: 1156
	return p97.coreVoiceManager:GetVoiceRewarmCookie()
end
function t1.SetVoiceRewarmCookie(t14: {[any]: any}, s13: string) -- line: 1160
	t14.coreVoiceManager:SetVoiceRewarmCookie(s13)
end
function t1.SetNewUserFTUXCookieValue(t15: {[any]: any}, b4: boolean) -- line: 1164
	return t15.coreVoiceManager:SetNewUserFTUXCookieValue(b4)
end
function t1.ShowPlayerModeratedMessage(t16: {[any]: any}, b5: boolean) -- line: 1168
	-- upvalues: GetUserSettings (copy), Analytics (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy)
	local s14 = "GetRequest"
	local v262 = GetUserSettings(function(...) -- line: 735
		-- upvalues: t16 (copy), s14 (copy)
		return t16[s14](t16, ...)
	end)

	if not v262 or not v262.isBanned then
		t16:_reportJoinFailed("PlayerModeratedBadState", Analytics.ERROR)

		return
	end

	t16.banReason = v262.banReason

	if v262.bannedUntil == nil then
		t16:showPrompt(PromptType.VoiceChatSuspendedPermanent)

		return
	end

	t16.bannedUntil = v262.bannedUntil

	if b5 then
		t16:showPrompt(PromptType.VoiceChatSuspendedTemporaryToast)

		return
	end

	if t16.banReason == BAN_REASON.NUDGE_V3 then
		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			t16:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)

			return
		end

		t16:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)

		return
	end

	t16:showPrompt(PromptType.VoiceChatSuspendedTemporary)
end
function t1.CheckCallState(p98) -- line: 1197
	return p98.coreVoiceManager:CheckCallState()
end
function t1.ShowVoiceChatLoadingMessage(p99) -- line: 1201
	-- upvalues: PromptType (copy)
	p99:showPrompt(PromptType.VoiceLoading)
end
function t1.requestMicPermission(p100) -- line: 1205
	return p100.coreVoiceManager:requestMicPermission()
end
function t1.canUseServiceAsync(p101) -- line: 1209
	return p101.coreVoiceManager:canUseServiceAsync()
end
function t1.canUseService(p102) -- line: 1214
	-- upvalues: HttpRbxApiService (copy), HttpService (copy), VOICE_CHAT_AVAILABILITY (copy)
	if p102.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		return false
	end

	local ok, result = pcall(function() -- line: 1218
		-- upvalues: HttpRbxApiService (copy), HttpService (copy)
		local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl("https://voice.roblox.com/v1/settings", Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)
	local v270 = ok and result.isVoiceEnabled

	if not v270 then
		p102.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable
	end

	return v270
end
function t1.ensureInitialized(p103, p104) -- line: 1234
	return p103.coreVoiceManager:ensureInitialized(p104)
end
function t1.GetSessionId(p105) -- line: 1239
	return p105.coreVoiceManager:GetSessionId()
end
function t1.GetChannelId(p106) -- line: 1243
	return p106.coreVoiceManager:GetChannelId()
end
function t1.JoinWithVoiceMuteData(p107, p108) -- line: 1247
	return p107.coreVoiceManager:JoinWithVoiceMuteData(p108)
end
function t1.calculateBanDuration(_: {[any]: any}, n3: number, n4: number) -- line: 1251
	return (math.ceil((n4 - n3) / 60))
end
function t1.ShowVoiceUI(p109) -- line: 1255
	-- upvalues: ExpChat (copy)
	p109.voiceUIVisible = true
	p109.showVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(true)
	end
end
function t1.HideVoiceUI(p110) -- line: 1264
	-- upvalues: ExpChat (copy)
	p110.voiceUIVisible = false
	p110.hideVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(false)
	end
end
function t1.createPromptInstance(p111, p112, p113) -- line: 1273
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), LocalizationService (copy), GetFFlagShowDevicePermissionsModal (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default3 (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy), Roact (copy), VoiceChatPrompt (copy), Analytics (copy), PostInformedOfBan (copy), Constants2 (copy), v51 (copy), GetFFlagJoinWithoutMicPermissions (copy), v18 (copy), CoreGui (copy)
	if p111.promptSignal then
		p111.promptSignal:Destroy()
		p111.promptSignal = nil
	end

	p111.promptSignal = Instance.new("BindableEvent")

	local errorText = nil

	if GetFFlagEnableVoicePromptReasonText() then
		errorText = p111.errorText
	end

	local v286 = p113 == PromptType.VoiceChatSuspendedTemporaryB

	if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
		v286 = v286 or p113 == PromptType.VoiceChatSuspendedTemporaryBV2
	end

	local s15 = ""

	if p111.bannedUntil ~= nil then
		s15 = if not v286 then DateTime.fromUnixTimestamp(p111.bannedUntil.Seconds):FormatLocalTime("l LT", LocalizationService.RobloxLocaleId) else tostring((p111:calculateBanDuration(DateTime.now().UnixTimestamp, p111.bannedUntil.Seconds)))
	end

	local v288 = p113 == PromptType.VoiceToxicityModal or (p113 == PromptType.VoiceToxicityToast or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (p113 == PromptType.VoiceToxicityModalV2 or p113 == PromptType.VoiceToxicityToastV2))
	local v289 = p113 == PromptType.VoiceConsentModalV1 or (p113 == PromptType.VoiceConsentModalV2 or p113 == PromptType.VoiceConsentModalV3)
	local u290 = false
	local u291 = nil

	if GetFFlagShowDevicePermissionsModal() and p113 == PromptType.DevicePermissionsModal and p111.settingsAppAvailable == nil then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function() -- line: 1322
					-- upvalues: u290 (ref), u291 (ref), default3 (copy), SettingsRoute (copy)
					local v475, v476 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

					u290 = v475
					u291 = v476
				end)

				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if u291 ~= nil then
					break
				end
			end
		else
			local v294, v295 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

			u290 = v294
			u291 = v295
		end

		p111.settingsAppAvailable = u290 and u291
	end

	p111.voiceChatPromptInstance = Roact.mount(Roact.createElement(VoiceChatPrompt, {
		Analytics = Analytics.new(),
		promptSignal = p111.promptSignal.Event,
		bannedUntil = s15,
		policyMapper = p111.policyMapper,
		errorText = errorText,
		onReadyForSignal = p112,
		VoiceChatServiceManager = p111,
		settingsAppAvailable = p111.settingsAppAvailable ~= nil and p111.settingsAppAvailable,
		onContinueFunc = if p113 ~= PromptType.VoiceChatSuspendedTemporary and not v286 then if not v288 then if not v289 then nil else function() -- line: 1361
			-- upvalues: p111 (copy), Constants2 (copy)
			p111:RecordUserSeenModal(Constants2.MODAL_IDS.IN_EXP_UPSELL)
		end else function() -- line: 1358
			-- upvalues: p111 (copy)
			p111.Analytics:reportClosedNudge(p111:GetNudgeAnalyticsData())
		end else function() -- line: 1355
			-- upvalues: PostInformedOfBan (copy), p111 (copy)
			local v477 = PostInformedOfBan
			local v478 = p111
			local s16 = "PostRequest"

			v477(function(...) -- line: 735
				-- upvalues: v478 (copy), s16 (copy)
				return v478[s16](v478, ...)
			end, true)
		end,
		onPrimaryActivated = if not v288 then if v51 or (not GetFFlagJoinWithoutMicPermissions() or p113 ~= PromptType.Permission) then if not GetFFlagJoinWithoutMicPermissions() or (not GetFFlagShowDevicePermissionsModal() or p113 ~= PromptType.DevicePermissionsModal) then if not v286 then if not v289 then nil else function() -- line: 1418
			-- upvalues: p111 (copy), Constants2 (copy)
			p111.Analytics:reportInExpConsent("accepted", p111.inExpUpsellEntrypoint, p111:GetInExpUpsellAnalyticsData())

			if p111.pendingConnectionSource == nil then
				p111.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			p111:EnableVoice()
		end else function() -- line: 1414
			-- upvalues: p111 (copy)
			p111:reportBanMessage("Understood")
			p111.Analytics:reportBanMessageEvent("Understood")
		end else function() -- line: 1393
			-- upvalues: v18 (copy), p111 (copy), default3 (copy), SettingsRoute (copy)
			v18:debug("Settings app available: {}", p111.settingsAppAvailable)
			p111.Analytics:reportDevicePermissionsModalEvent(not p111.settingsAppAvailable and "Acknowledged" or "OpenedSettings", p111:GetSessionId(), p111:GetInExpUpsellAnalyticsData())

			if p111.settingsAppAvailable then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp(SettingsRoute.Microphone):andThen(function() -- line: 1404
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1407
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1373
			-- upvalues: default3 (copy), v18 (copy)
			local v480 = default3:supportsSwitchToSettingsApp():await()

			v18:debug("Settings app available: {}", v480)

			if v480 then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp():andThen(function() -- line: 1379
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1382
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1366
			-- upvalues: p111 (copy)
			p111.Analytics:reportAcknowledgedNudge(p111:GetNudgeAnalyticsData())
		end,
		onSecondaryActivated = if p113 ~= PromptType.VoiceToxicityModal and (not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or p113 ~= PromptType.VoiceToxicityModalV2) then if not v288 then if not v286 then if not v289 then if p113 ~= PromptType.DevicePermissionsModal then nil else function() -- line: 1453
			-- upvalues: p111 (copy)
			p111.Analytics:reportDevicePermissionsModalEvent("Denied", p111:GetSessionId(), p111:GetInExpUpsellAnalyticsData())
		end else function() -- line: 1443
			-- upvalues: p111 (copy), Constants2 (copy), PromptType (copy)
			p111.Analytics:reportInExpConsent("denied", p111.inExpUpsellEntrypoint, p111:GetInExpUpsellAnalyticsData())

			if p111.inExpUpsellEntrypoint ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				p111:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end
		end else function() -- line: 1438
			-- upvalues: p111 (copy)
			p111:ShowVoiceToxicityFeedbackToast()
			p111:reportBanMessage("Denied")
			p111.Analytics:reportBanMessageEvent("Denied")
		end else function() -- line: 1435
			-- upvalues: p111 (copy)
			p111.Analytics:reportDeniedNudge(p111:GetNudgeAnalyticsData())
		end else function() -- line: 1431
			-- upvalues: p111 (copy)
			p111:ShowVoiceToxicityFeedbackToast()
			p111.Analytics:reportDeniedNudge(p111:GetNudgeAnalyticsData())
		end
	}), CoreGui, "RobloxVoiceChatPromptGui")
end
function t1.showPrompt(p114, p115, p116) -- line: 1467
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), v18 (copy)
	if GetFFlagEnableVoicePromptReasonText() then
		p114.errorText = p116 or nil
	end

	p114:createPromptInstance(function() -- line: 1471
		-- upvalues: v18 (copy), p115 (copy), p114 (copy)
		v18:debug("Show Prompt: {}", p115)
		p114.promptSignal:fire(p115)
	end, p115)
end
function t1.showJoinVoicePrompt(p117) -- line: 1477
	-- upvalues: PromptType (copy), AppStorageService (copy), Constants2 (copy)
	p117:showPrompt(PromptType.UnifiedJoinVoiceToast)
	pcall(function() -- line: 1479
		-- upvalues: AppStorageService (copy), Constants2 (copy)
		AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
		AppStorageService:Flush()
	end)
end
function t1.CheckAndShowPermissionPrompt(p118) -- line: 1485
	-- upvalues: GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy), GetFFlagEnableUniveralVoiceToasts (copy)
	local function showPrompt() -- line: 1486
		-- upvalues: p118 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy)
		local userEligible = p118.userEligible

		if p118.voiceEnabled or userEligible then
			if GetFFlagEnableSeamlessVoiceV2() or not GetFFlagJoinWithoutMicPermissions() then
				return p118.PermissionsService:hasPermissions({ PermissionsProtocol.Permissions.MICROPHONE_ACCESS }):andThen(function(p119) -- line: 1499
					-- upvalues: PermissionsProtocol (copy), p118 (copy), PromptType (copy)
					if p119 and p119.status == PermissionsProtocol.Status.DENIED then
						p118:showPrompt(PromptType.Permission)
					end
				end)
			end

			if p118.permissionState == PERMISSION_STATE.LISTEN_ONLY then
				p118:showPrompt(PromptType.Permission)
			end
		end

		return Promise.resolve()
	end

	if GetFFlagEnableUniveralVoiceToasts() then
		return showPrompt()
	end

	return p118:asyncInit():andThen(function() -- line: 1512
	end):catch(function() -- line: 1512
		-- upvalues: showPrompt (copy)
		return showPrompt()
	end)
end
function t1.showDataConsentToast(p120) -- line: 1518
	-- upvalues: GetFFlagSeamlessVoiceConsentToastPolicy (copy), UniversalAppPolicy (copy), SeamlessVoiceStatus (copy), Constants2 (copy), PromptType (copy)
	local v303 = p120:FetchAgeVerificationOverlay()
	local v304 = false

	if GetFFlagSeamlessVoiceConsentToastPolicy() then
		v304 = UniversalAppPolicy.getAppFeaturePolicies().getDisplayCheckboxInVoiceConsent() or false
	end

	local v305, showDataConsentToast

	if type(v303) == "table" then
		v305 = if not v303.voiceSettings then SeamlessVoiceStatus.Invalid else v303.voiceSettings.seamlessVoiceStatus
		showDataConsentToast = v303.showDataConsentToast
	else
		showDataConsentToast = false
		v305 = SeamlessVoiceStatus.Invalid
	end

	if showDataConsentToast and v304 then
		showDataConsentToast = type(p120:_GetShowAgeVerificationOverlay()) == "table" and p120:_GetShowAgeVerificationOverlay().showDataConsentToast
	end

	if v305 == SeamlessVoiceStatus.EnabledExistingUser and showDataConsentToast and v304 then
		p120:RecordUserSeenModal(Constants2.MODAL_IDS.DATA_CONSENT_TOAST)

		return p120:showPrompt(PromptType.VoiceDataConsentOptOutToast)
	end
end
function t1.CheckAndShowNotAudiblePrompt(p121) -- line: 1552
	-- upvalues: PromptType (copy), Promise (copy)
	if game:GetEngineFeature("VoiceChatSupported") then
		return p121:asyncInit():andThen(function() -- line: 1555
			-- upvalues: p121 (copy), PromptType (copy)
			if UserSettings().GameSettings.MasterVolume == 0 then
				p121:showPrompt(PromptType.NotAudible)
			end
		end):catch(function() -- line: 1561
		end)
	end

	return Promise.resolve()
end
function t1.ShowNotAudiblePromptVoiceChatVolume(p122) -- line: 1567
	-- upvalues: FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), Promise (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), PromptType (copy)
	if not FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast or not FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		return Promise.resolve()
	end

	if game:GetEngineFeature("VoiceChatSupported") then
		return p122:asyncInit():andThen(function() -- line: 1577
			-- upvalues: VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), p122 (copy), PromptType (copy)
			if UserSettings().GameSettings.MasterVolume > 0 and (VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi) and UserSettings().GameSettings.VoiceChatVolume == 0) then
				p122:showPrompt(PromptType.NotAudibleVoiceChatVolume)
			end
		end):catch(function() -- line: 1585
		end)
	end

	return Promise.resolve()
end
function t1.InitialJoinFailedPrompt(p123) -- line: 1590
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), PromptType (copy)
	v18:debug("JoinByGroupIdToken returns false")

	if not GetFFlagVoiceChatClientRewriteMasterLua then
		p123:showPrompt(PromptType.Retry)
	end
end
function t1.ShowVoiceToxicityFeedbackToast(p124) -- line: 1597
	-- upvalues: v18 (copy), PromptType (copy)
	v18:debug("Sending feedback toast")
	p124:showPrompt(PromptType.VoiceToxicityFeedbackToast)
end
function t1.GetNudgeAnalyticsData(p125) -- line: 1602
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p125:GetSessionId()
end
function t1.GetInExpUpsellAnalyticsData(_) -- line: 1606
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	local s17 = ""

	if EngineFeature then
		s17 = RbxAnalyticsService:GetPlaySessionId()
	end

	return game.GameId, game.PlaceId, s17
end
function t1.reportBanMessage(t18: {[any]: any}, s18: string) -- line: 1614
	-- upvalues: Players (copy)
	t18.Analytics:reportBanMessageEventV2(s18, t18.banReason, Players.LocalPlayer.UserId, not t18.service and "" or t18.previousSessionId)
end
function t1.reportJoinVoiceUpsellEvent(t19: {[any]: any}, s19: string, s20: string?, s21: string?) -- line: 1623
	-- upvalues: RbxAnalyticsService (copy), FFlagVoiceRewarmTelemetry (copy)
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()

	if FFlagVoiceRewarmTelemetry then
		t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled(), s20, s21)

		return
	end

	t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled())
end
function t1.SetAndSyncActive(t20: {[any]: any}, p127, b6: boolean) -- line: 1642
	t20.coreVoiceManager:SetAndSyncActive(p127, b6)
end
function t1.CreateAudioDeviceData(t21: {[any]: any}, p128) -- line: 1646
	return t21.coreVoiceManager:CreateAudioDeviceData(p128)
end
function t1.onInstanceAdded(t22: {[any]: any}, p129) -- line: 1650
	return t22.coreVoiceManager:onInstanceAdded(p129)
end
function t1.UpdateAudioDeviceInputDebugger(p130) -- line: 1654
	-- upvalues: v41 (copy), v18 (copy), Roact (copy), AudioDeviceInputDebugger (copy), CoreGui (copy)
	if v41 then
		if not p130.voiceDebuggerInstance then
			v18:debug("Mounting AudioDeviceInput Debugger")
			p130.voiceDebuggerInstance = Roact.mount(Roact.createElement(AudioDeviceInputDebugger, {
				instances = p130.audioDevices,
				mutedPlayers = p130.mutedPlayers
			}), CoreGui, "RobloxVoiceChatPromptGui")

			return
		end

		Roact.update(p130.voiceDebuggerInstance, Roact.createElement(AudioDeviceInputDebugger, {
			instances = p130.audioDevices,
			mutedPlayers = p130.mutedPlayers
		}))
	end
end
function t1.AddReverseNudgeToxicUser(t23: {[any]: any}, s22: string, p131, p132) -- line: 1678
	-- upvalues: GetFIntVoiceReverseNudgeUXDisplayTimeSeconds (copy)
	p131(s22, "iconColorChange")

	local v333 = t23.reverseNudgeToxicUserRemovalCallbacks[s22]

	if v333 ~= nil then
		task.cancel(v333)
	end

	local thread = task.delay(GetFIntVoiceReverseNudgeUXDisplayTimeSeconds(), function() -- line: 1692
		-- upvalues: p132 (copy), s22 (copy), t23 (copy)
		p132(s22)
		t23.reverseNudgeToxicUserRemovalCallbacks[s22] = nil
	end)

	t23.reverseNudgeToxicUserRemovalCallbacks[s22] = thread
end
function t1.onInstanceRemove(t24: {[any]: any}, p133) -- line: 1699
	return t24.coreVoiceManager:onInstanceRemove(p133)
end
function t1.hookupAudioDeviceInputListener(p134) -- line: 1703
	return p134.coreVoiceManager:hookupAudioDeviceInputListener()
end
function t1.ToggleMutePlayer(t25: {[any]: any}, n5: number, s23: string) -- line: 1707
	return t25.coreVoiceManager:ToggleMutePlayer(n5, s23)
end
function t1.MuteAll(t26: {[any]: any}, b7: boolean, s24: string) -- line: 1711
	return t26.coreVoiceManager:MuteAll(b7, s24)
end
function t1.ToggleMuteSome(t27: {[any]: any}, t28: {[any]: any}, b8: boolean, s25: string, s26: string) -- line: 1715
	return t27.coreVoiceManager:ToggleMuteSome(t28, b8, s25, s26)
end
function t1.FireMuteNonFriendsEvent(p135) -- line: 1724
	p135.mutedNonFriends:Fire()
end
function t1.EnsureCorrectMuteState(t29: {[any]: any}, t30: {[any]: any}, b9: boolean) -- line: 1728
	-- upvalues: VoiceChatService (copy), EngineFeature2 (copy), Players (copy)
	local t31 = {}

	for _, v355 in t30 do
		local v356 = t29.participants[tostring(v355)]

		if v356 and b9 ~= v356.isMutedLocally then
			if VoiceChatService.UseNewAudioApi then
				t31[v355] = true
				t29.mutedPlayers[v355] = b9
			else
				t29.service:SubscribePause(v355, b9)
			end

			v356.isMutedLocally = b9
			t29.participantsUpdate:Fire(t29.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v357 in t29.audioDevices do
			if v357.Player and t31[v357.Player.UserId] then
				if EngineFeature2 and v357.Player ~= Players.LocalPlayer then
					v357.MutedByLocalUser = b9
				else
					v357.Active = not b9
				end
			end
		end
	end
end
function t1.FireUserAgencySelectedEvent(t32: {[any]: any}, b10: boolean) -- line: 1760
	t32.userAgencySelected:Fire(b10)
end
function t1.ParticipantStateToIcon(_, p137, p138) -- line: 1764
	-- upvalues: VOICE_STATE (copy)
	local INACTIVE = VOICE_STATE.INACTIVE

	if not p137.subscriptionCompleted then
		INACTIVE = VOICE_STATE.CONNECTING
	elseif p137.isMutedLocally then
		INACTIVE = VOICE_STATE.LOCAL_MUTED
	elseif p137.isMuted then
		INACTIVE = VOICE_STATE.MUTED
	elseif p137.isSignalActive then
		INACTIVE = VOICE_STATE.TALKING
	end

	return getIcon(INACTIVE, p138)
end
function t1.VoiceStateToIcon(_, p140, p141, p142) -- line: 1779
	return getIcon(p140, p141, p142)
end
function t1.GetIcon(_, p144, p145) -- line: 1783
	return getIconSrc(p144, p145)
end
function t1.JoinVoice(p146, p147) -- line: 1787
	-- upvalues: FFlagVoiceRewarmTelemetry (copy), v65 (copy), v18 (copy), v69 (copy), Constants2 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), GetFFlagUpdateVoiceConnectionToasts (copy), PromptType (copy), GetFFlagNonVoiceFTUX (copy), AppStorageService (copy), GetFFlagEnableVrVoiceParity (copy), Promise (copy), v50 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v54 (copy), GetFFlagDisableConsentModalForExistingUsers (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), getOverlayStore (copy), OverlayTypes (copy), SocialUpsellType (copy), Enum2 (copy), v48 (copy)
	local joinVoiceButtonContext = nil
	local s27 = nil

	if FFlagVoiceRewarmTelemetry then
		joinVoiceButtonContext = p146.joinVoiceButtonContext
		p146.joinVoiceButtonContext = nil
	end

	if v65 then
		v18:debug("Consuming voice re-warm cookie on JoinVoice")
		p146:SetVoiceRewarmCookie("true")
	end

	local v375 = p146:FetchAgeVerificationOverlay()
	local v376 = ((if not v69 then v375.showVoiceInExperienceUpsellVariant else (if type(v375) ~= "table" then nil else v375.showVoiceInExperienceUpsellVariant))) or Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3

	if not FFlagVoiceRewarmTelemetry then
		p146.Analytics:reportJoinVoiceButtonEvent("clicked", p146:GetInExpUpsellAnalyticsData())
	end

	if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p146.previousGroupId then
		if FFlagVoiceRewarmTelemetry then
			s27 = "RejoinPreviousChannel"
		end

		p146:RejoinPreviousChannel()

		if GetFFlagEnableVoiceTrustedConnectionsToasts() then
			p146:showJoinVoicePrompt()
		elseif GetFFlagUpdateVoiceConnectionToasts() then
			p146:showPrompt(PromptType.UnifiedJoinVoiceToast)
		else
			p146:showPrompt(PromptType.JoinVoice)
		end

		p146:ShowVoiceUI()
		p146:SetVoiceConnectCookieValue(true)
	elseif GetFFlagNonVoiceFTUX() and p146.isShowingFTUX then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ExitFtux"
		end

		p146:HideFTUX(AppStorageService)
	elseif p146.deniedMicPermissions then
		if FFlagVoiceRewarmTelemetry then
			s27 = "MicPermissionPrompt"
		end

		if GetFFlagEnableVrVoiceParity() then
			p146:CheckAndShowPermissionPrompt()
		else
			p146:CheckAndShowPermissionPrompt():finallyReturn(Promise.reject())
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p146:UserVoiceEnabled() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FirstJoinSession"
		end

		if v50 then
			p146.isInitialJoin = true
		end

		p146.attemptVoiceRejoin:Fire()

		if GetFFlagEnableSeamlessVoiceV2() and p146:IsNewSeamlessVoiceUserDisconnect() then
			p146:SetVoiceConnectCookieValue(true)
			p146:SetNewUserFTUXCookieValue(true)
		end
	elseif v54 and p146:UserOnlyEligibleForVoiceViaOverlay() or p146:UserOnlyEligibleForVoice() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ConsentModal"
		end

		if GetFFlagDisableConsentModalForExistingUsers() and p146:IsSeamlessVoice() then
			p146:EnableVoice()
		else
			p146:SetInExpUpsellEntrypoint(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE)
			p146:showPrompt((p146:GetInExpUpsellPromptFromEnum(v376)))
		end
	elseif p146:EligibleForAgeCheckToast() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "AgeCheckToast"
		end

		p146:showPrompt(PromptType.AgeCheckForVoiceToast)
	elseif GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not p146:UserVoiceEnabled() and p146:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		if FFlagVoiceRewarmTelemetry then
			s27 = "PhoneUpsell"
		end

		if p147 then
			p147:SetVisibility(false, true)
		end

		p146:ShowInExperiencePhoneVoiceUpsell(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE, Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER)
	elseif p146:EligibleForFaeUpsell() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FaeUpsell"
		end

		if p146.pendingConnectionSource == nil then
			p146.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		end

		p146.coreVoiceManager:OptUserToJoinVoice()

		local v377 = getOverlayStore(false)

		if not FFlagVoiceRewarmTelemetry then
			p146:reportJoinVoiceUpsellEvent("Click")
		end

		v377.setCurrentOverlay(OverlayTypes.SocialUpsell, {
			upsellType = SocialUpsellType.FacialAgeEstimation,
			data = {
				isInExperience = true,
				countDownBadgeText = nil,
				isPhase2 = true,
				upsellEntrySurface = Enum2.UpsellEntrySurfaceType.InExperienceVoiceChatIcon,
				upsellEntryComponent = Enum2.UpsellComponent.Modal,
				upsellPurpose = Enum2.UpsellStage.Fae
			}
		})
	end

	if FFlagVoiceRewarmTelemetry then
		local v378, v379, v380 = p146:GetInExpUpsellAnalyticsData()

		p146.Analytics:reportJoinVoiceButtonEvent("clicked", v378, v379, v380, joinVoiceButtonContext, s27)
		p146:reportJoinVoiceUpsellEvent("Click", joinVoiceButtonContext, s27)
	end

	if v48 and p146:IsSeamlessVoice() then
		task.spawn(function() -- line: 1929
			-- upvalues: p146 (copy)
			p146.coreVoiceManager:PostUserVoiceConnectionStatus(true)
		end)
	end
end
function t1.EligibleForFaeUpsell(p148) -- line: 1935
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy)
	local v382 = GetFFlagEnableVoiceUxUpdates()

	if v382 then
		v382 = p148.coreVoiceManager:EligibleForFaeUpsell()

		if v382 then
			v382 = p148.AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

			if v382 then
				if FFlagTestDeviceForFAEUpsell then
					return (deviceMeetsRequirementsForFAE())
				end

				v382 = true
			end
		end
	end

	return v382
end
function t1.EligibleForAgeCheckToast(p149) -- line: 1942
	return p149.coreVoiceManager:EligibleForAgeCheckToast()
end
function t1.ShouldShowJoinVoice(p150) -- line: 1947
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagVoiceRewarmTelemetry (copy), VoiceChatCore (copy), v65 (copy), GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		if FFlagVoiceRewarmTelemetry then
			if p150:EligibleForFaeUpsell() then
				p150.joinVoiceButtonContext = "FaeUpsell"

				return true
			end

			if p150:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p150:GetVoiceConnectCookie() == "" then
				p150.joinVoiceButtonContext = "VoiceFtux"

				return true
			end

			if v65 and p150:GetVoiceRewarmCookie() == "" and p150:GetVoiceConnectCookie() == "false" and p150:UserVoiceEnabled() then
				p150.joinVoiceButtonContext = "Rewarm"

				return true
			end
		elseif p150:EligibleForFaeUpsell() or p150:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p150:GetVoiceConnectCookie() == "" or v65 and p150:GetVoiceRewarmCookie() == "" and p150:VoiceChatEnded() then
			return true
		end
	elseif GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses() then
		if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p150:IsSeamlessVoice() and p150:verifyUniverseAndPlaceCanUseVoice() then
			return not p150.voiceUIVisible
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p150:IsSeamlessVoice() then
		return not p150.voiceUIVisible
	end

	if p150:EligibleForAgeCheckToast() then
		return true
	end

	local v385 = p150:UserInInExperienceUpsellTreatment()
	local v386 = p150:UserOnlyEligibleForVoice() or p150:UserVoiceEnabled()

	if GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not v386 and not p150:UserVoiceEnabled() and p150:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		return true
	end

	return v385 and v386
end
function t1.ShouldShowJoinVoiceOnDisconnect(p151) -- line: 2026
	return p151.coreVoiceManager:ShouldShowJoinVoiceOnDisconnect()
end
function t1.IsSeamlessVoice(p152) -- line: 2030
	-- upvalues: GetFFlagCheckUniversePlaceBeforeSuspending (copy), v18 (copy), SeamlessVoiceStatus (copy)
	if GetFFlagCheckUniversePlaceBeforeSuspending() then
		return p152.coreVoiceManager:IsSeamlessVoice()
	end

	local v389 = p152:FetchAgeVerificationOverlay()

	if not v389 or not v389.voiceSettings then
		v18:error("VoiceChatServiceManager:IsSeamlessVoice() - ageVerificationOverlayData or voiceSettings is nil")

		return false
	end

	local seamlessVoiceStatus = v389.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == SeamlessVoiceStatus.EnabledNewUser
end
function t1.HasSeamlessVoiceFeature(p153, p154) -- line: 2046
	return p153.coreVoiceManager:HasSeamlessVoiceFeature(p154)
end
function t1.IsNewSeamlessVoiceUserDisconnect(p155) -- line: 2050
	return p155.coreVoiceManager:IsNewSeamlessVoiceUserDisconnect()
end
function t1.GetConnectDisconnectButtonAnalyticsData(t33: {[any]: any}, b11: boolean) -- line: 2054
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	local s28 = ""

	if EngineFeature then
		s28 = RbxAnalyticsService:GetPlaySessionId()
	end

	local t34 = {
		game.GameId,
		game.PlaceId,
		s28
	}

	if b11 and t33:getService() then
		table.insert(t34, t33:GetSessionId())
	end

	return unpack(t34)
end
function t1.GetConnectDisconnectAnalyticsData(p156) -- line: 2066
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy), GetFFlagNonVoiceFTUX (copy), default (copy)
	local t35 = {}
	local s29 = ""

	if EngineFeature then
		s29 = RbxAnalyticsService:GetPlaySessionId()
	end

	t35.universeId = game.GameId
	t35.placeId = game.PlaceId
	t35.playSessionId = s29

	if GetFFlagNonVoiceFTUX() then
		t35.voiceSessionId = not p156.service and "" or p156:GetSessionId()
	else
		t35.voiceSessionId = p156:GetSessionId()
	end

	t35.durationTimestamp = default:getTimestamp()

	return t35
end
function t1.Leave(p157) -- line: 2086
	-- upvalues: GetFFlagDisconnectToastClientRewrite (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v48 (copy)
	p157:ensureInitialized("leave")

	if GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p157:SetVoiceConnectCookieValue(false)
	end

	p157.Analytics:reportConnectDisconnectEvents("voiceDisconnectEvent", p157:GetConnectDisconnectAnalyticsData())

	local GroupId = p157.service:GetGroupId()
	local v403 = p157.service:IsPublishPaused()

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		local VoiceChatService2 = game:GetService("VoiceChatService")

		if VoiceChatService2 then
			VoiceChatService2:leaveVoice()
		end
	else
		p157.service:Leave()
	end

	p157:HideVoiceUI()
	p157.previousGroupId = GroupId
	p157.previousMutedState = v403

	if not GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p157:SetVoiceConnectCookieValue(false)
	end

	if v48 and p157:IsSeamlessVoice() then
		task.spawn(function() -- line: 2109
			-- upvalues: p157 (copy)
			p157.coreVoiceManager:PostUserVoiceConnectionStatus(false)
		end)
	end
end
function t1.GetVoiceStateFromEnum(_, p159) -- line: 2115
	-- upvalues: t2 (ref), VOICE_STATE (copy)
	if not t2[p159] then
		t2 = {
			[Enum.VoiceChatState.Idle] = VOICE_STATE.HIDDEN,
			[Enum.VoiceChatState.Joining] = VOICE_STATE.CONNECTING,
			[Enum.VoiceChatState.JoiningRetry] = VOICE_STATE.CONNECTING,
			[Enum.VoiceChatState.Joined] = VOICE_STATE.MUTED,
			[Enum.VoiceChatState.Leaving] = VOICE_STATE.MUTED,
			[Enum.VoiceChatState.Ended] = VOICE_STATE.HIDDEN,
			[Enum.VoiceChatState.Failed] = VOICE_STATE.ERROR
		}
	end

	return t2[p159]
end
function t1.GetInExpUpsellPromptFromEnum(_: {[any]: any}, s30: string) -- line: 2135
	-- upvalues: t3 (copy)
	return t3[s30]
end
function t1.getRecentUsersInteractionData(p160) -- line: 2140
	return p160.coreVoiceManager:getRecentUsersInteractionData()
end
function t1._setRecentUserState(p161, p162, p163) -- line: 2144
	return p161.coreVoiceManager:_setRecentUserState(p162, p163)
end
function t1._updateRecentUsersInteractionData(p164) -- line: 2148
	return p164.coreVoiceManager:_updateRecentUsersInteractionData()
end
function t1.SetupParticipantListeners(p165) -- line: 2152
	return p165.coreVoiceManager:SetupParticipantListeners()
end
function t1.Disconnect(p166) -- line: 2156
	p166.coreVoiceManager:Disconnect()
	p166.coreVoiceManager:unsubscribeAll()
end
function t1.GetSendMuteEvent(p167) -- line: 2161
	return p167.coreVoiceManager:GetSendMuteEvent()
end
function t1.ToggleMic(t37: {[any]: any}, s31: string?) -- line: 2166
	return t37.coreVoiceManager:ToggleMic(s31)
end
function t1.SubscribeRetry(t38: {[any]: any}, n6: number) -- line: 2170
	-- upvalues: v18 (copy)
	t38:ensureInitialized("subscribe retry")
	v18:debug("Attempting to retry connection to user: {}", "..." .. string.sub(tostring(n6), -4))
	t38.service:SubscribeRetry(n6)
end
function t1.JoinByGroupIdToken(p168, p169, p170) -- line: 2176
	return p168.coreVoiceManager:JoinByGroupIdToken(p169, p170)
end
function t1.RejoinPreviousChannel(p171) -- line: 2180
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy)
	local previousGroupId = p171.previousGroupId
	local previousMutedState = p171.previousMutedState

	v18:debug("Rejoining previous channel {} with mute status {}", previousGroupId, previousMutedState)
	pcall(function() -- line: 2185
		-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), p171 (copy), previousGroupId (copy), previousMutedState (copy)
		if GetFFlagVoiceChatClientRewriteMasterLua() then
			p171.coreVoiceManager:RejoinVoice()

			local ConnectDisconnectAnalyticsData = p171:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p171.pendingConnectionSource
			p171.pendingConnectionSource = nil
			p171.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p171.voiceConnectEventReportedForActiveSession = true

			return
		end

		if previousGroupId and previousGroupId ~= "" then
			p171.service:Leave()

			if not p171.service:JoinByGroupIdToken(previousGroupId, previousMutedState, true) then
				p171:InitialJoinFailedPrompt()

				return
			end

			local ConnectDisconnectAnalyticsData = p171:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p171.pendingConnectionSource
			p171.pendingConnectionSource = nil
			p171.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p171.voiceConnectEventReportedForActiveSession = true
		end
	end)
end
function t1.SwitchDevice(_, p173, p174, p175) -- line: 2211
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy), v18 (copy)
	if p173 == VOICE_CHAT_DEVICE_TYPE.Input then
		SoundService:SetInputDevice(p174, p175)
		v18:info("[InputDeviceSelection] Setting SS Mic Device To {} {}", p174, p175)

		return
	end

	SoundService:SetOutputDevice(p174, p175)
	v18:info("[OutputDeviceSelection] Setting SS Speaker Device To {} {}", p174, p175)
end
function t1.GetDevices(_, p177) -- line: 2221
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
	local ok, result, v435, v436 = pcall(function() -- line: 2222
		-- upvalues: p177 (copy), VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
		if p177 == VOICE_CHAT_DEVICE_TYPE.Input then
			return SoundService:GetInputDevices()
		end

		return SoundService:GetOutputDevices()
	end)

	return ok, result, v435, v436
end
function t1.VoiceChatAvailable(p178) -- line: 2233
	-- upvalues: MIN_VOICE_CHAT_API_VERSION (copy), VOICE_CHAT_AVAILABILITY (copy)
	local service = p178.service

	if p178.available == nil and service then
		p178.version = service:GetVoiceChatApiVersion()

		if p178.version >= MIN_VOICE_CHAT_API_VERSION then
			p178.available = service:GetVoiceChatAvailable()

			while p178.available == VOICE_CHAT_AVAILABILITY.Checking do
				wait(1)
				p178.available = service:GetVoiceChatAvailable()
			end
		end
	end

	if service then
		return p178.version >= MIN_VOICE_CHAT_API_VERSION and p178.available == VOICE_CHAT_AVAILABILITY.Available
	end

	return false
end
function t1.VoiceChatEnded(p179) -- line: 2253
	-- upvalues: v52 (copy)
	if p179.service then
		local VoiceChatState = p179.service.VoiceChatState

		if v52 then
			return VoiceChatState == Enum.VoiceChatState.Ended
		end

		return VoiceChatState == Enum.VoiceChatState.Ended or VoiceChatState == Enum.VoiceChatState.Idle
	end

	return true
end
function t1.UnmountPrompt(p180) -- line: 2265
	-- upvalues: Roact (copy)
	if p180.voiceChatPromptInstance ~= nil then
		Roact.unmount(p180.voiceChatPromptInstance)
		p180.voiceChatPromptInstance = nil
	end
end

t1.default = t1.new(CoreVoiceManager.default, nil, HttpRbxApiService, PermissionsProtocol.default, BlockingUtility:GetAfterBlockedStatusChangedEvent())

if game:DefineFastFlag("VoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry", false) then
	require(CorePackages.Workspace.Packages.PeopleService).getService("PerUserVoiceVolumeSessionLifecycle").ensureStarted()
end

return t1
