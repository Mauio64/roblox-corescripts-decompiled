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
local FFlagRenameVolumeToMainVolume = require(RobloxGui.Modules.Flags.FFlagRenameVolumeToMainVolume)
local FFlagAIRephraseSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagVoiceRewarmTelemetry = SharedFlags.FFlagVoiceRewarmTelemetry
local v66 = game:DefineFastFlag("DebounceVoiceSelectorIndexChange", false)
local v67 = game:DefineFastFlag("VoiceSelectorIgnoreFailedStateDisconnect", false)
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local v69 = game:DefineFastFlag("VoiceVolumeControlsFixSliderVisibilityOnEligibleGames", false)
local v70 = game:DefineFastFlag("VoiceVolumeControlsDisableInteractionWhenNoMasterVolume", false)
local v71 = require(CorePackages.Workspace.Packages.VoiceChatCore).Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()
local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(RobloxGui.Modules.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)
local v73 = game:DefineFastFlag("VoiceVolumeControlsSuppressInExperienceUiForPartyVoice", false)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local GameSettingsConstants = require(RobloxGui.Modules.Settings.Resources.GameSettingsConstants)
local v78 = default2 and default2.getHasPartyVoiceVolume()
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

local function voiceChatVolumeToSlider(n1: number) -- line: 143
	return (math.floor(n1 * 5 + 0.5))
end
local function voiceChatVolumeFromSlider(n2: number) -- line: 147
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
local v88 = RobloxTranslator:FormatByKey("Feature.SettingsHub.TouchMovementMode.ClassicThumbstick")
local v89 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")
local v90 = RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.ButtonText")
local t7 = {
	On = 1,
	Off = 2
}

local function getDefaultCameraMode() -- line: 190
	-- upvalues: UserInputService (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Default (Follow)"
	end

	return "Default (Classic)"
end
local function getDefaultMovementMode() -- line: 199
	-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
	end

	return "Default (Keyboard)"
end
local function getDefaultSelectToMove() -- line: 208
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

local v118 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local LocalPlayer = Players.LocalPlayer
local Platform = UserInputService:GetPlatform()
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local default3 = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceVolumeControlsEligibility = require(CorePackages.Workspace.Packages.VoiceChatCore).VoiceVolumeControlsEligibility
local default4 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).CrossExperienceVoiceManager.default
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v126 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.SystemDefault")
local v127 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.VideoCamera")
local v128 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

game:DefineFastInt("RomarkStartWithGraphicQualityLevel", -1)

local FastInt = game:GetFastInt("RomarkStartWithGraphicQualityLevel")
local v130 = not CachedPolicyService:IsSubjectToChinaPolicies()
local v131 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
local v132 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local v133 = if not isInExperienceUIVREnabled then (v132 or v131) and v130 else (v132 or (v131 or isSpatial())) and v130
local GetFIntVoiceChatDeviceChangeDebounceDelay = require(RobloxGui.Modules.Flags.GetFIntVoiceChatDeviceChangeDebounceDelay)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableExplicitSettingsChangeAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableExplicitSettingsChangeAnalytics)
local GetFFlagFixCyclicFullscreenIndexEvent = require(RobloxGui.Modules.Settings.Flags.GetFFlagFixCyclicFullscreenIndexEvent)
local v140 = game:DefineFastFlag("DisableFeedbackSoothsayerCheck", false)
local v141 = game:DefineFastFlag("UserShowGuiHideToggles", false)
local v142 = game:DefineFastFlag("UserFreecamGuiDestabilization", false)
local v143 = game:DefineFastFlag("FixDeveloperConsoleButtonSizeAndPositioning", false)
local v144 = game:DefineFastFlag("EnableTFFeedbackModeEntryCheck", false)
local v145 = game:DefineFastFlag("FeedbackEntryPointButtonSizeAdjustment2", false)
local v146 = game:DefineFastFlag("FeedbackEntryPointImprovedStrictnessCheck", false)
local GetFFlagEnableLocalesForExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLocalesForExperienceLanguageSwitcher)
local GetFFlagLazyInitiateExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagLazyInitiateExperienceLanguageSwitcher)
local ExperienceLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ExperienceLanguageSwitcherInitializer)
local PlayerChoiceTranslationSettingInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.PlayerChoiceTranslationSettingInitializer)
local v151 = game:DefineFastFlag("UpdateVisibilitySettingsCopy", false)
local v152 = game:DefineFastFlag("ExpChatDebounceRephraseIndexSelection", false)
local v153 = game:DefineFastFlag("EraseFPSFromDefaultSetting", false)

local function reportSettingsChangeForAnalytics(p1, p2, p3, p4) -- line: 335
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
local function reportSettingsForAnalytics() -- line: 366
	-- upvalues: UserInputService (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), EngineFeature2 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), RbxAnalyticsService (copy), Constants (copy)
	local t9 = {}
	local v168 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

	if v168 then
		t9.camera_mode_touch = tostring(GameSettings.TouchCameraMovementMode)
	else
		t9.camera_mode_desktop = tostring(GameSettings.ComputerCameraMovementMode)
	end

	if v168 then
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

local v156 = game:DefineFastFlag("IGMEnableGFXReset", false)

