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
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local v14 = game:DefineFastInt("ChatModerationFrameLayoutOrder", 9)
local t1 = {
	OverscanAdjustButton = 1
}

if FFlagEnableModerateChatRemoteEvent then
	t1.ChatModerationFrame = v14
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
	local v17 = ReactUtils.createNextOrder()

	t2 = {
		AudioHeader = v17(),
		VolumeFrame = v17(),
		VoiceChatVolumeFrame = if not FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then nil else v17(),
		PartyVoiceVolumeFrame = v17(),
		DeviceFrameInput = v17(),
		DeviceFrameOutput = v17(),
		AudioDivider = v17(),
		LanguageHeader = v17(),
		ChatModerationFrame = v17(),
		VoiceConnectDisconnectSelector = v17(),
		VoiceConnectFrame = v17(),
		VoiceDisconnectFrame = v17(),
		ChatSummariesFrame = if not FFlagChatSummariesSettingEnabled then nil else v17(),
		AIRephraseFrame = if not FFlagAIRephraseSettingEnabled then nil else v17(),
		PlayerChoiceTranslationFrame = if not game:GetEngineFeature("InExperiencePlayerChoiceToggle") then nil else v17(),
		LanguageSelectorFrame = v17(),
		FeedbackModeButton = v17(),
		ChatTranslationFrame = v17(),
		ChatLanguageSelectorFrame = v17(),
		ChatTranslationToggleFrame = v17(),
		LanguageDivider = v17(),
		DisplayHeader = v17(),
		OverscanAdjustButton = v17(),
		FullScreenFrame = v17(),
		PreferredTransparencyFrame = v17(),
		PreferredTextSizeFrame = v17(),
		VRComfortSettingFrame = if not isInExperienceUIVREnabled then nil else v17(),
		VRVignetteEnabledFrame = if not isInExperienceUIVREnabled then nil else v17(),
		VRSteppedRotationEnabledFrame = if not isInExperienceUIVREnabled then nil else v17(),
		VRThirdPersonFixedCamEnabledFrame = if not isInExperienceUIVREnabled then nil else v17(),
		VRSafetyBubbleModeFrame = if not isInExperienceUIVREnabled then nil else v17(),
		PerformanceStatsFrame = v17(),
		MicroProfilerFrame = v17(),
		GraphicsEnablerFrame = v17(),
		GraphicsQualityFrame = v17(),
		HapticsFrame = v17(),
		ReducedMotionFrame = v17(),
		FramerateCap = v17(),
		VREnabledFrame = v17(),
		DisplayDivider = v17(),
		ViewAndControlsHeader = v17(),
		CameraModeFrame = v17(),
		CameraInvertedFrame = v17(),
		CameraSensitivityFrame = v17(),
		MouseAdvancedFrame = v17(),
		GamepadSensitivityFrame = v17(),
		MovementModeFrame = v17(),
		ShiftLockFrame = v17(),
		CameraDeviceFrame = v17(),
		UiNavigationKeyBindEnabledFrame = v17(),
		DeveloperConsoleButton = v17(),
		PlayerNamesEnabledFrame = if not GetFFlagEnablePlayerNamesEnabledSetting() then nil else v17(),
		BadgeVisibilityFrame = if not FFlagBadgeVisibilitySettingEnabled then nil else v17(),
		UiToggleRow = v17(),
		UiToggleRowCustom = v17(),
		UiToggleRowBillboards = v17(),
		UiToggleRowNameplates = v17(),
		FreecamToggleRow = v17(),
		InformationFrame = v17()
	}
end

local function getLayoutOrder() -- line: 206
	-- upvalues: FFlagIEMSettingsGroups (copy), t2 (ref), t1 (copy)
	if FFlagIEMSettingsGroups then
		return t2
	end

	return t1
end

return {
	SETTINGS_MENU_LAYOUT_ORDER = if not FFlagIEMSettingsGroups then t1 else t2
}
