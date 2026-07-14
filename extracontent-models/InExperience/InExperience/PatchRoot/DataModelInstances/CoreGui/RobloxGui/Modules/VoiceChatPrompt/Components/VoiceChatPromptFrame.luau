local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local ContextActionService = game:GetService("ContextActionService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLastInput = Responsive.useLastInput
local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Toast = UIBlox.App.Dialog.Toast
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local validateStyle = UIBlox.Style.Validator.validateStyle
local PromptType = require(script.Parent.Parent.PromptType)
local InGameMenuPolicy = require(script.Parent.Parent.Parent.InGameMenu.InGameMenuPolicy)
local VoiceChatConsentModal = require(script.Parent.VoiceChatConsentModal)
local VoiceChatTooltip = require(script.Parent.VoiceChatTooltip)
local DevicePermissionsModal = require(script.Parent.DevicePermissionsModal)
local Assets = require(script.Parent.Parent.Parent.InGameMenu.Resources.Assets)

require(CorePackages.Workspace.Packages.VoiceChatCore)

local Flags = require(CorePackages.Workspace.Packages.VoiceChat).Flags
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetFFlagEnableVoicePromptReasonText = require(RobloxGui.Modules.Flags.GetFFlagEnableVoicePromptReasonText)
local GetFFlagSupportGamepadNavInVoiceModals = Flags.GetFFlagSupportGamepadNavInVoiceModals
local GetFIntVoiceToxicityToastDurationSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceToxicityToastDurationSeconds)
local v34 = game:DefineFastFlag("VoiceChatOnlyReportVoiceBans", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local GetFFlagShowDevicePermissionsModal = SharedFlags.GetFFlagShowDevicePermissionsModal
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFIntVoiceJoinM3ToastDurationSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceJoinM3ToastDurationSeconds)
local GetFFlagEnableSeamlessVoiceDataConsentToast = require(RobloxGui.Modules.Flags.GetFFlagEnableSeamlessVoiceDataConsentToast)
local GetFFlagUpdateVoiceConnectionToasts = require(script.Parent.Parent.Parent.VoiceChat.Flags.GetFFlagUpdateVoiceConnectionToasts)
local GetFFlagEnableVoiceTrustedConnectionsToasts = require(script.Parent.Parent.Parent.VoiceChat.Flags.GetFFlagEnableVoiceTrustedConnectionsToasts)
local GetFFlagVoiceConnectToastCapturesTrustedFriendsSubtitle = require(script.Parent.Parent.Parent.VoiceChat.Flags.GetFFlagVoiceConnectToastCapturesTrustedFriendsSubtitle)
local GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 = require(script.Parent.Parent.Parent.VoiceChat.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2)
local VoiceNudgeUseNewDACopy = require(script.Parent.Parent.Parent.VoiceChat.Helpers.VoiceNudgeUseNewDACopy)
local v46 = game:DefineFastFlag("VoiceNudgeUseNewConfirmButton", false)
local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(script.Parent.Parent.Parent.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local LocalizationService = game:GetService("LocalizationService")
local v50 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
local color3 = Color3.fromRGB(255, 255, 255)
local color3_2 = Color3.fromRGB(220, 220, 220)

Roact.PureComponent:extend("VoiceChatPromptFrame")

local t1 = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NotAudible"),
	[PromptType.NotAudibleVoiceChatVolume] = if not FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast then nil else v50:Format("Feature.SettingsHub.Prompt.NotAudible"),
	[PromptType.Permission] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicrophonePermission"),
	[PromptType.Retry] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicrophonePermission"),
	[PromptType.Place] = "Exceeds Max Players",
	[PromptType.User] = "Not Eligible for Voice",
	[PromptType.VoiceChatSuspendedTemporaryAvatarChat] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicAndCameraUseSuspended"),
	[PromptType.VoiceChatSuspendedTemporary] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended"),
	[PromptType.VoiceChatSuspendedTemporaryB] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspended"),
	[PromptType.VoiceChatSuspendedPermanent] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspended"),
	[PromptType.VoiceLoading] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Connecting"),
	[PromptType.VoiceToxicityModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRules"),
	[PromptType.VoiceToxicityToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRules"),
	[PromptType.VoiceToxicityFeedbackToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.ThankYouForFeedback"),
	[PromptType.VoiceChatSuspendedTemporaryToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended"),
	[PromptType.VoiceConsentDeclinedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.ChangeYourMind"),
	[PromptType.VoiceConsentAcceptedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat"),
	[PromptType.VoiceConsentModalV1] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GetVoiceChat"),
	[PromptType.VoiceConsentModalV2] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatWithOthers"),
	[PromptType.VoiceConsentModalV3] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GetVoiceChat"),
	[PromptType.JoinedVoiceToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat"),
	[PromptType.JoinVoiceSTUX] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat"),
	[PromptType.LeaveVoice] = if not GetFFlagUpdateVoiceConnectionToasts() then RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.LeaveVoiceChat") else v50:Format("Feature.SettingsHub.Prompt.LeaveVoiceChatV2"),
	[PromptType.JoinVoice] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChatV2"),
	[PromptType.DevicePermissionsModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NeedMicrophoneAccess"),
	[PromptType.VoiceDataConsentOptOutToast] = if not GetFFlagEnableSeamlessVoiceDataConsentToast() then nil else v50:Format("Feature.SettingsHub.Prompt.Title.ImproveVoiceChat"),
	[PromptType.UnifiedJoinVoiceToast] = if not GetFFlagUpdateVoiceConnectionToasts() then nil else v50:Format("Feature.SettingsHub.Prompt.JoinedVoiceChatV3"),
	[PromptType.AgeCheckForVoiceToast] = v50:Format("Feature.SettingsHub.Prompt.Title.AgeCheckForVoiceToast"),
	[PromptType.UpdateOnAutoJoinToast] = if not GetFFlagEnableVoiceTrustedConnectionsToasts() then nil else v50:Format("Feature.SettingsHub.Prompt.UpdateToVoiceChat"),
	[PromptType.VoiceChatSuspendedTemporaryBV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspendedV2"),
	[PromptType.VoiceToxicityModalV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat"),
	[PromptType.VoiceToxicityToastV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat")
}
local v54 = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupTrustedConnections" or "Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupTrustedFriends"
local v55 = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Prompt.Subtitle.TalkAgeGroupTrustedConnectionsUpdate" or "Feature.SettingsHub.Prompt.Subtitle.TalkAgeGroupTrustedFriendsUpdate"
local t2 = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.NotAudible"),
	[PromptType.NotAudibleVoiceChatVolume] = if not FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast then nil else v50:Format("Feature.SettingsHub.Prompt.Subtitle.NotAudibleVoiceChatVolume"),
	[PromptType.Permission] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MicrophonePermission"),
	[PromptType.Retry] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Retry"),
	[PromptType.Place] = "Spatial voice is only available for places with Max Players of 30 or less.",
	[PromptType.User] = "This account is not eligible to use Spatial Voice.",
	[PromptType.VoiceChatSuspendedTemporary] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Microphone"),
	[PromptType.VoiceChatSuspendedTemporaryAvatarChat] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MicAndCamera"),
	[PromptType.VoiceChatSuspendedTemporaryB] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan1"),
	[PromptType.VoiceChatSuspendedPermanent] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Revoked"),
	[PromptType.VoiceLoading] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Connecting"),
	[PromptType.VoiceToxicityModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityModal"),
	[PromptType.VoiceToxicityToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityToast"),
	[PromptType.VoiceToxicityFeedbackToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.ThanksForLettingUsKnow"),
	[PromptType.VoiceChatSuspendedTemporaryToast] = function(p1) -- line: 194
		-- upvalues: RobloxTranslator (copy)
		return RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.ChatWithVoiceDisabledUntil", {
			dateTime = p1
		})
	end,
	[PromptType.VoiceConsentDeclinedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.JoinVoiceLater"),
	[PromptType.VoiceConsentAcceptedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MuteAnyoneAnytime"),
	[PromptType.VoiceConsentModalV1] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell1"),
	[PromptType.VoiceConsentModalV2] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell2"),
	[PromptType.VoiceConsentModalV3] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell2"),
	[PromptType.JoinedVoiceToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.DisconnectOrMute"),
	[PromptType.JoinVoiceSTUX] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.DisconnectOrMuteHere"),
	[PromptType.DevicePermissionsModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.AllowMicrophoneAccess"),
	[PromptType.VoiceDataConsentOptOutToast] = if not GetFFlagEnableSeamlessVoiceDataConsentToast() then nil else v50:Format("Feature.SettingsHub.Prompt.Subtitle.ThanksForVoiceData"),
	[PromptType.UnifiedJoinVoiceToast] = if not GetFFlagVoiceConnectToastCapturesTrustedFriendsSubtitle then if not GetFFlagEnableVoiceTrustedConnectionsToasts() then if not GetFFlagUpdateVoiceConnectionToasts() then nil else v50:Format("Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupV2") else v50:Format(v54) else RobloxTranslator:FormatByKey("Feature.Captures.Prompt.Subtitle.VoiceChatRecordingTrustedFriendsAgeGroup"),
	[PromptType.AgeCheckForVoiceToast] = v50:Format("Feature.SettingsHub.Prompt.Subtitle.GoToAccountInfo"),
	[PromptType.UpdateOnAutoJoinToast] = if not GetFFlagEnableVoiceTrustedConnectionsToasts() then nil else v50:Format(v55),
	[PromptType.VoiceChatSuspendedTemporaryBV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan1V2"),
	[PromptType.VoiceToxicityModalV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityModalV2"),
	[PromptType.VoiceToxicityToastV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityToastV2")
}

if RunService:IsStudio() then
	t1[PromptType.Place] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Place")
	t1[PromptType.User] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.User")
	t2[PromptType.Place] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Place")
	t2[PromptType.User] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.User")
end

RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Respect")

local v57 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.FutureViolations")
local v58 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.EffectiveUntil")
local v59 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Understand")
local v60 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GotIt")
local v61 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudge")
local v62 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2")
local v63 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Ok")
local v64 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2V2")
local v65 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudgeV2")

local function PromptTypeIsBan(p2) -- line: 273
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p2 == PromptType.VoiceChatSuspendedPermanent or (p2 == PromptType.VoiceChatSuspendedTemporary or (p2 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p2 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p2 == PromptType.VoiceChatSuspendedTemporaryBV2)))
end
local function IsModalNudge(p3) -- line: 281
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p3 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p3 == PromptType.VoiceToxicityModalV2
end
local function IsVoiceConsentModal(p4) -- line: 286
	-- upvalues: PromptType (copy)
	return p4 == PromptType.VoiceConsentModalV1 or (p4 == PromptType.VoiceConsentModalV2 or p4 == PromptType.VoiceConsentModalV3)
end
local function IsDevicePermissionsModal(p5) -- line: 292
	-- upvalues: PromptType (copy)
	return p5 == PromptType.DevicePermissionsModal
end
local function PromptTypeIsModal(p6) -- line: 296
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p6 == PromptType.VoiceChatSuspendedPermanent or (p6 == PromptType.VoiceChatSuspendedTemporary or (p6 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p6 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p6 == PromptType.VoiceChatSuspendedTemporaryBV2))) or (p6 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p6 == PromptType.VoiceToxicityModalV2 or (p6 == PromptType.VoiceConsentModalV1 or (p6 == PromptType.VoiceConsentModalV2 or p6 == PromptType.VoiceConsentModalV3) or p6 == PromptType.DevicePermissionsModal))
end
local function PromptTypeIsVoiceConsent(p7) -- line: 303
	-- upvalues: PromptType (copy)
	return p7 == PromptType.VoiceConsentDeclinedToast or p7 == PromptType.VoiceConsentAcceptedToast
end
local function PromptTypeIsVoiceDataConsent(p8) -- line: 307
	-- upvalues: PromptType (copy)
	return p8 == PromptType.VoiceDataConsentOptOutToast
end
local function PromptTypeIsConnectDisconnectToast(p9) -- line: 311
	-- upvalues: PromptType (copy), GetFFlagUpdateVoiceConnectionToasts (copy)
	return p9 == PromptType.JoinVoice or (p9 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p9 == PromptType.UnifiedJoinVoiceToast)
end
local function ShouldShowBannedUntil(p10) -- line: 317
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p10 == PromptType.VoiceChatSuspendedTemporary or (p10 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p10 == PromptType.VoiceChatSuspendedTemporaryToast or (p10 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p10 == PromptType.VoiceChatSuspendedTemporaryBV2)))
end
local function ShouldShowSecondaryButton(p11) -- line: 325
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p11 == PromptType.VoiceChatSuspendedTemporaryB or (GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p11 == PromptType.VoiceChatSuspendedTemporaryBV2 or (p11 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p11 == PromptType.VoiceToxicityModalV2))
end

local v76 = Roact.PureComponent:extend("VoiceChatPromptFrame")

v76.validateProps = t.strictInterface({
	promptSignal = t.optional(t.RBXScriptSignal),
	errorText = t.optional(t.string),
	bannedUntil = t.optional(t.string),
	onContinueFunc = t.optional(t.callback),
	onPrimaryActivated = t.optional(t.callback),
	onSecondaryActivated = t.optional(t.callback),
	onReadyForSignal = t.optional(t.callback),
	Analytics = t.optional(t.table),
	VoiceChatServiceManager = t.optional(t.table),
	showNewContent = t.optional(t.boolean),
	showCheckbox = t.optional(t.boolean),
	showDataConsentToast = t.optional(t.boolean),
	policyMapper = t.optional(t.callback),
	appStyle = validateStyle,
	settingsAppAvailable = t.optional(t.boolean),
	UserInputService = t.optional(t.table),
	lastInput = t.optional(t.string)
})

function v76.init(p12) -- line: 350
	-- upvalues: PromptType (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), Roact (copy), RobloxTranslator (copy), t1 (copy), t2 (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), EngineFeature (copy), RbxAnalyticsService (copy), GetFFlagUpdateVoiceConnectionToasts (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), Images (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), ContextActionService (copy), VoiceNudgeUseNewDACopy (copy), v34 (copy)
	p12.promptStyle = {
		Theme = p12.props.appStyle.Theme,
		Font = p12.props.appStyle.Font
	}
	p12.state = {
		toastContent = nil,
		banEnd = "",
		showPrompt = true,
		screenSize = Vector2.new(0, 0),
		promptType = PromptType.None
	}
	p12.ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else Roact.createRef()

	if p12.props.showNewContent then
		local v91 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended")
		local v92 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporarySuspension2")

		t1[PromptType.VoiceChatSuspendedTemporary] = v91
		t1[PromptType.VoiceChatSuspendedPermanent] = v91
		t2[PromptType.VoiceChatSuspendedTemporary] = v92
	end

	function p12.onScreenSizeChanged(p13) -- line: 374
		-- upvalues: p12 (copy)
		if p12.state.screenSize ~= p13.AbsoluteSize then
			p12:setState({
				screenSize = p13.AbsoluteSize
			})
		end
	end
	function p12.promptSignalCallback(p14) -- line: 382
		-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), p12 (copy), EngineFeature (copy), RbxAnalyticsService (copy), t1 (copy), t2 (copy), GetFFlagUpdateVoiceConnectionToasts (copy), GetFFlagEnableVoiceTrustedConnectionsToasts (copy), Images (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), RobloxTranslator (copy), Roact (copy)
		if p14 == PromptType.VoiceChatSuspendedPermanent or (p14 == PromptType.VoiceChatSuspendedTemporary or (p14 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p14 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p14 == PromptType.VoiceChatSuspendedTemporaryBV2))) then
			if p12.props.Analytics then
				p12.props.Analytics:reportBanMessageEvent("Shown")
			end

			if p12.props.VoiceChatServiceManager then
				p12.props.VoiceChatServiceManager:reportBanMessage("Shown")
			end
		end

		if (p14 == PromptType.VoiceConsentModalV1 or (p14 == PromptType.VoiceConsentModalV2 or p14 == PromptType.VoiceConsentModalV3)) and p12.props.Analytics then
			local s1 = ""

			if EngineFeature then
				s1 = RbxAnalyticsService:GetPlaySessionId()
			end

			p12.props.Analytics:reportInExpConsent("shown", p12.props.VoiceChatServiceManager.inExpUpsellEntrypoint, game.GameId, game.PlaceId, s1)
		end

		if p14 == PromptType.DevicePermissionsModal and p12.props.Analytics and p12.props.VoiceChatServiceManager then
			p12.props.Analytics:reportDevicePermissionsModalEvent("Shown", p12.props.VoiceChatServiceManager:GetSessionId(), p12.props.VoiceChatServiceManager:GetInExpUpsellAnalyticsData())
		end

		if p14 and p14 ~= PromptType.None then
			local v138 = t1[p14]
			local v139 = t2[p14]

			if (p14 == PromptType.JoinVoice or (p14 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p14 == PromptType.UnifiedJoinVoiceToast)) and p12.props.VoiceChatServiceManager and p12.props.VoiceChatServiceManager:HasSeamlessVoiceFeature("HideJoinToastSubtitle") then
				v139 = nil
			end

			if typeof(v138) == "function" then
				v138 = v138(p12.props.bannedUntil)
			end

			if typeof(v139) == "function" then
				v139 = v139(p12.props.bannedUntil)
			end

			local v140 = if not GetFFlagEnableVoiceTrustedConnectionsToasts() or p14 ~= PromptType.UpdateOnAutoJoinToast then if not (p14 == PromptType.VoiceConsentDeclinedToast or p14 == PromptType.VoiceConsentAcceptedToast) and (p14 ~= PromptType.JoinedVoiceToast and (not GetFFlagUpdateVoiceConnectionToasts() or p14 ~= PromptType.UnifiedJoinVoiceToast)) then if not (p14 == PromptType.JoinVoice or (p14 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p14 == PromptType.UnifiedJoinVoiceToast)) then if p14 ~= PromptType.VoiceDataConsentOptOutToast or not GetFFlagEnableSeamlessVoiceDataConsentToast() then Images["icons/status/alert"] else nil else Images["icons/actions/info"] else Images["icons/controls/publicAudioJoin"] else Images["icons/controls/microphone"]

			p12:setState({
				showPrompt = true,
				promptType = p14,
				toastContent = {
					iconImage = v140,
					toastTitle = v138,
					toastSubtitle = v139,
					onActivated = function() -- line: 460
						-- upvalues: p12 (copy)
						if p12.props.onPrimaryActivated then
							p12.props.onPrimaryActivated()
						end
					end,
					onDismissed = function() -- line: 465
					end
				}
			})

			if p14 == PromptType.VoiceChatSuspendedTemporary or (p14 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p14 == PromptType.VoiceChatSuspendedTemporaryToast or (p14 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p14 == PromptType.VoiceChatSuspendedTemporaryBV2))) then
				local v141 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspension", {
					banDurationInMinutes = p12.props.bannedUntil
				})
				local v142 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspensionV2", {
					banDurationInMinutes = p12.props.bannedUntil
				})
				local v143 = if p14 ~= PromptType.VoiceChatSuspendedTemporaryB then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or p14 ~= PromptType.VoiceChatSuspendedTemporaryBV2 then " " .. p12.props.bannedUntil .. "." else v142 else v141

				p12:setState({
					banEnd = v143
				})

				return
			end
		else
			p12:setState({
				promptType = PromptType.None,
				toastContent = Roact.None
			})
		end
	end
	function p12.closeVoiceBanPrompt() -- line: 495
		-- upvalues: p12 (copy), ContextActionService (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v34 (copy)
		p12:setState({
			showPrompt = false
		})

		if p12.props.onContinueFunc then
			p12.props.onContinueFunc()
		end

		ContextActionService:UnbindCoreAction("CloseVoiceBanPrompt")

		local v144 = p12.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
		local v145 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and p12.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2)

		if v34 then
			local promptType = p12.state.promptType

			if (promptType == PromptType.VoiceChatSuspendedPermanent or (promptType == PromptType.VoiceChatSuspendedTemporary or (promptType == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (promptType == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceChatSuspendedTemporaryBV2)))) and not v144 and not v145 then
				if p12.props.Analytics then
					p12.props.Analytics:reportBanMessageEvent("Acknowledged")
				end

				if p12.props.VoiceChatServiceManager then
					p12.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")

					return
				end
			end
		elseif not v144 and not v145 then
			if p12.props.Analytics then
				p12.props.Analytics:reportBanMessageEvent("Acknowledged")
			end

			if p12.props.VoiceChatServiceManager then
				p12.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")
			end
		end
	end
	function p12.checkInputStateForClosePrompt(_, p16, _) -- line: 530
		-- upvalues: p12 (copy)
		if p16 == Enum.UserInputState.Begin then
			p12.closeVoiceBanPrompt()
		end
	end
	function p12.handlePrimayActivated() -- line: 536
		-- upvalues: p12 (copy)
		p12.closeVoiceBanPrompt()

		if p12.props.onPrimaryActivated then
			p12.props.onPrimaryActivated()
		end
	end
	function p12.handleSecondaryActivated() -- line: 543
		-- upvalues: p12 (copy)
		p12.closeVoiceBanPrompt()

		if p12.props.onSecondaryActivated then
			p12.props.onSecondaryActivated()
		end
	end
end
function v76.render(p18) -- line: 551
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagShowDevicePermissionsModal (copy), TextService (copy), v58 (copy), v62 (copy), v64 (copy), v57 (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), v46 (copy), Roact (copy), v63 (copy), v60 (copy), v59 (copy), color3_2 (copy), color3 (copy), Button (copy), ButtonType (copy), UIBlox (copy), Assets (copy), v65 (copy), v61 (copy), DevicePermissionsModal (copy), t1 (copy), t2 (copy), UserInputService (copy), VoiceChatConsentModal (copy), CoreGui (copy), VoiceChatTooltip (copy), GetFIntVoiceToxicityToastDurationSeconds (copy), GetFIntVoiceJoinM3ToastDurationSeconds (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), Toast (copy), ExternalEventConnection (copy)
	local v94 = GetFFlagEnableVoicePromptReasonText() and p18.props.errorText or nil
	local promptType = p18.state.promptType
	local v96 = promptType == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceToxicityModalV2
	local v97 = p18.state.promptType == PromptType.VoiceToxicityToast or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p18.state.promptType == PromptType.VoiceToxicityToastV2
	local v98 = p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
	local v99 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2)
	local v100 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and (p18.state.promptType == PromptType.VoiceToxicityModalV2 or p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2))
	local promptType2 = p18.state.promptType
	local v102 = promptType2 == PromptType.VoiceConsentModalV1 or (promptType2 == PromptType.VoiceConsentModalV2 or promptType2 == PromptType.VoiceConsentModalV3)
	local v103 = GetFFlagShowDevicePermissionsModal() and p18.state.promptType == PromptType.DevicePermissionsModal
	local AutomaticSizeY = Enum.AutomaticSize.Y
	local promptType3 = p18.state.promptType

	if promptType3 == PromptType.VoiceChatSuspendedPermanent or (promptType3 == PromptType.VoiceChatSuspendedTemporary or (promptType3 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (promptType3 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType3 == PromptType.VoiceChatSuspendedTemporaryBV2))) or (promptType3 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType3 == PromptType.VoiceToxicityModalV2 or (promptType3 == PromptType.VoiceConsentModalV1 or (promptType3 == PromptType.VoiceConsentModalV2 or promptType3 == PromptType.VoiceConsentModalV3) or promptType3 == PromptType.DevicePermissionsModal)) then
		local toastTitle = p18.state.toastContent.toastTitle
		local Header1Font = p18.promptStyle.Font.Header1.Font
		local v108 = p18.promptStyle.Font.Header1.RelativeSize * p18.promptStyle.Font.BaseSize
		local v109 = 20 + TextService:GetTextSize(toastTitle, v108, Header1Font, Vector2.new(325, 1e999)).Y
		local v110 = if not v98 and (not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or not v99) then v58 .. p18.state.banEnd else p18.state.banEnd
		local v111 = if p18.state.banEnd == "" then p18.state.toastContent.toastSubtitle .. p18.state.banEnd else "<b>" .. v110 .. "</b><br />" .. p18.state.toastContent.toastSubtitle
		local v112 = v94 or v111
		local BodyFont = p18.promptStyle.Font.Body.Font
		local v114 = p18.promptStyle.Font.Body.RelativeSize * p18.promptStyle.Font.BaseSize
		local v115 = 20 + TextService:GetTextSize(v112, v114, BodyFont, Vector2.new(325, 1e999)).Y

		if v98 or v99 then
			v115 += 20
		end

		local v116 = if not v98 then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or not v99 then v57 else v64 else v62
		local v117 = 20 + TextService:GetTextSize(v116, v114, BodyFont, Vector2.new(325, 1e999)).Y
		local promptType4 = p18.state.promptType
		local v119 = promptType4 == PromptType.VoiceChatSuspendedTemporaryB or (GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType4 == PromptType.VoiceChatSuspendedTemporaryBV2 or (promptType4 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType4 == PromptType.VoiceToxicityModalV2))
		local v120 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else Enum.SelectionBehavior.Stop
		local v121 = not not GetFFlagSupportGamepadNavInVoiceModals() or nil
		local v122 = if not v46 then Roact.createElement(Button, {
			layoutOrder = 1,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, -5, 0, 48),
			text = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not VoiceNudgeUseNewDACopy() or not v99) then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not v96 or (not VoiceNudgeUseNewDACopy() or p18.state.promptType ~= PromptType.VoiceToxicityModalV2)) then if not v96 then v59 else v60 else v63 else v63,
			onActivated = p18.handlePrimayActivated,
			Selectable = v121
		}) else Roact.createElement("TextButton", {
			Size = UDim2.new(1, -5, 0, 48),
			LayoutOrder = 1,
			Text = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not VoiceNudgeUseNewDACopy() or not v99) then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not v96 or (not VoiceNudgeUseNewDACopy() or p18.state.promptType ~= PromptType.VoiceToxicityModalV2)) then if not v96 then v59 else v60 else v63 else v63,
			[Roact.Event.Activated] = p18.handlePrimayActivated,
			[Roact.Event.MouseEnter] = function(p19) -- line: 619
				-- upvalues: color3_2 (copy)
				p19.BackgroundColor3 = color3_2
			end,
			[Roact.Event.MouseLeave] = function(p20) -- line: 622
				-- upvalues: color3 (copy)
				p20.BackgroundColor3 = color3
			end,
			Selectable = v121,
			BackgroundColor3 = color3,
			BackgroundTransparency = 0,
			TextColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Font = Enum.Font.BuilderSansBold,
			TextSize = 20
		}, {
			Corner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 8)
			})
		})
		local v123 = Roact.createElement("ScreenGui", {
			DisplayOrder = 8,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			Enabled = p18.state.showPrompt,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			Overlay = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = "",
				BackgroundColor3 = p18.promptStyle.Theme.Overlay.Color,
				BackgroundTransparency = p18.promptStyle.Theme.Overlay.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}),
			DialogMainFrame = Roact.createElement(UIBlox.Core.ImageSet.ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p18.promptStyle.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p18.promptStyle.Theme.BackgroundUIDefault.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				Size = UDim2.new(0, 365, 0, 55 + v109 + 1 + v115 + 14 + v117 + 36 + 40),
				AutomaticSize = AutomaticSizeY,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter,
				SelectionBehaviorDown = v120,
				SelectionBehaviorLeft = v120,
				SelectionBehaviorRight = v120,
				SelectionBehaviorUp = v120,
				SelectionGroup = v121,
				ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else p18.ref
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20)
				}),
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Icon = Roact.createElement(UIBlox.Core.ImageSet.ImageSetLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = p18.state.toastContent.iconImage,
					Size = UDim2.new(0, 55, 0, 55)
				}),
				TitleTextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v109),
					AutomaticSize = AutomaticSizeY
				}, {
					TitleText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = p18.promptStyle.Font.Header1,
						colorStyle = p18.promptStyle.Theme.SystemPrimaryDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = toastTitle
					})
				}),
				Divider = Roact.createElement("Frame", {
					BorderSizePixel = 0,
					LayoutOrder = 3,
					BackgroundColor3 = p18.promptStyle.Theme.Divider.Color,
					BackgroundTransparency = p18.promptStyle.Theme.Divider.Transparency,
					Size = UDim2.new(0.8, 0, 0, 1)
				}),
				DividerSpaceContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 7)
				}),
				BodyTextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, v115)
				}, {
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = p18.promptStyle.Font.Body,
						colorStyle = p18.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = v112
					})
				}),
				TextSpaceContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 6,
					Size = UDim2.new(1, 0, 0, 7)
				}),
				SubBodyTextContainer = not v96 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Size = UDim2.new(1, 0, 0, v117),
					AutomaticSize = AutomaticSizeY
				}, {
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = p18.promptStyle.Font.Body,
						colorStyle = p18.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = v116
					})
				}),
				SpaceContainer2 = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 8,
					Size = UDim2.new(1, 0, 0, 10)
				}),
				ButtonContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 9,
					Size = UDim2.new(1, 0, 0, 36),
					AutomaticSize = AutomaticSizeY
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 20),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					ConfirmButton = v122,
					SecondaryButton = v119 and Roact.createElement(UIBlox.App.Button.LinkButton, {
						colorStyleDefault = "TextMuted",
						colorStyleHover = "TextMuted",
						layoutOrder = not v46 and 1 or 2,
						size = UDim2.new(1, -5, 0, 36),
						text = if not v100 then v61 else v65,
						onActivated = p18.handleSecondaryActivated
					})
				})
			})
		})

		if v103 then
			v123 = Roact.createElement(DevicePermissionsModal, {
				titleText = t1[p18.state.promptType],
				bodyText = t2[p18.state.promptType],
				handlePrimaryActivated = p18.handlePrimayActivated,
				handleSecondaryActivated = p18.handleSecondaryActivated,
				Analytics = p18.props.Analytics,
				promptStyle = p18.promptStyle,
				showPrompt = p18.state.showPrompt,
				settingsAppAvailable = p18.props.settingsAppAvailable,
				UserInputService = if p18.props.UserInputService == nil then UserInputService else p18.props.UserInputService,
				ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else p18.ref
			})
		end

		if v102 then
			v123 = Roact.createElement(VoiceChatConsentModal, {
				titleText = t1[p18.state.promptType],
				bodyText = t2[p18.state.promptType],
				handlePrimaryActivated = p18.handlePrimayActivated,
				handleSecondaryActivated = p18.handleSecondaryActivated,
				Analytics = p18.props.Analytics,
				showCheckbox = p18.props.showCheckbox,
				promptStyle = p18.promptStyle,
				showPrompt = p18.state.showPrompt,
				ref = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else p18.ref
			})
		end

		return (Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			InGameMenuInformationalDialog = v123
		}))
	end

	if p18.state.promptType == PromptType.JoinVoiceSTUX then
		return (Roact.createElement(VoiceChatTooltip, {
			titleText = t1[p18.state.promptType],
			subtitleText = t2[p18.state.promptType],
			promptStyle = p18.promptStyle,
			showPrompt = p18.state.showPrompt,
			onClose = function() -- line: 854
				-- upvalues: p18 (copy)
				p18:setState({
					showPrompt = false
				})
			end,
			onMenuOpen = p18.hideOnMenuOpen
		}))
	end

	local v124 = if not v97 then p18.state.promptType ~= PromptType.JoinedVoiceToast and 3 or GetFIntVoiceJoinM3ToastDurationSeconds() else GetFIntVoiceToxicityToastDurationSeconds()
	local showPrompt = p18.state.showPrompt

	if p18.state.promptType == PromptType.VoiceDataConsentOptOutToast and GetFFlagEnableSeamlessVoiceDataConsentToast() then
		showPrompt = not not p18.props.showDataConsentToast and p18.props.showDataConsentToast
	end

	return (Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = p18.onScreenSizeChanged
	}, {
		Toast = p18.state.promptType ~= PromptType.None and Roact.createElement(Toast, {
			duration = if not v97 then v124 else GetFIntVoiceToxicityToastDurationSeconds(),
			toastContent = p18.state.toastContent,
			show = showPrompt
		}),
		EventConnection = p18.props.promptSignal and Roact.createElement(ExternalEventConnection, {
			event = p18.props.promptSignal,
			callback = p18.promptSignalCallback
		})
	}))
