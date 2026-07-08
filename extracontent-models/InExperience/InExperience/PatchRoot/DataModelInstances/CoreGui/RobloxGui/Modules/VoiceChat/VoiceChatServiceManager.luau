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
local v59 = game:DefineFastInt("SeamlessVoiceSTUXDisplayCount", 3)
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
local GetFFlagShowDevicePermissionsModal = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagShowDevicePermissionsModal
local FFlagEnableRetryForLinkingProtocolFetch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableRetryForLinkingProtocolFetch
local v63 = game:DefineFastFlag("ShowJoinVoiceWhenDisconnectedV3", false)
local FFlagVoiceRewarmTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagVoiceRewarmTelemetry
local v65 = game:DefineFastFlag("GuardVoiceInExpUpsellVariant", false)
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
local v96 = if not GetFFlagAvatarChatServiceEnabled() then nil else game:GetService("AvatarChatService")
local v97 = if not GetFFlagEnableVoiceChatMuteForVideoCaptures() then nil else game:GetService("CaptureService")
local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
local default3 = require(CorePackages.Workspace.Packages.LinkingProtocol).LinkingProtocol.default
local SettingsRoute = require(CorePackages.Workspace.Packages.LinkingProtocol).Enums.SettingsRoute
local v101 = if not GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then nil else require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneUpsellController
local v102 = if not GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() then nil else require(CorePackages.Workspace.Packages.PhoneUpsell).Http.Requests.PostPhoneUpsellDisplayed
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
	AvatarChatService = v96,
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
	CaptureService = v97
}
local v122 = LuauPolyfill.Set.new({
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

v122:add("_mutedAnyone")
v122:add("muteAllChanged")

local t2 = {}
local t3 = {
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT1] = PromptType.VoiceConsentModalV1,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT2] = PromptType.VoiceConsentModalV2,
	[Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3] = PromptType.VoiceConsentModalV3
}

function getIconSrc(p1, p2) -- line: 344
	return "rbxasset://textures/ui/VoiceChat/" .. (p2 and p2 .. "/" or "") .. p1 .. ".png"
end
function getIcon(p3, p4, p5) -- line: 349
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
		local v132 = math.floor(0.5 + 5 * (p4 or math.random())) * 20

		return p4 and getIconSrc("Unmuted" .. tostring(v132), p5) or getIconSrc("Blank", p5)
	end

	return getIconSrc("Error", p5)
end

t1.__index = t1

function t1.__index(p6, p7) -- line: 367
	-- upvalues: v122 (copy), t1 (copy)
	if v122:has(p7) then
		return p6.coreVoiceManager[p7]
	end

	return (rawget(t1, p7))
end
function t1.__newindex(p8, p9, p10) -- line: 374
	-- upvalues: v122 (copy), t1 (copy)
	if v122:has(p9) then
		p8.coreVoiceManager[p9] = p10

		return
	end

	rawset(t1, p9, p10)
