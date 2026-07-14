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

		local v453 = p32 == Enum.VoiceChatState.Ended

		if v453 then
			local ConnectDisconnectAnalyticsData = v153:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.disconnectReason = v153.pendingDisconnectReason or Constants2.VOICE_DISCONNECT_REASON.SYSTEM
			v153.Analytics:reportConnectDisconnectEvents("voiceDisconnectReasonEvent", ConnectDisconnectAnalyticsData)
			v153.pendingDisconnectReason = nil
		end

		if v453 and v153.bannedUntil == nil then
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
function t1._reportJoinFailed(p40, p41, p42) -- line: 744
	return p40.coreVoiceManager:_reportJoinFailed(p41, p42)
end
function t1._asyncInit(p43) -- line: 748
	return p43.coreVoiceManager:_asyncInit()
end
function t1.asyncInit(p44) -- line: 752
	return p44.coreVoiceManager:asyncInit()
end
function t1.CheckAudioInputExists(p45) -- line: 756
	return p45.coreVoiceManager:CheckAudioInputExists()
end
function t1.getService(p46) -- line: 760
	return p46.service
end
function t1.GetMutedAnyone(p47) -- line: 764
	return p47.coreVoiceManager:GetMutedAnyone()
end
function t1.RecordGameSettingsOpened(p48) -- line: 768
	p48.coreVoiceManager:RecordGameSettingsOpened()
end
function t1.ReportVoiceVolumeImpressionsIfNeeded(p49) -- line: 772
	p49.coreVoiceManager:ReportVoiceVolumeImpressionsIfNeeded()
end
function t1.GetRequest(p50, p51, p52) -- line: 776
	return p50.coreVoiceManager:GetRequest(p51, p52)
end
function t1.PostRequest(p53, p54, _, p56) -- line: 780
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 781
		-- upvalues: p53 (copy), p54 (copy), p56 (copy), HttpService (copy)
		local v460 = p53.HttpRbxApiService:PostAsyncFullUrl(p54, p56, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(v460)
	end)

	return ok and result
end
function t1._GetShowAgeVerificationOverlay(p57, p58) -- line: 802
	return p57.coreVoiceManager:_GetShowAgeVerificationOverlay(p58)
end
function t1.simulateVoiceConnectDisconnect(p59) -- line: 806
	-- upvalues: v49 (copy), v18 (copy)
	task.spawn(function() -- line: 807
		-- upvalues: v49 (copy), p59 (copy), v18 (copy)
		while true do
			task.wait(v49)

			if p59.voiceUIVisible then
				v18:debug("Hiding Voice")
				p59:HideVoiceUI()
			else
				v18:debug("Showing Voice")
				p59:ShowVoiceUI()
			end
		end
	end)
end
function t1.FetchAgeVerificationOverlay(p60, p61) -- line: 821
	return p60.coreVoiceManager:FetchAgeVerificationOverlay(p61)
end
function t1.FetchPhoneVerificationUpsell(t4: {[any]: any}, s2: string, n1: number?, b2: boolean?) -- line: 825
	return t4.coreVoiceManager:FetchPhoneVerificationUpsell(s2, n1, b2)
end
function t1.RecordUserSeenModal(t5: {[any]: any}, s3: string) -- line: 833
	-- upvalues: PostRecordUserSeenGeneralModal (copy)
	local s4 = "PostRequest"

	return PostRecordUserSeenGeneralModal(function(...) -- line: 735
		-- upvalues: t5 (copy), s4 (copy)
		return t5[s4](t5, ...)
	end, s3)
end
function t1.checkAndUpdateSequence(t6: {[any]: any}, s5: string, n2: number) -- line: 837
	return t6.coreVoiceManager:checkAndUpdateSequence(s5, n2)
end
function t1.onMissedSequence(p62, p63) -- line: 841
	return p62.coreVoiceManager:onMissedSequence(p63)
end
function t1.watchSignalR(p64) -- line: 845
	return p64.coreVoiceManager:watchSignalR()
end
function t1.voicePermissionGranted(p65, p66) -- line: 853
	return p65.coreVoiceManager:voicePermissionGranted(p66)
end
function t1.GetSignalREvent(p67, p68) -- line: 857
	return p67.coreVoiceManager:GetSignalREvent(p68)
end
function t1.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p69, p70) -- line: 862
	return p69.coreVoiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p70)
end
function t1.resolveAvatarChatUserAndPlaceSettings(p71) -- line: 866
	return p71.coreVoiceManager:resolveAvatarChatUserAndPlaceSettings()
end
function t1.EnableVoice(p72) -- line: 870
	return p72.coreVoiceManager:EnableVoice()
end
function t1._VoiceChatFirstTimeUX(t7: {[any]: any}, p73) -- line: 874
	-- upvalues: Constants2 (copy), v18 (copy), GetFFlagNonVoiceFTUX (copy), ExpChat (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), v61 (copy), v47 (copy), PromptType (copy)
	local u214 = nil
	local u215 = nil

	if not pcall(function() -- line: 876
		-- upvalues: p73 (copy), Constants2 (copy), u214 (ref), u215 (ref)
		local Item = p73:GetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY)
		local Item2 = p73:GetItem(Constants2.SEAMLESS_VOICE_STUX_KEY)

		u214 = Item == "true"
		u215 = if Item2 ~= nil then tonumber(Item2) else 0
	end) then
		v18:warning("Failed to read FTUX/STUX from AppStorage")

		return
	end

	v18:trace("hasShownFTUX: {}. STUXCount: {}", u214, u215)

	if not u214 then
		v18:debug("Showing FTUX")
		t7.isShowingFTUX = true
		t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxJoinEvent", t7:GetConnectDisconnectAnalyticsData())

		if GetFFlagNonVoiceFTUX() then
			ExpChat.Events.VoiceUIVisibilityChanged(true)
		else
			t7:MuteAll(true, "FTUX")
			t7.muteAllChanged.Event:Once(function() -- line: 902
				-- upvalues: t7 (copy), p73 (copy)
				t7:HideFTUX(p73)
				t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxLeaveEvent", t7:GetConnectDisconnectAnalyticsData())
			end)
			t7.talkingChanged.Event:Once(function() -- line: 909
				-- upvalues: t7 (copy), p73 (copy)
				t7:HideFTUX(p73)
			end)

			if GetFFlagEnableFtuxExitOnMuteToggle() then
				t7.coreVoiceManager.onPlayerMuteToggled.Event:Once(function() -- line: 913
					-- upvalues: t7 (copy), p73 (copy)
					t7:HideFTUX(p73)
				end)
			end
		end
	elseif u215 < v61 and (not v47 or t7:GetVoiceConnectCookieValue()) then
		v18:debug("Showing STUX")
		t7:showPrompt(PromptType.JoinVoiceSTUX)
		pcall(function() -- line: 924
			-- upvalues: p73 (copy), Constants2 (copy), u215 (ref)
			p73:SetItem(Constants2.SEAMLESS_VOICE_STUX_KEY, (tostring(u215 + 1)))
			p73:Flush()
		end)
	end
