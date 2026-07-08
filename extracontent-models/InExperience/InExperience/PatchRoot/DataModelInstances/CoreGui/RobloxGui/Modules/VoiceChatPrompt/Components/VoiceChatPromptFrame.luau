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
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local LocalizationService = game:GetService("LocalizationService")
local v49 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
local color3 = Color3.fromRGB(255, 255, 255)
local color3_2 = Color3.fromRGB(220, 220, 220)

Roact.PureComponent:extend("VoiceChatPromptFrame")

local t1 = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NotAudible"),
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
	[PromptType.LeaveVoice] = if not GetFFlagUpdateVoiceConnectionToasts() then RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.LeaveVoiceChat") else v49:Format("Feature.SettingsHub.Prompt.LeaveVoiceChatV2"),
	[PromptType.JoinVoice] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChatV2"),
	[PromptType.DevicePermissionsModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NeedMicrophoneAccess"),
	[PromptType.VoiceDataConsentOptOutToast] = if not GetFFlagEnableSeamlessVoiceDataConsentToast() then nil else v49:Format("Feature.SettingsHub.Prompt.Title.ImproveVoiceChat"),
	[PromptType.UnifiedJoinVoiceToast] = if not GetFFlagUpdateVoiceConnectionToasts() then nil else v49:Format("Feature.SettingsHub.Prompt.JoinedVoiceChatV3"),
	[PromptType.AgeCheckForVoiceToast] = v49:Format("Feature.SettingsHub.Prompt.Title.AgeCheckForVoiceToast"),
	[PromptType.UpdateOnAutoJoinToast] = if not GetFFlagEnableVoiceTrustedConnectionsToasts() then nil else v49:Format("Feature.SettingsHub.Prompt.UpdateToVoiceChat"),
	[PromptType.VoiceChatSuspendedTemporaryBV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspendedV2"),
	[PromptType.VoiceToxicityModalV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat"),
	[PromptType.VoiceToxicityToastV2] = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat")
}
local v53 = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupTrustedConnections" or "Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupTrustedFriends"
local v54 = not FFlagConnectionsToFriendsRename and "Feature.SettingsHub.Prompt.Subtitle.TalkAgeGroupTrustedConnectionsUpdate" or "Feature.SettingsHub.Prompt.Subtitle.TalkAgeGroupTrustedFriendsUpdate"
local t2 = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.NotAudible"),
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
	[PromptType.VoiceChatSuspendedTemporaryToast] = function(p1) -- line: 186
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
	[PromptType.VoiceDataConsentOptOutToast] = if not GetFFlagEnableSeamlessVoiceDataConsentToast() then nil else v49:Format("Feature.SettingsHub.Prompt.Subtitle.ThanksForVoiceData"),
	[PromptType.UnifiedJoinVoiceToast] = if not GetFFlagVoiceConnectToastCapturesTrustedFriendsSubtitle then if not GetFFlagEnableVoiceTrustedConnectionsToasts() then if not GetFFlagUpdateVoiceConnectionToasts() then nil else v49:Format("Feature.SettingsHub.Prompt.Subtitle.TalkInAgeGroupV2") else v49:Format(v53) else RobloxTranslator:FormatByKey("Feature.Captures.Prompt.Subtitle.VoiceChatRecordingTrustedFriendsAgeGroup"),
	[PromptType.AgeCheckForVoiceToast] = v49:Format("Feature.SettingsHub.Prompt.Subtitle.GoToAccountInfo"),
	[PromptType.UpdateOnAutoJoinToast] = if not GetFFlagEnableVoiceTrustedConnectionsToasts() then nil else v49:Format(v54),
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

local v56 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.FutureViolations")
local v57 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.EffectiveUntil")
local v58 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Understand")
local v59 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GotIt")
local v60 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudge")
local v61 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2")
local v62 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Ok")
local v63 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2V2")
local v64 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudgeV2")

local function PromptTypeIsBan(p2) -- line: 265
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p2 == PromptType.VoiceChatSuspendedPermanent or (p2 == PromptType.VoiceChatSuspendedTemporary or (p2 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p2 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p2 == PromptType.VoiceChatSuspendedTemporaryBV2)))
end
local function IsModalNudge(p3) -- line: 273
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p3 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p3 == PromptType.VoiceToxicityModalV2
end
local function IsVoiceConsentModal(p4) -- line: 278
	-- upvalues: PromptType (copy)
	return p4 == PromptType.VoiceConsentModalV1 or (p4 == PromptType.VoiceConsentModalV2 or p4 == PromptType.VoiceConsentModalV3)
end
local function IsDevicePermissionsModal(p5) -- line: 284
	-- upvalues: PromptType (copy)
	return p5 == PromptType.DevicePermissionsModal
end
local function PromptTypeIsModal(p6) -- line: 288
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p6 == PromptType.VoiceChatSuspendedPermanent or (p6 == PromptType.VoiceChatSuspendedTemporary or (p6 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p6 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p6 == PromptType.VoiceChatSuspendedTemporaryBV2))) or (p6 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p6 == PromptType.VoiceToxicityModalV2 or (p6 == PromptType.VoiceConsentModalV1 or (p6 == PromptType.VoiceConsentModalV2 or p6 == PromptType.VoiceConsentModalV3) or p6 == PromptType.DevicePermissionsModal))
end
local function PromptTypeIsVoiceConsent(p7) -- line: 295
	-- upvalues: PromptType (copy)
	return p7 == PromptType.VoiceConsentDeclinedToast or p7 == PromptType.VoiceConsentAcceptedToast