end
function v76.didUpdate(p21) -- line: 898
	-- upvalues: GetFFlagSupportGamepadNavInVoiceModals (copy), Responsive (copy), GuiService (copy)
	if GetFFlagSupportGamepadNavInVoiceModals() then
		if p21.props.lastInput == Responsive.Input.Directional then
			local v127 = p21.ref:getValue()

			if p21.state.showPrompt and v127 then
				GuiService:Select(v127)
			end

			if not p21.state.showPrompt and v127 then
				GuiService.SelectedCoreObject = nil

				return
			end
		elseif GuiService.SelectedCoreObject then
			GuiService.SelectedCoreObject = nil
		end
	end
end
function v76.didMount(p22) -- line: 930
	-- upvalues: ContextActionService (copy)
	if p22.props.onReadyForSignal then
		p22.props.onReadyForSignal()
	end

	ContextActionService:BindCoreAction("CloseVoiceBanPrompt", p22.checkInputStateForClosePrompt, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("CloseVoiceBanPrompt", p22.checkInputStateForClosePrompt, false, Enum.KeyCode.ButtonB)
end

local u77 = InGameMenuPolicy.connect(function(p23, _) -- line: 948
	return {
		showNewContent = p23.getGameInfoShowChatFeatures(),
		showCheckbox = p23.getDisplayCheckboxInVoiceConsent(),
		showDataConsentToast = p23.getDisplayCheckboxInVoiceConsent() ~= nil and p23.getDisplayCheckboxInVoiceConsent()
	}
end)(v76)

local function WrappedVoiceChatPromptFrame(p25) -- line: 958
	-- upvalues: useStyle (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), useLastInput (copy), Roact (copy), u77 (ref), Cryo (copy)
	local v132 = useStyle()
	local v133 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else useLastInput()

	return Roact.createElement(u77, Cryo.Dictionary.join(p25, {
		appStyle = v132,
		lastInput = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else v133
	}))
end

return function(p26) -- line: 969
	-- upvalues: renderWithCoreScriptsStyleProvider (copy), Roact (copy), WrappedVoiceChatPromptFrame (copy)
	return renderWithCoreScriptsStyleProvider({ Roact.createElement(WrappedVoiceChatPromptFrame, p26) })
end