local function getLastValueChangerFrame(p5) -- line: 435
	-- upvalues: FFlagIEMFocusNavToButtons (copy)
	if not FFlagIEMFocusNavToButtons then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v173 = nil

	for __, v in pairs(p5:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder <= SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v173 = p5:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v173
end
local function getFirstValueChangerFrame(p6) -- line: 454
	-- upvalues: FFlagIEMTabFocusNav (copy)
	if not FFlagIEMTabFocusNav then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v179 = nil

	for __, v in pairs(p6:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder > SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v179 = p6:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v179
end
local function Initialize() -- line: 473
	-- upvalues: v156 (copy), GfxReset (copy), RobloxGui (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), VRService (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), v153 (copy), RobloxTranslator (copy), FastInt (copy), t1 (copy), v151 (copy), FFlagUpdatePeopleNamesSettingCopy (copy), t7 (copy), UserInputService (copy), Create (copy), Theme (copy), v54 (copy), v56 (copy), TouchEnabled (copy), v132 (copy), v131 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), LocalPlayer (copy), CoreUtility (copy), t4 (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), t6 (copy), v88 (copy), t3 (copy), t2 (copy), Url (copy), HttpService (copy), v146 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), v145 (copy), v90 (copy), v140 (copy), v128 (copy), Players (copy), v89 (copy), RunService (copy), GetFFlagChatTranslationWaitForIXP (copy), IXPServiceWrapper (copy), GetFFlagChatTranslationNewDefaults (copy), FFlagRenameVolumeToMainVolume (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), u24 (ref), v70 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), CorePackages (copy), ContextActionService (copy), v143 (copy), PlayerPermissionsModule (copy), v142 (copy), v141 (copy), SoundService (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), GetFFlagEnableCrossExpVoice (copy), Signals (copy), GetFIntDebounceAIRephraseSettingDelay (copy), TextChatService (copy), v152 (copy), ThrottleFunctionCall (copy), GetFIntDebounceChatSummariesSettingDelay (copy), v127 (copy), UserGameSettings (copy), GetFFlagVoiceChatUILogging (copy), VideoCaptureService (copy), v126 (copy), v59 (copy), v58 (copy), v52 (copy), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v67 (copy), v55 (copy), v66 (copy), v60 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), GetFFlagEnableVrVoiceConnectDisconnect (copy), GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v69 (copy), v73 (copy), VoiceVolumeControlsEligibility (copy), GetFFlagEnableUniveralVoiceToasts (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), t5 (copy), GetFFlagSelfViewCameraSettings (copy), isCamEnabledForUserAndPlace (copy), getCamMicPermissions (copy), default (copy), cameraDevicePermissionGrantedSignal (copy), v118 (copy), v71 (copy), v78 (copy), v46 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), PlayerChoiceTranslationSettingInitializer (copy), CachedPolicyService (copy), v133 (copy), FFlagBadgeVisibilitySettingEnabled (copy), FFlagEnableModerateChatRemoteEvent (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), FFlagExpChatEnableFriendsTab (copy), GetHasGuiHidingPermission (copy), FFlagIEMSettingsGroups (copy), renderSettingsHeader (ref), renderSettingsDivider (ref), Migration (copy), BuilderIcons (copy), v144 (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), EngineFeature (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy)
	if v156 then
		GfxReset.RunGfxReset()
	end

	local v183 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	if GetFFlagLazyInitiateExperienceLanguageSwitcher() then
		v183.LanguageSwitcherInitialized = false
	end

	local u184 = false
	local t10 = {}

	local function onVRSettingsReady() -- line: 486
		-- upvalues: VRService (copy), t10 (copy)
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end
	local function onVREnabled() -- line: 493
		-- upvalues: VRService (copy), u184 (ref), t10 (copy)
		if VRService.VREnabled and u184 then
			local VREnabled = VRService.VREnabled

			for k, __ in pairs(t10) do
				k.Visible = not VREnabled
			end
		end
	end

	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)

	if VRService.VREnabled and u184 then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	local function createGraphicsOptions() -- line: 505
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), VRService (copy), v153 (copy), RobloxTranslator (copy), v156 (copy), GfxReset (copy), FastInt (copy), t1 (copy)
		local n3 = 1

		if not GameSettings:InFullScreen() then
			n3 = 2
		end

		local v264 = v183
		local v265 = v183
		local v266 = v183
		local v267, v268, v269 = Utility:AddNewRow(v183, "Fullscreen", "Selector", {
			"On",
			"Off"
		}, n3)

		v264.FullscreenFrame = v267
		v265.FullscreenLabel = v268
		v266.FullscreenEnabler = v269
		v183.FullscreenFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FullScreenFrame
		t10[v183.FullscreenFrame] = true
		v183.FullscreenEnabler.IndexChanged:connect(function(p7) -- line: 518
			-- upvalues: GameSettings (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), v183 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v775 = GameSettings:InFullScreen()

			if p7 == 1 then
				if not GameSettings:InFullScreen() then
					GuiService:ToggleFullscreen()

					if GetFFlagFixCyclicFullscreenIndexEvent() then
						if v183.FullscreenEnabler.GetSelectedIndex() ~= 1 then
							v183.FullscreenEnabler:SetSelectionIndex(1)
						end
					else
						v183.FullscreenEnabler:SetSelectionIndex(1)
					end
				end
			elseif p7 == 2 and GameSettings:InFullScreen() then
				GuiService:ToggleFullscreen()

				if GetFFlagFixCyclicFullscreenIndexEvent() then
					if v183.FullscreenEnabler.GetSelectedIndex() ~= 2 then
						v183.FullscreenEnabler:SetSelectionIndex(2)
					end
				else
					v183.FullscreenEnabler:SetSelectionIndex(2)
				end
			end

			spawn(function() -- line: 543
				-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), v775 (copy), GameSettings (copy), reportSettingsForAnalytics (copy)
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("fullscreen_enabled", v775, GameSettings:InFullScreen())
				end

				reportSettingsForAnalytics()
			end)
		end)
		GameSettings.FullscreenChanged:connect(function(p8) -- line: 551
			-- upvalues: v183 (copy), RbxAnalyticsService (copy), Constants (copy)
			if p8 then
				if v183.FullscreenEnabler:GetSelectedIndex() ~= 1 then
					v183.FullscreenEnabler:SetSelectionIndex(1)
				end
			elseif v183.FullscreenEnabler:GetSelectedIndex() ~= 2 then
				v183.FullscreenEnabler:SetSelectionIndex(2)
			end

			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
				enabled = p8
			})
		end)

		local n4 = 1

		if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			n4 = 2
		end

		local v271 = v183
		local v272 = v183
		local v273 = v183
		local v274, v275, v276 = Utility:AddNewRow(v183, "Graphics Mode", "Selector", {
			"Automatic",
			"Manual"
		}, n4)

		v271.GraphicsEnablerFrame = v274
		v272.GraphicsEnablerLabel = v275
		v273.GraphicsQualityEnabler = v276
		v183.GraphicsEnablerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsEnablerFrame

		local v277 = v183
		local v278 = v183
		local v279 = v183
		local v280, v281, v282 = Utility:AddNewRow(v183, "Graphics Quality", "Slider", 10, 1)

		v277.GraphicsQualityFrame = v280
		v278.GraphicsQualityLabel = v281
		v279.GraphicsQualitySlider = v282
		v183.GraphicsQualityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsQualityFrame
		v183.GraphicsQualitySlider:SetMinStep(1)

		if EngineFeature2 and not VRService.VREnabled then
			local v283 = table.clone(Constants.FramerateCaps)
			local t11 = { if not v153 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateCapDefaultEntry", {
				Frames = GameSettings:GetDefaultFramerateCap()
			}) else RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.Default") }

			for __, v286 in v283 do
				table.insert(t11, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateEntry", {
					Frames = v286
				}))
			end

			table.insert(v283, 1, -1)
			task.defer(function() -- line: 617
				-- upvalues: v183 (copy), Utility (copy), RobloxTranslator (copy), t11 (copy), v283 (copy), GameSettings (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
				local v777 = v183
				local v778 = v183
				local v779 = v183
				local v780, v781, v782 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate"), "DropDown", t11, table.find(v283, GameSettings.FramerateCap), nil, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate.Description"))

				v777.FramerateCapFrame = v780
				v778.FramerateCapLabel = v781
				v779.FramerateCapMode = v782
				v183.FramerateCapFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FramerateCap
				v183.FramerateCapMode.IndexChanged:Connect(function(p9) -- line: 629
					-- upvalues: GameSettings (copy), v283 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
					local FramerateCap = GameSettings.FramerateCap

					GameSettings.FramerateCap = v283[p9]

					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						reportSettingsChangeForAnalytics("framerate_cap", FramerateCap, GameSettings.FramerateCap)
					end

					reportSettingsForAnalytics()
				end)
			end)
		end

		settings().Rendering.EnableFRM = true

		function SetGraphicsQuality(p10, p11) -- line: 647
			-- upvalues: v156 (copy), GfxReset (copy), GameSettings (copy)
			if v156 then
				local v785, v786 = GfxReset.TemporaryOverride(p10)

				if v785 then
					settings().Rendering.QualityLevel = v786

					return
				end
			end

			local v787 = p10 / 10
			local v788 = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * v787)

			if v788 == 20 then
				v788 = 21
			elseif p10 == 1 then
				v788 = 1
			elseif p10 < 1 and not p11 then
				p10 = 1
				v788 = 1
			elseif v788 > settings().Rendering:GetMaxQualityLevel() then
				v788 = settings().Rendering:GetMaxQualityLevel() - 1
			end

			GameSettings.SavedQualityLevel = p10
			settings().Rendering.QualityLevel = v788
		end

		local function setGraphicsToAuto() -- line: 673
			-- upvalues: v183 (copy)
			v183.GraphicsQualitySlider:SetZIndex(1)
			v183.GraphicsQualityLabel.ZIndex = 1
			v183.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		end
		local function setGraphicsToManual(p12) -- line: 681
			-- upvalues: v183 (copy)
			v183.GraphicsQualitySlider:SetZIndex(2)
			v183.GraphicsQualityLabel.ZIndex = 2
			v183.GraphicsQualitySlider:SetInteractable(true)

			if p12 == v183.GraphicsQualitySlider:GetValue() then
				SetGraphicsQuality(p12)

				return
			end

			v183.GraphicsQualitySlider:SetValue(p12)
		end

		local u289 = false

		v183.GraphicsQualitySlider.ValueChanged:connect(function(p13) -- line: 695
			-- upvalues: u289 (ref), reportSettingsForAnalytics (copy)
			SetGraphicsQuality(p13)

			if u289 == true then
				reportSettingsForAnalytics()
			end

			u289 = true
		end)
		v183.GraphicsQualityEnabler.IndexChanged:connect(function(p14) -- line: 703
			-- upvalues: v183 (copy), setGraphicsToManual (copy), reportSettingsForAnalytics (copy), reportSettingsChangeForAnalytics (copy)
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
				v183.GraphicsQualitySlider:SetZIndex(1)
				v183.GraphicsQualityLabel.ZIndex = 1
				v183.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			elseif p14 == t12.Manual.Value then
				setGraphicsToManual(v183.GraphicsQualitySlider:GetValue())
			end

			reportSettingsForAnalytics()
			reportSettingsChangeForAnalytics("gfx_mode", AutomaticName, ManualName)
		end)
		game.GraphicsQualityChangeRequest:Connect(function(p15) -- line: 721
			-- upvalues: GameSettings (copy), v183 (copy)
			if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
				local Value = v183.GraphicsQualitySlider:GetValue()
				local v797 = if not p15 then Value - 1 else Value + 1

				v183.GraphicsQualitySlider:SetValue(v797)
			end
		end)

		if FastInt >= 0 then
			if FastInt == 0 then
				v183.GraphicsQualityEnabler:SetSelectionIndex(1)
				v183.GraphicsQualitySlider:SetZIndex(1)
				v183.GraphicsQualityLabel.ZIndex = 1
				v183.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			else
				v183.GraphicsQualityEnabler:SetSelectionIndex(2)
				setGraphicsToManual(FastInt)
			end
		elseif GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			v183.GraphicsQualitySlider:SetValue(5)
			v183.GraphicsQualitySlider:SetZIndex(1)
			v183.GraphicsQualityLabel.ZIndex = 1
			v183.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		else
			local str = tostring(GameSettings.SavedQualityLevel)
			local u291 = not t1[str] and 10 or t1[str]

			SetGraphicsQuality(u291)
			spawn(function() -- line: 754
				-- upvalues: v183 (copy), u291 (ref)
				v183.GraphicsQualitySlider:SetValue(u291)
			end)
		end
	end
	local function createReducedMotionOptions() -- line: 760
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n5 = 2

		if GameSettings.ReducedMotion then
			n5 = 1
		end

		local v293 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.ReducedMotion")
		local v294 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.ReducedMotion")
		local v295 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v296 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v297 = v183
		local v298 = v183
		local v299 = v183
		local v300, v301, v302 = Utility:AddNewRow(v183, v293, "Selector", {
			v295,
			v296
		}, n5, nil, v294)

		v297.ReducedMotionFrame = v300
		v298.ReducedMotionLabel = v301
		v299.ReducedMotionMode = v302
		v183.ReducedMotionFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ReducedMotionFrame
		v183.ReducedMotionMode.IndexChanged:connect(function(p16) -- line: 782
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local ReducedMotion = GameSettings.ReducedMotion

			GameSettings.ReducedMotion = p16 == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("reduced_motion", ReducedMotion, GameSettings.ReducedMotion)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPlayerNamesEnabledOptions() -- line: 793
		-- upvalues: v151 (copy), RobloxTranslator (copy), FFlagUpdatePeopleNamesSettingCopy (copy), GameSettings (copy), t7 (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v303 = if not v151 then if not FFlagUpdatePeopleNamesSettingCopy then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PlayerNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeoplesNames")
		local v304 = if not FFlagUpdatePeopleNamesSettingCopy then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames.Description")

		local function GetPlayerNamesEnabledStartIndex() -- line: 801
			-- upvalues: GameSettings (copy)
			if GameSettings.PlayerNamesEnabled then
				return 1
			end

			return 2
		end

		local v306 = if not GameSettings.PlayerNamesEnabled then t7.Off else t7.On
		local v307 = if not v151 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
		local v308 = if not v151 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
		local v309 = v183
		local v310 = v183
		local v311 = v183
		local v312, v313, v314 = Utility:AddNewRow(v183, v303, "Selector", {
			v307,
			v308
		}, v306, nil, v304)

		v309.PlayerNamesEnabledFrame = v312
		v310.playerNamesEnabledLabel = v313
		v311.playerNamesEnabledMode = v314
		v183.PlayerNamesEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PlayerNamesEnabledFrame
		v183.playerNamesEnabledMode.IndexChanged:connect(function(p17) -- line: 820
			-- upvalues: GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PlayerNamesEnabled = GameSettings.PlayerNamesEnabled

			GameSettings.PlayerNamesEnabled = p17 == 1
			reportSettingsChangeForAnalytics("player_names_enabled", PlayerNamesEnabled, GameSettings.PlayerNamesEnabled)
			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTransparencyOptions() -- line: 829
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v315 = 10 - math.clamp(math.floor(GameSettings.PreferredTransparency * 10 + 0.5), 0, 10)
		local v316 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTransparency")
		local v317 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTransparency")
		local v318 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Transparent")
		local v319 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Opaque")
		local v320 = v183
		local v321 = v183
		local v322 = v183
		local v323, v324, v325 = Utility:AddNewRow(v183, v316, "Slider", 10, v315, nil, v317, v318, v319)

		v320.PreferredTransparencyFrame = v323
		v321.PreferredTransparencyLabel = v324
		v322.PreferredTransparencySlider = v325
		v183.PreferredTransparencyFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTransparencyFrame
		v183.PreferredTransparencySlider.ValueChanged:connect(function(p18) -- line: 855
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v803 = (10 - math.clamp(math.floor(p18), 0, 10)) / 10
			local PreferredTransparency = GameSettings.PreferredTransparency

			GameSettings.PreferredTransparency = v803

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_transparency", PreferredTransparency, GameSettings.PreferredTransparency)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTextSizeOptions() -- line: 867
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local EnumItems = Enum.PreferredTextSize:GetEnumItems()
		local v327 = GameSettings.PreferredTextSize.Value - 1
		local v328 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTextSize")
		local v329 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTextSize")
		local v330 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Default")
		local v331 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Largest")
		local v332 = v183
		local v333 = v183
		local v334 = v183
		local v335, v336, v337 = Utility:AddNewRow(v183, v328, "Slider", 3, v327, nil, v329, v330, v331)

		v332.PreferredTextSizeFrame = v335
		v333.PreferredTextSizeLabel = v336
		v334.PreferredTextSizeSlider = v337
		v183.PreferredTextSizeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTextSizeFrame
		v183.PreferredTextSizeSlider.ValueChanged:connect(function(p19) -- line: 892
			-- upvalues: GameSettings (copy), EnumItems (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PreferredTextSize = GameSettings.PreferredTextSize

			GameSettings.PreferredTextSize = EnumItems[p19 + 1]

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_text_size", PreferredTextSize, GameSettings.PreferredTextSize)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createUiNavigationKeyBindOptions() -- line: 902
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), UserInputService (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local t13 = {
			On = 1,
			Off = 2
		}
		local Off = t13.Off

		if GameSettings.UiNavigationKeyBindEnabled then
			Off = t13.On
		end

		local v340 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.UiNavigationKeyBind")
		local v341 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.UiNavigationKeyBind", {
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})
		local v342 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v343 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v344 = v183
		local v345 = v183
		local v346 = v183
		local v347, v348, v349 = Utility:AddNewRow(v183, v340, "Selector", {
			v342,
			v343
		}, Off, nil, v341)

		v344.UiNavigationKeyBindEnabledFrame = v347
		v345.UiNavigationKeyBindEnabledLabel = v348
		v346.UiNavigationKeyBindEnabledMode = v349
		v183.UiNavigationKeyBindEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame
		v183.UiNavigationKeyBindEnabledMode.IndexChanged:connect(function(p20) -- line: 933
			-- upvalues: GameSettings (copy), t13 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local UiNavigationKeyBindEnabled = GameSettings.UiNavigationKeyBindEnabled

			GameSettings.UiNavigationKeyBindEnabled = p20 == t13.On

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("ui_navigation_key_bind_enabled", UiNavigationKeyBindEnabled, GameSettings.UiNavigationKeyBindEnabled)
			end

			reportSettingsForAnalytics()
		end)

		local function updateUiNavigationKeyBindVisibility() -- line: 946
			-- upvalues: UserInputService (copy), v183 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled = UserInputService.KeyboardEnabled

			if v183.UiNavigationKeyBindEnabledFrame then
				v183.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

				if KeyboardEnabled then
					v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		local KeyboardEnabled = UserInputService.KeyboardEnabled

		if v183.UiNavigationKeyBindEnabledFrame then
			v183.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

			if KeyboardEnabled then
				v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)
			else
				v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 961
			-- upvalues: UserInputService (copy), v183 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled2 = UserInputService.KeyboardEnabled

			if v183.UiNavigationKeyBindEnabledFrame then
				v183.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled2

				if KeyboardEnabled2 then
					v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v183.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end)
	end
	local function createPerformanceStatsOptions() -- line: 966
		-- upvalues: v183 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v352 = v183
		local v353 = v183
		local v354 = v183
		local v355 = v183

		v352.PerformanceStatsFrame = nil
		v353.PerformanceStatsLabel = nil
		v354.PerformanceStatsMode = nil
		v355.PerformanceStatsOverrideText = nil

		function GetDesiredPerformanceStatsIndex() -- line: 972
			-- upvalues: GameSettings (copy)
			if GameSettings.PerformanceStatsVisible then
				return 1
			end

			return 2
		end

		local v356 = GetDesiredPerformanceStatsIndex()
		local v357 = v183
		local v358 = v183
		local v359 = v183
		local v360, v361, v362 = Utility:AddNewRow(v183, "Performance Stats", "Selector", {
			"On",
			"Off"
		}, v356)

		v357.PerformanceStatsFrame = v360
		v358.PerformanceStatsLabel = v361
		v359.PerformanceStatsMode = v362
		v183.PerformanceStatsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PerformanceStatsFrame
		v183.PerformanceStatsOverrideText = Create("TextLabel")({
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
			Parent = v183.PerformanceStatsFrame
		})
		v183.PerformanceStatsMode.IndexChanged:connect(function(p21) -- line: 1001
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
		GameSettings.PerformanceStatsVisibleChanged:connect(function() -- line: 1023
			-- upvalues: v183 (copy)
			local v813 = GetDesiredPerformanceStatsIndex()

			if v813 ~= v183.PerformanceStatsMode.CurrentIndex then
				v183.PerformanceStatsMode:SetSelectionIndex(v813)
			end
		end)
	end
	local function createWebServerInformationRow() -- line: 1033
		-- upvalues: v183 (copy), Utility (copy), v56 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), TouchEnabled (copy), Create (copy), Theme (copy)
		local v363 = v183
		local v364 = v183
		local v365 = v183
		local v366, v367, v368 = Utility:AddNewRow(v183, "MicroProfiler Information", "TextBox", nil, nil, 5, nil, nil, nil, not v56 and nil)

		v363.InformationFrame = v366
		v364.InformationLabel = v367
		v365.InformationTextBox = v368
		v183.InformationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.InformationFrame
		v183.InformationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		if TouchEnabled then
			v183.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size18),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				Parent = v183.InformationFrame
			})
		else
			v183.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size14),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(1, -650, 0, 20),
				Parent = v183.InformationFrame
			})
		end

		return v183.InformationFrame, v183.InformationText
	end
	local function createMicroProfilerOptions() -- line: 1073
		-- upvalues: v183 (copy), GameSettings (copy), createWebServerInformationRow (copy), v132 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v131 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v369 = v183
		local v370 = v183
		local v371 = v183
		local v372 = v183

		v369.MicroProfilerFrame = nil
		v370.MicroProfilerLabel = nil
		v371.MicroProfilerMode = nil
		v372.MicroProfilerOverrideText = nil

		local function tryContentLabel() -- line: 1078
			-- upvalues: GameSettings (copy), v183 (copy), createWebServerInformationRow (copy)
			local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

			if MicroProfilerWebServerPort ~= 0 then
				local v815 = v183
				local v816 = v183
				local v817, v818 = createWebServerInformationRow()

				v815.InformationFrame = v817
				v816.InformationText = v818
				v183.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort

				return true
			end

			return false
		end
		local function setMicroProfilerIndex(p22) -- line: 1090
			-- upvalues: GameSettings (copy), v183 (copy), v132 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), createWebServerInformationRow (copy), v131 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local function hideContentLabel() -- line: 1091
				-- upvalues: GameSettings (copy), v183 (copy)
				GameSettings.MicroProfilerWebServerEnabled = false

				if v183.InformationFrame or v183.InformationText then
					v183.InformationFrame.Visible = false
					v183.InformationFrame.Parent = nil
					v183.InformationText.Parent = nil
					v183.InformationFrame = nil
					v183.InformationText = nil
				end
			end

			local s1 = nil
			local MicroProfilerWebServerEnabled = nil
			local MicroProfilerWebServerEnabled2 = nil

			if v132 then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					s1 = "webserver"
					MicroProfilerWebServerEnabled = GameSettings.MicroProfilerWebServerEnabled
				end

				if p22 == 1 then
					GameSettings.MicroProfilerWebServerEnabled = true

					local n6 = 30

					while n6 >= 1 do
						local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort
						local v830

						if MicroProfilerWebServerPort ~= 0 then
							local v826 = v183
							local v827 = v183
							local v828, v829 = createWebServerInformationRow()

							v826.InformationFrame = v828
							v827.InformationText = v829
							v183.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
							v830 = true
						else
							v830 = false
						end

						if v830 then
							break
						end

						n6 -= 1
						wait(0.1)
					end

					if n6 <= 0 then
						v183.MicroProfilerMode:SetSelectionIndex(2)
						GameSettings.MicroProfilerWebServerEnabled = false

						if v183.InformationFrame or v183.InformationText then
							v183.InformationFrame.Visible = false
							v183.InformationFrame.Parent = nil
							v183.InformationText.Parent = nil
							v183.InformationFrame = nil
							v183.InformationText = nil
						end
					end
				else
					GameSettings.MicroProfilerWebServerEnabled = false

					if v183.InformationFrame or v183.InformationText then
						v183.InformationFrame.Visible = false
						v183.InformationFrame.Parent = nil
						v183.InformationText.Parent = nil
						v183.InformationFrame = nil
						v183.InformationText = nil
					end
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					MicroProfilerWebServerEnabled2 = GameSettings.MicroProfilerWebServerEnabled
				end
			elseif v131 or isInExperienceUIVREnabled and isSpatial() then
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
		local function GetDesiredWebServerIndex() -- line: 1164
			-- upvalues: v132 (copy), GameSettings (copy), v131 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy)
			if v132 then
				if GameSettings.MicroProfilerWebServerEnabled then
					return 1
				end

				return 2
			end

			if v131 or isInExperienceUIVREnabled and isSpatial() then
				if GameSettings.OnScreenProfilerEnabled then
					return 1
				end

				return 2
			end

			return 2
		end

		local v376 = if not v132 then not v131 and (not isInExperienceUIVREnabled or not isSpatial()) and 2 or (not GameSettings.OnScreenProfilerEnabled and 2 or 1) else not GameSettings.MicroProfilerWebServerEnabled and 2 or 1
		local v377 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MicroProfiler")
		local v378 = v183
		local v379 = v183
		local v380 = v183
		local v381, v382, v383 = Utility:AddNewRow(v183, v377, "Selector", {
			"On",
			"Off"
		}, v376)

		v378.MicroProfilerFrame = v381
		v379.MicroProfilerLabel = v382
		v380.MicroProfilerMode = v383
		v183.MicroProfilerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MicroProfilerFrame

		local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

		if MicroProfilerWebServerPort ~= 0 then
			local v385 = v183
			local v386 = v183
			local v387, v388 = createWebServerInformationRow()

			v385.InformationFrame = v387
			v386.InformationText = v388
			v183.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
		end

		local u389 = false

		GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 1193
			-- upvalues: u389 (ref), GameSettings (copy), v183 (copy)
			u389 = true

			if GameSettings.OnScreenProfilerEnabled then
				v183.MicroProfilerMode:SetSelectionIndex(1)

				return
			end

			v183.MicroProfilerMode:SetSelectionIndex(2)
		end)

		local function onIndexChanged(...) -- line: 1203
			-- upvalues: u389 (ref), setMicroProfilerIndex (copy)
			if u389 then
				u389 = false

				return
			end

			setMicroProfilerIndex(...)
		end

		v183.MicroProfilerMode.IndexChanged:connect(onIndexChanged)
	end
	local function createCameraModeOptions(p23) -- line: 1214
		-- upvalues: v183 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), LocalPlayer (copy), UserInputService (copy), CoreUtility (copy), t4 (copy), VRService (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v88 (copy), t3 (copy), t2 (copy)
		local v392 = v183
		local v393 = v183
		local v394 = v183
		local v395 = v183

		v392.ShiftLockFrame = nil
		v393.ShiftLockLabel = nil
		v394.ShiftLockMode = nil
		v395.ShiftLockOverrideText = nil

		local n7 = 2

		if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
			n7 = 1
		end

		local v397 = v183
		local v398 = v183
		local v399 = v183
		local v400, v401, v402 = Utility:AddNewRow(v183, "Shift Lock Switch", "Selector", {
			"On",
			"Off"
		}, n7)

		v397.ShiftLockFrame = v400
		v398.ShiftLockLabel = v401
		v399.ShiftLockMode = v402
		v183.ShiftLockFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ShiftLockFrame
		t10[v183.ShiftLockFrame] = true
		v183.ShiftLockOverrideText = Create("TextLabel")({
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
			Parent = v183.ShiftLockFrame
		})
		v183.ShiftLockMode.IndexChanged:connect(function(p24) -- line: 1245
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v832 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v832 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			end

			if p24 == 1 then
				GameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
			else
				GameSettings.ControlMode = Enum.ControlMode.Classic
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("shift_lock_enabled", v832, GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
			end

			reportSettingsForAnalytics()
		end)

		local function setShiftLockSelectorVisible(b1: boolean) -- line: 1267
			-- upvalues: LocalPlayer (copy), v183 (copy)
			local v834 = b1 and LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockMode then
				v183.ShiftLockMode.SelectorFrame.Visible = v834
				v183.ShiftLockMode:SetInteractable(v834)
			end
		end
		local function applyDevOverrideShiftLockSelector() -- line: 1275
			-- upvalues: LocalPlayer (copy), v183 (copy)
			local v835 = not LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockOverrideText then
				v183.ShiftLockOverrideText.Visible = v835

				local v836 = not v835 and LocalPlayer.DevEnableMouseLock

				if v183.ShiftLockMode then
					v183.ShiftLockMode.SelectorFrame.Visible = v836
					v183.ShiftLockMode:SetInteractable(v836)
				end
			end
		end
		local function updateShiftLockVisibility() -- line: 1283
			-- upvalues: UserInputService (copy), v183 (copy), LocalPlayer (copy)
			local v837 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v183.ShiftLockFrame then
				v183.ShiftLockFrame.Visible = v837
			end

			local v838 = not LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockOverrideText then
				v183.ShiftLockOverrideText.Visible = v838

				local v839 = not v838 and LocalPlayer.DevEnableMouseLock

				if v183.ShiftLockMode then
					v183.ShiftLockMode.SelectorFrame.Visible = v839
					v183.ShiftLockMode:SetInteractable(v839)
				end
			end
		end

		local v406 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

		if v183.ShiftLockFrame then
			v183.ShiftLockFrame.Visible = v406
		end

		local v407 = not LocalPlayer.DevEnableMouseLock

		if v183.ShiftLockOverrideText then
			v183.ShiftLockOverrideText.Visible = v407

			local v408 = not v407 and LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockMode then
				v183.ShiftLockMode.SelectorFrame.Visible = v408
				v183.ShiftLockMode:SetInteractable(v408)
			end
		end

		UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function() -- line: 1293
			-- upvalues: UserInputService (copy), v183 (copy), LocalPlayer (copy)
			local v840 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v183.ShiftLockFrame then
				v183.ShiftLockFrame.Visible = v840
			end

			local v841 = not LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockOverrideText then
				v183.ShiftLockOverrideText.Visible = v841

				local v842 = not v841 and LocalPlayer.DevEnableMouseLock

				if v183.ShiftLockMode then
					v183.ShiftLockMode.SelectorFrame.Visible = v842
					v183.ShiftLockMode:SetInteractable(v842)
				end
			end
		end)
		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 1297
			-- upvalues: UserInputService (copy), v183 (copy), LocalPlayer (copy)
			local v843 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v183.ShiftLockFrame then
				v183.ShiftLockFrame.Visible = v843
			end

			local v844 = not LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockOverrideText then
				v183.ShiftLockOverrideText.Visible = v844

				local v845 = not v844 and LocalPlayer.DevEnableMouseLock

				if v183.ShiftLockMode then
					v183.ShiftLockMode.SelectorFrame.Visible = v845
					v183.ShiftLockMode:SetInteractable(v845)
				end
			end
		end)

		function cameraModeIsUserChoice() -- line: 1303
			-- upvalues: UserInputService (copy), LocalPlayer (copy)
			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				return LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
			end

			return LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end
		function setCameraModeVisible(p25) -- line: 1312
			-- upvalues: v183 (copy)
			if v183.CameraMode then
				v183.CameraMode.SelectorFrame.Visible = p25
				v183.CameraMode:SetInteractable(p25)
				v183.CameraModeOverrideText.Visible = not p25
			end
		end

		local v409 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
		local t14 = {}
		local t15 = {}

		local function updateCurrentCameraMovementIndex(p26) -- line: 1326
			-- upvalues: t15 (ref), t14 (ref), UserInputService (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy)
			local u848 = nil

			if not pcall(function() -- line: 1328
				-- upvalues: u848 (ref), t15 (ref), t14 (ref), p26 (copy)
				u848 = t15[t14[p26]]
			end) or u848 == nil then
				return false
			end

			local TouchCameraMovementModeValue = nil
			local v850

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.TouchCameraMovementMode.Value
				end

				v850 = GameSettings.TouchCameraMovementMode.Value ~= u848
				GameSettings.TouchCameraMovementMode = u848
			else
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.ComputerCameraMovementMode.Value
				end

				v850 = GameSettings.ComputerCameraMovementMode.Value ~= u848
				GameSettings.ComputerCameraMovementMode = u848
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() and v850 then
				reportSettingsChangeForAnalytics("camera_mode", TouchCameraMovementModeValue, u848)
			end

			return v850
		end
		local function updateCameraMovementModes() -- line: 1362
			-- upvalues: v409 (copy), UserInputService (copy), t14 (ref), t15 (ref), t4 (copy), v183 (copy), GameSettings (copy), updateCurrentCameraMovementIndex (copy)
			local t16 = {}

			if v409 then
				t16 = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then v409:GetRegisteredComputerCameraMovementModes() else v409:GetRegisteredTouchCameraMovementModes()
			end

			t14 = {}
			t15 = {}

			if #t16 <= 0 then
				setCameraModeVisible(false)

				return
			end

			for i = 1, #t16 do
				local v853 = t16[i]
				local Name = v853.Name

				if Name == "Default" then
					Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t4.DEFAULT_CLASSIC else t4.DEFAULT_FOLLOW
				end

				t14[#t14 + 1] = Name
				t15[Name] = v853.Value
			end

			if v183.CameraMode then
				v183.CameraMode:UpdateOptions(t14)
			end

			local v855 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
			local v856 = if not v855 then GameSettings.ComputerCameraMovementMode.Value else GameSettings.TouchCameraMovementMode.Value

			if v856 > -1 then
				if v855 or GameSettings.ComputerCameraMovementMode ~= Enum.ComputerCameraMovementMode.CameraToggle then
					v856 += 1
				end

				updateCurrentCameraMovementIndex(v856)
				v183.CameraMode:SetSelectionIndex(v856)
			end

			setCameraModeVisible(cameraModeIsUserChoice())
		end

		local v414 = v183
		local v415 = v183
		local v416 = v183
		local v417, v418, v419 = Utility:AddNewRow(v183, "Camera Mode", "Selector", t14, 1)

		v414.CameraModeFrame = v417
		v415.CameraModeLabel = v418
		v416.CameraMode = v419
		v183.CameraModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraModeFrame
		t10[v183.CameraMode] = true
		v183.CameraModeOverrideText = Create("TextLabel")({
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
			Parent = v183.CameraModeFrame
		})

		if v409 then
			v409.TouchCameraMovementModeRegistered:connect(function(__) -- line: 1448
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.TouchEnabled then
					updateCameraMovementModes()
				end
			end)
			v409.ComputerCameraMovementModeRegistered:connect(function(__) -- line: 1454
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.MouseEnabled then
					updateCameraMovementModes()
				end
			end)
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1461
			-- upvalues: updateCameraMovementModes (copy)
			updateCameraMovementModes()
		end)

		local u420 = false

		v183.CameraMode.IndexChanged:connect(function(p29) -- line: 1466
			-- upvalues: updateCurrentCameraMovementIndex (copy), u420 (ref), reportSettingsForAnalytics (copy)
			if updateCurrentCameraMovementIndex(p29) then
				if u420 then
					reportSettingsForAnalytics()
				end

				u420 = true
			end
		end)
		updateCameraMovementModes()

		local u421 = false

		local function createVROption() -- line: 1482
			-- upvalues: u421 (ref), GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy)
			if not u421 then
				u421 = true

				local u860 = if not GameSettings.VREnabled then {
					"On (restart pending)",
					"Off"
				} else {
					"On",
					"Off (restart pending)"
				}
				local v861 = v183
				local v862 = v183
				local v863 = v183
				local v864, v865, v866 = Utility:AddNewRow(v183, "VR", "Selector", u860, not GameSettings.VREnabled and 2 or 1)

				v861.VREnabledFrame = v864
				v862.VREnabledLabel = v865
				v863.VREnabledSelector = v866
				v183.VREnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VREnabledFrame
				v183.VREnabledSelector.IndexChanged:connect(function(p30) -- line: 1497
					-- upvalues: GameSettings (copy), u860 (ref), reportSettingsChangeForAnalytics (copy)
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
					local v1109 = p30 == t17.On.Value

					if v1109 ~= GameSettings.VREnabled then
						GameSettings.VREnabled = v1109

						local v1110 = u860[t17.On.Value]
						local v1111 = u860[p30]

						if v1111 == u860[t17.On.Value] then
							v1110 = u860[t17.Off.Value]
						end

						reportSettingsChangeForAnalytics("vr_mode", v1110, v1111)
					end
				end)
			end
		end
		local function onVREnabledChanged() -- line: 1516
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

		local function u428(__: boolean) -- line: 1541
		end
		local function setMovementModeVisible(p31) -- line: 1545
			-- upvalues: v183 (copy), t18 (ref)
			if v183.MovementMode then
				local v869 = p31 and #t18 > 0

				v183.MovementMode.SelectorFrame.Visible = v869
				v183.MovementMode:SetInteractable(v869)
				v183.MovementModeOverrideText.Visible = not v869
			end
		end

		if p23 then
			local v430 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

			local function getDisplayName(p32) -- line: 1559
				-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v88 (copy)
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
					p32 = v88
				end

				return p32
			end

			local v432 = v183
			local v433 = v183
			local v434 = v183
			local v435, v436, v437 = Utility:AddNewRow(v183, "Movement Mode", "Selector", {}, 1)

			v432.MovementModeFrame = v435
			v433.MovementModeLabel = v436
			v434.MovementMode = v437
			v183.MovementModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MovementModeFrame
			t10[v183.MovementMode] = true
			v183.MovementModeOverrideText = Create("TextLabel")({
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
				Parent = v183.MovementModeFrame
			})

			local function setMovementMode(p33) -- line: 1600
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

			function u428(b3: boolean) -- line: 1617
				-- upvalues: LocalPlayer (copy), v183 (copy), t18 (ref)
				local v874 = if not b3 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

				if v183.MovementMode then
					local v875 = v874 and #t18 > 0

					v183.MovementMode.SelectorFrame.Visible = v875
					v183.MovementMode:SetInteractable(v875)
					v183.MovementModeOverrideText.Visible = not v875
				end

				if v183.MovementModeOverrideText then
					v183.MovementModeOverrideText.Visible = not v874
				end
			end

			local function updateMovementModes() -- line: 1629
				-- upvalues: UserInputService (copy), v430 (copy), t18 (ref), t19 (ref), t20 (ref), t21 (ref), v183 (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v88 (copy), GameSettings (copy), setMovementMode (copy), u428 (ref)
				local v876 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

				if v430 then
					if v876 then
						t18 = v430:GetRegisteredTouchMovementModes()
					else
						t18 = v430:GetRegisteredComputerMovementModes()
					end
				end

				t19 = {}
				t20 = {}
				t21 = {}

				if #t18 <= 0 then
					if v183.MovementMode then
						v183.MovementMode.SelectorFrame.Visible = false
						v183.MovementMode:SetInteractable(false)
						v183.MovementModeOverrideText.Visible = true
					end

					return
				end

				if v183.MovementMode then
					local v877 = #t18 > 0

					v183.MovementMode.SelectorFrame.Visible = v877
					v183.MovementMode:SetInteractable(v877)
					v183.MovementModeOverrideText.Visible = not v877
				end

				for v878, v879 in t18 do
					t20[v878] = v879

					local v880 = t21
					local Name = v879.Name

					if Name == "Default" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.DEFAULT_KEYBOARD else RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
					elseif Name == "KeyboardMouse" then
						Name = "Keyboard + Mouse"
					elseif Name == "ClickToMove" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.CLICK_TO_MOVE else t6.TAP_TO_MOVE
					elseif Name == "DynamicThumbstick" then
						Name = "Dynamic Thumbstick"
					elseif Name == "Thumbstick" then
						Name = v88
					end

					v880[v878] = Name
					t19[v879] = v878
				end

				if v183.MovementMode then
					v183.MovementMode:UpdateOptions(t21)
				end

				local v882 = if not v876 then GameSettings.ComputerMovementMode else GameSettings.TouchMovementMode

				if v882 then
					setMovementMode(v882)
					v183.MovementMode:SetSelectionIndex(t19[v882])
				end

				u428(v876)
			end

			updateMovementModes()

			if v430 then
				v430.TouchMovementModeRegistered:connect(function(__) -- line: 1673
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.TouchEnabled then
						updateMovementModes()
					end
				end)
				v430.ComputerMovementModeRegistered:connect(function(__) -- line: 1679
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.MouseEnabled then
						updateMovementModes()
					end
				end)
			end

			UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1686
				-- upvalues: updateMovementModes (copy)
				updateMovementModes()
			end)
			v183.MovementMode.IndexChanged:connect(function(p36) -- line: 1690
				-- upvalues: setMovementMode (copy), t20 (ref), reportSettingsForAnalytics (copy)
				setMovementMode(t20[p36])
				reportSettingsForAnalytics()
			end)
		end

		local v440 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

		if not if not v440 then LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice else LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
			v183.CameraModeOverrideText.Visible = true
			setCameraModeVisible(false)
		else
			v183.CameraModeOverrideText.Visible = false
			setCameraModeVisible(true)
		end

		local v441 = if not v440 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

		if v183.MovementModeOverrideText then
			if not v441 then
				v183.MovementModeOverrideText.Visible = true

				if v183.MovementMode then
					v183.MovementMode.SelectorFrame.Visible = false
					v183.MovementMode:SetInteractable(false)
					v183.MovementModeOverrideText.Visible = true
				end
			else
				v183.MovementModeOverrideText.Visible = false

				if v183.MovementMode then
					local v442 = #t18 > 0

					v183.MovementMode.SelectorFrame.Visible = v442
					v183.MovementMode:SetInteractable(v442)
					v183.MovementModeOverrideText.Visible = not v442
				end
			end
		end

		local v443 = not LocalPlayer.DevEnableMouseLock

		if v183.ShiftLockOverrideText then
			v183.ShiftLockOverrideText.Visible = v443

			local v444 = not v443 and LocalPlayer.DevEnableMouseLock

			if v183.ShiftLockMode then
				v183.ShiftLockMode.SelectorFrame.Visible = v444
				v183.ShiftLockMode:SetInteractable(v444)
			end
		end

		local function updateUserSettingsMenu(p37) -- line: 1736
			-- upvalues: LocalPlayer (copy), v183 (copy), u428 (ref), t18 (ref)
			if p37 == "DevEnableMouseLock" then
				local v887 = not LocalPlayer.DevEnableMouseLock

				if v183.ShiftLockOverrideText then
					v183.ShiftLockOverrideText.Visible = v887

					local v888 = not v887 and LocalPlayer.DevEnableMouseLock

					if v183.ShiftLockMode then
						v183.ShiftLockMode.SelectorFrame.Visible = v888
						v183.ShiftLockMode:SetInteractable(v888)

						return
					end
				end
			else
				if p37 == "DevComputerCameraMode" then
					local v889 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice

					setCameraModeVisible(v889)
					v183.CameraModeOverrideText.Visible = not v889

					return
				end

				if p37 == "DevComputerMovementMode" then
					if u428 ~= nil then
						u428(false)

						return
					end

					local v890 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice

					if v183.MovementMode then
						local v891 = v890 and #t18 > 0

						v183.MovementMode.SelectorFrame.Visible = v891
						v183.MovementMode:SetInteractable(v891)
						v183.MovementModeOverrideText.Visible = not v891
					end

					if v183.MovementModeOverrideText then
						v183.MovementModeOverrideText.Visible = not v890

						return
					end
				elseif p37 == "DevTouchMovementMode" then
					if u428 ~= nil then
						u428(true)

						return
					end

					local v892 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

					if v183.MovementMode then
						local v893 = v892 and #t18 > 0

						v183.MovementMode.SelectorFrame.Visible = v893
						v183.MovementMode:SetInteractable(v893)
						v183.MovementModeOverrideText.Visible = not v893
					end

					if v183.MovementModeOverrideText then
						v183.MovementModeOverrideText.Visible = not v892

						return
					end
				elseif p37 == "DevTouchCameraMode" then
					local v894 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice

					setCameraModeVisible(v894)
					v183.CameraModeOverrideText.Visible = not v894
				end
			end
		end

		LocalPlayer.Changed:connect(function(p38) -- line: 1771
			-- upvalues: t3 (copy), updateUserSettingsMenu (copy), t2 (copy)
			if t3[p38] then
				updateUserSettingsMenu(p38)
			end

			if t2[p38] then
				updateUserSettingsMenu(p38)
			end
		end)
	end
	local function createFeedbackModeOptions() -- line: 1784
		-- upvalues: Url (copy), HttpService (copy), v146 (copy), v183 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v145 (copy), Utility (copy), v90 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v140 (copy), v128 (copy)
		local v446 = Url.ROLES_URL .. "v1/users/authenticated/roles"
		local v447 = HttpService:RequestInternal({
			Method = "GET",
			Url = v446
		})

		local function rolesCheckCallback(p39) -- line: 1791
			-- upvalues: v146 (copy), v183 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v145 (copy), Utility (copy), v90 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p39 then
				if not v146 and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v183.FeedbackEntryPointEnabled then
					return
				end

				local function onToggleFeedbackMode() -- line: 1803
					-- upvalues: v146 (copy), v183 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy)
					if v146 and (game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v183.FeedbackEntryPointEnabled) then
						return
					end

					v183.HubRef:PopMenu(false, true)

					if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
						SafetyService.IsCaptureModeForReport = false
					end

					if ExperienceStateCaptureService ~= nil then
						ExperienceStateCaptureService:ToggleCaptureMode()
					end

					reportSettingsChangeForAnalytics("translation_feedback", "", "pressed")
				end

				local v898, v899

				if v145 then
					v898, v899 = Utility:MakeStyledButton("toggleFeedbackModeButton", v90, UDim2.new(1, 0, 1, -20), onToggleFeedbackMode, v183)
					v898.Size = UDim2.new(0.6, 0, 0, 40)
					v898.Position = UDim2.new(0.4, 0, 0.5, 0)
					v898.AnchorPoint = Vector2.new(0, 0.5)
				else
					v898, v899 = Utility:MakeStyledButton("toggleFeedbackModeButton", v90, UDim2.new(0, 300, 1, -20), onToggleFeedbackMode, v183)
					v898.Size = UDim2.new(0, 300, 0, 30)
					v898.Position = UDim2.new(0.4, 0, 0.5, 0)
					v898.AnchorPoint = Vector2.new(0, 0.5)
				end

				v898.ZIndex = 2
				v898.Selectable = true
				v899.ZIndex = 2

				if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
					v183.toggleFeedbackModeButton = v898
					v183.toggleFeedbackModeText = v899
				end

				if v145 then
					Utility:AddNewRowObject(v183, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v898, nil, true).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton

					return
				end

				Utility:AddNewRowObject(v183, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v898).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
			end
		end

		if v140 then
			rolesCheckCallback(true)

			return
		end

		v447:Start(function(p40, p41) -- line: 1887
			-- upvalues: HttpService (copy), v128 (copy), v446 (copy), rolesCheckCallback (copy)
			local u902 = false
			local v903 = false
			local s2

			if not p40 then
				s2 = "Roles Api Request: Connection error"
			elseif p41.StatusCode == 401 then
				s2 = "Roles Api Request: Unauthorized"
			elseif p41.StatusCode < 200 or p41.StatusCode >= 400 then
				s2 = "Roles Api Status code: " .. p41.StatusCode
			else
				v903, s2 = pcall(function() -- line: 1899
					-- upvalues: HttpService (copy), p41 (copy), u902 (ref)
					local data = HttpService:JSONDecode(p41.Body)

					for __, v in pairs(data.roles) do
						if v == "Soothsayer" then
							u902 = true
						end
					end
				end)
			end

			if not v903 then
				v128:warning("Feedback Mode initialization api call failed with url: " .. v446 .. " and with error message: " .. s2)
			end

			rolesCheckCallback(u902)
		end)
	end
	local function createTranslationOptions() -- line: 1927
		-- upvalues: Players (copy), Url (copy), HttpService (copy), v128 (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), LocalPlayer (copy), reportSettingsChangeForAnalytics (copy), RunService (copy)
		local n8 = 1
		local n9 = 1
		local u451 = false
		local languageCode = nil
		local localeCode = nil
		local LocaleId = Players.LocalPlayer.LocaleId
		local languageCode2 = nil
		local u456 = nil
		local t22 = {}
		local t23 = {}
		local t24 = {}
		local t25 = {}
		local t26 = {}
		local v462 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))
		local v463 = HttpService:RequestInternal({
			Method = "GET",
			Url = v462
		})
		local v464 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
		local v465 = HttpService:RequestInternal({
			Method = "GET",
			Url = v464
		})
		local v466 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/supported-languages/games/%d/in-experience-language-selection", game.GameId)
		local v467 = HttpService:RequestInternal({
			Method = "GET",
			Url = v466
		})
		local v468 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
		local v469 = HttpService:RequestInternal({
			Method = "GET",
			Url = v468
		})

		local function userExperienceLanguageSettingsCallback(p42, p43) -- line: 1992
			-- upvalues: v128 (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t26 (copy), t24 (copy), languageCode (ref), t22 (copy), u456 (ref), t23 (copy), n8 (ref), n9 (ref), LocalPlayer (copy), localeCode (ref), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), u451 (ref), RunService (copy)
			if not p42 then
				if p43 == nil then
					p43 = "Execution path did not set earliest error to non-nil value."
				end

				v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p43)

				local v907 = v183
				local v908 = v183
				local v909 = v183
				local v910, v911, v912 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

				v907.LanguageSelectorFrame = v910
				v908.LanguageSelectorLabel = v911
				v909.LanguageSelectorMode = v912
				v183.LanguageSelectorMode:SetInteractable(false)
				v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

				return
			end

			local v913 = false

			table.insert(t26, t24[languageCode].languageName .. " (Original)")

			for __, v in pairs(t22) do
				if v == u456 then
					v913 = true
				end

				if v ~= languageCode then
					table.insert(t26, t24[v].languageName)
				end
			end

			if v913 == true then
				for k, v in pairs(t26) do
					if k ~= 1 and t23[v] == u456 then
						n8 = k
						n9 = k
					end
				end
			end

			local v918 = v183
			local v919 = v183
			local v920 = v183
			local v921, v922, v923 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", t26, n8)

			v918.LanguageSelectorFrame = v921
			v919.LanguageSelectorLabel = v922
			v920.LanguageSelectorMode = v923
			v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

			if n8 == 1 then
				LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
			else
				local v924 = t23[t26[n8]]

				LocalPlayer:SetExperienceSettingsLocaleId(t24[v924].localeCode)
			end

			v183.LanguageSelectorMode.CurrentLanguage = v183.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

			local function toggleTranslation(p44) -- line: 2072
				-- upvalues: v183 (copy), t24 (copy), languageCode (ref), t23 (copy), t26 (copy), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), n9 (ref), LocalPlayer (copy), localeCode (ref), v128 (copy), u451 (ref), RunService (copy)
				v183.LanguageSelectorMode:SetInteractable(false)

				local v1116 = if p44 ~= 1 then t24[t23[t26[p44]]].id else t24[languageCode].id
				local CurrentLanguage = v183.LanguageSelectorMode.CurrentLanguage
				local v1118 = t26[p44]

				if CurrentLanguage ~= v1118 then
					v183.LanguageSelectorMode.CurrentLanguage = v1118
					reportSettingsChangeForAnalytics("experience_language", CurrentLanguage, v1118)
				end

				local t27 = {
					settingValue = {
						settingType = "LanguageFamily",
						settingTargetId = v1116
					}
				}
				local v1120 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
				local v1121 = HttpService:RequestInternal({
					Method = "POST",
					Url = v1120,
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode(t27)
				})

				local function callback(p45, p46) -- line: 2119
					-- upvalues: n9 (ref), p44 (copy), LocalPlayer (copy), localeCode (ref), t23 (copy), t26 (copy), t24 (copy), v128 (copy), u451 (ref), v183 (copy)
					if p45 then
						n9 = p44

						if p44 == 1 then
							LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
						else
							local v1212 = t23[t26[p44]]

							LocalPlayer:SetExperienceSettingsLocaleId(t24[v1212].localeCode)
						end
					else
						v128:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p46)
						u451 = true
						v183.LanguageSelectorMode:SetSelectionIndex(n9)
					end

					v183.LanguageSelectorMode:SetInteractable(true)
				end

				if RunService:IsStudio() then
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1123 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1123].localeCode)
					end

					v183.LanguageSelectorMode:SetInteractable(true)

					return
				end

				if u451 then
					u451 = false
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1124 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1124].localeCode)
					end

					v183.LanguageSelectorMode:SetInteractable(true)

					return
				end

				v1121:Start(function(p47, p48) -- line: 2162
					-- upvalues: v128 (copy), v1120 (copy), callback (copy)
					local v1215 = false
					local s3 = nil

					if not p47 then
						s3 = "User Experience Language Settings Update Request: Connection error"
					elseif p48.StatusCode == 401 then
						s3 = "User Experience Language Settings Update Request: Unauthorized"
					elseif p48.StatusCode < 200 or p48.StatusCode >= 400 then
						s3 = "User Experience Language Settings Update Request Status Code: " .. p48.StatusCode
					else
						v128:info("User Experience Language Settings Update Request succeeded with code: " .. p48.StatusCode)
						v1215 = true
					end

					if not v1215 then
						v128:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. v1120 .. " with error message: " .. s3)
					end

					callback(v1215, s3)
				end)
			end

			v183.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
		end
		local function experienceSupportedLanguagesCallback(p49, p50) -- line: 2197
			-- upvalues: v469 (copy), HttpService (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v128 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p49 then
				v469:Start(function(p51, p52) -- line: 2199
					-- upvalues: HttpService (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v128 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy)
					local v1127 = false
					local s4

					if not p51 then
						s4 = "User Experience Language Setting Request: Connection error"
					elseif p52.StatusCode == 401 then
						s4 = "User Experience Language Setting Request: Unauthorized"
					elseif p52.StatusCode < 200 or p52.StatusCode >= 400 then
						s4 = "User Experience Language Setting Request Status code: " .. p52.StatusCode
					else
						v1127, s4 = pcall(function() -- line: 2210
							-- upvalues: HttpService (copy), p52 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
							local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p52.Body).userUniverseLocalizationSettingValue

							if userUniverseLocalizationSettingValue == nil then
								u456 = languageCode2

								return
							end

							if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
								if userUniverseLocalizationSettingValue.settingTargetId == 1 then
									u456 = languageCode
								else
									u456 = languageCode2
								end
							end

							if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
								if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
									u456 = languageCode2

									return
								end

								u456 = t25[userUniverseLocalizationSettingValue.settingTargetId]
							end
						end)
					end

					if not v1127 then
						v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v468 .. " with error message: " .. s4)
					end

					userExperienceLanguageSettingsCallback(v1127, s4)
				end)

				return
			end

			if p50 == nil then
				p50 = "Execution path did not set earliest error to non-nil value."
			end

			v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p50)

			local v928 = v183
			local v929 = v183
			local v930 = v183
			local v931, v932, v933 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

			v928.LanguageSelectorFrame = v931
			v929.LanguageSelectorLabel = v932
			v930.LanguageSelectorMode = v933
			v183.LanguageSelectorMode:SetInteractable(false)
			v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
		end
		local function experienceSourceLanguageCallback(p53, p54) -- line: 2259
			-- upvalues: v467 (copy), HttpService (copy), t22 (copy), v128 (copy), v466 (copy), v469 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p53 then
				v467:Start(function(p55, p56) -- line: 2261
					-- upvalues: HttpService (copy), t22 (copy), v128 (copy), v466 (copy), p54 (ref), p53 (copy), v469 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1131 = false
					local s5

					if not p55 then
						s5 = "Experience Supported Language Request: Connection error"
					elseif p56.StatusCode == 401 then
						s5 = "Experience Supported Language Request: Unauthorized"
					elseif p56.StatusCode < 200 or p56.StatusCode >= 400 then
						s5 = "Experience Supported Language Request Status code: " .. p56.StatusCode
					else
						v1131, s5 = pcall(function() -- line: 2271
							-- upvalues: HttpService (copy), p56 (copy), t22 (copy)
							local data = HttpService:JSONDecode(p56.Body)

							for k, v in pairs(data.data) do
								t22[k] = v.languageCode
							end
						end)
					end

					if not v1131 then
						v128:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v466 .. " with error message: " .. s5)
					end

					if p54 == nil then
						p54 = s5
					end

					local v1133 = v1131 and p53
					local v1134 = p54

					if v1133 then
						v469:Start(function(p57, p58) -- line: 2199
							-- upvalues: HttpService (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v128 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy)
							local v1223 = false
							local s6

							if not p57 then
								s6 = "User Experience Language Setting Request: Connection error"
							elseif p58.StatusCode == 401 then
								s6 = "User Experience Language Setting Request: Unauthorized"
							elseif p58.StatusCode < 200 or p58.StatusCode >= 400 then
								s6 = "User Experience Language Setting Request Status code: " .. p58.StatusCode
							else
								v1223, s6 = pcall(function() -- line: 2210
									-- upvalues: HttpService (copy), p58 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
									local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p58.Body).userUniverseLocalizationSettingValue

									if userUniverseLocalizationSettingValue == nil then
										u456 = languageCode2

										return
									end

									if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
										if userUniverseLocalizationSettingValue.settingTargetId == 1 then
											u456 = languageCode
										else
											u456 = languageCode2
										end
									end

									if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
										if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
											u456 = languageCode2

											return
										end

										u456 = t25[userUniverseLocalizationSettingValue.settingTargetId]
									end
								end)
							end

							if not v1223 then
								v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v468 .. " with error message: " .. s6)
							end

							userExperienceLanguageSettingsCallback(v1223, s6)
						end)

						return
					end

					if v1134 == nil then
						v1134 = "Execution path did not set earliest error to non-nil value."
					end

					v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1134)

					local v1135 = v183
					local v1136 = v183
					local v1137 = v183
					local v1138, v1139, v1140 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

					v1135.LanguageSelectorFrame = v1138
					v1136.LanguageSelectorLabel = v1139
					v1137.LanguageSelectorMode = v1140
					v183.LanguageSelectorMode:SetInteractable(false)
					v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
				end)
			else
				local v937 = p54

				if v937 == nil then
					v937 = "Execution path did not set earliest error to non-nil value."
				end

				v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v937)

				local v938 = v183
				local v939 = v183
				local v940 = v183
				local v941, v942, v943 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

				v938.LanguageSelectorFrame = v941
				v939.LanguageSelectorLabel = v942
				v940.LanguageSelectorMode = v943
				v183.LanguageSelectorMode:SetInteractable(false)
				v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end
		local function localeCodeToLanguageCodeMappingCallback(p59, p60) -- line: 2300
			-- upvalues: v465 (copy), HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v128 (copy), v464 (copy), v467 (copy), t22 (copy), v466 (copy), v469 (copy), u456 (ref), languageCode2 (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p59 then
				v465:Start(function(p61, p62) -- line: 2302
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v128 (copy), v464 (copy), p60 (ref), p59 (copy), v467 (copy), t22 (copy), v466 (copy), v469 (copy), u456 (ref), languageCode2 (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1143 = false
					local s7

					if not p61 then
						s7 = "Experience Source Language Request: Connection error"
					elseif p62.StatusCode == 401 then
						s7 = "Experience Source Language Request: Unauthorized"
					elseif p62.StatusCode < 200 or p62.StatusCode >= 400 then
						s7 = "Experience Source Language Status code: " .. p62.StatusCode
					else
						v1143, s7 = pcall(function() -- line: 2313
							-- upvalues: HttpService (copy), p62 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p62.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1143 then
						v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s7)
					end

					if p60 == nil then
						p60 = s7
					end

					local v1145 = v1143 and p59
					local u1146 = p60

					if v1145 then
						v467:Start(function(p63, p64) -- line: 2261
							-- upvalues: HttpService (copy), t22 (copy), v128 (copy), v466 (copy), u1146 (ref), v1145 (copy), v469 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1227 = false
							local s8

							if not p63 then
								s8 = "Experience Supported Language Request: Connection error"
							elseif p64.StatusCode == 401 then
								s8 = "Experience Supported Language Request: Unauthorized"
							elseif p64.StatusCode < 200 or p64.StatusCode >= 400 then
								s8 = "Experience Supported Language Request Status code: " .. p64.StatusCode
							else
								v1227, s8 = pcall(function() -- line: 2271
									-- upvalues: HttpService (copy), p64 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p64.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1227 then
								v128:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v466 .. " with error message: " .. s8)
							end

							if u1146 == nil then
								u1146 = s8
							end

							local v1229 = v1227 and v1145
							local v1230 = u1146

							if v1229 then
								v469:Start(function(p65, p66) -- line: 2199
									-- upvalues: HttpService (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v128 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1275 = false
									local s9

									if not p65 then
										s9 = "User Experience Language Setting Request: Connection error"
									elseif p66.StatusCode == 401 then
										s9 = "User Experience Language Setting Request: Unauthorized"
									elseif p66.StatusCode < 200 or p66.StatusCode >= 400 then
										s9 = "User Experience Language Setting Request Status code: " .. p66.StatusCode
									else
										v1275, s9 = pcall(function() -- line: 2210
											-- upvalues: HttpService (copy), p66 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p66.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u456 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u456 = languageCode
												else
													u456 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u456 = languageCode2

													return
												end

												u456 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1275 then
										v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v468 .. " with error message: " .. s9)
									end

									userExperienceLanguageSettingsCallback(v1275, s9)
								end)

								return
							end

							if v1230 == nil then
								v1230 = "Execution path did not set earliest error to non-nil value."
							end

							v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1230)

							local v1231 = v183
							local v1232 = v183
							local v1233 = v183
							local v1234, v1235, v1236 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

							v1231.LanguageSelectorFrame = v1234
							v1232.LanguageSelectorLabel = v1235
							v1233.LanguageSelectorMode = v1236
							v183.LanguageSelectorMode:SetInteractable(false)
							v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1147 = u1146

						if v1147 == nil then
							v1147 = "Execution path did not set earliest error to non-nil value."
						end

						v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1147)

						local v1148 = v183
						local v1149 = v183
						local v1150 = v183
						local v1151, v1152, v1153 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

						v1148.LanguageSelectorFrame = v1151
						v1149.LanguageSelectorLabel = v1152
						v1150.LanguageSelectorMode = v1153
						v183.LanguageSelectorMode:SetInteractable(false)
						v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v947 = p60

				if v947 == nil then
					v947 = "Execution path did not set earliest error to non-nil value."
				end

				v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v947)

				local v948 = v183
				local v949 = v183
				local v950 = v183
				local v951, v952, v953 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

				v948.LanguageSelectorFrame = v951
				v949.LanguageSelectorLabel = v952
				v950.LanguageSelectorMode = v953
				v183.LanguageSelectorMode:SetInteractable(false)
				v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		v463:Start(function(p67, p68) -- line: 2344
			-- upvalues: HttpService (copy), t24 (copy), t25 (copy), t23 (copy), LocaleId (copy), languageCode2 (ref), v128 (copy), v462 (copy), v465 (copy), languageCode (ref), localeCode (ref), v464 (copy), v467 (copy), t22 (copy), v466 (copy), v469 (copy), u456 (ref), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local v956 = false
			local s10

			if not p67 then
				s10 = "Locale Code to Language Code Mapping Request: Connection error"
			elseif p68.StatusCode == 401 then
				s10 = "Locale Code to Language Code Mapping Request: Unauthorized"
			elseif p68.StatusCode < 200 or p68.StatusCode >= 400 then
				s10 = "Locale Code to Language Code Mapping Request Status code: " .. p68.StatusCode
			else
				v956, s10 = pcall(function() -- line: 2355
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

			if not v956 then
				v128:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v462 .. " with error message: " .. s10)
			end

			local v958 = v956
			local u959 = s10

			if v958 then
				v465:Start(function(p69, p70) -- line: 2302
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v128 (copy), v464 (copy), u959 (ref), v958 (copy), v467 (copy), t22 (copy), v466 (copy), v469 (copy), u456 (ref), languageCode2 (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1163 = false
					local s11

					if not p69 then
						s11 = "Experience Source Language Request: Connection error"
					elseif p70.StatusCode == 401 then
						s11 = "Experience Source Language Request: Unauthorized"
					elseif p70.StatusCode < 200 or p70.StatusCode >= 400 then
						s11 = "Experience Source Language Status code: " .. p70.StatusCode
					else
						v1163, s11 = pcall(function() -- line: 2313
							-- upvalues: HttpService (copy), p70 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p70.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1163 then
						v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v464 .. " with error message: " .. s11)
					end

					if u959 == nil then
						u959 = s11
					end

					local v1165 = v1163 and v958
					local u1166 = u959

					if v1165 then
						v467:Start(function(p71, p72) -- line: 2261
							-- upvalues: HttpService (copy), t22 (copy), v128 (copy), v466 (copy), u1166 (ref), v1165 (copy), v469 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy), v183 (copy), Utility (copy), RobloxTranslator (copy), v89 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1239 = false
							local s12

							if not p71 then
								s12 = "Experience Supported Language Request: Connection error"
							elseif p72.StatusCode == 401 then
								s12 = "Experience Supported Language Request: Unauthorized"
							elseif p72.StatusCode < 200 or p72.StatusCode >= 400 then
								s12 = "Experience Supported Language Request Status code: " .. p72.StatusCode
							else
								v1239, s12 = pcall(function() -- line: 2271
									-- upvalues: HttpService (copy), p72 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p72.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1239 then
								v128:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v466 .. " with error message: " .. s12)
							end

							if u1166 == nil then
								u1166 = s12
							end

							local v1241 = v1239 and v1165
							local v1242 = u1166

							if v1241 then
								v469:Start(function(p73, p74) -- line: 2199
									-- upvalues: HttpService (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v128 (copy), v468 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1282 = false
									local s13

									if not p73 then
										s13 = "User Experience Language Setting Request: Connection error"
									elseif p74.StatusCode == 401 then
										s13 = "User Experience Language Setting Request: Unauthorized"
									elseif p74.StatusCode < 200 or p74.StatusCode >= 400 then
										s13 = "User Experience Language Setting Request Status code: " .. p74.StatusCode
									else
										v1282, s13 = pcall(function() -- line: 2210
											-- upvalues: HttpService (copy), p74 (copy), u456 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p74.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u456 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u456 = languageCode
												else
													u456 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u456 = languageCode2

													return
												end

												u456 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1282 then
										v128:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v468 .. " with error message: " .. s13)
									end

									userExperienceLanguageSettingsCallback(v1282, s13)
								end)

								return
							end

							if v1242 == nil then
								v1242 = "Execution path did not set earliest error to non-nil value."
							end

							v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1242)

							local v1243 = v183
							local v1244 = v183
							local v1245 = v183
							local v1246, v1247, v1248 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

							v1243.LanguageSelectorFrame = v1246
							v1244.LanguageSelectorLabel = v1247
							v1245.LanguageSelectorMode = v1248
							v183.LanguageSelectorMode:SetInteractable(false)
							v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1167 = u1166

						if v1167 == nil then
							v1167 = "Execution path did not set earliest error to non-nil value."
						end

						v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1167)

						local v1168 = v183
						local v1169 = v183
						local v1170 = v183
						local v1171, v1172, v1173 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

						v1168.LanguageSelectorFrame = v1171
						v1169.LanguageSelectorLabel = v1172
						v1170.LanguageSelectorMode = v1173
						v183.LanguageSelectorMode:SetInteractable(false)
						v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v960 = u959

				if v960 == nil then
					v960 = "Execution path did not set earliest error to non-nil value."
				end

				v128:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v960)

				local v961 = v183
				local v962 = v183
				local v963 = v183
				local v964, v965, v966 = Utility:AddNewRow(v183, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v89 }, 1)

				v961.LanguageSelectorFrame = v964
				v962.LanguageSelectorLabel = v965
				v963.LanguageSelectorMode = v966
				v183.LanguageSelectorMode:SetInteractable(false)
				v183.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end)
	end
	local function getChatTranslationLayerData(p75) -- line: 2394
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

		local ok, result = pcall(function() -- line: 2416
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
	local function createVolumeOptions() -- line: 2434
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), FFlagRenameVolumeToMainVolume (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v478 = math.floor(GameSettings.MasterVolume * 10)
		local v479 = v183
		local v480 = v183
		local v481 = v183
		local v482, v483, v484 = Utility:AddNewRow(v183, not FFlagRenameVolumeToMainVolume and "Volume" or RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.MainVolume"), "Slider", 10, v478)

		v479.VolumeFrame = v482
		v480.VolumeLabel = v483
		v481.VolumeSlider = v484
		v183.VolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VolumeFrame

		local Sound = Instance.new("Sound", game:GetService("CoreGui").RobloxGui.Sounds)

		Sound.Name = "VolumeChangeSound"
		Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
		v183.VolumeSlider.ValueChanged:connect(function(p76) -- line: 2447
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), Sound (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v968 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v968 = math.floor(GameSettings.MasterVolume * 10 + 0.5)
			end

			local v969 = p76 / 10

			Sound.Volume = v969
			Sound:Play()
			GameSettings.MasterVolume = v969

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("volume", v968, (math.floor(GameSettings.MasterVolume * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPartyVoiceVolumeOptions() -- line: 2465
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v486 = math.floor(GameSettings.PartyVoiceVolume * 10)
		local v487 = v183
		local v488 = v183
		local v489 = v183
		local v490, v491, v492 = Utility:AddNewRow(v183, "Party Voice Volume", "Slider", 10, v486)

		v487.PartyVoiceVolumeFrame = v490
		v488.PartyVoiceVolumeLabel = v491
		v489.PartyVoiceVolumeSlider = v492
		v183.PartyVoiceVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PartyVoiceVolumeFrame

		if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			v183.PartyVoiceVolumeFrame.Visible = default4.hasExperienceStarted
			default4.ExperienceJoined.Event:Connect(function() -- line: 2474
				-- upvalues: v183 (copy)
				v183.PartyVoiceVolumeFrame.Visible = true
			end)
			default4.ExperienceLeft.Event:Connect(function() -- line: 2477
				-- upvalues: v183 (copy)
				v183.PartyVoiceVolumeFrame.Visible = false
			end)
		end

		v183.PartyVoiceVolumeSlider.ValueChanged:connect(function(p77) -- line: 2482
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v486 (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v971 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v971 = v486 == nil and 0 or math.floor(v486 * 10 + 0.5)
			end

			GameSettings.PartyVoiceVolume = p77 / 10

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("party_voice_volume", v971, (math.floor(p77 * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createVoiceChatVolumeOptions() -- line: 2498
		-- upvalues: GameSettings (copy), u24 (ref), v128 (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v70 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v493 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
		local ok, result = pcall(function() -- line: 2500
			-- upvalues: u24 (ref)
			return u24:Format("CoreScripts.InGameMenu.GameSettings.VoiceChatVolume")
		end)

		if not ok then
			result = "Voice Chat Volume"
			v128:debug("[GameSettings] createVoiceChatVolumeOptions failed to get translation for Voice Chat Volume label, using placeholder text instead")
		end

		local v496 = v183
		local v497 = v183
		local v498 = v183
		local v499, v500, v501 = Utility:AddNewRow(v183, result, "Slider", 10, v493)

		v496.VoiceChatVolumeFrame = v499
		v497.VoiceChatVolumeLabel = v500
		v498.VoiceChatVolumeSlider = v501
		v183.VoiceChatVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceChatVolumeFrame
		v183.VoiceChatVolumeFrame.Visible = false

		if v70 then
			local function updateVoiceChatVolumeSliderInteractable(n10: number?) -- line: 2515
				-- upvalues: GameSettings (copy), v183 (copy)
				if if n10 == nil then GameSettings.MasterVolume == 0 else n10 == 0 then
					v183.VoiceChatVolumeSlider:SetZIndex(1)
					v183.VoiceChatVolumeLabel.ZIndex = 1
					v183.VoiceChatVolumeSlider:SetInteractable(false)

					return
				end

				v183.VoiceChatVolumeSlider:SetZIndex(2)
				v183.VoiceChatVolumeLabel.ZIndex = 2
				v183.VoiceChatVolumeSlider:SetInteractable(true)
			end

			updateVoiceChatVolumeSliderInteractable()
			v183.VolumeSlider.ValueChanged:connect(updateVoiceChatVolumeSliderInteractable)
		end

		v183.VoiceChatVolumeSlider.ValueChanged:connect(function(p78) -- line: 2535
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v183 (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v974 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v974 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
			end

			GameSettings.VoiceChatVolume = p78 / 5

			if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and v183.maxVoiceChatVolumeDuringSession ~= nil then
				v183.maxVoiceChatVolumeDuringSession = math.max(v183.maxVoiceChatVolumeDuringSession, GameSettings.VoiceChatVolume)
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("voice_chat_volume", v974, (math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createHapticsToggle() -- line: 2560
		-- upvalues: GameSettings (copy), getAppFeaturePolicies (copy), u24 (ref), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v503 = GameSettings.HapticStrength ~= 0 and 2 or 1
		local v504 = not getAppFeaturePolicies().getShouldUseVibrationInsteadOfHaptics() and "Haptics" or u24:Format("CoreScripts.InGameMenu.Vibration")
		local v505 = v183
		local v506 = v183
		local v507, v508, v509 = Utility:AddNewRow(v183, v504, "Selector", {
			"Off",
			"On"
		}, v503)

		v505.HapticsFrame = v507
		_ = v508
		v506.HapticsSelector = v509
		v183.HapticsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.HapticsFrame
		v183.HapticsSelector.IndexChanged:connect(function(p79) -- line: 2569
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
	local function createCameraInvertedOptions() -- line: 2585
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n11 = 1

		if pcall(function() -- line: 2587
			-- upvalues: GameSettings (copy), n11 (ref)
			if GameSettings.CameraYInverted == true then
				n11 = 2
			end
		end) == false then
			return
		end

		local v511 = v183
		local v512 = v183
		local v513, v514, v515 = Utility:AddNewRow(v183, "Camera Inverted", "Selector", {
			"Off",
			"On"
		}, n11)

		v511.CameraInvertedFrame = v513
		_ = v514
		v512.CameraInvertedSelector = v515
		v183.CameraInvertedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraInvertedFrame
		t10[v183.CameraInvertedFrame] = true
		v183.CameraInvertedSelector.IndexChanged:connect(function(p80) -- line: 2602
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
	local function setCameraSensitivity(p81) -- line: 2621
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
	local function createMouseOptions() -- line: 2659
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), setCameraSensitivity (copy)
		local function translateEngineMouseSensitivityToGui(p82) -- line: 2664
			local v980 = p82 <= 1 and math.floor((p82 - 0.2) / 0.16 + 0.5) or math.floor((p82 + 2) / 0.6 + 0.5)

			if p82 <= 0.2 then
				return 0
			end

			return v980
		end
		local function translateGuiMouseSensitivityToEngine(p83) -- line: 2672
			local v982 = p83 <= 5 and 0.16 * p83 + 0.2 or 0.6 * p83 - 2

			if v982 <= 0.2 then
				return 0.2
			end

			return v982
		end

		local MouseSensitivity = GameSettings.MouseSensitivity
		local v523 = MouseSensitivity <= 1 and math.floor((MouseSensitivity - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivity + 2) / 0.6 + 0.5)
		local v524 = if not (MouseSensitivity <= 0.2) then v523 else 0
		local u525 = true

		tostring(GameSettings.MouseSensitivityFirstPerson.X)

		local v526 = v183
		local v527 = v183
		local v528 = v183
		local v529, v530, v531 = Utility:AddNewRow(v183, "Camera Sensitivity", "Slider", 10, v524)

		v526.MouseAdvancedFrame = v529
		v527.MouseAdvancedLabel = v530
		v528.MouseAdvancedEntry = v531
		v183.MouseAdvancedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MouseAdvancedFrame
		t10[v183.MouseAdvancedFrame] = true
		v183.MouseAdvancedEntry.SliderFrame.Size = UDim2.new(v183.MouseAdvancedEntry.SliderFrame.Size.X.Scale, v183.MouseAdvancedEntry.SliderFrame.Size.X.Offset - 60 - 20, v183.MouseAdvancedEntry.SliderFrame.Size.Y.Scale, v183.MouseAdvancedEntry.SliderFrame.Size.Y.Offset - 6)
		v183.MouseAdvancedEntry.SliderFrame.Position = UDim2.new(v183.MouseAdvancedEntry.SliderFrame.Position.X.Scale, v183.MouseAdvancedEntry.SliderFrame.Position.X.Offset - 60 - 20, v183.MouseAdvancedEntry.SliderFrame.Position.Y.Scale, v183.MouseAdvancedEntry.SliderFrame.Position.Y.Offset)
		v183.MouseAdvancedLabel.ZIndex = 2
		v183.MouseAdvancedEntry:SetInteractable(true)

		local v532 = Create("TextBox")({
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
			Parent = v183.MouseAdvancedEntry.SliderFrame
		})

		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = v532
		})

		local function setMouseSensitivityText(p84) -- line: 2731
			-- upvalues: v532 (copy)
			local v984 = math.floor(p84 * 1000 + 0.5) / 1000

			v532.Text = tostring((tonumber((string.format("%.3f", v984)))))
		end

		local v534 = math.floor(GameSettings.MouseSensitivityFirstPerson.X * 1000 + 0.5) / 1000

		v532.Text = tostring((tonumber((string.format("%.3f", v534)))))

		local MouseAdvancedEntry = v183.MouseAdvancedEntry
		local MouseSensitivityFirstPersonX = GameSettings.MouseSensitivityFirstPerson.X
		local v537 = MouseSensitivityFirstPersonX <= 1 and math.floor((MouseSensitivityFirstPersonX - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivityFirstPersonX + 2) / 0.6 + 0.5)

		MouseAdvancedEntry:SetValue(if not (MouseSensitivityFirstPersonX <= 0.2) then v537 else 0)

		function clampMouseSensitivity(p85) -- line: 2746
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
		function setMouseSensitivity(p86, p87) -- line: 2764
			-- upvalues: u525 (ref), setCameraSensitivity (copy), v183 (copy), v532 (copy)
			if not u525 then
				return
			end

			setCameraSensitivity(p86)
			u525 = false

			if p87 ~= v183.MouseAdvancedEntry then
				local MouseAdvancedEntry2 = v183.MouseAdvancedEntry
				local v989 = p86 <= 1 and math.floor((p86 - 0.2) / 0.16 + 0.5) or math.floor((p86 + 2) / 0.6 + 0.5)

				MouseAdvancedEntry2:SetValue(if not (p86 <= 0.2) then v989 else 0)
			end

			local v990 = math.floor(p86 * 1000 + 0.5) / 1000

			v532.Text = tostring((tonumber((string.format("%.3f", v990)))))
			u525 = true
		end

		v532.FocusLost:connect(function() -- line: 2782
			-- upvalues: v183 (copy), v532 (copy), GameSettings (copy)
			v183.MouseAdvancedEntry:SetInteractable(true)

			local num = tonumber((string.match(v532.Text, "([%d%.]+)")))

			if num then
				setMouseSensitivity(clampMouseSensitivity(num), v532)

				return
			end

			setMouseSensitivity(GameSettings.MouseSensitivityFirstPerson.X, v532)
		end)
		v532.Focused:connect(function() -- line: 2794
			-- upvalues: v183 (copy)
			v183.MouseAdvancedEntry:SetInteractable(false)
		end)
		v183.MouseAdvancedEntry.ValueChanged:connect(function(p88) -- line: 2798
			-- upvalues: v183 (copy)
			local v993 = clampMouseSensitivity(p88)
			local v994 = v993 <= 5 and 0.16 * v993 + 0.2 or 0.6 * v993 - 2
			local v995 = if not (v994 <= 0.2) then v994 else 0.2

			setMouseSensitivity(v995, v183.MouseAdvancedEntry)
		end)
	end
	local function createGamepadOptions() -- line: 2805
		-- upvalues: GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), setCameraSensitivity (copy)
		local function translateEngineGamepadSensitivityToGui(p89) -- line: 2810
			local v997 = p89 <= 1 and math.floor((p89 - 0.2) / 0.16 + 0.5) or math.floor((p89 + 2) / 0.6 + 0.5)

			if p89 <= 0.2 then
				return 0
			end

			return v997
		end
		local function translateGuiGamepadSensitivityToEngine(p90) -- line: 2817
			local v999 = p90 <= 5 and 0.16 * p90 + 0.2 or 0.6 * p90 - 2

			if v999 <= 0.2 then
				return 0.2
			end

			return v999
		end

		local GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity
		local v541 = GamepadCameraSensitivity <= 1 and math.floor((GamepadCameraSensitivity - 0.2) / 0.16 + 0.5) or math.floor((GamepadCameraSensitivity + 2) / 0.6 + 0.5)
		local v542 = if not (GamepadCameraSensitivity <= 0.2) then v541 else 0
		local v543 = v183
		local v544 = v183
		local v545 = v183
		local v546, v547, v548 = Utility:AddNewRow(v183, "Camera Sensitivity", "Slider", 10, v542)

		v543.GamepadSensitivityFrame = v546
		v544.GamepadSensitivityLabel = v547
		v545.GamepadSensitivitySlider = v548
		v183.GamepadSensitivityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GamepadSensitivityFrame
		v183.GamepadSensitivitySlider.ValueChanged:connect(function(p91) -- line: 2832
			-- upvalues: setCameraSensitivity (copy)
			local v1001 = setCameraSensitivity
			local v1002 = p91 <= 5 and 0.16 * p91 + 0.2 or 0.6 * p91 - 2

			v1001(if not (v1002 <= 0.2) then v1002 else 0.2)
		end)
	end
	local function createOverscanOption() -- line: 2837
		-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy), Utility (copy), v183 (copy), Theme (copy), RunService (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v549, v550, v551 = Utility:MakeStyledButton("AdjustButton", "Adjust", UDim2.new(0, 300, 1, -20), function() -- line: 2838
			-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
			local Overscan = require(RobloxGui.Modules.Shell.Components.Overscan10ft.Overscan)
			local v1005 = require(RobloxGui.Modules.Settings.Components.OverscanWrapper)(Overscan)
			local Roact = require(CorePackages.Packages.Roact)
			local u1007 = nil
			local t29 = {
				onUnmount = function() -- line: 2849
					-- upvalues: u1007 (ref), Roact (copy), ContextActionService (copy), SettingsHub (copy)
					if u1007 then
						Roact.unmount(u1007)
						ContextActionService:UnbindCoreAction("RbxStopOverscanMovement")
						SettingsHub:SetVisibility(true, true)
					end
				end,
				ImageVisible = false,
				BackgroundTransparency = 0.2
			}

			SettingsHub:SetVisibility(false, true)
			ContextActionService:BindCoreAction("RbxStopOverscanMovement", function() -- line: 2865
			end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

			local v1009 = Roact.createElement(v1005, t29)

			u1007 = Roact.mount(v1009, RobloxGui, (tostring(v1005)))
		end, v183)

		v550.Font = Theme.font(Enum.Font.SourceSans)
		v549.Position = UDim2.new(1, -400, 0, 12)
		v549.Size = UDim2.new(0, 300, 0, 40)
		v549.Position = UDim2.new(1, -400, 0.5, 0)
		v549.AnchorPoint = Vector2.new(0, 0.5)

		if RunService:IsStudio() then
			v549.Selectable = false
			v549.Active = false
			v549.Enabled.Value = false
			v550.TextColor3 = Color3.fromRGB(100, 100, 100)
		end

		local v552 = Utility:AddNewRowObject(v183, "Safe Zone", v549)

		v552.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.OverscanAdjustButton
		v551(v552)
	end
	local function createDeveloperConsoleOption() -- line: 2904
		-- upvalues: reportSettingsChangeForAnalytics (copy), v143 (copy), Utility (copy), v183 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), RunService (copy), PlayerPermissionsModule (copy), Players (copy)
		local function makeDevConsoleOption() -- line: 2906
			-- upvalues: reportSettingsChangeForAnalytics (copy), v143 (copy), Utility (copy), v183 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local function onOpenDevConsole() -- line: 2907
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

			if v143 then
				local v1011, v1012, v1013 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(1, 0, 1, -20), onOpenDevConsole, v183)

				v1012.Font = Theme.font(Enum.Font.SourceSans)
				v1011.Size = UDim2.new(0.6, -10, 0, 35)
				v1011.Position = UDim2.new(0.4, 10, 0.5, 0)
				v1011.AnchorPoint = Vector2.new(0, 0.5)

				local v1014 = Utility:AddNewRowObject(v183, "Developer Console", v1011, nil, true)

				v1014.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v1013(v1014)

				return
			end

			local v1015, v1016, v1017 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(0, 300, 1, -20), onOpenDevConsole, v183)

			v1016.Font = Theme.font(Enum.Font.SourceSans)
			v1015.Size = UDim2.new(0.6, -10, 0, 35)
			v1015.Position = UDim2.new(1, -400, 0.5, 0)
			v1015.AnchorPoint = Vector2.new(0, 0.5)

			local v1018 = Utility:AddNewRowObject(v183, "Developer Console", v1015)

			v1018.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
			v1017(v1018)
		end

		if RunService:IsStudio() then
			makeDevConsoleOption()

			return
		end

		spawn(function() -- line: 2959
			-- upvalues: PlayerPermissionsModule (copy), Players (copy), makeDevConsoleOption (copy)
			if PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer) then
				makeDevConsoleOption()
			end
		end)
	end
	local function createUiToggleOptions() -- line: 2968
		-- upvalues: v142 (copy), v141 (copy), RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), LocalPlayer (copy)
		if v142 or v141 then
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
			local v555 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
			local v556 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

			v183.uiToggleSelectors = {}

			for __, v558 in t30 do
				local v559 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.ShowGuiType", {
					GuiType = v558.label
				})
				local v560, v561, v562 = Utility:AddNewRow(v183, v559, "Selector", {
					v555,
					v556
				}, 1)

				v560.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER[v558.layoutOrderKey]
				v562.IndexChanged:Connect(function(p92) -- line: 2996
					-- upvalues: GuiService (copy), v558 (copy)
					if p92 ~= (not GuiService:GetGuiIsVisible(v558.type) and 2 or 1) then
						GuiService:ToggleGuiIsVisibleIfAllowed(v558.type)
					end
				end)
				v183.uiToggleSelectors[v558.label] = {
					label = v559,
					type = v558.type,
					row = v560,
					frame = v561,
					selector = v562
				}
			end

			local v563 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.Freecam")
			local v564 = v183
			local v565 = v183
			local v566 = v183
			local v567, v568, v569 = Utility:AddNewRow(v183, v563, "Selector", {
				v556,
				v555
			}, 1)

			v564.freecamRow = v567
			v565.freecamFrame = v568
			v566.freecamSelector = v569
			v183.freecamRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FreecamToggleRow
			v183.freecamSelector.IndexChanged:Connect(function(p93) -- line: 3018
				-- upvalues: LocalPlayer (copy)
				local v1021 = p93 == 2
				local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

				if not FreecamScript then
					warn("Freecam not present")

					return
				end

				FreecamScript:SetAttribute("FreecamEnabled", v1021)
			end)

			return
		end

		local v570 = v183
		local v571 = v183
		local v572 = v183
		local v573, v574, v575 = Utility:AddNewRow(v183, "BillboardGui Visibility", "Selector", {
			"All visible",
			"Hide nameplates/bubble chat"
		}, 1)

		v570.uiToggleRow = v573
		v571.uiToggleFrame = v574
		v572.uiToggleSelector = v575
		v183.uiToggleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiToggleRow
		v183.uiToggleSelector.IndexChanged:connect(function(__) -- line: 3037
			-- upvalues: GuiService (copy)
			GuiService:ToggleGuiIsVisibleIfAllowed(Enum.GuiType.PlayerNameplates)
		end)
	end
	local function updateUiToggleSelection() -- line: 3043
		-- upvalues: v142 (copy), v141 (copy), v183 (copy), GuiService (copy), LocalPlayer (copy)
		if v142 or v141 then
			if not v183.uiToggleSelectors then
				return
			end

			for __, v577 in v183.uiToggleSelectors do
				local v578 = not GuiService:GetGuiIsVisible(v577.type) and 2 or 1

				if v578 ~= v577.selector:GetSelectedIndex() then
					v577.selector:SetSelectionIndex(v578)
				end
			end

			local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

			if FreecamScript then
				local v580 = not FreecamScript:GetAttribute("FreecamEnabled") and 1 or 2

				v183.freecamSelector:SetSelectionIndex(v580)

				return
			end
		else
			if not v183.uiToggleSelector then
				return
			end

			local v581 = not GuiService:GetGuiIsVisible(Enum.GuiType.PlayerNameplates) and 2 or 1

			if v581 == v183.uiToggleSelector:GetSelectedIndex() then
				return
			end

			v183.uiToggleSelector:SetSelectionIndex(v581)
		end
	end
	local function isValidDeviceList(p95, p96, p97) -- line: 3085
		return p95 and (p96 and (p97 and (#p95 > 0 and (p97 > 0 and (p97 <= #p95 and #p95 == #p96)))))
	end
	local function SwitchOutputDevice(p98, p99) -- line: 3098
		-- upvalues: SoundService (copy), v128 (copy)
		SoundService:SetOutputDevice(p98, p99)
		v128:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", p98, p99)
	end
	local function createDeviceOptions(p100) -- line: 3103
		-- upvalues: v183 (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), SoundService (copy), v128 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
		local v588 = v183[p100 .. "DeviceIndex"] or 0
		local v589 = v183[p100 .. "DeviceNames"] or {}
		local v590 = v183[p100 .. "DeviceGuids"] or {}
		local v591 = p100 == "Input" and RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.InputDevice") or RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.OutputDevice")
		local v592 = v183
		local v593 = p100 .. "DeviceFrame"
		local v594 = v183
		local v595 = p100 .. "DeviceSelector"
		local v596, v597, v598 = Utility:AddNewRow(v183, v591, "Selector", v589, v588)

		v592[v593] = v596
		_ = v597
		v594[v595] = v598
		v183[p100 .. "DeviceFrame"].LayoutOrder = p100 == "Input" and SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameInput or SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameOutput
		v183[p100 .. "DeviceInfo"] = {
			Name = v588 > 0 and v589[v588] or nil,
			Guid = v588 > 0 and v590[v588] or nil
		}
		v183[p100 .. "PrevDeviceName"] = v183[p100 .. "DeviceInfo"].Name

		local n12 = 0
		local v600 = GetFIntVoiceChatDeviceChangeDebounceDelay()

		v183[p100 .. "DeviceSelector"].IndexChanged:connect(function(p101) -- line: 3126
			-- upvalues: v183 (copy), p100 (copy), n12 (ref), v600 (copy), default3 (copy), SoundService (copy), v128 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
			if v183[p100 .. "DeviceInfo"].Name == v183[p100 .. "DeviceNames"][p101] and v183[p100 .. "DeviceInfo"].Guid == v183[p100 .. "DeviceGuids"][p101] then
				return
			end

			local v1025 = n12 + 1

			n12 = v1025
			wait(v600)

			if v1025 == n12 then
				n12 = 0
				v183[p100 .. "DeviceInfo"] = {
					Name = v183[p100 .. "DeviceNames"][p101],
					Guid = v183[p100 .. "DeviceGuids"][p101]
				}

				local Name = v183[p100 .. "DeviceInfo"].Name
				local Guid = v183[p100 .. "DeviceInfo"].Guid

				if v183.VoiceChatOptionsEnabled then
					default3:SwitchDevice(p100, Name, Guid)
				else
					SoundService:SetOutputDevice(Name, Guid)
					v128:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", Name, Guid)
				end

				if GetFFlagEnableCrossExpVoice() then
					v128:debug("[GameSettings] Changing {} device to {} {} ", p100, Name, Guid)

					if p100 == "Input" then
						default4:changeInputDevice(Name, Guid)
					else
						default4:changeOutputDevice(Name, Guid)
					end
				end

				reportSettingsChangeForAnalytics(p100, v183[p100 .. "PrevDeviceName"], Name)
				v183[p100 .. "PrevDeviceName"] = Name
			end
		end)
	end
	local function createBadgeVisibilityOptions() -- line: 3168
		-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v151 (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
		spawn(function() -- line: 3169
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v151 (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n13 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n13 = 1
			end

			local v1029 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v1030 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v1031 = if not v151 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v1032 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v1033 = v183
			local v1034 = v183
			local v1035 = v183
			local v1036, v1037, v1038 = Utility:AddNewRow(v183, v1031, "Selector", {
				v1030,
				v1029
			}, n13, nil, v1032)

			v1033.badgeVisibleRow = v1036
			v1034.badgeVisibleFrame = v1037
			v1035.badgeVisibleSelector = v1038
			v183.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v183.badgeVisibleSelector.IndexChanged:connect(function(p102) -- line: 3183
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p102 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p102 == 1)
			end)
		end)
	end
	local function createChatModerationOptions() -- line: 3190
		-- upvalues: v183 (copy), Utility (copy), u24 (ref), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), Signals (copy), reportSettingsChangeForAnalytics (copy)
		local __ = {
			title = "CoreScripts.InGameMenu.GameSettings.ReadOnlyView",
			description = "CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}
		local v602 = v183
		local v603 = v183
		local v604, v605, v606 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyView"), "Selector", {
			u24:Format("InGame.CommonUI.Label.Off"),
			u24:Format("InGame.CommonUI.Label.On")
		}, 1, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription"))

		v602.ChatModerationFrame = v604
		_ = v605
		v603.ChatModerationSelector = v606
		v183.ChatModerationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatModerationFrame
		v183.ChatModerationFrame.Visible = false

		local v607 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetChatModerationStore(false)

		v183.ChatModerationDisposeEffect = Signals.createEffect(function(p103) -- line: 3214
			-- upvalues: v183 (copy), v607 (copy)
			v183.ChatModerationFrame.Visible = v607.getIsSettingVisible(p103)

			local v1040 = not v607.getIsSettingEnabled(p103) and 1 or 2

			if v1040 ~= v183.ChatModerationSelector:GetSelectedIndex() then
				v183.ChatModerationSelector:SetSelectionIndex(v1040)
			end
		end)
		v183.ChatModerationSelector.IndexChanged:connect(function(p104) -- line: 3223
			-- upvalues: v607 (copy), reportSettingsChangeForAnalytics (copy)
			local v1042 = p104 == 2

			v607.setIsSettingEnabled(v1042)
			reportSettingsChangeForAnalytics("moderate_chat", not v1042, v1042)
		end)
		v607.initialize()
	end
	local function createAIRephraseSettingOptions() -- line: 3232
		-- upvalues: RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceAIRephraseSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy), v152 (copy), ThrottleFunctionCall (copy)
		local v608 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessages")
		local v609 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessagesDescription")
		local v610 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v611 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v612 = v183
		local v613 = v183
		local v614, v615, v616 = Utility:AddNewRow(v183, v608, "Selector", {
			v611,
			v610
		}, 1, nil, v609)

		v612.AIRephraseFrame = v614
		_ = v615
		v613.AIRephraseSelector = v616
		v183.AIRephraseFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AIRephraseFrame
		v183.AIRephraseFrame.Visible = false

		local v617 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getAIRephraseSettingStore(false)
		local v618 = GetFIntDebounceAIRephraseSettingDelay()
		local v619 = v618 > 0
		local u620 = not v617.getIsSettingEnabled(false) and 1 or 2

		v183.AIRephraseDisposeEffect = Signals.createEffect(function(p105) -- line: 3258
			-- upvalues: v183 (copy), v617 (copy), u620 (ref)
			v183.AIRephraseFrame.Visible = v617.getIsSettingVisible(p105)

			local v1044 = not v617.getIsSettingEnabled(p105) and 1 or 2

			if v1044 ~= v183.AIRephraseSelector:GetSelectedIndex() then
				u620 = v1044
				v183.AIRephraseSelector:SetSelectionIndex(v1044)
			end
		end)

		local function v621(p106) -- line: 3269
			-- upvalues: u620 (ref), TextChatService (copy), v617 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
			if p106 == u620 then
				return
			end

			local v1046 = p106 == 2

			task.spawn(function() -- line: 3275
				-- upvalues: TextChatService (copy), v1046 (copy), v617 (copy), u620 (ref), p106 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
				if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1046 and "Disabled" or "Enabled") then
					v617.setIsSettingEnabled(v1046)
					u620 = p106
					reportSettingsChangeForAnalytics("ai_rephrase", not v1046, v1046)

					return
				end

				v183.AIRephraseSelector:SetSelectionIndex(u620)
			end)
		end

		if v152 then
			if v619 then
				local u622 = nil

				v183.AIRephraseSelector.IndexChanged:connect(function(p107) -- line: 3292
					-- upvalues: u622 (ref), v618 (copy), u620 (ref), TextChatService (copy), v617 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
					if u622 then
						task.cancel(u622)
					end

					u622 = task.delay(v618, function() -- line: 3296
						-- upvalues: u622 (ref), p107 (copy), u620 (ref), TextChatService (copy), v617 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
						u622 = nil

						local v1177 = p107

						if v1177 == u620 then
							return
						end

						local v1178 = v1177 == 2

						task.spawn(function() -- line: 3275
							-- upvalues: TextChatService (copy), v1178 (copy), v617 (copy), u620 (ref), v1177 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
							if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1178 and "Disabled" or "Enabled") then
								v617.setIsSettingEnabled(v1178)
								u620 = v1177
								reportSettingsChangeForAnalytics("ai_rephrase", not v1178, v1178)

								return
							end

							v183.AIRephraseSelector:SetSelectionIndex(u620)
						end)
					end)
				end)
			else
				v183.AIRephraseSelector.IndexChanged:connect(v621)
			end
		else
			v183.AIRephraseSelector.IndexChanged:connect(if not v619 then v621 else ThrottleFunctionCall(v618, v621))
		end
	end
	local function createChatSummariesSettingOptions() -- line: 3309
		-- upvalues: RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceChatSummariesSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy)
		local v623 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummaries")
		local v624 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummariesDescription")
		local v625 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v626 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v627 = v183
		local v628 = v183
		local v629, v630, v631 = Utility:AddNewRow(v183, v623, "Selector", {
			v626,
			v625
		}, 1, nil, v624)

		v627.ChatSummariesFrame = v629
		_ = v630
		v628.ChatSummariesSelector = v631
		v183.ChatSummariesFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatSummariesFrame
		v183.ChatSummariesFrame.Visible = false

		local v632 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getChatSummariesSettingStore(false)
		local v633 = GetFIntDebounceChatSummariesSettingDelay()
		local v634 = v633 > 0
		local u635 = not v632.getIsSettingEnabled(false) and 1 or 2

		v183.ChatSummariesDisposeEffect = Signals.createEffect(function(p108) -- line: 3335
			-- upvalues: v183 (copy), v632 (copy), u635 (ref)
			v183.ChatSummariesFrame.Visible = v632.getIsSettingVisible(p108)

			local v1049 = not v632.getIsSettingEnabled(p108) and 1 or 2

			if v1049 ~= v183.ChatSummariesSelector:GetSelectedIndex() then
				u635 = v1049
				v183.ChatSummariesSelector:SetSelectionIndex(v1049)
			end
		end)

		if v634 then
			local u636 = nil

			v183.ChatSummariesSelector.IndexChanged:connect(function(p109) -- line: 3368
				-- upvalues: u636 (ref), v633 (copy), u635 (ref), TextChatService (copy), v632 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
				if u636 then
					task.cancel(u636)
				end

				u636 = task.delay(v633, function() -- line: 3372
					-- upvalues: u636 (ref), p109 (copy), u635 (ref), TextChatService (copy), v632 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
					u636 = nil

					local v1179 = p109

					if v1179 == u635 then
						return
					end

					local v1180 = v1179 == 2

					task.spawn(function() -- line: 3352
						-- upvalues: TextChatService (copy), v1180 (copy), v632 (copy), u635 (ref), v1179 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
						if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1180 and "Disabled" or "Enabled") then
							v632.setIsSettingEnabled(v1180)
							u635 = v1179
							reportSettingsChangeForAnalytics("chat_summaries", not v1180, v1180)

							return
						end

						v183.ChatSummariesSelector:SetSelectionIndex(u635)
					end)
				end)
			end)
		else
			v183.ChatSummariesSelector.IndexChanged:connect(function(p110) -- line: 3346
				-- upvalues: u635 (ref), TextChatService (copy), v632 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
				if p110 == u635 then
					return
				end

				local v1051 = p110 == 2

				task.spawn(function() -- line: 3352
					-- upvalues: TextChatService (copy), v1051 (copy), v632 (copy), u635 (ref), p110 (copy), reportSettingsChangeForAnalytics (copy), v183 (copy)
					if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1051 and "Disabled" or "Enabled") then
						v632.setIsSettingEnabled(v1051)
						u635 = p110
						reportSettingsChangeForAnalytics("chat_summaries", not v1051, v1051)

						return
					end

					v183.ChatSummariesSelector:SetSelectionIndex(u635)
				end)
			end)
		end
	end
	local function createChatNotificationsSettingOptions() -- line: 3382
		-- upvalues: CorePackages (copy), RobloxTranslator (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy)
		local ToastNotification = require(CorePackages.Workspace.Packages.ToastNotification)
		local default5 = ToastNotification.ToastNotificationSnoozeManager.default
		local NotificationGroups = ToastNotification.NotificationGroups
		local ToastNotificationTypeModule = ToastNotification.ToastNotificationTypeModule
		local NotificationSnoozedSignal = ToastNotification.Signals.NotificationSnoozedSignal
		local NotificationTypeEnum = ToastNotificationTypeModule.NotificationTypeEnum
		local SnoozeActionEnum = ToastNotificationTypeModule.SnoozeActionEnum
		local t31 = {
			Off = 1,
			On = 2
		}
		local v645 = RobloxTranslator:FormatByKey("Feature.Chat.Label.InGameFriendsChatNotifications")
		local v646 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v647 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

		local function getSelectorIndex() -- line: 3400
			-- upvalues: default5 (copy), NotificationTypeEnum (copy)
			if default5:isSnoozedNotificationType(NotificationTypeEnum.ChatNewMessage) then
				return 1
			end

			return 2
		end

		local u649 = if not default5:isSnoozedNotificationType(NotificationTypeEnum.ChatNewMessage) then t31.On else t31.Off
		local v650 = v183
		local v651 = v183
		local v652, v653, v654 = Utility:AddNewRow(v183, v645, "Selector", {
			v647,
			v646
		}, u649)

		v650.ChatNotificationsFrame = v652
		_ = v653
		v651.ChatNotificationsSelector = v654
		v183.ChatNotificationsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatNotificationsFrame
		v183.ChatNotificationsSelector.IndexChanged:connect(function(p111) -- line: 3415
			-- upvalues: u649 (ref), default5 (copy), NotificationGroups (copy), reportSettingsChangeForAnalytics (copy)
			if p111 == u649 then
				return
			end

			local v1054 = u649 == 2
			local v1055 = p111 == 2

			u649 = p111

			if v1055 then
				default5:unmuteNotification({
					context = "InGameSettingsChatNotifications",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup
				})
			else
				default5:snoozeNotification({
					durationMinutes = -1,
					context = "InGameSettingsChatNotifications",
					notificationType = NotificationGroups.ChatLandingNotificationsGroup
				})
			end

			reportSettingsChangeForAnalytics("chat_notifications", v1054, v1055)
		end)
		NotificationSnoozedSignal:connect(function(p112) -- line: 3441
			-- upvalues: NotificationTypeEnum (copy), SnoozeActionEnum (copy), v183 (copy), u649 (ref)
			if p112.notificationType ~= NotificationTypeEnum.ChatNewMessage then
				return
			end

			local v1057 = p112.actionType ~= SnoozeActionEnum.Mute and 2 or 1

			if v1057 ~= v183.ChatNotificationsSelector:GetSelectedIndex() then
				u649 = v1057
				v183.ChatNotificationsSelector:SetSelectionIndex(v1057)
			end
		end)
		v183.Displayed.Event:Connect(function() -- line: 3456
			-- upvalues: default5 (copy), NotificationTypeEnum (copy), t31 (copy), v183 (copy), u649 (ref)
			local v1058 = if not default5:isSnoozedNotificationType(NotificationTypeEnum.ChatNewMessage) then t31.On else t31.Off

			if v1058 ~= v183.ChatNotificationsSelector:GetSelectedIndex() then
				u649 = v1058
				v183.ChatNotificationsSelector:SetSelectionIndex(v1058)
			end
		end)
	end
	local function createCameraDeviceOptions() -- line: 3468
		-- upvalues: v183 (copy), v127 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v128 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
		local v655 = v183.CameraDeviceIndex or 1
		local v656 = v183.CameraDeviceNames or {}
		local v657 = v183.CameraDeviceGuids or {}
		local v658 = v127
		local v659 = v183
		local v660 = v183
		local v661, v662, v663 = Utility:AddNewRow(v183, v658, "Selector", v656, v655)

		v659.CameraDeviceFrame = v661
		_ = v662
		v660.CameraDeviceSelector = v663
		v183.CameraDeviceFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraDeviceFrame
		v183.CameraDeviceInfo = {
			Name = v655 > 0 and v656[v655] or nil,
			Guid = v655 > 0 and v657[v655] or nil
		}
		v183.prevCameraDeviceName = v183.CameraDeviceInfo.Name
		v183.CameraDeviceSelector.IndexChanged:connect(function(p113) -- line: 3485
			-- upvalues: v183 (copy), v128 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
			if v183.CameraDeviceInfo.Name == v183.CameraDeviceNames[p113] and v183.CameraDeviceInfo.Guid == v183.CameraDeviceGuids[p113] then
				return
			end

			v183.CameraDeviceInfo = {
				Name = v183.CameraDeviceNames[p113],
				Guid = v183.CameraDeviceGuids[p113]
			}

			local Guid = v183.CameraDeviceInfo.Guid

			v128:info("Changed webcam to: {}", Guid)
			UserGameSettings.DefaultCameraID = Guid
			reportSettingsChangeForAnalytics("video_camera", v183.prevCameraDeviceName or "None", v183.CameraDeviceInfo.Name)
			v183.prevCameraDeviceName = v183.CameraDeviceInfo.Name
		end)
	end
	local function updateAudioDevices(p114) -- line: 3510
		-- upvalues: SoundService (copy), u24 (ref), v183 (copy), GetFFlagVoiceChatUILogging (copy), v128 (copy), createDeviceOptions (copy)
		local ok, result, v667, v668 = pcall(function() -- line: 3511
			-- upvalues: p114 (copy), SoundService (copy)
			if p114 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v667 and (v668 and (#result > 0 and (v668 > 0 and (v668 <= #result and #result == #v667)))))) then
			if v667[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v183[p114 .. "DeviceNames"] = result
			v183[p114 .. "DeviceGuids"] = v667
			v183[p114 .. "DeviceIndex"] = v668
		else
			if GetFFlagVoiceChatUILogging() then
				v128:warning("Errors in get {} device info", p114)
			end

			v183[p114 .. "DeviceNames"] = {}
			v183[p114 .. "DeviceGuids"] = {}
			v183[p114 .. "DeviceIndex"] = 0
		end

		if not v183[p114 .. "DeviceSelector"] then
			createDeviceOptions(p114)

			return
		end

		v183[p114 .. "DeviceSelector"]:UpdateOptions(result)
		v183[p114 .. "DeviceSelector"]:SetSelectionIndex(v668)
	end
	local function updateVoiceChatDevices(p115) -- line: 3543
		-- upvalues: GetFFlagVoiceChatUILogging (copy), v128 (copy), SoundService (copy), u24 (ref), v183 (copy), createDeviceOptions (copy)
		if p115 ~= "Input" and (p115 ~= "Output" and GetFFlagVoiceChatUILogging()) then
			v128:warning("{} is not supported in VoiceChat devices", p115)
		end

		local ok, result, v672, v673 = pcall(function() -- line: 3550
			-- upvalues: p115 (copy), SoundService (copy)
			if p115 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v672 and (v673 and (#result > 0 and (v673 > 0 and (v673 <= #result and #result == #v672)))))) then
			if v672[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v183[p115 .. "DeviceNames"] = result
			v183[p115 .. "DeviceGuids"] = v672
			v183[p115 .. "DeviceIndex"] = v673
		else
			if GetFFlagVoiceChatUILogging() then
				if #result > 0 then
					v128:warning("Errors in get {} device info success: {}", p115, ok)
				else
					v128:warning("Empty deviceNames list for {}", p115)
				end
			end

			v183[p115 .. "DeviceNames"] = {}
			v183[p115 .. "DeviceGuids"] = {}
			v183[p115 .. "DeviceIndex"] = 0
		end

		if not v183[p115 .. "DeviceSelector"] then
			createDeviceOptions(p115)
		else
			v183[p115 .. "DeviceSelector"]:UpdateOptions(result)
			v183[p115 .. "DeviceSelector"]:SetSelectionIndex(v673)
		end

		if v183[p115 .. "DeviceFrame"] then
			if #result > 0 then
				v183[p115 .. "DeviceFrame"].Visible = true

				return
			end

			v183[p115 .. "DeviceFrame"].Visible = false
		end
	end
	local function updateCameraDevices() -- line: 3602
		-- upvalues: VideoCaptureService (copy), v126 (copy), UserGameSettings (copy), v183 (copy), createCameraDeviceOptions (copy)
		local CameraDevices = VideoCaptureService:GetCameraDevices()
		local t32 = {}
		local t33 = {}
		local n14 = 1

		table.insert(t32, v126)
		table.insert(t33, "{DefaultDeviceGuid}")

		for k, v in pairs(CameraDevices) do
			if k == UserGameSettings.DefaultCameraID then
				n14 = #t32 + 1
			end

			table.insert(t32, v)
			table.insert(t33, k)
		end

		v183.CameraDeviceNames = t32
		v183.CameraDeviceGuids = t33
		v183.CameraDeviceIndex = 0

		if not v183.CameraDeviceSelector then
			createCameraDeviceOptions()
		else
			v183.CameraDeviceSelector:UpdateOptions(t32)
		end

		v183.CameraDeviceSelector:SetSelectionIndex(n14)
	end

	local connection = nil
	local connection2 = nil

	local function updateAudioOptions() -- line: 3632
		-- upvalues: v183 (copy), updateVoiceChatDevices (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), updateAudioDevices (copy)
		if v183.VoiceChatOptionsEnabled then
			updateVoiceChatDevices("Input")
			updateVoiceChatDevices("Output")

			return
		end

		if GetFFlagEnableCrossExpVoice() and default4:getIsConnected() then
			updateAudioDevices("Input")
		end

		updateAudioDevices("Output")
	end
	local function setupDeviceChangedListener() -- line: 3644
		-- upvalues: SoundService (copy), connection (ref), v183 (copy), updateAudioOptions (copy)
		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3646
				-- upvalues: v183 (copy), updateAudioOptions (copy)
				if v183.PageOpen then
					updateAudioOptions()
				end
			end)
		end
	end
	local function setupVideoCameraDeviceChangedListener() -- line: 3654
		-- upvalues: VideoCaptureService (copy), connection2 (ref), v183 (copy), updateCameraDevices (copy)
		if VideoCaptureService.DevicesChanged then
			connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3656
				-- upvalues: v183 (copy), updateCameraDevices (copy)
				if v183.PageOpen then
					updateCameraDevices()
				end
			end)
		end
	end
	local function teardownDeviceChangedListener() -- line: 3664
		-- upvalues: SoundService (copy), connection (ref)
		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end
	end
	local function teardownVideoCameraDeviceChangedListener() -- line: 3670
		-- upvalues: VideoCaptureService (copy), connection2 (ref)
		if VideoCaptureService.DevicesChanged and connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end
	local function checkVoiceChatOptions() -- line: 3678
		-- upvalues: default3 (copy), v183 (copy)
		if default3:VoiceChatAvailable() then
			v183.VoiceChatOptionsEnabled = true
		end
	end
	local function updateInputDeviceVisibility() -- line: 3684
		-- upvalues: v183 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy)
		local v680 = v183.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

		if v183.InputDeviceFrame then
			v183.InputDeviceFrame.Visible = v680
		end
	end

	local u237 = false
	local u238 = nil

	if v59 then
		u238 = false
	end

	local function createVoiceChatSelector() -- line: 3697
		-- upvalues: v58 (copy), v183 (copy), v52 (copy), u24 (ref), default3 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v59 (copy), GetFIntDebounceDisconnectButtonDelay (copy), u238 (ref), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v67 (copy), u237 (ref), ThrottleFunctionCall (copy), v55 (copy), GuiService (copy), v66 (copy), v60 (copy)
		if v58 and (v183.VoiceConnectDisconnectFrame and v183.VoiceConnectDisconnectSelector) then
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

		local v684 = not default3:VoiceChatEnded() and 2 or 1
		local v685 = v183
		local v686 = v183
		local v687, v688, v689 = Utility:AddNewRow(v183, s15, "Selector", {
			s16,
			s17
		}, v684)

		v685.VoiceConnectDisconnectFrame = v687
		_ = v688
		v686.VoiceConnectDisconnectSelector = v689
		v183.VoiceConnectDisconnectFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectDisconnectSelector

		local v690 = default3:getService()

		if v690 and not v59 then
			v690.StateChanged:Connect(function(oldState, newState) -- line: 3722
				-- upvalues: v58 (copy), v183 (copy), default3 (copy)
				if v58 then
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined and v183.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if (newState == Enum.VoiceChatState.Ended or newState == Enum.VoiceChatState.Failed or newState == Enum.VoiceChatState.Idle) and v183.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

						return
					end
				else
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if default3:VoiceChatEnded() then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end
			end)
		end

		local u691 = v684
		local v692 = GetFIntDebounceDisconnectButtonDelay()
		local v693 = v692 > 0

		local function v694(p116) -- line: 3756
			-- upvalues: u691 (ref), v59 (copy), u238 (ref), FFlagVoiceRewarmTelemetry (copy), default3 (copy), Constants2 (copy), v67 (copy), u237 (ref), v183 (copy)
			if p116 == u691 then
				return
			end

			u691 = p116

			if v59 and u238 then
				return
			end

			if FFlagVoiceRewarmTelemetry then
				local v1064, v1065, v1066, v1067 = default3:GetConnectDisconnectButtonAnalyticsData(p116 == 2)

				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1064, v1065, v1066, v1067, default3.joinVoiceButtonContext)
			else
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(p116 == 2))
			end

			if p116 == 2 then
				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			elseif v67 then
				local v1068 = default3:getService()
				local v1069 = v1068 ~= nil and v1068.VoiceChatState == Enum.VoiceChatState.Failed

				if not default3:VoiceChatEnded() and not v1069 then
					default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
					default3:Leave()
				end
			elseif not default3:VoiceChatEnded() then
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			if u237 then
				task.spawn(function() -- line: 3800
					-- upvalues: p116 (copy), v183 (copy)
					task.wait(0.5)

					if p116 ~= 1 then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end)
			end
		end

		v183.VoiceConnectDisconnectSelector.IndexChanged:connect(if not v693 then v694 else ThrottleFunctionCall(v692, v694))

		if v55 then
			v183.VoiceConnectDisconnectFrame.SelectionChanged:Connect(function(__, p118, p119) -- line: 3814
				-- upvalues: s15 (ref), v183 (copy), GuiService (copy)
				if p119 and (p118 and p118.Parent and p118.Parent.Name == s15 .. "Frame" and p119.Name == "ImageButton" and v183.Active) then
					GuiService.SelectedCoreObject = p118
				end
			end)
		end

		default3:subscribe("OnStateChanged", function(__, p121) -- line: 3821
			-- upvalues: v59 (copy), u238 (ref), v66 (copy), v183 (copy), v60 (copy)
			if v59 then
				u238 = true

				if v66 then
					if p121 == Enum.VoiceChatState.Joined and v183.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					end
				elseif p121 == Enum.VoiceChatState.Joined then
					v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
				end
			end

			if v66 then
				if p121 == Enum.VoiceChatState.Failed and v183.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
					v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
				end
			elseif p121 == Enum.VoiceChatState.Failed then
				v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
			end

			if v59 then
				if v60 then
					task.defer(function() -- line: 3853
						-- upvalues: u238 (ref)
						u238 = false
					end)

					return
				end

				u238 = false
			end
		end)
		default3:subscribe("OnRequestMicPermissionRejected", function() -- line: 3862
			-- upvalues: u237 (ref), v59 (copy), u238 (ref), v183 (copy), v60 (copy)
			task.spawn(function() -- line: 3863
				-- upvalues: u237 (ref), v59 (copy), u238 (ref), v183 (copy), v60 (copy)
				task.wait(0.5)
				u237 = true

				if v59 then
					u238 = true
				end

				v183.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

				if v59 then
					if v60 then
						task.defer(function() -- line: 3872
							-- upvalues: u238 (ref)
							u238 = false
						end)

						return
					end

					u238 = false
				end
			end)
		end)
	end
	local function createVoiceConnectDisconnect() -- line: 3883
		-- upvalues: default3 (copy), u24 (ref), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), Utility (copy), ThrottleFunctionCall (copy), v183 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy)
		if default3:IsSeamlessVoice() and not default3.isShowingFTUX then
			local v695 = u24:Format("Feature.GameDetails.Label.VoiceChat")
			local v696 = u24:Format("Feature.SettingsHub.Label.Connect")
			local v697 = u24:Format("Feature.SettingsHub.Label.Disconnect")
			local v698 = GetFIntDebounceDisconnectButtonDelay()
			local v699 = v698 > 0

			local function v700() -- line: 3893
				-- upvalues: default3 (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy)
				if default3:getService() then
					local connection3 = nil

					connection3 = default3:getService().StateChanged:Connect(function(__, newState) -- line: 3897
						-- upvalues: FFlagVoiceRewarmTelemetry (copy), default3 (copy), connection3 (ref)
						if newState == Enum.VoiceChatState.Joined then
							if FFlagVoiceRewarmTelemetry then
								local v1183, v1184, v1185, v1186 = default3:GetConnectDisconnectButtonAnalyticsData(true)

								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1183, v1184, v1185, v1186, default3.joinVoiceButtonContext)
							else
								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
							end

							connection3:Disconnect()
						end
					end)
				elseif FFlagVoiceRewarmTelemetry then
					local v1076, v1077, v1078, v1079 = default3:GetConnectDisconnectButtonAnalyticsData(false)

					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1076, v1077, v1078, v1079, default3.joinVoiceButtonContext)
				else
					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(false))
				end

				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			end
			local function v701() -- line: 3930
				-- upvalues: default3 (copy), Constants2 (copy)
				default3.Analytics:reportLeaveVoiceButtonEvent("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			local v702, v703, v704 = Utility:MakeStyledButton("VoiceConnectButton", v696, UDim2.new(1, 0, 1, -20), if not v699 then v700 else ThrottleFunctionCall(v698, v700), v183)

			voiceConnectSetRowRef = v704

			local v705, v706, v707 = Utility:MakeStyledButton("VoiceDisconnectButton", v697, UDim2.new(1, 0, 1, -20), if not v699 then v701 else ThrottleFunctionCall(v698, v701), v183)

			voiceDisconnectSetRowRef = v707
			v702.Size = UDim2.new(0.6, 0, 0, 40)
			v702.Position = UDim2.new(0.4, 0, 0.5, 0)
			v702.AnchorPoint = Vector2.new(0, 0.5)
			v702.ZIndex = 2
			v702.Selectable = true
			v703.ZIndex = 2
			v705.Size = UDim2.new(0.6, 0, 0, 40)
			v705.Position = UDim2.new(0.4, 0, 0.5, 0)
			v705.AnchorPoint = Vector2.new(0, 0.5)
			v705.ZIndex = 2
			v705.Selectable = true
			v706.ZIndex = 2

			local v708 = Utility:AddNewRowObject(v183, v695, v702, nil, true)
			local v709 = Utility:AddNewRowObject(v183, v695, v705, nil, true)

			v183.VoiceConnectFrame = v708
			v183.VoiceDisconnectFrame = v709
			v708.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectFrame
			v709.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceDisconnectFrame
			voiceConnectSetRowRef(v708)
			voiceDisconnectSetRowRef(v709)

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused() then
				v708.Visible = false
				v709.Visible = false

				return
			end

			if default3:ShouldShowJoinVoice() then
				v708.Visible = true
				v709.Visible = false

				return
			end

			v708.Visible = false
			v709.Visible = true
		end
	end
	local function createVRComfortSettingOptions() -- line: 3993
		-- upvalues: u24 (ref), GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local EnumItems = Enum.VRComfortSetting:GetEnumItems()
		local t34 = {
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
		local t35 = {}

		for i, v in ipairs(EnumItems) do
			t35[i] = u24:Format(t34[tostring(v)])
		end

		local v715 = table.find(EnumItems, GameSettings.VRComfortSetting)
		local v716 = v183
		local v717 = v183
		local v718 = v183
		local v719, v720, v721 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.PageTitle.VRComfortSettings"), "Selector", t35, v715, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription"))

		v716.VRComfortSettingFrame = v719
		v717.VRComfortSettingLabel = v720
		v718.VRComfortSettingSelector = v721
		v183.VRComfortSettingFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRComfortSettingFrame

		local v722 = not GameSettings.VignetteEnabled and 2 or 1
		local v723 = v183
		local v724 = v183
		local v725 = v183
		local v726, v727, v728 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.GameSettings.VignetteEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v722)

		v723.VRVignetteEnabledFrame = v726
		v724.VRVignetteEnabledLabel = v727
		v725.VRVignetteEnabledSelector = v728
		v183.VRVignetteEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRVignetteEnabledFrame

		local v729 = not GameSettings.VRSmoothRotationEnabled and 1 or 2
		local v730 = v183
		local v731 = v183
		local v732 = v183
		local v733, v734, v735 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v729)

		v730.VRSteppedRotationEnabledFrame = v733
		v731.VRSteppedRotationEnabledLabel = v734
		v732.VRSteppedRotationEnabledSelector = v735
		v183.VRSteppedRotationEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSteppedRotationEnabledFrame

		local v736 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2
		local v737 = v183
		local v738 = v183
		local v739 = v183
		local v740, v741, v742 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v736)

		v737.VRThirdPersonFixedCamEnabledFrame = v740
		v738.VRThirdPersonFixedCamEnabledLabel = v741
		v739.VRThirdPersonFixedCamEnabledSelector = v742
		v183.VRThirdPersonFixedCamEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRThirdPersonFixedCamEnabledFrame

		local function v743(p123) -- line: 4059
			-- upvalues: v183 (copy)
			if p123 == Enum.VRComfortSetting.Custom then
				v183.VRVignetteEnabledSelector:SetZIndex(2)
				v183.VRVignetteEnabledLabel.ZIndex = 2
				v183.VRVignetteEnabledSelector:SetInteractable(true)
				v183.VRSteppedRotationEnabledSelector:SetZIndex(2)
				v183.VRSteppedRotationEnabledLabel.ZIndex = 2
				v183.VRSteppedRotationEnabledSelector:SetInteractable(true)
				v183.VRThirdPersonFixedCamEnabledSelector:SetZIndex(2)
				v183.VRThirdPersonFixedCamEnabledLabel.ZIndex = 2
				v183.VRThirdPersonFixedCamEnabledSelector:SetInteractable(true)

				return
			end

			v183.VRVignetteEnabledSelector:SetZIndex(1)
			v183.VRVignetteEnabledLabel.ZIndex = 1
			v183.VRVignetteEnabledSelector:SetInteractable(false)
			v183.VRSteppedRotationEnabledSelector:SetZIndex(1)
			v183.VRSteppedRotationEnabledLabel.ZIndex = 1
			v183.VRSteppedRotationEnabledSelector:SetInteractable(false)
			v183.VRThirdPersonFixedCamEnabledSelector:SetZIndex(1)
			v183.VRThirdPersonFixedCamEnabledLabel.ZIndex = 1
			v183.VRThirdPersonFixedCamEnabledSelector:SetInteractable(false)
		end

		v183.VRComfortSettingSelector.IndexChanged:connect(function(p124) -- line: 4083
			-- upvalues: EnumItems (copy), GameSettings (copy), v743 (copy)
			local v1082 = EnumItems[p124]

			GameSettings.VRComfortSetting = v1082
			v743(v1082)
		end)
		v743(GameSettings.VRComfortSetting)
		v183.VRVignetteEnabledSelector.IndexChanged:connect(function(p125) -- line: 4090
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VignetteEnabledCustomOption = p125 == 1
			end
		end)
		v183.VRSteppedRotationEnabledSelector.IndexChanged:connect(function(p126) -- line: 4096
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRSmoothRotationEnabledCustomOption = p126 == 2
			end
		end)
		v183.VRThirdPersonFixedCamEnabledSelector.IndexChanged:connect(function(p127) -- line: 4102
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRThirdPersonFollowCamEnabledCustomOption = p127 == 2
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function() -- line: 4108
			-- upvalues: EnumItems (copy), GameSettings (copy), v183 (copy)
			local v1086 = table.find(EnumItems, GameSettings.VRComfortSetting)

			if v1086 ~= v183.VRComfortSettingSelector:GetSelectedIndex() then
				v183.VRComfortSettingSelector:SetSelectionIndex(v1086)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function() -- line: 4115
			-- upvalues: GameSettings (copy), v183 (copy)
			local v1087 = not GameSettings.VignetteEnabled and 2 or 1

			if v1087 ~= v183.VRVignetteEnabledSelector:GetSelectedIndex() then
				v183.VRVignetteEnabledSelector:SetSelectionIndex(v1087)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function() -- line: 4122
			-- upvalues: GameSettings (copy), v183 (copy)
			local v1088 = not GameSettings.VRSmoothRotationEnabled and 1 or 2

			if v1088 ~= v183.VRSteppedRotationEnabledSelector:GetSelectedIndex() then
				v183.VRSteppedRotationEnabledSelector:SetSelectionIndex(v1088)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function() -- line: 4129
			-- upvalues: GameSettings (copy), v183 (copy)
			local v1089 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2

			if v1089 ~= v183.VRThirdPersonFixedCamEnabledSelector:GetSelectedIndex() then
				v183.VRThirdPersonFixedCamEnabledSelector:SetSelectionIndex(v1089)
			end
		end)
	end
	local function createVRSafetyBubbleModeOptions() -- line: 4137
		-- upvalues: u24 (ref), GameSettings (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local EnumItems = Enum.VRSafetyBubbleMode:GetEnumItems()
		local t36 = {
			title = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle",
			description = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription",
			["Enum.VRSafetyBubbleMode.NoOne"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeNoOne",
			["Enum.VRSafetyBubbleMode.OnlyFriends"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeOnlyFriends",
			["Enum.VRSafetyBubbleMode.Anyone"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeAnyone"
		}
		local t37 = {}

		for i, v in ipairs(EnumItems) do
			t37[i] = u24:Format(t36[tostring(v)])
		end

		local v749 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

		task.defer(function() -- line: 4153
			-- upvalues: v183 (copy), Utility (copy), u24 (ref), t37 (copy), v749 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), EnumItems (copy), GameSettings (copy)
			local v1090 = v183
			local v1091 = v183
			local v1092 = v183
			local v1093, v1094, v1095 = Utility:AddNewRow(v183, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle"), "DropDown", t37, v749, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription"))

			v1090.VRSafetyBubbleModeFrame = v1093
			v1091.VRSafetyBubbleModeLabel = v1094
			v1092.VRSafetyBubbleModeSelector = v1095
			v183.VRSafetyBubbleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSafetyBubbleModeFrame
			v183.VRSafetyBubbleModeSelector.IndexChanged:connect(function(p128) -- line: 4166
				-- upvalues: EnumItems (copy), GameSettings (copy)
				GameSettings.VRSafetyBubbleMode = EnumItems[p128]
			end)
			GameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function() -- line: 4171
				-- upvalues: EnumItems (copy), GameSettings (copy), v183 (copy)
				local v1188 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

				if v1188 ~= v183.VRSafetyBubbleModeSelector:GetSelectedIndex() then
					v183.VRSafetyBubbleModeSelector:SetSelectionIndex(v1188)
				end
			end)
		end)
	end

	v183.VoiceChatOptionsEnabled = false

	local connection4 = nil
	local connection5 = nil
	local u245 = nil

	if game:GetEngineFeature("VoiceChatSupported") and (GetFFlagEnableVrVoiceConnectDisconnect() or (not isInExperienceUIVREnabled or not isSpatial())) then
		spawn(function() -- line: 4185
			-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), default3 (copy), createVoiceChatSelector (copy), isVoiceFocused (copy), v183 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), VoiceVolumeControlsEligibility (copy), v128 (copy), v58 (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u238 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), default4 (copy), t5 (copy), GetFFlagVoiceChatUILogging (copy)
			if GetFFlagEnableVoiceUxUpdates() and ((not v53 and default3:EligibleForFaeUpsell() or default3:IsSeamlessVoice()) and default3:verifyUniverseAndPlaceCanUseVoice()) then
				createVoiceChatSelector()

				if isVoiceFocused() and v183.VoiceConnectDisconnectFrame then
					v183.VoiceConnectDisconnectFrame.Visible = false
				end

				observeIsVoiceFocused(function(p129) -- line: 4195
					-- upvalues: v183 (copy)
					if p129 then
						if v183.VoiceConnectDisconnectFrame then
							v183.VoiceConnectDisconnectFrame.Visible = false

							return
						end
					elseif v183.VoiceConnectDisconnectFrame then
						v183.VoiceConnectDisconnectFrame.Visible = true
					end
				end)
			end

			default3:asyncInit():andThen(function() -- line: 4208
				-- upvalues: default3 (copy), v183 (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), VoiceVolumeControlsEligibility (copy), v128 (copy), observeIsVoiceFocused (copy), v58 (copy), GetFFlagEnableVoiceUxUpdates (copy), createVoiceChatSelector (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u238 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), default4 (copy), t5 (copy)
				VoiceChatService = default3:getService()

				if default3:VoiceChatAvailable() then
					v183.VoiceChatOptionsEnabled = true
				end

				if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v183.VoiceChatVolumeFrame then
					local function updateVoiceChatVolumeVisibility(p130) -- line: 4212
						-- upvalues: default3 (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy), v128 (copy)
						local ok, result = pcall(function() -- line: 4213
							-- upvalues: default3 (copy), v69 (copy), p130 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy)
							local VoiceChatService2 = game:GetService("VoiceChatService")
							local v1250 = default3:getService()
							local v1251 = ((if not v69 then v1250 and v1250.VoiceChatState else p130 or v1250 and v1250.VoiceChatState)) == Enum.VoiceChatState.Joined
							local v1252 = VoiceChatService2 and VoiceChatService2.UseNewAudioApi
							local v1253 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

							v183.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1251, v1252) and not v1253
						end)

						if not ok then
							v128:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
						end
					end

					local v1098 = nil
					local ok, result = pcall(function() -- line: 4213
						-- upvalues: default3 (copy), v69 (copy), v1098 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy)
						local VoiceChatService3 = game:GetService("VoiceChatService")
						local v1193 = default3:getService()
						local v1194 = ((if not v69 then v1193 and v1193.VoiceChatState else v1098 or v1193 and v1193.VoiceChatState)) == Enum.VoiceChatState.Joined
						local v1195 = VoiceChatService3 and VoiceChatService3.UseNewAudioApi
						local v1196 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

						v183.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1194, v1195) and not v1196
					end)

					if not ok then
						v128:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
					end

					if v73 and GetFFlagEnableCrossExpVoice() and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						observeIsVoiceFocused(function() -- line: 4241
							-- upvalues: default3 (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy), v128 (copy)
							local v1197 = nil
							local ok2, result2 = pcall(function() -- line: 4213
								-- upvalues: default3 (copy), v69 (copy), v1197 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy)
								local VoiceChatService4 = game:GetService("VoiceChatService")
								local v1255 = default3:getService()
								local v1256 = ((if not v69 then v1255 and v1255.VoiceChatState else v1197 or v1255 and v1255.VoiceChatState)) == Enum.VoiceChatState.Joined
								local v1257 = VoiceChatService4 and VoiceChatService4.UseNewAudioApi
								local v1258 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

								v183.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1256, v1257) and not v1258
							end)

							if not ok2 then
								v128:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result2)
							end
						end)
					end

					if v69 then
						default3:subscribe("OnStateChanged", function(__, p132) -- line: 4246
							-- upvalues: default3 (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy), v128 (copy)
							local ok3, result3 = pcall(function() -- line: 4213
								-- upvalues: default3 (copy), v69 (copy), p132 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy)
								local VoiceChatService5 = game:GetService("VoiceChatService")
								local v1260 = default3:getService()
								local v1261 = ((if not v69 then v1260 and v1260.VoiceChatState else p132 or v1260 and v1260.VoiceChatState)) == Enum.VoiceChatState.Joined
								local v1262 = VoiceChatService5 and VoiceChatService5.UseNewAudioApi
								local v1263 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

								v183.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1261, v1262) and not v1263
							end)

							if not ok3 then
								v128:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result3)
							end
						end)
					else
						local v1101 = default3:getService()

						if v1101 then
							v1101.StateChanged:Connect(function() -- line: 4252
								-- upvalues: default3 (copy), v69 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy), v128 (copy)
								local v1204 = nil
								local ok4, result4 = pcall(function() -- line: 4213
									-- upvalues: default3 (copy), v69 (copy), v1204 (copy), v73 (copy), GetFFlagEnableCrossExpVoice (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), v183 (copy), VoiceVolumeControlsEligibility (copy)
									local VoiceChatService6 = game:GetService("VoiceChatService")
									local v1265 = default3:getService()
									local v1266 = ((if not v69 then v1265 and v1265.VoiceChatState else v1204 or v1265 and v1265.VoiceChatState)) == Enum.VoiceChatState.Joined
									local v1267 = VoiceChatService6 and VoiceChatService6.UseNewAudioApi
									local v1268 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

									v183.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1266, v1267) and not v1268
								end)

								if not ok4 then
									v128:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result4)
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

					local v1102 = v73 and (GetFFlagEnableCrossExpVoice() and (GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused()))

					if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and not v1102 then
						default3:ShowNotAudiblePromptVoiceChatVolume()
					end
				end

				if GetFFlagEnableVoiceUxUpdates() then
					if v59 and v60 then
						u238 = true
						v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
						task.defer(function() -- line: 4290
							-- upvalues: u238 (ref)
							u238 = false
						end)

						return
					end

					v183.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

					return
				end

				local u1103 = false

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
					createVoiceConnectDisconnect()

					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						u1103 = isVoiceFocused()
						observeIsVoiceFocused(function(p133) -- line: 4305
							-- upvalues: u1103 (ref), v183 (copy), default3 (copy)
							u1103 = p133

							if p133 then
								if v183.VoiceConnectFrame then
									v183.VoiceConnectFrame.Visible = false
								end

								if v183.VoiceDisconnectFrame then
									v183.VoiceDisconnectFrame.Visible = false

									return
								end
							elseif default3:ShouldShowJoinVoice() then
								if v183.VoiceConnectFrame then
									v183.VoiceConnectFrame.Visible = true
								end

								if v183.VoiceDisconnectFrame then
									v183.VoiceDisconnectFrame.Visible = false
								end
							end
						end)
					end
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceConnectFrame then
					v183.VoiceConnectFrame.Visible = false
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceDisconnectFrame then
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						v183.VoiceDisconnectFrame.Visible = not u1103
					else
						v183.VoiceDisconnectFrame.Visible = true
					end
				end

				default3.showVoiceUI.Event:Connect(function() -- line: 4338
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1103 (ref), v183 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1103 then
						return
					end

					v183.VoiceChatOptionsEnabled = true

					local v1208 = v183.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v183[t5.Input .. "DeviceFrame"] then
						v183[t5.Input .. "DeviceFrame"].Visible = v1208
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceConnectFrame then
						v183.VoiceConnectFrame.Visible = false
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceDisconnectFrame then
						v183.VoiceDisconnectFrame.Visible = true
					end
				end)
				default3.hideVoiceUI.Event:Connect(function() -- line: 4356
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1103 (ref), v183 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1103 then
						return
					end

					v183.VoiceChatOptionsEnabled = false

					local v1209 = v183.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v183[t5.Input .. "DeviceFrame"] then
						v183[t5.Input .. "DeviceFrame"].Visible = v1209
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceConnectFrame then
						v183.VoiceConnectFrame.Visible = true
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v183.VoiceDisconnectFrame then
						v183.VoiceDisconnectFrame.Visible = false
					end
				end)
			end):catch(function() -- line: 4376
				-- upvalues: GetFFlagVoiceChatUILogging (copy), v128 (copy), GetFFlagEnableUniveralVoiceToasts (copy), default3 (copy)
				if GetFFlagVoiceChatUILogging() then
					v128:warning("Failed to init VoiceChatServiceManager")
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowPermissionPrompt()
				end
			end)
		end)
	end

	if GetFFlagEnableCrossExpVoice() and (not isInExperienceUIVREnabled or not isSpatial()) then
		connection4 = default4.ExperienceJoined.Event:Connect(function() -- line: 4389
			-- upvalues: v183 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v750 = v183.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v183[t5.Input .. "DeviceFrame"] then
				v183[t5.Input .. "DeviceFrame"].Visible = v750
			end
		end)
		connection5 = default4.ExperienceLeft.Event:Connect(function() -- line: 4392
			-- upvalues: v183 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v751 = v183.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v183[t5.Input .. "DeviceFrame"] then
				v183[t5.Input .. "DeviceFrame"].Visible = v751
			end
		end)

		function u245() -- line: 4395
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

	v183.VideoOptionsEnabled = false

	local u246 = nil

	if GetFFlagSelfViewCameraSettings() and (not isInExperienceUIVREnabled or not isSpatial()) and isCamEnabledForUserAndPlace() then
		getCamMicPermissions(function(p134) -- line: 4417
			-- upvalues: v183 (copy)
			v183.VideoOptionsEnabled = p134.hasCameraPermissions
		end, { default.Permissions.CAMERA_ACCESS }, true)

		if u246 then
			u246:disconnect()
		end

		u246 = cameraDevicePermissionGrantedSignal:connect(function() -- line: 4433
			-- upvalues: v183 (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref)
			v183.VideoOptionsEnabled = true
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3656
					-- upvalues: v183 (copy), updateCameraDevices (copy)
					if v183.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end)
	end

	if not isInExperienceUIVREnabled then
		createCameraModeOptions(not v118 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))
	end

	if UserInputService.MouseEnabled then
		createMouseOptions()
	elseif UserInputService.GamepadEnabled then
		if GameSettings.IsUsingGamepadCameraSensitivity then
			createGamepadOptions()
		else
			local u247 = nil

			u247 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4455
				-- upvalues: GameSettings (copy), u247 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u247 then
						u247:disconnect()
					end

					createGamepadOptions()
				end
			end)
		end
	else
		local u248 = nil

		u248 = UserInputService.GamepadConnected:connect(function() -- line: 4473
			-- upvalues: u248 (ref), GameSettings (copy), createGamepadOptions (copy)
			if u248 then
				u248:disconnect()
			end

			if GameSettings.IsUsingGamepadCameraSensitivity then
				createGamepadOptions()

				return
			end

			local u754 = nil

			u754 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4455
				-- upvalues: GameSettings (copy), u754 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u754 then
						u754:disconnect()
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
			local u249 = nil

			u249 = GameSettings.Changed:connect(function(p135) -- line: 4487
				-- upvalues: GameSettings (copy), u249 (ref), createCameraInvertedOptions (copy)
				if p135 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
					u249:disconnect()
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
			createCameraModeOptions(not v118 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))

			if GameSettings.IsUsingCameraYInverted then
				createCameraInvertedOptions()
			else
				local u250 = nil

				u250 = GameSettings.Changed:connect(function(p136) -- line: 4516
					-- upvalues: GameSettings (copy), u250 (ref), createCameraInvertedOptions (copy)
					if p136 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
						u250:disconnect()
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

	if v71 and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		local u251 = false

		v183.Displayed.Event:Connect(function() -- line: 4539
			-- upvalues: u251 (ref), v183 (copy), default3 (copy)
			u251 = true

			if v183.VoiceChatVolumeFrame and v183.VoiceChatVolumeFrame.Visible then
				default3:RecordGameSettingsOpened()
			end
		end)
		v183.Hidden.Event:Connect(function() -- line: 4546
			-- upvalues: u251 (ref)
			u251 = false
		end)
		v183.VoiceChatVolumeFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 4550
			-- upvalues: v183 (copy), u251 (ref), default3 (copy)
			if v183.VoiceChatVolumeFrame.Visible and u251 then
				default3:RecordGameSettingsOpened()
			end
		end)
	end

	if v78 then
		createPartyVoiceVolumeOptions()
	end

	createHapticsToggle()
	createGraphicsOptions()

	if v46 and GetFFlagEnablePlayerNamesEnabledSetting() then
		createPlayerNamesEnabledOptions()
	end

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		PlayerChoiceTranslationSettingInitializer(v183, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
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

	if v133 then
		createMicroProfilerOptions()
	end

	if v118 and getAppFeaturePolicies().getSupportsOverscan() then
		createOverscanOption()
	end

	if v46 and FFlagBadgeVisibilitySettingEnabled then
		spawn(function() -- line: 3169
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v151 (copy), v183 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n15 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n15 = 1
			end

			local v758 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v759 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v760 = if not v151 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v761 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v762 = v183
			local v763 = v183
			local v764 = v183
			local v765, v766, v767 = Utility:AddNewRow(v183, v760, "Selector", {
				v759,
				v758
			}, n15, nil, v761)

			v762.badgeVisibleRow = v765
			v763.badgeVisibleFrame = v766
			v764.badgeVisibleSelector = v767
			v183.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v183.badgeVisibleSelector.IndexChanged:connect(function(p137) -- line: 3183
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p137 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p137 == 1)
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

	if FFlagExpChatEnableFriendsTab then
		createChatNotificationsSettingOptions()
	end

	createDeveloperConsoleOption()
	GetHasGuiHidingPermission(RunService:IsStudio(), LocalPlayer, PlayerPermissionsModule):andThen(function(p138) -- line: 4615
		-- upvalues: createUiToggleOptions (copy)
		if p138 then
			createUiToggleOptions()
		end
	end):catch(function(p139) -- line: 4620
		warn(p139)
	end)
	u184 = true

	if VRService.VREnabled then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	if FFlagIEMSettingsGroups then
		v183.AudioHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.AudioHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioHeader,
			parent = v183.Page
		})
		v183.AudioDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioDivider,
			parent = v183.Page
		})
		v183.DisplayHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.DisplayHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayHeader,
			parent = v183.Page
		})
		v183.DisplayDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayDivider,
			parent = v183.Page
		})

		if not isSpatial() then
			v183.LanguageHeader = renderSettingsHeader({
				headerText = "CoreScripts.InGameMenu.GameSettings.LanguageHeader",
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageHeader,
				parent = v183.Page
			})
			v183.LanguageDivider = renderSettingsDivider({
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageDivider,
				parent = v183.Page
			})
		end

		v183.ViewAndControlsHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.ViewandControlsHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ViewAndControlsHeader,
			parent = v183.Page
		})
	end

	v183.TabHeader.Name = "GameSettingsTab"

	local v255 = Migration.uiblox["icons/common/settings"]

	v183.TabHeader.TabLabel.Icon.Text = v255.name
	v183.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v255.variant]
	v183.TabHeader.TabLabel.Title.Text = "Settings"
	v183.Page.ZIndex = 5

	if v183.PageListLayout then
		v183.PageListLayout.Padding = UDim.new(0, 0)
	end

	v183.PageOpen = false

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		v183.FeedbackEntryPointEnabled = true
	end

	local function staticFeedbackEntryPointChecksPassed() -- line: 4689
		-- upvalues: RunService (copy), v144 (copy), v118 (copy)
		if RunService:IsStudio() then
			return false
		end

		if game:GetEngineFeature("CaptureModeEnabled") == false then
			return false
		end

		if v144 and v118 then
			return false
		end

		return true
	end

	function v183.OpenSettingsPage() -- line: 4705
		-- upvalues: v183 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), updateAudioOptions (copy), SoundService (copy), connection (ref), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), GetFFlagSelfViewCameraSettings (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref), updateUiToggleSelection (copy), ExperienceStateCaptureService (ref), v90 (copy), Theme (copy), v89 (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy)
		v183.PageOpen = true

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if GetFFlagLazyInitiateExperienceLanguageSwitcher() and not v183.LanguageSwitcherInitialized and isLangaugeSelectionDropdownEnabled() and GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
			v183.LanguageSwitcherInitialized = true
			ExperienceLanguageSwitcherInitializer(v183, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		updateAudioOptions()

		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3646
				-- upvalues: v183 (copy), updateAudioOptions (copy)
				if v183.PageOpen then
					updateAudioOptions()
				end
			end)
		end

		v183.startVolume = GameSettings.MasterVolume

		if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
			v183.maxVoiceChatVolumeDuringSession = GameSettings.VoiceChatVolume
		end

		if GetFFlagSelfViewCameraSettings() and v183.VideoOptionsEnabled and game:GetEngineFeature("VideoCaptureService") then
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3656
					-- upvalues: v183 (copy), updateCameraDevices (copy)
					if v183.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end

		updateUiToggleSelection()

		if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and v183.toggleFeedbackModeButton and v183.toggleFeedbackModeText then
			v183.FeedbackEntryPointEnabled = ExperienceStateCaptureService ~= nil and ExperienceStateCaptureService:CanEnterCaptureMode()

			if v183.FeedbackEntryPointEnabled then
				v183.toggleFeedbackModeButton.Active = true
				v183.toggleFeedbackModeButton.Enabled.Value = true
				v183.toggleFeedbackModeText.Text = v90
			else
				v183.toggleFeedbackModeButton.Active = false
				v183.toggleFeedbackModeButton.Enabled.Value = false
				v183.toggleFeedbackModeText.TextColor3 = Theme.color("ButtonNonInteractable", Color3.fromRGB(100, 100, 100))
				v183.toggleFeedbackModeText.Text = v89
			end
		end

		if FFlagIEMFocusNavToButtons then
			table.insert(v183.LastSelectableObjects, getLastValueChangerFrame(v183))
		end

		if FFlagIEMTabFocusNav then
			table.insert(v183.FirstSelectableObjects, getFirstValueChangerFrame(v183))
			v183.FirstSelectableObjectsUpdated:fire()
		end
	end
	function v183.CloseSettingsPage() -- line: 4776
		-- upvalues: v183 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), SoundService (copy), connection (ref), GetFFlagEnableCrossExpVoice (copy), u245 (ref), GetFFlagSelfViewCameraSettings (copy), VideoCaptureService (copy), connection2 (ref), u246 (ref), default3 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy)
		v183.PageOpen = false

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end

		if GetFFlagEnableCrossExpVoice() and u245 then
			u245()
		end

		if GetFFlagSelfViewCameraSettings() then
			if game:GetEngineFeature("VideoCaptureService") and VideoCaptureService.DevicesChanged and connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u246 then
				u246:disconnect()
				u246 = nil
			end
		end

		if game:GetEngineFeature("VoiceChatSupported") and v183.VoiceChatOptionsEnabled and v183.startVolume ~= nil and v183.startVolume > 0 then
			default3:CheckAndShowNotAudiblePrompt()
		end

		if game:GetEngineFeature("VoiceChatSupported") and v183.VoiceChatOptionsEnabled and FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v183.maxVoiceChatVolumeDuringSession ~= nil and v183.maxVoiceChatVolumeDuringSession > 0 then
			default3:ShowNotAudiblePromptVoiceChatVolume()
		end
	end
	function isLangaugeSelectionDropdownEnabled() -- line: 4820
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
	function v183.SetHub(__, p141) -- line: 4843
		-- upvalues: v183 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), createTranslationOptions (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), getChatTranslationLayerData (copy), EngineFeature (copy), GetFFlagChatTranslationNewDefaults (copy), GameSettings (copy), TextChatService (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy), RunService (copy), v144 (copy), v118 (copy), createFeedbackModeOptions (copy)
		v183.HubRef = p141

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if isLangaugeSelectionDropdownEnabled() then
			if GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
				if not GetFFlagLazyInitiateExperienceLanguageSwitcher() then
					ExperienceLanguageSwitcherInitializer(v183, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
				end
			else
				createTranslationOptions()
			end
		end

		if game:GetEngineFeature("EnableTCSChatTranslation") and GetFFlagChatTranslationSettingEnabled() then
			if GetFFlagChatTranslationHoldoutEnabled() then
				local v773 = GetFStringChatTranslationLayerName()

				if not getChatTranslationLayerData(v773).ChatTranslationEnabled then
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
						pcall(function() -- line: 4881
							-- upvalues: TextChatService (copy)
							TextChatService.ChatTranslationEnabled = false
						end)
					end
				elseif GetFFlagChatTranslationForceSetting() then
					GameSettings.ChatTranslationEnabled = true
				end
			end

			ChatTranslationOptionsWithChatLanguageSwitcherInitializer(v183, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		if not RunService:IsStudio() and (game:GetEngineFeature("CaptureModeEnabled") ~= false and (not v144 or not v118)) then
			createFeedbackModeOptions()
		end
	end

	return v183
end

return (Initialize())