end
local function PromptTypeIsVoiceDataConsent(p8) -- line: 299
	-- upvalues: PromptType (copy)
	return p8 == PromptType.VoiceDataConsentOptOutToast
end
local function PromptTypeIsConnectDisconnectToast(p9) -- line: 303
	-- upvalues: PromptType (copy), GetFFlagUpdateVoiceConnectionToasts (copy)
	return p9 == PromptType.JoinVoice or (p9 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p9 == PromptType.UnifiedJoinVoiceToast)
end
local function ShouldShowBannedUntil(p10) -- line: 309
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p10 == PromptType.VoiceChatSuspendedTemporary or (p10 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p10 == PromptType.VoiceChatSuspendedTemporaryToast or (p10 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p10 == PromptType.VoiceChatSuspendedTemporaryBV2)))
end
local function ShouldShowSecondaryButton(p11) -- line: 317
	-- upvalues: PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy)
	return p11 == PromptType.VoiceChatSuspendedTemporaryB or (GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p11 == PromptType.VoiceChatSuspendedTemporaryBV2 or (p11 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p11 == PromptType.VoiceToxicityModalV2))
end

local v75 = Roact.PureComponent:extend("VoiceChatPromptFrame")

v75.validateProps = t.strictInterface({
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

function v75.init(p12) -- line: 342
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
		local v90 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended")
		local v91 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporarySuspension2")

		t1[PromptType.VoiceChatSuspendedTemporary] = v90
		t1[PromptType.VoiceChatSuspendedPermanent] = v90
		t2[PromptType.VoiceChatSuspendedTemporary] = v91
	end

	function p12.onScreenSizeChanged(p13) -- line: 366
		-- upvalues: p12 (copy)
		if p12.state.screenSize ~= p13.AbsoluteSize then
			p12:setState({
				screenSize = p13.AbsoluteSize
			})
		end
	end
	function p12.promptSignalCallback(p14) -- line: 374
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
			local v137 = t1[p14]
			local v138 = t2[p14]

			if (p14 == PromptType.JoinVoice or (p14 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p14 == PromptType.UnifiedJoinVoiceToast)) and p12.props.VoiceChatServiceManager and p12.props.VoiceChatServiceManager:HasSeamlessVoiceFeature("HideJoinToastSubtitle") then
				v138 = nil
			end

			if typeof(v137) == "function" then
				v137 = v137(p12.props.bannedUntil)
			end

			if typeof(v138) == "function" then
				v138 = v138(p12.props.bannedUntil)
			end

			local v139 = if not GetFFlagEnableVoiceTrustedConnectionsToasts() or p14 ~= PromptType.UpdateOnAutoJoinToast then if not (p14 == PromptType.VoiceConsentDeclinedToast or p14 == PromptType.VoiceConsentAcceptedToast) and (p14 ~= PromptType.JoinedVoiceToast and (not GetFFlagUpdateVoiceConnectionToasts() or p14 ~= PromptType.UnifiedJoinVoiceToast)) then if not (p14 == PromptType.JoinVoice or (p14 == PromptType.LeaveVoice or GetFFlagUpdateVoiceConnectionToasts() and p14 == PromptType.UnifiedJoinVoiceToast)) then if p14 ~= PromptType.VoiceDataConsentOptOutToast or not GetFFlagEnableSeamlessVoiceDataConsentToast() then Images["icons/status/alert"] else nil else Images["icons/actions/info"] else Images["icons/controls/publicAudioJoin"] else Images["icons/controls/microphone"]

			p12:setState({
				showPrompt = true,
				promptType = p14,
				toastContent = {
					iconImage = v139,
					toastTitle = v137,
					toastSubtitle = v138,
					onActivated = function() -- line: 452
						-- upvalues: p12 (copy)
						if p12.props.onPrimaryActivated then
							p12.props.onPrimaryActivated()
						end
					end,
					onDismissed = function() -- line: 457
					end
				}
			})

			if p14 == PromptType.VoiceChatSuspendedTemporary or (p14 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (p14 == PromptType.VoiceChatSuspendedTemporaryToast or (p14 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p14 == PromptType.VoiceChatSuspendedTemporaryBV2))) then
				local v140 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspension", {
					banDurationInMinutes = p12.props.bannedUntil
				})
				local v141 = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspensionV2", {
					banDurationInMinutes = p12.props.bannedUntil
				})
				local v142 = if p14 ~= PromptType.VoiceChatSuspendedTemporaryB then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or p14 ~= PromptType.VoiceChatSuspendedTemporaryBV2 then " " .. p12.props.bannedUntil .. "." else v141 else v140

				p12:setState({
					banEnd = v142
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
	function p12.closeVoiceBanPrompt() -- line: 487
		-- upvalues: p12 (copy), ContextActionService (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), v34 (copy)
		p12:setState({
			showPrompt = false
		})

		if p12.props.onContinueFunc then
			p12.props.onContinueFunc()
		end

		ContextActionService:UnbindCoreAction("CloseVoiceBanPrompt")

		local v143 = p12.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
		local v144 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and p12.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2)

		if v34 then
			local promptType = p12.state.promptType

			if (promptType == PromptType.VoiceChatSuspendedPermanent or (promptType == PromptType.VoiceChatSuspendedTemporary or (promptType == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (promptType == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceChatSuspendedTemporaryBV2)))) and not v143 and not v144 then
				if p12.props.Analytics then
					p12.props.Analytics:reportBanMessageEvent("Acknowledged")
				end

				if p12.props.VoiceChatServiceManager then
					p12.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")

					return
				end
			end
		elseif not v143 and not v144 then
			if p12.props.Analytics then
				p12.props.Analytics:reportBanMessageEvent("Acknowledged")
			end

			if p12.props.VoiceChatServiceManager then
				p12.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")
			end
		end
	end
	function p12.checkInputStateForClosePrompt(_, p16, _) -- line: 522
		-- upvalues: p12 (copy)
		if p16 == Enum.UserInputState.Begin then
			p12.closeVoiceBanPrompt()
		end
	end
	function p12.handlePrimayActivated() -- line: 528
		-- upvalues: p12 (copy)
		p12.closeVoiceBanPrompt()

		if p12.props.onPrimaryActivated then
			p12.props.onPrimaryActivated()
		end
	end
	function p12.handleSecondaryActivated() -- line: 535
		-- upvalues: p12 (copy)
		p12.closeVoiceBanPrompt()

		if p12.props.onSecondaryActivated then
			p12.props.onSecondaryActivated()
		end
	end
end
function v75.render(p18) -- line: 543
	-- upvalues: GetFFlagEnableVoicePromptReasonText (copy), PromptType (copy), GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 (copy), VoiceNudgeUseNewDACopy (copy), GetFFlagShowDevicePermissionsModal (copy), TextService (copy), v57 (copy), v61 (copy), v63 (copy), v56 (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), v46 (copy), Roact (copy), v62 (copy), v59 (copy), v58 (copy), color3_2 (copy), color3 (copy), Button (copy), ButtonType (copy), UIBlox (copy), Assets (copy), v64 (copy), v60 (copy), DevicePermissionsModal (copy), t1 (copy), t2 (copy), UserInputService (copy), VoiceChatConsentModal (copy), CoreGui (copy), VoiceChatTooltip (copy), GetFIntVoiceToxicityToastDurationSeconds (copy), GetFIntVoiceJoinM3ToastDurationSeconds (copy), GetFFlagEnableSeamlessVoiceDataConsentToast (copy), Toast (copy), ExternalEventConnection (copy)
	local v93 = GetFFlagEnableVoicePromptReasonText() and p18.props.errorText or nil
	local promptType = p18.state.promptType
	local v95 = promptType == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceToxicityModalV2
	local v96 = p18.state.promptType == PromptType.VoiceToxicityToast or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p18.state.promptType == PromptType.VoiceToxicityToastV2
	local v97 = p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
	local v98 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2)
	local v99 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and (VoiceNudgeUseNewDACopy() and (p18.state.promptType == PromptType.VoiceToxicityModalV2 or p18.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2))
	local promptType2 = p18.state.promptType
	local v101 = promptType2 == PromptType.VoiceConsentModalV1 or (promptType2 == PromptType.VoiceConsentModalV2 or promptType2 == PromptType.VoiceConsentModalV3)
	local v102 = GetFFlagShowDevicePermissionsModal() and p18.state.promptType == PromptType.DevicePermissionsModal
	local AutomaticSizeY = Enum.AutomaticSize.Y
	local promptType3 = p18.state.promptType

	if promptType3 == PromptType.VoiceChatSuspendedPermanent or (promptType3 == PromptType.VoiceChatSuspendedTemporary or (promptType3 == PromptType.VoiceChatSuspendedTemporaryAvatarChat or (promptType3 == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType3 == PromptType.VoiceChatSuspendedTemporaryBV2))) or (promptType3 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType3 == PromptType.VoiceToxicityModalV2 or (promptType3 == PromptType.VoiceConsentModalV1 or (promptType3 == PromptType.VoiceConsentModalV2 or promptType3 == PromptType.VoiceConsentModalV3) or promptType3 == PromptType.DevicePermissionsModal)) then
		local toastTitle = p18.state.toastContent.toastTitle
		local Header1Font = p18.promptStyle.Font.Header1.Font
		local v107 = p18.promptStyle.Font.Header1.RelativeSize * p18.promptStyle.Font.BaseSize
		local v108 = 20 + TextService:GetTextSize(toastTitle, v107, Header1Font, Vector2.new(325, 1e999)).Y
		local v109 = if not v97 and (not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or not v98) then v57 .. p18.state.banEnd else p18.state.banEnd
		local v110 = if p18.state.banEnd == "" then p18.state.toastContent.toastSubtitle .. p18.state.banEnd else "<b>" .. v109 .. "</b><br />" .. p18.state.toastContent.toastSubtitle
		local v111 = v93 or v110
		local BodyFont = p18.promptStyle.Font.Body.Font
		local v113 = p18.promptStyle.Font.Body.RelativeSize * p18.promptStyle.Font.BaseSize
		local v114 = 20 + TextService:GetTextSize(v111, v113, BodyFont, Vector2.new(325, 1e999)).Y

		if v97 or v98 then
			v114 += 20
		end

		local v115 = if not v97 then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or not v98 then v56 else v63 else v61
		local v116 = 20 + TextService:GetTextSize(v115, v113, BodyFont, Vector2.new(325, 1e999)).Y
		local promptType4 = p18.state.promptType
		local v118 = promptType4 == PromptType.VoiceChatSuspendedTemporaryB or (GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType4 == PromptType.VoiceChatSuspendedTemporaryBV2 or (promptType4 == PromptType.VoiceToxicityModal or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType4 == PromptType.VoiceToxicityModalV2))
		local v119 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else Enum.SelectionBehavior.Stop
		local v120 = not not GetFFlagSupportGamepadNavInVoiceModals() or nil
		local v121 = if not v46 then Roact.createElement(Button, {
			layoutOrder = 1,
			buttonType = ButtonType.PrimarySystem,
			size = UDim2.new(1, -5, 0, 48),
			text = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not VoiceNudgeUseNewDACopy() or not v98) then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not v95 or (not VoiceNudgeUseNewDACopy() or p18.state.promptType ~= PromptType.VoiceToxicityModalV2)) then if not v95 then v58 else v59 else v62 else v62,
			onActivated = p18.handlePrimayActivated,
			Selectable = v120
		}) else Roact.createElement("TextButton", {
			Size = UDim2.new(1, -5, 0, 48),
			LayoutOrder = 1,
			Text = if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not VoiceNudgeUseNewDACopy() or not v98) then if not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() or (not v95 or (not VoiceNudgeUseNewDACopy() or p18.state.promptType ~= PromptType.VoiceToxicityModalV2)) then if not v95 then v58 else v59 else v62 else v62,
			[Roact.Event.Activated] = p18.handlePrimayActivated,
			[Roact.Event.MouseEnter] = function(p19) -- line: 611
				-- upvalues: color3_2 (copy)
				p19.BackgroundColor3 = color3_2
			end,
			[Roact.Event.MouseLeave] = function(p20) -- line: 614
				-- upvalues: color3 (copy)
				p20.BackgroundColor3 = color3
			end,
			Selectable = v120,
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
		local v122 = Roact.createElement("ScreenGui", {
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
				Size = UDim2.new(0, 365, 0, 55 + v108 + 1 + v114 + 14 + v116 + 36 + 40),
				AutomaticSize = AutomaticSizeY,
				SliceCenter = Assets.Images.RoundedRect.SliceCenter,
				SelectionBehaviorDown = v119,
				SelectionBehaviorLeft = v119,
				SelectionBehaviorRight = v119,
				SelectionBehaviorUp = v119,
				SelectionGroup = v120,
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
					Size = UDim2.new(1, 0, 0, v108),
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
					Size = UDim2.new(1, 0, 0, v114)
				}, {
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = p18.promptStyle.Font.Body,
						colorStyle = p18.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = v111
					})
				}),
				TextSpaceContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 6,
					Size = UDim2.new(1, 0, 0, 7)
				}),
				SubBodyTextContainer = not v95 and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Size = UDim2.new(1, 0, 0, v116),
					AutomaticSize = AutomaticSizeY
				}, {
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = p18.promptStyle.Font.Body,
						colorStyle = p18.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = v115
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
					ConfirmButton = v121,
					SecondaryButton = v118 and Roact.createElement(UIBlox.App.Button.LinkButton, {
						colorStyleDefault = "TextMuted",
						colorStyleHover = "TextMuted",
						layoutOrder = not v46 and 1 or 2,
						size = UDim2.new(1, -5, 0, 36),
						text = if not v99 then v60 else v64,
						onActivated = p18.handleSecondaryActivated
					})
				})
			})
		})

		if v102 then
			v122 = Roact.createElement(DevicePermissionsModal, {
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

		if v101 then
			v122 = Roact.createElement(VoiceChatConsentModal, {
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
			InGameMenuInformationalDialog = v122
		}))
	end

	if p18.state.promptType == PromptType.JoinVoiceSTUX then
		return (Roact.createElement(VoiceChatTooltip, {
			titleText = t1[p18.state.promptType],
			subtitleText = t2[p18.state.promptType],
			promptStyle = p18.promptStyle,
			showPrompt = p18.state.showPrompt,
			onClose = function() -- line: 846
				-- upvalues: p18 (copy)
				p18:setState({
					showPrompt = false
				})
			end,
			onMenuOpen = p18.hideOnMenuOpen
		}))
	end

	local v123 = if not v96 then p18.state.promptType ~= PromptType.JoinedVoiceToast and 3 or GetFIntVoiceJoinM3ToastDurationSeconds() else GetFIntVoiceToxicityToastDurationSeconds()
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
			duration = if not v96 then v123 else GetFIntVoiceToxicityToastDurationSeconds(),
			toastContent = p18.state.toastContent,
			show = showPrompt
		}),
		EventConnection = p18.props.promptSignal and Roact.createElement(ExternalEventConnection, {
			event = p18.props.promptSignal,
			callback = p18.promptSignalCallback
		})
	}))
