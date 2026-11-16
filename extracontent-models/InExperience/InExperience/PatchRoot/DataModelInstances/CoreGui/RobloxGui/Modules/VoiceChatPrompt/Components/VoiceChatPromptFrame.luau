local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local ContextActionService = game:GetService("ContextActionService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)

local FFlagVoiceChatBanDurationUseServerTime = require(script.Parent.Parent.Parent.VoiceChat.Flags.FFlagVoiceChatBanDurationUseServerTime)
local Cryo = require(CorePackages.Packages.Cryo)

local renderWithCoreScriptsStyleProvider = require(script.Parent.Parent.Parent.Common.renderWithCoreScriptsStyleProvider)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useLastInput = Responsive.useLastInput

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local getFFlagMicConsumerRegistry = VoiceChatCore.Flags and VoiceChatCore.Flags.GetFFlagMicConsumerRegistry
local VoiceChat = require(CorePackages.Workspace.Packages.VoiceChat)

local Flags = VoiceChat.Flags

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetFFlagEnableVoicePromptReasonText = require(RobloxGui.Modules.Flags.GetFFlagEnableVoicePromptReasonText)
local GetFFlagSupportGamepadNavInVoiceModals = Flags.GetFFlagSupportGamepadNavInVoiceModals

local GetFIntVoiceToxicityToastDurationSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceToxicityToastDurationSeconds)
local defineFastFlag = game:DefineFastFlag("VoiceChatOnlyReportVoiceBans", false)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagShowDevicePermissionsModal = SharedFlags.GetFFlagShowDevicePermissionsModal

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local GetFIntVoiceJoinM3ToastDurationSeconds = require(RobloxGui.Modules.Flags.GetFIntVoiceJoinM3ToastDurationSeconds)

local GetFFlagEnableSeamlessVoiceDataConsentToast = require(RobloxGui.Modules.Flags.GetFFlagEnableSeamlessVoiceDataConsentToast)

local GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2 = require(script.Parent.Parent.Parent.VoiceChat.Flags.GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2)
local VoiceNudgeUseNewDACopy = require(script.Parent.Parent.Parent.VoiceChat.Helpers.VoiceNudgeUseNewDACopy)
local defineFastFlag2 = game:DefineFastFlag("VoiceNudgeUseNewConfirmButton", false)

local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(script.Parent.Parent.Parent.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)

local color = Color3.fromRGB(255, 255, 255)
local color2 = Color3.fromRGB(220, 220, 220)

local function formatMicPromptText(p, p2)
	if not getFFlagMicConsumerRegistry() then
		return nil
	end

	local success, result = pcall(function()
		return localization:Format(p)
	end)
	return if success then result else p2
end

local function getMicPermissionDeniedTitle()
	if not getFFlagMicConsumerRegistry() then
		return nil
	end

	local v = "Feature.SettingsHub.Prompt.MicPermissionDenied"
	local success, result = pcall(function()
		return localization:Format(v)
	end)
	return if success then result else "Can't access microphone"
end

local function getMicFirstUnmutePrivacyTitle()
	if not getFFlagMicConsumerRegistry() then
		return nil
	end

	local v = "Feature.SettingsHub.Prompt.MicFirstUnmutePrivacy"
	local success, result = pcall(function()
		return localization:Format(v)
	end)
	return if success then result else "Microphone is active"
end

local function getMicPermissionDeniedSubtitle()
	if not getFFlagMicConsumerRegistry() then
		return nil
	end

	local v = "Feature.SettingsHub.Prompt.Subtitle.MicPermissionDenied"
	local success, result = pcall(function()
		return localization:Format(v)
	end)

	if success then
		return result
	end

	return "To use your microphone, tap here to update your device settings."
end

local function getMicFirstUnmutePrivacySubtitle()
	if not getFFlagMicConsumerRegistry() then
		return nil
	end

	local v = "Feature.SettingsHub.Prompt.Subtitle.MicFirstUnmutePrivacy"
	local success, result = pcall(function()
		return localization:Format(v)
	end)

	if success then
		return result
	end

	return "We process and then delete your audio. Tap to view our privacy policy."
end

Roact.PureComponent:extend("VoiceChatPromptFrame")

local v = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NotAudible")
}
local NotAudibleVoiceChatVolume = PromptType.NotAudibleVoiceChatVolume
local v2

if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast then
	v2 = localization:Format("Feature.SettingsHub.Prompt.NotAudible")
end

v[NotAudibleVoiceChatVolume] = v2

v[PromptType.Permission] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicrophonePermission")
v[PromptType.Retry] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicrophonePermission")
v[PromptType.Place] = "Exceeds Max Players"
v[PromptType.User] = "Not Eligible for Voice"
v[PromptType.VoiceChatSuspendedTemporaryAvatarChat] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicAndCameraUseSuspended")

v[PromptType.VoiceChatSuspendedTemporary] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended")

v[PromptType.VoiceChatSuspendedTemporaryB] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspended")

v[PromptType.VoiceChatSuspendedPermanent] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspended")

