local CoreGui = game:GetService("CoreGui")
local modules = CoreGui:WaitForChild("RobloxGui").Modules
local CorePackages = game:GetService("CorePackages")

local engineFeature = game:GetEngineFeature("PartyVoiceVolume")
local GetFFlagEnablePlayerNamesEnabledSetting = require(modules.Settings.Flags.GetFFlagEnablePlayerNamesEnabledSetting)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableModerateChatRemoteEvent = SharedFlags2.FFlagEnableModerateChatRemoteEvent
local FFlagIEMSettingsGroups = require(modules.Settings.Flags.FFlagIEMSettingsGroups)
local engineFeature2 = game:GetEngineFeature("RUUserScalePreferenceAPI")
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUIScaleEngineOptions = SharedFlags3.FFlagUIScaleEngineOptions
local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAIRephraseSettingEnabled = SharedFlags4.FFlagAIRephraseSettingEnabled
local defineFastFlag = game:DefineFastFlag("UpdateRephraseSettingUI", false)
local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChatSummariesSettingEnabled = SharedFlags5.FFlagChatSummariesSettingEnabled
local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags6.FFlagExpChatEnableFriendsTab

local SharedFlags7 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagExpChatDictationVoiceTypingModeSetting = SharedFlags7.FFlagExpChatDictationVoiceTypingModeSetting

local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local defineFastInt = game:DefineFastInt("ChatModerationFrameLayoutOrder", 9)

local v = {}
v.MoreSettingsBanner = 0
v.OverscanAdjustButton = 1

if FFlagEnableModerateChatRemoteEvent then
	v.ChatModerationFrame = defineFastInt
end

v.ShiftLockFrame = 10
v.CameraModeFrame = 11
v.MovementModeFrame = 12
v.FramerateCap = 13
v.GamepadSensitivityFrame = 14
v.CameraInvertedFrame = 90
v.CameraDeviceFrame = 91

v.MouseAdvancedFrame = 50

v.VoiceConnectDisconnectSelector = 17
v.VoiceConnectFrame = 18
v.VoiceDisconnectFrame = 19

if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
	v.PlayerChoiceTranslationFrame = 20
	v.LanguageSelectorFrame = 21

	v.ChatTranslationFrame = 30
	v.ChatLanguageSelectorFrame = 31
	v.ChatTranslationToggleFrame = 32

	v.FeedbackModeButton = 40
else
	v.LanguageSelectorFrame = 20

	v.FeedbackModeButton = 30

	v.ChatTranslationFrame = 40
	v.ChatLanguageSelectorFrame = 41
	v.ChatTranslationToggleFrame = 42
end

if FFlagExpChatEnableFriendsTab then
	v.ChatNotificationsFrame = 44
end

if isInExperienceUIVREnabled then
	v.VRComfortSettingFrame = 54
	v.VRVignetteEnabledFrame = 55
	v.VRSteppedRotationEnabledFrame = 56
	v.VRThirdPersonFixedCamEnabledFrame = 57
	v.VRSafetyBubbleModeFrame = 58
end

v.DeviceFrameInput = 60
v.DeviceFrameOutput = 61
v.VolumeFrame = 62

if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
	v.VoiceChatVolumeFrame = 63

	if engineFeature then
		v.PartyVoiceVolumeFrame = 64
	end

	v.HapticsFrame = engineFeature and 65 or 64
else
	if engineFeature then
		v.PartyVoiceVolumeFrame = 63
	end

	v.HapticsFrame = engineFeature and 64 or 63
end

v.FullScreenFrame = 70
v.GraphicsEnablerFrame = 71
v.GraphicsQualityFrame = 72
v.ReducedMotionFrame = 73

v.PreferredTransparencyFrame = FFlagUIScaleEngineOptions and 77 or 74
v.PreferredTextSizeFrame = FFlagUIScaleEngineOptions and 76 or 75

if engineFeature2 then
	v.UIScaleModeFrame = 76
	v.UIScaleFrame = 77
	v.UiNavigationKeyBindEnabledFrame = 78
else
	v.UiNavigationKeyBindEnabledFrame = 76
end