end
function v75.didUpdate(p21) -- line: 890
	-- upvalues: GetFFlagSupportGamepadNavInVoiceModals (copy), Responsive (copy), GuiService (copy)
	if GetFFlagSupportGamepadNavInVoiceModals() then
		if p21.props.lastInput == Responsive.Input.Directional then
			local v126 = p21.ref:getValue()

			if p21.state.showPrompt and v126 then
				GuiService:Select(v126)
			end

			if not p21.state.showPrompt and v126 then
				GuiService.SelectedCoreObject = nil

				return
			end
		elseif GuiService.SelectedCoreObject then
			GuiService.SelectedCoreObject = nil
		end
	end
end
function v75.didMount(p22) -- line: 922
	-- upvalues: ContextActionService (copy)
	if p22.props.onReadyForSignal then
		p22.props.onReadyForSignal()
	end

	ContextActionService:BindCoreAction("CloseVoiceBanPrompt", p22.checkInputStateForClosePrompt, false, Enum.KeyCode.ButtonA)
	ContextActionService:BindCoreAction("CloseVoiceBanPrompt", p22.checkInputStateForClosePrompt, false, Enum.KeyCode.ButtonB)
end

local u76 = InGameMenuPolicy.connect(function(p23, _) -- line: 940
	return {
		showNewContent = p23.getGameInfoShowChatFeatures(),
		showCheckbox = p23.getDisplayCheckboxInVoiceConsent(),
		showDataConsentToast = p23.getDisplayCheckboxInVoiceConsent() ~= nil and p23.getDisplayCheckboxInVoiceConsent()
	}
end)(v75)

local function WrappedVoiceChatPromptFrame(p25) -- line: 950
	-- upvalues: useStyle (copy), GetFFlagSupportGamepadNavInVoiceModals (copy), useLastInput (copy), Roact (copy), u76 (ref), Cryo (copy)
	local v131 = useStyle()
	local v132 = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else useLastInput()

	return Roact.createElement(u76, Cryo.Dictionary.join(p25, {
		appStyle = v131,
		lastInput = if not GetFFlagSupportGamepadNavInVoiceModals() then nil else v132
	}))
end

return function(p26) -- line: 961
	-- upvalues: renderWithCoreScriptsStyleProvider (copy), Roact (copy), WrappedVoiceChatPromptFrame (copy)
	return renderWithCoreScriptsStyleProvider({ Roact.createElement(WrappedVoiceChatPromptFrame, p26) })
end
