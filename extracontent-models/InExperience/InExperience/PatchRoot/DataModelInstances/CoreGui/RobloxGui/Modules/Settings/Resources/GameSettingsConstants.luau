local Modules = game:GetService("CoreGui"):WaitForChild("RobloxGui").Modules
local CorePackages = game:GetService("CorePackages")
local EngineFeature = game:GetEngineFeature("PartyVoiceVolume")
local GetFFlagEnablePlayerNamesEnabledSetting = require(Modules.Settings.Flags.GetFFlagEnablePlayerNamesEnabledSetting)
local FFlagBadgeVisibilitySettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBadgeVisibilitySettingEnabled
local FFlagEnableModerateChatRemoteEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableModerateChatRemoteEvent
local FFlagIEMSettingsGroups = require(Modules.Settings.Flags.FFlagIEMSettingsGroups)
local FFlagAIRephraseSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAIRephraseSettingEnabled
local v9 = game:DefineFastFlag("UpdateRephraseSettingUI", false)
local FFlagChatSummariesSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChatSummariesSettingEnabled
local FFlagExpChatEnableFriendsTab = require(CorePackages.Workspace.Packages.SharedFlags).FFlagExpChatEnableFriendsTab
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local v15 = game:DefineFastInt("ChatModerationFrameLayoutOrder", 9)
local t1 = {
	OverscanAdjustButton = 1
}

if FFlagEnableModerateChatRemoteEvent then
	t1.ChatModerationFrame = v15
end

t1.ShiftLockFrame = 10
t1.CameraModeFrame = 11
t1.MovementModeFrame = 12
t1.FramerateCap = 13
t1.GamepadSensitivityFrame = 14
t1.CameraInvertedFrame = 90
t1.CameraDeviceFrame = 91
t1.MouseAdvancedFrame = 50
t1.VoiceConnectDisconnectSelector = 17
t1.VoiceConnectFrame = 18
t1.VoiceDisconnectFrame = 19

if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
	t1.PlayerChoiceTranslationFrame = 20
	t1.LanguageSelectorFrame = 21
	t1.ChatTranslationFrame = 30
	t1.ChatLanguageSelectorFrame = 31
	t1.ChatTranslationToggleFrame = 32
	t1.FeedbackModeButton = 40
else
	t1.LanguageSelectorFrame = 20
	t1.FeedbackModeButton = 30
	t1.ChatTranslationFrame = 40
	t1.ChatLanguageSelectorFrame = 41
	t1.ChatTranslationToggleFrame = 42
end

if FFlagExpChatEnableFriendsTab then
	t1.ChatNotificationsFrame = 44
end

if isInExperienceUIVREnabled then
	t1.VRComfortSettingFrame = 54
	t1.VRVignetteEnabledFrame = 55
	t1.VRSteppedRotationEnabledFrame = 56
	t1.VRThirdPersonFixedCamEnabledFrame = 57
	t1.VRSafetyBubbleModeFrame = 58
end

t1.DeviceFrameInput = 60
t1.DeviceFrameOutput = 61
t1.VolumeFrame = 62

if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
	t1.VoiceChatVolumeFrame = 63

	if EngineFeature then
		t1.PartyVoiceVolumeFrame = 64
	end

	t1.HapticsFrame = not EngineFeature and 64 or 65
else
	if EngineFeature then
		t1.PartyVoiceVolumeFrame = 63
	end

	t1.HapticsFrame = not EngineFeature and 63 or 64
end

t1.FullScreenFrame = 70
t1.GraphicsEnablerFrame = 71
t1.GraphicsQualityFrame = 72
t1.ReducedMotionFrame = 73
t1.PreferredTransparencyFrame = 74
t1.PreferredTextSizeFrame = 75
t1.UiNavigationKeyBindEnabledFrame = 76
t1.PerformanceStatsFrame = 80
t1.MicroProfilerFrame = 81
t1.VREnabledFrame = 100
t1.DeveloperConsoleButton = 101

if GetFFlagEnablePlayerNamesEnabledSetting() then
	t1.PlayerNamesEnabledFrame = 105
end

if FFlagBadgeVisibilitySettingEnabled then
	t1.BadgeVisibilityFrame = 106
end