v[PromptType.VoiceLoading] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Connecting")
v[PromptType.VoiceToxicityModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRules")
v[PromptType.VoiceToxicityToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRules")
v[PromptType.VoiceToxicityFeedbackToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.ThankYouForFeedback")

v[PromptType.VoiceChatSuspendedTemporaryToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended")

v[PromptType.VoiceConsentDeclinedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.ChangeYourMind")
v[PromptType.VoiceConsentAcceptedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat")
v[PromptType.VoiceConsentModalV1] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GetVoiceChat")
v[PromptType.VoiceConsentModalV2] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatWithOthers")
v[PromptType.VoiceConsentModalV3] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GetVoiceChat")
v[PromptType.JoinedVoiceToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat")
v[PromptType.JoinVoiceSTUX] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChat")
v[PromptType.LeaveVoice] = localization:Format("Feature.SettingsHub.Prompt.LeaveVoiceChatV2")
v[PromptType.JoinVoice] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.JoinedVoiceChatV2")
v[PromptType.DevicePermissionsModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.NeedMicrophoneAccess")

local VoiceDataConsentOptOutToast = PromptType.VoiceDataConsentOptOutToast
local v3

if GetFFlagEnableSeamlessVoiceDataConsentToast() then
	v3 = localization:Format("Feature.SettingsHub.Prompt.Title.ImproveVoiceChat")
end

v[VoiceDataConsentOptOutToast] = v3

v[PromptType.UnifiedJoinVoiceToast] = localization:Format("Feature.SettingsHub.Prompt.JoinedVoiceChatV3")
v[PromptType.AgeCheckForVoiceToast] = localization:Format("Feature.SettingsHub.Prompt.Title.AgeCheckForVoiceToast")
v[PromptType.UpdateOnAutoJoinToast] = localization:Format("Feature.SettingsHub.Prompt.UpdateToVoiceChat")
local VoiceChatSuspendedTemporaryBV2 = PromptType.VoiceChatSuspendedTemporaryBV2
local v4

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v4 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.VoiceChatSuspendedV2")
end

v[VoiceChatSuspendedTemporaryBV2] = v4

local VoiceToxicityModalV2 = PromptType.VoiceToxicityModalV2
local v5

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v5 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat")
end

v[VoiceToxicityModalV2] = v5

local VoiceToxicityToastV2 = PromptType.VoiceToxicityToastV2
local v6

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v6 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.RememberRulesVoiceChat")
end

v[VoiceToxicityToastV2] = v6

v[PromptType.MicPermissionDenied] = getMicPermissionDeniedTitle
v[PromptType.MicFirstUnmutePrivacy] = getMicFirstUnmutePrivacyTitle

local v7 = {
	[PromptType.None] = "",
	[PromptType.NotAudible] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.NotAudible")
}
local notAudibleVoiceChatVolume = PromptType.NotAudibleVoiceChatVolume
local v8

if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast then
	v8 = localization:Format("Feature.SettingsHub.Prompt.Subtitle.NotAudibleVoiceChatVolume")
end

v7[notAudibleVoiceChatVolume] = v8

v7[PromptType.Permission] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MicrophonePermission")
v7[PromptType.Retry] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Retry")
v7[PromptType.Place] = "Spatial voice is only available for places with Max Players of 30 or less."
v7[PromptType.User] = "This account is not eligible to use Spatial Voice."
v7[PromptType.VoiceChatSuspendedTemporary] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Microphone")

v7[PromptType.VoiceChatSuspendedTemporaryAvatarChat] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MicAndCamera")

v7[PromptType.VoiceChatSuspendedTemporaryB] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan1")

v7[PromptType.VoiceChatSuspendedPermanent] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Revoked")

v7[PromptType.VoiceLoading] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Connecting")
v7[PromptType.VoiceToxicityModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityModal")

v7[PromptType.VoiceToxicityToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityToast")

v7[PromptType.VoiceToxicityFeedbackToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.ThanksForLettingUsKnow")

v7[PromptType.VoiceChatSuspendedTemporaryToast] = function(dateTime)
	return RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.ChatWithVoiceDisabledUntil", {
		dateTime = dateTime
	})
end

v7[PromptType.VoiceConsentDeclinedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.JoinVoiceLater")

v7[PromptType.VoiceConsentAcceptedToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.MuteAnyoneAnytime")

v7[PromptType.VoiceConsentModalV1] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell1")

v7[PromptType.VoiceConsentModalV2] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell2")

v7[PromptType.VoiceConsentModalV3] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.InExpVoiceUpsell2")

v7[PromptType.JoinedVoiceToast] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.DisconnectOrMute")

v7[PromptType.JoinVoiceSTUX] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.DisconnectOrMuteHere")

v7[PromptType.DevicePermissionsModal] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.AllowMicrophoneAccess")

local voiceDataConsentOptOutToast = PromptType.VoiceDataConsentOptOutToast
local v9

if GetFFlagEnableSeamlessVoiceDataConsentToast() then
	v9 = localization:Format("Feature.SettingsHub.Prompt.Subtitle.ThanksForVoiceData")
end

v7[voiceDataConsentOptOutToast] = v9

v7[PromptType.UnifiedJoinVoiceToast] = RobloxTranslator:FormatByKey("Feature.Captures.Prompt.Subtitle.VoiceChatRecordingTrustedFriendsAgeGroup")

v7[PromptType.AgeCheckForVoiceToast] = localization:Format("Feature.SettingsHub.Prompt.Subtitle.GoToAccountInfo")
v7[PromptType.UpdateOnAutoJoinToast] = localization:Format("Feature.SettingsHub.Prompt.Subtitle.TalkAgeGroupTrustedFriendsUpdate")
local voiceChatSuspendedTemporaryBV2 = PromptType.VoiceChatSuspendedTemporaryBV2
local v10

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v10 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan1V2")
end

v7[voiceChatSuspendedTemporaryBV2] = v10

local voiceToxicityModalV2 = PromptType.VoiceToxicityModalV2
local v11

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v11 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityModalV2")
end

v7[voiceToxicityModalV2] = v11

local voiceToxicityToastV2 = PromptType.VoiceToxicityToastV2
local v12

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v12 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.VoiceToxicityToastV2")
end

v7[voiceToxicityToastV2] = v12

v7[PromptType.MicPermissionDenied] = getMicPermissionDeniedSubtitle
v7[PromptType.MicFirstUnmutePrivacy] = getMicFirstUnmutePrivacySubtitle

if RunService:IsStudio() then
	v[PromptType.Place] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Place")
	v[PromptType.User] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.User")
	v7[PromptType.Place] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Place")
	v7[PromptType.User] = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.User")
end

RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.Respect")
local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.FutureViolations")
local formatByKey2 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.EffectiveUntil")
local formatByKey3 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Understand")
local formatByKey4 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.GotIt")
local formatByKey5 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudge")
local formatByKey6 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2")
local v13

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v13 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Ok")
else
	v13 = nil
end

local v14

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v14 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporaryVoiceBan2V2")
else
	v14 = nil
end

local v15

if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
	v15 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.IncorrectNudgeV2")
else
	v15 = nil
end

local function formatBannedUntilDate(absoluteSeconds: number) -- 2 equivalent calls inferred from this helper
	return DateTime.fromUnixTimestamp(absoluteSeconds):FormatLocalTime("l LT", LocalizationService.RobloxLocaleId)
end

local function PromptTypeIsBan(p) -- 4 equivalent calls inferred from this helper
	return p == PromptType.VoiceChatSuspendedPermanent
		or p == PromptType.VoiceChatSuspendedTemporary
		or p == PromptType.VoiceChatSuspendedTemporaryAvatarChat
		or p == PromptType.VoiceChatSuspendedTemporaryB
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p == PromptType.VoiceChatSuspendedTemporaryBV2
end

local function IsModalNudge(p) -- 3 equivalent calls inferred from this helper
	return p == PromptType.VoiceToxicityModal
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p == PromptType.VoiceToxicityModalV2
end

local function IsVoiceConsentModal(p): boolean -- 4 equivalent calls inferred from this helper
	return p == PromptType.VoiceConsentModalV1
		or p == PromptType.VoiceConsentModalV2
		or p == PromptType.VoiceConsentModalV3
end

local function IsDevicePermissionsModal(p): boolean -- 4 equivalent calls inferred from this helper
	return p == PromptType.DevicePermissionsModal
end

local function PromptTypeIsModal(p)
	return PromptTypeIsBan(p) or IsModalNudge(p) or IsVoiceConsentModal(p) or IsDevicePermissionsModal(p) -- inferred equivalent call
end

local function PromptTypeIsVoiceConsent(p): boolean -- 1 equivalent call inferred from this helper
	return p == PromptType.VoiceConsentDeclinedToast or p == PromptType.VoiceConsentAcceptedToast
end

local function PromptTypeIsVoiceDataConsent(p): boolean -- 1 equivalent call inferred from this helper
	return p == PromptType.VoiceDataConsentOptOutToast
end

local function PromptTypeIsConnectDisconnectToast(p): boolean -- 2 equivalent calls inferred from this helper
	return p == PromptType.JoinVoice or p == PromptType.LeaveVoice or p == PromptType.UnifiedJoinVoiceToast
end

local function ShouldShowBannedUntil(p) -- 1 equivalent call inferred from this helper
	return p == PromptType.VoiceChatSuspendedTemporary
		or p == PromptType.VoiceChatSuspendedTemporaryAvatarChat
		or p == PromptType.VoiceChatSuspendedTemporaryToast
		or p == PromptType.VoiceChatSuspendedTemporaryB
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and p == PromptType.VoiceChatSuspendedTemporaryBV2
end

local function ShouldShowSecondaryButton(promptType) -- 1 equivalent call inferred from this helper
	return (promptType == PromptType.VoiceChatSuspendedTemporaryB or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceChatSuspendedTemporaryBV2 or promptType == PromptType.VoiceToxicityModal)
		and true
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and promptType == PromptType.VoiceToxicityModalV2
end

local function promptSignalCallback(object, promptType)
	if PromptTypeIsBan(promptType) then -- inferred equivalent call
		if object.props.Analytics then
			object.props.Analytics:reportBanMessageEvent("Shown")
		end

		if object.props.VoiceChatServiceManager then
			object.props.VoiceChatServiceManager:reportBanMessage("Shown")
		end
	end

	if IsVoiceConsentModal(promptType) and object.props.Analytics then -- inferred equivalent call
		local v16 = not engineFeature and "" or RbxAnalyticsService:GetPlaySessionId()

		object.props.Analytics:reportInExpConsent(
			"shown",
			object.props.VoiceChatServiceManager.inExpUpsellEntrypoint,
			game.GameId,
			game.PlaceId,
			v16
		)
	end

	if IsDevicePermissionsModal(promptType) and object.props.Analytics and object.props.VoiceChatServiceManager then -- inferred equivalent call
		object.props.Analytics:reportDevicePermissionsModalEvent(
			"Shown",
			object.props.VoiceChatServiceManager:GetSessionId(),
			object.props.VoiceChatServiceManager:GetInExpUpsellAnalyticsData()
		)
	end

	if promptType and promptType ~= PromptType.None then
		local toastTitle = v[promptType]
		local toastSubtitle = v7[promptType]

		if
			PromptTypeIsConnectDisconnectToast(promptType) -- inferred equivalent call
			and object.props.VoiceChatServiceManager
			and object.props.VoiceChatServiceManager:HasSeamlessVoiceFeature("HideJoinToastSubtitle")
		then
			toastSubtitle = nil
		end

		local v16 = object.props.bannedUntil

		if FFlagVoiceChatBanDurationUseServerTime then
			v16 = object.props.bannedUntil and formatBannedUntilDate(object.props.bannedUntil.absoluteSeconds) -- inferred equivalent call
		end

		if typeof(toastTitle) == "function" then
			toastTitle = toastTitle(v16)
		end

		if typeof(toastSubtitle) == "function" then
			toastSubtitle = toastSubtitle(v16)
		end

		local fn
		local iconImage

		if getFFlagMicConsumerRegistry() and promptType == PromptType.MicPermissionDenied then
			iconImage = Images["icons/status/alert"]
			fn = function()
				local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
				local default = LinkingProtocol.LinkingProtocol.default
				local settingsRoute = LinkingProtocol.Enums.SettingsRoute
				local microphone

				if settingsRoute then
					microphone = settingsRoute.Microphone
				end

				local v17, v18 = default:supportsSwitchToSettingsApp(microphone):await()

				if v17 and v18 then
					default:switchToSettingsApp(microphone):catch(function() end)
				end
			end
		elseif getFFlagMicConsumerRegistry() and promptType == PromptType.MicFirstUnmutePrivacy then
			iconImage = Images["icons/controls/microphone"]
			fn = function()
				local LinkingProtocol = require(CorePackages.Workspace.Packages.LinkingProtocol)
				LinkingProtocol.LinkingProtocol.default:openURL("https://en.help.roblox.com/hc/articles/115004630823"):catch(function() end)
			end
		elseif promptType == PromptType.UpdateOnAutoJoinToast then
			iconImage = Images["icons/controls/microphone"]
		elseif
			PromptTypeIsVoiceConsent(promptType) -- inferred equivalent call
			or promptType == PromptType.JoinedVoiceToast
			or promptType == PromptType.UnifiedJoinVoiceToast
		then
			iconImage = Images["icons/controls/publicAudioJoin"]
		elseif PromptTypeIsConnectDisconnectToast(promptType) then -- inferred equivalent call
			iconImage = Images["icons/actions/info"]
		elseif not (PromptTypeIsVoiceDataConsent(promptType) and GetFFlagEnableSeamlessVoiceDataConsentToast()) then -- inferred equivalent call
			iconImage = Images["icons/status/alert"]
		end

		object:setState({
			showPrompt = true,
			promptType = promptType,
			toastContent = {
				iconImage = iconImage,
				toastTitle = toastTitle,
				toastSubtitle = toastSubtitle,
				onActivated = fn or function()
					if object.props.onPrimaryActivated then
						object.props.onPrimaryActivated()
					end
				end,
				onDismissed = function() end
			}
		})

		if ShouldShowBannedUntil(promptType) then -- inferred equivalent call
			local banEnd

			if FFlagVoiceChatBanDurationUseServerTime then
				local v17 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
					and promptType == PromptType.VoiceChatSuspendedTemporaryBV2

				local v18 = promptType == PromptType.VoiceChatSuspendedTemporaryB or v17
				local minutes = object.props.bannedUntil.minutes

				if v18 then
					if minutes >= 1 then
						v18 = minutes <= 60
					else
						v18 = false
					end
				end

				if v18 and v17 then
					banEnd = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspensionV2", {
						banDurationInMinutes = minutes
					})
				elseif v18 then
					banEnd = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspension", {
						banDurationInMinutes = minutes
					})
				else
					banEnd = formatByKey2 .. " " .. formatBannedUntilDate(object.props.bannedUntil.absoluteSeconds) .. "." -- inferred equivalent call
				end
			else
				local formatByKey7 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspension", {
					banDurationInMinutes = object.props.bannedUntil
				})

				if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() then
					banEnd = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.XMinuteSuspensionV2", {
						banDurationInMinutes = object.props.bannedUntil
					})
				end

				if promptType == PromptType.VoiceChatSuspendedTemporaryB then
					banEnd = formatByKey7
				elseif
					not GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
					or promptType ~= PromptType.VoiceChatSuspendedTemporaryBV2
				then
					banEnd = " " .. object.props.bannedUntil .. "."
				end
			end

			object:setState({ banEnd = banEnd })
		end
	else
		object:setState({ promptType = PromptType.None, toastContent = Roact.None })
	end
end

local extended = Roact.PureComponent:extend("VoiceChatPromptFrame")
local strictInterface = t.strictInterface
local v16 = {
	promptSignal = t.optional(t.RBXScriptSignal),
	errorText = t.optional(t.string),
	bannedUntil = 0,
	onContinueFunc = 0,
	onPrimaryActivated = 0,
	onSecondaryActivated = 0,
	onReadyForSignal = 0,
	Analytics = 0,
	VoiceChatServiceManager = 0,
	showNewContent = 0,
	showCheckbox = 0,
	showDataConsentToast = 0,
	policyMapper = 0,
	appStyle = 0,
	settingsAppAvailable = 0,
	UserInputService = 0,
	lastInput = 0
}
local optional = t.optional
local v17

if FFlagVoiceChatBanDurationUseServerTime then
	v17 = t.interface({ minutes = t.number, absoluteSeconds = t.number })
else
	v17 = t.string
end

v16.bannedUntil = optional(v17)

v16.onContinueFunc = t.optional(t.callback)
v16.onPrimaryActivated = t.optional(t.callback)
v16.onSecondaryActivated = t.optional(t.callback)
v16.onReadyForSignal = t.optional(t.callback)
v16.Analytics = t.optional(t.table)
v16.VoiceChatServiceManager = t.optional(t.table)
v16.showNewContent = t.optional(t.boolean)
v16.showCheckbox = t.optional(t.boolean)
v16.showDataConsentToast = t.optional(t.boolean)
v16.policyMapper = t.optional(t.callback)
v16.appStyle = validateStyle
v16.settingsAppAvailable = t.optional(t.boolean)
v16.UserInputService = t.optional(t.table)
v16.lastInput = t.optional(t.string)
extended.validateProps = strictInterface(v16)

function extended:init()
	self.promptStyle = { Theme = self.props.appStyle.Theme, Font = self.props.appStyle.Font }

	self.state = {
		screenSize = Vector2.new(0, 0),
		promptType = PromptType.None,
		toastContent = nil,
		banEnd = "",
		showPrompt = true
	}
	local ref

	if GetFFlagSupportGamepadNavInVoiceModals() then
		ref = Roact.createRef()
	end

	self.ref = ref

	if self.props.showNewContent then
		local formatByKey7 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.MicUseSuspended")
		local formatByKey8 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Prompt.Subtitle.TemporarySuspension2")
		v[PromptType.VoiceChatSuspendedTemporary] = formatByKey7
		v[PromptType.VoiceChatSuspendedPermanent] = formatByKey7
		v7[PromptType.VoiceChatSuspendedTemporary] = formatByKey8
	end

	function self.onScreenSizeChanged(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
		end
	end

	function self.promptSignalCallback(promptType)
		promptSignalCallback(self, promptType)
	end

	function self.closeVoiceBanPrompt()
		self:setState({ showPrompt = false })

		if self.props.onContinueFunc then
			self.props.onContinueFunc()
		end

		ContextActionService:UnbindCoreAction("CloseVoiceBanPrompt")
		local v18 = self.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
		local v19 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
			and VoiceNudgeUseNewDACopy()
			and self.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2

		if defineFastFlag then
			if PromptTypeIsBan(self.state.promptType) and not (v18 or v19) then -- inferred equivalent call
				if self.props.Analytics then
					self.props.Analytics:reportBanMessageEvent("Acknowledged")
				end

				if self.props.VoiceChatServiceManager then
					self.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")
				end
			end
		elseif not (v18 or v19) then
			if self.props.Analytics then
				self.props.Analytics:reportBanMessageEvent("Acknowledged")
			end

			if self.props.VoiceChatServiceManager then
				self.props.VoiceChatServiceManager:reportBanMessage("Acknowledged")
			end
		end
	end

	function self.checkInputStateForClosePrompt(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.closeVoiceBanPrompt()
		end
	end

	function self.handlePrimayActivated()
		self.closeVoiceBanPrompt()

		if self.props.onPrimaryActivated then
			self.props.onPrimaryActivated()
		end
	end

	function self.handleSecondaryActivated()
		self.closeVoiceBanPrompt()

		if self.props.onSecondaryActivated then
			self.props.onSecondaryActivated()
		end
	end
end

function extended.render(props)
	local errorText

	if GetFFlagEnableVoicePromptReasonText() then
		errorText = props.props.errorText or nil
	end

	local modalNudge = IsModalNudge(props.state.promptType) -- inferred equivalent call
	local v18 = props.state.promptType == PromptType.VoiceToxicityToast
		or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
		and props.state.promptType == PromptType.VoiceToxicityToastV2

	local v19 = props.state.promptType == PromptType.VoiceChatSuspendedTemporaryB
	local v20 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
		and VoiceNudgeUseNewDACopy()
		and props.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2
	local v21 = GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
		and VoiceNudgeUseNewDACopy()
		and (props.state.promptType == PromptType.VoiceToxicityModalV2 or props.state.promptType == PromptType.VoiceChatSuspendedTemporaryBV2)

	local voiceConsentModal = IsVoiceConsentModal(props.state.promptType) -- inferred equivalent call
	local v22 = GetFFlagShowDevicePermissionsModal() and IsDevicePermissionsModal(props.state.promptType) -- inferred equivalent call
	local y = Enum.AutomaticSize.Y

	local promptType = props.state.promptType

	if
		PromptTypeIsBan(promptType) -- inferred equivalent call
		or IsModalNudge(promptType) -- inferred equivalent call
		or IsVoiceConsentModal(promptType) -- inferred equivalent call
		or IsDevicePermissionsModal(promptType) -- inferred equivalent call
	then
		local toastTitle = props.state.toastContent.toastTitle
		local font = props.promptStyle.Font.Header1.Font
		local v23 = props.promptStyle.Font.Header1.RelativeSize * props.promptStyle.Font.BaseSize
		local v24

		if FoundationFontFaceMigration then
			v24 = GetTextSize(toastTitle, v23, font, Vector2.new(325, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			v24 = TextService:GetTextSize(toastTitle, v23, font, Vector2.new(325, 1e999)).Y
		end

		local v25 = 20 + v24
		local v26

		if
			FFlagVoiceChatBanDurationUseServerTime
			or v19
			or GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and v20
		then
			v26 = props.state.banEnd
		else
			v26 = formatByKey2 .. props.state.banEnd
		end

		local v27

		if props.state.banEnd == "" then
			v27 = props.state.toastContent.toastSubtitle .. props.state.banEnd
		else
			v27 = "<b>" .. v26 .. "</b><br />" .. props.state.toastContent.toastSubtitle
		end

		local text = errorText or v27
		local font2 = props.promptStyle.Font.Body.Font
		local v28 = props.promptStyle.Font.Body.RelativeSize * props.promptStyle.Font.BaseSize
		local v29

		if FoundationFontFaceMigration then
			v29 = GetTextSize(text, v28, font2, Vector2.new(325, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			v29 = TextService:GetTextSize(text, v28, font2, Vector2.new(325, 1e999)).Y
		end

		local v30 = 20 + v29

		if v19 or v20 then
			v30 += 20
		end

		local text2

		if v19 then
			text2 = formatByKey6
		elseif GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and v20 then
			text2 = v14
		else
			text2 = formatByKey
		end

		local v31

		if FoundationFontFaceMigration then
			v31 = GetTextSize(text2, v28, font2, Vector2.new(325, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			v31 = TextService:GetTextSize(text2, v28, font2, Vector2.new(325, 1e999)).Y
		end

		local v32 = 20 + v31

		local secondaryButton = ShouldShowSecondaryButton(props.state.promptType) -- inferred equivalent call
		local stop

		if GetFFlagSupportGamepadNavInVoiceModals() then
			stop = Enum.SelectionBehavior.Stop
		end

		local v38 = GetFFlagSupportGamepadNavInVoiceModals() and true or nil
		local confirmButton

		if defineFastFlag2 then
			local createElement = Roact.createElement
			local v41 = {}
			v41.Size = UDim2.new(1, -5, 0, 48)
			v41.LayoutOrder = 1
			local text3

			if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() and v20 then
				text3 = v13
			elseif
				GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
				and modalNudge
				and VoiceNudgeUseNewDACopy()
				and props.state.promptType == PromptType.VoiceToxicityModalV2
			then
				text3 = v13
			elseif modalNudge then
				text3 = formatByKey4
			else
				text3 = formatByKey3
			end

			v41.Text = text3

			v41[Roact.Event.Activated] = props.handlePrimayActivated
			v41[Roact.Event.MouseEnter] = function(p)
				p.BackgroundColor3 = color2
			end
			v41[Roact.Event.MouseLeave] = function(p)
				p.BackgroundColor3 = color
			end
			v41.Selectable = v38
			v41.BackgroundColor3 = color
			v41.BackgroundTransparency = 0
			v41.TextColor3 = Color3.fromRGB(0, 0, 0)
			v41.BorderSizePixel = 0
			v41.AutoButtonColor = false

			v41.Font = Enum.Font.BuilderSansBold
			v41.TextSize = 20
			confirmButton = createElement("TextButton", v41, {
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) })
			})
		else
			local createElement = Roact.createElement
			local v40 = {
				buttonType = ButtonType.PrimarySystem,
				layoutOrder = 1,
				size = UDim2.new(1, -5, 0, 48),
				text = 0,
				onActivated = 0,
				Selectable = 0
			}
			local text3

			if GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2() and VoiceNudgeUseNewDACopy() and v20 then
				text3 = v13
			elseif
				GetFFlagVoiceChatDisruptiveVoiceNudgeEnableVariant2()
				and modalNudge
				and VoiceNudgeUseNewDACopy()
				and props.state.promptType == PromptType.VoiceToxicityModalV2
			then
				text3 = v13
			elseif modalNudge then
				text3 = formatByKey4
			else
				text3 = formatByKey3
			end

			v40.text = text3

			v40.onActivated = props.handlePrimayActivated
			v40.Selectable = v38
			confirmButton = createElement(Button, v40)
		end

		local createElement = Roact.createElement
		local v41 = {
			DisplayOrder = 8,
			IgnoreGuiInset = true,
			OnTopOfCoreBlur = true,
			Enabled = props.state.showPrompt,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}
		local v42 = {
			Overlay = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				BackgroundColor3 = props.promptStyle.Theme.Overlay.Color,
				BackgroundTransparency = props.promptStyle.Theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Text = ""
			}),
			DialogMainFrame = 0
		}

		local createElement2 = Roact.createElement
		local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
		local v43 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = Assets.Images.RoundedRect.Image,
			ImageColor3 = props.promptStyle.Theme.BackgroundUIDefault.Color,
			ImageTransparency = props.promptStyle.Theme.BackgroundUIDefault.Transparency,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			ScaleType = Assets.Images.RoundedRect.ScaleType,
			Size = UDim2.new(0, 365, 0, 55 + v25 + 1 + v30 + 14 + v32 + 36 + 40),
			AutomaticSize = y,
			SliceCenter = Assets.Images.RoundedRect.SliceCenter,
			SelectionBehaviorDown = stop,
			SelectionBehaviorLeft = stop,
			SelectionBehaviorRight = stop,
			SelectionBehaviorUp = stop,
			SelectionGroup = v38,
			ref = 0
		}
		local ref

		if GetFFlagSupportGamepadNavInVoiceModals() then
			ref = props.ref
		end

		v43.ref = ref
		local v45 = {
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
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = props.state.toastContent.iconImage,
				Size = UDim2.new(0, 55, 0, 55),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}),
			TitleTextContainer = Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v25),
					AutomaticSize = y
				},
				{
					TitleText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = props.promptStyle.Font.Header1,
						colorStyle = props.promptStyle.Theme.SystemPrimaryDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = toastTitle
					})
				}
			),
			Divider = Roact.createElement("Frame", {
				BackgroundColor3 = props.promptStyle.Theme.Divider.Color,
				BackgroundTransparency = props.promptStyle.Theme.Divider.Transparency,
				BorderSizePixel = 0,
				LayoutOrder = 3,
				Size = UDim2.new(0.8, 0, 0, 1)
			}),
			DividerSpaceContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 7)
			}),
			BodyTextContainer = Roact.createElement(
				"Frame",
				{ BackgroundTransparency = 1, LayoutOrder = 5, Size = UDim2.new(1, 0, 0, v30) },
				{
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = props.promptStyle.Font.Body,
						colorStyle = props.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = text
					})
				}
			),
			TextSpaceContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, 7)
			}),
			SubBodyTextContainer = not modalNudge and Roact.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					LayoutOrder = 7,
					Size = UDim2.new(1, 0, 0, v32),
					AutomaticSize = y
				},
				{
					BodyText = Roact.createElement(UIBlox.App.Text.StyledTextLabel, {
						fontStyle = props.promptStyle.Font.Body,
						colorStyle = props.promptStyle.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Center,
						size = UDim2.new(1, 0, 1, 0),
						text = text2
					})
				}
			),
			SpaceContainer2 = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 8,
				Size = UDim2.new(1, 0, 0, 10)
			}),
			ButtonContainer = 0
		}

		local createElement3 = Roact.createElement
		local v47 = {
			BackgroundTransparency = 1,
			LayoutOrder = 9,
			Size = UDim2.new(1, 0, 0, 36),
			AutomaticSize = y
		}

		local v48 = {
			Layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 20),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			ConfirmButton = confirmButton,
			SecondaryButton = 0
		}

		if secondaryButton then
			local createElement4 = Roact.createElement
			local linkButton = UIBlox.App.Button.LinkButton
			local v49 = {
				layoutOrder = defineFastFlag2 and 2 or 1,
				size = UDim2.new(1, -5, 0, 36),
				text = 0,
				colorStyleDefault = "TextMuted",
				colorStyleHover = "TextMuted",
				onActivated = 0
			}
			local text3 = if v21 then v15 else formatByKey5
			v49.text = text3

			v49.onActivated = props.handleSecondaryActivated
			secondaryButton = createElement4(linkButton, v49)
		end

		v48.SecondaryButton = secondaryButton
		v45.ButtonContainer = createElement3("Frame", v47, v48)
		v42.DialogMainFrame = createElement2(imageSetLabel, v43, v45)
		local inGameMenuInformationalDialog = createElement("ScreenGui", v41, v42)

		if v22 then
			local createElement4 = Roact.createElement
			local v50 = {
				titleText = v[props.state.promptType],
				bodyText = v7[props.state.promptType],
				handlePrimaryActivated = props.handlePrimayActivated,
				handleSecondaryActivated = props.handleSecondaryActivated,
				Analytics = props.props.Analytics,
				promptStyle = props.promptStyle,
				showPrompt = props.state.showPrompt,
				settingsAppAvailable = props.props.settingsAppAvailable,
				UserInputService = 0,
				ref = 0
			}
			local userInputService

			if props.props.UserInputService == nil then
				userInputService = UserInputService
			else
				userInputService = props.props.UserInputService
			end

			v50.UserInputService = userInputService
			local ref2

			if GetFFlagSupportGamepadNavInVoiceModals() then
				ref2 = props.ref
			end

			v50.ref = ref2
			inGameMenuInformationalDialog = createElement4(DevicePermissionsModal, v50)
		end

		if voiceConsentModal then
			local createElement4 = Roact.createElement
			local v50 = {
				titleText = v[props.state.promptType],
				bodyText = v7[props.state.promptType],
				handlePrimaryActivated = props.handlePrimayActivated,
				handleSecondaryActivated = props.handleSecondaryActivated,
				Analytics = props.props.Analytics,
				showCheckbox = props.props.showCheckbox,
				promptStyle = props.promptStyle,
				showPrompt = props.state.showPrompt,
				ref = 0
			}
			local ref2

			if GetFFlagSupportGamepadNavInVoiceModals() then
				ref2 = props.ref
			end

			v50.ref = ref2
			inGameMenuInformationalDialog = createElement4(VoiceChatConsentModal, v50)
		end

		return (Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameMenuInformationalDialog = inGameMenuInformationalDialog
		}))
	else
		if props.state.promptType == PromptType.JoinVoiceSTUX then
			return (Roact.createElement(VoiceChatTooltip, {
				titleText = v[props.state.promptType],
				subtitleText = v7[props.state.promptType],
				promptStyle = props.promptStyle,
				showPrompt = props.state.showPrompt,
				onClose = function()
					props:setState({ showPrompt = false })
				end,
				onMenuOpen = props.hideOnMenuOpen
			}))
		end

		local duration

		if v18 then
			duration = GetFIntVoiceToxicityToastDurationSeconds()
		else
			duration = props.state.promptType ~= PromptType.JoinedVoiceToast and 3
				or GetFIntVoiceJoinM3ToastDurationSeconds()
		end

		local show = props.state.showPrompt

		if
			props.state.promptType == PromptType.VoiceDataConsentOptOutToast
			and GetFFlagEnableSeamlessVoiceDataConsentToast()
		then
			if props.props.showDataConsentToast then
				show = props.props.showDataConsentToast
			else
				show = false
			end
		end

		local createElement = Roact.createElement
		local onScreenSizeChangedsByAbsoluteSize = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[Roact.Change.AbsoluteSize] = props.onScreenSizeChanged
		}
		local toast

		if props.state.promptType == PromptType.None then
			toast = false
		else
			local createElement2 = Roact.createElement

			if v18 then
				duration = GetFIntVoiceToxicityToastDurationSeconds()
			end

			toast = createElement2(Toast, {
				duration = duration,
				toastContent = props.state.toastContent,
				show = show
			})
		end

		return (createElement("Frame", onScreenSizeChangedsByAbsoluteSize, {
			Toast = toast,
			EventConnection = props.props.promptSignal and Roact.createElement(ExternalEventConnection, {
				event = props.props.promptSignal,
				callback = props.promptSignalCallback
			})
		}))
	end