end
function t1.VoiceChatFirstTimeUX(t8: {[any]: any}, p74) -- line: 931
	-- upvalues: v47 (copy), v18 (copy), v46 (copy), Constants2 (copy), GetFFlagNonVoiceFTUX (copy)
	if v47 and not t8:verifyUniverseAndPlaceCanUseVoice() then
		v18:debug("Universe/place is not voice enabled, do not run FTUX/STUX")

		return
	end

	if not v46 then
		local v218 = t8:FetchAgeVerificationOverlay()

		if type(v218) == "table" and v218.voiceSettings and v218.voiceSettings.seamlessVoiceStatus ~= Constants2.SEAMLESS_VOICE_STATUS_ENABLED_NEW_USER then
			v18:debug("User not eligible for FTUX/STUX")

			return
		end
	end

	local function startFTUX() -- line: 951
		-- upvalues: v18 (copy), t8 (copy), p74 (copy)
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p74)
	end

	if GetFFlagNonVoiceFTUX() then
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p74)

		return
	end

	t8:asyncInit():andThen(function() -- line: 959
		-- upvalues: t8 (copy), v18 (copy), p74 (copy)
		local connection = nil

		if t8.service.VoiceChatState and t8.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v18:debug("Starting FTUX")
			t8:_VoiceChatFirstTimeUX(p74)
		end

		connection = t8.service.StateChanged:Connect(function(_, newState) -- line: 967
			-- upvalues: v18 (copy), t8 (copy), p74 (copy), connection (ref)
			if newState == Enum.VoiceChatState.Joined then
				v18:debug("Starting FTUX")
				t8:_VoiceChatFirstTimeUX(p74)
				connection:Disconnect()
			end
		end)
	end):catch(function(p76) -- line: 974
		-- upvalues: v18 (copy)
		v18:trace("Failed to start FTUX: {}", p76)
	end)
end
function t1.HideFTUX(t9: {[any]: any}, p77) -- line: 980
	-- upvalues: Constants2 (copy), GetFFlagNonVoiceFTUX (copy), PromptType (copy)
	t9.isShowingFTUX = false
	t9.hideFTUXSignal:Fire()
	pcall(function() -- line: 983
		-- upvalues: p77 (copy), Constants2 (copy)
		p77:SetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY, "true")
		p77:Flush()
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
function t1._onUserAndPlaceCanUseVoiceResolved(p78, p79, p80) -- line: 997
	-- upvalues: GetInformedOfBan (copy), GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagEnableVoicePromptReasonText (copy)
	p78.bannedUntil = nil

	if p79 and p79.isBanned then
		local s6 = "GetRequest"
		local v226 = GetInformedOfBan(function(...) -- line: 735
			-- upvalues: p78 (copy), s6 (copy)
			return p78[s6](p78, ...)
		end)

		if v226 and not v226.informedOfBan then
			if GetFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() and p79.bannedUntil == nil then
				p78:ShowPlayerModeratedMessage()
			elseif p79.bannedUntil == nil then
				p78:showPrompt(PromptType.VoiceChatSuspendedPermanent)
			else
				p78.bannedUntil = p79.bannedUntil

				if p79.banReason == BAN_REASON.NUDGE_V3 then
					if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
						p78:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)
					else
						p78:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)
					end
				else
					p78:showPrompt(PromptType.VoiceChatSuspendedTemporary)
				end
			end
		end

		if v226 and v226.informedOfBan then
			p78:ShowPlayerModeratedMessage(true)

			return
		end
	else
		if p78.runService:IsStudio() and p79 and not p79.isVoiceEnabled then
			p78:showPrompt(PromptType.User)

			return
		end

		if p78.runService:IsStudio() and p80 and not p80.isPlaceEnabledForVoice then
			p78:showPrompt(PromptType.Place, GetFFlagEnableVoicePromptReasonText() and table.concat(p80.reasons or {}, "") or nil)
		end
	end
end
function t1.ChangeVoiceJoinProgress(p81, p82) -- line: 1045
	return p81.coreVoiceManager:ChangeVoiceJoinProgress(p82)
end
function t1.GetVoiceJoinProgress(p83) -- line: 1049
	return p83.coreVoiceManager.VoiceJoinProgress
end
function t1.UserOnlyEligibleForVoice(p84) -- line: 1053
	return p84.coreVoiceManager:UserOnlyEligibleForVoice()
end
function t1.UserOnlyEligibleForVoiceViaOverlay(p85) -- line: 1057
	return p85.coreVoiceManager:UserOnlyEligibleForVoiceViaOverlay()
end
function t1.UserVoiceEnabled(p86) -- line: 1061
	return p86.coreVoiceManager:UserVoiceEnabled()
end
function t1.UserInInExperienceUpsellTreatment(p87) -- line: 1065
	return p87.coreVoiceManager:UserInInExperienceUpsellTreatment()
end
function t1.UserEligibleForInExperienceUpsell(p88) -- line: 1069
	return p88.coreVoiceManager:UserEligibleForInExperienceUpsell()
end
function t1.ShowInExperienceVoiceUpsell(t10: {[any]: any}, s7: string) -- line: 1074
	-- upvalues: v69 (copy)
	local v237 = t10:FetchAgeVerificationOverlay()

	if v69 and type(v237) ~= "table" then
		return
	end

	local showVoiceInExperienceUpsellVariant = v237.showVoiceInExperienceUpsellVariant

	t10:SetInExpUpsellEntrypoint(s7)
	t10:showPrompt((t10:GetInExpUpsellPromptFromEnum(showVoiceInExperienceUpsellVariant)))
end
function t1.ShowInExperiencePhoneVoiceUpsell(t11: {[any]: any}, s8: string, s9: string) -- line: 1088
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
		onSuccessBeforeToast = function() -- line: 1105
			-- upvalues: t11 (copy), v106 (copy), s9 (copy)
			t11.coreVoiceManager:DisablePhoneVerificationUpsell()

			local v465 = v106
			local v466 = t11
			local s10 = "PostRequest"

			v465(function(...) -- line: 735
				-- upvalues: v466 (copy), s10 (copy)
				return v466[s10](v466, ...)
			end, s9, os.time(), false)
		end,
		onSuccess = function() -- line: 1109
			-- upvalues: t11 (copy), Constants2 (copy)
			if t11.pendingConnectionSource == nil then
				t11.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			t11:EnableVoice()
		end,
		closeUpsell = function() -- line: 1115
			-- upvalues: s8 (copy), Constants2 (copy), t11 (copy), PromptType (copy), v106 (copy), s9 (copy)
			if s8 ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				t11:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end

			local v468 = v106
			local v469 = t11
			local s11 = "PostRequest"

			v468(function(...) -- line: 735
				-- upvalues: v469 (copy), s11 (copy)
				return v469[s11](v469, ...)
			end, s9, os.time(), true)
		end
	})
