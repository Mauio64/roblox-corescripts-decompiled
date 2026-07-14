local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local SoundService = game:GetService("SoundService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local v13 = UserSettings()
local GameSettings = v13.GameSettings
local VideoCaptureService = game:GetService("VideoCaptureService")
local UserGameSettings = v13:GetService("UserGameSettings")
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url
local TextChatService = game:GetService("TextChatService")
local SafetyService = game:GetService("SafetyService")
local ExperienceStateCaptureService = nil

if game:GetEngineFeature("CaptureModeEnabled") then
	ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
end

local GetFFlagEnableConnectDisconnectInSettingsAndChrome = require(RobloxGui.Modules.Flags.GetFFlagEnableConnectDisconnectInSettingsAndChrome)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local FFlagIEMSettingsGroups = require(RobloxGui.Modules.Settings.Flags.FFlagIEMSettingsGroups)
local u24 = nil

if GetFFlagEnableConnectDisconnectInSettingsAndChrome() or isInExperienceUIVREnabled then
	local LocalizationService = game:GetService("LocalizationService")

	u24 = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization.new(LocalizationService.RobloxLocaleId)
end

local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local isCamEnabledForUserAndPlace = require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)
local renderSettingsHeader = nil
local renderSettingsDivider = nil

if FFlagIEMSettingsGroups then
	renderSettingsHeader = require(RobloxGui.Modules.Settings.Components.renderSettingsHeader)
	renderSettingsDivider = require(RobloxGui.Modules.Settings.Components.renderSettingsDivider)
end

local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local isVoiceFocused = require(CorePackages.Workspace.Packages.CrossExperience).Utils.isVoiceFocused
local observeIsVoiceFocused = require(CorePackages.Workspace.Packages.CrossExperience).Utils.observeIsVoiceFocused
local cameraDevicePermissionGrantedSignal = require(CoreGui.RobloxGui.Modules.Settings.cameraDevicePermissionGrantedSignal)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty = SharedFlags.GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local GetFFlagSelfViewCameraSettings = SharedFlags.GetFFlagSelfViewCameraSettings
local GetFFlagAlwaysShowVRToggle = require(RobloxGui.Modules.Flags.GetFFlagAlwaysShowVRToggle)
local GetFIntDebounceDisconnectButtonDelay = require(RobloxGui.Modules.Flags.GetFIntDebounceDisconnectButtonDelay)
local GetFIntDebounceAIRephraseSettingDelay = require(RobloxGui.Modules.Flags.GetFIntDebounceAIRephraseSettingDelay)
local GetFIntDebounceChatSummariesSettingDelay = require(RobloxGui.Modules.Flags.GetFIntDebounceChatSummariesSettingDelay)
local TouchEnabled = UserInputService.TouchEnabled
local GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice = SharedFlags.GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice
local FFlagIEMFocusNavToButtons = SharedFlags.FFlagIEMFocusNavToButtons
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local v46 = game:DefineFastFlag("ShowAntiHarassmentSettings", false)
local GetFFlagEnablePlayerNamesEnabledSetting = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnablePlayerNamesEnabledSetting)
local FFlagUpdatePeopleNamesSettingCopy = require(RobloxGui.Modules.Settings.Flags.FFlagUpdatePeopleNamesSettingCopy)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local GetFFlagEnableVoiceUxUpdates = SharedFlags.GetFFlagEnableVoiceUxUpdates
local GetFFlagEnableVrVoiceConnectDisconnect = SharedFlags.GetFFlagEnableVrVoiceConnectDisconnect
local v52 = game:DefineFastFlag("EnableVoiceSelectorTranslations_AEGIS2", false)
local v53 = game:DefineFastFlag("HideVoiceChatSelectorForFae_AEGIS2", false)
local v54 = game:DefineFastFlag("CenterShiftLockOverride", true)
local v55 = game:DefineFastFlag("VoiceChatSelectorReconnectFocus2_AEGIS2", false)
local v56 = game:DefineFastFlag("MicroProfilerReadOnlyInformationLabel", false)
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local v58 = game:DefineFastFlag("VoiceSelectorAvailableAfterFae", false)
local v59 = game:DefineFastFlag("DifferentiateVoiceSelectorSystemAndUser", false)
local v60 = game:DefineFastFlag("DeferProgrammaticChange", false)
local FFlagAIRephraseSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagVoiceRewarmTelemetry = SharedFlags.FFlagVoiceRewarmTelemetry
local v64 = game:DefineFastFlag("DebounceVoiceSelectorIndexChange", false)
local v65 = game:DefineFastFlag("VoiceSelectorIgnoreFailedStateDisconnect", false)
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local v67 = game:DefineFastFlag("VoiceVolumeControlsFixSliderVisibilityOnEligibleGames", false)
local v68 = game:DefineFastFlag("VoiceVolumeControlsDisableInteractionWhenNoMasterVolume", false)
local v69 = require(CorePackages.Workspace.Packages.VoiceChatCore).Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()
local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(RobloxGui.Modules.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local GameSettingsConstants = require(RobloxGui.Modules.Settings.Resources.GameSettingsConstants)
local v75 = default2 and default2.getHasPartyVoiceVolume()
local Constants = require(RobloxGui:WaitForChild("Modules"):WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local t1 = {
	["Enum.SavedQualitySetting.Automatic"] = 0,
	["Enum.SavedQualitySetting.QualityLevel1"] = 1,
	["Enum.SavedQualitySetting.QualityLevel2"] = 2,
	["Enum.SavedQualitySetting.QualityLevel3"] = 3,
	["Enum.SavedQualitySetting.QualityLevel4"] = 4,
	["Enum.SavedQualitySetting.QualityLevel5"] = 5,
	["Enum.SavedQualitySetting.QualityLevel6"] = 6,
	["Enum.SavedQualitySetting.QualityLevel7"] = 7,
	["Enum.SavedQualitySetting.QualityLevel8"] = 8,
	["Enum.SavedQualitySetting.QualityLevel9"] = 9,
	["Enum.SavedQualitySetting.QualityLevel10"] = 10
}

local function voiceChatVolumeToSlider(n1: number) -- line: 139
	return (math.floor(n1 * 5 + 0.5))
end
local function voiceChatVolumeFromSlider(n2: number) -- line: 143
	return n2 / 5
end

local t2 = {
	DevComputerMovementMode = true,
	DevComputerCameraMode = true,
	DevEnableMouseLock = true
}
local t3 = {
	DevTouchMovementMode = true,
	DevTouchCameraMode = true
}
local t4 = {
	DEFAULT_FOLLOW = "Default (Follow)",
	DEFAULT_CLASSIC = "Default (Classic)"
}
local t5 = {
	Input = "Input",
	Output = "Output"
}
local t6 = {
	DEFAULT_THUMBSTICK = "Default (Dynamic Thumbstick)",
	DEFAULT_KEYBOARD = "Default (Keyboard)",
	TAP_TO_MOVE = "Tap to Move",
	CLICK_TO_MOVE = "Click to Move"
}
local v85 = RobloxTranslator:FormatByKey("Feature.SettingsHub.TouchMovementMode.ClassicThumbstick")
local v86 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")
local v87 = RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.ButtonText")
local t7 = {
	On = 1,
	Off = 2
}

local function getDefaultCameraMode() -- line: 186
	-- upvalues: UserInputService (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Default (Follow)"
	end

	return "Default (Classic)"
end
local function getDefaultMovementMode() -- line: 195
	-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
	end

	return "Default (Keyboard)"
end
local function getDefaultSelectToMove() -- line: 204
	-- upvalues: UserInputService (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Tap to Move"
	end

	return "Click to Move"
end

local SETTINGS_MENU_LAYOUT_ORDER = GameSettingsConstants.SETTINGS_MENU_LAYOUT_ORDER
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local GetFFlagChatTranslationSettingEnabled = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationSettingEnabled)
local GetFStringChatTranslationLayerName = require(RobloxGui.Modules.Flags.GetFStringChatTranslationLayerName)
local GetFFlagChatTranslationHoldoutEnabled = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationHoldoutEnabled)
local GetFFlagChatTranslationWaitForIXP = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationWaitForIXP)
local GetFFlagChatTranslationForceSetting = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationForceSetting)
local GetFFlagChatTranslationNewDefaults = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationNewDefaults)
local EngineFeature = game:GetEngineFeature("TextChatServiceSettingsSaved")
local ChatTranslationOptionsWithChatLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ChatTranslationOptionsWithChatLanguageSwitcherInitializer)
local EngineFeature2 = game:GetEngineFeature("GameBasicSettingsFramerateCap")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local CoreUtility = require(RobloxGui.Modules.CoreUtility)
local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)
local GetHasGuiHidingPermission = require(RobloxGui.Modules.Common.GetHasGuiHidingPermission)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Cryo = require(CorePackages.Packages.Cryo)
local GfxReset = require(script.Parent.Parent.GfxReset)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local ThrottleFunctionCall = require(CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame.ThrottleFunctionCall)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Signals = require(CorePackages.Packages.Signals)
local Migration = BuilderIcons.Migration

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
RobloxGui:WaitForChild("Modules"):WaitForChild("Settings"):WaitForChild("SettingsHub")

local v115 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local LocalPlayer = Players.LocalPlayer
local Platform = UserInputService:GetPlatform()
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local default3 = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceVolumeControlsEligibility = require(CorePackages.Workspace.Packages.VoiceChatCore).VoiceVolumeControlsEligibility
local default4 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).CrossExperienceVoiceManager.default
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v123 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.SystemDefault")
local v124 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.VideoCamera")
local v125 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

game:DefineFastInt("RomarkStartWithGraphicQualityLevel", -1)

local FastInt = game:GetFastInt("RomarkStartWithGraphicQualityLevel")
local v127 = not CachedPolicyService:IsSubjectToChinaPolicies()
local v128 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
local v129 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local v130 = if not isInExperienceUIVREnabled then (v129 or v128) and v127 else (v129 or (v128 or isSpatial())) and v127
local GetFIntVoiceChatDeviceChangeDebounceDelay = require(RobloxGui.Modules.Flags.GetFIntVoiceChatDeviceChangeDebounceDelay)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableExplicitSettingsChangeAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableExplicitSettingsChangeAnalytics)
local GetFFlagFixCyclicFullscreenIndexEvent = require(RobloxGui.Modules.Settings.Flags.GetFFlagFixCyclicFullscreenIndexEvent)
local v137 = game:DefineFastFlag("DisableFeedbackSoothsayerCheck", false)
local v138 = game:DefineFastFlag("UserShowGuiHideToggles", false)
local v139 = game:DefineFastFlag("UserFreecamGuiDestabilization", false)
local v140 = game:DefineFastFlag("FixDeveloperConsoleButtonSizeAndPositioning", false)
local v141 = game:DefineFastFlag("EnableTFFeedbackModeEntryCheck", false)
local v142 = game:DefineFastFlag("FeedbackEntryPointButtonSizeAdjustment2", false)
local v143 = game:DefineFastFlag("FeedbackEntryPointImprovedStrictnessCheck", false)
local GetFFlagEnableLocalesForExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLocalesForExperienceLanguageSwitcher)
local GetFFlagLazyInitiateExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagLazyInitiateExperienceLanguageSwitcher)
local ExperienceLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ExperienceLanguageSwitcherInitializer)
local PlayerChoiceTranslationSettingInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.PlayerChoiceTranslationSettingInitializer)
local v148 = game:DefineFastFlag("UpdateVisibilitySettingsCopy", false)
local v149 = game:DefineFastFlag("ExpChatDebounceRephraseIndexSelection", false)
local v150 = game:DefineFastFlag("EraseFPSFromDefaultSetting", false)

local function reportSettingsChangeForAnalytics(p1, p2, p3, p4) -- line: 331
	-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), UserInputService (copy), Cryo (copy), RbxAnalyticsService (copy), Constants (copy)
	if not GetFFlagEnableExplicitSettingsChangeAnalytics() or (p2 == p3 or p2 == nil or p3 == nil) then
		return
	end

	local t8 = {
		universe_id = tostring(game.GameId),
		name = p1,
		old_value = tostring(p2),
		new_value = tostring(p3),
		has_touch = UserInputService.TouchEnabled,
		has_mouse = UserInputService.MouseEnabled,
		has_gamepad = UserInputService.GamepadEnabled
	}

	if p4 then
		t8 = Cryo.Dictionary.join(t8, p4)
	end

	RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsExplicitSettingsChangeName, t8)
end
local function reportSettingsForAnalytics() -- line: 362
	-- upvalues: UserInputService (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), EngineFeature2 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), RbxAnalyticsService (copy), Constants (copy)
	local t9 = {}
	local v165 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

	if v165 then
		t9.camera_mode_touch = tostring(GameSettings.TouchCameraMovementMode)
	else
		t9.camera_mode_desktop = tostring(GameSettings.ComputerCameraMovementMode)
	end

	if v165 then
		t9.movement_mode_touch = tostring(GameSettings.TouchMovementMode)
	else
		t9.movement_mode_desktop = tostring(GameSettings.ComputerMovementMode)
	end

	if UserInputService.MouseEnabled then
		t9.shift_lock_enabled = tostring(GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
	end

	if UserInputService.GamepadEnabled and GameSettings.IsUsingGamepadCameraSensitivity then
		local GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity

		t9.camera_sensitivity_gamepad = tostring((tonumber(string.format("%.2f", GamepadCameraSensitivity))))
	end

	if UserInputService.MouseEnabled then
		local MouseSensitivityFirstPersonX = GameSettings.MouseSensitivityFirstPerson.X

		t9.camera_sensitivity_mouse = tostring((tonumber(string.format("%.2f", MouseSensitivityFirstPersonX))))
	end

	t9.camera_y_inverted = tostring(GameSettings.CameraYInverted)
	t9.show_performance_stats = tostring(GameSettings.PerformanceStatsVisible)
	t9.volume = tostring((math.floor(GameSettings.MasterVolume * 10 + 0.5)))

	if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		t9.voice_chat_volume = tostring((math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)))
	end

	t9.gfx_quality_level = tostring(settings().Rendering.QualityLevel)

	if EngineFeature2 then
		t9.framerate_cap = tostring(GameSettings.FramerateCap)
	end

	t9.fullscreen_enabled = tostring(GameSettings:InFullScreen())
	t9.microprofiler_enabled = tostring(GameSettings.OnScreenProfilerEnabled)
	t9.microprofiler_webserver_enabled = tostring(GameSettings.MicroProfilerWebServerEnabled)
	t9.reduced_motion = tostring(GameSettings.ReducedMotion)
	t9.preferred_transparency = tostring(GameSettings.PreferredTransparency)
	t9.preferred_text_size = tostring(GameSettings.PreferredTextSize)
	t9.ui_navigation_key_bind_enabled = tostring(GameSettings.UiNavigationKeyBindEnabled)
	t9.universeid = tostring(game.GameId)

	if GetFFlagEnablePlayerNamesEnabledSetting() then
		t9.player_names_enabled = tostring(GameSettings.PlayerNamesEnabled)
	end

	RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsSettingsChangeName, t9)
end

game:DefineFastInt("V1MenuLanguageSelectionFeaturePerMillageRollout", 0)
game:DefineFastString("V1MenuLanguageSelectionFeatureForcedUserIds", "")

local v153 = game:DefineFastFlag("IGMEnableGFXReset", false)