end

function extended.didUpdate(data)
	if GetFFlagSupportGamepadNavInVoiceModals() then
		if data.props.lastInput == Responsive.Input.Directional then
			local value = data.ref:getValue()

			if data.state.showPrompt and value then
				GuiService:Select(value)
			end

			if not data.state.showPrompt and value then
				GuiService.SelectedCoreObject = nil
			end
		elseif GuiService.SelectedCoreObject then
			GuiService.SelectedCoreObject = nil
		end
	end
end

function extended.didMount(p)
	if p.props.onReadyForSignal then
		p.props.onReadyForSignal()
	end

	ContextActionService:BindCoreAction(
		"CloseVoiceBanPrompt",
		p.checkInputStateForClosePrompt,
		false,
		Enum.KeyCode.ButtonA
	)

	ContextActionService:BindCoreAction(
		"CloseVoiceBanPrompt",
		p.checkInputStateForClosePrompt,
		false,
		Enum.KeyCode.ButtonB
	)
end

local v18 = InGameMenuPolicy.connect(function(p, _)
	return {
		showNewContent = p.getGameInfoShowChatFeatures(),
		showCheckbox = p.getDisplayCheckboxInVoiceConsent(),
		showDataConsentToast = p.getDisplayCheckboxInVoiceConsent() ~= nil and p.getDisplayCheckboxInVoiceConsent()
	}
end)(extended)

local function WrappedVoiceChatPromptFrame(p)
	local appStyle = useStyle()
	local lastInput

	if GetFFlagSupportGamepadNavInVoiceModals() then
		lastInput = useLastInput()
	end

	local createElement = Roact.createElement

	local join = Cryo.Dictionary.join

	if not GetFFlagSupportGamepadNavInVoiceModals() then
		lastInput = nil
	end

	return createElement(v18, join(p, { appStyle = appStyle, lastInput = lastInput }))
end

return function(p)
	return renderWithCoreScriptsStyleProvider({ Roact.createElement(WrappedVoiceChatPromptFrame, p) })
end