end
function t1.DisablePhoneVerificationUpsell(p89) -- line: 1124
	p89.coreVoiceManager:DisablePhoneVerificationUpsell()
end
function t1.SetInExpUpsellEntrypoint(t12: {[any]: any}, s12: string) -- line: 1128
	t12.inExpUpsellEntrypoint = s12
end
function t1.userAndPlaceCanUseVoice(p90) -- line: 1132
	return p90.coreVoiceManager:userAndPlaceCanUseVoice()
end
function t1.verifyUniverseAndPlaceCanUseVoice(p91) -- line: 1136
	return p91.coreVoiceManager:verifyUniverseAndPlaceCanUseVoice()
end
function t1.GetVoiceConnectCookieValue(p92) -- line: 1140
	return p92.coreVoiceManager:GetVoiceConnectCookieValue()
end
function t1.GetVoiceConnectCookie(p93) -- line: 1144
	return p93.coreVoiceManager:GetVoiceConnectCookie()
end
function t1.SetVoiceConnectCookieValue(t13: {[any]: any}, b3: boolean) -- line: 1148
	return t13.coreVoiceManager:SetVoiceConnectCookieValue(b3)
end
function t1.GetVoiceRewarmCookie(p94) -- line: 1152
	return p94.coreVoiceManager:GetVoiceRewarmCookie()
end
function t1.SetVoiceRewarmCookie(t14: {[any]: any}, s13: string) -- line: 1156
	t14.coreVoiceManager:SetVoiceRewarmCookie(s13)
end
function t1.SetNewUserFTUXCookieValue(t15: {[any]: any}, b4: boolean) -- line: 1160
	return t15.coreVoiceManager:SetNewUserFTUXCookieValue(b4)
end
function t1.ShowPlayerModeratedMessage(t16: {[any]: any}, b5: boolean) -- line: 1164
	-- upvalues: GetUserSettings (copy), Analytics (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy)
	local s14 = "GetRequest"
	local v259 = GetUserSettings(function(...) -- line: 735
		-- upvalues: t16 (copy), s14 (copy)
		return t16[s14](t16, ...)
	end)

	if not v259 or not v259.isBanned then
		t16:_reportJoinFailed("PlayerModeratedBadState", Analytics.ERROR)

		return
	end

	t16.banReason = v259.banReason

	if v259.bannedUntil == nil then
		t16:showPrompt(PromptType.VoiceChatSuspendedPermanent)

		return
	end

	t16.bannedUntil = v259.bannedUntil

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
function t1.CheckCallState(p95) -- line: 1193
	return p95.coreVoiceManager:CheckCallState()
end
function t1.ShowVoiceChatLoadingMessage(p96) -- line: 1197
	-- upvalues: PromptType (copy)
	p96:showPrompt(PromptType.VoiceLoading)
end
function t1.requestMicPermission(p97) -- line: 1201
	return p97.coreVoiceManager:requestMicPermission()
end
function t1.canUseServiceAsync(p98) -- line: 1205
	return p98.coreVoiceManager:canUseServiceAsync()