local function getLastValueChangerFrame(p5) -- line: 431
	-- upvalues: FFlagIEMFocusNavToButtons (copy)
	if not FFlagIEMFocusNavToButtons then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v170 = nil

	for __, v in pairs(p5:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder <= SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v170 = p5:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v170
end
local function getFirstValueChangerFrame(p6) -- line: 450
	-- upvalues: FFlagIEMTabFocusNav (copy)
	if not FFlagIEMTabFocusNav then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v176 = nil

	for __, v in pairs(p6:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder > SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v176 = p6:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v176
end
local function Initialize() -- line: 469
	-- upvalues: v153 (copy), GfxReset (copy), RobloxGui (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), VRService (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), v150 (copy), RobloxTranslator (copy), FastInt (copy), t1 (copy), v148 (copy), FFlagUpdatePeopleNamesSettingCopy (copy), t7 (copy), UserInputService (copy), Create (copy), Theme (copy), v54 (copy), v56 (copy), TouchEnabled (copy), v129 (copy), v128 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), LocalPlayer (copy), CoreUtility (copy), t4 (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), t6 (copy), v85 (copy), t3 (copy), t2 (copy), Url (copy), HttpService (copy), v143 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), v142 (copy), v87 (copy), v137 (copy), v125 (copy), Players (copy), v86 (copy), RunService (copy), GetFFlagChatTranslationWaitForIXP (copy), IXPServiceWrapper (copy), GetFFlagChatTranslationNewDefaults (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), u24 (ref), v68 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), CorePackages (copy), ContextActionService (copy), v140 (copy), PlayerPermissionsModule (copy), v139 (copy), v138 (copy), SoundService (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), GetFFlagEnableCrossExpVoice (copy), Signals (copy), GetFIntDebounceAIRephraseSettingDelay (copy), TextChatService (copy), v149 (copy), ThrottleFunctionCall (copy), GetFIntDebounceChatSummariesSettingDelay (copy), v124 (copy), UserGameSettings (copy), GetFFlagVoiceChatUILogging (copy), VideoCaptureService (copy), v123 (copy), v59 (copy), v58 (copy), v52 (copy), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v65 (copy), v55 (copy), v64 (copy), v60 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), GetFFlagEnableVrVoiceConnectDisconnect (copy), GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v67 (copy), VoiceVolumeControlsEligibility (copy), GetFFlagEnableUniveralVoiceToasts (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), t5 (copy), GetFFlagSelfViewCameraSettings (copy), isCamEnabledForUserAndPlace (copy), getCamMicPermissions (copy), default (copy), cameraDevicePermissionGrantedSignal (copy), v115 (copy), v69 (copy), v75 (copy), v46 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), PlayerChoiceTranslationSettingInitializer (copy), CachedPolicyService (copy), v130 (copy), FFlagBadgeVisibilitySettingEnabled (copy), FFlagEnableModerateChatRemoteEvent (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), GetHasGuiHidingPermission (copy), FFlagIEMSettingsGroups (copy), renderSettingsHeader (ref), renderSettingsDivider (ref), Migration (copy), BuilderIcons (copy), v141 (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), EngineFeature (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy)
	if v153 then
		GfxReset.RunGfxReset()
	end

	local v180 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	if GetFFlagLazyInitiateExperienceLanguageSwitcher() then
		v180.LanguageSwitcherInitialized = false
	end

	local u181 = false
	local t10 = {}

	local function onVRSettingsReady() -- line: 482
		-- upvalues: VRService (copy), t10 (copy)
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end
	local function onVREnabled() -- line: 489
		-- upvalues: VRService (copy), u181 (ref), t10 (copy)
		if VRService.VREnabled and u181 then
			local VREnabled = VRService.VREnabled

			for k, __ in pairs(t10) do
				k.Visible = not VREnabled
			end
		end
	end

	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)

	if VRService.VREnabled and u181 then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	local function createGraphicsOptions() -- line: 501
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), VRService (copy), v150 (copy), RobloxTranslator (copy), v153 (copy), GfxReset (copy), FastInt (copy), t1 (copy)
		local n3 = 1

		if not GameSettings:InFullScreen() then
			n3 = 2
		end

		local v260 = v180
		local v261 = v180
		local v262 = v180
		local v263, v264, v265 = Utility:AddNewRow(v180, "Fullscreen", "Selector", {
			"On",
			"Off"
		}, n3)

		v260.FullscreenFrame = v263
		v261.FullscreenLabel = v264
		v262.FullscreenEnabler = v265
		v180.FullscreenFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FullScreenFrame
		t10[v180.FullscreenFrame] = true
		v180.FullscreenEnabler.IndexChanged:connect(function(p7) -- line: 514
			-- upvalues: GameSettings (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), v180 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v753 = GameSettings:InFullScreen()

			if p7 == 1 then
				if not GameSettings:InFullScreen() then
					GuiService:ToggleFullscreen()

					if GetFFlagFixCyclicFullscreenIndexEvent() then
						if v180.FullscreenEnabler.GetSelectedIndex() ~= 1 then
							v180.FullscreenEnabler:SetSelectionIndex(1)
						end
					else
						v180.FullscreenEnabler:SetSelectionIndex(1)
					end
				end
			elseif p7 == 2 and GameSettings:InFullScreen() then
				GuiService:ToggleFullscreen()

				if GetFFlagFixCyclicFullscreenIndexEvent() then
					if v180.FullscreenEnabler.GetSelectedIndex() ~= 2 then
						v180.FullscreenEnabler:SetSelectionIndex(2)
					end
				else
					v180.FullscreenEnabler:SetSelectionIndex(2)
				end
			end

			spawn(function() -- line: 539
				-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), v753 (copy), GameSettings (copy), reportSettingsForAnalytics (copy)
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("fullscreen_enabled", v753, GameSettings:InFullScreen())
				end

				reportSettingsForAnalytics()
			end)
		end)
		GameSettings.FullscreenChanged:connect(function(p8) -- line: 547
			-- upvalues: v180 (copy), RbxAnalyticsService (copy), Constants (copy)
			if p8 then
				if v180.FullscreenEnabler:GetSelectedIndex() ~= 1 then
					v180.FullscreenEnabler:SetSelectionIndex(1)
				end
			elseif v180.FullscreenEnabler:GetSelectedIndex() ~= 2 then
				v180.FullscreenEnabler:SetSelectionIndex(2)
			end

			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
				enabled = p8
			})
		end)

		local n4 = 1

		if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			n4 = 2
		end

		local v267 = v180
		local v268 = v180
		local v269 = v180
		local v270, v271, v272 = Utility:AddNewRow(v180, "Graphics Mode", "Selector", {
			"Automatic",
			"Manual"
		}, n4)

		v267.GraphicsEnablerFrame = v270
		v268.GraphicsEnablerLabel = v271
		v269.GraphicsQualityEnabler = v272
		v180.GraphicsEnablerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsEnablerFrame

		local v273 = v180
		local v274 = v180
		local v275 = v180
		local v276, v277, v278 = Utility:AddNewRow(v180, "Graphics Quality", "Slider", 10, 1)

		v273.GraphicsQualityFrame = v276
		v274.GraphicsQualityLabel = v277
		v275.GraphicsQualitySlider = v278
		v180.GraphicsQualityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsQualityFrame
		v180.GraphicsQualitySlider:SetMinStep(1)

		if EngineFeature2 and not VRService.VREnabled then
			local v279 = table.clone(Constants.FramerateCaps)
			local t11 = { if not v150 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateCapDefaultEntry", {
				Frames = GameSettings:GetDefaultFramerateCap()
			}) else RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.Default") }

			for __, v282 in v279 do
				table.insert(t11, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateEntry", {
					Frames = v282
				}))
			end

			table.insert(v279, 1, -1)
			task.defer(function() -- line: 613
				-- upvalues: v180 (copy), Utility (copy), RobloxTranslator (copy), t11 (copy), v279 (copy), GameSettings (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
				local v755 = v180
				local v756 = v180
				local v757 = v180
				local v758, v759, v760 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate"), "DropDown", t11, table.find(v279, GameSettings.FramerateCap), nil, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate.Description"))

				v755.FramerateCapFrame = v758
				v756.FramerateCapLabel = v759
				v757.FramerateCapMode = v760
				v180.FramerateCapFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FramerateCap
				v180.FramerateCapMode.IndexChanged:Connect(function(p9) -- line: 625
					-- upvalues: GameSettings (copy), v279 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
					local FramerateCap = GameSettings.FramerateCap

					GameSettings.FramerateCap = v279[p9]

					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						reportSettingsChangeForAnalytics("framerate_cap", FramerateCap, GameSettings.FramerateCap)
					end

					reportSettingsForAnalytics()
				end)
			end)
		end

		settings().Rendering.EnableFRM = true

		function SetGraphicsQuality(p10, p11) -- line: 643
			-- upvalues: v153 (copy), GfxReset (copy), GameSettings (copy)
			if v153 then
				local v763, v764 = GfxReset.TemporaryOverride(p10)

				if v763 then
					settings().Rendering.QualityLevel = v764

					return
				end
			end

			local v765 = p10 / 10
			local v766 = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * v765)

			if v766 == 20 then
				v766 = 21
			elseif p10 == 1 then
				v766 = 1
			elseif p10 < 1 and not p11 then
				p10 = 1
				v766 = 1
			elseif v766 > settings().Rendering:GetMaxQualityLevel() then
				v766 = settings().Rendering:GetMaxQualityLevel() - 1
			end

			GameSettings.SavedQualityLevel = p10
			settings().Rendering.QualityLevel = v766
		end

		local function setGraphicsToAuto() -- line: 669
			-- upvalues: v180 (copy)
			v180.GraphicsQualitySlider:SetZIndex(1)
			v180.GraphicsQualityLabel.ZIndex = 1
			v180.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		end
		local function setGraphicsToManual(p12) -- line: 677
			-- upvalues: v180 (copy)
			v180.GraphicsQualitySlider:SetZIndex(2)
			v180.GraphicsQualityLabel.ZIndex = 2
			v180.GraphicsQualitySlider:SetInteractable(true)

			if p12 == v180.GraphicsQualitySlider:GetValue() then
				SetGraphicsQuality(p12)

				return
			end

			v180.GraphicsQualitySlider:SetValue(p12)
		end

		local u285 = false

		v180.GraphicsQualitySlider.ValueChanged:connect(function(p13) -- line: 691
			-- upvalues: u285 (ref), reportSettingsForAnalytics (copy)
			SetGraphicsQuality(p13)

			if u285 == true then
				reportSettingsForAnalytics()
			end

			u285 = true
		end)
		v180.GraphicsQualityEnabler.IndexChanged:connect(function(p14) -- line: 699
			-- upvalues: v180 (copy), setGraphicsToManual (copy), reportSettingsForAnalytics (copy), reportSettingsChangeForAnalytics (copy)
			local t12 = {
				Automatic = {
					Name = "Automatic",
					Value = 1
				},
				Manual = {
					Name = "Manual",
					Value = 2
				}
			}
			local AutomaticName = t12.Automatic.Name
			local ManualName = t12.Manual.Name

			if p14 == t12.Automatic.Value then
				AutomaticName = t12.Manual.Name
				ManualName = t12.Automatic.Name
				v180.GraphicsQualitySlider:SetZIndex(1)
				v180.GraphicsQualityLabel.ZIndex = 1
				v180.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			elseif p14 == t12.Manual.Value then
				setGraphicsToManual(v180.GraphicsQualitySlider:GetValue())
			end

			reportSettingsForAnalytics()
			reportSettingsChangeForAnalytics("gfx_mode", AutomaticName, ManualName)
		end)
		game.GraphicsQualityChangeRequest:Connect(function(p15) -- line: 717
			-- upvalues: GameSettings (copy), v180 (copy)
			if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
				local Value = v180.GraphicsQualitySlider:GetValue()
				local v775 = if not p15 then Value - 1 else Value + 1

				v180.GraphicsQualitySlider:SetValue(v775)
			end
		end)

		if FastInt >= 0 then
			if FastInt == 0 then
				v180.GraphicsQualityEnabler:SetSelectionIndex(1)
				v180.GraphicsQualitySlider:SetZIndex(1)
				v180.GraphicsQualityLabel.ZIndex = 1
				v180.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			else
				v180.GraphicsQualityEnabler:SetSelectionIndex(2)
				setGraphicsToManual(FastInt)
			end
		elseif GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			v180.GraphicsQualitySlider:SetValue(5)
			v180.GraphicsQualitySlider:SetZIndex(1)
			v180.GraphicsQualityLabel.ZIndex = 1
			v180.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		else
			local str = tostring(GameSettings.SavedQualityLevel)
			local u287 = not t1[str] and 10 or t1[str]

			SetGraphicsQuality(u287)
			spawn(function() -- line: 750
				-- upvalues: v180 (copy), u287 (ref)
				v180.GraphicsQualitySlider:SetValue(u287)
			end)
		end
	end
	local function createReducedMotionOptions() -- line: 756
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n5 = 2

		if GameSettings.ReducedMotion then
			n5 = 1
		end

		local v289 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.ReducedMotion")
		local v290 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.ReducedMotion")
		local v291 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v292 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v293 = v180
		local v294 = v180
		local v295 = v180
		local v296, v297, v298 = Utility:AddNewRow(v180, v289, "Selector", {
			v291,
			v292
		}, n5, nil, v290)

		v293.ReducedMotionFrame = v296
		v294.ReducedMotionLabel = v297
		v295.ReducedMotionMode = v298
		v180.ReducedMotionFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ReducedMotionFrame
		v180.ReducedMotionMode.IndexChanged:connect(function(p16) -- line: 778
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local ReducedMotion = GameSettings.ReducedMotion

			GameSettings.ReducedMotion = p16 == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("reduced_motion", ReducedMotion, GameSettings.ReducedMotion)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPlayerNamesEnabledOptions() -- line: 789
		-- upvalues: v148 (copy), RobloxTranslator (copy), FFlagUpdatePeopleNamesSettingCopy (copy), GameSettings (copy), t7 (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v299 = if not v148 then if not FFlagUpdatePeopleNamesSettingCopy then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PlayerNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeoplesNames")
		local v300 = if not FFlagUpdatePeopleNamesSettingCopy then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames.Description")

		local function GetPlayerNamesEnabledStartIndex() -- line: 797
			-- upvalues: GameSettings (copy)
			if GameSettings.PlayerNamesEnabled then
				return 1
			end

			return 2
		end

		local v302 = if not GameSettings.PlayerNamesEnabled then t7.Off else t7.On
		local v303 = if not v148 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
		local v304 = if not v148 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
		local v305 = v180
		local v306 = v180
		local v307 = v180
		local v308, v309, v310 = Utility:AddNewRow(v180, v299, "Selector", {
			v303,
			v304
		}, v302, nil, v300)

		v305.PlayerNamesEnabledFrame = v308
		v306.playerNamesEnabledLabel = v309
		v307.playerNamesEnabledMode = v310
		v180.PlayerNamesEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PlayerNamesEnabledFrame
		v180.playerNamesEnabledMode.IndexChanged:connect(function(p17) -- line: 816
			-- upvalues: GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PlayerNamesEnabled = GameSettings.PlayerNamesEnabled

			GameSettings.PlayerNamesEnabled = p17 == 1
			reportSettingsChangeForAnalytics("player_names_enabled", PlayerNamesEnabled, GameSettings.PlayerNamesEnabled)
			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTransparencyOptions() -- line: 825
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v311 = 10 - math.clamp(math.floor(GameSettings.PreferredTransparency * 10 + 0.5), 0, 10)
		local v312 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTransparency")
		local v313 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTransparency")
		local v314 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Transparent")
		local v315 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Opaque")
		local v316 = v180
		local v317 = v180
		local v318 = v180
		local v319, v320, v321 = Utility:AddNewRow(v180, v312, "Slider", 10, v311, nil, v313, v314, v315)

		v316.PreferredTransparencyFrame = v319
		v317.PreferredTransparencyLabel = v320
		v318.PreferredTransparencySlider = v321
		v180.PreferredTransparencyFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTransparencyFrame
		v180.PreferredTransparencySlider.ValueChanged:connect(function(p18) -- line: 851
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v781 = (10 - math.clamp(math.floor(p18), 0, 10)) / 10
			local PreferredTransparency = GameSettings.PreferredTransparency

			GameSettings.PreferredTransparency = v781

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_transparency", PreferredTransparency, GameSettings.PreferredTransparency)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTextSizeOptions() -- line: 863
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local EnumItems = Enum.PreferredTextSize:GetEnumItems()
		local v323 = GameSettings.PreferredTextSize.Value - 1
		local v324 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTextSize")
		local v325 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTextSize")
		local v326 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Default")
		local v327 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Largest")
		local v328 = v180
		local v329 = v180
		local v330 = v180
		local v331, v332, v333 = Utility:AddNewRow(v180, v324, "Slider", 3, v323, nil, v325, v326, v327)

		v328.PreferredTextSizeFrame = v331
		v329.PreferredTextSizeLabel = v332
		v330.PreferredTextSizeSlider = v333
		v180.PreferredTextSizeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTextSizeFrame
		v180.PreferredTextSizeSlider.ValueChanged:connect(function(p19) -- line: 888
			-- upvalues: GameSettings (copy), EnumItems (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PreferredTextSize = GameSettings.PreferredTextSize

			GameSettings.PreferredTextSize = EnumItems[p19 + 1]

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_text_size", PreferredTextSize, GameSettings.PreferredTextSize)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createUiNavigationKeyBindOptions() -- line: 898
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), UserInputService (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local t13 = {
			On = 1,
			Off = 2
		}
		local Off = t13.Off

		if GameSettings.UiNavigationKeyBindEnabled then
			Off = t13.On
		end

		local v336 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.UiNavigationKeyBind")
		local v337 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.UiNavigationKeyBind", {
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})
		local v338 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v339 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v340 = v180
		local v341 = v180
		local v342 = v180
		local v343, v344, v345 = Utility:AddNewRow(v180, v336, "Selector", {
			v338,
			v339
		}, Off, nil, v337)

		v340.UiNavigationKeyBindEnabledFrame = v343
		v341.UiNavigationKeyBindEnabledLabel = v344
		v342.UiNavigationKeyBindEnabledMode = v345
		v180.UiNavigationKeyBindEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame
		v180.UiNavigationKeyBindEnabledMode.IndexChanged:connect(function(p20) -- line: 929
			-- upvalues: GameSettings (copy), t13 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local UiNavigationKeyBindEnabled = GameSettings.UiNavigationKeyBindEnabled

			GameSettings.UiNavigationKeyBindEnabled = p20 == t13.On

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("ui_navigation_key_bind_enabled", UiNavigationKeyBindEnabled, GameSettings.UiNavigationKeyBindEnabled)
			end

			reportSettingsForAnalytics()
		end)

		local function updateUiNavigationKeyBindVisibility() -- line: 942
			-- upvalues: UserInputService (copy), v180 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled = UserInputService.KeyboardEnabled

			if v180.UiNavigationKeyBindEnabledFrame then
				v180.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

				if KeyboardEnabled then
					v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		local KeyboardEnabled = UserInputService.KeyboardEnabled

		if v180.UiNavigationKeyBindEnabledFrame then
			v180.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

			if KeyboardEnabled then
				v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)
			else
				v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 957
			-- upvalues: UserInputService (copy), v180 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled2 = UserInputService.KeyboardEnabled

			if v180.UiNavigationKeyBindEnabledFrame then
				v180.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled2

				if KeyboardEnabled2 then
					v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v180.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end)
	end
	local function createPerformanceStatsOptions() -- line: 962
		-- upvalues: v180 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v348 = v180
		local v349 = v180
		local v350 = v180
		local v351 = v180

		v348.PerformanceStatsFrame = nil
		v349.PerformanceStatsLabel = nil
		v350.PerformanceStatsMode = nil
		v351.PerformanceStatsOverrideText = nil

		function GetDesiredPerformanceStatsIndex() -- line: 968
			-- upvalues: GameSettings (copy)
			if GameSettings.PerformanceStatsVisible then
				return 1
			end

			return 2
		end

		local v352 = GetDesiredPerformanceStatsIndex()
		local v353 = v180
		local v354 = v180
		local v355 = v180
		local v356, v357, v358 = Utility:AddNewRow(v180, "Performance Stats", "Selector", {
			"On",
			"Off"
		}, v352)

		v353.PerformanceStatsFrame = v356
		v354.PerformanceStatsLabel = v357
		v355.PerformanceStatsMode = v358
		v180.PerformanceStatsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PerformanceStatsFrame
		v180.PerformanceStatsOverrideText = Create("TextLabel")({
			Name = "PerformanceStatsLabel",
			Text = "Set by Developer",
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = 2,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			Size = if not v54 then UDim2.new(0, 200, 1, 0) else UDim2.new(0.6, 0, 1, 0),
			Position = if not v54 then UDim2.new(1, -350, 0, 0) else UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = if not v54 then nil else Vector2.new(1, 0.5),
			Parent = v180.PerformanceStatsFrame
		})
		v180.PerformanceStatsMode.IndexChanged:connect(function(p21) -- line: 997
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PerformanceStatsVisible = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				PerformanceStatsVisible = GameSettings.PerformanceStatsVisible
			end

			if p21 == 1 then
				GameSettings.PerformanceStatsVisible = true
			else
				GameSettings.PerformanceStatsVisible = false
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("show_performance_stats", PerformanceStatsVisible, GameSettings.PerformanceStatsVisible)
			end

			reportSettingsForAnalytics()
		end)
		GameSettings.PerformanceStatsVisibleChanged:connect(function() -- line: 1019
			-- upvalues: v180 (copy)
			local v791 = GetDesiredPerformanceStatsIndex()

			if v791 ~= v180.PerformanceStatsMode.CurrentIndex then
				v180.PerformanceStatsMode:SetSelectionIndex(v791)
			end
		end)
	end
	local function createWebServerInformationRow() -- line: 1029
		-- upvalues: v180 (copy), Utility (copy), v56 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), TouchEnabled (copy), Create (copy), Theme (copy)
		local v359 = v180
		local v360 = v180
		local v361 = v180
		local v362, v363, v364 = Utility:AddNewRow(v180, "MicroProfiler Information", "TextBox", nil, nil, 5, nil, nil, nil, not v56 and nil)

		v359.InformationFrame = v362
		v360.InformationLabel = v363
		v361.InformationTextBox = v364
		v180.InformationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.InformationFrame
		v180.InformationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		if TouchEnabled then
			v180.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size18),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				Parent = v180.InformationFrame
			})
		else
			v180.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size14),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(1, -650, 0, 20),
				Parent = v180.InformationFrame
			})
		end

		return v180.InformationFrame, v180.InformationText
	end
	local function createMicroProfilerOptions() -- line: 1069
		-- upvalues: v180 (copy), GameSettings (copy), createWebServerInformationRow (copy), v129 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v128 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v365 = v180
		local v366 = v180
		local v367 = v180
		local v368 = v180

		v365.MicroProfilerFrame = nil
		v366.MicroProfilerLabel = nil
		v367.MicroProfilerMode = nil
		v368.MicroProfilerOverrideText = nil

		local function tryContentLabel() -- line: 1074
			-- upvalues: GameSettings (copy), v180 (copy), createWebServerInformationRow (copy)
			local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

			if MicroProfilerWebServerPort ~= 0 then
				local v793 = v180
				local v794 = v180
				local v795, v796 = createWebServerInformationRow()

				v793.InformationFrame = v795
				v794.InformationText = v796
				v180.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort

				return true
			end

			return false
		end
		local function setMicroProfilerIndex(p22) -- line: 1086
			-- upvalues: GameSettings (copy), v180 (copy), v129 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), createWebServerInformationRow (copy), v128 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local function hideContentLabel() -- line: 1087
				-- upvalues: GameSettings (copy), v180 (copy)
				GameSettings.MicroProfilerWebServerEnabled = false

				if v180.InformationFrame or v180.InformationText then
					v180.InformationFrame.Visible = false
					v180.InformationFrame.Parent = nil
					v180.InformationText.Parent = nil
					v180.InformationFrame = nil
					v180.InformationText = nil
				end
			end

			local s1 = nil
			local MicroProfilerWebServerEnabled = nil
			local MicroProfilerWebServerEnabled2 = nil

			if v129 then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					s1 = "webserver"
					MicroProfilerWebServerEnabled = GameSettings.MicroProfilerWebServerEnabled
				end

				if p22 == 1 then
					GameSettings.MicroProfilerWebServerEnabled = true

					local n6 = 30

					while n6 >= 1 do
						local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort
						local v808

						if MicroProfilerWebServerPort ~= 0 then
							local v804 = v180
							local v805 = v180
							local v806, v807 = createWebServerInformationRow()

							v804.InformationFrame = v806
							v805.InformationText = v807
							v180.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
							v808 = true
						else
							v808 = false
						end

						if v808 then
							break
						end

						n6 -= 1
						wait(0.1)
					end

					if n6 <= 0 then
						v180.MicroProfilerMode:SetSelectionIndex(2)
						GameSettings.MicroProfilerWebServerEnabled = false

						if v180.InformationFrame or v180.InformationText then
							v180.InformationFrame.Visible = false
							v180.InformationFrame.Parent = nil
							v180.InformationText.Parent = nil
							v180.InformationFrame = nil
							v180.InformationText = nil
						end
					end
				else
					GameSettings.MicroProfilerWebServerEnabled = false

					if v180.InformationFrame or v180.InformationText then
						v180.InformationFrame.Visible = false
						v180.InformationFrame.Parent = nil
						v180.InformationText.Parent = nil
						v180.InformationFrame = nil
						v180.InformationText = nil
					end
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					MicroProfilerWebServerEnabled2 = GameSettings.MicroProfilerWebServerEnabled
				end
			elseif v128 or isInExperienceUIVREnabled and isSpatial() then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					s1 = "regular"
					MicroProfilerWebServerEnabled = GameSettings.OnScreenProfilerEnabled
				end

				GameSettings.OnScreenProfilerEnabled = p22 == 1

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					MicroProfilerWebServerEnabled2 = GameSettings.OnScreenProfilerEnabled
				end
			end

			RbxAnalyticsService:ReportCounter("MicroprofilerSettingsPressed")

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("microprofiler_enabled", MicroProfilerWebServerEnabled, MicroProfilerWebServerEnabled2, {
					microprofiler_type = s1
				})
			end

			reportSettingsForAnalytics()
		end
		local function GetDesiredWebServerIndex() -- line: 1160
			-- upvalues: v129 (copy), GameSettings (copy), v128 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy)
			if v129 then
				if GameSettings.MicroProfilerWebServerEnabled then
					return 1
				end

				return 2
			end

			if v128 or isInExperienceUIVREnabled and isSpatial() then
				if GameSettings.OnScreenProfilerEnabled then
					return 1
				end

				return 2
			end

			return 2
		end

		local v372 = if not v129 then not v128 and (not isInExperienceUIVREnabled or not isSpatial()) and 2 or (not GameSettings.OnScreenProfilerEnabled and 2 or 1) else not GameSettings.MicroProfilerWebServerEnabled and 2 or 1
		local v373 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MicroProfiler")
		local v374 = v180
		local v375 = v180
		local v376 = v180
		local v377, v378, v379 = Utility:AddNewRow(v180, v373, "Selector", {
			"On",
			"Off"
		}, v372)

		v374.MicroProfilerFrame = v377
		v375.MicroProfilerLabel = v378
		v376.MicroProfilerMode = v379
		v180.MicroProfilerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MicroProfilerFrame

		local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

		if MicroProfilerWebServerPort ~= 0 then
			local v381 = v180
			local v382 = v180
			local v383, v384 = createWebServerInformationRow()

			v381.InformationFrame = v383
			v382.InformationText = v384
			v180.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
		end

		local u385 = false

		GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 1189
			-- upvalues: u385 (ref), GameSettings (copy), v180 (copy)
			u385 = true

			if GameSettings.OnScreenProfilerEnabled then
				v180.MicroProfilerMode:SetSelectionIndex(1)

				return
			end

			v180.MicroProfilerMode:SetSelectionIndex(2)
		end)

		local function onIndexChanged(...) -- line: 1199
			-- upvalues: u385 (ref), setMicroProfilerIndex (copy)
			if u385 then
				u385 = false

				return
			end

			setMicroProfilerIndex(...)
		end

		v180.MicroProfilerMode.IndexChanged:connect(onIndexChanged)
	end
	local function createCameraModeOptions(p23) -- line: 1210
		-- upvalues: v180 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), LocalPlayer (copy), UserInputService (copy), CoreUtility (copy), t4 (copy), VRService (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v85 (copy), t3 (copy), t2 (copy)
		local v388 = v180
		local v389 = v180
		local v390 = v180
		local v391 = v180

		v388.ShiftLockFrame = nil
		v389.ShiftLockLabel = nil
		v390.ShiftLockMode = nil
		v391.ShiftLockOverrideText = nil

		local n7 = 2

		if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
			n7 = 1
		end

		local v393 = v180
		local v394 = v180
		local v395 = v180
		local v396, v397, v398 = Utility:AddNewRow(v180, "Shift Lock Switch", "Selector", {
			"On",
			"Off"
		}, n7)

		v393.ShiftLockFrame = v396
		v394.ShiftLockLabel = v397
		v395.ShiftLockMode = v398
		v180.ShiftLockFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ShiftLockFrame
		t10[v180.ShiftLockFrame] = true
		v180.ShiftLockOverrideText = Create("TextLabel")({
			Name = "ShiftLockOverrideLabel",
			Text = "Set by Developer",
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = 2,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			Size = if not v54 then UDim2.new(0, 200, 1, 0) else UDim2.new(0.6, 0, 1, 0),
			Position = if not v54 then UDim2.new(1, -350, 0, 0) else UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = if not v54 then nil else Vector2.new(1, 0.5),
			Parent = v180.ShiftLockFrame
		})
		v180.ShiftLockMode.IndexChanged:connect(function(p24) -- line: 1241
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v810 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v810 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			end

			if p24 == 1 then
				GameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
			else
				GameSettings.ControlMode = Enum.ControlMode.Classic
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("shift_lock_enabled", v810, GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
			end

			reportSettingsForAnalytics()
		end)

		local function setShiftLockSelectorVisible(b1: boolean) -- line: 1263
			-- upvalues: LocalPlayer (copy), v180 (copy)
			local v812 = b1 and LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockMode then
				v180.ShiftLockMode.SelectorFrame.Visible = v812
				v180.ShiftLockMode:SetInteractable(v812)
			end
		end
		local function applyDevOverrideShiftLockSelector() -- line: 1271
			-- upvalues: LocalPlayer (copy), v180 (copy)
			local v813 = not LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockOverrideText then
				v180.ShiftLockOverrideText.Visible = v813

				local v814 = not v813 and LocalPlayer.DevEnableMouseLock

				if v180.ShiftLockMode then
					v180.ShiftLockMode.SelectorFrame.Visible = v814
					v180.ShiftLockMode:SetInteractable(v814)
				end
			end
		end
		local function updateShiftLockVisibility() -- line: 1279
			-- upvalues: UserInputService (copy), v180 (copy), LocalPlayer (copy)
			local v815 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v180.ShiftLockFrame then
				v180.ShiftLockFrame.Visible = v815
			end

			local v816 = not LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockOverrideText then
				v180.ShiftLockOverrideText.Visible = v816

				local v817 = not v816 and LocalPlayer.DevEnableMouseLock

				if v180.ShiftLockMode then
					v180.ShiftLockMode.SelectorFrame.Visible = v817
					v180.ShiftLockMode:SetInteractable(v817)
				end
			end
		end

		local v402 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

		if v180.ShiftLockFrame then
			v180.ShiftLockFrame.Visible = v402
		end

		local v403 = not LocalPlayer.DevEnableMouseLock

		if v180.ShiftLockOverrideText then
			v180.ShiftLockOverrideText.Visible = v403

			local v404 = not v403 and LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockMode then
				v180.ShiftLockMode.SelectorFrame.Visible = v404
				v180.ShiftLockMode:SetInteractable(v404)
			end
		end

		UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function() -- line: 1289
			-- upvalues: UserInputService (copy), v180 (copy), LocalPlayer (copy)
			local v818 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v180.ShiftLockFrame then
				v180.ShiftLockFrame.Visible = v818
			end

			local v819 = not LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockOverrideText then
				v180.ShiftLockOverrideText.Visible = v819

				local v820 = not v819 and LocalPlayer.DevEnableMouseLock

				if v180.ShiftLockMode then
					v180.ShiftLockMode.SelectorFrame.Visible = v820
					v180.ShiftLockMode:SetInteractable(v820)
				end
			end
		end)
		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 1293
			-- upvalues: UserInputService (copy), v180 (copy), LocalPlayer (copy)
			local v821 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v180.ShiftLockFrame then
				v180.ShiftLockFrame.Visible = v821
			end

			local v822 = not LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockOverrideText then
				v180.ShiftLockOverrideText.Visible = v822

				local v823 = not v822 and LocalPlayer.DevEnableMouseLock

				if v180.ShiftLockMode then
					v180.ShiftLockMode.SelectorFrame.Visible = v823
					v180.ShiftLockMode:SetInteractable(v823)
				end
			end
		end)

		function cameraModeIsUserChoice() -- line: 1299
			-- upvalues: UserInputService (copy), LocalPlayer (copy)
			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				return LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
			end

			return LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end
		function setCameraModeVisible(p25) -- line: 1308
			-- upvalues: v180 (copy)
			if v180.CameraMode then
				v180.CameraMode.SelectorFrame.Visible = p25
				v180.CameraMode:SetInteractable(p25)
				v180.CameraModeOverrideText.Visible = not p25
			end
		end

		local v405 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
		local t14 = {}
		local t15 = {}

		local function updateCurrentCameraMovementIndex(p26) -- line: 1322
			-- upvalues: t15 (ref), t14 (ref), UserInputService (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy)
			local u826 = nil

			if not pcall(function() -- line: 1324
				-- upvalues: u826 (ref), t15 (ref), t14 (ref), p26 (copy)
				u826 = t15[t14[p26]]
			end) or u826 == nil then
				return false
			end

			local TouchCameraMovementModeValue = nil
			local v828

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.TouchCameraMovementMode.Value
				end

				v828 = GameSettings.TouchCameraMovementMode.Value ~= u826
				GameSettings.TouchCameraMovementMode = u826
			else
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.ComputerCameraMovementMode.Value
				end

				v828 = GameSettings.ComputerCameraMovementMode.Value ~= u826
				GameSettings.ComputerCameraMovementMode = u826
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() and v828 then
				reportSettingsChangeForAnalytics("camera_mode", TouchCameraMovementModeValue, u826)
			end

			return v828
		end
		local function updateCameraMovementModes() -- line: 1358
			-- upvalues: v405 (copy), UserInputService (copy), t14 (ref), t15 (ref), t4 (copy), v180 (copy), GameSettings (copy), updateCurrentCameraMovementIndex (copy)
			local t16 = {}

			if v405 then
				t16 = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then v405:GetRegisteredComputerCameraMovementModes() else v405:GetRegisteredTouchCameraMovementModes()
			end

			t14 = {}
			t15 = {}

			if #t16 <= 0 then
				setCameraModeVisible(false)

				return
			end

			for i = 1, #t16 do
				local v831 = t16[i]
				local Name = v831.Name

				if Name == "Default" then
					Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t4.DEFAULT_CLASSIC else t4.DEFAULT_FOLLOW
				end

				t14[#t14 + 1] = Name
				t15[Name] = v831.Value
			end

			if v180.CameraMode then
				v180.CameraMode:UpdateOptions(t14)
			end

			local v833 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
			local v834 = if not v833 then GameSettings.ComputerCameraMovementMode.Value else GameSettings.TouchCameraMovementMode.Value

			if v834 > -1 then
				if v833 or GameSettings.ComputerCameraMovementMode ~= Enum.ComputerCameraMovementMode.CameraToggle then
					v834 += 1
				end

				updateCurrentCameraMovementIndex(v834)
				v180.CameraMode:SetSelectionIndex(v834)
			end

			setCameraModeVisible(cameraModeIsUserChoice())
		end

		local v410 = v180
		local v411 = v180
		local v412 = v180
		local v413, v414, v415 = Utility:AddNewRow(v180, "Camera Mode", "Selector", t14, 1)

		v410.CameraModeFrame = v413
		v411.CameraModeLabel = v414
		v412.CameraMode = v415
		v180.CameraModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraModeFrame
		t10[v180.CameraMode] = true
		v180.CameraModeOverrideText = Create("TextLabel")({
			Name = "CameraDevOverrideLabel",
			Text = "Set by Developer",
			BackgroundTransparency = 1,
			Visible = false,
			ZIndex = 2,
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			Size = UDim2.new(0.6, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Parent = v180.CameraModeFrame
		})

		if v405 then
			v405.TouchCameraMovementModeRegistered:connect(function(__) -- line: 1444
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.TouchEnabled then
					updateCameraMovementModes()
				end
			end)
			v405.ComputerCameraMovementModeRegistered:connect(function(__) -- line: 1450
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.MouseEnabled then
					updateCameraMovementModes()
				end
			end)
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1457
			-- upvalues: updateCameraMovementModes (copy)
			updateCameraMovementModes()
		end)

		local u416 = false

		v180.CameraMode.IndexChanged:connect(function(p29) -- line: 1462
			-- upvalues: updateCurrentCameraMovementIndex (copy), u416 (ref), reportSettingsForAnalytics (copy)
			if updateCurrentCameraMovementIndex(p29) then
				if u416 then
					reportSettingsForAnalytics()
				end

				u416 = true
			end
		end)
		updateCameraMovementModes()

		local u417 = false

		local function createVROption() -- line: 1478
			-- upvalues: u417 (ref), GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy)
			if not u417 then
				u417 = true

				local u838 = if not GameSettings.VREnabled then {
					"On (restart pending)",
					"Off"
				} else {
					"On",
					"Off (restart pending)"
				}
				local v839 = v180
				local v840 = v180
				local v841 = v180
				local v842, v843, v844 = Utility:AddNewRow(v180, "VR", "Selector", u838, not GameSettings.VREnabled and 2 or 1)

				v839.VREnabledFrame = v842
				v840.VREnabledLabel = v843
				v841.VREnabledSelector = v844
				v180.VREnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VREnabledFrame
				v180.VREnabledSelector.IndexChanged:connect(function(p30) -- line: 1493
					-- upvalues: GameSettings (copy), u838 (ref), reportSettingsChangeForAnalytics (copy)
					local t17 = {
						On = {
							Name = "On",
							Value = 1
						},
						Off = {
							Name = "Off",
							Value = 2
						}
					}
					local v1080 = p30 == t17.On.Value

					if v1080 ~= GameSettings.VREnabled then
						GameSettings.VREnabled = v1080

						local v1081 = u838[t17.On.Value]
						local v1082 = u838[p30]

						if v1082 == u838[t17.On.Value] then
							v1081 = u838[t17.Off.Value]
						end

						reportSettingsChangeForAnalytics("vr_mode", v1081, v1082)
					end
				end)
			end
		end
		local function onVREnabledChanged() -- line: 1512
			-- upvalues: VRService (copy), GameSettings (copy), createVROption (copy)
			if VRService.VREnabled then
				GameSettings.HasEverUsedVR = true
				createVROption()

				return
			end

			if GameSettings.HasEverUsedVR then
				createVROption()
			end
		end

		if GetFFlagAlwaysShowVRToggle() and getAppFeaturePolicies().getIsLinkedVRModeAvailable() then
			createVROption()
		else
			if VRService.VREnabled then
				GameSettings.HasEverUsedVR = true
				createVROption()
			elseif GameSettings.HasEverUsedVR then
				createVROption()
			end

			VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabledChanged)
		end

		local t18 = {}
		local t19 = {}
		local t20 = {}
		local t21 = {}

		local function u424(__: boolean) -- line: 1537
		end
		local function setMovementModeVisible(p31) -- line: 1541
			-- upvalues: v180 (copy), t18 (ref)
			if v180.MovementMode then
				local v847 = p31 and #t18 > 0

				v180.MovementMode.SelectorFrame.Visible = v847
				v180.MovementMode:SetInteractable(v847)
				v180.MovementModeOverrideText.Visible = not v847
			end
		end

		if p23 then
			local v426 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

			local function getDisplayName(p32) -- line: 1555
				-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v85 (copy)
				if p32 == "Default" then
					if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
						return (RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey))
					end

					return t6.DEFAULT_KEYBOARD
				end

				if p32 == "KeyboardMouse" then
					return "Keyboard + Mouse"
				end

				if p32 == "ClickToMove" then
					if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
						return t6.TAP_TO_MOVE
					end

					return t6.CLICK_TO_MOVE
				end

				if p32 == "DynamicThumbstick" then
					return "Dynamic Thumbstick"
				end

				if p32 == "Thumbstick" then
					p32 = v85
				end

				return p32
			end

			local v428 = v180
			local v429 = v180
			local v430 = v180
			local v431, v432, v433 = Utility:AddNewRow(v180, "Movement Mode", "Selector", {}, 1)

			v428.MovementModeFrame = v431
			v429.MovementModeLabel = v432
			v430.MovementMode = v433
			v180.MovementModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MovementModeFrame
			t10[v180.MovementMode] = true
			v180.MovementModeOverrideText = Create("TextLabel")({
				Name = "MovementDevOverrideLabel",
				Text = "Set by Developer",
				BackgroundTransparency = 1,
				Visible = false,
				ZIndex = 2,
				TextColor3 = Color3.new(1, 1, 1),
				Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
				FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
				Size = UDim2.new(0.6, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Parent = v180.MovementModeFrame
			})

			local function setMovementMode(p33) -- line: 1596
				-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy)
				local TouchMovementMode = nil

				if p33.EnumType == Enum.TouchMovementMode then
					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						TouchMovementMode = GameSettings.TouchMovementMode
					end

					GameSettings.TouchMovementMode = p33
				else
					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						TouchMovementMode = GameSettings.ComputerMovementMode
					end

					GameSettings.ComputerMovementMode = p33
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("movement_mode", TouchMovementMode, p33)
				end
			end

			function u424(b3: boolean) -- line: 1613
				-- upvalues: LocalPlayer (copy), v180 (copy), t18 (ref)
				local v852 = if not b3 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

				if v180.MovementMode then
					local v853 = v852 and #t18 > 0

					v180.MovementMode.SelectorFrame.Visible = v853
					v180.MovementMode:SetInteractable(v853)
					v180.MovementModeOverrideText.Visible = not v853
				end

				if v180.MovementModeOverrideText then
					v180.MovementModeOverrideText.Visible = not v852
				end
			end

			local function updateMovementModes() -- line: 1625
				-- upvalues: UserInputService (copy), v426 (copy), t18 (ref), t19 (ref), t20 (ref), t21 (ref), v180 (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v85 (copy), GameSettings (copy), setMovementMode (copy), u424 (ref)
				local v854 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

				if v426 then
					if v854 then
						t18 = v426:GetRegisteredTouchMovementModes()
					else
						t18 = v426:GetRegisteredComputerMovementModes()
					end
				end

				t19 = {}
				t20 = {}
				t21 = {}

				if #t18 <= 0 then
					if v180.MovementMode then
						v180.MovementMode.SelectorFrame.Visible = false
						v180.MovementMode:SetInteractable(false)
						v180.MovementModeOverrideText.Visible = true
					end

					return
				end

				if v180.MovementMode then
					local v855 = #t18 > 0

					v180.MovementMode.SelectorFrame.Visible = v855
					v180.MovementMode:SetInteractable(v855)
					v180.MovementModeOverrideText.Visible = not v855
				end

				for v856, v857 in t18 do
					t20[v856] = v857

					local v858 = t21
					local Name = v857.Name

					if Name == "Default" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.DEFAULT_KEYBOARD else RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
					elseif Name == "KeyboardMouse" then
						Name = "Keyboard + Mouse"
					elseif Name == "ClickToMove" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.CLICK_TO_MOVE else t6.TAP_TO_MOVE
					elseif Name == "DynamicThumbstick" then
						Name = "Dynamic Thumbstick"
					elseif Name == "Thumbstick" then
						Name = v85
					end

					v858[v856] = Name
					t19[v857] = v856
				end

				if v180.MovementMode then
					v180.MovementMode:UpdateOptions(t21)
				end

				local v860 = if not v854 then GameSettings.ComputerMovementMode else GameSettings.TouchMovementMode

				if v860 then
					setMovementMode(v860)
					v180.MovementMode:SetSelectionIndex(t19[v860])
				end

				u424(v854)
			end

			updateMovementModes()

			if v426 then
				v426.TouchMovementModeRegistered:connect(function(__) -- line: 1669
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.TouchEnabled then
						updateMovementModes()
					end
				end)
				v426.ComputerMovementModeRegistered:connect(function(__) -- line: 1675
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.MouseEnabled then
						updateMovementModes()
					end
				end)
			end

			UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1682
				-- upvalues: updateMovementModes (copy)
				updateMovementModes()
			end)
			v180.MovementMode.IndexChanged:connect(function(p36) -- line: 1686
				-- upvalues: setMovementMode (copy), t20 (ref), reportSettingsForAnalytics (copy)
				setMovementMode(t20[p36])
				reportSettingsForAnalytics()
			end)
		end

		local v436 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

		if not if not v436 then LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice else LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
			v180.CameraModeOverrideText.Visible = true
			setCameraModeVisible(false)
		else
			v180.CameraModeOverrideText.Visible = false
			setCameraModeVisible(true)
		end

		local v437 = if not v436 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

		if v180.MovementModeOverrideText then
			if not v437 then
				v180.MovementModeOverrideText.Visible = true

				if v180.MovementMode then
					v180.MovementMode.SelectorFrame.Visible = false
					v180.MovementMode:SetInteractable(false)
					v180.MovementModeOverrideText.Visible = true
				end
			else
				v180.MovementModeOverrideText.Visible = false

				if v180.MovementMode then
					local v438 = #t18 > 0

					v180.MovementMode.SelectorFrame.Visible = v438
					v180.MovementMode:SetInteractable(v438)
					v180.MovementModeOverrideText.Visible = not v438
				end
			end
		end

		local v439 = not LocalPlayer.DevEnableMouseLock

		if v180.ShiftLockOverrideText then
			v180.ShiftLockOverrideText.Visible = v439

			local v440 = not v439 and LocalPlayer.DevEnableMouseLock

			if v180.ShiftLockMode then
				v180.ShiftLockMode.SelectorFrame.Visible = v440
				v180.ShiftLockMode:SetInteractable(v440)
			end
		end

		local function updateUserSettingsMenu(p37) -- line: 1732
			-- upvalues: LocalPlayer (copy), v180 (copy), u424 (ref), t18 (ref)
			if p37 == "DevEnableMouseLock" then
				local v865 = not LocalPlayer.DevEnableMouseLock

				if v180.ShiftLockOverrideText then
					v180.ShiftLockOverrideText.Visible = v865

					local v866 = not v865 and LocalPlayer.DevEnableMouseLock

					if v180.ShiftLockMode then
						v180.ShiftLockMode.SelectorFrame.Visible = v866
						v180.ShiftLockMode:SetInteractable(v866)

						return
					end
				end
			else
				if p37 == "DevComputerCameraMode" then
					local v867 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice

					setCameraModeVisible(v867)
					v180.CameraModeOverrideText.Visible = not v867

					return
				end

				if p37 == "DevComputerMovementMode" then
					if u424 ~= nil then
						u424(false)

						return
					end

					local v868 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice

					if v180.MovementMode then
						local v869 = v868 and #t18 > 0

						v180.MovementMode.SelectorFrame.Visible = v869
						v180.MovementMode:SetInteractable(v869)
						v180.MovementModeOverrideText.Visible = not v869
					end

					if v180.MovementModeOverrideText then
						v180.MovementModeOverrideText.Visible = not v868

						return
					end
				elseif p37 == "DevTouchMovementMode" then
					if u424 ~= nil then
						u424(true)

						return
					end

					local v870 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

					if v180.MovementMode then
						local v871 = v870 and #t18 > 0

						v180.MovementMode.SelectorFrame.Visible = v871
						v180.MovementMode:SetInteractable(v871)
						v180.MovementModeOverrideText.Visible = not v871
					end

					if v180.MovementModeOverrideText then
						v180.MovementModeOverrideText.Visible = not v870

						return
					end
				elseif p37 == "DevTouchCameraMode" then
					local v872 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice

					setCameraModeVisible(v872)
					v180.CameraModeOverrideText.Visible = not v872
				end
			end
		end

		LocalPlayer.Changed:connect(function(p38) -- line: 1767
			-- upvalues: t3 (copy), updateUserSettingsMenu (copy), t2 (copy)
			if t3[p38] then
				updateUserSettingsMenu(p38)
			end

			if t2[p38] then
				updateUserSettingsMenu(p38)
			end
		end)
	end
	local function createFeedbackModeOptions() -- line: 1780
		-- upvalues: Url (copy), HttpService (copy), v143 (copy), v180 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v142 (copy), Utility (copy), v87 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v137 (copy), v125 (copy)
		local v442 = Url.ROLES_URL .. "v1/users/authenticated/roles"
		local v443 = HttpService:RequestInternal({
			Method = "GET",
			Url = v442
		})

		local function rolesCheckCallback(p39) -- line: 1787
			-- upvalues: v143 (copy), v180 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v142 (copy), Utility (copy), v87 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p39 then
				if not v143 and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v180.FeedbackEntryPointEnabled then
					return
				end

				local function onToggleFeedbackMode() -- line: 1799
					-- upvalues: v143 (copy), v180 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy)
					if v143 and (game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v180.FeedbackEntryPointEnabled) then
						return
					end

					v180.HubRef:PopMenu(false, true)

					if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
						SafetyService.IsCaptureModeForReport = false
					end

					if ExperienceStateCaptureService ~= nil then
						ExperienceStateCaptureService:ToggleCaptureMode()
					end

					reportSettingsChangeForAnalytics("translation_feedback", "", "pressed")
				end

				local v876, v877

				if v142 then
					v876, v877 = Utility:MakeStyledButton("toggleFeedbackModeButton", v87, UDim2.new(1, 0, 1, -20), onToggleFeedbackMode, v180)
					v876.Size = UDim2.new(0.6, 0, 0, 40)
					v876.Position = UDim2.new(0.4, 0, 0.5, 0)
					v876.AnchorPoint = Vector2.new(0, 0.5)
				else
					v876, v877 = Utility:MakeStyledButton("toggleFeedbackModeButton", v87, UDim2.new(0, 300, 1, -20), onToggleFeedbackMode, v180)
					v876.Size = UDim2.new(0, 300, 0, 30)
					v876.Position = UDim2.new(0.4, 0, 0.5, 0)
					v876.AnchorPoint = Vector2.new(0, 0.5)
				end

				v876.ZIndex = 2
				v876.Selectable = true
				v877.ZIndex = 2

				if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
					v180.toggleFeedbackModeButton = v876
					v180.toggleFeedbackModeText = v877
				end

				if v142 then
					Utility:AddNewRowObject(v180, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v876, nil, true).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton

					return
				end

				Utility:AddNewRowObject(v180, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v876).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
			end
		end

		if v137 then
			rolesCheckCallback(true)

			return
		end

		v443:Start(function(p40, p41) -- line: 1883
			-- upvalues: HttpService (copy), v125 (copy), v442 (copy), rolesCheckCallback (copy)
			local u880 = false
			local v881 = false
			local s2

			if not p40 then
				s2 = "Roles Api Request: Connection error"
			elseif p41.StatusCode == 401 then
				s2 = "Roles Api Request: Unauthorized"
			elseif p41.StatusCode < 200 or p41.StatusCode >= 400 then
				s2 = "Roles Api Status code: " .. p41.StatusCode
			else
				v881, s2 = pcall(function() -- line: 1895
					-- upvalues: HttpService (copy), p41 (copy), u880 (ref)
					local data = HttpService:JSONDecode(p41.Body)

					for __, v in pairs(data.roles) do
						if v == "Soothsayer" then
							u880 = true
						end
					end
				end)
			end

			if not v881 then
				v125:warning("Feedback Mode initialization api call failed with url: " .. v442 .. " and with error message: " .. s2)
			end

			rolesCheckCallback(u880)
		end)
	end
	local function createTranslationOptions() -- line: 1923
		-- upvalues: Players (copy), Url (copy), HttpService (copy), v125 (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), LocalPlayer (copy), reportSettingsChangeForAnalytics (copy), RunService (copy)
		local n8 = 1
		local n9 = 1
		local u447 = false
		local languageCode = nil
		local localeCode = nil
		local LocaleId = Players.LocalPlayer.LocaleId
		local languageCode2 = nil
		local u452 = nil
		local t22 = {}
		local t23 = {}
		local t24 = {}
		local t25 = {}
		local t26 = {}
		local v458 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))
		local v459 = HttpService:RequestInternal({
			Method = "GET",
			Url = v458
		})
		local v460 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
		local v461 = HttpService:RequestInternal({
			Method = "GET",
			Url = v460
		})
		local v462 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/supported-languages/games/%d/in-experience-language-selection", game.GameId)
		local v463 = HttpService:RequestInternal({
			Method = "GET",
			Url = v462
		})
		local v464 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
		local v465 = HttpService:RequestInternal({
			Method = "GET",
			Url = v464
		})

		local function userExperienceLanguageSettingsCallback(p42, p43) -- line: 1988
			-- upvalues: v125 (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t26 (copy), t24 (copy), languageCode (ref), t22 (copy), u452 (ref), t23 (copy), n8 (ref), n9 (ref), LocalPlayer (copy), localeCode (ref), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), u447 (ref), RunService (copy)
			if not p42 then
				if p43 == nil then
					p43 = "Execution path did not set earliest error to non-nil value."
				end

				v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p43)

				local v885 = v180
				local v886 = v180
				local v887 = v180
				local v888, v889, v890 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

				v885.LanguageSelectorFrame = v888
				v886.LanguageSelectorLabel = v889
				v887.LanguageSelectorMode = v890
				v180.LanguageSelectorMode:SetInteractable(false)
				v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

				return
			end

			local v891 = false

			table.insert(t26, t24[languageCode].languageName .. " (Original)")

			for __, v in pairs(t22) do
				if v == u452 then
					v891 = true
				end

				if v ~= languageCode then
					table.insert(t26, t24[v].languageName)
				end
			end

			if v891 == true then
				for k, v in pairs(t26) do
					if k ~= 1 and t23[v] == u452 then
						n8 = k
						n9 = k
					end
				end
			end

			local v896 = v180
			local v897 = v180
			local v898 = v180
			local v899, v900, v901 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", t26, n8)

			v896.LanguageSelectorFrame = v899
			v897.LanguageSelectorLabel = v900
			v898.LanguageSelectorMode = v901
			v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

			if n8 == 1 then
				LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
			else
				local v902 = t23[t26[n8]]

				LocalPlayer:SetExperienceSettingsLocaleId(t24[v902].localeCode)
			end

			v180.LanguageSelectorMode.CurrentLanguage = v180.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

			local function toggleTranslation(p44) -- line: 2068
				-- upvalues: v180 (copy), t24 (copy), languageCode (ref), t23 (copy), t26 (copy), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), n9 (ref), LocalPlayer (copy), localeCode (ref), v125 (copy), u447 (ref), RunService (copy)
				v180.LanguageSelectorMode:SetInteractable(false)

				local v1087 = if p44 ~= 1 then t24[t23[t26[p44]]].id else t24[languageCode].id
				local CurrentLanguage = v180.LanguageSelectorMode.CurrentLanguage
				local v1089 = t26[p44]

				if CurrentLanguage ~= v1089 then
					v180.LanguageSelectorMode.CurrentLanguage = v1089
					reportSettingsChangeForAnalytics("experience_language", CurrentLanguage, v1089)
				end

				local t27 = {
					settingValue = {
						settingType = "LanguageFamily",
						settingTargetId = v1087
					}
				}
				local v1091 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
				local v1092 = HttpService:RequestInternal({
					Method = "POST",
					Url = v1091,
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode(t27)
				})

				local function callback(p45, p46) -- line: 2115
					-- upvalues: n9 (ref), p44 (copy), LocalPlayer (copy), localeCode (ref), t23 (copy), t26 (copy), t24 (copy), v125 (copy), u447 (ref), v180 (copy)
					if p45 then
						n9 = p44

						if p44 == 1 then
							LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
						else
							local v1179 = t23[t26[p44]]

							LocalPlayer:SetExperienceSettingsLocaleId(t24[v1179].localeCode)
						end
					else
						v125:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p46)
						u447 = true
						v180.LanguageSelectorMode:SetSelectionIndex(n9)
					end

					v180.LanguageSelectorMode:SetInteractable(true)
				end

				if RunService:IsStudio() then
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1094 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1094].localeCode)
					end

					v180.LanguageSelectorMode:SetInteractable(true)

					return
				end

				if u447 then
					u447 = false
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1095 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1095].localeCode)
					end

					v180.LanguageSelectorMode:SetInteractable(true)

					return
				end

				v1092:Start(function(p47, p48) -- line: 2158
					-- upvalues: v125 (copy), v1091 (copy), callback (copy)
					local v1182 = false
					local s3 = nil

					if not p47 then
						s3 = "User Experience Language Settings Update Request: Connection error"
					elseif p48.StatusCode == 401 then
						s3 = "User Experience Language Settings Update Request: Unauthorized"
					elseif p48.StatusCode < 200 or p48.StatusCode >= 400 then
						s3 = "User Experience Language Settings Update Request Status Code: " .. p48.StatusCode
					else
						v125:info("User Experience Language Settings Update Request succeeded with code: " .. p48.StatusCode)
						v1182 = true
					end

					if not v1182 then
						v125:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. v1091 .. " with error message: " .. s3)
					end

					callback(v1182, s3)
				end)
			end

			v180.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
		end
		local function experienceSupportedLanguagesCallback(p49, p50) -- line: 2193
			-- upvalues: v465 (copy), HttpService (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v125 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p49 then
				v465:Start(function(p51, p52) -- line: 2195
					-- upvalues: HttpService (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v125 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy)
					local v1098 = false
					local s4

					if not p51 then
						s4 = "User Experience Language Setting Request: Connection error"
					elseif p52.StatusCode == 401 then
						s4 = "User Experience Language Setting Request: Unauthorized"
					elseif p52.StatusCode < 200 or p52.StatusCode >= 400 then
						s4 = "User Experience Language Setting Request Status code: " .. p52.StatusCode
					else
						v1098, s4 = pcall(function() -- line: 2206
							-- upvalues: HttpService (copy), p52 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
							local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p52.Body).userUniverseLocalizationSettingValue

							if userUniverseLocalizationSettingValue == nil then
								u452 = languageCode2

								return
							end

							if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
								if userUniverseLocalizationSettingValue.settingTargetId == 1 then
									u452 = languageCode
								else
									u452 = languageCode2
								end
							end

							if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
								if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
									u452 = languageCode2

									return
								end

								u452 = t25[userUniverseLocalizationSettingValue.settingTargetId]
							end
						end)
					end

					if not v1098 then
						v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s4)
					end

					userExperienceLanguageSettingsCallback(v1098, s4)
				end)

				return
			end

			if p50 == nil then
				p50 = "Execution path did not set earliest error to non-nil value."
			end

			v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p50)

			local v906 = v180
			local v907 = v180
			local v908 = v180
			local v909, v910, v911 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

			v906.LanguageSelectorFrame = v909
			v907.LanguageSelectorLabel = v910
			v908.LanguageSelectorMode = v911
			v180.LanguageSelectorMode:SetInteractable(false)
			v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
		end
		local function experienceSourceLanguageCallback(p53, p54) -- line: 2255
			-- upvalues: v463 (copy), HttpService (copy), t22 (copy), v125 (copy), v462 (copy), v465 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p53 then
				v463:Start(function(p55, p56) -- line: 2257
					-- upvalues: HttpService (copy), t22 (copy), v125 (copy), v462 (copy), p54 (ref), p53 (copy), v465 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1102 = false
					local s5

					if not p55 then
						s5 = "Experience Supported Language Request: Connection error"
					elseif p56.StatusCode == 401 then
						s5 = "Experience Supported Language Request: Unauthorized"
					elseif p56.StatusCode < 200 or p56.StatusCode >= 400 then
						s5 = "Experience Supported Language Request Status code: " .. p56.StatusCode
					else
						v1102, s5 = pcall(function() -- line: 2267
							-- upvalues: HttpService (copy), p56 (copy), t22 (copy)
							local data = HttpService:JSONDecode(p56.Body)

							for k, v in pairs(data.data) do
								t22[k] = v.languageCode
							end
						end)
					end

					if not v1102 then
						v125:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v462 .. " with error message: " .. s5)
					end

					if p54 == nil then
						p54 = s5
					end

					local v1104 = v1102 and p53
					local v1105 = p54

					if v1104 then
						v465:Start(function(p57, p58) -- line: 2195
							-- upvalues: HttpService (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v125 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy)
							local v1190 = false
							local s6

							if not p57 then
								s6 = "User Experience Language Setting Request: Connection error"
							elseif p58.StatusCode == 401 then
								s6 = "User Experience Language Setting Request: Unauthorized"
							elseif p58.StatusCode < 200 or p58.StatusCode >= 400 then
								s6 = "User Experience Language Setting Request Status code: " .. p58.StatusCode
							else
								v1190, s6 = pcall(function() -- line: 2206
									-- upvalues: HttpService (copy), p58 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
									local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p58.Body).userUniverseLocalizationSettingValue

									if userUniverseLocalizationSettingValue == nil then
										u452 = languageCode2

										return
									end

									if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
										if userUniverseLocalizationSettingValue.settingTargetId == 1 then
											u452 = languageCode
										else
											u452 = languageCode2
										end
									end

									if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
										if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
											u452 = languageCode2

											return
										end

										u452 = t25[userUniverseLocalizationSettingValue.settingTargetId]
									end
								end)
							end

							if not v1190 then
								v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s6)
							end

							userExperienceLanguageSettingsCallback(v1190, s6)
						end)

						return
					end

					if v1105 == nil then
						v1105 = "Execution path did not set earliest error to non-nil value."
					end

					v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1105)

					local v1106 = v180
					local v1107 = v180
					local v1108 = v180
					local v1109, v1110, v1111 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

					v1106.LanguageSelectorFrame = v1109
					v1107.LanguageSelectorLabel = v1110
					v1108.LanguageSelectorMode = v1111
					v180.LanguageSelectorMode:SetInteractable(false)
					v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
				end)
			else
				local v915 = p54

				if v915 == nil then
					v915 = "Execution path did not set earliest error to non-nil value."
				end

				v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v915)

				local v916 = v180
				local v917 = v180
				local v918 = v180
				local v919, v920, v921 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

				v916.LanguageSelectorFrame = v919
				v917.LanguageSelectorLabel = v920
				v918.LanguageSelectorMode = v921
				v180.LanguageSelectorMode:SetInteractable(false)
				v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end
		local function localeCodeToLanguageCodeMappingCallback(p59, p60) -- line: 2296
			-- upvalues: v461 (copy), HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v125 (copy), v460 (copy), v463 (copy), t22 (copy), v462 (copy), v465 (copy), u452 (ref), languageCode2 (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p59 then
				v461:Start(function(p61, p62) -- line: 2298
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v125 (copy), v460 (copy), p60 (ref), p59 (copy), v463 (copy), t22 (copy), v462 (copy), v465 (copy), u452 (ref), languageCode2 (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1114 = false
					local s7

					if not p61 then
						s7 = "Experience Source Language Request: Connection error"
					elseif p62.StatusCode == 401 then
						s7 = "Experience Source Language Request: Unauthorized"
					elseif p62.StatusCode < 200 or p62.StatusCode >= 400 then
						s7 = "Experience Source Language Status code: " .. p62.StatusCode
					else
						v1114, s7 = pcall(function() -- line: 2309
							-- upvalues: HttpService (copy), p62 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p62.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1114 then
						v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v460 .. " with error message: " .. s7)
					end

					if p60 == nil then
						p60 = s7
					end

					local v1116 = v1114 and p59
					local u1117 = p60

					if v1116 then
						v463:Start(function(p63, p64) -- line: 2257
							-- upvalues: HttpService (copy), t22 (copy), v125 (copy), v462 (copy), u1117 (ref), v1116 (copy), v465 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1194 = false
							local s8

							if not p63 then
								s8 = "Experience Supported Language Request: Connection error"
							elseif p64.StatusCode == 401 then
								s8 = "Experience Supported Language Request: Unauthorized"
							elseif p64.StatusCode < 200 or p64.StatusCode >= 400 then
								s8 = "Experience Supported Language Request Status code: " .. p64.StatusCode
							else
								v1194, s8 = pcall(function() -- line: 2267
									-- upvalues: HttpService (copy), p64 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p64.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1194 then
								v125:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v462 .. " with error message: " .. s8)
							end

							if u1117 == nil then
								u1117 = s8
							end

							local v1196 = v1194 and v1116
							local v1197 = u1117

							if v1196 then
								v465:Start(function(p65, p66) -- line: 2195
									-- upvalues: HttpService (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v125 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1234 = false
									local s9

									if not p65 then
										s9 = "User Experience Language Setting Request: Connection error"
									elseif p66.StatusCode == 401 then
										s9 = "User Experience Language Setting Request: Unauthorized"
									elseif p66.StatusCode < 200 or p66.StatusCode >= 400 then
										s9 = "User Experience Language Setting Request Status code: " .. p66.StatusCode
									else
										v1234, s9 = pcall(function() -- line: 2206
											-- upvalues: HttpService (copy), p66 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p66.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u452 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u452 = languageCode
												else
													u452 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u452 = languageCode2

													return
												end

												u452 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1234 then
										v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s9)
									end

									userExperienceLanguageSettingsCallback(v1234, s9)
								end)

								return
							end

							if v1197 == nil then
								v1197 = "Execution path did not set earliest error to non-nil value."
							end

							v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1197)

							local v1198 = v180
							local v1199 = v180
							local v1200 = v180
							local v1201, v1202, v1203 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

							v1198.LanguageSelectorFrame = v1201
							v1199.LanguageSelectorLabel = v1202
							v1200.LanguageSelectorMode = v1203
							v180.LanguageSelectorMode:SetInteractable(false)
							v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1118 = u1117

						if v1118 == nil then
							v1118 = "Execution path did not set earliest error to non-nil value."
						end

						v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1118)

						local v1119 = v180
						local v1120 = v180
						local v1121 = v180
						local v1122, v1123, v1124 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

						v1119.LanguageSelectorFrame = v1122
						v1120.LanguageSelectorLabel = v1123
						v1121.LanguageSelectorMode = v1124
						v180.LanguageSelectorMode:SetInteractable(false)
						v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v925 = p60

				if v925 == nil then
					v925 = "Execution path did not set earliest error to non-nil value."
				end

				v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v925)

				local v926 = v180
				local v927 = v180
				local v928 = v180
				local v929, v930, v931 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

				v926.LanguageSelectorFrame = v929
				v927.LanguageSelectorLabel = v930
				v928.LanguageSelectorMode = v931
				v180.LanguageSelectorMode:SetInteractable(false)
				v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		v459:Start(function(p67, p68) -- line: 2340
			-- upvalues: HttpService (copy), t24 (copy), t25 (copy), t23 (copy), LocaleId (copy), languageCode2 (ref), v125 (copy), v458 (copy), v461 (copy), languageCode (ref), localeCode (ref), v460 (copy), v463 (copy), t22 (copy), v462 (copy), v465 (copy), u452 (ref), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local v934 = false
			local s10

			if not p67 then
				s10 = "Locale Code to Language Code Mapping Request: Connection error"
			elseif p68.StatusCode == 401 then
				s10 = "Locale Code to Language Code Mapping Request: Unauthorized"
			elseif p68.StatusCode < 200 or p68.StatusCode >= 400 then
				s10 = "Locale Code to Language Code Mapping Request Status code: " .. p68.StatusCode
			else
				v934, s10 = pcall(function() -- line: 2351
					-- upvalues: HttpService (copy), p68 (copy), t24 (copy), t25 (copy), t23 (copy), LocaleId (copy), languageCode2 (ref)
					local data = HttpService:JSONDecode(p68.Body)

					for __, v in pairs(data.data) do
						local languageCode3 = v.locale.language.languageCode
						local locale = v.locale.locale
						local name = v.locale.language.name
						local id = v.locale.language.id

						t24[languageCode3] = {
							localeCode = locale,
							languageName = name,
							id = id
						}
						t25[id] = languageCode3
						t23[name] = languageCode3

						if v.locale.locale == LocaleId:gsub("-", "_") then
							languageCode2 = v.locale.language.languageCode
						end
					end
				end)
			end

			if not v934 then
				v125:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v458 .. " with error message: " .. s10)
			end

			local v936 = v934
			local u937 = s10

			if v936 then
				v461:Start(function(p69, p70) -- line: 2298
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v125 (copy), v460 (copy), u937 (ref), v936 (copy), v463 (copy), t22 (copy), v462 (copy), v465 (copy), u452 (ref), languageCode2 (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1134 = false
					local s11

					if not p69 then
						s11 = "Experience Source Language Request: Connection error"
					elseif p70.StatusCode == 401 then
						s11 = "Experience Source Language Request: Unauthorized"
					elseif p70.StatusCode < 200 or p70.StatusCode >= 400 then
						s11 = "Experience Source Language Status code: " .. p70.StatusCode
					else
						v1134, s11 = pcall(function() -- line: 2309
							-- upvalues: HttpService (copy), p70 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p70.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1134 then
						v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v460 .. " with error message: " .. s11)
					end

					if u937 == nil then
						u937 = s11
					end

					local v1136 = v1134 and v936
					local u1137 = u937

					if v1136 then
						v463:Start(function(p71, p72) -- line: 2257
							-- upvalues: HttpService (copy), t22 (copy), v125 (copy), v462 (copy), u1137 (ref), v1136 (copy), v465 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy), v180 (copy), Utility (copy), RobloxTranslator (copy), v86 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1206 = false
							local s12

							if not p71 then
								s12 = "Experience Supported Language Request: Connection error"
							elseif p72.StatusCode == 401 then
								s12 = "Experience Supported Language Request: Unauthorized"
							elseif p72.StatusCode < 200 or p72.StatusCode >= 400 then
								s12 = "Experience Supported Language Request Status code: " .. p72.StatusCode
							else
								v1206, s12 = pcall(function() -- line: 2267
									-- upvalues: HttpService (copy), p72 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p72.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1206 then
								v125:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v462 .. " with error message: " .. s12)
							end

							if u1137 == nil then
								u1137 = s12
							end

							local v1208 = v1206 and v1136
							local v1209 = u1137

							if v1208 then
								v465:Start(function(p73, p74) -- line: 2195
									-- upvalues: HttpService (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v125 (copy), v464 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1241 = false
									local s13

									if not p73 then
										s13 = "User Experience Language Setting Request: Connection error"
									elseif p74.StatusCode == 401 then
										s13 = "User Experience Language Setting Request: Unauthorized"
									elseif p74.StatusCode < 200 or p74.StatusCode >= 400 then
										s13 = "User Experience Language Setting Request Status code: " .. p74.StatusCode
									else
										v1241, s13 = pcall(function() -- line: 2206
											-- upvalues: HttpService (copy), p74 (copy), u452 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p74.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u452 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u452 = languageCode
												else
													u452 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u452 = languageCode2

													return
												end

												u452 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1241 then
										v125:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s13)
									end

									userExperienceLanguageSettingsCallback(v1241, s13)
								end)

								return
							end

							if v1209 == nil then
								v1209 = "Execution path did not set earliest error to non-nil value."
							end

							v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1209)

							local v1210 = v180
							local v1211 = v180
							local v1212 = v180
							local v1213, v1214, v1215 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

							v1210.LanguageSelectorFrame = v1213
							v1211.LanguageSelectorLabel = v1214
							v1212.LanguageSelectorMode = v1215
							v180.LanguageSelectorMode:SetInteractable(false)
							v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1138 = u1137

						if v1138 == nil then
							v1138 = "Execution path did not set earliest error to non-nil value."
						end

						v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1138)

						local v1139 = v180
						local v1140 = v180
						local v1141 = v180
						local v1142, v1143, v1144 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

						v1139.LanguageSelectorFrame = v1142
						v1140.LanguageSelectorLabel = v1143
						v1141.LanguageSelectorMode = v1144
						v180.LanguageSelectorMode:SetInteractable(false)
						v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v938 = u937

				if v938 == nil then
					v938 = "Execution path did not set earliest error to non-nil value."
				end

				v125:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v938)

				local v939 = v180
				local v940 = v180
				local v941 = v180
				local v942, v943, v944 = Utility:AddNewRow(v180, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v86 }, 1)

				v939.LanguageSelectorFrame = v942
				v940.LanguageSelectorLabel = v943
				v941.LanguageSelectorMode = v944
				v180.LanguageSelectorMode:SetInteractable(false)
				v180.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end)
	end
	local function getChatTranslationLayerData(p75) -- line: 2390
		-- upvalues: GetFFlagChatTranslationWaitForIXP (copy), IXPServiceWrapper (copy), GetFFlagChatTranslationNewDefaults (copy)
		local t28 = {
			ChatTranslationEnabled = false,
			ChatTranslationToggleEnabled = false
		}

		if not p75 or p75 == "" then
			return t28
		end

		if p75 == "override" then
			t28.ChatTranslationEnabled = true

			return t28
		end

		if GetFFlagChatTranslationWaitForIXP() then
			IXPServiceWrapper:WaitForInitialization()
		end

		local ok, result = pcall(function() -- line: 2412
			-- upvalues: IXPServiceWrapper (copy), p75 (copy)
			return IXPServiceWrapper:GetLayerData(p75)
		end)

		if ok then
			if GetFFlagChatTranslationNewDefaults() then
				t28.ChatTranslationEnabled = result.ChatTranslationEnabled or true
				t28.ChatTranslationToggleEnabled = result.ChatTranslationToggleEnabled or false

				return t28
			end

			t28.ChatTranslationEnabled = result.chatTranslationEnabled or false
			t28.ChatTranslationToggleEnabled = result.chatTranslationToggleEnabled or false
		end

		return t28
	end
	local function createVolumeOptions() -- line: 2430
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v474 = math.floor(GameSettings.MasterVolume * 10)
		local v475 = v180
		local v476 = v180
		local v477 = v180
		local v478, v479, v480 = Utility:AddNewRow(v180, "Volume", "Slider", 10, v474)

		v475.VolumeFrame = v478
		v476.VolumeLabel = v479
		v477.VolumeSlider = v480
		v180.VolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VolumeFrame

		local Sound = Instance.new("Sound", game:GetService("CoreGui").RobloxGui.Sounds)

		Sound.Name = "VolumeChangeSound"
		Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
		v180.VolumeSlider.ValueChanged:connect(function(p76) -- line: 2441
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), Sound (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v946 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v946 = math.floor(GameSettings.MasterVolume * 10 + 0.5)
			end

			local v947 = p76 / 10

			Sound.Volume = v947
			Sound:Play()
			GameSettings.MasterVolume = v947

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("volume", v946, (math.floor(GameSettings.MasterVolume * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPartyVoiceVolumeOptions() -- line: 2459
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v482 = math.floor(GameSettings.PartyVoiceVolume * 10)
		local v483 = v180
		local v484 = v180
		local v485 = v180
		local v486, v487, v488 = Utility:AddNewRow(v180, "Party Voice Volume", "Slider", 10, v482)

		v483.PartyVoiceVolumeFrame = v486
		v484.PartyVoiceVolumeLabel = v487
		v485.PartyVoiceVolumeSlider = v488
		v180.PartyVoiceVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PartyVoiceVolumeFrame

		if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			v180.PartyVoiceVolumeFrame.Visible = default4.hasExperienceStarted
			default4.ExperienceJoined.Event:Connect(function() -- line: 2468
				-- upvalues: v180 (copy)
				v180.PartyVoiceVolumeFrame.Visible = true
			end)
			default4.ExperienceLeft.Event:Connect(function() -- line: 2471
				-- upvalues: v180 (copy)
				v180.PartyVoiceVolumeFrame.Visible = false
			end)
		end

		v180.PartyVoiceVolumeSlider.ValueChanged:connect(function(p77) -- line: 2476
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v482 (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v949 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v949 = v482 == nil and 0 or math.floor(v482 * 10 + 0.5)
			end

			GameSettings.PartyVoiceVolume = p77 / 10

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("party_voice_volume", v949, (math.floor(p77 * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createVoiceChatVolumeOptions() -- line: 2492
		-- upvalues: GameSettings (copy), u24 (ref), v125 (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v68 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v489 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
		local ok, result = pcall(function() -- line: 2494
			-- upvalues: u24 (ref)
			return u24:Format("CoreScripts.InGameMenu.GameSettings.VoiceChatVolume")
		end)

		if not ok then
			result = "Voice Chat Volume"
			v125:debug("[GameSettings] createVoiceChatVolumeOptions failed to get translation for Voice Chat Volume label, using placeholder text instead")
		end

		local v492 = v180
		local v493 = v180
		local v494 = v180
		local v495, v496, v497 = Utility:AddNewRow(v180, result, "Slider", 10, v489)

		v492.VoiceChatVolumeFrame = v495
		v493.VoiceChatVolumeLabel = v496
		v494.VoiceChatVolumeSlider = v497
		v180.VoiceChatVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceChatVolumeFrame
		v180.VoiceChatVolumeFrame.Visible = false

		if v68 then
			local function updateVoiceChatVolumeSliderInteractable(n10: number?) -- line: 2509
				-- upvalues: GameSettings (copy), v180 (copy)
				if if n10 == nil then GameSettings.MasterVolume == 0 else n10 == 0 then
					v180.VoiceChatVolumeSlider:SetZIndex(1)
					v180.VoiceChatVolumeLabel.ZIndex = 1
					v180.VoiceChatVolumeSlider:SetInteractable(false)

					return
				end

				v180.VoiceChatVolumeSlider:SetZIndex(2)
				v180.VoiceChatVolumeLabel.ZIndex = 2
				v180.VoiceChatVolumeSlider:SetInteractable(true)
			end

			updateVoiceChatVolumeSliderInteractable()
			v180.VolumeSlider.ValueChanged:connect(updateVoiceChatVolumeSliderInteractable)
		end

		v180.VoiceChatVolumeSlider.ValueChanged:connect(function(p78) -- line: 2529
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v180 (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v952 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v952 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
			end

			GameSettings.VoiceChatVolume = p78 / 5

			if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and v180.maxVoiceChatVolumeDuringSession ~= nil then
				v180.maxVoiceChatVolumeDuringSession = math.max(v180.maxVoiceChatVolumeDuringSession, GameSettings.VoiceChatVolume)
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("voice_chat_volume", v952, (math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createHapticsToggle() -- line: 2554
		-- upvalues: GameSettings (copy), getAppFeaturePolicies (copy), u24 (ref), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v499 = GameSettings.HapticStrength ~= 0 and 2 or 1
		local v500 = not getAppFeaturePolicies().getShouldUseVibrationInsteadOfHaptics() and "Haptics" or u24:Format("CoreScripts.InGameMenu.Vibration")
		local v501 = v180
		local v502 = v180
		local v503, v504, v505 = Utility:AddNewRow(v180, v500, "Selector", {
			"Off",
			"On"
		}, v499)

		v501.HapticsFrame = v503
		_ = v504
		v502.HapticsSelector = v505
		v180.HapticsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.HapticsFrame
		v180.HapticsSelector.IndexChanged:connect(function(p79) -- line: 2563
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local HapticStrength = GameSettings.HapticStrength

			if p79 == 2 then
				GameSettings.HapticStrength = 1
			else
				GameSettings.HapticStrength = 0
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("haptics_toggle", HapticStrength, GameSettings.HapticStrength)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createCameraInvertedOptions() -- line: 2579
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n11 = 1

		if pcall(function() -- line: 2581
			-- upvalues: GameSettings (copy), n11 (ref)
			if GameSettings.CameraYInverted == true then
				n11 = 2
			end
		end) == false then
			return
		end

		local v507 = v180
		local v508 = v180
		local v509, v510, v511 = Utility:AddNewRow(v180, "Camera Inverted", "Selector", {
			"Off",
			"On"
		}, n11)

		v507.CameraInvertedFrame = v509
		_ = v510
		v508.CameraInvertedSelector = v511
		v180.CameraInvertedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraInvertedFrame
		t10[v180.CameraInvertedFrame] = true
		v180.CameraInvertedSelector.IndexChanged:connect(function(p80) -- line: 2596
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local CameraYInverted = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				CameraYInverted = GameSettings.CameraYInverted
			end

			if p80 == 2 then
				GameSettings.CameraYInverted = true
			else
				GameSettings.CameraYInverted = false
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("camera_y_inverted", CameraYInverted, GameSettings.CameraYInverted)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function setCameraSensitivity(p81) -- line: 2615
		-- upvalues: UserInputService (copy), GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local s14 = nil
		local GamepadCameraSensitivity = nil

		if UserInputService.GamepadEnabled and GameSettings.IsUsingGamepadCameraSensitivity then
			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				s14 = "gamepad"
				GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity
			end

			GameSettings.GamepadCameraSensitivity = p81
		end

		if UserInputService.MouseEnabled then
			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				s14 = "mouse"
				GamepadCameraSensitivity = GameSettings.MouseSensitivityFirstPerson.X
			end

			local vector2 = Vector2.new(p81, p81)

			GameSettings.MouseSensitivityFirstPerson = vector2
			GameSettings.MouseSensitivityThirdPerson = vector2
		end

		if GetFFlagEnableExplicitSettingsChangeAnalytics() and typeof(GamepadCameraSensitivity) == "number" and typeof(p81) == "number" then
			reportSettingsChangeForAnalytics("camera_sensitivity", tonumber(string.format("%.2f", GamepadCameraSensitivity)), tonumber(string.format("%.2f", p81)), {
				sensitivity_type = s14
			})
		end

		reportSettingsForAnalytics()
	end
	local function createMouseOptions() -- line: 2653
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), setCameraSensitivity (copy)
		local function translateEngineMouseSensitivityToGui(p82) -- line: 2658
			local v958 = p82 <= 1 and math.floor((p82 - 0.2) / 0.16 + 0.5) or math.floor((p82 + 2) / 0.6 + 0.5)

			if p82 <= 0.2 then
				return 0
			end

			return v958
		end
		local function translateGuiMouseSensitivityToEngine(p83) -- line: 2666
			local v960 = p83 <= 5 and 0.16 * p83 + 0.2 or 0.6 * p83 - 2

			if v960 <= 0.2 then
				return 0.2
			end

			return v960
		end

		local MouseSensitivity = GameSettings.MouseSensitivity
		local v519 = MouseSensitivity <= 1 and math.floor((MouseSensitivity - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivity + 2) / 0.6 + 0.5)
		local v520 = if not (MouseSensitivity <= 0.2) then v519 else 0
		local u521 = true

		tostring(GameSettings.MouseSensitivityFirstPerson.X)

		local v522 = v180
		local v523 = v180
		local v524 = v180
		local v525, v526, v527 = Utility:AddNewRow(v180, "Camera Sensitivity", "Slider", 10, v520)

		v522.MouseAdvancedFrame = v525
		v523.MouseAdvancedLabel = v526
		v524.MouseAdvancedEntry = v527
		v180.MouseAdvancedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MouseAdvancedFrame
		t10[v180.MouseAdvancedFrame] = true
		v180.MouseAdvancedEntry.SliderFrame.Size = UDim2.new(v180.MouseAdvancedEntry.SliderFrame.Size.X.Scale, v180.MouseAdvancedEntry.SliderFrame.Size.X.Offset - 60 - 20, v180.MouseAdvancedEntry.SliderFrame.Size.Y.Scale, v180.MouseAdvancedEntry.SliderFrame.Size.Y.Offset - 6)
		v180.MouseAdvancedEntry.SliderFrame.Position = UDim2.new(v180.MouseAdvancedEntry.SliderFrame.Position.X.Scale, v180.MouseAdvancedEntry.SliderFrame.Position.X.Offset - 60 - 20, v180.MouseAdvancedEntry.SliderFrame.Position.Y.Scale, v180.MouseAdvancedEntry.SliderFrame.Position.Y.Offset)
		v180.MouseAdvancedLabel.ZIndex = 2
		v180.MouseAdvancedEntry:SetInteractable(true)

		local v528 = Create("TextBox")({
			Name = "CameraSensitivityTextBox",
			ZIndex = 3,
			Selectable = false,
			BorderSizePixel = 0,
			TextColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0.8, 0.8, 0.8),
			BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
			Font = Theme.font(Enum.Font.SourceSans),
			TextSize = Theme.textSize(18),
			Size = UDim2.new(0, 60, 0.8, 0),
			Position = UDim2.new(1, 10, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Parent = v180.MouseAdvancedEntry.SliderFrame
		})

		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = v528
		})

		local function setMouseSensitivityText(p84) -- line: 2725
			-- upvalues: v528 (copy)
			local v962 = math.floor(p84 * 1000 + 0.5) / 1000

			v528.Text = tostring((tonumber((string.format("%.3f", v962)))))
		end

		local v530 = math.floor(GameSettings.MouseSensitivityFirstPerson.X * 1000 + 0.5) / 1000

		v528.Text = tostring((tonumber((string.format("%.3f", v530)))))

		local MouseAdvancedEntry = v180.MouseAdvancedEntry
		local MouseSensitivityFirstPersonX = GameSettings.MouseSensitivityFirstPerson.X
		local v533 = MouseSensitivityFirstPersonX <= 1 and math.floor((MouseSensitivityFirstPersonX - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivityFirstPersonX + 2) / 0.6 + 0.5)

		MouseAdvancedEntry:SetValue(if not (MouseSensitivityFirstPersonX <= 0.2) then v533 else 0)

		function clampMouseSensitivity(p85) -- line: 2740
			if p85 < 0 then
				p85 = -p85
			end

			if p85 > 100 then
				return 100
			end

			if p85 < 0.001 then
				p85 = 0.001
			end

			return p85
		end
		function setMouseSensitivity(p86, p87) -- line: 2758
			-- upvalues: u521 (ref), setCameraSensitivity (copy), v180 (copy), v528 (copy)
			if not u521 then
				return
			end

			setCameraSensitivity(p86)
			u521 = false

			if p87 ~= v180.MouseAdvancedEntry then
				local MouseAdvancedEntry2 = v180.MouseAdvancedEntry
				local v967 = p86 <= 1 and math.floor((p86 - 0.2) / 0.16 + 0.5) or math.floor((p86 + 2) / 0.6 + 0.5)

				MouseAdvancedEntry2:SetValue(if not (p86 <= 0.2) then v967 else 0)
			end

			local v968 = math.floor(p86 * 1000 + 0.5) / 1000

			v528.Text = tostring((tonumber((string.format("%.3f", v968)))))
			u521 = true
		end

		v528.FocusLost:connect(function() -- line: 2776
			-- upvalues: v180 (copy), v528 (copy), GameSettings (copy)
			v180.MouseAdvancedEntry:SetInteractable(true)

			local num = tonumber((string.match(v528.Text, "([%d%.]+)")))

			if num then
				setMouseSensitivity(clampMouseSensitivity(num), v528)

				return
			end

			setMouseSensitivity(GameSettings.MouseSensitivityFirstPerson.X, v528)
		end)
		v528.Focused:connect(function() -- line: 2788
			-- upvalues: v180 (copy)
			v180.MouseAdvancedEntry:SetInteractable(false)
		end)
		v180.MouseAdvancedEntry.ValueChanged:connect(function(p88) -- line: 2792
			-- upvalues: v180 (copy)
			local v971 = clampMouseSensitivity(p88)
			local v972 = v971 <= 5 and 0.16 * v971 + 0.2 or 0.6 * v971 - 2
			local v973 = if not (v972 <= 0.2) then v972 else 0.2

			setMouseSensitivity(v973, v180.MouseAdvancedEntry)
		end)
	end
	local function createGamepadOptions() -- line: 2799
		-- upvalues: GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), setCameraSensitivity (copy)
		local function translateEngineGamepadSensitivityToGui(p89) -- line: 2804
			local v975 = p89 <= 1 and math.floor((p89 - 0.2) / 0.16 + 0.5) or math.floor((p89 + 2) / 0.6 + 0.5)

			if p89 <= 0.2 then
				return 0
			end

			return v975
		end
		local function translateGuiGamepadSensitivityToEngine(p90) -- line: 2811
			local v977 = p90 <= 5 and 0.16 * p90 + 0.2 or 0.6 * p90 - 2

			if v977 <= 0.2 then
				return 0.2
			end

			return v977
		end

		local GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity
		local v537 = GamepadCameraSensitivity <= 1 and math.floor((GamepadCameraSensitivity - 0.2) / 0.16 + 0.5) or math.floor((GamepadCameraSensitivity + 2) / 0.6 + 0.5)
		local v538 = if not (GamepadCameraSensitivity <= 0.2) then v537 else 0
		local v539 = v180
		local v540 = v180
		local v541 = v180
		local v542, v543, v544 = Utility:AddNewRow(v180, "Camera Sensitivity", "Slider", 10, v538)

		v539.GamepadSensitivityFrame = v542
		v540.GamepadSensitivityLabel = v543
		v541.GamepadSensitivitySlider = v544
		v180.GamepadSensitivityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GamepadSensitivityFrame
		v180.GamepadSensitivitySlider.ValueChanged:connect(function(p91) -- line: 2826
			-- upvalues: setCameraSensitivity (copy)
			local v979 = setCameraSensitivity
			local v980 = p91 <= 5 and 0.16 * p91 + 0.2 or 0.6 * p91 - 2

			v979(if not (v980 <= 0.2) then v980 else 0.2)
		end)
	end
	local function createOverscanOption() -- line: 2831
		-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy), Utility (copy), v180 (copy), Theme (copy), RunService (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v545, v546, v547 = Utility:MakeStyledButton("AdjustButton", "Adjust", UDim2.new(0, 300, 1, -20), function() -- line: 2832
			-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
			local Overscan = require(RobloxGui.Modules.Shell.Components.Overscan10ft.Overscan)
			local v983 = require(RobloxGui.Modules.Settings.Components.OverscanWrapper)(Overscan)
			local Roact = require(CorePackages.Packages.Roact)
			local u985 = nil
			local t29 = {
				onUnmount = function() -- line: 2843
					-- upvalues: u985 (ref), Roact (copy), ContextActionService (copy), SettingsHub (copy)
					if u985 then
						Roact.unmount(u985)
						ContextActionService:UnbindCoreAction("RbxStopOverscanMovement")
						SettingsHub:SetVisibility(true, true)
					end
				end,
				ImageVisible = false,
				BackgroundTransparency = 0.2
			}

			SettingsHub:SetVisibility(false, true)
			ContextActionService:BindCoreAction("RbxStopOverscanMovement", function() -- line: 2859
			end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

			local v987 = Roact.createElement(v983, t29)

			u985 = Roact.mount(v987, RobloxGui, (tostring(v983)))
		end, v180)

		v546.Font = Theme.font(Enum.Font.SourceSans)
		v545.Position = UDim2.new(1, -400, 0, 12)
		v545.Size = UDim2.new(0, 300, 0, 40)
		v545.Position = UDim2.new(1, -400, 0.5, 0)
		v545.AnchorPoint = Vector2.new(0, 0.5)

		if RunService:IsStudio() then
			v545.Selectable = false
			v545.Active = false
			v545.Enabled.Value = false
			v546.TextColor3 = Color3.fromRGB(100, 100, 100)
		end

		local v548 = Utility:AddNewRowObject(v180, "Safe Zone", v545)

		v548.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.OverscanAdjustButton
		v547(v548)
	end
	local function createDeveloperConsoleOption() -- line: 2898
		-- upvalues: reportSettingsChangeForAnalytics (copy), v140 (copy), Utility (copy), v180 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), RunService (copy), PlayerPermissionsModule (copy), Players (copy)
		local function makeDevConsoleOption() -- line: 2900
			-- upvalues: reportSettingsChangeForAnalytics (copy), v140 (copy), Utility (copy), v180 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local function onOpenDevConsole() -- line: 2901
				-- upvalues: reportSettingsChangeForAnalytics (copy)
				local DevConsoleMaster = require(script.Parent.Parent.Parent.DevConsoleMaster)

				if DevConsoleMaster then
					DevConsoleMaster:SetVisibility(true)

					local SettingsHub = require(script.Parent.Parent.SettingsHub)

					if SettingsHub then
						SettingsHub:SetVisibility(false)
					end

					reportSettingsChangeForAnalytics("dev_console", "", "pressed")
				end
			end

			if v140 then
				local v989, v990, v991 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(1, 0, 1, -20), onOpenDevConsole, v180)

				v990.Font = Theme.font(Enum.Font.SourceSans)
				v989.Size = UDim2.new(0.6, -10, 0, 35)
				v989.Position = UDim2.new(0.4, 10, 0.5, 0)
				v989.AnchorPoint = Vector2.new(0, 0.5)

				local v992 = Utility:AddNewRowObject(v180, "Developer Console", v989, nil, true)

				v992.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v991(v992)

				return
			end

			local v993, v994, v995 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(0, 300, 1, -20), onOpenDevConsole, v180)

			v994.Font = Theme.font(Enum.Font.SourceSans)
			v993.Size = UDim2.new(0.6, -10, 0, 35)
			v993.Position = UDim2.new(1, -400, 0.5, 0)
			v993.AnchorPoint = Vector2.new(0, 0.5)

			local v996 = Utility:AddNewRowObject(v180, "Developer Console", v993)

			v996.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
			v995(v996)
		end

		if RunService:IsStudio() then
			makeDevConsoleOption()

			return
		end

		spawn(function() -- line: 2953
			-- upvalues: PlayerPermissionsModule (copy), Players (copy), makeDevConsoleOption (copy)
			if PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer) then
				makeDevConsoleOption()
			end
		end)
	end
	local function createUiToggleOptions() -- line: 2962
		-- upvalues: v139 (copy), v138 (copy), RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), LocalPlayer (copy)
		if v139 or v138 then
			local t30 = {
				{
					label = "Custom",
					layoutOrderKey = "UiToggleRowCustom",
					type = Enum.GuiType.Custom
				},
				{
					label = "CustomBillboards",
					layoutOrderKey = "UiToggleRowBillboards",
					type = Enum.GuiType.CustomBillboards
				},
				{
					label = "PlayerNameplates",
					layoutOrderKey = "UiToggleRowNameplates",
					type = Enum.GuiType.PlayerNameplates
				}
			}
			local v551 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
			local v552 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

			v180.uiToggleSelectors = {}

			for __, v554 in t30 do
				local v555 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.ShowGuiType", {
					GuiType = v554.label
				})
				local v556, v557, v558 = Utility:AddNewRow(v180, v555, "Selector", {
					v551,
					v552
				}, 1)

				v556.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER[v554.layoutOrderKey]
				v558.IndexChanged:Connect(function(p92) -- line: 2990
					-- upvalues: GuiService (copy), v554 (copy)
					if p92 ~= (not GuiService:GetGuiIsVisible(v554.type) and 2 or 1) then
						GuiService:ToggleGuiIsVisibleIfAllowed(v554.type)
					end
				end)
				v180.uiToggleSelectors[v554.label] = {
					label = v555,
					type = v554.type,
					row = v556,
					frame = v557,
					selector = v558
				}
			end

			local v559 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.Freecam")
			local v560 = v180
			local v561 = v180
			local v562 = v180
			local v563, v564, v565 = Utility:AddNewRow(v180, v559, "Selector", {
				v552,
				v551
			}, 1)

			v560.freecamRow = v563
			v561.freecamFrame = v564
			v562.freecamSelector = v565
			v180.freecamRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FreecamToggleRow
			v180.freecamSelector.IndexChanged:Connect(function(p93) -- line: 3012
				-- upvalues: LocalPlayer (copy)
				local v999 = p93 == 2
				local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

				if not FreecamScript then
					warn("Freecam not present")

					return
				end

				FreecamScript:SetAttribute("FreecamEnabled", v999)
			end)

			return
		end

		local v566 = v180
		local v567 = v180
		local v568 = v180
		local v569, v570, v571 = Utility:AddNewRow(v180, "BillboardGui Visibility", "Selector", {
			"All visible",
			"Hide nameplates/bubble chat"
		}, 1)

		v566.uiToggleRow = v569
		v567.uiToggleFrame = v570
		v568.uiToggleSelector = v571
		v180.uiToggleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiToggleRow
		v180.uiToggleSelector.IndexChanged:connect(function(__) -- line: 3031
			-- upvalues: GuiService (copy)
			GuiService:ToggleGuiIsVisibleIfAllowed(Enum.GuiType.PlayerNameplates)
		end)
	end
	local function updateUiToggleSelection() -- line: 3037
		-- upvalues: v139 (copy), v138 (copy), v180 (copy), GuiService (copy), LocalPlayer (copy)
		if v139 or v138 then
			if not v180.uiToggleSelectors then
				return
			end

			for __, v573 in v180.uiToggleSelectors do
				local v574 = not GuiService:GetGuiIsVisible(v573.type) and 2 or 1

				if v574 ~= v573.selector:GetSelectedIndex() then
					v573.selector:SetSelectionIndex(v574)
				end
			end

			local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

			if FreecamScript then
				local v576 = not FreecamScript:GetAttribute("FreecamEnabled") and 1 or 2

				v180.freecamSelector:SetSelectionIndex(v576)

				return
			end
		else
			if not v180.uiToggleSelector then
				return
			end

			local v577 = not GuiService:GetGuiIsVisible(Enum.GuiType.PlayerNameplates) and 2 or 1

			if v577 == v180.uiToggleSelector:GetSelectedIndex() then
				return
			end

			v180.uiToggleSelector:SetSelectionIndex(v577)
		end
	end
	local function isValidDeviceList(p95, p96, p97) -- line: 3079
		return p95 and (p96 and (p97 and (#p95 > 0 and (p97 > 0 and (p97 <= #p95 and #p95 == #p96)))))
	end
	local function SwitchOutputDevice(p98, p99) -- line: 3092
		-- upvalues: SoundService (copy), v125 (copy)
		SoundService:SetOutputDevice(p98, p99)
		v125:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", p98, p99)
	end
	local function createDeviceOptions(p100) -- line: 3097
		-- upvalues: v180 (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), SoundService (copy), v125 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
		local v584 = v180[p100 .. "DeviceIndex"] or 0
		local v585 = v180[p100 .. "DeviceNames"] or {}
		local v586 = v180[p100 .. "DeviceGuids"] or {}
		local v587 = p100 == "Input" and RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.InputDevice") or RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.OutputDevice")
		local v588 = v180
		local v589 = p100 .. "DeviceFrame"
		local v590 = v180
		local v591 = p100 .. "DeviceSelector"
		local v592, v593, v594 = Utility:AddNewRow(v180, v587, "Selector", v585, v584)

		v588[v589] = v592
		_ = v593
		v590[v591] = v594
		v180[p100 .. "DeviceFrame"].LayoutOrder = p100 == "Input" and SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameInput or SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameOutput
		v180[p100 .. "DeviceInfo"] = {
			Name = v584 > 0 and v585[v584] or nil,
			Guid = v584 > 0 and v586[v584] or nil
		}
		v180[p100 .. "PrevDeviceName"] = v180[p100 .. "DeviceInfo"].Name

		local n12 = 0
		local v596 = GetFIntVoiceChatDeviceChangeDebounceDelay()

		v180[p100 .. "DeviceSelector"].IndexChanged:connect(function(p101) -- line: 3120
			-- upvalues: v180 (copy), p100 (copy), n12 (ref), v596 (copy), default3 (copy), SoundService (copy), v125 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
			if v180[p100 .. "DeviceInfo"].Name == v180[p100 .. "DeviceNames"][p101] and v180[p100 .. "DeviceInfo"].Guid == v180[p100 .. "DeviceGuids"][p101] then
				return
			end

			local v1003 = n12 + 1

			n12 = v1003
			wait(v596)

			if v1003 == n12 then
				n12 = 0
				v180[p100 .. "DeviceInfo"] = {
					Name = v180[p100 .. "DeviceNames"][p101],
					Guid = v180[p100 .. "DeviceGuids"][p101]
				}

				local Name = v180[p100 .. "DeviceInfo"].Name
				local Guid = v180[p100 .. "DeviceInfo"].Guid

				if v180.VoiceChatOptionsEnabled then
					default3:SwitchDevice(p100, Name, Guid)
				else
					SoundService:SetOutputDevice(Name, Guid)
					v125:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", Name, Guid)
				end

				if GetFFlagEnableCrossExpVoice() then
					v125:debug("[GameSettings] Changing {} device to {} {} ", p100, Name, Guid)

					if p100 == "Input" then
						default4:changeInputDevice(Name, Guid)
					else
						default4:changeOutputDevice(Name, Guid)
					end
				end

				reportSettingsChangeForAnalytics(p100, v180[p100 .. "PrevDeviceName"], Name)
				v180[p100 .. "PrevDeviceName"] = Name
			end
		end)
	end
	local function createBadgeVisibilityOptions() -- line: 3162
		-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v148 (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
		spawn(function() -- line: 3163
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v148 (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n13 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n13 = 1
			end

			local v1007 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v1008 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v1009 = if not v148 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v1010 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v1011 = v180
			local v1012 = v180
			local v1013 = v180
			local v1014, v1015, v1016 = Utility:AddNewRow(v180, v1009, "Selector", {
				v1008,
				v1007
			}, n13, nil, v1010)

			v1011.badgeVisibleRow = v1014
			v1012.badgeVisibleFrame = v1015
			v1013.badgeVisibleSelector = v1016
			v180.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v180.badgeVisibleSelector.IndexChanged:connect(function(p102) -- line: 3177
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p102 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p102 == 1)
			end)
		end)
	end
	local function createChatModerationOptions() -- line: 3184
		-- upvalues: v180 (copy), Utility (copy), u24 (ref), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), Signals (copy), reportSettingsChangeForAnalytics (copy)
		local __ = {
			title = "CoreScripts.InGameMenu.GameSettings.ReadOnlyView",
			description = "CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}
		local v598 = v180
		local v599 = v180
		local v600, v601, v602 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyView"), "Selector", {
			u24:Format("InGame.CommonUI.Label.Off"),
			u24:Format("InGame.CommonUI.Label.On")
		}, 1, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription"))

		v598.ChatModerationFrame = v600
		_ = v601
		v599.ChatModerationSelector = v602
		v180.ChatModerationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatModerationFrame
		v180.ChatModerationFrame.Visible = false

		local v603 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetChatModerationStore(false)

		v180.ChatModerationDisposeEffect = Signals.createEffect(function(p103) -- line: 3208
			-- upvalues: v180 (copy), v603 (copy)
			v180.ChatModerationFrame.Visible = v603.getIsSettingVisible(p103)

			local v1018 = not v603.getIsSettingEnabled(p103) and 1 or 2

			if v1018 ~= v180.ChatModerationSelector:GetSelectedIndex() then
				v180.ChatModerationSelector:SetSelectionIndex(v1018)
			end
		end)
		v180.ChatModerationSelector.IndexChanged:connect(function(p104) -- line: 3217
			-- upvalues: v603 (copy), reportSettingsChangeForAnalytics (copy)
			local v1020 = p104 == 2

			v603.setIsSettingEnabled(v1020)
			reportSettingsChangeForAnalytics("moderate_chat", not v1020, v1020)
		end)
		v603.initialize()
	end
	local function createAIRephraseSettingOptions() -- line: 3226
		-- upvalues: RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceAIRephraseSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy), v149 (copy), ThrottleFunctionCall (copy)
		local v604 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessages")
		local v605 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessagesDescription")
		local v606 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v607 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v608 = v180
		local v609 = v180
		local v610, v611, v612 = Utility:AddNewRow(v180, v604, "Selector", {
			v607,
			v606
		}, 1, nil, v605)

		v608.AIRephraseFrame = v610
		_ = v611
		v609.AIRephraseSelector = v612
		v180.AIRephraseFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AIRephraseFrame
		v180.AIRephraseFrame.Visible = false

		local v613 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getAIRephraseSettingStore(false)
		local v614 = GetFIntDebounceAIRephraseSettingDelay()
		local v615 = v614 > 0
		local u616 = not v613.getIsSettingEnabled(false) and 1 or 2

		v180.AIRephraseDisposeEffect = Signals.createEffect(function(p105) -- line: 3252
			-- upvalues: v180 (copy), v613 (copy), u616 (ref)
			v180.AIRephraseFrame.Visible = v613.getIsSettingVisible(p105)

			local v1022 = not v613.getIsSettingEnabled(p105) and 1 or 2

			if v1022 ~= v180.AIRephraseSelector:GetSelectedIndex() then
				u616 = v1022
				v180.AIRephraseSelector:SetSelectionIndex(v1022)
			end
		end)

		local function v617(p106) -- line: 3263
			-- upvalues: u616 (ref), TextChatService (copy), v613 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
			if p106 == u616 then
				return
			end

			local v1024 = p106 == 2

			task.spawn(function() -- line: 3269
				-- upvalues: TextChatService (copy), v1024 (copy), v613 (copy), u616 (ref), p106 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
				if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1024 and "Disabled" or "Enabled") then
					v613.setIsSettingEnabled(v1024)
					u616 = p106
					reportSettingsChangeForAnalytics("ai_rephrase", not v1024, v1024)

					return
				end

				v180.AIRephraseSelector:SetSelectionIndex(u616)
			end)
		end

		if v149 then
			if v615 then
				local u618 = nil

				v180.AIRephraseSelector.IndexChanged:connect(function(p107) -- line: 3286
					-- upvalues: u618 (ref), v614 (copy), u616 (ref), TextChatService (copy), v613 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
					if u618 then
						task.cancel(u618)
					end

					u618 = task.delay(v614, function() -- line: 3290
						-- upvalues: u618 (ref), p107 (copy), u616 (ref), TextChatService (copy), v613 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
						u618 = nil

						local v1148 = p107

						if v1148 == u616 then
							return
						end

						local v1149 = v1148 == 2

						task.spawn(function() -- line: 3269
							-- upvalues: TextChatService (copy), v1149 (copy), v613 (copy), u616 (ref), v1148 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
							if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1149 and "Disabled" or "Enabled") then
								v613.setIsSettingEnabled(v1149)
								u616 = v1148
								reportSettingsChangeForAnalytics("ai_rephrase", not v1149, v1149)

								return
							end

							v180.AIRephraseSelector:SetSelectionIndex(u616)
						end)
					end)
				end)
			else
				v180.AIRephraseSelector.IndexChanged:connect(v617)
			end
		else
			v180.AIRephraseSelector.IndexChanged:connect(if not v615 then v617 else ThrottleFunctionCall(v614, v617))
		end
	end
	local function createChatSummariesSettingOptions() -- line: 3303
		-- upvalues: RobloxTranslator (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceChatSummariesSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy)
		local v619 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummaries")
		local v620 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummariesDescription")
		local v621 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v622 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v623 = v180
		local v624 = v180
		local v625, v626, v627 = Utility:AddNewRow(v180, v619, "Selector", {
			v622,
			v621
		}, 1, nil, v620)

		v623.ChatSummariesFrame = v625
		_ = v626
		v624.ChatSummariesSelector = v627
		v180.ChatSummariesFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatSummariesFrame
		v180.ChatSummariesFrame.Visible = false

		local v628 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getChatSummariesSettingStore(false)
		local v629 = GetFIntDebounceChatSummariesSettingDelay()
		local v630 = v629 > 0
		local u631 = not v628.getIsSettingEnabled(false) and 1 or 2

		v180.ChatSummariesDisposeEffect = Signals.createEffect(function(p108) -- line: 3329
			-- upvalues: v180 (copy), v628 (copy), u631 (ref)
			v180.ChatSummariesFrame.Visible = v628.getIsSettingVisible(p108)

			local v1027 = not v628.getIsSettingEnabled(p108) and 1 or 2

			if v1027 ~= v180.ChatSummariesSelector:GetSelectedIndex() then
				u631 = v1027
				v180.ChatSummariesSelector:SetSelectionIndex(v1027)
			end
		end)

		if v630 then
			local u632 = nil

			v180.ChatSummariesSelector.IndexChanged:connect(function(p109) -- line: 3362
				-- upvalues: u632 (ref), v629 (copy), u631 (ref), TextChatService (copy), v628 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
				if u632 then
					task.cancel(u632)
				end

				u632 = task.delay(v629, function() -- line: 3366
					-- upvalues: u632 (ref), p109 (copy), u631 (ref), TextChatService (copy), v628 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
					u632 = nil

					local v1150 = p109

					if v1150 == u631 then
						return
					end

					local v1151 = v1150 == 2

					task.spawn(function() -- line: 3346
						-- upvalues: TextChatService (copy), v1151 (copy), v628 (copy), u631 (ref), v1150 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
						if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1151 and "Disabled" or "Enabled") then
							v628.setIsSettingEnabled(v1151)
							u631 = v1150
							reportSettingsChangeForAnalytics("chat_summaries", not v1151, v1151)

							return
						end

						v180.ChatSummariesSelector:SetSelectionIndex(u631)
					end)
				end)
			end)
		else
			v180.ChatSummariesSelector.IndexChanged:connect(function(p110) -- line: 3340
				-- upvalues: u631 (ref), TextChatService (copy), v628 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
				if p110 == u631 then
					return
				end

				local v1029 = p110 == 2

				task.spawn(function() -- line: 3346
					-- upvalues: TextChatService (copy), v1029 (copy), v628 (copy), u631 (ref), p110 (copy), reportSettingsChangeForAnalytics (copy), v180 (copy)
					if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1029 and "Disabled" or "Enabled") then
						v628.setIsSettingEnabled(v1029)
						u631 = p110
						reportSettingsChangeForAnalytics("chat_summaries", not v1029, v1029)

						return
					end

					v180.ChatSummariesSelector:SetSelectionIndex(u631)
				end)
			end)
		end
	end
	local function createCameraDeviceOptions() -- line: 3379
		-- upvalues: v180 (copy), v124 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v125 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
		local v633 = v180.CameraDeviceIndex or 1
		local v634 = v180.CameraDeviceNames or {}
		local v635 = v180.CameraDeviceGuids or {}
		local v636 = v124
		local v637 = v180
		local v638 = v180
		local v639, v640, v641 = Utility:AddNewRow(v180, v636, "Selector", v634, v633)

		v637.CameraDeviceFrame = v639
		_ = v640
		v638.CameraDeviceSelector = v641
		v180.CameraDeviceFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraDeviceFrame
		v180.CameraDeviceInfo = {
			Name = v633 > 0 and v634[v633] or nil,
			Guid = v633 > 0 and v635[v633] or nil
		}
		v180.prevCameraDeviceName = v180.CameraDeviceInfo.Name
		v180.CameraDeviceSelector.IndexChanged:connect(function(p111) -- line: 3396
			-- upvalues: v180 (copy), v125 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
			if v180.CameraDeviceInfo.Name == v180.CameraDeviceNames[p111] and v180.CameraDeviceInfo.Guid == v180.CameraDeviceGuids[p111] then
				return
			end

			v180.CameraDeviceInfo = {
				Name = v180.CameraDeviceNames[p111],
				Guid = v180.CameraDeviceGuids[p111]
			}

			local Guid = v180.CameraDeviceInfo.Guid

			v125:info("Changed webcam to: {}", Guid)
			UserGameSettings.DefaultCameraID = Guid
			reportSettingsChangeForAnalytics("video_camera", v180.prevCameraDeviceName or "None", v180.CameraDeviceInfo.Name)
			v180.prevCameraDeviceName = v180.CameraDeviceInfo.Name
		end)
	end
	local function updateAudioDevices(p112) -- line: 3421
		-- upvalues: SoundService (copy), u24 (ref), v180 (copy), GetFFlagVoiceChatUILogging (copy), v125 (copy), createDeviceOptions (copy)
		local ok, result, v645, v646 = pcall(function() -- line: 3422
			-- upvalues: p112 (copy), SoundService (copy)
			if p112 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v645 and (v646 and (#result > 0 and (v646 > 0 and (v646 <= #result and #result == #v645)))))) then
			if v645[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v180[p112 .. "DeviceNames"] = result
			v180[p112 .. "DeviceGuids"] = v645
			v180[p112 .. "DeviceIndex"] = v646
		else
			if GetFFlagVoiceChatUILogging() then
				v125:warning("Errors in get {} device info", p112)
			end

			v180[p112 .. "DeviceNames"] = {}
			v180[p112 .. "DeviceGuids"] = {}
			v180[p112 .. "DeviceIndex"] = 0
		end

		if not v180[p112 .. "DeviceSelector"] then
			createDeviceOptions(p112)

			return
		end

		v180[p112 .. "DeviceSelector"]:UpdateOptions(result)
		v180[p112 .. "DeviceSelector"]:SetSelectionIndex(v646)
	end
	local function updateVoiceChatDevices(p113) -- line: 3454
		-- upvalues: GetFFlagVoiceChatUILogging (copy), v125 (copy), SoundService (copy), u24 (ref), v180 (copy), createDeviceOptions (copy)
		if p113 ~= "Input" and (p113 ~= "Output" and GetFFlagVoiceChatUILogging()) then
			v125:warning("{} is not supported in VoiceChat devices", p113)
		end

		local ok, result, v650, v651 = pcall(function() -- line: 3461
			-- upvalues: p113 (copy), SoundService (copy)
			if p113 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v650 and (v651 and (#result > 0 and (v651 > 0 and (v651 <= #result and #result == #v650)))))) then
			if v650[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v180[p113 .. "DeviceNames"] = result
			v180[p113 .. "DeviceGuids"] = v650
			v180[p113 .. "DeviceIndex"] = v651
		else
			if GetFFlagVoiceChatUILogging() then
				if #result > 0 then
					v125:warning("Errors in get {} device info success: {}", p113, ok)
				else
					v125:warning("Empty deviceNames list for {}", p113)
				end
			end

			v180[p113 .. "DeviceNames"] = {}
			v180[p113 .. "DeviceGuids"] = {}
			v180[p113 .. "DeviceIndex"] = 0
		end

		if not v180[p113 .. "DeviceSelector"] then
			createDeviceOptions(p113)
		else
			v180[p113 .. "DeviceSelector"]:UpdateOptions(result)
			v180[p113 .. "DeviceSelector"]:SetSelectionIndex(v651)
		end

		if v180[p113 .. "DeviceFrame"] then
			if #result > 0 then
				v180[p113 .. "DeviceFrame"].Visible = true

				return
			end

			v180[p113 .. "DeviceFrame"].Visible = false
		end
	end
	local function updateCameraDevices() -- line: 3513
		-- upvalues: VideoCaptureService (copy), v123 (copy), UserGameSettings (copy), v180 (copy), createCameraDeviceOptions (copy)
		local CameraDevices = VideoCaptureService:GetCameraDevices()
		local t31 = {}
		local t32 = {}
		local n14 = 1

		table.insert(t31, v123)
		table.insert(t32, "{DefaultDeviceGuid}")

		for k, v in pairs(CameraDevices) do
			if k == UserGameSettings.DefaultCameraID then
				n14 = #t31 + 1
			end

			table.insert(t31, v)
			table.insert(t32, k)
		end

		v180.CameraDeviceNames = t31
		v180.CameraDeviceGuids = t32
		v180.CameraDeviceIndex = 0

		if not v180.CameraDeviceSelector then
			createCameraDeviceOptions()
		else
			v180.CameraDeviceSelector:UpdateOptions(t31)
		end

		v180.CameraDeviceSelector:SetSelectionIndex(n14)
	end

	local connection = nil
	local connection2 = nil

	local function updateAudioOptions() -- line: 3543
		-- upvalues: v180 (copy), updateVoiceChatDevices (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), updateAudioDevices (copy)
		if v180.VoiceChatOptionsEnabled then
			updateVoiceChatDevices("Input")
			updateVoiceChatDevices("Output")

			return
		end

		if GetFFlagEnableCrossExpVoice() and default4:getIsConnected() then
			updateAudioDevices("Input")
		end

		updateAudioDevices("Output")
	end
	local function setupDeviceChangedListener() -- line: 3555
		-- upvalues: SoundService (copy), connection (ref), v180 (copy), updateAudioOptions (copy)
		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3557
				-- upvalues: v180 (copy), updateAudioOptions (copy)
				if v180.PageOpen then
					updateAudioOptions()
				end
			end)
		end
	end
	local function setupVideoCameraDeviceChangedListener() -- line: 3565
		-- upvalues: VideoCaptureService (copy), connection2 (ref), v180 (copy), updateCameraDevices (copy)
		if VideoCaptureService.DevicesChanged then
			connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3567
				-- upvalues: v180 (copy), updateCameraDevices (copy)
				if v180.PageOpen then
					updateCameraDevices()
				end
			end)
		end
	end
	local function teardownDeviceChangedListener() -- line: 3575
		-- upvalues: SoundService (copy), connection (ref)
		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end
	end
	local function teardownVideoCameraDeviceChangedListener() -- line: 3581
		-- upvalues: VideoCaptureService (copy), connection2 (ref)
		if VideoCaptureService.DevicesChanged and connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end
	local function checkVoiceChatOptions() -- line: 3589
		-- upvalues: default3 (copy), v180 (copy)
		if default3:VoiceChatAvailable() then
			v180.VoiceChatOptionsEnabled = true
		end
	end
	local function updateInputDeviceVisibility() -- line: 3595
		-- upvalues: v180 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy)
		local v658 = v180.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

		if v180.InputDeviceFrame then
			v180.InputDeviceFrame.Visible = v658
		end
	end

	local u233 = false
	local u234 = nil

	if v59 then
		u234 = false
	end

	local function createVoiceChatSelector() -- line: 3608
		-- upvalues: v58 (copy), v180 (copy), v52 (copy), u24 (ref), default3 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v59 (copy), GetFIntDebounceDisconnectButtonDelay (copy), u234 (ref), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v65 (copy), u233 (ref), ThrottleFunctionCall (copy), v55 (copy), GuiService (copy), v64 (copy), v60 (copy)
		if v58 and (v180.VoiceConnectDisconnectFrame and v180.VoiceConnectDisconnectSelector) then
			return
		end

		local s15 = "Voice Chat"
		local s16 = "Disconnected"
		local s17 = "Connected"

		if v52 then
			s15 = u24:Format("Feature.GameDetails.Label.VoiceChat")
			s16 = u24:Format("Feature.SettingsHub.Label.Disconnected")
			s17 = u24:Format("Feature.SettingsHub.Label.Connected")
		end

		local v662 = not default3:VoiceChatEnded() and 2 or 1
		local v663 = v180
		local v664 = v180
		local v665, v666, v667 = Utility:AddNewRow(v180, s15, "Selector", {
			s16,
			s17
		}, v662)

		v663.VoiceConnectDisconnectFrame = v665
		_ = v666
		v664.VoiceConnectDisconnectSelector = v667
		v180.VoiceConnectDisconnectFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectDisconnectSelector

		local v668 = default3:getService()

		if v668 and not v59 then
			v668.StateChanged:Connect(function(oldState, newState) -- line: 3633
				-- upvalues: v58 (copy), v180 (copy), default3 (copy)
				if v58 then
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined and v180.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if (newState == Enum.VoiceChatState.Ended or newState == Enum.VoiceChatState.Failed or newState == Enum.VoiceChatState.Idle) and v180.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

						return
					end
				else
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if default3:VoiceChatEnded() then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end
			end)
		end

		local u669 = v662
		local v670 = GetFIntDebounceDisconnectButtonDelay()
		local v671 = v670 > 0

		local function v672(p114) -- line: 3667
			-- upvalues: u669 (ref), v59 (copy), u234 (ref), FFlagVoiceRewarmTelemetry (copy), default3 (copy), Constants2 (copy), v65 (copy), u233 (ref), v180 (copy)
			if p114 == u669 then
				return
			end

			u669 = p114

			if v59 and u234 then
				return
			end

			if FFlagVoiceRewarmTelemetry then
				local v1036, v1037, v1038, v1039 = default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2)

				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1036, v1037, v1038, v1039, default3.joinVoiceButtonContext)
			else
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2))
			end

			if p114 == 2 then
				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			elseif v65 then
				local v1040 = default3:getService()
				local v1041 = v1040 ~= nil and v1040.VoiceChatState == Enum.VoiceChatState.Failed

				if not default3:VoiceChatEnded() and not v1041 then
					default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
					default3:Leave()
				end
			elseif not default3:VoiceChatEnded() then
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			if u233 then
				task.spawn(function() -- line: 3711
					-- upvalues: p114 (copy), v180 (copy)
					task.wait(0.5)

					if p114 ~= 1 then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end)
			end
		end

		v180.VoiceConnectDisconnectSelector.IndexChanged:connect(if not v671 then v672 else ThrottleFunctionCall(v670, v672))

		if v55 then
			v180.VoiceConnectDisconnectFrame.SelectionChanged:Connect(function(__, p116, p117) -- line: 3725
				-- upvalues: s15 (ref), v180 (copy), GuiService (copy)
				if p117 and (p116 and p116.Parent and p116.Parent.Name == s15 .. "Frame" and p117.Name == "ImageButton" and v180.Active) then
					GuiService.SelectedCoreObject = p116
				end
			end)
		end

		default3:subscribe("OnStateChanged", function(__, p119) -- line: 3732
			-- upvalues: v59 (copy), u234 (ref), v64 (copy), v180 (copy), v60 (copy)
			if v59 then
				u234 = true

				if v64 then
					if p119 == Enum.VoiceChatState.Joined and v180.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					end
				elseif p119 == Enum.VoiceChatState.Joined then
					v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
				end
			end

			if v64 then
				if p119 == Enum.VoiceChatState.Failed and v180.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
					v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
				end
			elseif p119 == Enum.VoiceChatState.Failed then
				v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
			end

			if v59 then
				if v60 then
					task.defer(function() -- line: 3764
						-- upvalues: u234 (ref)
						u234 = false
					end)

					return
				end

				u234 = false
			end
		end)
		default3:subscribe("OnRequestMicPermissionRejected", function() -- line: 3773
			-- upvalues: u233 (ref), v59 (copy), u234 (ref), v180 (copy), v60 (copy)
			task.spawn(function() -- line: 3774
				-- upvalues: u233 (ref), v59 (copy), u234 (ref), v180 (copy), v60 (copy)
				task.wait(0.5)
				u233 = true

				if v59 then
					u234 = true
				end

				v180.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

				if v59 then
					if v60 then
						task.defer(function() -- line: 3783
							-- upvalues: u234 (ref)
							u234 = false
						end)

						return
					end

					u234 = false
				end
			end)
		end)
	end
	local function createVoiceConnectDisconnect() -- line: 3794
		-- upvalues: default3 (copy), u24 (ref), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), Utility (copy), ThrottleFunctionCall (copy), v180 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy)
		if default3:IsSeamlessVoice() and not default3.isShowingFTUX then
			local v673 = u24:Format("Feature.GameDetails.Label.VoiceChat")
			local v674 = u24:Format("Feature.SettingsHub.Label.Connect")
			local v675 = u24:Format("Feature.SettingsHub.Label.Disconnect")
			local v676 = GetFIntDebounceDisconnectButtonDelay()
			local v677 = v676 > 0

			local function v678() -- line: 3804
				-- upvalues: default3 (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy)
				if default3:getService() then
					local connection3 = nil

					connection3 = default3:getService().StateChanged:Connect(function(__, newState) -- line: 3808
						-- upvalues: FFlagVoiceRewarmTelemetry (copy), default3 (copy), connection3 (ref)
						if newState == Enum.VoiceChatState.Joined then
							if FFlagVoiceRewarmTelemetry then
								local v1154, v1155, v1156, v1157 = default3:GetConnectDisconnectButtonAnalyticsData(true)

								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1154, v1155, v1156, v1157, default3.joinVoiceButtonContext)
							else
								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
							end

							connection3:Disconnect()
						end
					end)
				elseif FFlagVoiceRewarmTelemetry then
					local v1048, v1049, v1050, v1051 = default3:GetConnectDisconnectButtonAnalyticsData(false)

					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1048, v1049, v1050, v1051, default3.joinVoiceButtonContext)
				else
					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(false))
				end

				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			end
			local function v679() -- line: 3841
				-- upvalues: default3 (copy), Constants2 (copy)
				default3.Analytics:reportLeaveVoiceButtonEvent("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			local v680, v681, v682 = Utility:MakeStyledButton("VoiceConnectButton", v674, UDim2.new(1, 0, 1, -20), if not v677 then v678 else ThrottleFunctionCall(v676, v678), v180)

			voiceConnectSetRowRef = v682

			local v683, v684, v685 = Utility:MakeStyledButton("VoiceDisconnectButton", v675, UDim2.new(1, 0, 1, -20), if not v677 then v679 else ThrottleFunctionCall(v676, v679), v180)

			voiceDisconnectSetRowRef = v685
			v680.Size = UDim2.new(0.6, 0, 0, 40)
			v680.Position = UDim2.new(0.4, 0, 0.5, 0)
			v680.AnchorPoint = Vector2.new(0, 0.5)
			v680.ZIndex = 2
			v680.Selectable = true
			v681.ZIndex = 2
			v683.Size = UDim2.new(0.6, 0, 0, 40)
			v683.Position = UDim2.new(0.4, 0, 0.5, 0)
			v683.AnchorPoint = Vector2.new(0, 0.5)
			v683.ZIndex = 2
			v683.Selectable = true
			v684.ZIndex = 2

			local v686 = Utility:AddNewRowObject(v180, v673, v680, nil, true)
			local v687 = Utility:AddNewRowObject(v180, v673, v683, nil, true)

			v180.VoiceConnectFrame = v686
			v180.VoiceDisconnectFrame = v687
			v686.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectFrame
			v687.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceDisconnectFrame
			voiceConnectSetRowRef(v686)
			voiceDisconnectSetRowRef(v687)

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused() then
				v686.Visible = false
				v687.Visible = false

				return
			end

			if default3:ShouldShowJoinVoice() then
				v686.Visible = true
				v687.Visible = false

				return
			end

			v686.Visible = false
			v687.Visible = true
		end
	end
	local function createVRComfortSettingOptions() -- line: 3904
		-- upvalues: u24 (ref), GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local EnumItems = Enum.VRComfortSetting:GetEnumItems()
		local t33 = {
			title = "CoreScripts.InGameMenu.PageTitle.VRComfortSettings",
			description = "CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription",
			["Enum.VRComfortSetting.Comfort"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingComfort",
			["Enum.VRComfortSetting.Normal"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingNormal",
			["Enum.VRComfortSetting.Expert"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingExpert",
			["Enum.VRComfortSetting.Custom"] = "CoreScripts.InGameMenu.GameSettings.ComfortSettingCustom",
			vignetteEnabled = "CoreScripts.InGameMenu.GameSettings.VignetteEnabled",
			steppedRotationEnabled = "CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled",
			thirdPersonFixedCamEnabled = "CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}
		local t34 = {}

		for i, v in ipairs(EnumItems) do
			t34[i] = u24:Format(t33[tostring(v)])
		end

		local v693 = table.find(EnumItems, GameSettings.VRComfortSetting)
		local v694 = v180
		local v695 = v180
		local v696 = v180
		local v697, v698, v699 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.PageTitle.VRComfortSettings"), "Selector", t34, v693, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription"))

		v694.VRComfortSettingFrame = v697
		v695.VRComfortSettingLabel = v698
		v696.VRComfortSettingSelector = v699
		v180.VRComfortSettingFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRComfortSettingFrame

		local v700 = not GameSettings.VignetteEnabled and 2 or 1
		local v701 = v180
		local v702 = v180
		local v703 = v180
		local v704, v705, v706 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.GameSettings.VignetteEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v700)

		v701.VRVignetteEnabledFrame = v704
		v702.VRVignetteEnabledLabel = v705
		v703.VRVignetteEnabledSelector = v706
		v180.VRVignetteEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRVignetteEnabledFrame

		local v707 = not GameSettings.VRSmoothRotationEnabled and 1 or 2
		local v708 = v180
		local v709 = v180
		local v710 = v180
		local v711, v712, v713 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v707)

		v708.VRSteppedRotationEnabledFrame = v711
		v709.VRSteppedRotationEnabledLabel = v712
		v710.VRSteppedRotationEnabledSelector = v713
		v180.VRSteppedRotationEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSteppedRotationEnabledFrame

		local v714 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2
		local v715 = v180
		local v716 = v180
		local v717 = v180
		local v718, v719, v720 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v714)

		v715.VRThirdPersonFixedCamEnabledFrame = v718
		v716.VRThirdPersonFixedCamEnabledLabel = v719
		v717.VRThirdPersonFixedCamEnabledSelector = v720
		v180.VRThirdPersonFixedCamEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRThirdPersonFixedCamEnabledFrame

		local function v721(p121) -- line: 3970
			-- upvalues: v180 (copy)
			if p121 == Enum.VRComfortSetting.Custom then
				v180.VRVignetteEnabledSelector:SetZIndex(2)
				v180.VRVignetteEnabledLabel.ZIndex = 2
				v180.VRVignetteEnabledSelector:SetInteractable(true)
				v180.VRSteppedRotationEnabledSelector:SetZIndex(2)
				v180.VRSteppedRotationEnabledLabel.ZIndex = 2
				v180.VRSteppedRotationEnabledSelector:SetInteractable(true)
				v180.VRThirdPersonFixedCamEnabledSelector:SetZIndex(2)
				v180.VRThirdPersonFixedCamEnabledLabel.ZIndex = 2
				v180.VRThirdPersonFixedCamEnabledSelector:SetInteractable(true)

				return
			end

			v180.VRVignetteEnabledSelector:SetZIndex(1)
			v180.VRVignetteEnabledLabel.ZIndex = 1
			v180.VRVignetteEnabledSelector:SetInteractable(false)
			v180.VRSteppedRotationEnabledSelector:SetZIndex(1)
			v180.VRSteppedRotationEnabledLabel.ZIndex = 1
			v180.VRSteppedRotationEnabledSelector:SetInteractable(false)
			v180.VRThirdPersonFixedCamEnabledSelector:SetZIndex(1)
			v180.VRThirdPersonFixedCamEnabledLabel.ZIndex = 1
			v180.VRThirdPersonFixedCamEnabledSelector:SetInteractable(false)
		end

		v180.VRComfortSettingSelector.IndexChanged:connect(function(p122) -- line: 3994
			-- upvalues: EnumItems (copy), GameSettings (copy), v721 (copy)
			local v1054 = EnumItems[p122]

			GameSettings.VRComfortSetting = v1054
			v721(v1054)
		end)
		v721(GameSettings.VRComfortSetting)
		v180.VRVignetteEnabledSelector.IndexChanged:connect(function(p123) -- line: 4001
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VignetteEnabledCustomOption = p123 == 1
			end
		end)
		v180.VRSteppedRotationEnabledSelector.IndexChanged:connect(function(p124) -- line: 4007
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRSmoothRotationEnabledCustomOption = p124 == 2
			end
		end)
		v180.VRThirdPersonFixedCamEnabledSelector.IndexChanged:connect(function(p125) -- line: 4013
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRThirdPersonFollowCamEnabledCustomOption = p125 == 2
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function() -- line: 4019
			-- upvalues: EnumItems (copy), GameSettings (copy), v180 (copy)
			local v1058 = table.find(EnumItems, GameSettings.VRComfortSetting)

			if v1058 ~= v180.VRComfortSettingSelector:GetSelectedIndex() then
				v180.VRComfortSettingSelector:SetSelectionIndex(v1058)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function() -- line: 4026
			-- upvalues: GameSettings (copy), v180 (copy)
			local v1059 = not GameSettings.VignetteEnabled and 2 or 1

			if v1059 ~= v180.VRVignetteEnabledSelector:GetSelectedIndex() then
				v180.VRVignetteEnabledSelector:SetSelectionIndex(v1059)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function() -- line: 4033
			-- upvalues: GameSettings (copy), v180 (copy)
			local v1060 = not GameSettings.VRSmoothRotationEnabled and 1 or 2

			if v1060 ~= v180.VRSteppedRotationEnabledSelector:GetSelectedIndex() then
				v180.VRSteppedRotationEnabledSelector:SetSelectionIndex(v1060)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function() -- line: 4040
			-- upvalues: GameSettings (copy), v180 (copy)
			local v1061 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2

			if v1061 ~= v180.VRThirdPersonFixedCamEnabledSelector:GetSelectedIndex() then
				v180.VRThirdPersonFixedCamEnabledSelector:SetSelectionIndex(v1061)
			end
		end)
	end
	local function createVRSafetyBubbleModeOptions() -- line: 4048
		-- upvalues: u24 (ref), GameSettings (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local EnumItems = Enum.VRSafetyBubbleMode:GetEnumItems()
		local t35 = {
			title = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle",
			description = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription",
			["Enum.VRSafetyBubbleMode.NoOne"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeNoOne",
			["Enum.VRSafetyBubbleMode.OnlyFriends"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeOnlyFriends",
			["Enum.VRSafetyBubbleMode.Anyone"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeAnyone"
		}
		local t36 = {}

		for i, v in ipairs(EnumItems) do
			t36[i] = u24:Format(t35[tostring(v)])
		end

		local v727 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

		task.defer(function() -- line: 4064
			-- upvalues: v180 (copy), Utility (copy), u24 (ref), t36 (copy), v727 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), EnumItems (copy), GameSettings (copy)
			local v1062 = v180
			local v1063 = v180
			local v1064 = v180
			local v1065, v1066, v1067 = Utility:AddNewRow(v180, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle"), "DropDown", t36, v727, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription"))

			v1062.VRSafetyBubbleModeFrame = v1065
			v1063.VRSafetyBubbleModeLabel = v1066
			v1064.VRSafetyBubbleModeSelector = v1067
			v180.VRSafetyBubbleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSafetyBubbleModeFrame
			v180.VRSafetyBubbleModeSelector.IndexChanged:connect(function(p126) -- line: 4077
				-- upvalues: EnumItems (copy), GameSettings (copy)
				GameSettings.VRSafetyBubbleMode = EnumItems[p126]
			end)
			GameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function() -- line: 4082
				-- upvalues: EnumItems (copy), GameSettings (copy), v180 (copy)
				local v1159 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

				if v1159 ~= v180.VRSafetyBubbleModeSelector:GetSelectedIndex() then
					v180.VRSafetyBubbleModeSelector:SetSelectionIndex(v1159)
				end
			end)
		end)
	end

	v180.VoiceChatOptionsEnabled = false

	local connection4 = nil
	local connection5 = nil
	local u241 = nil

	if game:GetEngineFeature("VoiceChatSupported") and (GetFFlagEnableVrVoiceConnectDisconnect() or (not isInExperienceUIVREnabled or not isSpatial())) then
		spawn(function() -- line: 4096
			-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), default3 (copy), createVoiceChatSelector (copy), isVoiceFocused (copy), v180 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v67 (copy), VoiceVolumeControlsEligibility (copy), v125 (copy), v58 (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u234 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagVoiceChatUILogging (copy)
			if GetFFlagEnableVoiceUxUpdates() and ((not v53 and default3:EligibleForFaeUpsell() or default3:IsSeamlessVoice()) and default3:verifyUniverseAndPlaceCanUseVoice()) then
				createVoiceChatSelector()

				if isVoiceFocused() and v180.VoiceConnectDisconnectFrame then
					v180.VoiceConnectDisconnectFrame.Visible = false
				end

				observeIsVoiceFocused(function(p127) -- line: 4106
					-- upvalues: v180 (copy)
					if p127 then
						if v180.VoiceConnectDisconnectFrame then
							v180.VoiceConnectDisconnectFrame.Visible = false

							return
						end
					elseif v180.VoiceConnectDisconnectFrame then
						v180.VoiceConnectDisconnectFrame.Visible = true
					end
				end)
			end

			default3:asyncInit():andThen(function() -- line: 4119
				-- upvalues: default3 (copy), v180 (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v67 (copy), VoiceVolumeControlsEligibility (copy), v125 (copy), v58 (copy), GetFFlagEnableVoiceUxUpdates (copy), createVoiceChatSelector (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u234 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), observeIsVoiceFocused (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
				VoiceChatService = default3:getService()

				if default3:VoiceChatAvailable() then
					v180.VoiceChatOptionsEnabled = true
				end

				if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v180.VoiceChatVolumeFrame then
					local function updateVoiceChatVolumeVisibility(p128) -- line: 4123
						-- upvalues: default3 (copy), v67 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy), v125 (copy)
						local ok, result = pcall(function() -- line: 4124
							-- upvalues: default3 (copy), v67 (copy), p128 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy)
							local VoiceChatService2 = game:GetService("VoiceChatService")
							local v1217 = default3:getService()
							local v1218 = ((if not v67 then v1217 and v1217.VoiceChatState else p128 or v1217 and v1217.VoiceChatState)) == Enum.VoiceChatState.Joined
							local v1219 = VoiceChatService2 and VoiceChatService2.UseNewAudioApi

							v180.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1218, v1219)
						end)

						if not ok then
							v125:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
						end
					end

					local v1070 = nil
					local ok, result = pcall(function() -- line: 4124
						-- upvalues: default3 (copy), v67 (copy), v1070 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy)
						local VoiceChatService3 = game:GetService("VoiceChatService")
						local v1164 = default3:getService()
						local v1165 = ((if not v67 then v1164 and v1164.VoiceChatState else v1070 or v1164 and v1164.VoiceChatState)) == Enum.VoiceChatState.Joined
						local v1166 = VoiceChatService3 and VoiceChatService3.UseNewAudioApi

						v180.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1165, v1166)
					end)

					if not ok then
						v125:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
					end

					if v67 then
						default3:subscribe("OnStateChanged", function(__, p130) -- line: 4144
							-- upvalues: default3 (copy), v67 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy), v125 (copy)
							local ok2, result2 = pcall(function() -- line: 4124
								-- upvalues: default3 (copy), v67 (copy), p130 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy)
								local VoiceChatService4 = game:GetService("VoiceChatService")
								local v1221 = default3:getService()
								local v1222 = ((if not v67 then v1221 and v1221.VoiceChatState else p130 or v1221 and v1221.VoiceChatState)) == Enum.VoiceChatState.Joined
								local v1223 = VoiceChatService4 and VoiceChatService4.UseNewAudioApi

								v180.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1222, v1223)
							end)

							if not ok2 then
								v125:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result2)
							end
						end)
					else
						local v1073 = default3:getService()

						if v1073 then
							v1073.StateChanged:Connect(function() -- line: 4150
								-- upvalues: default3 (copy), v67 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy), v125 (copy)
								local v1171 = nil
								local ok3, result3 = pcall(function() -- line: 4124
									-- upvalues: default3 (copy), v67 (copy), v1171 (copy), v180 (copy), VoiceVolumeControlsEligibility (copy)
									local VoiceChatService5 = game:GetService("VoiceChatService")
									local v1225 = default3:getService()
									local v1226 = ((if not v67 then v1225 and v1225.VoiceChatState else v1171 or v1225 and v1225.VoiceChatState)) == Enum.VoiceChatState.Joined
									local v1227 = VoiceChatService5 and VoiceChatService5.UseNewAudioApi

									v180.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1226, v1227)
								end)

								if not ok3 then
									v125:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result3)
								end
							end)
						end
					end
				end

				if v58 and GetFFlagEnableVoiceUxUpdates() and default3:UserVoiceEnabled() and default3:verifyUniverseAndPlaceCanUseVoice() then
					createVoiceChatSelector()
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowNotAudiblePrompt()

					if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast then
						default3:ShowNotAudiblePromptVoiceChatVolume()
					end
				end

				if GetFFlagEnableVoiceUxUpdates() then
					if v59 and v60 then
						u234 = true
						v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
						task.defer(function() -- line: 4180
							-- upvalues: u234 (ref)
							u234 = false
						end)

						return
					end

					v180.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

					return
				end

				local u1074 = false

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
					createVoiceConnectDisconnect()

					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						u1074 = isVoiceFocused()
						observeIsVoiceFocused(function(p131) -- line: 4195
							-- upvalues: u1074 (ref), v180 (copy), default3 (copy)
							u1074 = p131

							if p131 then
								if v180.VoiceConnectFrame then
									v180.VoiceConnectFrame.Visible = false
								end

								if v180.VoiceDisconnectFrame then
									v180.VoiceDisconnectFrame.Visible = false

									return
								end
							elseif default3:ShouldShowJoinVoice() then
								if v180.VoiceConnectFrame then
									v180.VoiceConnectFrame.Visible = true
								end

								if v180.VoiceDisconnectFrame then
									v180.VoiceDisconnectFrame.Visible = false
								end
							end
						end)
					end
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceConnectFrame then
					v180.VoiceConnectFrame.Visible = false
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceDisconnectFrame then
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						v180.VoiceDisconnectFrame.Visible = not u1074
					else
						v180.VoiceDisconnectFrame.Visible = true
					end
				end

				default3.showVoiceUI.Event:Connect(function() -- line: 4228
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1074 (ref), v180 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1074 then
						return
					end

					v180.VoiceChatOptionsEnabled = true

					local v1175 = v180.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v180[t5.Input .. "DeviceFrame"] then
						v180[t5.Input .. "DeviceFrame"].Visible = v1175
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceConnectFrame then
						v180.VoiceConnectFrame.Visible = false
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceDisconnectFrame then
						v180.VoiceDisconnectFrame.Visible = true
					end
				end)
				default3.hideVoiceUI.Event:Connect(function() -- line: 4246
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1074 (ref), v180 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1074 then
						return
					end

					v180.VoiceChatOptionsEnabled = false

					local v1176 = v180.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v180[t5.Input .. "DeviceFrame"] then
						v180[t5.Input .. "DeviceFrame"].Visible = v1176
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceConnectFrame then
						v180.VoiceConnectFrame.Visible = true
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v180.VoiceDisconnectFrame then
						v180.VoiceDisconnectFrame.Visible = false
					end
				end)
			end):catch(function() -- line: 4266
				-- upvalues: GetFFlagVoiceChatUILogging (copy), v125 (copy), GetFFlagEnableUniveralVoiceToasts (copy), default3 (copy)
				if GetFFlagVoiceChatUILogging() then
					v125:warning("Failed to init VoiceChatServiceManager")
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowPermissionPrompt()
				end
			end)
		end)
	end

	if GetFFlagEnableCrossExpVoice() and (not isInExperienceUIVREnabled or not isSpatial()) then
		connection4 = default4.ExperienceJoined.Event:Connect(function() -- line: 4279
			-- upvalues: v180 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v728 = v180.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v180[t5.Input .. "DeviceFrame"] then
				v180[t5.Input .. "DeviceFrame"].Visible = v728
			end
		end)
		connection5 = default4.ExperienceLeft.Event:Connect(function() -- line: 4282
			-- upvalues: v180 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v729 = v180.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v180[t5.Input .. "DeviceFrame"] then
				v180[t5.Input .. "DeviceFrame"].Visible = v729
			end
		end)

		function u241() -- line: 4285
			-- upvalues: connection4 (ref), connection5 (ref)
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end
		end
	end

	v180.VideoOptionsEnabled = false

	local u242 = nil

	if GetFFlagSelfViewCameraSettings() and (not isInExperienceUIVREnabled or not isSpatial()) and isCamEnabledForUserAndPlace() then
		getCamMicPermissions(function(p132) -- line: 4307
			-- upvalues: v180 (copy)
			v180.VideoOptionsEnabled = p132.hasCameraPermissions
		end, { default.Permissions.CAMERA_ACCESS }, true)

		if u242 then
			u242:disconnect()
		end

		u242 = cameraDevicePermissionGrantedSignal:connect(function() -- line: 4323
			-- upvalues: v180 (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref)
			v180.VideoOptionsEnabled = true
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3567
					-- upvalues: v180 (copy), updateCameraDevices (copy)
					if v180.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end)
	end

	if not isInExperienceUIVREnabled then
		createCameraModeOptions(not v115 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))
	end

	if UserInputService.MouseEnabled then
		createMouseOptions()
	elseif UserInputService.GamepadEnabled then
		if GameSettings.IsUsingGamepadCameraSensitivity then
			createGamepadOptions()
		else
			local u243 = nil

			u243 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4345
				-- upvalues: GameSettings (copy), u243 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u243 then
						u243:disconnect()
					end

					createGamepadOptions()
				end
			end)
		end
	else
		local u244 = nil

		u244 = UserInputService.GamepadConnected:connect(function() -- line: 4363
			-- upvalues: u244 (ref), GameSettings (copy), createGamepadOptions (copy)
			if u244 then
				u244:disconnect()
			end

			if GameSettings.IsUsingGamepadCameraSensitivity then
				createGamepadOptions()

				return
			end

			local u732 = nil

			u732 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4345
				-- upvalues: GameSettings (copy), u732 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u732 then
						u732:disconnect()
					end

					createGamepadOptions()
				end
			end)
		end)
	end

	if not isInExperienceUIVREnabled then
		if GameSettings.IsUsingCameraYInverted then
			createCameraInvertedOptions()
		else
			local u245 = nil

			u245 = GameSettings.Changed:connect(function(p133) -- line: 4377
				-- upvalues: GameSettings (copy), u245 (ref), createCameraInvertedOptions (copy)
				if p133 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
					u245:disconnect()
					createCameraInvertedOptions()
				end
			end)
		end
	end

	if isInExperienceUIVREnabled then
		if isSpatial() then
			createVRComfortSettingOptions()
			createVRSafetyBubbleModeOptions()
		else
			createCameraModeOptions(not v115 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))

			if GameSettings.IsUsingCameraYInverted then
				createCameraInvertedOptions()
			else
				local u246 = nil

				u246 = GameSettings.Changed:connect(function(p134) -- line: 4406
					-- upvalues: GameSettings (copy), u246 (ref), createCameraInvertedOptions (copy)
					if p134 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
						u246:disconnect()
						createCameraInvertedOptions()
					end
				end)
			end

			createReducedMotionOptions()
			createPreferredTransparencyOptions()
		end
	end

	createVolumeOptions()

	if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		createVoiceChatVolumeOptions()
	end

	if v69 and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		local u247 = false

		v180.Displayed.Event:Connect(function() -- line: 4429
			-- upvalues: u247 (ref), v180 (copy), default3 (copy)
			u247 = true

			if v180.VoiceChatVolumeFrame and v180.VoiceChatVolumeFrame.Visible then
				default3:RecordGameSettingsOpened()
			end
		end)
		v180.Hidden.Event:Connect(function() -- line: 4436
			-- upvalues: u247 (ref)
			u247 = false
		end)
		v180.VoiceChatVolumeFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 4440
			-- upvalues: v180 (copy), u247 (ref), default3 (copy)
			if v180.VoiceChatVolumeFrame.Visible and u247 then
				default3:RecordGameSettingsOpened()
			end
		end)
	end

	if v75 then
		createPartyVoiceVolumeOptions()
	end

	createHapticsToggle()
	createGraphicsOptions()

	if v46 and GetFFlagEnablePlayerNamesEnabledSetting() then
		createPlayerNamesEnabledOptions()
	end

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		PlayerChoiceTranslationSettingInitializer(v180, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
	end

	if not isInExperienceUIVREnabled then
		createReducedMotionOptions()
		createPreferredTransparencyOptions()
	end

	createPreferredTextSizeOptions()
	createUiNavigationKeyBindOptions()

	if not CachedPolicyService:IsSubjectToChinaPolicies() then
		createPerformanceStatsOptions()
	end

	if v130 then
		createMicroProfilerOptions()
	end

	if v115 and getAppFeaturePolicies().getSupportsOverscan() then
		createOverscanOption()
	end

	if v46 and FFlagBadgeVisibilitySettingEnabled then
		spawn(function() -- line: 3163
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v148 (copy), v180 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n15 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n15 = 1
			end

			local v736 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v737 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v738 = if not v148 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v739 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v740 = v180
			local v741 = v180
			local v742 = v180
			local v743, v744, v745 = Utility:AddNewRow(v180, v738, "Selector", {
				v737,
				v736
			}, n15, nil, v739)

			v740.badgeVisibleRow = v743
			v741.badgeVisibleFrame = v744
			v742.badgeVisibleSelector = v745
			v180.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v180.badgeVisibleSelector.IndexChanged:connect(function(p135) -- line: 3177
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p135 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p135 == 1)
			end)
		end)
	end

	if FFlagEnableModerateChatRemoteEvent then
		createChatModerationOptions()
	end

	if FFlagAIRephraseSettingEnabled then
		createAIRephraseSettingOptions()
	end

	if FFlagChatSummariesSettingEnabled then
		createChatSummariesSettingOptions()
	end

	createDeveloperConsoleOption()
	GetHasGuiHidingPermission(RunService:IsStudio(), LocalPlayer, PlayerPermissionsModule):andThen(function(p136) -- line: 4501
		-- upvalues: createUiToggleOptions (copy)
		if p136 then
			createUiToggleOptions()
		end
	end):catch(function(p137) -- line: 4506
		warn(p137)
	end)
	u181 = true

	if VRService.VREnabled then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	if FFlagIEMSettingsGroups then
		v180.AudioHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.AudioHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioHeader,
			parent = v180.Page
		})
		v180.AudioDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioDivider,
			parent = v180.Page
		})
		v180.DisplayHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.DisplayHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayHeader,
			parent = v180.Page
		})
		v180.DisplayDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayDivider,
			parent = v180.Page
		})

		if not isSpatial() then
			v180.LanguageHeader = renderSettingsHeader({
				headerText = "CoreScripts.InGameMenu.GameSettings.LanguageHeader",
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageHeader,
				parent = v180.Page
			})
			v180.LanguageDivider = renderSettingsDivider({
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageDivider,
				parent = v180.Page
			})
		end

		v180.ViewAndControlsHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.ViewandControlsHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ViewAndControlsHeader,
			parent = v180.Page
		})
	end

	v180.TabHeader.Name = "GameSettingsTab"

	local v251 = Migration.uiblox["icons/common/settings"]

	v180.TabHeader.TabLabel.Icon.Text = v251.name
	v180.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v251.variant]
	v180.TabHeader.TabLabel.Title.Text = "Settings"
	v180.Page.ZIndex = 5

	if v180.PageListLayout then
		v180.PageListLayout.Padding = UDim.new(0, 0)
	end

	v180.PageOpen = false

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		v180.FeedbackEntryPointEnabled = true
	end

	local function staticFeedbackEntryPointChecksPassed() -- line: 4575
		-- upvalues: RunService (copy), v141 (copy), v115 (copy)
		if RunService:IsStudio() then
			return false
		end

		if game:GetEngineFeature("CaptureModeEnabled") == false then
			return false
		end

		if v141 and v115 then
			return false
		end

		return true
	end

	function v180.OpenSettingsPage() -- line: 4591
		-- upvalues: v180 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), updateAudioOptions (copy), SoundService (copy), connection (ref), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), GetFFlagSelfViewCameraSettings (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref), updateUiToggleSelection (copy), ExperienceStateCaptureService (ref), v87 (copy), Theme (copy), v86 (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy)
		v180.PageOpen = true

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if GetFFlagLazyInitiateExperienceLanguageSwitcher() and not v180.LanguageSwitcherInitialized and isLangaugeSelectionDropdownEnabled() and GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
			v180.LanguageSwitcherInitialized = true
			ExperienceLanguageSwitcherInitializer(v180, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		updateAudioOptions()

		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3557
				-- upvalues: v180 (copy), updateAudioOptions (copy)
				if v180.PageOpen then
					updateAudioOptions()
				end
			end)
		end

		v180.startVolume = GameSettings.MasterVolume

		if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
			v180.maxVoiceChatVolumeDuringSession = GameSettings.VoiceChatVolume
		end

		if GetFFlagSelfViewCameraSettings() and v180.VideoOptionsEnabled and game:GetEngineFeature("VideoCaptureService") then
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3567
					-- upvalues: v180 (copy), updateCameraDevices (copy)
					if v180.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end

		updateUiToggleSelection()

		if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and v180.toggleFeedbackModeButton and v180.toggleFeedbackModeText then
			v180.FeedbackEntryPointEnabled = ExperienceStateCaptureService ~= nil and ExperienceStateCaptureService:CanEnterCaptureMode()

			if v180.FeedbackEntryPointEnabled then
				v180.toggleFeedbackModeButton.Active = true
				v180.toggleFeedbackModeButton.Enabled.Value = true
				v180.toggleFeedbackModeText.Text = v87
			else
				v180.toggleFeedbackModeButton.Active = false
				v180.toggleFeedbackModeButton.Enabled.Value = false
				v180.toggleFeedbackModeText.TextColor3 = Theme.color("ButtonNonInteractable", Color3.fromRGB(100, 100, 100))
				v180.toggleFeedbackModeText.Text = v86
			end
		end

		if FFlagIEMFocusNavToButtons then
			table.insert(v180.LastSelectableObjects, getLastValueChangerFrame(v180))
		end

		if FFlagIEMTabFocusNav then
			table.insert(v180.FirstSelectableObjects, getFirstValueChangerFrame(v180))
			v180.FirstSelectableObjectsUpdated:fire()
		end
	end
	function v180.CloseSettingsPage() -- line: 4662
		-- upvalues: v180 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), SoundService (copy), connection (ref), GetFFlagEnableCrossExpVoice (copy), u241 (ref), GetFFlagSelfViewCameraSettings (copy), VideoCaptureService (copy), connection2 (ref), u242 (ref), default3 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy)
		v180.PageOpen = false

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end

		if GetFFlagEnableCrossExpVoice() and u241 then
			u241()
		end

		if GetFFlagSelfViewCameraSettings() then
			if game:GetEngineFeature("VideoCaptureService") and VideoCaptureService.DevicesChanged and connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u242 then
				u242:disconnect()
				u242 = nil
			end
		end

		if game:GetEngineFeature("VoiceChatSupported") and v180.VoiceChatOptionsEnabled and v180.startVolume ~= nil and v180.startVolume > 0 then
			default3:CheckAndShowNotAudiblePrompt()
		end

		if game:GetEngineFeature("VoiceChatSupported") and v180.VoiceChatOptionsEnabled and FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v180.maxVoiceChatVolumeDuringSession ~= nil and v180.maxVoiceChatVolumeDuringSession > 0 then
			default3:ShowNotAudiblePromptVoiceChatVolume()
		end
	end
	function isLangaugeSelectionDropdownEnabled() -- line: 4706
		-- upvalues: LocalPlayer (copy)
		if game:GetEngineFeature("EnableSetExperienceSettingsLocaleIdApi") ~= true then
			return false
		end

		if LocalPlayer.UserId % 1000 + 1 <= game:GetFastInt("V1MenuLanguageSelectionFeaturePerMillageRollout") then
			return true
		end

		for match in game:GetFastString("V1MenuLanguageSelectionFeatureForcedUserIds"):gmatch("%d+") do
			if tonumber(match) == LocalPlayer.UserId then
				return true
			end
		end

		return false
	end
	function v180.SetHub(__, p139) -- line: 4729
		-- upvalues: v180 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), createTranslationOptions (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), getChatTranslationLayerData (copy), EngineFeature (copy), GetFFlagChatTranslationNewDefaults (copy), GameSettings (copy), TextChatService (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy), RunService (copy), v141 (copy), v115 (copy), createFeedbackModeOptions (copy)
		v180.HubRef = p139

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if isLangaugeSelectionDropdownEnabled() then
			if GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
				if not GetFFlagLazyInitiateExperienceLanguageSwitcher() then
					ExperienceLanguageSwitcherInitializer(v180, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
				end
			else
				createTranslationOptions()
			end
		end

		if game:GetEngineFeature("EnableTCSChatTranslation") and GetFFlagChatTranslationSettingEnabled() then
			if GetFFlagChatTranslationHoldoutEnabled() then
				local v751 = GetFStringChatTranslationLayerName()

				if not getChatTranslationLayerData(v751).ChatTranslationEnabled then
					if EngineFeature then
						if GetFFlagChatTranslationNewDefaults() then
							if GameSettings.ChatTranslationLocale == "" then
								GameSettings.ChatTranslationEnabled = false
								GameSettings.ChatTranslationLocale = "en_us"
							end
						else
							GameSettings.ChatTranslationEnabled = false
						end
					else
						pcall(function() -- line: 4767
							-- upvalues: TextChatService (copy)
							TextChatService.ChatTranslationEnabled = false
						end)
					end
				elseif GetFFlagChatTranslationForceSetting() then
					GameSettings.ChatTranslationEnabled = true
				end
			end

			ChatTranslationOptionsWithChatLanguageSwitcherInitializer(v180, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		if not RunService:IsStudio() and (game:GetEngineFeature("CaptureModeEnabled") ~= false and (not v141 or not v115)) then
			createFeedbackModeOptions()
		end
	end

	return v180
end

return (Initialize())