end
function t1.new(p11, p12, p13, p14, p15, p16, p17, p18, p19, p20) -- line: 382
	-- upvalues: Analytics (copy), getCamMicPermissions (copy), t1 (copy), WATCHED_MESSAGE_TYPES (copy), GetFIntThrottleParticipantsUpdateMs (copy), IXPServiceWrapper (copy), v57 (copy), v58 (copy), GetFFlagExpChatUseVoiceParticipantsStore (copy), ExpChat (copy), GetFFlagEnableUniveralVoiceToasts (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v44 (copy), v41 (copy), FFlagEnablePartyVoiceChangersInLua (copy), MicrophoneDevicePermissionsLogging (copy), VOICE_JOIN_PROGRESS (copy), Constants2 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), v53 (copy), PromptType (copy), v45 (copy), v18 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), AppStorageService (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagShowDevicePermissionsModal (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), GetFFlagNonVoiceFTUX (copy), GetFFlagUpdateVoiceConnectionToasts (copy), v50 (copy), GetFFlagEnableVoiceChatMuteForVideoCaptures (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), default2 (copy)
	local v148 = setmetatable({
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

	for _, v150 in WATCHED_MESSAGE_TYPES do
		v148.SignalREventTable[v150] = Instance.new("BindableEvent")
	end

	v148.shouldThrottleParticipantUpdate = false
	v148.participantsStateThrottleTime = 0
	v148.lastParticipantsStateUpdate = 0
	v148.lastStateUpdateCounter = 0
	v148.reverseNudgeToxicUserRemovalCallbacks = {}

	if GetFIntThrottleParticipantsUpdateMs() > 0 then
		v148.participantsStateThrottleTime = GetFIntThrottleParticipantsUpdateMs() / 1000

		local ok, result = pcall(function() -- line: 423
			-- upvalues: IXPServiceWrapper (copy), v57 (copy)
			return IXPServiceWrapper:GetLayerData(v57)
		end)

		if ok and result and result[v58] then
			v148.shouldThrottleParticipantUpdate = true
		end
	end

	v148.MuteStatusIcons = {
		MicOn = v148:GetIcon("Unmuted0", "SpeakerLight"),
		MicOff = v148:GetIcon("Muted", "SpeakerLight"),
		MicDisabled = v148:GetIcon("Muted", "SpeakerLight"),
		Loading = v148:GetIcon("Connecting", "SpeakerLight"),
		Error = v148:GetIcon("Error", "SpeakerLight")
	}
	v148.PlayerMuteStatusIcons = {
		MicOn = v148:GetIcon("Unmuted0", "MicLight"),
		MicOff = v148:GetIcon("Muted", "MicLight"),
		MicDisabled = v148:GetIcon("Muted", "MicLight"),
		Loading = v148:GetIcon("Connecting", "MicLight"),
		Error = v148:GetIcon("Error", "MicLight")
	}

	local u153 = false
	local connection = v148.attemptVoiceRejoin.Event:Connect(function() -- line: 449
		-- upvalues: u153 (ref)
		u153 = true
	end)
	local v155 = if not GetFFlagExpChatUseVoiceParticipantsStore() then nil else ExpChat.Stores.GetVoiceStore(false)

	v148.coreVoiceManager:subscribe("GetPermissions", function(p21, p22, p23, p24) -- line: 456
		-- upvalues: v148 (copy)
		local s1 = "VoiceChatServiceManager.requestMicPermission"

		if v148.inExpUpsellEntrypoint ~= nil then
			s1 = v148.inExpUpsellEntrypoint
		end

		v148.getPermissionsFunction(p21, p22, p23, s1, p24)
	end)
	v148.coreVoiceManager:subscribe("OnVoiceParticipantRemoved", function(p25) -- line: 463
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v155 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v155.handleVoiceParticipantRemoved(p25)

			return
		end

		if ExpChat.Events.VoiceParticipantRemoved then
			ExpChat.Events.VoiceParticipantRemoved((tostring(p25)))
		end
	end)
	v148.coreVoiceManager:subscribe("OnVoiceParticipantAdded", function(p26) -- line: 470
		-- upvalues: GetFFlagExpChatUseVoiceParticipantsStore (copy), v155 (copy), ExpChat (copy)
		if GetFFlagExpChatUseVoiceParticipantsStore() then
			v155.handleVoiceParticipantAdded(p26)

			return
		end

		if ExpChat.Events.VoiceParticipantAdded then
			ExpChat.Events.VoiceParticipantAdded((tostring(p26)))
		end
	end)
	v148.coreVoiceManager:subscribe("OnVoiceParticipantToggleMuted", function(p27, p28) -- line: 477
		-- upvalues: ExpChat (copy)
		if ExpChat.Events.VoiceParticipantToggleMuted then
			ExpChat.Events.VoiceParticipantToggleMuted(tostring(p27), p28)
		end
	end)
	v148.coreVoiceManager:subscribe("OnUserAndPlaceCanUseVoiceResolved", function(p29, p30) -- line: 482
		-- upvalues: v148 (copy)
		v148:_onUserAndPlaceCanUseVoiceResolved(p29, p30)
	end)
	v148.coreVoiceManager:subscribe("OnRequestMicPermissionResolved", function() -- line: 485
		-- upvalues: GetFFlagEnableUniveralVoiceToasts (copy), v148 (copy)
		if GetFFlagEnableUniveralVoiceToasts() then
			return v148:CheckAndShowNotAudiblePrompt()
		end
	end)
	v148.coreVoiceManager:subscribe("OnRequestMicPermissionRejected", function() -- line: 490
		-- upvalues: GetFFlagEnableSeamlessVoiceV2 (copy), v148 (copy), GetFFlagEnableUniveralVoiceToasts (copy), v44 (copy)
		if GetFFlagEnableSeamlessVoiceV2() and v148:IsSeamlessVoice() then
			v148.deniedMicPermissions = true
		end

		if GetFFlagEnableUniveralVoiceToasts() and not v44 then
			return v148:CheckAndShowPermissionPrompt()
		end
	end)

	if v41 then
		v148.coreVoiceManager:subscribe("OnDevicePlayerChanged", function() -- line: 501
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
		v148.coreVoiceManager:subscribe("OnDeviceActiveChanged", function() -- line: 504
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
		v148.coreVoiceManager:subscribe("OnDeviceMuteChanged", function() -- line: 507
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)

		if FFlagEnablePartyVoiceChangersInLua then
			v148.coreVoiceManager:subscribe("OnVoiceChangerChanged", function() -- line: 511
				-- upvalues: v148 (copy)
				v148:UpdateAudioDeviceInputDebugger()
			end)
		end

		v148.coreVoiceManager:subscribe("OnPlayerMuted", function() -- line: 515
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
		v148.coreVoiceManager:subscribe("OnAudioDeviceInputAdded", function() -- line: 518
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
		v148.coreVoiceManager:subscribe("OnAudioDeviceInputRemoved", function() -- line: 521
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
		v148.coreVoiceManager:subscribe("OnDeviceMutedByLocalUserChanged", function() -- line: 524
			-- upvalues: v148 (copy)
			v148:UpdateAudioDeviceInputDebugger()
		end)
	end

	v148.coreVoiceManager:subscribe("OnStateChanged", function(_, p32) -- line: 528
		-- upvalues: MicrophoneDevicePermissionsLogging (copy), v148 (copy), VOICE_JOIN_PROGRESS (copy), Constants2 (copy), u153 (ref), connection (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), v53 (copy), PromptType (copy)
		MicrophoneDevicePermissionsLogging:setClientSessionId(v148.coreVoiceManager:GetSessionId())

		if p32 == Enum.VoiceChatState.Ended or p32 == Enum.VoiceChatState.Failed then
			v148.voiceConnectEventReportedForActiveSession = false
		end

		if p32 == Enum.VoiceChatState.Joined and v148:GetVoiceJoinProgress() == VOICE_JOIN_PROGRESS.Idle and not v148.voiceConnectEventReportedForActiveSession then
			local ConnectDisconnectAnalyticsData = v148:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = Constants2.VOICE_CONNECTION_SOURCE.AUTO_CONNECT
			v148.pendingConnectionSource = nil
			v148.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			v148.voiceConnectEventReportedForActiveSession = true
			u153 = false
			connection:Disconnect()
		end

		local v445 = p32 == Enum.VoiceChatState.Ended

		if v445 then
			local ConnectDisconnectAnalyticsData = v148:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.disconnectReason = v148.pendingDisconnectReason or Constants2.VOICE_DISCONNECT_REASON.SYSTEM
			v148.Analytics:reportConnectDisconnectEvents("voiceDisconnectReasonEvent", ConnectDisconnectAnalyticsData)
			v148.pendingDisconnectReason = nil
		end

		if v445 and v148.bannedUntil == nil then
			if not GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
				v148:HideVoiceUI()
			end

			if v53 and v148.runService:IsStudio() then
				return
			end

			v148:showPrompt(PromptType.LeaveVoice)
		end
	end)
	v148.coreVoiceManager:subscribe("OnVoiceChatServiceInitialized", function() -- line: 567
		-- upvalues: v148 (copy), v45 (copy), v18 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), AppStorageService (copy), Constants2 (copy), PromptType (copy)
		v148:ShowVoiceUI()

		if v45 then
			v18:debug("Simulating join voice")
			v148:simulateVoiceConnectDisconnect()
		end

		if GetFFlagEnableVoiceTrustedConnectionsToasts() and not v148.coreVoiceManager.initializedPostSuspension then
			local ok, result = pcall(function() -- line: 575
				-- upvalues: AppStorageService (copy), Constants2 (copy)
				return AppStorageService:GetItem(Constants2.VOICE_WITH_TC_TOAST_KEY) == "true"
			end)

			if ok and not result then
				v148:showPrompt(PromptType.UpdateOnAutoJoinToast)
				pcall(function() -- line: 582
					-- upvalues: AppStorageService (copy), Constants2 (copy)
					AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
					AppStorageService:Flush()
				end)
			end
		end
	end)
	v148.coreVoiceManager:subscribe("OnInitialJoinFailed", function() -- line: 590
		-- upvalues: v148 (copy)
		v148:InitialJoinFailedPrompt()
	end)
	v148.coreVoiceManager:subscribe("OnPlayerModerated", function() -- line: 593
		-- upvalues: v148 (copy), Constants2 (copy)
		v148.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.MODERATED
		v148:ShowPlayerModeratedMessage()
	end)
	v148.coreVoiceManager:subscribe("OnRetryRequested", function() -- line: 598
		-- upvalues: v148 (copy), PromptType (copy)
		v148:showPrompt(PromptType.Retry)
	end)
	v148.coreVoiceManager:subscribe("OnVoiceToxicityModal", function() -- line: 601
		-- upvalues: v18 (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v148 (copy), PromptType (copy)
		v18:debug("Showing Voice Toxicity Modal")

		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			v148:showPrompt(PromptType.VoiceToxicityModalV2)

			return
		end

		v148:showPrompt(PromptType.VoiceToxicityModal)
	end)
	v148.coreVoiceManager:subscribe("OnVoiceToxicityToast", function() -- line: 609
		-- upvalues: v18 (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v148 (copy), PromptType (copy)
		v18:debug("Showing Voice Toxicity Toast")

		if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
			v148:showPrompt(PromptType.VoiceToxicityToastV2)

			return
		end

		v148:showPrompt(PromptType.VoiceToxicityToast)
	end)
	v148.coreVoiceManager:subscribe("OnPermissionRequested", function() -- line: 617
		-- upvalues: GetFFlagShowDevicePermissionsModal (copy), v148 (copy), PromptType (copy)
		if GetFFlagShowDevicePermissionsModal() then
			v148:showPrompt(PromptType.DevicePermissionsModal)

			return
		end

		v148:showPrompt(PromptType.Permission)
	end)
	v148.coreVoiceManager:subscribe("OnShowDataConsentToast", function() -- line: 624
		-- upvalues: GetFFlagEnableSeamlessVoiceDataConsentToast (copy), v148 (copy)
		if GetFFlagEnableSeamlessVoiceDataConsentToast() then
			v148:showDataConsentToast()
		end
	end)
	v148.coreVoiceManager:subscribe("OnVoiceReverseNudgeIconColorChange", function(p33) -- line: 629
		-- upvalues: v18 (copy), ExpChat (copy), v148 (copy)
		v18:debug("Showing Reverse Nudge Icon Color Change")

		if ExpChat.Events.AddReverseNudgeToxicUser and ExpChat.Events.RemoveReverseNudgeToxicUser then
			v148:AddReverseNudgeToxicUser(p33.toxicUserId, ExpChat.Events.AddReverseNudgeToxicUser, ExpChat.Events.RemoveReverseNudgeToxicUser)
		end
	end)
	v148.coreVoiceManager.setVoiceUIVisibility.Event:Connect(function(b1: boolean) -- line: 639
		-- upvalues: v148 (copy)
		if b1 then
			v148:ShowVoiceUI()

			return
		end

		v148:HideVoiceUI()
	end)
	v148.coreVoiceManager:subscribe("OnVoiceJoin", function() -- line: 646
		-- upvalues: GetFFlagNonVoiceFTUX (copy), v148 (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), GetFFlagUpdateVoiceConnectionToasts (copy), PromptType (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v50 (copy), GetFFlagEnableVoiceChatMuteForVideoCaptures (copy), GetFFlagEnableCrossExperienceVoiceCaptureMute (copy), default2 (copy), u153 (ref), connection (copy)
		if GetFFlagNonVoiceFTUX() and v148.hasLeftFTUX then
			v148.hasLeftFTUX = false

			if GetFFlagEnableVoiceTrustedConnectionsToasts() then
				v148:showJoinVoicePrompt()
			elseif GetFFlagUpdateVoiceConnectionToasts() then
				v148:showPrompt(PromptType.UnifiedJoinVoiceToast)
			else
				v148:showPrompt(PromptType.JoinedVoiceToast)
			end

			v148.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxLeaveEvent", v148:GetConnectDisconnectAnalyticsData())
		elseif GetFFlagEnableSeamlessVoiceV2() and v148:IsSeamlessVoice() then
			if GetFFlagEnableVoiceTrustedConnectionsToasts() then
				v148:showJoinVoicePrompt()
			elseif GetFFlagUpdateVoiceConnectionToasts() then
				v148:showPrompt(PromptType.UnifiedJoinVoiceToast)
			elseif v50 and v148.isInitialJoin then
				v148:showPrompt(PromptType.JoinedVoiceToast)
			else
				v148:showPrompt(PromptType.JoinVoice)
			end

			v148:SetVoiceConnectCookieValue(true)
		else
			v148:showPrompt(PromptType.VoiceConsentAcceptedToast)
		end

		if GetFFlagEnableVoiceChatMuteForVideoCaptures() and v148.CaptureService:IsCapturingVideo() then
			if GetFFlagEnableCrossExperienceVoiceCaptureMute() then
				default2:MuteAll("Capture")
				v148:HideVoiceUI()
			else
				v148:MuteAll(true, "Capture")
				v148:HideVoiceUI()
			end
		end

		if u153 then
			local ConnectDisconnectAnalyticsData = v148:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = v148.pendingConnectionSource
			v148.pendingConnectionSource = nil
			v148.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			v148.voiceConnectEventReportedForActiveSession = true
			u153 = false
			connection:Disconnect()
		end
	end)

	return v148
end

local function shorten(p34) -- line: 702
	return "..." .. string.sub(tostring(p34), -4)
end
local function bind(p35, p36) -- line: 706
	return function(...) -- line: 707
		-- upvalues: p35 (copy), p36 (copy)
		return p35[p36](p35, ...)
	end
end

function t1.subscribe(p37, p38, p39) -- line: 712
	return p37.coreVoiceManager:subscribe(p38, p39)
end
function t1._reportJoinFailed(p40, p41, p42) -- line: 716
	return p40.coreVoiceManager:_reportJoinFailed(p41, p42)
end
function t1._asyncInit(p43) -- line: 720
	return p43.coreVoiceManager:_asyncInit()
end
function t1.asyncInit(p44) -- line: 724
	return p44.coreVoiceManager:asyncInit()
end
function t1.CheckAudioInputExists(p45) -- line: 728
	return p45.coreVoiceManager:CheckAudioInputExists()
end
function t1.getService(p46) -- line: 732
	return p46.service
end
function t1.GetMutedAnyone(p47) -- line: 736
	return p47.coreVoiceManager:GetMutedAnyone()
end
function t1.GetRequest(p48, p49, p50) -- line: 740
	return p48.coreVoiceManager:GetRequest(p49, p50)
end
function t1.PostRequest(p51, p52, _, p54) -- line: 744
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 745
		-- upvalues: p51 (copy), p52 (copy), p54 (copy), HttpService (copy)
		local v452 = p51.HttpRbxApiService:PostAsyncFullUrl(p52, p54, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(v452)
	end)

	return ok and result
end
function t1._GetShowAgeVerificationOverlay(p55, p56) -- line: 766
	return p55.coreVoiceManager:_GetShowAgeVerificationOverlay(p56)
end
function t1.simulateVoiceConnectDisconnect(p57) -- line: 770
	-- upvalues: v49 (copy), v18 (copy)
	task.spawn(function() -- line: 771
		-- upvalues: v49 (copy), p57 (copy), v18 (copy)
		while true do
			task.wait(v49)

			if p57.voiceUIVisible then
				v18:debug("Hiding Voice")
				p57:HideVoiceUI()
			else
				v18:debug("Showing Voice")
				p57:ShowVoiceUI()
			end
		end
	end)
end
function t1.FetchAgeVerificationOverlay(p58, p59) -- line: 785
	return p58.coreVoiceManager:FetchAgeVerificationOverlay(p59)
end
function t1.FetchPhoneVerificationUpsell(t4: {[any]: any}, s2: string, n1: number?, b2: boolean?) -- line: 789
	return t4.coreVoiceManager:FetchPhoneVerificationUpsell(s2, n1, b2)
end
function t1.RecordUserSeenModal(t5: {[any]: any}, s3: string) -- line: 797
	-- upvalues: PostRecordUserSeenGeneralModal (copy)
	local s4 = "PostRequest"

	return PostRecordUserSeenGeneralModal(function(...) -- line: 707
		-- upvalues: t5 (copy), s4 (copy)
		return t5[s4](t5, ...)
	end, s3)
end
function t1.checkAndUpdateSequence(t6: {[any]: any}, s5: string, n2: number) -- line: 801
	return t6.coreVoiceManager:checkAndUpdateSequence(s5, n2)
end
function t1.onMissedSequence(p60, p61) -- line: 805
	return p60.coreVoiceManager:onMissedSequence(p61)
end
function t1.watchSignalR(p62) -- line: 809
	return p62.coreVoiceManager:watchSignalR()
end
function t1.voicePermissionGranted(p63, p64) -- line: 817
	return p63.coreVoiceManager:voicePermissionGranted(p64)
end
function t1.GetSignalREvent(p65, p66) -- line: 821
	return p65.coreVoiceManager:GetSignalREvent(p66)
end
function t1.avatarChatUserAndPlaceSettingsValueOfClientFeatures(p67, p68) -- line: 826
	return p67.coreVoiceManager:avatarChatUserAndPlaceSettingsValueOfClientFeatures(p68)
end
function t1.resolveAvatarChatUserAndPlaceSettings(p69) -- line: 830
	return p69.coreVoiceManager:resolveAvatarChatUserAndPlaceSettings()
end
function t1.EnableVoice(p70) -- line: 834
	return p70.coreVoiceManager:EnableVoice()
end
function t1._VoiceChatFirstTimeUX(t7: {[any]: any}, p71) -- line: 838
	-- upvalues: Constants2 (copy), v18 (copy), GetFFlagNonVoiceFTUX (copy), ExpChat (copy), GetFFlagEnableFtuxExitOnMuteToggle (copy), v59 (copy), v47 (copy), PromptType (copy)
	local u207 = nil
	local u208 = nil

	if not pcall(function() -- line: 840
		-- upvalues: p71 (copy), Constants2 (copy), u207 (ref), u208 (ref)
		local Item = p71:GetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY)
		local Item2 = p71:GetItem(Constants2.SEAMLESS_VOICE_STUX_KEY)

		u207 = Item == "true"
		u208 = if Item2 ~= nil then tonumber(Item2) else 0
	end) then
		v18:warning("Failed to read FTUX/STUX from AppStorage")

		return
	end

	v18:trace("hasShownFTUX: {}. STUXCount: {}", u207, u208)

	if not u207 then
		v18:debug("Showing FTUX")
		t7.isShowingFTUX = true
		t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxJoinEvent", t7:GetConnectDisconnectAnalyticsData())

		if GetFFlagNonVoiceFTUX() then
			ExpChat.Events.VoiceUIVisibilityChanged(true)
		else
			t7:MuteAll(true, "FTUX")
			t7.muteAllChanged.Event:Once(function() -- line: 866
				-- upvalues: t7 (copy), p71 (copy)
				t7:HideFTUX(p71)
				t7.Analytics:reportConnectDisconnectEvents("voiceConnectFtuxLeaveEvent", t7:GetConnectDisconnectAnalyticsData())
			end)
			t7.talkingChanged.Event:Once(function() -- line: 873
				-- upvalues: t7 (copy), p71 (copy)
				t7:HideFTUX(p71)
			end)

			if GetFFlagEnableFtuxExitOnMuteToggle() then
				t7.coreVoiceManager.onPlayerMuteToggled.Event:Once(function() -- line: 877
					-- upvalues: t7 (copy), p71 (copy)
					t7:HideFTUX(p71)
				end)
			end
		end
	elseif u208 < v59 and (not v47 or t7:GetVoiceConnectCookieValue()) then
		v18:debug("Showing STUX")
		t7:showPrompt(PromptType.JoinVoiceSTUX)
		pcall(function() -- line: 888
			-- upvalues: p71 (copy), Constants2 (copy), u208 (ref)
			p71:SetItem(Constants2.SEAMLESS_VOICE_STUX_KEY, (tostring(u208 + 1)))
			p71:Flush()
		end)
	end
end
function t1.VoiceChatFirstTimeUX(t8: {[any]: any}, p72) -- line: 895
	-- upvalues: v47 (copy), v18 (copy), v46 (copy), Constants2 (copy), GetFFlagNonVoiceFTUX (copy)
	if v47 and not t8:verifyUniverseAndPlaceCanUseVoice() then
		v18:debug("Universe/place is not voice enabled, do not run FTUX/STUX")

		return
	end

	if not v46 then
		local v211 = t8:FetchAgeVerificationOverlay()

		if type(v211) == "table" and v211.voiceSettings and v211.voiceSettings.seamlessVoiceStatus ~= Constants2.SEAMLESS_VOICE_STATUS_ENABLED_NEW_USER then
			v18:debug("User not eligible for FTUX/STUX")

			return
		end
	end

	local function startFTUX() -- line: 915
		-- upvalues: v18 (copy), t8 (copy), p72 (copy)
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p72)
	end

	if GetFFlagNonVoiceFTUX() then
		v18:debug("Starting FTUX")
		t8:_VoiceChatFirstTimeUX(p72)

		return
	end

	t8:asyncInit():andThen(function() -- line: 923
		-- upvalues: t8 (copy), v18 (copy), p72 (copy)
		local connection = nil

		if t8.service.VoiceChatState and t8.service.VoiceChatState == Enum.VoiceChatState.Joined then
			v18:debug("Starting FTUX")
			t8:_VoiceChatFirstTimeUX(p72)
		end

		connection = t8.service.StateChanged:Connect(function(_, newState) -- line: 931
			-- upvalues: v18 (copy), t8 (copy), p72 (copy), connection (ref)
			if newState == Enum.VoiceChatState.Joined then
				v18:debug("Starting FTUX")
				t8:_VoiceChatFirstTimeUX(p72)
				connection:Disconnect()
			end
		end)
	end):catch(function(p74) -- line: 938
		-- upvalues: v18 (copy)
		v18:trace("Failed to start FTUX: {}", p74)
	end)
end
function t1.HideFTUX(t9: {[any]: any}, p75) -- line: 944
	-- upvalues: Constants2 (copy), GetFFlagNonVoiceFTUX (copy), PromptType (copy)
	t9.isShowingFTUX = false
	t9.hideFTUXSignal:Fire()
	pcall(function() -- line: 947
		-- upvalues: p75 (copy), Constants2 (copy)
		p75:SetItem(Constants2.SEAMLESS_VOICE_FTUX_KEY, "true")
		p75:Flush()
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
function t1._onUserAndPlaceCanUseVoiceResolved(p76, p77, p78) -- line: 961
	-- upvalues: GetInformedOfBan (copy), GetFFlagAvatarChatServiceEnabled (copy), GetFFlagVoiceChatServiceManagerUseAvatarChat (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagEnableVoicePromptReasonText (copy)
	p76.bannedUntil = nil

	if p77 and p77.isBanned then
		local s6 = "GetRequest"
		local v219 = GetInformedOfBan(function(...) -- line: 707
			-- upvalues: p76 (copy), s6 (copy)
			return p76[s6](p76, ...)
		end)

		if v219 and not v219.informedOfBan then
			if GetFFlagAvatarChatServiceEnabled() and GetFFlagVoiceChatServiceManagerUseAvatarChat() and p77.bannedUntil == nil then
				p76:ShowPlayerModeratedMessage()
			elseif p77.bannedUntil == nil then
				p76:showPrompt(PromptType.VoiceChatSuspendedPermanent)
			else
				p76.bannedUntil = p77.bannedUntil

				if p77.banReason == BAN_REASON.NUDGE_V3 then
					if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() then
						p76:showPrompt(PromptType.VoiceChatSuspendedTemporaryBV2)
					else
						p76:showPrompt(PromptType.VoiceChatSuspendedTemporaryB)
					end
				else
					p76:showPrompt(PromptType.VoiceChatSuspendedTemporary)
				end
			end
		end

		if v219 and v219.informedOfBan then
			p76:ShowPlayerModeratedMessage(true)

			return
		end
	else
		if p76.runService:IsStudio() and p77 and not p77.isVoiceEnabled then
			p76:showPrompt(PromptType.User)

			return
		end

		if p76.runService:IsStudio() and p78 and not p78.isPlaceEnabledForVoice then
			p76:showPrompt(PromptType.Place, GetFFlagEnableVoicePromptReasonText() and table.concat(p78.reasons or {}, "") or nil)
		end
	end
end
function t1.ChangeVoiceJoinProgress(p79, p80) -- line: 1009
	return p79.coreVoiceManager:ChangeVoiceJoinProgress(p80)
end
function t1.GetVoiceJoinProgress(p81) -- line: 1013
	return p81.coreVoiceManager.VoiceJoinProgress
end
function t1.UserOnlyEligibleForVoice(p82) -- line: 1017
	return p82.coreVoiceManager:UserOnlyEligibleForVoice()
end
function t1.UserOnlyEligibleForVoiceViaOverlay(p83) -- line: 1021
	return p83.coreVoiceManager:UserOnlyEligibleForVoiceViaOverlay()
end
function t1.UserVoiceEnabled(p84) -- line: 1025
	return p84.coreVoiceManager:UserVoiceEnabled()
end
function t1.UserInInExperienceUpsellTreatment(p85) -- line: 1029
	return p85.coreVoiceManager:UserInInExperienceUpsellTreatment()
end
function t1.UserEligibleForInExperienceUpsell(p86) -- line: 1033
	return p86.coreVoiceManager:UserEligibleForInExperienceUpsell()
end
function t1.ShowInExperienceVoiceUpsell(t10: {[any]: any}, s7: string) -- line: 1038
	-- upvalues: v65 (copy)
	local v230 = t10:FetchAgeVerificationOverlay()

	if v65 and type(v230) ~= "table" then
		return
	end

	local showVoiceInExperienceUpsellVariant = v230.showVoiceInExperienceUpsellVariant

	t10:SetInExpUpsellEntrypoint(s7)
	t10:showPrompt((t10:GetInExpUpsellPromptFromEnum(showVoiceInExperienceUpsellVariant)))
end
function t1.ShowInExperiencePhoneVoiceUpsell(t11: {[any]: any}, s8: string, s9: string) -- line: 1052
	-- upvalues: v101 (copy), GetFFlagInExperiencePhoneUpsellNewCopy (copy), v102 (copy), Constants2 (copy), PromptType (copy)
	t11:SetInExpUpsellEntrypoint(s8)
	v101.openPhoneUpsell({
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
		onSuccessBeforeToast = function() -- line: 1069
			-- upvalues: t11 (copy), v102 (copy), s9 (copy)
			t11.coreVoiceManager:DisablePhoneVerificationUpsell()

			local v457 = v102
			local v458 = t11
			local s10 = "PostRequest"

			v457(function(...) -- line: 707
				-- upvalues: v458 (copy), s10 (copy)
				return v458[s10](v458, ...)
			end, s9, os.time(), false)
		end,
		onSuccess = function() -- line: 1073
			-- upvalues: t11 (copy), Constants2 (copy)
			if t11.pendingConnectionSource == nil then
				t11.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			t11:EnableVoice()
		end,
		closeUpsell = function() -- line: 1079
			-- upvalues: s8 (copy), Constants2 (copy), t11 (copy), PromptType (copy), v102 (copy), s9 (copy)
			if s8 ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				t11:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end

			local v460 = v102
			local v461 = t11
			local s11 = "PostRequest"

			v460(function(...) -- line: 707
				-- upvalues: v461 (copy), s11 (copy)
				return v461[s11](v461, ...)
			end, s9, os.time(), true)
		end
	})
end
function t1.DisablePhoneVerificationUpsell(p87) -- line: 1088
	p87.coreVoiceManager:DisablePhoneVerificationUpsell()
end
function t1.SetInExpUpsellEntrypoint(t12: {[any]: any}, s12: string) -- line: 1092
	t12.inExpUpsellEntrypoint = s12
end
function t1.userAndPlaceCanUseVoice(p88) -- line: 1096
	return p88.coreVoiceManager:userAndPlaceCanUseVoice()
end
function t1.verifyUniverseAndPlaceCanUseVoice(p89) -- line: 1100
	return p89.coreVoiceManager:verifyUniverseAndPlaceCanUseVoice()
end
function t1.GetVoiceConnectCookieValue(p90) -- line: 1104
	return p90.coreVoiceManager:GetVoiceConnectCookieValue()
end
function t1.GetVoiceConnectCookie(p91) -- line: 1108
	return p91.coreVoiceManager:GetVoiceConnectCookie()
end
function t1.SetVoiceConnectCookieValue(t13: {[any]: any}, b3: boolean) -- line: 1112
	return t13.coreVoiceManager:SetVoiceConnectCookieValue(b3)
end
function t1.GetVoiceRewarmCookie(p92) -- line: 1116
	return p92.coreVoiceManager:GetVoiceRewarmCookie()
end
function t1.SetVoiceRewarmCookie(t14: {[any]: any}, s13: string) -- line: 1120
	t14.coreVoiceManager:SetVoiceRewarmCookie(s13)
end
function t1.SetNewUserFTUXCookieValue(t15: {[any]: any}, b4: boolean) -- line: 1124
	return t15.coreVoiceManager:SetNewUserFTUXCookieValue(b4)
end
function t1.ShowPlayerModeratedMessage(t16: {[any]: any}, b5: boolean) -- line: 1128
	-- upvalues: GetUserSettings (copy), Analytics (copy), PromptType (copy), BAN_REASON (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy)
	local s14 = "GetRequest"
	local v252 = GetUserSettings(function(...) -- line: 707
		-- upvalues: t16 (copy), s14 (copy)
		return t16[s14](t16, ...)
	end)

	if not v252 or not v252.isBanned then
		t16:_reportJoinFailed("PlayerModeratedBadState", Analytics.ERROR)

		return
	end

	t16.banReason = v252.banReason

	if v252.bannedUntil == nil then
		t16:showPrompt(PromptType.VoiceChatSuspendedPermanent)

		return
	end

	t16.bannedUntil = v252.bannedUntil

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
function t1.CheckCallState(p93) -- line: 1157
	return p93.coreVoiceManager:CheckCallState()
end
function t1.ShowVoiceChatLoadingMessage(p94) -- line: 1161
	-- upvalues: PromptType (copy)
	p94:showPrompt(PromptType.VoiceLoading)
end
function t1.requestMicPermission(p95) -- line: 1165
	return p95.coreVoiceManager:requestMicPermission()
end
function t1.canUseServiceAsync(p96) -- line: 1169
	return p96.coreVoiceManager:canUseServiceAsync()
end
function t1.canUseService(p97) -- line: 1174
	-- upvalues: HttpRbxApiService (copy), HttpService (copy), VOICE_CHAT_AVAILABILITY (copy)
	if p97.available ~= nil or not game:GetEngineFeature("VoiceChatSupported") then
		return false
	end

	local ok, result = pcall(function() -- line: 1178
		-- upvalues: HttpRbxApiService (copy), HttpService (copy)
		local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl("https://voice.roblox.com/v1/settings", Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

		return HttpService:JSONDecode(AsyncFullUrl)
	end)
	local v260 = ok and result.isVoiceEnabled

	if not v260 then
		p97.available = VOICE_CHAT_AVAILABILITY.UserNotAvailable
	end

	return v260
end
function t1.ensureInitialized(p98, p99) -- line: 1194
	return p98.coreVoiceManager:ensureInitialized(p99)
end
function t1.GetSessionId(p100) -- line: 1199
	return p100.coreVoiceManager:GetSessionId()
end
function t1.GetChannelId(p101) -- line: 1203
	return p101.coreVoiceManager:GetChannelId()
end
function t1.JoinWithVoiceMuteData(p102, p103) -- line: 1207
	return p102.coreVoiceManager:JoinWithVoiceMuteData(p103)
end
function t1.calculateBanDuration(_: {[any]: any}, n3: number, n4: number) -- line: 1211
	return (math.ceil((n4 - n3) / 60))
end
function t1.ShowVoiceUI(p104) -- line: 1215
	-- upvalues: ExpChat (copy)
	p104.voiceUIVisible = true
	p104.showVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(true)
	end
end
function t1.HideVoiceUI(p105) -- line: 1224
	-- upvalues: ExpChat (copy)
	p105.voiceUIVisible = false
	p105.hideVoiceUI:Fire()

	if ExpChat.Events.VoiceUIVisibilityChanged then
		ExpChat.Events.VoiceUIVisibilityChanged(false)
	end
end
function t1.createPromptInstance(p106, p107, p108) -- line: 1233
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), LocalizationService (copy), GetFFlagShowDevicePermissionsModal (copy), FFlagEnableRetryForLinkingProtocolFetch (copy), FIntLinkingProtocolFetchRetries (copy), default3 (copy), SettingsRoute (copy), FIntLinkingProtocolFetchTimeoutMS (copy), Roact (copy), VoiceChatPrompt (copy), Analytics (copy), PostInformedOfBan (copy), Constants2 (copy), v51 (copy), GetFFlagJoinWithoutMicPermissions (copy), v18 (copy), CoreGui (copy)
	if p106.promptSignal then
		p106.promptSignal:Destroy()
		p106.promptSignal = nil
	end

	p106.promptSignal = Instance.new("BindableEvent")

	local errorText = nil

	if GetFFlagEnableVoicePromptReasonText() then
		errorText = p106.errorText
	end

	local v276 = p108 == PromptType.VoiceChatSuspendedTemporaryB

	if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
		v276 = v276 or p108 == PromptType.VoiceChatSuspendedTemporaryBV2
	end

	local s15 = ""

	if p106.bannedUntil ~= nil then
		s15 = if not v276 then DateTime.fromUnixTimestamp(p106.bannedUntil.Seconds):FormatLocalTime("l LT", LocalizationService.RobloxLocaleId) else tostring((p106:calculateBanDuration(DateTime.now().UnixTimestamp, p106.bannedUntil.Seconds)))
	end

	local v278 = p108 == PromptType.VoiceToxicityModal or (p108 == PromptType.VoiceToxicityToast or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (p108 == PromptType.VoiceToxicityModalV2 or p108 == PromptType.VoiceToxicityToastV2))
	local v279 = p108 == PromptType.VoiceConsentModalV1 or (p108 == PromptType.VoiceConsentModalV2 or p108 == PromptType.VoiceConsentModalV3)
	local u280 = false
	local u281 = nil

	if GetFFlagShowDevicePermissionsModal() and p108 == PromptType.DevicePermissionsModal and p106.settingsAppAvailable == nil then
		if FFlagEnableRetryForLinkingProtocolFetch then
			for _ = 0, FIntLinkingProtocolFetchRetries do
				local thread = task.spawn(function() -- line: 1282
					-- upvalues: u280 (ref), u281 (ref), default3 (copy), SettingsRoute (copy)
					local v464, v465 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

					u280 = v464
					u281 = v465
				end)

				task.wait(FIntLinkingProtocolFetchTimeoutMS / 1000)
				task.cancel(thread)

				if u281 ~= nil then
					break
				end
			end
		else
			local v284, v285 = default3:supportsSwitchToSettingsApp(SettingsRoute.Microphone):await()

			u280 = v284
			u281 = v285
		end

		p106.settingsAppAvailable = u280 and u281
	end

	p106.voiceChatPromptInstance = Roact.mount(Roact.createElement(VoiceChatPrompt, {
		Analytics = Analytics.new(),
		promptSignal = p106.promptSignal.Event,
		bannedUntil = s15,
		policyMapper = p106.policyMapper,
		errorText = errorText,
		onReadyForSignal = p107,
		VoiceChatServiceManager = p106,
		settingsAppAvailable = p106.settingsAppAvailable ~= nil and p106.settingsAppAvailable,
		onContinueFunc = if p108 ~= PromptType.VoiceChatSuspendedTemporary and not v276 then if not v278 then if not v279 then nil else function() -- line: 1321
			-- upvalues: p106 (copy), Constants2 (copy)
			p106:RecordUserSeenModal(Constants2.MODAL_IDS.IN_EXP_UPSELL)
		end else function() -- line: 1318
			-- upvalues: p106 (copy)
			p106.Analytics:reportClosedNudge(p106:GetNudgeAnalyticsData())
		end else function() -- line: 1315
			-- upvalues: PostInformedOfBan (copy), p106 (copy)
			local v466 = PostInformedOfBan
			local v467 = p106
			local s16 = "PostRequest"

			v466(function(...) -- line: 707
				-- upvalues: v467 (copy), s16 (copy)
				return v467[s16](v467, ...)
			end, true)
		end,
		onPrimaryActivated = if not v278 then if v51 or (not GetFFlagJoinWithoutMicPermissions() or p108 ~= PromptType.Permission) then if not GetFFlagJoinWithoutMicPermissions() or (not GetFFlagShowDevicePermissionsModal() or p108 ~= PromptType.DevicePermissionsModal) then if not v276 then if not v279 then nil else function() -- line: 1378
			-- upvalues: p106 (copy), Constants2 (copy)
			p106.Analytics:reportInExpConsent("accepted", p106.inExpUpsellEntrypoint, p106:GetInExpUpsellAnalyticsData())

			if p106.pendingConnectionSource == nil then
				p106.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
			end

			p106:EnableVoice()
		end else function() -- line: 1374
			-- upvalues: p106 (copy)
			p106:reportBanMessage("Understood")
			p106.Analytics:reportBanMessageEvent("Understood")
		end else function() -- line: 1353
			-- upvalues: v18 (copy), p106 (copy), default3 (copy), SettingsRoute (copy)
			v18:debug("Settings app available: {}", p106.settingsAppAvailable)
			p106.Analytics:reportDevicePermissionsModalEvent(not p106.settingsAppAvailable and "Acknowledged" or "OpenedSettings", p106:GetSessionId(), p106:GetInExpUpsellAnalyticsData())

			if p106.settingsAppAvailable then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp(SettingsRoute.Microphone):andThen(function() -- line: 1364
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1367
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1333
			-- upvalues: default3 (copy), v18 (copy)
			local v469 = default3:supportsSwitchToSettingsApp():await()

			v18:debug("Settings app available: {}", v469)

			if v469 then
				v18:debug("Switching to settings app")
				default3:switchToSettingsApp():andThen(function() -- line: 1339
					-- upvalues: v18 (copy)
					v18:debug("Successfully switched to settings app")
				end):catch(function() -- line: 1342
					-- upvalues: v18 (copy)
					v18:error("Error switching to settings app")
				end)

				return
			end

			v18:debug("Current platform does not support switching to settings app")
		end else function() -- line: 1326
			-- upvalues: p106 (copy)
			p106.Analytics:reportAcknowledgedNudge(p106:GetNudgeAnalyticsData())
		end,
		onSecondaryActivated = if p108 ~= PromptType.VoiceToxicityModal and (not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or p108 ~= PromptType.VoiceToxicityModalV2) then if not v278 then if not v276 then if not v279 then if p108 ~= PromptType.DevicePermissionsModal then nil else function() -- line: 1413
			-- upvalues: p106 (copy)
			p106.Analytics:reportDevicePermissionsModalEvent("Denied", p106:GetSessionId(), p106:GetInExpUpsellAnalyticsData())
		end else function() -- line: 1403
			-- upvalues: p106 (copy), Constants2 (copy), PromptType (copy)
			p106.Analytics:reportInExpConsent("denied", p106.inExpUpsellEntrypoint, p106:GetInExpUpsellAnalyticsData())

			if p106.inExpUpsellEntrypoint ~= Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE then
				p106:showPrompt(PromptType.VoiceConsentDeclinedToast)
			end
		end else function() -- line: 1398
			-- upvalues: p106 (copy)
			p106:ShowVoiceToxicityFeedbackToast()
			p106:reportBanMessage("Denied")
			p106.Analytics:reportBanMessageEvent("Denied")
		end else function() -- line: 1395
			-- upvalues: p106 (copy)
			p106.Analytics:reportDeniedNudge(p106:GetNudgeAnalyticsData())
		end else function() -- line: 1391
			-- upvalues: p106 (copy)
			p106:ShowVoiceToxicityFeedbackToast()
			p106.Analytics:reportDeniedNudge(p106:GetNudgeAnalyticsData())
		end
	}), CoreGui, "RobloxVoiceChatPromptGui")
end
function t1.showPrompt(p109, p110, p111) -- line: 1427
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), v18 (copy)
	if GetFFlagEnableVoicePromptReasonText() then
		p109.errorText = p111 or nil
	end

	p109:createPromptInstance(function() -- line: 1431
		-- upvalues: v18 (copy), p110 (copy), p109 (copy)
		v18:debug("Show Prompt: {}", p110)
		p109.promptSignal:fire(p110)
	end, p110)
end
function t1.showJoinVoicePrompt(p112) -- line: 1437
	-- upvalues: PromptType (copy), AppStorageService (copy), Constants2 (copy)
	p112:showPrompt(PromptType.UnifiedJoinVoiceToast)
	pcall(function() -- line: 1439
		-- upvalues: AppStorageService (copy), Constants2 (copy)
		AppStorageService:SetItem(Constants2.VOICE_WITH_TC_TOAST_KEY, "true")
		AppStorageService:Flush()
	end)
end
function t1.CheckAndShowPermissionPrompt(p113) -- line: 1445
	-- upvalues: GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy), GetFFlagEnableUniveralVoiceToasts (copy)
	local function showPrompt() -- line: 1446
		-- upvalues: p113 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), GetFFlagJoinWithoutMicPermissions (copy), PERMISSION_STATE (copy), PromptType (copy), PermissionsProtocol (copy), Promise (copy)
		local userEligible = p113.userEligible

		if p113.voiceEnabled or userEligible then
			if GetFFlagEnableSeamlessVoiceV2() or not GetFFlagJoinWithoutMicPermissions() then
				return p113.PermissionsService:hasPermissions({ PermissionsProtocol.Permissions.MICROPHONE_ACCESS }):andThen(function(p114) -- line: 1459
					-- upvalues: PermissionsProtocol (copy), p113 (copy), PromptType (copy)
					if p114 and p114.status == PermissionsProtocol.Status.DENIED then
						p113:showPrompt(PromptType.Permission)
					end
				end)
			end

			if p113.permissionState == PERMISSION_STATE.LISTEN_ONLY then
				p113:showPrompt(PromptType.Permission)
			end
		end

		return Promise.resolve()
	end

	if GetFFlagEnableUniveralVoiceToasts() then
		return showPrompt()
	end

	return p113:asyncInit():andThen(function() -- line: 1472
	end):catch(function() -- line: 1472
		-- upvalues: showPrompt (copy)
		return showPrompt()
	end)
end
function t1.showDataConsentToast(p115) -- line: 1478
	-- upvalues: GetFFlagSeamlessVoiceConsentToastPolicy (copy), UniversalAppPolicy (copy), SeamlessVoiceStatus (copy), Constants2 (copy), PromptType (copy)
	local v293 = p115:FetchAgeVerificationOverlay()
	local v294 = false

	if GetFFlagSeamlessVoiceConsentToastPolicy() then
		v294 = UniversalAppPolicy.getAppFeaturePolicies().getDisplayCheckboxInVoiceConsent() or false
	end

	local v295, showDataConsentToast

	if type(v293) == "table" then
		v295 = if not v293.voiceSettings then SeamlessVoiceStatus.Invalid else v293.voiceSettings.seamlessVoiceStatus
		showDataConsentToast = v293.showDataConsentToast
	else
		showDataConsentToast = false
		v295 = SeamlessVoiceStatus.Invalid
	end

	if showDataConsentToast and v294 then
		showDataConsentToast = type(p115:_GetShowAgeVerificationOverlay()) == "table" and p115:_GetShowAgeVerificationOverlay().showDataConsentToast
	end

	if v295 == SeamlessVoiceStatus.EnabledExistingUser and showDataConsentToast and v294 then
		p115:RecordUserSeenModal(Constants2.MODAL_IDS.DATA_CONSENT_TOAST)

		return p115:showPrompt(PromptType.VoiceDataConsentOptOutToast)
	end
end
function t1.CheckAndShowNotAudiblePrompt(p116) -- line: 1512
	-- upvalues: PromptType (copy), Promise (copy)
	if game:GetEngineFeature("VoiceChatSupported") then
		return p116:asyncInit():andThen(function() -- line: 1515
			-- upvalues: p116 (copy), PromptType (copy)
			if UserSettings().GameSettings.MasterVolume == 0 then
				p116:showPrompt(PromptType.NotAudible)
			end
		end):catch(function() -- line: 1521
		end)
	end

	return Promise.resolve()
end
function t1.InitialJoinFailedPrompt(p117) -- line: 1526
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), PromptType (copy)
	v18:debug("JoinByGroupIdToken returns false")

	if not GetFFlagVoiceChatClientRewriteMasterLua then
		p117:showPrompt(PromptType.Retry)
	end
end
function t1.ShowVoiceToxicityFeedbackToast(p118) -- line: 1533
	-- upvalues: v18 (copy), PromptType (copy)
	v18:debug("Sending feedback toast")
	p118:showPrompt(PromptType.VoiceToxicityFeedbackToast)
end
function t1.GetNudgeAnalyticsData(p119) -- line: 1538
	-- upvalues: Players (copy)
	return Players.LocalPlayer.UserId, p119:GetSessionId()
end
function t1.GetInExpUpsellAnalyticsData(_) -- line: 1542
	-- upvalues: EngineFeature (copy), RbxAnalyticsService (copy)
	local s17 = ""

	if EngineFeature then
		s17 = RbxAnalyticsService:GetPlaySessionId()
	end

	return game.GameId, game.PlaceId, s17
end
function t1.reportBanMessage(t18: {[any]: any}, s18: string) -- line: 1550
	-- upvalues: Players (copy)
	t18.Analytics:reportBanMessageEventV2(s18, t18.banReason, Players.LocalPlayer.UserId, not t18.service and "" or t18.previousSessionId)
end
function t1.reportJoinVoiceUpsellEvent(t19: {[any]: any}, s19: string, s20: string?, s21: string?) -- line: 1559
	-- upvalues: RbxAnalyticsService (copy), FFlagVoiceRewarmTelemetry (copy)
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()

	if FFlagVoiceRewarmTelemetry then
		t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled(), s20, s21)

		return
	end

	t19.Analytics:reportJoinVoiceUpsellEvent(s19, PlaySessionId, t19:UserVoiceEnabled())
end
function t1.SetAndSyncActive(t20: {[any]: any}, p121, b6: boolean) -- line: 1578
	t20.coreVoiceManager:SetAndSyncActive(p121, b6)
end
function t1.CreateAudioDeviceData(t21: {[any]: any}, p122) -- line: 1582
	return t21.coreVoiceManager:CreateAudioDeviceData(p122)
end
function t1.onInstanceAdded(t22: {[any]: any}, p123) -- line: 1586
	return t22.coreVoiceManager:onInstanceAdded(p123)
end
function t1.UpdateAudioDeviceInputDebugger(p124) -- line: 1590
	-- upvalues: v41 (copy), v18 (copy), Roact (copy), AudioDeviceInputDebugger (copy), CoreGui (copy)
	if v41 then
		if not p124.voiceDebuggerInstance then
			v18:debug("Mounting AudioDeviceInput Debugger")
			p124.voiceDebuggerInstance = Roact.mount(Roact.createElement(AudioDeviceInputDebugger, {
				instances = p124.audioDevices,
				mutedPlayers = p124.mutedPlayers
			}), CoreGui, "RobloxVoiceChatPromptGui")

			return
		end

		Roact.update(p124.voiceDebuggerInstance, Roact.createElement(AudioDeviceInputDebugger, {
			instances = p124.audioDevices,
			mutedPlayers = p124.mutedPlayers
		}))
	end
end
function t1.AddReverseNudgeToxicUser(t23: {[any]: any}, s22: string, p125, p126) -- line: 1614
	-- upvalues: GetFIntVoiceReverseNudgeUXDisplayTimeSeconds (copy)
	p125(s22, "iconColorChange")

	local v322 = t23.reverseNudgeToxicUserRemovalCallbacks[s22]

	if v322 ~= nil then
		task.cancel(v322)
	end

	local thread = task.delay(GetFIntVoiceReverseNudgeUXDisplayTimeSeconds(), function() -- line: 1628
		-- upvalues: p126 (copy), s22 (copy), t23 (copy)
		p126(s22)
		t23.reverseNudgeToxicUserRemovalCallbacks[s22] = nil
	end)

	t23.reverseNudgeToxicUserRemovalCallbacks[s22] = thread
end
function t1.onInstanceRemove(t24: {[any]: any}, p127) -- line: 1635
	return t24.coreVoiceManager:onInstanceRemove(p127)
end
function t1.hookupAudioDeviceInputListener(p128) -- line: 1639
	return p128.coreVoiceManager:hookupAudioDeviceInputListener()
end
function t1.ToggleMutePlayer(t25: {[any]: any}, n5: number, s23: string) -- line: 1643
	return t25.coreVoiceManager:ToggleMutePlayer(n5, s23)
end
function t1.MuteAll(t26: {[any]: any}, b7: boolean, s24: string) -- line: 1647
	return t26.coreVoiceManager:MuteAll(b7, s24)
end
function t1.ToggleMuteSome(t27: {[any]: any}, t28: {[any]: any}, b8: boolean, s25: string, s26: string) -- line: 1651
	return t27.coreVoiceManager:ToggleMuteSome(t28, b8, s25, s26)
end
function t1.FireMuteNonFriendsEvent(p129) -- line: 1660
	p129.mutedNonFriends:Fire()
end
function t1.EnsureCorrectMuteState(t29: {[any]: any}, t30: {[any]: any}, b9: boolean) -- line: 1664
	-- upvalues: VoiceChatService (copy), EngineFeature2 (copy), Players (copy)
	local t31 = {}

	for _, v344 in t30 do
		local v345 = t29.participants[tostring(v344)]

		if v345 and b9 ~= v345.isMutedLocally then
			if VoiceChatService.UseNewAudioApi then
				t31[v344] = true
				t29.mutedPlayers[v344] = b9
			else
				t29.service:SubscribePause(v344, b9)
			end

			v345.isMutedLocally = b9
			t29.participantsUpdate:Fire(t29.participants)
		end
	end

	if VoiceChatService.UseNewAudioApi then
		for v346 in t29.audioDevices do
			if v346.Player and t31[v346.Player.UserId] then
				if EngineFeature2 and v346.Player ~= Players.LocalPlayer then
					v346.MutedByLocalUser = b9
				else
					v346.Active = not b9
				end
			end
		end
	end
end
function t1.FireUserAgencySelectedEvent(t32: {[any]: any}, b10: boolean) -- line: 1696
	t32.userAgencySelected:Fire(b10)
end
function t1.ParticipantStateToIcon(_, p131, p132) -- line: 1700
	-- upvalues: VOICE_STATE (copy)
	local INACTIVE = VOICE_STATE.INACTIVE

	if not p131.subscriptionCompleted then
		INACTIVE = VOICE_STATE.CONNECTING
	elseif p131.isMutedLocally then
		INACTIVE = VOICE_STATE.LOCAL_MUTED
	elseif p131.isMuted then
		INACTIVE = VOICE_STATE.MUTED
	elseif p131.isSignalActive then
		INACTIVE = VOICE_STATE.TALKING
	end

	return getIcon(INACTIVE, p132)
end
function t1.VoiceStateToIcon(_, p134, p135, p136) -- line: 1715
	return getIcon(p134, p135, p136)
end
function t1.GetIcon(_, p138, p139) -- line: 1719
	return getIconSrc(p138, p139)
end
function t1.JoinVoice(p140, p141) -- line: 1723
	-- upvalues: FFlagVoiceRewarmTelemetry (copy), v63 (copy), v18 (copy), v65 (copy), Constants2 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), GetFFlagUpdateVoiceConnectionToasts (copy), PromptType (copy), GetFFlagNonVoiceFTUX (copy), AppStorageService (copy), GetFFlagEnableVrVoiceParity (copy), Promise (copy), v50 (copy), GetFFlagEnableSeamlessVoiceV2 (copy), v54 (copy), GetFFlagDisableConsentModalForExistingUsers (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), getOverlayStore (copy), OverlayTypes (copy), SocialUpsellType (copy), Enum2 (copy), v48 (copy)
	local joinVoiceButtonContext = nil
	local s27 = nil

	if FFlagVoiceRewarmTelemetry then
		joinVoiceButtonContext = p140.joinVoiceButtonContext
		p140.joinVoiceButtonContext = nil
	end

	if v63 then
		v18:debug("Consuming voice re-warm cookie on JoinVoice")
		p140:SetVoiceRewarmCookie("true")
	end

	local v364 = p140:FetchAgeVerificationOverlay()
	local v365 = ((if not v65 then v364.showVoiceInExperienceUpsellVariant else (if type(v364) ~= "table" then nil else v364.showVoiceInExperienceUpsellVariant))) or Constants2.IN_EXP_UPSELL_VARIANT.VARIANT3

	if not FFlagVoiceRewarmTelemetry then
		p140.Analytics:reportJoinVoiceButtonEvent("clicked", p140:GetInExpUpsellAnalyticsData())
	end

	if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p140.previousGroupId then
		if FFlagVoiceRewarmTelemetry then
			s27 = "RejoinPreviousChannel"
		end

		p140:RejoinPreviousChannel()

		if GetFFlagEnableVoiceTrustedConnectionsToasts() then
			p140:showJoinVoicePrompt()
		elseif GetFFlagUpdateVoiceConnectionToasts() then
			p140:showPrompt(PromptType.UnifiedJoinVoiceToast)
		else
			p140:showPrompt(PromptType.JoinVoice)
		end

		p140:ShowVoiceUI()
		p140:SetVoiceConnectCookieValue(true)
	elseif GetFFlagNonVoiceFTUX() and p140.isShowingFTUX then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ExitFtux"
		end

		p140:HideFTUX(AppStorageService)
	elseif p140.deniedMicPermissions then
		if FFlagVoiceRewarmTelemetry then
			s27 = "MicPermissionPrompt"
		end

		if GetFFlagEnableVrVoiceParity() then
			p140:CheckAndShowPermissionPrompt()
		else
			p140:CheckAndShowPermissionPrompt():finallyReturn(Promise.reject())
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p140:UserVoiceEnabled() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FirstJoinSession"
		end

		if v50 then
			p140.isInitialJoin = true
		end

		p140.attemptVoiceRejoin:Fire()

		if GetFFlagEnableSeamlessVoiceV2() and p140:IsNewSeamlessVoiceUserDisconnect() then
			p140:SetVoiceConnectCookieValue(true)
			p140:SetNewUserFTUXCookieValue(true)
		end
	elseif v54 and p140:UserOnlyEligibleForVoiceViaOverlay() or p140:UserOnlyEligibleForVoice() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "ConsentModal"
		end

		if GetFFlagDisableConsentModalForExistingUsers() and p140:IsSeamlessVoice() then
			p140:EnableVoice()
		else
			p140:SetInExpUpsellEntrypoint(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE)
			p140:showPrompt((p140:GetInExpUpsellPromptFromEnum(v365)))
		end
	elseif p140:EligibleForAgeCheckToast() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "AgeCheckToast"
		end

		p140:showPrompt(PromptType.AgeCheckForVoiceToast)
	elseif GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not p140:UserVoiceEnabled() and p140:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		if FFlagVoiceRewarmTelemetry then
			s27 = "PhoneUpsell"
		end

		if p141 then
			p141:SetVisibility(false, true)
		end

		p140:ShowInExperiencePhoneVoiceUpsell(Constants2.IN_EXP_UPSELL_ENTRYPOINTS.JOIN_VOICE, Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER)
	elseif p140:EligibleForFaeUpsell() then
		if FFlagVoiceRewarmTelemetry then
			s27 = "FaeUpsell"
		end

		if p140.pendingConnectionSource == nil then
			p140.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.IN_EXPERIENCE
		end

		p140.coreVoiceManager:OptUserToJoinVoice()

		local v366 = getOverlayStore(false)

		if not FFlagVoiceRewarmTelemetry then
			p140:reportJoinVoiceUpsellEvent("Click")
		end

		v366.setCurrentOverlay(OverlayTypes.SocialUpsell, {
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
		local v367, v368, v369 = p140:GetInExpUpsellAnalyticsData()

		p140.Analytics:reportJoinVoiceButtonEvent("clicked", v367, v368, v369, joinVoiceButtonContext, s27)
		p140:reportJoinVoiceUpsellEvent("Click", joinVoiceButtonContext, s27)
	end

	if v48 and p140:IsSeamlessVoice() then
		task.spawn(function() -- line: 1865
			-- upvalues: p140 (copy)
			p140.coreVoiceManager:PostUserVoiceConnectionStatus(true)
		end)
	end
end
function t1.EligibleForFaeUpsell(p142) -- line: 1871
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagTestDeviceForFAEUpsell (copy), deviceMeetsRequirementsForFAE (copy)
	local v371 = GetFFlagEnableVoiceUxUpdates()

	if v371 then
		v371 = p142.coreVoiceManager:EligibleForFaeUpsell()

		if v371 then
			v371 = p142.AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.InExperienceFAE)

			if v371 then
				if FFlagTestDeviceForFAEUpsell then
					return (deviceMeetsRequirementsForFAE())
				end

				v371 = true
			end
		end
	end

	return v371
end
function t1.EligibleForAgeCheckToast(p143) -- line: 1878
	return p143.coreVoiceManager:EligibleForAgeCheckToast()
end
function t1.ShouldShowJoinVoice(p144) -- line: 1883
	-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), FFlagVoiceRewarmTelemetry (copy), VoiceChatCore (copy), v63 (copy), GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagIntegratePhoneUpsellJoinVoice (copy), GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy), Constants2 (copy)
	if GetFFlagEnableVoiceUxUpdates() then
		if FFlagVoiceRewarmTelemetry then
			if p144:EligibleForFaeUpsell() then
				p144.joinVoiceButtonContext = "FaeUpsell"

				return true
			end

			if p144:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p144:GetVoiceConnectCookie() == "" then
				p144.joinVoiceButtonContext = "VoiceFtux"

				return true
			end

			if v63 and p144:GetVoiceRewarmCookie() == "" and p144:GetVoiceConnectCookie() == "false" and p144:UserVoiceEnabled() then
				p144.joinVoiceButtonContext = "Rewarm"

				return true
			end
		elseif p144:EligibleForFaeUpsell() or p144:HasSeamlessVoiceFeature(VoiceChatCore.Constants.SeamlessVoiceFeatures.InitialJoinVoice) and p144:GetVoiceConnectCookie() == "" or v63 and p144:GetVoiceRewarmCookie() == "" and p144:VoiceChatEnded() then
			return true
		end
	elseif GetFFlagOnlyEnableJoinVoiceInVoiceEnabledUniverses() then
		if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p144:IsSeamlessVoice() and p144:verifyUniverseAndPlaceCanUseVoice() then
			return not p144.voiceUIVisible
		end
	elseif GetFFlagEnableConnectDisconnectInSettingsAndChrome() and p144:IsSeamlessVoice() then
		return not p144.voiceUIVisible
	end

	if p144:EligibleForAgeCheckToast() then
		return true
	end

	local v374 = p144:UserInInExperienceUpsellTreatment()
	local v375 = p144:UserOnlyEligibleForVoice() or p144:UserVoiceEnabled()

	if GetFFlagIntegratePhoneUpsellJoinVoice() and GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and not v375 and not p144:UserVoiceEnabled() and p144:FetchPhoneVerificationUpsell(Constants2.IN_EXP_PHONE_UPSELL_IXP_LAYER) == Constants2.PHONE_UPSELL_VALUE_PROP.VoiceChat then
		return true
	end

	return v374 and v375
end
function t1.ShouldShowJoinVoiceOnDisconnect(p145) -- line: 1962
	return p145.coreVoiceManager:ShouldShowJoinVoiceOnDisconnect()
end
function t1.IsSeamlessVoice(p146) -- line: 1966
	-- upvalues: GetFFlagCheckUniversePlaceBeforeSuspending (copy), v18 (copy), SeamlessVoiceStatus (copy)
	if GetFFlagCheckUniversePlaceBeforeSuspending() then
		return p146.coreVoiceManager:IsSeamlessVoice()
	end

	local v378 = p146:FetchAgeVerificationOverlay()

	if not v378 or not v378.voiceSettings then
		v18:error("VoiceChatServiceManager:IsSeamlessVoice() - ageVerificationOverlayData or voiceSettings is nil")

		return false
	end

	local seamlessVoiceStatus = v378.voiceSettings.seamlessVoiceStatus

	return seamlessVoiceStatus == SeamlessVoiceStatus.EnabledExistingUser or seamlessVoiceStatus == SeamlessVoiceStatus.EnabledNewUser
end
function t1.HasSeamlessVoiceFeature(p147, p148) -- line: 1982
	return p147.coreVoiceManager:HasSeamlessVoiceFeature(p148)
end
function t1.IsNewSeamlessVoiceUserDisconnect(p149) -- line: 1986
	return p149.coreVoiceManager:IsNewSeamlessVoiceUserDisconnect()
end
function t1.GetConnectDisconnectButtonAnalyticsData(t33: {[any]: any}, b11: boolean) -- line: 1990
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
function t1.GetConnectDisconnectAnalyticsData(p150) -- line: 2002
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
		t35.voiceSessionId = not p150.service and "" or p150:GetSessionId()
	else
		t35.voiceSessionId = p150:GetSessionId()
	end

	t35.durationTimestamp = default:getTimestamp()

	return t35
end
function t1.Leave(p151) -- line: 2022
	-- upvalues: GetFFlagDisconnectToastClientRewrite (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy), v48 (copy)
	p151:ensureInitialized("leave")

	if GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p151:SetVoiceConnectCookieValue(false)
	end

	p151.Analytics:reportConnectDisconnectEvents("voiceDisconnectEvent", p151:GetConnectDisconnectAnalyticsData())

	local GroupId = p151.service:GetGroupId()
	local v392 = p151.service:IsPublishPaused()

	if GetFFlagVoiceChatClientRewriteMasterLua() then
		local VoiceChatService2 = game:GetService("VoiceChatService")

		if VoiceChatService2 then
			VoiceChatService2:leaveVoice()
		end
	else
		p151.service:Leave()
	end

	p151:HideVoiceUI()
	p151.previousGroupId = GroupId
	p151.previousMutedState = v392

	if not GetFFlagDisconnectToastClientRewrite() and GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
		p151:SetVoiceConnectCookieValue(false)
	end

	if v48 and p151:IsSeamlessVoice() then
		task.spawn(function() -- line: 2045
			-- upvalues: p151 (copy)
			p151.coreVoiceManager:PostUserVoiceConnectionStatus(false)
		end)
	end
end
function t1.GetVoiceStateFromEnum(_, p153) -- line: 2051
	-- upvalues: t2 (ref), VOICE_STATE (copy)
	if not t2[p153] then
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

	return t2[p153]
end
function t1.GetInExpUpsellPromptFromEnum(_: {[any]: any}, s30: string) -- line: 2071
	-- upvalues: t3 (copy)
	return t3[s30]
end
function t1.getRecentUsersInteractionData(p154) -- line: 2076
	return p154.coreVoiceManager:getRecentUsersInteractionData()
end
function t1._setRecentUserState(p155, p156, p157) -- line: 2080
	return p155.coreVoiceManager:_setRecentUserState(p156, p157)
end
function t1._updateRecentUsersInteractionData(p158) -- line: 2084
	return p158.coreVoiceManager:_updateRecentUsersInteractionData()
end
function t1.SetupParticipantListeners(p159) -- line: 2088
	return p159.coreVoiceManager:SetupParticipantListeners()
end
function t1.Disconnect(p160) -- line: 2092
	p160.coreVoiceManager:Disconnect()
	p160.coreVoiceManager:unsubscribeAll()
end
function t1.GetSendMuteEvent(p161) -- line: 2097
	return p161.coreVoiceManager:GetSendMuteEvent()
end
function t1.ToggleMic(t37: {[any]: any}, s31: string?) -- line: 2102
	return t37.coreVoiceManager:ToggleMic(s31)
end
function t1.SubscribeRetry(t38: {[any]: any}, n6: number) -- line: 2106
	-- upvalues: v18 (copy)
	t38:ensureInitialized("subscribe retry")
	v18:debug("Attempting to retry connection to user: {}", "..." .. string.sub(tostring(n6), -4))
	t38.service:SubscribeRetry(n6)
end
function t1.JoinByGroupIdToken(p162, p163, p164) -- line: 2112
	return p162.coreVoiceManager:JoinByGroupIdToken(p163, p164)
end
function t1.RejoinPreviousChannel(p165) -- line: 2116
	-- upvalues: v18 (copy), GetFFlagVoiceChatClientRewriteMasterLua (copy)
	local previousGroupId = p165.previousGroupId
	local previousMutedState = p165.previousMutedState

	v18:debug("Rejoining previous channel {} with mute status {}", previousGroupId, previousMutedState)
	pcall(function() -- line: 2121
		-- upvalues: GetFFlagVoiceChatClientRewriteMasterLua (copy), p165 (copy), previousGroupId (copy), previousMutedState (copy)
		if GetFFlagVoiceChatClientRewriteMasterLua() then
			p165.coreVoiceManager:RejoinVoice()

			local ConnectDisconnectAnalyticsData = p165:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p165.pendingConnectionSource
			p165.pendingConnectionSource = nil
			p165.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p165.voiceConnectEventReportedForActiveSession = true

			return
		end

		if previousGroupId and previousGroupId ~= "" then
			p165.service:Leave()

			if not p165.service:JoinByGroupIdToken(previousGroupId, previousMutedState, true) then
				p165:InitialJoinFailedPrompt()

				return
			end

			local ConnectDisconnectAnalyticsData = p165:GetConnectDisconnectAnalyticsData()

			ConnectDisconnectAnalyticsData.connectionSource = p165.pendingConnectionSource
			p165.pendingConnectionSource = nil
			p165.Analytics:reportConnectDisconnectEvents("voiceConnectEvent", ConnectDisconnectAnalyticsData)
			p165.voiceConnectEventReportedForActiveSession = true
		end
	end)
end
function t1.SwitchDevice(_, p167, p168, p169) -- line: 2147
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy), v18 (copy)
	if p167 == VOICE_CHAT_DEVICE_TYPE.Input then
		SoundService:SetInputDevice(p168, p169)
		v18:info("[InputDeviceSelection] Setting SS Mic Device To {} {}", p168, p169)

		return
	end

	SoundService:SetOutputDevice(p168, p169)
	v18:info("[OutputDeviceSelection] Setting SS Speaker Device To {} {}", p168, p169)
end
function t1.GetDevices(_, p171) -- line: 2157
	-- upvalues: VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
	local ok, result, v424, v425 = pcall(function() -- line: 2158
		-- upvalues: p171 (copy), VOICE_CHAT_DEVICE_TYPE (copy), SoundService (copy)
		if p171 == VOICE_CHAT_DEVICE_TYPE.Input then
			return SoundService:GetInputDevices()
		end

		return SoundService:GetOutputDevices()
	end)

	return ok, result, v424, v425
end
function t1.VoiceChatAvailable(p172) -- line: 2169
	-- upvalues: MIN_VOICE_CHAT_API_VERSION (copy), VOICE_CHAT_AVAILABILITY (copy)
	local service = p172.service

	if p172.available == nil and service then
		p172.version = service:GetVoiceChatApiVersion()

		if p172.version >= MIN_VOICE_CHAT_API_VERSION then
			p172.available = service:GetVoiceChatAvailable()

			while p172.available == VOICE_CHAT_AVAILABILITY.Checking do
				wait(1)
				p172.available = service:GetVoiceChatAvailable()
			end
		end
	end

	if service then
		return p172.version >= MIN_VOICE_CHAT_API_VERSION and p172.available == VOICE_CHAT_AVAILABILITY.Available
	end

	return false
end
function t1.VoiceChatEnded(p173) -- line: 2189
	-- upvalues: v52 (copy)
	if p173.service then
		local VoiceChatState = p173.service.VoiceChatState

		if v52 then
			return VoiceChatState == Enum.VoiceChatState.Ended
		end

		return VoiceChatState == Enum.VoiceChatState.Ended or VoiceChatState == Enum.VoiceChatState.Idle
	end

	return true
end
function t1.UnmountPrompt(p174) -- line: 2201
	-- upvalues: Roact (copy)
	if p174.voiceChatPromptInstance ~= nil then
		Roact.unmount(p174.voiceChatPromptInstance)
		p174.voiceChatPromptInstance = nil
	end
end

t1.default = t1.new(CoreVoiceManager.default, nil, HttpRbxApiService, PermissionsProtocol.default, BlockingUtility:GetAfterBlockedStatusChangedEvent())

return t1