end
function t1.canUseService(p99) -- line: 1210
	-- upvalues: HttpRbxApiService (copy), HttpService (copy), VOICE_CHAT_AVAILABILITY (copy)
	if p99.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		return false
	end

	local ok, result = pcall(function() -- line: 1214
		-- upvalues: HttpRbxApiService (copy), HttpService (copy)
		local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl("https://voice.roblox.com/v1/settings", Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)
	local v267 = ok and result.isVoiceEnabled

	if not v267 then
		p99.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable
	end

	return v267
end
function t1.ensureInitialized(p100, p101) -- line: 1230
	return p100.coreVoiceManager:ensureInitialized(p101)
end
function t1.GetSessionId(p102) -- line: 1235
	return p102.coreVoiceManager:GetSessionId()
end
function t1.GetChannelId(p103) -- line: 1239
	return p103.coreVoiceManager:GetChannelId()
end
function t1.JoinWithVoiceMuteData(p104, p105) -- line: 1243
	return p104.coreVoiceManager:JoinWithVoiceMuteData(p105)
end
function t1.calculateBanDuration(_: {[any]: any}, n3: number, n4: number) -- line: 1247
	return (math.ceil((n4 - n3) / 60))
end
function t1.ShowVoiceUI(p106) -- line: 1251
	-- upvalues: ExpChat (copy)
	p106.voiceUIVisible = true
	p106.showVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(true)
	end
end
function t1.HideVoiceUI(p107) -- line: 1260
	-- upvalues: ExpChat (copy)
	p107.voiceUIVisible = false
	p107.hideVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(false)
	end
end
function t1.createPromptInstance(p108, p109, p110) -- line: 1269
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), LocalizationService (copy), GetFFlagShowDevicePermissionsModal (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default3 (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy), Roact (copy), VoiceChatPrompt (copy), Analytics (copy), PostInformedOfBan (copy), Constants2 (copy), v51 (copy), GetFFlagJoinWithoutMicPermissions (copy), v18 (copy), CoreGui (copy)
	if p108.promptSignal then
		p108.promptSignal:Destroy()
		p108.promptSignal = nil
	end

	p108.promptSignal = Instance.new("BindableEvent")

	local errorText = nil

	if GetFFlagEnableVoicePromptReasonText() then
		errorText = p108.errorText
	end

	local v283 = p110 == PromptType.VoiceChatSuspendedTemporaryB

	if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
		v283 = v283 or p110 == PromptType.VoiceChatSuspendedTemporaryBV2
	end

	local s15 = ""

	if p108.bannedUntil ~= nil then
		s15 = if not v283 then DateTime.fromUnixTimestamp(p108.bannedUntil.Seconds):FormatLocalTime("l LT", LocalizationService.RobloxLocaleId) else tostring((p108:calculateBanDuration(DateTime.now().UnixTimestamp, p108.bannedUntil.Seconds)))
	end

	local v285 = p110 == PromptType.VoiceToxicityModal or (p110 == PromptType.VoiceToxicityToast or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (p110 == PromptType.VoiceToxicityModalV2 or p110 == PromptType.VoiceToxicityToastV2))
	local v286 = p110 == PromptType.VoiceConsentModalV1 or (p110 == PromptType.VoiceConsentModalV2 or p110 == PromptType.VoiceConsentModalV3)
	local u287 = false
	local u288 = nil

	if GetFFlagShowDevicePermissionsModal() and p110 == PromptType.DevicePermissionsModal and p108.settingsAppAvailable == nil then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function() -- line: 1318
					-- upvalues: u287 (ref), u288 (ref), default3 (copy), SettingsRoute (copy)
					local v472, v473 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

					u287 = v472
					u288 = v473
				end)

				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if u288 ~= nil then
					break
				end
			end
		else
			local v291, v292 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

			u287 = v291
			u288 = v292
		end

		p108.settingsAppAvailable = u287 and u288
	end

	p108.voiceChatPromptInstance = Roact.mount(Roact.createElement(VoiceChatPrompt, {
		Analytics = Analytics.new(),
		promptSignal = p108.promptSignal.Event,
		bannedUntil = s15,
		policyMapper = p108.policyMapper,
		errorText = errorText,
		onReadyForSignal = p109,
		VoiceChatServiceManager = p108,
		settingsAppAvailable = p108.settingsAppAvailable ~= nil and p108.settingsAppAvailable,
		onContinueFunc = if p110 ~= PromptType.VoiceChatSuspendedTemporary and not v283 then if not v285 then if not v286 then nil else function() -- line: 1357
			-- upvalues: p108 (copy), Constants2 (copy)
			p108:RecordUserSeenModal(Constants2.MODAL_IDS.IN_EXP_UPSELL)
		end else function() -- line: 1354
			-- upvalues: p108 (copy)
			p108.Analytics:reportClosedNudge(p108:GetNudgeAnalyticsData())
		end else function() -- line: 1351
			-- upvalues: PostInformedOfBan (copy), p108 (copy)
			local v474 = PostInformedOfBan
			local v475 = p108
			local s16 = "PostRequest"

			v474(function(...) -- line: 735
				-- upvalues: v475 (copy), s16 (copy)
				return v475[s16](v475, ...)
			end, true)
		end,
		onPrimaryActivated = if not v285 then if v51 or (not GetFFlagJoinWithoutMicPermissions() or p110 ~= PromptType.Permission) then if not GetFFlagJoinWithoutMicPermissions() or (not GetFFlagShowDevicePermissionsModal() or p110 ~= PromptType.DevicePermissionsModal) then if not v283 then if not v286 then nil else function() -- line: 1414
			-- upvalues: p108 (copy), Constants2 (copy)
			p108.Analytics:reportInExpConsent("accepted", p108.inExpUpsellEntrypoint, p108:GetInExpUpsellAnalyticsData())

			if p108.pendingConnectionSource == nil then
				p108.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			p108:EnableVoice()
		end else function() -- line: 1410
			-- upvalues: p108 (copy)
			p108:reportBanMessage("Understood")
			p108.Analytics:reportBanMessageEvent("Understood")
		end else function() -- line: 1389
			-- upvalues: v18 (copy), p108 (copy), default3 (copy), SettingsRoute (copy)
			v18:debug("Settings app available: {}", p108.settingsAppAvailable)
			p108.Analytics:reportDevicePermissionsModalEvent(not p108.settingsAppAvailable and "Acknowledged" or "OpenedSettings", p108:GetSessionId(), p108:GetInExpUpsellAnalyticsData())

			if p108.settingsAppAvailable then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp(SettingsRoute.Microphone):andThen(function() -- line: 1400
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1403
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1369
			-- upvalues: default3 (copy), v18 (copy)
			local v477 = default3:supportsSwitchToSettingsApp():await()

			v18:debug("Settings app available: {}", v477)

			if v477 then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp():andThen(function() -- line: 1375
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1378
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1362
			-- upvalues: p108 (copy)
			p108.Analytics:reportAcknowledgedNudge(p108:GetNudgeAnalyticsData())
		end,
		onSecondaryActivated = if p110 ~= PromptType.VoiceToxicityModal and (not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or p110 ~= PromptType.VoiceToxicityModalV2) then if not v285 then if not v283 then if not v286 then if p110 ~= PromptType.DevicePermissionsModal then nil else function() -- line: 1449
			-- upvalues: p108 (copy)
			p108.Analytics:reportDevicePermissionsModalEvent("Denied", p108:GetSessionId(), p108:GetInExpUpsellAnalyticsData())
		end else function() -- line: 1439
			-- upvalues: p108 (copy), Constants2 (copy), PromptType (copy)
			p108.Analytics:reportInExpConsent("denied", p108.inExpUpsellEntrypoint, p108:GetInExpUpsellAnalyticsData())

			if p108.inExpUpsellEntrypoint ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				p108:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end
		end else function() -- line: 1434
			-- upvalues: p108 (copy)
			p108:ShowVoiceToxicityFeedbackToast()
			p108:reportBanMessage("Denied")
			p108.Analytics:reportBanMessageEvent("Denied")
		end else function() -- line: 1431
			-- upvalues: p108 (copy)
			p108.Analytics:reportDeniedNudge(p108:GetNudgeAnalyticsData())
		end else function() -- line: 1427
			-- upvalues: p108 (copy)
			p108:ShowVoiceToxicityFeedbackToast()
			p108.Analytics:reportDeniedNudge(p108:GetNudgeAnalyticsData())
		end
	}), CoreGui, "RobloxVoiceChatPromptGui")
end
function t1.showPrompt(p111, p112, p113) -- line: 1463
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), v18 (copy)
	if GetFFlagEnableVoicePromptReasonText() then
		p111.errorText = p113 or nil
	end

	p111:createPromptInstance(function() -- line: 1467
		-- upvalues: v18 (copy), p112 (copy), p111 (copy)
		v18:debug("Show Prompt: {}", p112)
		p111.promptSignal:fire(p112)
	end, p112)
end
function t1.showJoinVoicePrompt(p114) -- line: 1473
	-- upvalues: PromptType (copy), AppStorageService (copy), Constants2 (copy)
	p114:showPrompt(PromptType.UnifiedJoinVoiceToast)
	pcall(function() -- line: 1475
		-- upvalues: AppStorageService (copy), Constants2 (copy)
		AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
		AppStorageService:Flush()
	end)
end
function t1.CheckAndShowPermissionPrompt(p115) -- line: 1481
	-- upvalues: GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy), GetFFlagEnableUniveralVoiceToasts (copy)
	local function showPrompt() -- line: 1482
		-- upvalues: p115 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy)
		local userEligible = p115.userEligible

		if p115.voiceEnabled or userEligible then
			if GetFFlagEnableSeamlessVoiceV2() or not GetFFlagJoinWithoutMicPermissions() then
				return p115.PermissionsService:hasPermissions({ PermissionsProtocol.Permissions.MICROPHONE_ACCESS }):andThen(function(p116) -- line: 1495
					-- upvalues: PermissionsProtocol (copy), p115 (copy), PromptType (copy)
					if p116 and p116.status == PermissionsProtocol.Status.DENIED then
						p115:showPrompt(PromptType.Permission)
					end
				end)
			end

			if p115.permissionState == PERMISSION_STATE.LISTEN_ONLY then
				p115:showPrompt(PromptType.Permission)
			end
		end

		return Promise.resolve()
	end

	if GetFFlagEnableUniveralVoiceToasts() then
		return showPrompt()
	end

	return p115:asyncInit():andThen(function() -- line: 1508
	end):catch(function() -- line: 1508
		-- upvalues: showPrompt (copy)
		return showPrompt()
	end)
