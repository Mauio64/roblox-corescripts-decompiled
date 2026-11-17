local CoreGui = game:GetService("CoreGui")
local modules = CoreGui:WaitForChild("RobloxGui").Modules
local CorePackages = game:GetService("CorePackages")

local GetFFlagEnablePlayerNamesEnabledSetting = require(modules.Settings.Flags.GetFFlagEnablePlayerNamesEnabledSetting)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local engineFeature = game:GetEngineFeature("RUUserScalePreferenceAPI")
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUIScaleEngineOptions = SharedFlags2.FFlagUIScaleEngineOptions
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAIRephraseSettingEnabled = SharedFlags3.FFlagAIRephraseSettingEnabled
local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChatSummariesSettingEnabled = SharedFlags4.FFlagChatSummariesSettingEnabled

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatDictationVoiceTypingModeSetting = SharedFlags5.FFlagExpChatDictationVoiceTypingModeSetting

local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local FFlagFriendsCallingCallVolumeSlider = require(modules.Settings.Flags.FFlagFriendsCallingCallVolumeSlider)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local nextOrder = ReactUtils.createNextOrder()

local v = {}
v.MoreSettingsBanner = nextOrder()

v.AudioHeader = nextOrder()
v.VolumeFrame = nextOrder()
local voiceChatVolumeFrame

if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
	voiceChatVolumeFrame = nextOrder()
end

v.VoiceChatVolumeFrame = voiceChatVolumeFrame
v.PartyVoiceVolumeFrame = nextOrder()
local callVolumeFrame

if FFlagFriendsCallingCallVolumeSlider then
	callVolumeFrame = nextOrder()
end

v.CallVolumeFrame = callVolumeFrame
v.DeviceFrameInput = nextOrder()
v.DeviceFrameOutput = nextOrder()
v.AudioDivider = nextOrder()

v.LanguageHeader = nextOrder()
local voiceTypingModeFrame

if FFlagExpChatDictationVoiceTypingModeSetting then
	voiceTypingModeFrame = nextOrder()
end

v.VoiceTypingModeFrame = voiceTypingModeFrame
v.ChatModerationFrame = nextOrder()
v.VoiceConnectDisconnectSelector = nextOrder()
v.VoiceConnectFrame = nextOrder()
v.VoiceDisconnectFrame = nextOrder()
local chatSummariesFrame

if FFlagChatSummariesSettingEnabled then
	chatSummariesFrame = nextOrder()
end

v.ChatSummariesFrame = chatSummariesFrame
local aiRephraseFrame

if FFlagAIRephraseSettingEnabled then
	aiRephraseFrame = nextOrder()
end

v.AIRephraseFrame = aiRephraseFrame
local playerChoiceTranslationFrame

if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
	playerChoiceTranslationFrame = nextOrder()
end

v.PlayerChoiceTranslationFrame = playerChoiceTranslationFrame
v.LanguageSelectorFrame = nextOrder()
v.FeedbackModeButton = nextOrder()
v.ChatTranslationFrame = nextOrder()
v.ChatLanguageSelectorFrame = nextOrder()
v.ChatTranslationToggleFrame = nextOrder()
v.ChatNotificationsFrame = nextOrder()
v.LanguageDivider = nextOrder()

v.DisplayHeader = nextOrder()
v.OverscanAdjustButton = nextOrder()
v.FullScreenFrame = nextOrder()
local uiScaleEngineModeFrame

if FFlagUIScaleEngineOptions then
	uiScaleEngineModeFrame = nextOrder()
end

v.UIScaleEngineModeFrame = uiScaleEngineModeFrame
local uiScaleEngineFrame

if FFlagUIScaleEngineOptions then
	uiScaleEngineFrame = nextOrder()
end

v.UIScaleEngineFrame = uiScaleEngineFrame
v.PreferredTransparencyFrame = nextOrder()
v.PreferredTextSizeFrame = nextOrder()
local uiScaleModeFrame

if engineFeature then
	uiScaleModeFrame = nextOrder()
end

v.UIScaleModeFrame = uiScaleModeFrame
local uiScaleFrame

if engineFeature then
	uiScaleFrame = nextOrder()
end

v.UIScaleFrame = uiScaleFrame
local vrComfortSettingFrame

if isInExperienceUIVREnabled then
	vrComfortSettingFrame = nextOrder()
end

v.VRComfortSettingFrame = vrComfortSettingFrame
local vrVignetteEnabledFrame

if isInExperienceUIVREnabled then
	vrVignetteEnabledFrame = nextOrder()
end

v.VRVignetteEnabledFrame = vrVignetteEnabledFrame
local vrSteppedRotationEnabledFrame

if isInExperienceUIVREnabled then
	vrSteppedRotationEnabledFrame = nextOrder()
end

v.VRSteppedRotationEnabledFrame = vrSteppedRotationEnabledFrame
local vrThirdPersonFixedCamEnabledFrame

if isInExperienceUIVREnabled then
	vrThirdPersonFixedCamEnabledFrame = nextOrder()
end

v.VRThirdPersonFixedCamEnabledFrame = vrThirdPersonFixedCamEnabledFrame
local vrSafetyBubbleModeFrame

if isInExperienceUIVREnabled then
	vrSafetyBubbleModeFrame = nextOrder()
end

v.VRSafetyBubbleModeFrame = vrSafetyBubbleModeFrame
v.PerformanceStatsFrame = nextOrder()
v.MicroProfilerFrame = nextOrder()
v.GraphicsEnablerFrame = nextOrder()
v.GraphicsQualityFrame = nextOrder()
v.HapticsFrame = nextOrder()
v.ReducedMotionFrame = nextOrder()
v.FramerateCap = nextOrder()
v.VREnabledFrame = nextOrder()
v.DisplayDivider = nextOrder()

v.ViewAndControlsHeader = nextOrder()
v.CameraModeFrame = nextOrder()
v.CameraInvertedFrame = nextOrder()
v.CameraSensitivityFrame = nextOrder()
v.MouseAdvancedFrame = nextOrder()
v.GamepadSensitivityFrame = nextOrder()
v.MovementModeFrame = nextOrder()
v.ShiftLockFrame = nextOrder()
v.CameraDeviceFrame = nextOrder()
v.UiNavigationKeyBindEnabledFrame = nextOrder()
v.DeveloperConsoleButton = nextOrder()
local playerNamesEnabledFrame

if GetFFlagEnablePlayerNamesEnabledSetting() then
	playerNamesEnabledFrame = nextOrder()
end

v.PlayerNamesEnabledFrame = playerNamesEnabledFrame
local badgeVisibilityFrame

if FFlagBadgeVisibilitySettingEnabled then
	badgeVisibilityFrame = nextOrder()
end

v.BadgeVisibilityFrame = badgeVisibilityFrame

v.UiToggleRow = nextOrder()
v.UiToggleRowCustom = nextOrder()
v.UiToggleRowBillboards = nextOrder()
v.UiToggleRowNameplates = nextOrder()
v.FreecamToggleRow = nextOrder()
v.InformationFrame = nextOrder()

if FFlagUIScaleEngineOptions then
	local preferredTransparencyFrame = v.PreferredTransparencyFrame
	local preferredTextSizeFrame = v.PreferredTextSizeFrame
	v.PreferredTextSizeFrame = preferredTransparencyFrame
	v.PreferredTransparencyFrame = preferredTextSizeFrame
end

return { SETTINGS_MENU_LAYOUT_ORDER = v }