if FFlagUIScaleEngineOptions then
	v.UIScaleEngineModeFrame = 74
	v.UIScaleEngineFrame = 75
end

v.PerformanceStatsFrame = 80
v.MicroProfilerFrame = 81

v.VREnabledFrame = 100
v.DeveloperConsoleButton = 101

if GetFFlagEnablePlayerNamesEnabledSetting() then
	v.PlayerNamesEnabledFrame = 105
end

if FFlagBadgeVisibilitySettingEnabled then
	v.BadgeVisibilityFrame = 106
end

if FFlagAIRephraseSettingEnabled then
	v.AIRephraseFrame = defineFastFlag and 20 or 43
end

if FFlagChatSummariesSettingEnabled then
	v.ChatSummariesFrame = 20
end

if FFlagExpChatDictationVoiceTypingModeSetting then
	v.VoiceTypingModeFrame = 16
end

v.UiToggleRow = 200
v.UiToggleRowCustom = 200
v.UiToggleRowBillboards = 201
v.UiToggleRowNameplates = 202
v.FreecamToggleRow = 203
v.InformationFrame = 999
local v2

if FFlagIEMSettingsGroups then
	local nextOrder = ReactUtils.createNextOrder()

	v2 = {
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		["MoreSettingsBanner"] = nil,
		MoreSettingsBanner = nextOrder(),
		AudioHeader = nextOrder(),
		VolumeFrame = nextOrder()
	}
	local voiceChatVolumeFrame

	if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		voiceChatVolumeFrame = nextOrder()
	end

	v2.VoiceChatVolumeFrame = voiceChatVolumeFrame
	v2.PartyVoiceVolumeFrame = nextOrder()
	v2.DeviceFrameInput = nextOrder()
	v2.DeviceFrameOutput = nextOrder()
	v2.AudioDivider = nextOrder()

	v2.LanguageHeader = nextOrder()
	local voiceTypingModeFrame

	if FFlagExpChatDictationVoiceTypingModeSetting then
		voiceTypingModeFrame = nextOrder()
	end

	v2.VoiceTypingModeFrame = voiceTypingModeFrame
	v2.ChatModerationFrame = nextOrder()
	v2.VoiceConnectDisconnectSelector = nextOrder()
	v2.VoiceConnectFrame = nextOrder()
	v2.VoiceDisconnectFrame = nextOrder()
	local chatSummariesFrame

	if FFlagChatSummariesSettingEnabled then
		chatSummariesFrame = nextOrder()
	end

	v2.ChatSummariesFrame = chatSummariesFrame
	local aiRephraseFrame

	if FFlagAIRephraseSettingEnabled then
		aiRephraseFrame = nextOrder()
	end

	v2.AIRephraseFrame = aiRephraseFrame
	local playerChoiceTranslationFrame

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		playerChoiceTranslationFrame = nextOrder()
	end

	v2.PlayerChoiceTranslationFrame = playerChoiceTranslationFrame
	v2.LanguageSelectorFrame = nextOrder()
	v2.FeedbackModeButton = nextOrder()
	v2.ChatTranslationFrame = nextOrder()
	v2.ChatLanguageSelectorFrame = nextOrder()
	v2.ChatTranslationToggleFrame = nextOrder()
	local chatNotificationsFrame

	if FFlagExpChatEnableFriendsTab then
		chatNotificationsFrame = nextOrder()
	end

	v2.ChatNotificationsFrame = chatNotificationsFrame
	v2.LanguageDivider = nextOrder()

	v2.DisplayHeader = nextOrder()
	v2.OverscanAdjustButton = nextOrder()
	v2.FullScreenFrame = nextOrder()
	local uiScaleEngineModeFrame

	if FFlagUIScaleEngineOptions then
		uiScaleEngineModeFrame = nextOrder()
	end

	v2.UIScaleEngineModeFrame = uiScaleEngineModeFrame
	local uiScaleEngineFrame

	if FFlagUIScaleEngineOptions then
		uiScaleEngineFrame = nextOrder()
	end

	v2.UIScaleEngineFrame = uiScaleEngineFrame
	v2.PreferredTransparencyFrame = nextOrder()
	v2.PreferredTextSizeFrame = nextOrder()
	local uiScaleModeFrame

	if engineFeature2 then
		uiScaleModeFrame = nextOrder()
	end

	v2.UIScaleModeFrame = uiScaleModeFrame
	local uiScaleFrame

	if engineFeature2 then
		uiScaleFrame = nextOrder()
	end

	v2.UIScaleFrame = uiScaleFrame
	local vrComfortSettingFrame

	if isInExperienceUIVREnabled then
		vrComfortSettingFrame = nextOrder()
	end

	v2.VRComfortSettingFrame = vrComfortSettingFrame
	local vrVignetteEnabledFrame

	if isInExperienceUIVREnabled then
		vrVignetteEnabledFrame = nextOrder()
	end

	v2.VRVignetteEnabledFrame = vrVignetteEnabledFrame
	local vrSteppedRotationEnabledFrame

	if isInExperienceUIVREnabled then
		vrSteppedRotationEnabledFrame = nextOrder()
	end

	v2.VRSteppedRotationEnabledFrame = vrSteppedRotationEnabledFrame
	local vrThirdPersonFixedCamEnabledFrame

	if isInExperienceUIVREnabled then
		vrThirdPersonFixedCamEnabledFrame = nextOrder()
	end

	v2.VRThirdPersonFixedCamEnabledFrame = vrThirdPersonFixedCamEnabledFrame
	local vrSafetyBubbleModeFrame

	if isInExperienceUIVREnabled then
		vrSafetyBubbleModeFrame = nextOrder()
	end

	v2.VRSafetyBubbleModeFrame = vrSafetyBubbleModeFrame
	v2.PerformanceStatsFrame = nextOrder()
	v2.MicroProfilerFrame = nextOrder()
	v2.GraphicsEnablerFrame = nextOrder()
	v2.GraphicsQualityFrame = nextOrder()
	v2.HapticsFrame = nextOrder()
	v2.ReducedMotionFrame = nextOrder()
	v2.FramerateCap = nextOrder()
	v2.VREnabledFrame = nextOrder()
	v2.DisplayDivider = nextOrder()

	v2.ViewAndControlsHeader = nextOrder()
	v2.CameraModeFrame = nextOrder()
	v2.CameraInvertedFrame = nextOrder()
	v2.CameraSensitivityFrame = nextOrder()
	v2.MouseAdvancedFrame = nextOrder()
	v2.GamepadSensitivityFrame = nextOrder()
	v2.MovementModeFrame = nextOrder()
	v2.ShiftLockFrame = nextOrder()
	v2.CameraDeviceFrame = nextOrder()
	v2.UiNavigationKeyBindEnabledFrame = nextOrder()
	v2.DeveloperConsoleButton = nextOrder()
	local playerNamesEnabledFrame

	if GetFFlagEnablePlayerNamesEnabledSetting() then
		playerNamesEnabledFrame = nextOrder()
	end

	v2.PlayerNamesEnabledFrame = playerNamesEnabledFrame
	local badgeVisibilityFrame

	if FFlagBadgeVisibilitySettingEnabled then
		badgeVisibilityFrame = nextOrder()
	end

	v2.BadgeVisibilityFrame = badgeVisibilityFrame

	v2.UiToggleRow = nextOrder()
	v2.UiToggleRowCustom = nextOrder()
	v2.UiToggleRowBillboards = nextOrder()
	v2.UiToggleRowNameplates = nextOrder()
	v2.FreecamToggleRow = nextOrder()
	v2.InformationFrame = nextOrder()

	if FFlagUIScaleEngineOptions then
		local preferredTransparencyFrame = v2.PreferredTransparencyFrame
		local preferredTextSizeFrame = v2.PreferredTextSizeFrame
		v2.PreferredTextSizeFrame = preferredTransparencyFrame
		v2.PreferredTransparencyFrame = preferredTextSizeFrame
	end
else
	v2 = nil
end

local function getLayoutOrder() -- 1 equivalent call inferred from this helper
	return if FFlagIEMSettingsGroups then v2 else v
end

return { SETTINGS_MENU_LAYOUT_ORDER = getLayoutOrder() } -- inferred equivalent call