end
function t1.showDataConsentToast(p117) -- line: 1514
	-- upvalues: GetFFlagSeamlessVoiceConsentToastPolicy (copy), UniversalAppPolicy (copy), SeamlessVoiceStatus (copy), Constants2 (copy), PromptType (copy)
	local v300 = p117:FetchAgeVerificationOverlay()
	local v301 = false

	if GetFFlagSeamlessVoiceConsentToastPolicy() then
		v301 = UniversalAppPolicy.getAppFeaturePolicies().getDisplayCheckboxInVoiceConsent() or false
	end

	local v302, showDataConsentToast

	if type(v300) == "table" then
		v302 = if not v300.voiceSettings then SeamlessVoiceStatus.Invalid else v300.voiceSettings.seamlessVoiceStatus
		showDataConsentToast = v300.showDataConsentToast
	else
		showDataConsentToast = false
		v302 = SeamlessVoiceStatus.Invalid
	end

	if showDataConsentToast and v301 then
		showDataConsentToast = type(p117:_GetShowAgeVerificationOverlay()) == "table" and p117:_GetShowAgeVerificationOverlay().showDataConsentToast
	end

	if v302 == SeamlessVoiceStatus.EnabledExistingUser and showDataConsentToast and v301 then
		p117:RecordUserSeenModal(Constants2.MODAL_IDS.DATA_CONSENT_TOAST)

		return p117:showPrompt(PromptType.VoiceDataConsentOptOutToast)
	end
end
function t1.CheckAndShowNotAudiblePrompt(p118) -- line: 1548
	-- upvalues: PromptType (copy), Promise (copy)
	if game:GetEngineFeature("VoiceChatSupported") then
		return p118:asyncInit():andThen(function() -- line: 1551
			-- upvalues: p118 (copy), PromptType (copy)
			if UserSettings().GameSettings.MasterVolume == 0 then
				p118:showPrompt(PromptType.NotAudible)
			end
		end):catch(function() -- line: 1557
		end)
	end

	return Promise.resolve()
end
function t1.ShowNotAudiblePromptVoiceChatVolume(p119) -- line: 1563
	-- upvalues: FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), Promise (copy), VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), PromptType (copy)
	if not FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast or not FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		return Promise.resolve()
	end

	if game:GetEngineFeature("VoiceChatSupported") then
		return p119:asyncInit():andThen(function() -- line: 1573
			-- upvalues: VoiceVolumeControlsEligibility (copy), VoiceChatService (copy), p119 (copy), PromptType (copy)
			if UserSettings().GameSettings.MasterVolume > 0 and (VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(true, VoiceChatService.UseNewAudioApi) and UserSettings().GameSettings.VoiceChatVolume == 0) then
				p119:showPrompt(PromptType.NotAudibleVoiceChatVolume)
			end
		end):catch(function() -- line: 1581
		end)
	end

	return Promise.resolve()
end
function t1.InitialJoinFailedPrompt(p120) -- line: 1586
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), PromptType (copy)
	v18:debug("JoinByGroupIdToken returns false")

	if not GetFFlagVoiceChatClientRewriteMasterLua then
		p120:showPrompt(PromptType.Retry)
	end
end
function t1.ShowVoiceToxicityFeedbackToast(p121) -- line: 1593
	-- upvalues: v18 (copy), PromptType (copy)
	v18:debug("Sending feedback toast")
	p121:showPrompt(PromptType.VoiceToxicityFeedbackToast)
end
function t1.GetNudgeAnalyticsData(p122) -- line: 1598
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p122:GetSessionId()
end
function t1.GetInExpUpsellAnalyticsData(_) -- line: 1602
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	local s17 = ""

	if EngineFeature then
		s17 = RbxAnalyticsService:GetPlaySessionId()
	end

	return game.GameId, game.PlaceId, s17
end
function t1.reportBanMessage(t18: {[any]: any}, s18: string) -- line: 1610
	-- upvalues: Players (copy)
	t18.Analytics:reportBanMessageEventV2(s18, t18.banReason, Players.LocalPlayer.UserId, not t18.service and "" or t18.previousSessionId)
end
function t1.reportJoinVoiceUpsellEvent(t19: {[any]: any}, s19: string, s20: string?, s21: string?) -- line: 1619
	-- upvalues: RbxAnalyticsService (copy), FFlagVoiceRewarmTelemetry (copy)
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()

	if FFlagVoiceRewarmTelemetry then
		t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled(), s20, s21)

		return
	end

	t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled())
end
function t1.SetAndSyncActive(t20: {[any]: any}, p124, b6: boolean) -- line: 1638
	t20.coreVoiceManager:SetAndSyncActive(p124, b6)
end
function t1.CreateAudioDeviceData(t21: {[any]: any}, p125) -- line: 1642
	return t21.coreVoiceManager:CreateAudioDeviceData(p125)
end
function t1.onInstanceAdded(t22: {[any]: any}, p126) -- line: 1646
	return t22.coreVoiceManager:onInstanceAdded(p126)
end
function t1.UpdateAudioDeviceInputDebugger(p127) -- line: 1650
	-- upvalues: v41 (copy), v18 (copy), Roact (copy), AudioDeviceInputDebugger (copy), CoreGui (copy)
	if v41 then
		if not p127.voiceDebuggerInstance then
			v18:debug("Mounting AudioDeviceInput Debugger")
			p127.voiceDebuggerInstance = Roact.mount(Roact.createElement(AudioDeviceInputDebugger, {
				instances = p127.audioDevices,
				mutedPlayers = p127.mutedPlayers
			}), CoreGui, "RobloxVoiceChatPromptGui")

			return
		end

		Roact.update(p127.voiceDebuggerInstance, Roact.createElement(AudioDeviceInputDebugger, {
			instances = p127.audioDevices,
			mutedPlayers = p127.mutedPlayers
		}))
	end