if FFlagAIRephraseSettingEnabled then
	t1.AIRephraseFrame = not v9 and 43 or 20
end

if FFlagChatSummariesSettingEnabled then
	t1.ChatSummariesFrame = 20
end

t1.UiToggleRow = 200
t1.UiToggleRowCustom = 200
t1.UiToggleRowBillboards = 201
t1.UiToggleRowNameplates = 202
t1.FreecamToggleRow = 203
t1.InformationFrame = 999

local t2 = nil

if FFlagIEMSettingsGroups then
	local v18 = ReactUtils.createNextOrder()

	t2 = {
		AudioHeader = v18(),
		VolumeFrame = v18(),
		VoiceChatVolumeFrame = if not FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then nil else v18(),
		PartyVoiceVolumeFrame = v18(),
		DeviceFrameInput = v18(),
		DeviceFrameOutput = v18(),
		AudioDivider = v18(),
		LanguageHeader = v18(),
		ChatModerationFrame = v18(),
		VoiceConnectDisconnectSelector = v18(),
		VoiceConnectFrame = v18(),
		VoiceDisconnectFrame = v18(),
		ChatSummariesFrame = if not FFlagChatSummariesSettingEnabled then nil else v18(),
		AIRephraseFrame = if not FFlagAIRephraseSettingEnabled then nil else v18(),
		PlayerChoiceTranslationFrame = if not game:GetEngineFeature("InExperiencePlayerChoiceToggle") then nil else v18(),
		LanguageSelectorFrame = v18(),
		FeedbackModeButton = v18(),
		ChatTranslationFrame = v18(),
		ChatLanguageSelectorFrame = v18(),
		ChatTranslationToggleFrame = v18(),
		ChatNotificationsFrame = if not FFlagExpChatEnableFriendsTab then nil else v18(),
		LanguageDivider = v18(),
		DisplayHeader = v18(),
		OverscanAdjustButton = v18(),
		FullScreenFrame = v18(),
		PreferredTransparencyFrame = v18(),
		PreferredTextSizeFrame = v18(),
		VRComfortSettingFrame = if not isInExperienceUIVREnabled then nil else v18(),
		VRVignetteEnabledFrame = if not isInExperienceUIVREnabled then nil else v18(),
		VRSteppedRotationEnabledFrame = if not isInExperienceUIVREnabled then nil else v18(),
		VRThirdPersonFixedCamEnabledFrame = if not isInExperienceUIVREnabled then nil else v18(),
		VRSafetyBubbleModeFrame = if not isInExperienceUIVREnabled then nil else v18(),
		PerformanceStatsFrame = v18(),
		MicroProfilerFrame = v18(),
		GraphicsEnablerFrame = v18(),
		GraphicsQualityFrame = v18(),
		HapticsFrame = v18(),
		ReducedMotionFrame = v18(),
		FramerateCap = v18(),
		VREnabledFrame = v18(),
		DisplayDivider = v18(),
		ViewAndControlsHeader = v18(),
		CameraModeFrame = v18(),
		CameraInvertedFrame = v18(),
		CameraSensitivityFrame = v18(),
		MouseAdvancedFrame = v18(),
		GamepadSensitivityFrame = v18(),
		MovementModeFrame = v18(),
		ShiftLockFrame = v18(),
		CameraDeviceFrame = v18(),
		UiNavigationKeyBindEnabledFrame = v18(),
		DeveloperConsoleButton = v18(),
		PlayerNamesEnabledFrame = if not GetFFlagEnablePlayerNamesEnabledSetting() then nil else v18(),
		BadgeVisibilityFrame = if not FFlagBadgeVisibilitySettingEnabled then nil else v18(),
		UiToggleRow = v18(),
		UiToggleRowCustom = v18(),
		UiToggleRowBillboards = v18(),
		UiToggleRowNameplates = v18(),
		FreecamToggleRow = v18(),
		InformationFrame = v18()
	}
end

local function getLayoutOrder() -- line: 211
	-- upvalues: FFlagIEMSettingsGroups (copy), t2 (ref), t1 (copy)
	if FFlagIEMSettingsGroups then
		return t2
	end

	return t1
end

return {
	SETTINGS_MENU_LAYOUT_ORDER = if not FFlagIEMSettingsGroups then t1 else t2
}