end
function t1.AddReverseNudgeToxicUser(t23: {[any]: any}, s22: string, p128, p129) -- line: 1674
	-- upvalues: GetFIntVoiceReverseNudgeUXDisplayTimeSeconds (copy)
	p128(s22, "iconColorChange")

	local v330 = t23.reverseNudgeToxicUserRemovalCallbacks[s22]

	if v330 ~= nil then
		task.cancel(v330)
	end

	local thread = task.delay(GetFIntVoiceReverseNudgeUXDisplayTimeSeconds(), function() -- line: 1688
		-- upvalues: p129 (copy), s22 (copy), t23 (copy)
		p129(s22)
		t23.reverseNudgeToxicUserRemovalCallbacks[s22] = nil
	end)

	t23.reverseNudgeToxicUserRemovalCallbacks[s22] = thread
end
function t1.onInstanceRemove(t24: {[any]: any}, p130) -- line: 1695
	return t24.coreVoiceManager:onInstanceRemove(p130)
end
function t1.hookupAudioDeviceInputListener(p131) -- line: 1699
	return p131.coreVoiceManager:hookupAudioDeviceInputListener()
end
function t1.ToggleMutePlayer(t25: {[any]: any}, n5: number, s23: string) -- line: 1703
	return t25.coreVoiceManager:ToggleMutePlayer(n5, s23)
end
function t1.MuteAll(t26: {[any]: any}, b7: boolean, s24: string) -- line: 1707
	return t26.coreVoiceManager:MuteAll(b7, s24)
end
function t1.ToggleMuteSome(t27: {[any]: any}, t28: {[any]: any}, b8: boolean, s25: string, s26: string) -- line: 1711
	return t27.coreVoiceManager:ToggleMuteSome(t28, b8, s25, s26)
end
function t1.FireMuteNonFriendsEvent(p132) -- line: 1720
	p132.mutedNonFriends:Fire()
end
function t1.EnsureCorrectMuteState(t29: {[any]: any}, t30: {[any]: any}, b9: boolean) -- line: 1724
	-- upvalues: VoiceChatService (copy), EngineFeature2 (copy), Players (copy)
	local t31 = {}

	for _, v352 in t30 do
		local v353 = t29.participants[tostring(v352)]

		if v353 and b9 ~= v353.isMutedLocally then
			if VoiceChatService.UseNewAudioApi then
				t31[v352] = true
				t29.mutedPlayers[v352] = b9
			else
				t29.service:SubscribePause(v352, b9)
			end

			v353.isMutedLocally = b9
			t29.participantsUpdate:Fire(t29.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v354 in t29.audioDevices do
			if v354.Player and t31[v354.Player.UserId] then
				if EngineFeature2 and v354.Player ~= Players.LocalPlayer then
					v354.MutedByLocalUser = b9
				else
					v354.Active = not b9
				end
			end
		end
	end
end
function t1.FireUserAgencySelectedEvent(t32: {[any]: any}, b10: boolean) -- line: 1756
	t32.userAgencySelected:Fire(b10)
end
function t1.ParticipantStateToIcon(_, p134, p135) -- line: 1760
	-- upvalues: VOICE_STATE (copy)
	local INACTIVE = VOICE_STATE.INACTIVE

	if not p134.subscriptionCompleted then
		INACTIVE = VOICE_STATE.CONNECTING
	elseif p134.isMutedLocally then
		INACTIVE = VOICE_STATE.LOCAL_MUTED
	elseif p134.isMuted then
		INACTIVE = VOICE_STATE.MUTED
	elseif p134.isSignalActive then
		INACTIVE = VOICE_STATE.TALKING
	end

	return getIcon(INACTIVE, p135)
end
function t1.VoiceStateToIcon(_, p137, p138, p139) -- line: 1775
	return getIcon(p137, p138, p139)
end
function t1.GetIcon(_, p141, p142) -- line: 1779
	return getIconSrc(p141, p142)
end
function t1.JoinVoice(p143, p144) -- line: 1783
	-- upvalues: FFlagVoiceRewarmTelemetry (copy), v65 (copy), v18 (copy), v69 (copy), Constants2 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), GetFFlagUpdateVoiceConnectionToasts (copy), PromptType (copy), GetFFlagNonVoiceFTUX (copy), AppStorageService (copy), GetFFlagEnableVrVoiceParity (copy), Promise (copy), v50 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v54 (copy), GetFFlagDisableConsentModalForExistingUsers (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), getOverlayStore (copy), OverlayTypes (copy), SocialUpsellType (copy), Enum2 (copy), v48 (copy)
	local joinVoiceButtonContext = nil
	local s27 = nil

	if FFlagVoiceRewarmTelemetry then
		joinVoiceButtonContext = p143.joinVoiceButtonContext
		p143.joinVoiceButtonContext = nil
	end

	if v65 then
		v18:debug("Consuming voice re-warm cookie on JoinVoice")
		p143:SetVoiceRewarmCookie("true")
	end

	local v372 = p143:FetchAgeVerificationOverlay()
	local v373 = ((if not v69 then v372.showVoiceInExperienceUpsellVariant else (if type(v372) ~= "table" then nil else v372.showVoiceInExperienceUpsellVariant))) or Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3

	if not FFlagVoiceRewarmTelemetry then
		p143.Analytics:reportJoinVoiceButtonEvent("clicked", p143:GetInExpUpsellAnalyticsData())
	end

	if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p143.previousGroupId then
		if FFlagVoiceRewarmTelemetry then
			s27 = "RejoinPreviousChannel"
		end

		p143:RejoinPreviousChannel()

		if GetFFlagEnableVoiceTrustedConnectionsToasts() then
			p143:showJoinVoicePrompt()
		elseif GetFFlagUpdateVoiceConnectionToasts() then
			p143:showPrompt(PromptType.UnifiedJoinVoiceToast)
		else
			p143:showPrompt(PromptType.JoinVoice)
		end

		p143:ShowVoiceUI()
		p143:SetVoiceConnectCookieValue(true)
	elseif GetFFlagNonVoiceFTUX() and p143.isShowingFTUX then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ExitFtux"
		end

		p143:HideFTUX(AppStorageService)
	elseif p143.deniedMicPermissions then
		if FFlagVoiceRewarmTelemetry then
			s27 = "MicPermissionPrompt"
		end

		if GetFFlagEnableVrVoiceParity() then
			p143:CheckAndShowPermissionPrompt()
		else
			p143:CheckAndShowPermissionPrompt():finallyReturn(Promise.reject())
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p143:UserVoiceEnabled() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FirstJoinSession"
		end

		if v50 then
			p143.isInitialJoin = true
		end

		p143.attemptVoiceRejoin:Fire()

		if GetFFlagEnableSeamlessVoiceV2() and p143:IsNewSeamlessVoiceUserDisconnect() then
			p143:SetVoiceConnectCookieValue(true)
			p143:SetNewUserFTUXCookieValue(true)
		end
	elseif v54 and p143:UserOnlyEligibleForVoiceViaOverlay() or p143:UserOnlyEligibleForVoice() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ConsentModal"
		end

		if GetFFlagDisableConsentModalForExistingUsers() and p143:IsSeamlessVoice() then
			p143:EnableVoice()
		else
			p143:SetInExpUpsellEntrypoint(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE)
			p143:showPrompt((p143:GetInExpUpsellPromptFromEnum(v373)))
		end
	elseif p143:EligibleForAgeCheckToast() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "AgeCheckToast"
		end

		p143:showPrompt(PromptType.AgeCheckForVoiceToast)
	elseif GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not p143:UserVoiceEnabled() and p143:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		if FFlagVoiceRewarmTelemetry then
			s27 = "PhoneUpsell"
		end

		if p144 then
			p144:SetVisibility(false, true)
		end

		p143:ShowInExperiencePhoneVoiceUpsell(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE, Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER)
	elseif p143:EligibleForFaeUpsell() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FaeUpsell"
		end

		if p143.pendingConnectionSource == nil then
			p143.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		end

		p143.coreVoiceManager:OptUserToJoinVoice()

		local v374 = getOverlayStore(false)

		if not FFlagVoiceRewarmTelemetry then
			p143:reportJoinVoiceUpsellEvent("Click")
		end

		v374.setCurrentOverlay(OverlayTypes.SocialUpsell, {
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
		local v375, v376, v377 = p143:GetInExpUpsellAnalyticsData()

		p143.Analytics:reportJoinVoiceButtonEvent("clicked", v375, v376, v377, joinVoiceButtonContext, s27)
		p143:reportJoinVoiceUpsellEvent("Click", joinVoiceButtonContext, s27)
	end

	if v48 and p143:IsSeamlessVoice() then
		task.spawn(function() -- line: 1925
			-- upvalues: p143 (copy)
			p143.coreVoiceManager:PostUserVoiceConnectionStatus(true)
		end)
	end
end
function t1.EligibleForFaeUpsell(p145) -- line: 1931
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy)
	local v379 = GetFFlagEnableVoiceUxUpdates()

	if v379 then
		v379 = p145.coreVoiceManager:EligibleForFaeUpsell()

		if v379 then
			v379 = p145.AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

			if v379 then
				if FFlagTestDeviceForFAEUpsell then
					return (deviceMeetsRequirementsForFAE())
				end

				v379 = true
			end
		end
	end

	return v379
end
function t1.EligibleForAgeCheckToast(p146) -- line: 1938
	return p146.coreVoiceManager:EligibleForAgeCheckToast()
end
function t1.ShouldShowJoinVoice(p147) -- line: 1943
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagVoiceRewarmTelemetry (copy), VoiceChatCore (copy), v65 (copy), GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		if FFlagVoiceRewarmTelemetry then
			if p147:EligibleForFaeUpsell() then
				p147.joinVoiceButtonContext = "FaeUpsell"

				return true
			end

			if p147:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p147:GetVoiceConnectCookie() == "" then
				p147.joinVoiceButtonContext = "VoiceFtux"

				return true
			end

			if v65 and p147:GetVoiceRewarmCookie() == "" and p147:GetVoiceConnectCookie() == "false" and p147:UserVoiceEnabled() then
				p147.joinVoiceButtonContext = "Rewarm"

				return true
			end
		elseif p147:EligibleForFaeUpsell() or p147:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p147:GetVoiceConnectCookie() == "" or v65 and p147:GetVoiceRewarmCookie() == "" and p147:VoiceChatEnded() then
			return true
		end
	elseif GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses() then
		if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p147:IsSeamlessVoice() and p147:verifyUniverseAndPlaceCanUseVoice() then
			return not p147.voiceUIVisible
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p147:IsSeamlessVoice() then
		return not p147.voiceUIVisible
	end

	if p147:EligibleForAgeCheckToast() then
		return true
	end

	local v382 = p147:UserInInExperienceUpsellTreatment()
	local v383 = p147:UserOnlyEligibleForVoice() or p147:UserVoiceEnabled()

	if GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not v383 and not p147:UserVoiceEnabled() and p147:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		return true
	end

	return v382 and v383
end
function t1.ShouldShowJoinVoiceOnDisconnect(p148) -- line: 2022
	return p148.coreVoiceManager:ShouldShowJoinVoiceOnDisconnect()
end
function t1.IsSeamlessVoice(p149) -- line: 2026
	-- upvalues: GetFFlagCheckUniversePlaceBeforeSuspending (copy), v18 (copy), SeamlessVoiceStatus (copy)
	if GetFFlagCheckUniversePlaceBeforeSuspending() then
		return p149.coreVoiceManager:IsSeamlessVoice()
	end

	local v386 = p149:FetchAgeVerificationOverlay()

	if not v386 or not v386.voiceSettings then
		v18:error("VoiceChatServiceManager:IsSeamlessVoice() - ageVerificationOverlayData or voiceSettings is nil")

		return false
	end

	local seamlessVoiceStatus = v386.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == SeamlessVoiceStatus.EnabledNewUser
end
function t1.HasSeamlessVoiceFeature(p150, p151) -- line: 2042
	return p150.coreVoiceManager:HasSeamlessVoiceFeature(p151)
end
function t1.IsNewSeamlessVoiceUserDisconnect(p152) -- line: 2046
	return p152.coreVoiceManager:IsNewSeamlessVoiceUserDisconnect()
end
function t1.GetConnectDisconnectButtonAnalyticsData(t33: {[any]: any}, b11: boolean) -- line: 2050
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
function t1.GetConnectDisconnectAnalyticsData(p153) -- line: 2062
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
		t35.voiceSessionId = not p153.service and "" or p153:GetSessionId()
	else
		t35.voiceSessionId = p153:GetSessionId()
	end

	t35.durationTimestamp = default:getTimestamp()

	return t35
end
function t1.Leave(p154) -- line: 2082
	-- upvalues: GetFFlagDisconnectToastClientRewrite (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v48 (copy)
	p154:ensureInitialized("leave")

	if GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p154:SetVoiceConnectCookieValue(false)
	end

	p154.Analytics:reportConnectDisconnectEvents("voiceDisconnectEvent", p154:GetConnectDisconnectAnalyticsData())

	local GroupId = p154.service:GetGroupId()
	local v400 = p154.service:IsPublishPaused()

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		local VoiceChatService2 = game:GetService("VoiceChatService")

		if VoiceChatService2 then
			VoiceChatService2:leaveVoice()
		end
	else
		p154.service:Leave()
	end

	p154:HideVoiceUI()
	p154.previousGroupId = GroupId
	p154.previousMutedState = v400

	if not GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p154:SetVoiceConnectCookieValue(false)
	end

	if v48 and p154:IsSeamlessVoice() then
		task.spawn(function() -- line: 2105
			-- upvalues: p154 (copy)
			p154.coreVoiceManager:PostUserVoiceConnectionStatus(false)
		end)
	end
end
function t1.GetVoiceStateFromEnum(_, p156) -- line: 2111
	-- upvalues: t2 (ref), VOICE_STATE (copy)
	if not t2[p156] then
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

	return t2[p156]
end
function t1.GetInExpUpsellPromptFromEnum(_: {[any]: any}, s30: string) -- line: 2131
	-- upvalues: t3 (copy)
	return t3[s30]
end
function t1.getRecentUsersInteractionData(p157) -- line: 2136
	return p157.coreVoiceManager:getRecentUsersInteractionData()
end
function t1._setRecentUserState(p158, p159, p160) -- line: 2140
	return p158.coreVoiceManager:_setRecentUserState(p159, p160)
end
function t1._updateRecentUsersInteractionData(p161) -- line: 2144
	return p161.coreVoiceManager:_updateRecentUsersInteractionData()
end
function t1.SetupParticipantListeners(p162) -- line: 2148
	return p162.coreVoiceManager:SetupParticipantListeners()
end
function t1.Disconnect(p163) -- line: 2152
	p163.coreVoiceManager:Disconnect()
	p163.coreVoiceManager:unsubscribeAll()
end
function t1.GetSendMuteEvent(p164) -- line: 2157
	return p164.coreVoiceManager:GetSendMuteEvent()
end
function t1.ToggleMic(t37: {[any]: any}, s31: string?) -- line: 2162
	return t37.coreVoiceManager:ToggleMic(s31)
end
function t1.SubscribeRetry(t38: {[any]: any}, n6: number) -- line: 2166
	-- upvalues: v18 (copy)
	t38:ensureInitialized("subscribe retry")
	v18:debug("Attempting to retry connection to user: {}", "..." .. string.sub(tostring(n6), -4))
	t38.service:SubscribeRetry(n6)
end
function t1.JoinByGroupIdToken(p165, p166, p167) -- line: 2172
	return p165.coreVoiceManager:JoinByGroupIdToken(p166, p167)
end
function t1.RejoinPreviousChannel(p168) -- line: 2176
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy)
	local previousGroupId = p168.previousGroupId
	local previousMutedState = p168.previousMutedState

	v18:debug("Rejoining previous channel {} with mute status {}", previousGroupId, previousMutedState)
	pcall(function() -- line: 2181
		-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), p168 (copy), previousGroupId (copy), previousMutedState (copy)
		if GetFFlagVoiceChatClientRewriteMasterLua() then
			p168.coreVoiceManager:RejoinVoice()

			local ConnectDisconnectAnalyticsData = p168:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p168.pendingConnectionSource
			p168.pendingConnectionSource = nil
			p168.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p168.voiceConnectEventReportedForActiveSession = true

			return
		end

		if previousGroupId and previousGroupId ~= "" then
			p168.service:Leave()

			if not p168.service:JoinByGroupIdToken(previousGroupId, previousMutedState, true) then
				p168:InitialJoinFailedPrompt()

				return
			end

			local ConnectDisconnectAnalyticsData = p168:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p168.pendingConnectionSource
			p168.pendingConnectionSource = nil
			p168.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p168.voiceConnectEventReportedForActiveSession = true
		end
	end)
end
function t1.SwitchDevice(_, p170, p171, p172) -- line: 2207
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy), v18 (copy)
	if p170 == VOICE_CHAT_DEVICE_TYPE.Input then
		SoundService:SetInputDevice(p171, p172)
		v18:info("[InputDeviceSelection] Setting SS Mic Device To {} {}", p171, p172)

		return
	end

	SoundService:SetOutputDevice(p171, p172)
	v18:info("[OutputDeviceSelection] Setting SS Speaker Device To {} {}", p171, p172)
end
function t1.GetDevices(_, p174) -- line: 2217
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
	local ok, result, v432, v433 = pcall(function() -- line: 2218
		-- upvalues: p174 (copy), VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
		if p174 == VOICE_CHAT_DEVICE_TYPE.Input then
			return SoundService:GetInputDevices()
		end

		return SoundService:GetOutputDevices()
	end)

	return ok, result, v432, v433
end
function t1.VoiceChatAvailable(p175) -- line: 2229
	-- upvalues: MIN_VOICE_CHAT_API_VERSION (copy), VOICE_CHAT_AVAILABILITY (copy)
	local service = p175.service

	if p175.available == nil and service then
		p175.version = service:GetVoiceChatApiVersion()

		if p175.version >= MIN_VOICE_CHAT_API_VERSION then
			p175.available = service:GetVoiceChatAvailable()

			while p175.available == VOICE_CHAT_AVAILABILITY.Checking do
				wait(1)
				p175.available = service:GetVoiceChatAvailable()
			end
		end
	end

	if service then
		return p175.version >= MIN_VOICE_CHAT_API_VERSION and p175.available == VOICE_CHAT_AVAILABILITY.Available
	end

	return false
end
function t1.VoiceChatEnded(p176) -- line: 2249
	-- upvalues: v52 (copy)
	if p176.service then
		local VoiceChatState = p176.service.VoiceChatState

		if v52 then
			return VoiceChatState == Enum.VoiceChatState.Ended
		end

		return VoiceChatState == Enum.VoiceChatState.Ended or VoiceChatState == Enum.VoiceChatState.Idle
	end

	return true
end
function t1.UnmountPrompt(p177) -- line: 2261
	-- upvalues: Roact (copy)
	if p177.voiceChatPromptInstance ~= nil then
		Roact.unmount(p177.voiceChatPromptInstance)
		p177.voiceChatPromptInstance = nil
	end
end

t1.default = t1.new(CoreVoiceManager.default, nil, HttpRbxApiService, PermissionsProtocol.default, BlockingUtility:GetAfterBlockedStatusChangedEvent())

return t1
