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
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local GameSettingsConstants = require(RobloxGui.Modules.Settings.Resources.GameSettingsConstants)
local v71 = default2 and default2.getHasPartyVoiceVolume()
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

local function voiceChatVolumeToSlider(n1: number) -- line: 131
	return (math.floor(n1 * 5 + 0.5))
end
local function voiceChatVolumeFromSlider(n2: number) -- line: 135
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
local v81 = RobloxTranslator:FormatByKey("Feature.SettingsHub.TouchMovementMode.ClassicThumbstick")
local v82 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")
local v83 = RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.ButtonText")
local t7 = {
	On = 1,
	Off = 2
}

local function getDefaultCameraMode() -- line: 178
	-- upvalues: UserInputService (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Default (Follow)"
	end

	return "Default (Classic)"
end
local function getDefaultMovementMode() -- line: 187
	-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
	end

	return "Default (Keyboard)"
end
local function getDefaultSelectToMove() -- line: 196
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

local v111 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local LocalPlayer = Players.LocalPlayer
local Platform = UserInputService:GetPlatform()
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local default3 = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local default4 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).CrossExperienceVoiceManager.default
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v118 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.SystemDefault")
local v119 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.VideoCamera")
local v120 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

game:DefineFastInt("RomarkStartWithGraphicQualityLevel", -1)

local FastInt = game:GetFastInt("RomarkStartWithGraphicQualityLevel")
local v122 = not CachedPolicyService:IsSubjectToChinaPolicies()
local v123 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
local v124 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local v125 = if not isInExperienceUIVREnabled then (v124 or v123) and v122 else (v124 or (v123 or isSpatial())) and v122
local GetFIntVoiceChatDeviceChangeDebounceDelay = require(RobloxGui.Modules.Flags.GetFIntVoiceChatDeviceChangeDebounceDelay)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableExplicitSettingsChangeAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableExplicitSettingsChangeAnalytics)
local GetFFlagFixCyclicFullscreenIndexEvent = require(RobloxGui.Modules.Settings.Flags.GetFFlagFixCyclicFullscreenIndexEvent)
local v132 = game:DefineFastFlag("DisableFeedbackSoothsayerCheck", false)
local v133 = game:DefineFastFlag("UserShowGuiHideToggles", false)
local v134 = game:DefineFastFlag("UserFreecamGuiDestabilization", false)
local v135 = game:DefineFastFlag("FixDeveloperConsoleButtonSizeAndPositioning", false)
local v136 = game:DefineFastFlag("EnableTFFeedbackModeEntryCheck", false)
local v137 = game:DefineFastFlag("FeedbackEntryPointButtonSizeAdjustment2", false)
local v138 = game:DefineFastFlag("FeedbackEntryPointImprovedStrictnessCheck", false)
local GetFFlagEnableLocalesForExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLocalesForExperienceLanguageSwitcher)
local GetFFlagLazyInitiateExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagLazyInitiateExperienceLanguageSwitcher)
local ExperienceLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ExperienceLanguageSwitcherInitializer)
local PlayerChoiceTranslationSettingInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.PlayerChoiceTranslationSettingInitializer)
local v143 = game:DefineFastFlag("UpdateVisibilitySettingsCopy", false)
local v144 = game:DefineFastFlag("ExpChatDebounceRephraseIndexSelection", false)
local v145 = game:DefineFastFlag("EraseFPSFromDefaultSetting", false)

local function reportSettingsChangeForAnalytics(p1, p2, p3, p4) -- line: 321
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
local function reportSettingsForAnalytics() -- line: 352
	-- upvalues: UserInputService (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), EngineFeature2 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), RbxAnalyticsService (copy), Constants (copy)
	local t9 = {}
	local v160 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

	if v160 then
		t9.camera_mode_touch = tostring(GameSettings.TouchCameraMovementMode)
	else
		t9.camera_mode_desktop = tostring(GameSettings.ComputerCameraMovementMode)
	end

	if v160 then
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

local v148 = game:DefineFastFlag("IGMEnableGFXReset", false)

local function getLastValueChangerFrame(p5) -- line: 421
	-- upvalues: FFlagIEMFocusNavToButtons (copy)
	if not FFlagIEMFocusNavToButtons then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v165 = nil

	for __, v in pairs(p5:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder <= SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v165 = p5:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v165
end
local function getFirstValueChangerFrame(p6) -- line: 440
	-- upvalues: FFlagIEMTabFocusNav (copy)
	if not FFlagIEMTabFocusNav then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v171 = nil

	for __, v in pairs(p6:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder > SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v171 = p6:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v171
end
local function Initialize() -- line: 459
	-- upvalues: v148 (copy), GfxReset (copy), RobloxGui (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), VRService (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), v145 (copy), RobloxTranslator (copy), FastInt (copy), t1 (copy), v143 (copy), FFlagUpdatePeopleNamesSettingCopy (copy), t7 (copy), UserInputService (copy), Create (copy), Theme (copy), v54 (copy), v56 (copy), TouchEnabled (copy), v124 (copy), v123 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), LocalPlayer (copy), CoreUtility (copy), t4 (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), t6 (copy), v81 (copy), t3 (copy), t2 (copy), Url (copy), HttpService (copy), v138 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), v137 (copy), v83 (copy), v132 (copy), v120 (copy), Players (copy), v82 (copy), RunService (copy), GetFFlagChatTranslationWaitForIXP (copy), IXPServiceWrapper (copy), GetFFlagChatTranslationNewDefaults (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), u24 (ref), CorePackages (copy), ContextActionService (copy), v135 (copy), PlayerPermissionsModule (copy), v134 (copy), v133 (copy), SoundService (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), GetFFlagEnableCrossExpVoice (copy), Signals (copy), GetFIntDebounceAIRephraseSettingDelay (copy), TextChatService (copy), v144 (copy), ThrottleFunctionCall (copy), GetFIntDebounceChatSummariesSettingDelay (copy), v119 (copy), UserGameSettings (copy), GetFFlagVoiceChatUILogging (copy), VideoCaptureService (copy), v118 (copy), v59 (copy), v58 (copy), v52 (copy), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v65 (copy), v55 (copy), v64 (copy), v60 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), GetFFlagEnableVrVoiceConnectDisconnect (copy), GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), GetFFlagEnableUniveralVoiceToasts (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), t5 (copy), GetFFlagSelfViewCameraSettings (copy), isCamEnabledForUserAndPlace (copy), getCamMicPermissions (copy), default (copy), cameraDevicePermissionGrantedSignal (copy), v111 (copy), v71 (copy), v46 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), PlayerChoiceTranslationSettingInitializer (copy), CachedPolicyService (copy), v125 (copy), FFlagBadgeVisibilitySettingEnabled (copy), FFlagEnableModerateChatRemoteEvent (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), GetHasGuiHidingPermission (copy), FFlagIEMSettingsGroups (copy), renderSettingsHeader (ref), renderSettingsDivider (ref), Migration (copy), BuilderIcons (copy), v136 (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), EngineFeature (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy)
	if v148 then
		GfxReset.RunGfxReset()
	end

	local v175 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	if GetFFlagLazyInitiateExperienceLanguageSwitcher() then
		v175.LanguageSwitcherInitialized = false
	end

	local u176 = false
	local t10 = {}

	local function onVRSettingsReady() -- line: 472
		-- upvalues: VRService (copy), t10 (copy)
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end
	local function onVREnabled() -- line: 479
		-- upvalues: VRService (copy), u176 (ref), t10 (copy)
		if VRService.VREnabled and u176 then
			local VREnabled = VRService.VREnabled

			for k, __ in pairs(t10) do
				k.Visible = not VREnabled
			end
		end
	end

	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)

	if VRService.VREnabled and u176 then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	local function createGraphicsOptions() -- line: 491
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), VRService (copy), v145 (copy), RobloxTranslator (copy), v148 (copy), GfxReset (copy), FastInt (copy), t1 (copy)
		local n3 = 1

		if not GameSettings:InFullScreen() then
			n3 = 2
		end

		local v254 = v175
		local v255 = v175
		local v256 = v175
		local v257, v258, v259 = Utility:AddNewRow(v175, "Fullscreen", "Selector", {
			"On",
			"Off"
		}, n3)

		v254.FullscreenFrame = v257
		v255.FullscreenLabel = v258
		v256.FullscreenEnabler = v259
		v175.FullscreenFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FullScreenFrame
		t10[v175.FullscreenFrame] = true
		v175.FullscreenEnabler.IndexChanged:connect(function(p7) -- line: 504
			-- upvalues: GameSettings (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), v175 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v746 = GameSettings:InFullScreen()

			if p7 == 1 then
				if not GameSettings:InFullScreen() then
					GuiService:ToggleFullscreen()

					if GetFFlagFixCyclicFullscreenIndexEvent() then
						if v175.FullscreenEnabler.GetSelectedIndex() ~= 1 then
							v175.FullscreenEnabler:SetSelectionIndex(1)
						end
					else
						v175.FullscreenEnabler:SetSelectionIndex(1)
					end
				end
			elseif p7 == 2 and GameSettings:InFullScreen() then
				GuiService:ToggleFullscreen()

				if GetFFlagFixCyclicFullscreenIndexEvent() then
					if v175.FullscreenEnabler.GetSelectedIndex() ~= 2 then
						v175.FullscreenEnabler:SetSelectionIndex(2)
					end
				else
					v175.FullscreenEnabler:SetSelectionIndex(2)
				end
			end

			spawn(function() -- line: 529
				-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), v746 (copy), GameSettings (copy), reportSettingsForAnalytics (copy)
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("fullscreen_enabled", v746, GameSettings:InFullScreen())
				end

				reportSettingsForAnalytics()
			end)
		end)
		GameSettings.FullscreenChanged:connect(function(p8) -- line: 537
			-- upvalues: v175 (copy), RbxAnalyticsService (copy), Constants (copy)
			if p8 then
				if v175.FullscreenEnabler:GetSelectedIndex() ~= 1 then
					v175.FullscreenEnabler:SetSelectionIndex(1)
				end
			elseif v175.FullscreenEnabler:GetSelectedIndex() ~= 2 then
				v175.FullscreenEnabler:SetSelectionIndex(2)
			end

			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
				enabled = p8
			})
		end)

		local n4 = 1

		if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			n4 = 2
		end

		local v261 = v175
		local v262 = v175
		local v263 = v175
		local v264, v265, v266 = Utility:AddNewRow(v175, "Graphics Mode", "Selector", {
			"Automatic",
			"Manual"
		}, n4)

		v261.GraphicsEnablerFrame = v264
		v262.GraphicsEnablerLabel = v265
		v263.GraphicsQualityEnabler = v266
		v175.GraphicsEnablerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsEnablerFrame

		local v267 = v175
		local v268 = v175
		local v269 = v175
		local v270, v271, v272 = Utility:AddNewRow(v175, "Graphics Quality", "Slider", 10, 1)

		v267.GraphicsQualityFrame = v270
		v268.GraphicsQualityLabel = v271
		v269.GraphicsQualitySlider = v272
		v175.GraphicsQualityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsQualityFrame
		v175.GraphicsQualitySlider:SetMinStep(1)

		if EngineFeature2 and not VRService.VREnabled then
			local v273 = table.clone(Constants.FramerateCaps)
			local t11 = { if not v145 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateCapDefaultEntry", {
				Frames = GameSettings:GetDefaultFramerateCap()
			}) else RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.Default") }

			for __, v276 in v273 do
				table.insert(t11, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateEntry", {
					Frames = v276
				}))
			end

			table.insert(v273, 1, -1)
			task.defer(function() -- line: 603
				-- upvalues: v175 (copy), Utility (copy), RobloxTranslator (copy), t11 (copy), v273 (copy), GameSettings (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
				local v748 = v175
				local v749 = v175
				local v750 = v175
				local v751, v752, v753 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate"), "DropDown", t11, table.find(v273, GameSettings.FramerateCap), nil, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate.Description"))

				v748.FramerateCapFrame = v751
				v749.FramerateCapLabel = v752
				v750.FramerateCapMode = v753
				v175.FramerateCapFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FramerateCap
				v175.FramerateCapMode.IndexChanged:Connect(function(p9) -- line: 615
					-- upvalues: GameSettings (copy), v273 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
					local FramerateCap = GameSettings.FramerateCap

					GameSettings.FramerateCap = v273[p9]

					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						reportSettingsChangeForAnalytics("framerate_cap", FramerateCap, GameSettings.FramerateCap)
					end

					reportSettingsForAnalytics()
				end)
			end)
		end

		settings().Rendering.EnableFRM = true

		function SetGraphicsQuality(p10, p11) -- line: 633
			-- upvalues: v148 (copy), GfxReset (copy), GameSettings (copy)
			if v148 then
				local v756, v757 = GfxReset.TemporaryOverride(p10)

				if v756 then
					settings().Rendering.QualityLevel = v757

					return
				end
			end

			local v758 = p10 / 10
			local v759 = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * v758)

			if v759 == 20 then
				v759 = 21
			elseif p10 == 1 then
				v759 = 1
			elseif p10 < 1 and not p11 then
				p10 = 1
				v759 = 1
			elseif v759 > settings().Rendering:GetMaxQualityLevel() then
				v759 = settings().Rendering:GetMaxQualityLevel() - 1
			end

			GameSettings.SavedQualityLevel = p10
			settings().Rendering.QualityLevel = v759
		end

		local function setGraphicsToAuto() -- line: 659
			-- upvalues: v175 (copy)
			v175.GraphicsQualitySlider:SetZIndex(1)
			v175.GraphicsQualityLabel.ZIndex = 1
			v175.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		end
		local function setGraphicsToManual(p12) -- line: 667
			-- upvalues: v175 (copy)
			v175.GraphicsQualitySlider:SetZIndex(2)
			v175.GraphicsQualityLabel.ZIndex = 2
			v175.GraphicsQualitySlider:SetInteractable(true)

			if p12 == v175.GraphicsQualitySlider:GetValue() then
				SetGraphicsQuality(p12)

				return
			end

			v175.GraphicsQualitySlider:SetValue(p12)
		end

		local u279 = false

		v175.GraphicsQualitySlider.ValueChanged:connect(function(p13) -- line: 681
			-- upvalues: u279 (ref), reportSettingsForAnalytics (copy)
			SetGraphicsQuality(p13)

			if u279 == true then
				reportSettingsForAnalytics()
			end

			u279 = true
		end)
		v175.GraphicsQualityEnabler.IndexChanged:connect(function(p14) -- line: 689
			-- upvalues: v175 (copy), setGraphicsToManual (copy), reportSettingsForAnalytics (copy), reportSettingsChangeForAnalytics (copy)
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
				v175.GraphicsQualitySlider:SetZIndex(1)
				v175.GraphicsQualityLabel.ZIndex = 1
				v175.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			elseif p14 == t12.Manual.Value then
				setGraphicsToManual(v175.GraphicsQualitySlider:GetValue())
			end

			reportSettingsForAnalytics()
			reportSettingsChangeForAnalytics("gfx_mode", AutomaticName, ManualName)
		end)
		game.GraphicsQualityChangeRequest:Connect(function(p15) -- line: 707
			-- upvalues: GameSettings (copy), v175 (copy)
			if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
				local Value = v175.GraphicsQualitySlider:GetValue()
				local v768 = if not p15 then Value - 1 else Value + 1

				v175.GraphicsQualitySlider:SetValue(v768)
			end
		end)

		if FastInt >= 0 then
			if FastInt == 0 then
				v175.GraphicsQualityEnabler:SetSelectionIndex(1)
				v175.GraphicsQualitySlider:SetZIndex(1)
				v175.GraphicsQualityLabel.ZIndex = 1
				v175.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			else
				v175.GraphicsQualityEnabler:SetSelectionIndex(2)
				setGraphicsToManual(FastInt)
			end
		elseif GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			v175.GraphicsQualitySlider:SetValue(5)
			v175.GraphicsQualitySlider:SetZIndex(1)
			v175.GraphicsQualityLabel.ZIndex = 1
			v175.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		else
			local str = tostring(GameSettings.SavedQualityLevel)
			local u281 = not t1[str] and 10 or t1[str]

			SetGraphicsQuality(u281)
			spawn(function() -- line: 740
				-- upvalues: v175 (copy), u281 (ref)
				v175.GraphicsQualitySlider:SetValue(u281)
			end)
		end
	end
	local function createReducedMotionOptions() -- line: 746
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n5 = 2

		if GameSettings.ReducedMotion then
			n5 = 1
		end

		local v283 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.ReducedMotion")
		local v284 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.ReducedMotion")
		local v285 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v286 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v287 = v175
		local v288 = v175
		local v289 = v175
		local v290, v291, v292 = Utility:AddNewRow(v175, v283, "Selector", {
			v285,
			v286
		}, n5, nil, v284)

		v287.ReducedMotionFrame = v290
		v288.ReducedMotionLabel = v291
		v289.ReducedMotionMode = v292
		v175.ReducedMotionFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ReducedMotionFrame
		v175.ReducedMotionMode.IndexChanged:connect(function(p16) -- line: 768
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local ReducedMotion = GameSettings.ReducedMotion

			GameSettings.ReducedMotion = p16 == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("reduced_motion", ReducedMotion, GameSettings.ReducedMotion)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPlayerNamesEnabledOptions() -- line: 779
		-- upvalues: v143 (copy), RobloxTranslator (copy), FFlagUpdatePeopleNamesSettingCopy (copy), GameSettings (copy), t7 (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v293 = if not v143 then if not FFlagUpdatePeopleNamesSettingCopy then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PlayerNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeoplesNames")
		local v294 = if not FFlagUpdatePeopleNamesSettingCopy then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames.Description")

		local function GetPlayerNamesEnabledStartIndex() -- line: 787
			-- upvalues: GameSettings (copy)
			if GameSettings.PlayerNamesEnabled then
				return 1
			end

			return 2
		end

		local v296 = if not GameSettings.PlayerNamesEnabled then t7.Off else t7.On
		local v297 = if not v143 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
		local v298 = if not v143 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
		local v299 = v175
		local v300 = v175
		local v301 = v175
		local v302, v303, v304 = Utility:AddNewRow(v175, v293, "Selector", {
			v297,
			v298
		}, v296, nil, v294)

		v299.PlayerNamesEnabledFrame = v302
		v300.playerNamesEnabledLabel = v303
		v301.playerNamesEnabledMode = v304
		v175.PlayerNamesEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PlayerNamesEnabledFrame
		v175.playerNamesEnabledMode.IndexChanged:connect(function(p17) -- line: 806
			-- upvalues: GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PlayerNamesEnabled = GameSettings.PlayerNamesEnabled

			GameSettings.PlayerNamesEnabled = p17 == 1
			reportSettingsChangeForAnalytics("player_names_enabled", PlayerNamesEnabled, GameSettings.PlayerNamesEnabled)
			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTransparencyOptions() -- line: 815
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v305 = 10 - math.clamp(math.floor(GameSettings.PreferredTransparency * 10 + 0.5), 0, 10)
		local v306 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTransparency")
		local v307 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTransparency")
		local v308 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Transparent")
		local v309 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Opaque")
		local v310 = v175
		local v311 = v175
		local v312 = v175
		local v313, v314, v315 = Utility:AddNewRow(v175, v306, "Slider", 10, v305, nil, v307, v308, v309)

		v310.PreferredTransparencyFrame = v313
		v311.PreferredTransparencyLabel = v314
		v312.PreferredTransparencySlider = v315
		v175.PreferredTransparencyFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTransparencyFrame
		v175.PreferredTransparencySlider.ValueChanged:connect(function(p18) -- line: 841
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v774 = (10 - math.clamp(math.floor(p18), 0, 10)) / 10
			local PreferredTransparency = GameSettings.PreferredTransparency

			GameSettings.PreferredTransparency = v774

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_transparency", PreferredTransparency, GameSettings.PreferredTransparency)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTextSizeOptions() -- line: 853
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local EnumItems = Enum.PreferredTextSize:GetEnumItems()
		local v317 = GameSettings.PreferredTextSize.Value - 1
		local v318 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTextSize")
		local v319 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTextSize")
		local v320 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Default")
		local v321 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Largest")
		local v322 = v175
		local v323 = v175
		local v324 = v175
		local v325, v326, v327 = Utility:AddNewRow(v175, v318, "Slider", 3, v317, nil, v319, v320, v321)

		v322.PreferredTextSizeFrame = v325
		v323.PreferredTextSizeLabel = v326
		v324.PreferredTextSizeSlider = v327
		v175.PreferredTextSizeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTextSizeFrame
		v175.PreferredTextSizeSlider.ValueChanged:connect(function(p19) -- line: 878
			-- upvalues: GameSettings (copy), EnumItems (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PreferredTextSize = GameSettings.PreferredTextSize

			GameSettings.PreferredTextSize = EnumItems[p19 + 1]

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_text_size", PreferredTextSize, GameSettings.PreferredTextSize)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createUiNavigationKeyBindOptions() -- line: 888
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), UserInputService (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local t13 = {
			On = 1,
			Off = 2
		}
		local Off = t13.Off

		if GameSettings.UiNavigationKeyBindEnabled then
			Off = t13.On
		end

		local v330 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.UiNavigationKeyBind")
		local v331 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.UiNavigationKeyBind", {
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})
		local v332 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v333 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v334 = v175
		local v335 = v175
		local v336 = v175
		local v337, v338, v339 = Utility:AddNewRow(v175, v330, "Selector", {
			v332,
			v333
		}, Off, nil, v331)

		v334.UiNavigationKeyBindEnabledFrame = v337
		v335.UiNavigationKeyBindEnabledLabel = v338
		v336.UiNavigationKeyBindEnabledMode = v339
		v175.UiNavigationKeyBindEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame
		v175.UiNavigationKeyBindEnabledMode.IndexChanged:connect(function(p20) -- line: 919
			-- upvalues: GameSettings (copy), t13 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local UiNavigationKeyBindEnabled = GameSettings.UiNavigationKeyBindEnabled

			GameSettings.UiNavigationKeyBindEnabled = p20 == t13.On

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("ui_navigation_key_bind_enabled", UiNavigationKeyBindEnabled, GameSettings.UiNavigationKeyBindEnabled)
			end

			reportSettingsForAnalytics()
		end)

		local function updateUiNavigationKeyBindVisibility() -- line: 932
			-- upvalues: UserInputService (copy), v175 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled = UserInputService.KeyboardEnabled

			if v175.UiNavigationKeyBindEnabledFrame then
				v175.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

				if KeyboardEnabled then
					v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		local KeyboardEnabled = UserInputService.KeyboardEnabled

		if v175.UiNavigationKeyBindEnabledFrame then
			v175.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

			if KeyboardEnabled then
				v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)
			else
				v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 947
			-- upvalues: UserInputService (copy), v175 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled2 = UserInputService.KeyboardEnabled

			if v175.UiNavigationKeyBindEnabledFrame then
				v175.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled2

				if KeyboardEnabled2 then
					v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v175.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end)
	end
	local function createPerformanceStatsOptions() -- line: 952
		-- upvalues: v175 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v342 = v175
		local v343 = v175
		local v344 = v175
		local v345 = v175

		v342.PerformanceStatsFrame = nil
		v343.PerformanceStatsLabel = nil
		v344.PerformanceStatsMode = nil
		v345.PerformanceStatsOverrideText = nil

		function GetDesiredPerformanceStatsIndex() -- line: 958
			-- upvalues: GameSettings (copy)
			if GameSettings.PerformanceStatsVisible then
				return 1
			end

			return 2
		end

		local v346 = GetDesiredPerformanceStatsIndex()
		local v347 = v175
		local v348 = v175
		local v349 = v175
		local v350, v351, v352 = Utility:AddNewRow(v175, "Performance Stats", "Selector", {
			"On",
			"Off"
		}, v346)

		v347.PerformanceStatsFrame = v350
		v348.PerformanceStatsLabel = v351
		v349.PerformanceStatsMode = v352
		v175.PerformanceStatsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PerformanceStatsFrame
		v175.PerformanceStatsOverrideText = Create("TextLabel")({
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
			Parent = v175.PerformanceStatsFrame
		})
		v175.PerformanceStatsMode.IndexChanged:connect(function(p21) -- line: 987
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
		GameSettings.PerformanceStatsVisibleChanged:connect(function() -- line: 1009
			-- upvalues: v175 (copy)
			local v784 = GetDesiredPerformanceStatsIndex()

			if v784 ~= v175.PerformanceStatsMode.CurrentIndex then
				v175.PerformanceStatsMode:SetSelectionIndex(v784)
			end
		end)
	end
	local function createWebServerInformationRow() -- line: 1019
		-- upvalues: v175 (copy), Utility (copy), v56 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), TouchEnabled (copy), Create (copy), Theme (copy)
		local v353 = v175
		local v354 = v175
		local v355 = v175
		local v356, v357, v358 = Utility:AddNewRow(v175, "MicroProfiler Information", "TextBox", nil, nil, 5, nil, nil, nil, not v56 and nil)

		v353.InformationFrame = v356
		v354.InformationLabel = v357
		v355.InformationTextBox = v358
		v175.InformationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.InformationFrame
		v175.InformationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		if TouchEnabled then
			v175.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size18),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				Parent = v175.InformationFrame
			})
		else
			v175.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size14),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(1, -650, 0, 20),
				Parent = v175.InformationFrame
			})
		end

		return v175.InformationFrame, v175.InformationText
	end
	local function createMicroProfilerOptions() -- line: 1059
		-- upvalues: v175 (copy), GameSettings (copy), createWebServerInformationRow (copy), v124 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v123 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v359 = v175
		local v360 = v175
		local v361 = v175
		local v362 = v175

		v359.MicroProfilerFrame = nil
		v360.MicroProfilerLabel = nil
		v361.MicroProfilerMode = nil
		v362.MicroProfilerOverrideText = nil

		local function tryContentLabel() -- line: 1064
			-- upvalues: GameSettings (copy), v175 (copy), createWebServerInformationRow (copy)
			local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

			if MicroProfilerWebServerPort ~= 0 then
				local v786 = v175
				local v787 = v175
				local v788, v789 = createWebServerInformationRow()

				v786.InformationFrame = v788
				v787.InformationText = v789
				v175.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort

				return true
			end

			return false
		end
		local function setMicroProfilerIndex(p22) -- line: 1076
			-- upvalues: GameSettings (copy), v175 (copy), v124 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), createWebServerInformationRow (copy), v123 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local function hideContentLabel() -- line: 1077
				-- upvalues: GameSettings (copy), v175 (copy)
				GameSettings.MicroProfilerWebServerEnabled = false

				if v175.InformationFrame or v175.InformationText then
					v175.InformationFrame.Visible = false
					v175.InformationFrame.Parent = nil
					v175.InformationText.Parent = nil
					v175.InformationFrame = nil
					v175.InformationText = nil
				end
			end

			local s1 = nil
			local MicroProfilerWebServerEnabled = nil
			local MicroProfilerWebServerEnabled2 = nil

			if v124 then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					s1 = "webserver"
					MicroProfilerWebServerEnabled = GameSettings.MicroProfilerWebServerEnabled
				end

				if p22 == 1 then
					GameSettings.MicroProfilerWebServerEnabled = true

					local n6 = 30

					while n6 >= 1 do
						local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort
						local v801

						if MicroProfilerWebServerPort ~= 0 then
							local v797 = v175
							local v798 = v175
							local v799, v800 = createWebServerInformationRow()

							v797.InformationFrame = v799
							v798.InformationText = v800
							v175.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
							v801 = true
						else
							v801 = false
						end

						if v801 then
							break
						end

						n6 -= 1
						wait(0.1)
					end

					if n6 <= 0 then
						v175.MicroProfilerMode:SetSelectionIndex(2)
						GameSettings.MicroProfilerWebServerEnabled = false

						if v175.InformationFrame or v175.InformationText then
							v175.InformationFrame.Visible = false
							v175.InformationFrame.Parent = nil
							v175.InformationText.Parent = nil
							v175.InformationFrame = nil
							v175.InformationText = nil
						end
					end
				else
					GameSettings.MicroProfilerWebServerEnabled = false

					if v175.InformationFrame or v175.InformationText then
						v175.InformationFrame.Visible = false
						v175.InformationFrame.Parent = nil
						v175.InformationText.Parent = nil
						v175.InformationFrame = nil
						v175.InformationText = nil
					end
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					MicroProfilerWebServerEnabled2 = GameSettings.MicroProfilerWebServerEnabled
				end
			elseif v123 or isInExperienceUIVREnabled and isSpatial() then
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
		local function GetDesiredWebServerIndex() -- line: 1150
			-- upvalues: v124 (copy), GameSettings (copy), v123 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy)
			if v124 then
				if GameSettings.MicroProfilerWebServerEnabled then
					return 1
				end

				return 2
			end

			if v123 or isInExperienceUIVREnabled and isSpatial() then
				if GameSettings.OnScreenProfilerEnabled then
					return 1
				end

				return 2
			end

			return 2
		end

		local v366 = if not v124 then not v123 and (not isInExperienceUIVREnabled or not isSpatial()) and 2 or (not GameSettings.OnScreenProfilerEnabled and 2 or 1) else not GameSettings.MicroProfilerWebServerEnabled and 2 or 1
		local v367 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MicroProfiler")
		local v368 = v175
		local v369 = v175
		local v370 = v175
		local v371, v372, v373 = Utility:AddNewRow(v175, v367, "Selector", {
			"On",
			"Off"
		}, v366)

		v368.MicroProfilerFrame = v371
		v369.MicroProfilerLabel = v372
		v370.MicroProfilerMode = v373
		v175.MicroProfilerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MicroProfilerFrame

		local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

		if MicroProfilerWebServerPort ~= 0 then
			local v375 = v175
			local v376 = v175
			local v377, v378 = createWebServerInformationRow()

			v375.InformationFrame = v377
			v376.InformationText = v378
			v175.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
		end

		local u379 = false

		GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 1179
			-- upvalues: u379 (ref), GameSettings (copy), v175 (copy)
			u379 = true

			if GameSettings.OnScreenProfilerEnabled then
				v175.MicroProfilerMode:SetSelectionIndex(1)

				return
			end

			v175.MicroProfilerMode:SetSelectionIndex(2)
		end)

		local function onIndexChanged(...) -- line: 1189
			-- upvalues: u379 (ref), setMicroProfilerIndex (copy)
			if u379 then
				u379 = false

				return
			end

			setMicroProfilerIndex(...)
		end

		v175.MicroProfilerMode.IndexChanged:connect(onIndexChanged)
	end
	local function createCameraModeOptions(p23) -- line: 1200
		-- upvalues: v175 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), LocalPlayer (copy), UserInputService (copy), CoreUtility (copy), t4 (copy), VRService (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v81 (copy), t3 (copy), t2 (copy)
		local v382 = v175
		local v383 = v175
		local v384 = v175
		local v385 = v175

		v382.ShiftLockFrame = nil
		v383.ShiftLockLabel = nil
		v384.ShiftLockMode = nil
		v385.ShiftLockOverrideText = nil

		local n7 = 2

		if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
			n7 = 1
		end

		local v387 = v175
		local v388 = v175
		local v389 = v175
		local v390, v391, v392 = Utility:AddNewRow(v175, "Shift Lock Switch", "Selector", {
			"On",
			"Off"
		}, n7)

		v387.ShiftLockFrame = v390
		v388.ShiftLockLabel = v391
		v389.ShiftLockMode = v392
		v175.ShiftLockFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ShiftLockFrame
		t10[v175.ShiftLockFrame] = true
		v175.ShiftLockOverrideText = Create("TextLabel")({
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
			Parent = v175.ShiftLockFrame
		})
		v175.ShiftLockMode.IndexChanged:connect(function(p24) -- line: 1231
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v803 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v803 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			end

			if p24 == 1 then
				GameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
			else
				GameSettings.ControlMode = Enum.ControlMode.Classic
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("shift_lock_enabled", v803, GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
			end

			reportSettingsForAnalytics()
		end)

		local function setShiftLockSelectorVisible(b1: boolean) -- line: 1253
			-- upvalues: LocalPlayer (copy), v175 (copy)
			local v805 = b1 and LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockMode then
				v175.ShiftLockMode.SelectorFrame.Visible = v805
				v175.ShiftLockMode:SetInteractable(v805)
			end
		end
		local function applyDevOverrideShiftLockSelector() -- line: 1261
			-- upvalues: LocalPlayer (copy), v175 (copy)
			local v806 = not LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockOverrideText then
				v175.ShiftLockOverrideText.Visible = v806

				local v807 = not v806 and LocalPlayer.DevEnableMouseLock

				if v175.ShiftLockMode then
					v175.ShiftLockMode.SelectorFrame.Visible = v807
					v175.ShiftLockMode:SetInteractable(v807)
				end
			end
		end
		local function updateShiftLockVisibility() -- line: 1269
			-- upvalues: UserInputService (copy), v175 (copy), LocalPlayer (copy)
			local v808 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v175.ShiftLockFrame then
				v175.ShiftLockFrame.Visible = v808
			end

			local v809 = not LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockOverrideText then
				v175.ShiftLockOverrideText.Visible = v809

				local v810 = not v809 and LocalPlayer.DevEnableMouseLock

				if v175.ShiftLockMode then
					v175.ShiftLockMode.SelectorFrame.Visible = v810
					v175.ShiftLockMode:SetInteractable(v810)
				end
			end
		end

		local v396 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

		if v175.ShiftLockFrame then
			v175.ShiftLockFrame.Visible = v396
		end

		local v397 = not LocalPlayer.DevEnableMouseLock

		if v175.ShiftLockOverrideText then
			v175.ShiftLockOverrideText.Visible = v397

			local v398 = not v397 and LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockMode then
				v175.ShiftLockMode.SelectorFrame.Visible = v398
				v175.ShiftLockMode:SetInteractable(v398)
			end
		end

		UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function() -- line: 1279
			-- upvalues: UserInputService (copy), v175 (copy), LocalPlayer (copy)
			local v811 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v175.ShiftLockFrame then
				v175.ShiftLockFrame.Visible = v811
			end

			local v812 = not LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockOverrideText then
				v175.ShiftLockOverrideText.Visible = v812

				local v813 = not v812 and LocalPlayer.DevEnableMouseLock

				if v175.ShiftLockMode then
					v175.ShiftLockMode.SelectorFrame.Visible = v813
					v175.ShiftLockMode:SetInteractable(v813)
				end
			end
		end)
		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 1283
			-- upvalues: UserInputService (copy), v175 (copy), LocalPlayer (copy)
			local v814 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v175.ShiftLockFrame then
				v175.ShiftLockFrame.Visible = v814
			end

			local v815 = not LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockOverrideText then
				v175.ShiftLockOverrideText.Visible = v815

				local v816 = not v815 and LocalPlayer.DevEnableMouseLock

				if v175.ShiftLockMode then
					v175.ShiftLockMode.SelectorFrame.Visible = v816
					v175.ShiftLockMode:SetInteractable(v816)
				end
			end
		end)

		function cameraModeIsUserChoice() -- line: 1289
			-- upvalues: UserInputService (copy), LocalPlayer (copy)
			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				return LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
			end

			return LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end
		function setCameraModeVisible(p25) -- line: 1298
			-- upvalues: v175 (copy)
			if v175.CameraMode then
				v175.CameraMode.SelectorFrame.Visible = p25
				v175.CameraMode:SetInteractable(p25)
				v175.CameraModeOverrideText.Visible = not p25
			end
		end

		local v399 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
		local t14 = {}
		local t15 = {}

		local function updateCurrentCameraMovementIndex(p26) -- line: 1312
			-- upvalues: t15 (ref), t14 (ref), UserInputService (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy)
			local u819 = nil

			if not pcall(function() -- line: 1314
				-- upvalues: u819 (ref), t15 (ref), t14 (ref), p26 (copy)
				u819 = t15[t14[p26]]
			end) or u819 == nil then
				return false
			end

			local TouchCameraMovementModeValue = nil
			local v821

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.TouchCameraMovementMode.Value
				end

				v821 = GameSettings.TouchCameraMovementMode.Value ~= u819
				GameSettings.TouchCameraMovementMode = u819
			else
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.ComputerCameraMovementMode.Value
				end

				v821 = GameSettings.ComputerCameraMovementMode.Value ~= u819
				GameSettings.ComputerCameraMovementMode = u819
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() and v821 then
				reportSettingsChangeForAnalytics("camera_mode", TouchCameraMovementModeValue, u819)
			end

			return v821
		end
		local function updateCameraMovementModes() -- line: 1348
			-- upvalues: v399 (copy), UserInputService (copy), t14 (ref), t15 (ref), t4 (copy), v175 (copy), GameSettings (copy), updateCurrentCameraMovementIndex (copy)
			local t16 = {}

			if v399 then
				t16 = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then v399:GetRegisteredComputerCameraMovementModes() else v399:GetRegisteredTouchCameraMovementModes()
			end

			t14 = {}
			t15 = {}

			if #t16 <= 0 then
				setCameraModeVisible(false)

				return
			end

			for i = 1, #t16 do
				local v824 = t16[i]
				local Name = v824.Name

				if Name == "Default" then
					Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t4.DEFAULT_CLASSIC else t4.DEFAULT_FOLLOW
				end

				t14[#t14 + 1] = Name
				t15[Name] = v824.Value
			end

			if v175.CameraMode then
				v175.CameraMode:UpdateOptions(t14)
			end

			local v826 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
			local v827 = if not v826 then GameSettings.ComputerCameraMovementMode.Value else GameSettings.TouchCameraMovementMode.Value

			if v827 > -1 then
				if v826 or GameSettings.ComputerCameraMovementMode ~= Enum.ComputerCameraMovementMode.CameraToggle then
					v827 += 1
				end

				updateCurrentCameraMovementIndex(v827)
				v175.CameraMode:SetSelectionIndex(v827)
			end

			setCameraModeVisible(cameraModeIsUserChoice())
		end

		local v404 = v175
		local v405 = v175
		local v406 = v175
		local v407, v408, v409 = Utility:AddNewRow(v175, "Camera Mode", "Selector", t14, 1)

		v404.CameraModeFrame = v407
		v405.CameraModeLabel = v408
		v406.CameraMode = v409
		v175.CameraModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraModeFrame
		t10[v175.CameraMode] = true
		v175.CameraModeOverrideText = Create("TextLabel")({
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
			Parent = v175.CameraModeFrame
		})

		if v399 then
			v399.TouchCameraMovementModeRegistered:connect(function(__) -- line: 1434
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.TouchEnabled then
					updateCameraMovementModes()
				end
			end)
			v399.ComputerCameraMovementModeRegistered:connect(function(__) -- line: 1440
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.MouseEnabled then
					updateCameraMovementModes()
				end
			end)
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1447
			-- upvalues: updateCameraMovementModes (copy)
			updateCameraMovementModes()
		end)

		local u410 = false

		v175.CameraMode.IndexChanged:connect(function(p29) -- line: 1452
			-- upvalues: updateCurrentCameraMovementIndex (copy), u410 (ref), reportSettingsForAnalytics (copy)
			if updateCurrentCameraMovementIndex(p29) then
				if u410 then
					reportSettingsForAnalytics()
				end

				u410 = true
			end
		end)
		updateCameraMovementModes()

		local u411 = false

		local function createVROption() -- line: 1468
			-- upvalues: u411 (ref), GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy)
			if not u411 then
				u411 = true

				local u831 = if not GameSettings.VREnabled then {
					"On (restart pending)",
					"Off"
				} else {
					"On",
					"Off (restart pending)"
				}
				local v832 = v175
				local v833 = v175
				local v834 = v175
				local v835, v836, v837 = Utility:AddNewRow(v175, "VR", "Selector", u831, not GameSettings.VREnabled and 2 or 1)

				v832.VREnabledFrame = v835
				v833.VREnabledLabel = v836
				v834.VREnabledSelector = v837
				v175.VREnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VREnabledFrame
				v175.VREnabledSelector.IndexChanged:connect(function(p30) -- line: 1483
					-- upvalues: GameSettings (copy), u831 (ref), reportSettingsChangeForAnalytics (copy)
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
					local v1071 = p30 == t17.On.Value

					if v1071 ~= GameSettings.VREnabled then
						GameSettings.VREnabled = v1071

						local v1072 = u831[t17.On.Value]
						local v1073 = u831[p30]

						if v1073 == u831[t17.On.Value] then
							v1072 = u831[t17.Off.Value]
						end

						reportSettingsChangeForAnalytics("vr_mode", v1072, v1073)
					end
				end)
			end
		end
		local function onVREnabledChanged() -- line: 1502
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

		local function u418(__: boolean) -- line: 1527
		end
		local function setMovementModeVisible(p31) -- line: 1531
			-- upvalues: v175 (copy), t18 (ref)
			if v175.MovementMode then
				local v840 = p31 and #t18 > 0

				v175.MovementMode.SelectorFrame.Visible = v840
				v175.MovementMode:SetInteractable(v840)
				v175.MovementModeOverrideText.Visible = not v840
			end
		end

		if p23 then
			local v420 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

			local function getDisplayName(p32) -- line: 1545
				-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v81 (copy)
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
					p32 = v81
				end

				return p32
			end

			local v422 = v175
			local v423 = v175
			local v424 = v175
			local v425, v426, v427 = Utility:AddNewRow(v175, "Movement Mode", "Selector", {}, 1)

			v422.MovementModeFrame = v425
			v423.MovementModeLabel = v426
			v424.MovementMode = v427
			v175.MovementModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MovementModeFrame
			t10[v175.MovementMode] = true
			v175.MovementModeOverrideText = Create("TextLabel")({
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
				Parent = v175.MovementModeFrame
			})

			local function setMovementMode(p33) -- line: 1586
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

			function u418(b3: boolean) -- line: 1603
				-- upvalues: LocalPlayer (copy), v175 (copy), t18 (ref)
				local v845 = if not b3 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

				if v175.MovementMode then
					local v846 = v845 and #t18 > 0

					v175.MovementMode.SelectorFrame.Visible = v846
					v175.MovementMode:SetInteractable(v846)
					v175.MovementModeOverrideText.Visible = not v846
				end

				if v175.MovementModeOverrideText then
					v175.MovementModeOverrideText.Visible = not v845
				end
			end

			local function updateMovementModes() -- line: 1615
				-- upvalues: UserInputService (copy), v420 (copy), t18 (ref), t19 (ref), t20 (ref), t21 (ref), v175 (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v81 (copy), GameSettings (copy), setMovementMode (copy), u418 (ref)
				local v847 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

				if v420 then
					if v847 then
						t18 = v420:GetRegisteredTouchMovementModes()
					else
						t18 = v420:GetRegisteredComputerMovementModes()
					end
				end

				t19 = {}
				t20 = {}
				t21 = {}

				if #t18 <= 0 then
					if v175.MovementMode then
						v175.MovementMode.SelectorFrame.Visible = false
						v175.MovementMode:SetInteractable(false)
						v175.MovementModeOverrideText.Visible = true
					end

					return
				end

				if v175.MovementMode then
					local v848 = #t18 > 0

					v175.MovementMode.SelectorFrame.Visible = v848
					v175.MovementMode:SetInteractable(v848)
					v175.MovementModeOverrideText.Visible = not v848
				end

				for v849, v850 in t18 do
					t20[v849] = v850

					local v851 = t21
					local Name = v850.Name

					if Name == "Default" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.DEFAULT_KEYBOARD else RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
					elseif Name == "KeyboardMouse" then
						Name = "Keyboard + Mouse"
					elseif Name == "ClickToMove" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.CLICK_TO_MOVE else t6.TAP_TO_MOVE
					elseif Name == "DynamicThumbstick" then
						Name = "Dynamic Thumbstick"
					elseif Name == "Thumbstick" then
						Name = v81
					end

					v851[v849] = Name
					t19[v850] = v849
				end

				if v175.MovementMode then
					v175.MovementMode:UpdateOptions(t21)
				end

				local v853 = if not v847 then GameSettings.ComputerMovementMode else GameSettings.TouchMovementMode

				if v853 then
					setMovementMode(v853)
					v175.MovementMode:SetSelectionIndex(t19[v853])
				end

				u418(v847)
			end

			updateMovementModes()

			if v420 then
				v420.TouchMovementModeRegistered:connect(function(__) -- line: 1659
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.TouchEnabled then
						updateMovementModes()
					end
				end)
				v420.ComputerMovementModeRegistered:connect(function(__) -- line: 1665
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.MouseEnabled then
						updateMovementModes()
					end
				end)
			end

			UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1672
				-- upvalues: updateMovementModes (copy)
				updateMovementModes()
			end)
			v175.MovementMode.IndexChanged:connect(function(p36) -- line: 1676
				-- upvalues: setMovementMode (copy), t20 (ref), reportSettingsForAnalytics (copy)
				setMovementMode(t20[p36])
				reportSettingsForAnalytics()
			end)
		end

		local v430 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

		if not if not v430 then LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice else LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
			v175.CameraModeOverrideText.Visible = true
			setCameraModeVisible(false)
		else
			v175.CameraModeOverrideText.Visible = false
			setCameraModeVisible(true)
		end

		local v431 = if not v430 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

		if v175.MovementModeOverrideText then
			if not v431 then
				v175.MovementModeOverrideText.Visible = true

				if v175.MovementMode then
					v175.MovementMode.SelectorFrame.Visible = false
					v175.MovementMode:SetInteractable(false)
					v175.MovementModeOverrideText.Visible = true
				end
			else
				v175.MovementModeOverrideText.Visible = false

				if v175.MovementMode then
					local v432 = #t18 > 0

					v175.MovementMode.SelectorFrame.Visible = v432
					v175.MovementMode:SetInteractable(v432)
					v175.MovementModeOverrideText.Visible = not v432
				end
			end
		end

		local v433 = not LocalPlayer.DevEnableMouseLock

		if v175.ShiftLockOverrideText then
			v175.ShiftLockOverrideText.Visible = v433

			local v434 = not v433 and LocalPlayer.DevEnableMouseLock

			if v175.ShiftLockMode then
				v175.ShiftLockMode.SelectorFrame.Visible = v434
				v175.ShiftLockMode:SetInteractable(v434)
			end
		end

		local function updateUserSettingsMenu(p37) -- line: 1722
			-- upvalues: LocalPlayer (copy), v175 (copy), u418 (ref), t18 (ref)
			if p37 == "DevEnableMouseLock" then
				local v858 = not LocalPlayer.DevEnableMouseLock

				if v175.ShiftLockOverrideText then
					v175.ShiftLockOverrideText.Visible = v858

					local v859 = not v858 and LocalPlayer.DevEnableMouseLock

					if v175.ShiftLockMode then
						v175.ShiftLockMode.SelectorFrame.Visible = v859
						v175.ShiftLockMode:SetInteractable(v859)

						return
					end
				end
			else
				if p37 == "DevComputerCameraMode" then
					local v860 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice

					setCameraModeVisible(v860)
					v175.CameraModeOverrideText.Visible = not v860

					return
				end

				if p37 == "DevComputerMovementMode" then
					if u418 ~= nil then
						u418(false)

						return
					end

					local v861 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice

					if v175.MovementMode then
						local v862 = v861 and #t18 > 0

						v175.MovementMode.SelectorFrame.Visible = v862
						v175.MovementMode:SetInteractable(v862)
						v175.MovementModeOverrideText.Visible = not v862
					end

					if v175.MovementModeOverrideText then
						v175.MovementModeOverrideText.Visible = not v861

						return
					end
				elseif p37 == "DevTouchMovementMode" then
					if u418 ~= nil then
						u418(true)

						return
					end

					local v863 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

					if v175.MovementMode then
						local v864 = v863 and #t18 > 0

						v175.MovementMode.SelectorFrame.Visible = v864
						v175.MovementMode:SetInteractable(v864)
						v175.MovementModeOverrideText.Visible = not v864
					end

					if v175.MovementModeOverrideText then
						v175.MovementModeOverrideText.Visible = not v863

						return
					end
				elseif p37 == "DevTouchCameraMode" then
					local v865 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice

					setCameraModeVisible(v865)
					v175.CameraModeOverrideText.Visible = not v865
				end
			end
		end

		LocalPlayer.Changed:connect(function(p38) -- line: 1757
			-- upvalues: t3 (copy), updateUserSettingsMenu (copy), t2 (copy)
			if t3[p38] then
				updateUserSettingsMenu(p38)
			end

			if t2[p38] then
				updateUserSettingsMenu(p38)
			end
		end)
	end
	local function createFeedbackModeOptions() -- line: 1770
		-- upvalues: Url (copy), HttpService (copy), v138 (copy), v175 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v137 (copy), Utility (copy), v83 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v132 (copy), v120 (copy)
		local v436 = Url.ROLES_URL .. "v1/users/authenticated/roles"
		local v437 = HttpService:RequestInternal({
			Method = "GET",
			Url = v436
		})

		local function rolesCheckCallback(p39) -- line: 1777
			-- upvalues: v138 (copy), v175 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v137 (copy), Utility (copy), v83 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p39 then
				if not v138 and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v175.FeedbackEntryPointEnabled then
					return
				end

				local function onToggleFeedbackMode() -- line: 1789
					-- upvalues: v138 (copy), v175 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy)
					if v138 and (game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v175.FeedbackEntryPointEnabled) then
						return
					end

					v175.HubRef:PopMenu(false, true)

					if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
						SafetyService.IsCaptureModeForReport = false
					end

					if ExperienceStateCaptureService ~= nil then
						ExperienceStateCaptureService:ToggleCaptureMode()
					end

					reportSettingsChangeForAnalytics("translation_feedback", "", "pressed")
				end

				local v869, v870

				if v137 then
					v869, v870 = Utility:MakeStyledButton("toggleFeedbackModeButton", v83, UDim2.new(1, 0, 1, -20), onToggleFeedbackMode, v175)
					v869.Size = UDim2.new(0.6, 0, 0, 40)
					v869.Position = UDim2.new(0.4, 0, 0.5, 0)
					v869.AnchorPoint = Vector2.new(0, 0.5)
				else
					v869, v870 = Utility:MakeStyledButton("toggleFeedbackModeButton", v83, UDim2.new(0, 300, 1, -20), onToggleFeedbackMode, v175)
					v869.Size = UDim2.new(0, 300, 0, 30)
					v869.Position = UDim2.new(0.4, 0, 0.5, 0)
					v869.AnchorPoint = Vector2.new(0, 0.5)
				end

				v869.ZIndex = 2
				v869.Selectable = true
				v870.ZIndex = 2

				if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
					v175.toggleFeedbackModeButton = v869
					v175.toggleFeedbackModeText = v870
				end

				if v137 then
					Utility:AddNewRowObject(v175, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v869, nil, true).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton

					return
				end

				Utility:AddNewRowObject(v175, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v869).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
			end
		end

		if v132 then
			rolesCheckCallback(true)

			return
		end

		v437:Start(function(p40, p41) -- line: 1873
			-- upvalues: HttpService (copy), v120 (copy), v436 (copy), rolesCheckCallback (copy)
			local u873 = false
			local v874 = false
			local s2

			if not p40 then
				s2 = "Roles Api Request: Connection error"
			elseif p41.StatusCode == 401 then
				s2 = "Roles Api Request: Unauthorized"
			elseif p41.StatusCode < 200 or p41.StatusCode >= 400 then
				s2 = "Roles Api Status code: " .. p41.StatusCode
			else
				v874, s2 = pcall(function() -- line: 1885
					-- upvalues: HttpService (copy), p41 (copy), u873 (ref)
					local data = HttpService:JSONDecode(p41.Body)

					for __, v in pairs(data.roles) do
						if v == "Soothsayer" then
							u873 = true
						end
					end
				end)
			end

			if not v874 then
				v120:warning("Feedback Mode initialization api call failed with url: " .. v436 .. " and with error message: " .. s2)
			end

			rolesCheckCallback(u873)
		end)
	end
	local function createTranslationOptions() -- line: 1913
		-- upvalues: Players (copy), Url (copy), HttpService (copy), v120 (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), LocalPlayer (copy), reportSettingsChangeForAnalytics (copy), RunService (copy)
		local n8 = 1
		local n9 = 1
		local u441 = false
		local languageCode = nil
		local localeCode = nil
		local LocaleId = Players.LocalPlayer.LocaleId
		local languageCode2 = nil
		local u446 = nil
		local t22 = {}
		local t23 = {}
		local t24 = {}
		local t25 = {}
		local t26 = {}
		local v452 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))
		local v453 = HttpService:RequestInternal({
			Method = "GET",
			Url = v452
		})
		local v454 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
		local v455 = HttpService:RequestInternal({
			Method = "GET",
			Url = v454
		})
		local v456 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/supported-languages/games/%d/in-experience-language-selection", game.GameId)
		local v457 = HttpService:RequestInternal({
			Method = "GET",
			Url = v456
		})
		local v458 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
		local v459 = HttpService:RequestInternal({
			Method = "GET",
			Url = v458
		})

		local function userExperienceLanguageSettingsCallback(p42, p43) -- line: 1978
			-- upvalues: v120 (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t26 (copy), t24 (copy), languageCode (ref), t22 (copy), u446 (ref), t23 (copy), n8 (ref), n9 (ref), LocalPlayer (copy), localeCode (ref), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), u441 (ref), RunService (copy)
			if not p42 then
				if p43 == nil then
					p43 = "Execution path did not set earliest error to non-nil value."
				end

				v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p43)

				local v878 = v175
				local v879 = v175
				local v880 = v175
				local v881, v882, v883 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

				v878.LanguageSelectorFrame = v881
				v879.LanguageSelectorLabel = v882
				v880.LanguageSelectorMode = v883
				v175.LanguageSelectorMode:SetInteractable(false)
				v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

				return
			end

			local v884 = false

			table.insert(t26, t24[languageCode].languageName .. " (Original)")

			for __, v in pairs(t22) do
				if v == u446 then
					v884 = true
				end

				if v ~= languageCode then
					table.insert(t26, t24[v].languageName)
				end
			end

			if v884 == true then
				for k, v in pairs(t26) do
					if k ~= 1 and t23[v] == u446 then
						n8 = k
						n9 = k
					end
				end
			end

			local v889 = v175
			local v890 = v175
			local v891 = v175
			local v892, v893, v894 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", t26, n8)

			v889.LanguageSelectorFrame = v892
			v890.LanguageSelectorLabel = v893
			v891.LanguageSelectorMode = v894
			v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

			if n8 == 1 then
				LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
			else
				local v895 = t23[t26[n8]]

				LocalPlayer:SetExperienceSettingsLocaleId(t24[v895].localeCode)
			end

			v175.LanguageSelectorMode.CurrentLanguage = v175.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

			local function toggleTranslation(p44) -- line: 2058
				-- upvalues: v175 (copy), t24 (copy), languageCode (ref), t23 (copy), t26 (copy), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), n9 (ref), LocalPlayer (copy), localeCode (ref), v120 (copy), u441 (ref), RunService (copy)
				v175.LanguageSelectorMode:SetInteractable(false)

				local v1078 = if p44 ~= 1 then t24[t23[t26[p44]]].id else t24[languageCode].id
				local CurrentLanguage = v175.LanguageSelectorMode.CurrentLanguage
				local v1080 = t26[p44]

				if CurrentLanguage ~= v1080 then
					v175.LanguageSelectorMode.CurrentLanguage = v1080
					reportSettingsChangeForAnalytics("experience_language", CurrentLanguage, v1080)
				end

				local t27 = {
					settingValue = {
						settingType = "LanguageFamily",
						settingTargetId = v1078
					}
				}
				local v1082 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
				local v1083 = HttpService:RequestInternal({
					Method = "POST",
					Url = v1082,
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode(t27)
				})

				local function callback(p45, p46) -- line: 2105
					-- upvalues: n9 (ref), p44 (copy), LocalPlayer (copy), localeCode (ref), t23 (copy), t26 (copy), t24 (copy), v120 (copy), u441 (ref), v175 (copy)
					if p45 then
						n9 = p44

						if p44 == 1 then
							LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
						else
							local v1164 = t23[t26[p44]]

							LocalPlayer:SetExperienceSettingsLocaleId(t24[v1164].localeCode)
						end
					else
						v120:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p46)
						u441 = true
						v175.LanguageSelectorMode:SetSelectionIndex(n9)
					end

					v175.LanguageSelectorMode:SetInteractable(true)
				end

				if RunService:IsStudio() then
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1085 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1085].localeCode)
					end

					v175.LanguageSelectorMode:SetInteractable(true)

					return
				end

				if u441 then
					u441 = false
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1086 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1086].localeCode)
					end

					v175.LanguageSelectorMode:SetInteractable(true)

					return
				end

				v1083:Start(function(p47, p48) -- line: 2148
					-- upvalues: v120 (copy), v1082 (copy), callback (copy)
					local v1167 = false
					local s3 = nil

					if not p47 then
						s3 = "User Experience Language Settings Update Request: Connection error"
					elseif p48.StatusCode == 401 then
						s3 = "User Experience Language Settings Update Request: Unauthorized"
					elseif p48.StatusCode < 200 or p48.StatusCode >= 400 then
						s3 = "User Experience Language Settings Update Request Status Code: " .. p48.StatusCode
					else
						v120:info("User Experience Language Settings Update Request succeeded with code: " .. p48.StatusCode)
						v1167 = true
					end

					if not v1167 then
						v120:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. v1082 .. " with error message: " .. s3)
					end

					callback(v1167, s3)
				end)
			end

			v175.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
		end
		local function experienceSupportedLanguagesCallback(p49, p50) -- line: 2183
			-- upvalues: v459 (copy), HttpService (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v120 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p49 then
				v459:Start(function(p51, p52) -- line: 2185
					-- upvalues: HttpService (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v120 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy)
					local v1089 = false
					local s4

					if not p51 then
						s4 = "User Experience Language Setting Request: Connection error"
					elseif p52.StatusCode == 401 then
						s4 = "User Experience Language Setting Request: Unauthorized"
					elseif p52.StatusCode < 200 or p52.StatusCode >= 400 then
						s4 = "User Experience Language Setting Request Status code: " .. p52.StatusCode
					else
						v1089, s4 = pcall(function() -- line: 2196
							-- upvalues: HttpService (copy), p52 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
							local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p52.Body).userUniverseLocalizationSettingValue

							if userUniverseLocalizationSettingValue == nil then
								u446 = languageCode2

								return
							end

							if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
								if userUniverseLocalizationSettingValue.settingTargetId == 1 then
									u446 = languageCode
								else
									u446 = languageCode2
								end
							end

							if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
								if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
									u446 = languageCode2

									return
								end

								u446 = t25[userUniverseLocalizationSettingValue.settingTargetId]
							end
						end)
					end

					if not v1089 then
						v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v458 .. " with error message: " .. s4)
					end

					userExperienceLanguageSettingsCallback(v1089, s4)
				end)

				return
			end

			if p50 == nil then
				p50 = "Execution path did not set earliest error to non-nil value."
			end

			v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p50)

			local v899 = v175
			local v900 = v175
			local v901 = v175
			local v902, v903, v904 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

			v899.LanguageSelectorFrame = v902
			v900.LanguageSelectorLabel = v903
			v901.LanguageSelectorMode = v904
			v175.LanguageSelectorMode:SetInteractable(false)
			v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
		end
		local function experienceSourceLanguageCallback(p53, p54) -- line: 2245
			-- upvalues: v457 (copy), HttpService (copy), t22 (copy), v120 (copy), v456 (copy), v459 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p53 then
				v457:Start(function(p55, p56) -- line: 2247
					-- upvalues: HttpService (copy), t22 (copy), v120 (copy), v456 (copy), p54 (ref), p53 (copy), v459 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1093 = false
					local s5

					if not p55 then
						s5 = "Experience Supported Language Request: Connection error"
					elseif p56.StatusCode == 401 then
						s5 = "Experience Supported Language Request: Unauthorized"
					elseif p56.StatusCode < 200 or p56.StatusCode >= 400 then
						s5 = "Experience Supported Language Request Status code: " .. p56.StatusCode
					else
						v1093, s5 = pcall(function() -- line: 2257
							-- upvalues: HttpService (copy), p56 (copy), t22 (copy)
							local data = HttpService:JSONDecode(p56.Body)

							for k, v in pairs(data.data) do
								t22[k] = v.languageCode
							end
						end)
					end

					if not v1093 then
						v120:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v456 .. " with error message: " .. s5)
					end

					if p54 == nil then
						p54 = s5
					end

					local v1095 = v1093 and p53
					local v1096 = p54

					if v1095 then
						v459:Start(function(p57, p58) -- line: 2185
							-- upvalues: HttpService (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v120 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy)
							local v1175 = false
							local s6

							if not p57 then
								s6 = "User Experience Language Setting Request: Connection error"
							elseif p58.StatusCode == 401 then
								s6 = "User Experience Language Setting Request: Unauthorized"
							elseif p58.StatusCode < 200 or p58.StatusCode >= 400 then
								s6 = "User Experience Language Setting Request Status code: " .. p58.StatusCode
							else
								v1175, s6 = pcall(function() -- line: 2196
									-- upvalues: HttpService (copy), p58 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
									local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p58.Body).userUniverseLocalizationSettingValue

									if userUniverseLocalizationSettingValue == nil then
										u446 = languageCode2

										return
									end

									if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
										if userUniverseLocalizationSettingValue.settingTargetId == 1 then
											u446 = languageCode
										else
											u446 = languageCode2
										end
									end

									if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
										if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
											u446 = languageCode2

											return
										end

										u446 = t25[userUniverseLocalizationSettingValue.settingTargetId]
									end
								end)
							end

							if not v1175 then
								v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v458 .. " with error message: " .. s6)
							end

							userExperienceLanguageSettingsCallback(v1175, s6)
						end)

						return
					end

					if v1096 == nil then
						v1096 = "Execution path did not set earliest error to non-nil value."
					end

					v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1096)

					local v1097 = v175
					local v1098 = v175
					local v1099 = v175
					local v1100, v1101, v1102 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

					v1097.LanguageSelectorFrame = v1100
					v1098.LanguageSelectorLabel = v1101
					v1099.LanguageSelectorMode = v1102
					v175.LanguageSelectorMode:SetInteractable(false)
					v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
				end)
			else
				local v908 = p54

				if v908 == nil then
					v908 = "Execution path did not set earliest error to non-nil value."
				end

				v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v908)

				local v909 = v175
				local v910 = v175
				local v911 = v175
				local v912, v913, v914 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

				v909.LanguageSelectorFrame = v912
				v910.LanguageSelectorLabel = v913
				v911.LanguageSelectorMode = v914
				v175.LanguageSelectorMode:SetInteractable(false)
				v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end
		local function localeCodeToLanguageCodeMappingCallback(p59, p60) -- line: 2286
			-- upvalues: v455 (copy), HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v120 (copy), v454 (copy), v457 (copy), t22 (copy), v456 (copy), v459 (copy), u446 (ref), languageCode2 (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p59 then
				v455:Start(function(p61, p62) -- line: 2288
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v120 (copy), v454 (copy), p60 (ref), p59 (copy), v457 (copy), t22 (copy), v456 (copy), v459 (copy), u446 (ref), languageCode2 (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1105 = false
					local s7

					if not p61 then
						s7 = "Experience Source Language Request: Connection error"
					elseif p62.StatusCode == 401 then
						s7 = "Experience Source Language Request: Unauthorized"
					elseif p62.StatusCode < 200 or p62.StatusCode >= 400 then
						s7 = "Experience Source Language Status code: " .. p62.StatusCode
					else
						v1105, s7 = pcall(function() -- line: 2299
							-- upvalues: HttpService (copy), p62 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p62.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1105 then
						v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v454 .. " with error message: " .. s7)
					end

					if p60 == nil then
						p60 = s7
					end

					local v1107 = v1105 and p59
					local u1108 = p60

					if v1107 then
						v457:Start(function(p63, p64) -- line: 2247
							-- upvalues: HttpService (copy), t22 (copy), v120 (copy), v456 (copy), u1108 (ref), v1107 (copy), v459 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1179 = false
							local s8

							if not p63 then
								s8 = "Experience Supported Language Request: Connection error"
							elseif p64.StatusCode == 401 then
								s8 = "Experience Supported Language Request: Unauthorized"
							elseif p64.StatusCode < 200 or p64.StatusCode >= 400 then
								s8 = "Experience Supported Language Request Status code: " .. p64.StatusCode
							else
								v1179, s8 = pcall(function() -- line: 2257
									-- upvalues: HttpService (copy), p64 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p64.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1179 then
								v120:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v456 .. " with error message: " .. s8)
							end

							if u1108 == nil then
								u1108 = s8
							end

							local v1181 = v1179 and v1107
							local v1182 = u1108

							if v1181 then
								v459:Start(function(p65, p66) -- line: 2185
									-- upvalues: HttpService (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v120 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1215 = false
									local s9

									if not p65 then
										s9 = "User Experience Language Setting Request: Connection error"
									elseif p66.StatusCode == 401 then
										s9 = "User Experience Language Setting Request: Unauthorized"
									elseif p66.StatusCode < 200 or p66.StatusCode >= 400 then
										s9 = "User Experience Language Setting Request Status code: " .. p66.StatusCode
									else
										v1215, s9 = pcall(function() -- line: 2196
											-- upvalues: HttpService (copy), p66 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p66.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u446 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u446 = languageCode
												else
													u446 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u446 = languageCode2

													return
												end

												u446 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1215 then
										v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v458 .. " with error message: " .. s9)
									end

									userExperienceLanguageSettingsCallback(v1215, s9)
								end)

								return
							end

							if v1182 == nil then
								v1182 = "Execution path did not set earliest error to non-nil value."
							end

							v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1182)

							local v1183 = v175
							local v1184 = v175
							local v1185 = v175
							local v1186, v1187, v1188 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

							v1183.LanguageSelectorFrame = v1186
							v1184.LanguageSelectorLabel = v1187
							v1185.LanguageSelectorMode = v1188
							v175.LanguageSelectorMode:SetInteractable(false)
							v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1109 = u1108

						if v1109 == nil then
							v1109 = "Execution path did not set earliest error to non-nil value."
						end

						v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1109)

						local v1110 = v175
						local v1111 = v175
						local v1112 = v175
						local v1113, v1114, v1115 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

						v1110.LanguageSelectorFrame = v1113
						v1111.LanguageSelectorLabel = v1114
						v1112.LanguageSelectorMode = v1115
						v175.LanguageSelectorMode:SetInteractable(false)
						v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v918 = p60

				if v918 == nil then
					v918 = "Execution path did not set earliest error to non-nil value."
				end

				v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v918)

				local v919 = v175
				local v920 = v175
				local v921 = v175
				local v922, v923, v924 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

				v919.LanguageSelectorFrame = v922
				v920.LanguageSelectorLabel = v923
				v921.LanguageSelectorMode = v924
				v175.LanguageSelectorMode:SetInteractable(false)
				v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		v453:Start(function(p67, p68) -- line: 2330
			-- upvalues: HttpService (copy), t24 (copy), t25 (copy), t23 (copy), LocaleId (copy), languageCode2 (ref), v120 (copy), v452 (copy), v455 (copy), languageCode (ref), localeCode (ref), v454 (copy), v457 (copy), t22 (copy), v456 (copy), v459 (copy), u446 (ref), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local v927 = false
			local s10

			if not p67 then
				s10 = "Locale Code to Language Code Mapping Request: Connection error"
			elseif p68.StatusCode == 401 then
				s10 = "Locale Code to Language Code Mapping Request: Unauthorized"
			elseif p68.StatusCode < 200 or p68.StatusCode >= 400 then
				s10 = "Locale Code to Language Code Mapping Request Status code: " .. p68.StatusCode
			else
				v927, s10 = pcall(function() -- line: 2341
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

			if not v927 then
				v120:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v452 .. " with error message: " .. s10)
			end

			local v929 = v927
			local u930 = s10

			if v929 then
				v455:Start(function(p69, p70) -- line: 2288
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v120 (copy), v454 (copy), u930 (ref), v929 (copy), v457 (copy), t22 (copy), v456 (copy), v459 (copy), u446 (ref), languageCode2 (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1125 = false
					local s11

					if not p69 then
						s11 = "Experience Source Language Request: Connection error"
					elseif p70.StatusCode == 401 then
						s11 = "Experience Source Language Request: Unauthorized"
					elseif p70.StatusCode < 200 or p70.StatusCode >= 400 then
						s11 = "Experience Source Language Status code: " .. p70.StatusCode
					else
						v1125, s11 = pcall(function() -- line: 2299
							-- upvalues: HttpService (copy), p70 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p70.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1125 then
						v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v454 .. " with error message: " .. s11)
					end

					if u930 == nil then
						u930 = s11
					end

					local v1127 = v1125 and v929
					local u1128 = u930

					if v1127 then
						v457:Start(function(p71, p72) -- line: 2247
							-- upvalues: HttpService (copy), t22 (copy), v120 (copy), v456 (copy), u1128 (ref), v1127 (copy), v459 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy), v175 (copy), Utility (copy), RobloxTranslator (copy), v82 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1191 = false
							local s12

							if not p71 then
								s12 = "Experience Supported Language Request: Connection error"
							elseif p72.StatusCode == 401 then
								s12 = "Experience Supported Language Request: Unauthorized"
							elseif p72.StatusCode < 200 or p72.StatusCode >= 400 then
								s12 = "Experience Supported Language Request Status code: " .. p72.StatusCode
							else
								v1191, s12 = pcall(function() -- line: 2257
									-- upvalues: HttpService (copy), p72 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p72.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1191 then
								v120:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v456 .. " with error message: " .. s12)
							end

							if u1128 == nil then
								u1128 = s12
							end

							local v1193 = v1191 and v1127
							local v1194 = u1128

							if v1193 then
								v459:Start(function(p73, p74) -- line: 2185
									-- upvalues: HttpService (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v120 (copy), v458 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1222 = false
									local s13

									if not p73 then
										s13 = "User Experience Language Setting Request: Connection error"
									elseif p74.StatusCode == 401 then
										s13 = "User Experience Language Setting Request: Unauthorized"
									elseif p74.StatusCode < 200 or p74.StatusCode >= 400 then
										s13 = "User Experience Language Setting Request Status code: " .. p74.StatusCode
									else
										v1222, s13 = pcall(function() -- line: 2196
											-- upvalues: HttpService (copy), p74 (copy), u446 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p74.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u446 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u446 = languageCode
												else
													u446 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u446 = languageCode2

													return
												end

												u446 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1222 then
										v120:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v458 .. " with error message: " .. s13)
									end

									userExperienceLanguageSettingsCallback(v1222, s13)
								end)

								return
							end

							if v1194 == nil then
								v1194 = "Execution path did not set earliest error to non-nil value."
							end

							v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1194)

							local v1195 = v175
							local v1196 = v175
							local v1197 = v175
							local v1198, v1199, v1200 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

							v1195.LanguageSelectorFrame = v1198
							v1196.LanguageSelectorLabel = v1199
							v1197.LanguageSelectorMode = v1200
							v175.LanguageSelectorMode:SetInteractable(false)
							v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1129 = u1128

						if v1129 == nil then
							v1129 = "Execution path did not set earliest error to non-nil value."
						end

						v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1129)

						local v1130 = v175
						local v1131 = v175
						local v1132 = v175
						local v1133, v1134, v1135 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

						v1130.LanguageSelectorFrame = v1133
						v1131.LanguageSelectorLabel = v1134
						v1132.LanguageSelectorMode = v1135
						v175.LanguageSelectorMode:SetInteractable(false)
						v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v931 = u930

				if v931 == nil then
					v931 = "Execution path did not set earliest error to non-nil value."
				end

				v120:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v931)

				local v932 = v175
				local v933 = v175
				local v934 = v175
				local v935, v936, v937 = Utility:AddNewRow(v175, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v82 }, 1)

				v932.LanguageSelectorFrame = v935
				v933.LanguageSelectorLabel = v936
				v934.LanguageSelectorMode = v937
				v175.LanguageSelectorMode:SetInteractable(false)
				v175.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end)
	end
	local function getChatTranslationLayerData(p75) -- line: 2380
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

		local ok, result = pcall(function() -- line: 2402
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
	local function createVolumeOptions() -- line: 2420
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v468 = math.floor(GameSettings.MasterVolume * 10)
		local v469 = v175
		local v470 = v175
		local v471 = v175
		local v472, v473, v474 = Utility:AddNewRow(v175, "Volume", "Slider", 10, v468)

		v469.VolumeFrame = v472
		v470.VolumeLabel = v473
		v471.VolumeSlider = v474
		v175.VolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VolumeFrame

		local Sound = Instance.new("Sound", game:GetService("CoreGui").RobloxGui.Sounds)

		Sound.Name = "VolumeChangeSound"
		Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
		v175.VolumeSlider.ValueChanged:connect(function(p76) -- line: 2431
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), Sound (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v939 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v939 = math.floor(GameSettings.MasterVolume * 10 + 0.5)
			end

			local v940 = p76 / 10

			Sound.Volume = v940
			Sound:Play()
			GameSettings.MasterVolume = v940

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("volume", v939, (math.floor(GameSettings.MasterVolume * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPartyVoiceVolumeOptions() -- line: 2449
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v476 = math.floor(GameSettings.PartyVoiceVolume * 10)
		local v477 = v175
		local v478 = v175
		local v479 = v175
		local v480, v481, v482 = Utility:AddNewRow(v175, "Party Voice Volume", "Slider", 10, v476)

		v477.PartyVoiceVolumeFrame = v480
		v478.PartyVoiceVolumeLabel = v481
		v479.PartyVoiceVolumeSlider = v482
		v175.PartyVoiceVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PartyVoiceVolumeFrame

		if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			v175.PartyVoiceVolumeFrame.Visible = default4.hasExperienceStarted
			default4.ExperienceJoined.Event:Connect(function() -- line: 2458
				-- upvalues: v175 (copy)
				v175.PartyVoiceVolumeFrame.Visible = true
			end)
			default4.ExperienceLeft.Event:Connect(function() -- line: 2461
				-- upvalues: v175 (copy)
				v175.PartyVoiceVolumeFrame.Visible = false
			end)
		end

		v175.PartyVoiceVolumeSlider.ValueChanged:connect(function(p77) -- line: 2466
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v476 (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v942 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v942 = v476 == nil and 0 or math.floor(v476 * 10 + 0.5)
			end

			GameSettings.PartyVoiceVolume = p77 / 10

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("party_voice_volume", v942, (math.floor(p77 * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createVoiceChatVolumeOptions() -- line: 2482
		-- upvalues: GameSettings (copy), u24 (ref), v120 (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v483 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
		local ok, result = pcall(function() -- line: 2484
			-- upvalues: u24 (ref)
			return u24:Format("CoreScripts.InGameMenu.GameSettings.VoiceChatVolume")
		end)

		if not ok then
			result = "Voice Chat Volume"
			v120:debug("[GameSettings] createVoiceChatVolumeOptions failed to get translation for Voice Chat Volume label, using placeholder text instead")
		end

		local v486 = v175
		local v487 = v175
		local v488 = v175
		local v489, v490, v491 = Utility:AddNewRow(v175, result, "Slider", 10, v483)

		v486.VoiceChatVolumeFrame = v489
		v487.VoiceChatVolumeLabel = v490
		v488.VoiceChatVolumeSlider = v491
		v175.VoiceChatVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceChatVolumeFrame
		v175.VoiceChatVolumeFrame.Visible = false
		v175.VoiceChatVolumeSlider.ValueChanged:connect(function(p78) -- line: 2498
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v944 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v944 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
			end

			GameSettings.VoiceChatVolume = p78 / 5

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("voice_chat_volume", v944, (math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createHapticsToggle() -- line: 2517
		-- upvalues: GameSettings (copy), getAppFeaturePolicies (copy), u24 (ref), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v492 = GameSettings.HapticStrength ~= 0 and 2 or 1
		local v493 = not getAppFeaturePolicies().getShouldUseVibrationInsteadOfHaptics() and "Haptics" or u24:Format("CoreScripts.InGameMenu.Vibration")
		local v494 = v175
		local v495 = v175
		local v496, v497, v498 = Utility:AddNewRow(v175, v493, "Selector", {
			"Off",
			"On"
		}, v492)

		v494.HapticsFrame = v496
		_ = v497
		v495.HapticsSelector = v498
		v175.HapticsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.HapticsFrame
		v175.HapticsSelector.IndexChanged:connect(function(p79) -- line: 2526
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
	local function createCameraInvertedOptions() -- line: 2542
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n10 = 1

		if pcall(function() -- line: 2544
			-- upvalues: GameSettings (copy), n10 (ref)
			if GameSettings.CameraYInverted == true then
				n10 = 2
			end
		end) == false then
			return
		end

		local v500 = v175
		local v501 = v175
		local v502, v503, v504 = Utility:AddNewRow(v175, "Camera Inverted", "Selector", {
			"Off",
			"On"
		}, n10)

		v500.CameraInvertedFrame = v502
		_ = v503
		v501.CameraInvertedSelector = v504
		v175.CameraInvertedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraInvertedFrame
		t10[v175.CameraInvertedFrame] = true
		v175.CameraInvertedSelector.IndexChanged:connect(function(p80) -- line: 2559
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
	local function setCameraSensitivity(p81) -- line: 2578
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
	local function createMouseOptions() -- line: 2616
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), setCameraSensitivity (copy)
		local function translateEngineMouseSensitivityToGui(p82) -- line: 2621
			local v950 = p82 <= 1 and math.floor((p82 - 0.2) / 0.16 + 0.5) or math.floor((p82 + 2) / 0.6 + 0.5)

			if p82 <= 0.2 then
				return 0
			end

			return v950
		end
		local function translateGuiMouseSensitivityToEngine(p83) -- line: 2629
			local v952 = p83 <= 5 and 0.16 * p83 + 0.2 or 0.6 * p83 - 2

			if v952 <= 0.2 then
				return 0.2
			end

			return v952
		end

		local MouseSensitivity = GameSettings.MouseSensitivity
		local v512 = MouseSensitivity <= 1 and math.floor((MouseSensitivity - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivity + 2) / 0.6 + 0.5)
		local v513 = if not (MouseSensitivity <= 0.2) then v512 else 0
		local u514 = true

		tostring(GameSettings.MouseSensitivityFirstPerson.X)

		local v515 = v175
		local v516 = v175
		local v517 = v175
		local v518, v519, v520 = Utility:AddNewRow(v175, "Camera Sensitivity", "Slider", 10, v513)

		v515.MouseAdvancedFrame = v518
		v516.MouseAdvancedLabel = v519
		v517.MouseAdvancedEntry = v520
		v175.MouseAdvancedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MouseAdvancedFrame
		t10[v175.MouseAdvancedFrame] = true
		v175.MouseAdvancedEntry.SliderFrame.Size = UDim2.new(v175.MouseAdvancedEntry.SliderFrame.Size.X.Scale, v175.MouseAdvancedEntry.SliderFrame.Size.X.Offset - 60 - 20, v175.MouseAdvancedEntry.SliderFrame.Size.Y.Scale, v175.MouseAdvancedEntry.SliderFrame.Size.Y.Offset - 6)
		v175.MouseAdvancedEntry.SliderFrame.Position = UDim2.new(v175.MouseAdvancedEntry.SliderFrame.Position.X.Scale, v175.MouseAdvancedEntry.SliderFrame.Position.X.Offset - 60 - 20, v175.MouseAdvancedEntry.SliderFrame.Position.Y.Scale, v175.MouseAdvancedEntry.SliderFrame.Position.Y.Offset)
		v175.MouseAdvancedLabel.ZIndex = 2
		v175.MouseAdvancedEntry:SetInteractable(true)

		local v521 = Create("TextBox")({
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
			Parent = v175.MouseAdvancedEntry.SliderFrame
		})

		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = v521
		})

		local function setMouseSensitivityText(p84) -- line: 2688
			-- upvalues: v521 (copy)
			local v954 = math.floor(p84 * 1000 + 0.5) / 1000

			v521.Text = tostring((tonumber((string.format("%.3f", v954)))))
		end

		local v523 = math.floor(GameSettings.MouseSensitivityFirstPerson.X * 1000 + 0.5) / 1000

		v521.Text = tostring((tonumber((string.format("%.3f", v523)))))

		local MouseAdvancedEntry = v175.MouseAdvancedEntry
		local MouseSensitivityFirstPersonX = GameSettings.MouseSensitivityFirstPerson.X
		local v526 = MouseSensitivityFirstPersonX <= 1 and math.floor((MouseSensitivityFirstPersonX - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivityFirstPersonX + 2) / 0.6 + 0.5)

		MouseAdvancedEntry:SetValue(if not (MouseSensitivityFirstPersonX <= 0.2) then v526 else 0)

		function clampMouseSensitivity(p85) -- line: 2703
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
		function setMouseSensitivity(p86, p87) -- line: 2721
			-- upvalues: u514 (ref), setCameraSensitivity (copy), v175 (copy), v521 (copy)
			if not u514 then
				return
			end

			setCameraSensitivity(p86)
			u514 = false

			if p87 ~= v175.MouseAdvancedEntry then
				local MouseAdvancedEntry2 = v175.MouseAdvancedEntry
				local v959 = p86 <= 1 and math.floor((p86 - 0.2) / 0.16 + 0.5) or math.floor((p86 + 2) / 0.6 + 0.5)

				MouseAdvancedEntry2:SetValue(if not (p86 <= 0.2) then v959 else 0)
			end

			local v960 = math.floor(p86 * 1000 + 0.5) / 1000

			v521.Text = tostring((tonumber((string.format("%.3f", v960)))))
			u514 = true
		end

		v521.FocusLost:connect(function() -- line: 2739
			-- upvalues: v175 (copy), v521 (copy), GameSettings (copy)
			v175.MouseAdvancedEntry:SetInteractable(true)

			local num = tonumber((string.match(v521.Text, "([%d%.]+)")))

			if num then
				setMouseSensitivity(clampMouseSensitivity(num), v521)

				return
			end

			setMouseSensitivity(GameSettings.MouseSensitivityFirstPerson.X, v521)
		end)
		v521.Focused:connect(function() -- line: 2751
			-- upvalues: v175 (copy)
			v175.MouseAdvancedEntry:SetInteractable(false)
		end)
		v175.MouseAdvancedEntry.ValueChanged:connect(function(p88) -- line: 2755
			-- upvalues: v175 (copy)
			local v963 = clampMouseSensitivity(p88)
			local v964 = v963 <= 5 and 0.16 * v963 + 0.2 or 0.6 * v963 - 2
			local v965 = if not (v964 <= 0.2) then v964 else 0.2

			setMouseSensitivity(v965, v175.MouseAdvancedEntry)
		end)
	end
	local function createGamepadOptions() -- line: 2762
		-- upvalues: GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), setCameraSensitivity (copy)
		local function translateEngineGamepadSensitivityToGui(p89) -- line: 2767
			local v967 = p89 <= 1 and math.floor((p89 - 0.2) / 0.16 + 0.5) or math.floor((p89 + 2) / 0.6 + 0.5)

			if p89 <= 0.2 then
				return 0
			end

			return v967
		end
		local function translateGuiGamepadSensitivityToEngine(p90) -- line: 2774
			local v969 = p90 <= 5 and 0.16 * p90 + 0.2 or 0.6 * p90 - 2

			if v969 <= 0.2 then
				return 0.2
			end

			return v969
		end

		local GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity
		local v530 = GamepadCameraSensitivity <= 1 and math.floor((GamepadCameraSensitivity - 0.2) / 0.16 + 0.5) or math.floor((GamepadCameraSensitivity + 2) / 0.6 + 0.5)
		local v531 = if not (GamepadCameraSensitivity <= 0.2) then v530 else 0
		local v532 = v175
		local v533 = v175
		local v534 = v175
		local v535, v536, v537 = Utility:AddNewRow(v175, "Camera Sensitivity", "Slider", 10, v531)

		v532.GamepadSensitivityFrame = v535
		v533.GamepadSensitivityLabel = v536
		v534.GamepadSensitivitySlider = v537
		v175.GamepadSensitivityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GamepadSensitivityFrame
		v175.GamepadSensitivitySlider.ValueChanged:connect(function(p91) -- line: 2789
			-- upvalues: setCameraSensitivity (copy)
			local v971 = setCameraSensitivity
			local v972 = p91 <= 5 and 0.16 * p91 + 0.2 or 0.6 * p91 - 2

			v971(if not (v972 <= 0.2) then v972 else 0.2)
		end)
	end
	local function createOverscanOption() -- line: 2794
		-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy), Utility (copy), v175 (copy), Theme (copy), RunService (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v538, v539, v540 = Utility:MakeStyledButton("AdjustButton", "Adjust", UDim2.new(0, 300, 1, -20), function() -- line: 2795
			-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
			local Overscan = require(RobloxGui.Modules.Shell.Components.Overscan10ft.Overscan)
			local v975 = require(RobloxGui.Modules.Settings.Components.OverscanWrapper)(Overscan)
			local Roact = require(CorePackages.Packages.Roact)
			local u977 = nil
			local t29 = {
				onUnmount = function() -- line: 2806
					-- upvalues: u977 (ref), Roact (copy), ContextActionService (copy), SettingsHub (copy)
					if u977 then
						Roact.unmount(u977)
						ContextActionService:UnbindCoreAction("RbxStopOverscanMovement")
						SettingsHub:SetVisibility(true, true)
					end
				end,
				ImageVisible = false,
				BackgroundTransparency = 0.2
			}

			SettingsHub:SetVisibility(false, true)
			ContextActionService:BindCoreAction("RbxStopOverscanMovement", function() -- line: 2822
			end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

			local v979 = Roact.createElement(v975, t29)

			u977 = Roact.mount(v979, RobloxGui, (tostring(v975)))
		end, v175)

		v539.Font = Theme.font(Enum.Font.SourceSans)
		v538.Position = UDim2.new(1, -400, 0, 12)
		v538.Size = UDim2.new(0, 300, 0, 40)
		v538.Position = UDim2.new(1, -400, 0.5, 0)
		v538.AnchorPoint = Vector2.new(0, 0.5)

		if RunService:IsStudio() then
			v538.Selectable = false
			v538.Active = false
			v538.Enabled.Value = false
			v539.TextColor3 = Color3.fromRGB(100, 100, 100)
		end

		local v541 = Utility:AddNewRowObject(v175, "Safe Zone", v538)

		v541.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.OverscanAdjustButton
		v540(v541)
	end
	local function createDeveloperConsoleOption() -- line: 2861
		-- upvalues: reportSettingsChangeForAnalytics (copy), v135 (copy), Utility (copy), v175 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), RunService (copy), PlayerPermissionsModule (copy), Players (copy)
		local function makeDevConsoleOption() -- line: 2863
			-- upvalues: reportSettingsChangeForAnalytics (copy), v135 (copy), Utility (copy), v175 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local function onOpenDevConsole() -- line: 2864
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

			if v135 then
				local v981, v982, v983 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(1, 0, 1, -20), onOpenDevConsole, v175)

				v982.Font = Theme.font(Enum.Font.SourceSans)
				v981.Size = UDim2.new(0.6, -10, 0, 35)
				v981.Position = UDim2.new(0.4, 10, 0.5, 0)
				v981.AnchorPoint = Vector2.new(0, 0.5)

				local v984 = Utility:AddNewRowObject(v175, "Developer Console", v981, nil, true)

				v984.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v983(v984)

				return
			end

			local v985, v986, v987 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(0, 300, 1, -20), onOpenDevConsole, v175)

			v986.Font = Theme.font(Enum.Font.SourceSans)
			v985.Size = UDim2.new(0.6, -10, 0, 35)
			v985.Position = UDim2.new(1, -400, 0.5, 0)
			v985.AnchorPoint = Vector2.new(0, 0.5)

			local v988 = Utility:AddNewRowObject(v175, "Developer Console", v985)

			v988.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
			v987(v988)
		end

		if RunService:IsStudio() then
			makeDevConsoleOption()

			return
		end

		spawn(function() -- line: 2916
			-- upvalues: PlayerPermissionsModule (copy), Players (copy), makeDevConsoleOption (copy)
			if PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer) then
				makeDevConsoleOption()
			end
		end)
	end
	local function createUiToggleOptions() -- line: 2925
		-- upvalues: v134 (copy), v133 (copy), RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), LocalPlayer (copy)
		if v134 or v133 then
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
			local v544 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
			local v545 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

			v175.uiToggleSelectors = {}

			for __, v547 in t30 do
				local v548 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.ShowGuiType", {
					GuiType = v547.label
				})
				local v549, v550, v551 = Utility:AddNewRow(v175, v548, "Selector", {
					v544,
					v545
				}, 1)

				v549.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER[v547.layoutOrderKey]
				v551.IndexChanged:Connect(function(p92) -- line: 2953
					-- upvalues: GuiService (copy), v547 (copy)
					if p92 ~= (not GuiService:GetGuiIsVisible(v547.type) and 2 or 1) then
						GuiService:ToggleGuiIsVisibleIfAllowed(v547.type)
					end
				end)
				v175.uiToggleSelectors[v547.label] = {
					label = v548,
					type = v547.type,
					row = v549,
					frame = v550,
					selector = v551
				}
			end

			local v552 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.Freecam")
			local v553 = v175
			local v554 = v175
			local v555 = v175
			local v556, v557, v558 = Utility:AddNewRow(v175, v552, "Selector", {
				v545,
				v544
			}, 1)

			v553.freecamRow = v556
			v554.freecamFrame = v557
			v555.freecamSelector = v558
			v175.freecamRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FreecamToggleRow
			v175.freecamSelector.IndexChanged:Connect(function(p93) -- line: 2975
				-- upvalues: LocalPlayer (copy)
				local v991 = p93 == 2
				local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

				if not FreecamScript then
					warn("Freecam not present")

					return
				end

				FreecamScript:SetAttribute("FreecamEnabled", v991)
			end)

			return
		end

		local v559 = v175
		local v560 = v175
		local v561 = v175
		local v562, v563, v564 = Utility:AddNewRow(v175, "BillboardGui Visibility", "Selector", {
			"All visible",
			"Hide nameplates/bubble chat"
		}, 1)

		v559.uiToggleRow = v562
		v560.uiToggleFrame = v563
		v561.uiToggleSelector = v564
		v175.uiToggleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiToggleRow
		v175.uiToggleSelector.IndexChanged:connect(function(__) -- line: 2994
			-- upvalues: GuiService (copy)
			GuiService:ToggleGuiIsVisibleIfAllowed(Enum.GuiType.PlayerNameplates)
		end)
	end
	local function updateUiToggleSelection() -- line: 3000
		-- upvalues: v134 (copy), v133 (copy), v175 (copy), GuiService (copy), LocalPlayer (copy)
		if v134 or v133 then
			if not v175.uiToggleSelectors then
				return
			end

			for __, v566 in v175.uiToggleSelectors do
				local v567 = not GuiService:GetGuiIsVisible(v566.type) and 2 or 1

				if v567 ~= v566.selector:GetSelectedIndex() then
					v566.selector:SetSelectionIndex(v567)
				end
			end

			local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

			if FreecamScript then
				local v569 = not FreecamScript:GetAttribute("FreecamEnabled") and 1 or 2

				v175.freecamSelector:SetSelectionIndex(v569)

				return
			end
		else
			if not v175.uiToggleSelector then
				return
			end

			local v570 = not GuiService:GetGuiIsVisible(Enum.GuiType.PlayerNameplates) and 2 or 1

			if v570 == v175.uiToggleSelector:GetSelectedIndex() then
				return
			end

			v175.uiToggleSelector:SetSelectionIndex(v570)
		end
	end
	local function isValidDeviceList(p95, p96, p97) -- line: 3042
		return p95 and (p96 and (p97 and (#p95 > 0 and (p97 > 0 and (p97 <= #p95 and #p95 == #p96)))))
	end
	local function SwitchOutputDevice(p98, p99) -- line: 3055
		-- upvalues: SoundService (copy), v120 (copy)
		SoundService:SetOutputDevice(p98, p99)
		v120:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", p98, p99)
	end
	local function createDeviceOptions(p100) -- line: 3060
		-- upvalues: v175 (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), SoundService (copy), v120 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
		local v577 = v175[p100 .. "DeviceIndex"] or 0
		local v578 = v175[p100 .. "DeviceNames"] or {}
		local v579 = v175[p100 .. "DeviceGuids"] or {}
		local v580 = p100 == "Input" and RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.InputDevice") or RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.OutputDevice")
		local v581 = v175
		local v582 = p100 .. "DeviceFrame"
		local v583 = v175
		local v584 = p100 .. "DeviceSelector"
		local v585, v586, v587 = Utility:AddNewRow(v175, v580, "Selector", v578, v577)

		v581[v582] = v585
		_ = v586
		v583[v584] = v587
		v175[p100 .. "DeviceFrame"].LayoutOrder = p100 == "Input" and SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameInput or SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameOutput
		v175[p100 .. "DeviceInfo"] = {
			Name = v577 > 0 and v578[v577] or nil,
			Guid = v577 > 0 and v579[v577] or nil
		}
		v175[p100 .. "PrevDeviceName"] = v175[p100 .. "DeviceInfo"].Name

		local n11 = 0
		local v589 = GetFIntVoiceChatDeviceChangeDebounceDelay()

		v175[p100 .. "DeviceSelector"].IndexChanged:connect(function(p101) -- line: 3083
			-- upvalues: v175 (copy), p100 (copy), n11 (ref), v589 (copy), default3 (copy), SoundService (copy), v120 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
			if v175[p100 .. "DeviceInfo"].Name == v175[p100 .. "DeviceNames"][p101] and v175[p100 .. "DeviceInfo"].Guid == v175[p100 .. "DeviceGuids"][p101] then
				return
			end

			local v995 = n11 + 1

			n11 = v995
			wait(v589)

			if v995 == n11 then
				n11 = 0
				v175[p100 .. "DeviceInfo"] = {
					Name = v175[p100 .. "DeviceNames"][p101],
					Guid = v175[p100 .. "DeviceGuids"][p101]
				}

				local Name = v175[p100 .. "DeviceInfo"].Name
				local Guid = v175[p100 .. "DeviceInfo"].Guid

				if v175.VoiceChatOptionsEnabled then
					default3:SwitchDevice(p100, Name, Guid)
				else
					SoundService:SetOutputDevice(Name, Guid)
					v120:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", Name, Guid)
				end

				if GetFFlagEnableCrossExpVoice() then
					v120:debug("[GameSettings] Changing {} device to {} {} ", p100, Name, Guid)

					if p100 == "Input" then
						default4:changeInputDevice(Name, Guid)
					else
						default4:changeOutputDevice(Name, Guid)
					end
				end

				reportSettingsChangeForAnalytics(p100, v175[p100 .. "PrevDeviceName"], Name)
				v175[p100 .. "PrevDeviceName"] = Name
			end
		end)
	end
	local function createBadgeVisibilityOptions() -- line: 3125
		-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v143 (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
		spawn(function() -- line: 3126
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v143 (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n12 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n12 = 1
			end

			local v999 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v1000 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v1001 = if not v143 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v1002 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v1003 = v175
			local v1004 = v175
			local v1005 = v175
			local v1006, v1007, v1008 = Utility:AddNewRow(v175, v1001, "Selector", {
				v1000,
				v999
			}, n12, nil, v1002)

			v1003.badgeVisibleRow = v1006
			v1004.badgeVisibleFrame = v1007
			v1005.badgeVisibleSelector = v1008
			v175.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v175.badgeVisibleSelector.IndexChanged:connect(function(p102) -- line: 3140
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p102 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p102 == 1)
			end)
		end)
	end
	local function createChatModerationOptions() -- line: 3147
		-- upvalues: v175 (copy), Utility (copy), u24 (ref), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), Signals (copy), reportSettingsChangeForAnalytics (copy)
		local __ = {
			title = "CoreScripts.InGameMenu.GameSettings.ReadOnlyView",
			description = "CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}
		local v591 = v175
		local v592 = v175
		local v593, v594, v595 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyView"), "Selector", {
			u24:Format("InGame.CommonUI.Label.Off"),
			u24:Format("InGame.CommonUI.Label.On")
		}, 1, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription"))

		v591.ChatModerationFrame = v593
		_ = v594
		v592.ChatModerationSelector = v595
		v175.ChatModerationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatModerationFrame
		v175.ChatModerationFrame.Visible = false

		local v596 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetChatModerationStore(false)

		v175.ChatModerationDisposeEffect = Signals.createEffect(function(p103) -- line: 3171
			-- upvalues: v175 (copy), v596 (copy)
			v175.ChatModerationFrame.Visible = v596.getIsSettingVisible(p103)

			local v1010 = not v596.getIsSettingEnabled(p103) and 1 or 2

			if v1010 ~= v175.ChatModerationSelector:GetSelectedIndex() then
				v175.ChatModerationSelector:SetSelectionIndex(v1010)
			end
		end)
		v175.ChatModerationSelector.IndexChanged:connect(function(p104) -- line: 3180
			-- upvalues: v596 (copy), reportSettingsChangeForAnalytics (copy)
			local v1012 = p104 == 2

			v596.setIsSettingEnabled(v1012)
			reportSettingsChangeForAnalytics("moderate_chat", not v1012, v1012)
		end)
		v596.initialize()
	end
	local function createAIRephraseSettingOptions() -- line: 3189
		-- upvalues: RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceAIRephraseSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy), v144 (copy), ThrottleFunctionCall (copy)
		local v597 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessages")
		local v598 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessagesDescription")
		local v599 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v600 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v601 = v175
		local v602 = v175
		local v603, v604, v605 = Utility:AddNewRow(v175, v597, "Selector", {
			v600,
			v599
		}, 1, nil, v598)

		v601.AIRephraseFrame = v603
		_ = v604
		v602.AIRephraseSelector = v605
		v175.AIRephraseFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AIRephraseFrame
		v175.AIRephraseFrame.Visible = false

		local v606 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getAIRephraseSettingStore(false)
		local v607 = GetFIntDebounceAIRephraseSettingDelay()
		local v608 = v607 > 0
		local u609 = not v606.getIsSettingEnabled(false) and 1 or 2

		v175.AIRephraseDisposeEffect = Signals.createEffect(function(p105) -- line: 3215
			-- upvalues: v175 (copy), v606 (copy), u609 (ref)
			v175.AIRephraseFrame.Visible = v606.getIsSettingVisible(p105)

			local v1014 = not v606.getIsSettingEnabled(p105) and 1 or 2

			if v1014 ~= v175.AIRephraseSelector:GetSelectedIndex() then
				u609 = v1014
				v175.AIRephraseSelector:SetSelectionIndex(v1014)
			end
		end)

		local function v610(p106) -- line: 3226
			-- upvalues: u609 (ref), TextChatService (copy), v606 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
			if p106 == u609 then
				return
			end

			local v1016 = p106 == 2

			task.spawn(function() -- line: 3232
				-- upvalues: TextChatService (copy), v1016 (copy), v606 (copy), u609 (ref), p106 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
				if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1016 and "Disabled" or "Enabled") then
					v606.setIsSettingEnabled(v1016)
					u609 = p106
					reportSettingsChangeForAnalytics("ai_rephrase", not v1016, v1016)

					return
				end

				v175.AIRephraseSelector:SetSelectionIndex(u609)
			end)
		end

		if v144 then
			if v608 then
				local u611 = nil

				v175.AIRephraseSelector.IndexChanged:connect(function(p107) -- line: 3249
					-- upvalues: u611 (ref), v607 (copy), u609 (ref), TextChatService (copy), v606 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
					if u611 then
						task.cancel(u611)
					end

					u611 = task.delay(v607, function() -- line: 3253
						-- upvalues: u611 (ref), p107 (copy), u609 (ref), TextChatService (copy), v606 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
						u611 = nil

						local v1139 = p107

						if v1139 == u609 then
							return
						end

						local v1140 = v1139 == 2

						task.spawn(function() -- line: 3232
							-- upvalues: TextChatService (copy), v1140 (copy), v606 (copy), u609 (ref), v1139 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
							if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1140 and "Disabled" or "Enabled") then
								v606.setIsSettingEnabled(v1140)
								u609 = v1139
								reportSettingsChangeForAnalytics("ai_rephrase", not v1140, v1140)

								return
							end

							v175.AIRephraseSelector:SetSelectionIndex(u609)
						end)
					end)
				end)
			else
				v175.AIRephraseSelector.IndexChanged:connect(v610)
			end
		else
			v175.AIRephraseSelector.IndexChanged:connect(if not v608 then v610 else ThrottleFunctionCall(v607, v610))
		end
	end
	local function createChatSummariesSettingOptions() -- line: 3266
		-- upvalues: RobloxTranslator (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceChatSummariesSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy)
		local v612 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummaries")
		local v613 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummariesDescription")
		local v614 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v615 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v616 = v175
		local v617 = v175
		local v618, v619, v620 = Utility:AddNewRow(v175, v612, "Selector", {
			v615,
			v614
		}, 1, nil, v613)

		v616.ChatSummariesFrame = v618
		_ = v619
		v617.ChatSummariesSelector = v620
		v175.ChatSummariesFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatSummariesFrame
		v175.ChatSummariesFrame.Visible = false

		local v621 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getChatSummariesSettingStore(false)
		local v622 = GetFIntDebounceChatSummariesSettingDelay()
		local v623 = v622 > 0
		local u624 = not v621.getIsSettingEnabled(false) and 1 or 2

		v175.ChatSummariesDisposeEffect = Signals.createEffect(function(p108) -- line: 3292
			-- upvalues: v175 (copy), v621 (copy), u624 (ref)
			v175.ChatSummariesFrame.Visible = v621.getIsSettingVisible(p108)

			local v1019 = not v621.getIsSettingEnabled(p108) and 1 or 2

			if v1019 ~= v175.ChatSummariesSelector:GetSelectedIndex() then
				u624 = v1019
				v175.ChatSummariesSelector:SetSelectionIndex(v1019)
			end
		end)

		if v623 then
			local u625 = nil

			v175.ChatSummariesSelector.IndexChanged:connect(function(p109) -- line: 3325
				-- upvalues: u625 (ref), v622 (copy), u624 (ref), TextChatService (copy), v621 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
				if u625 then
					task.cancel(u625)
				end

				u625 = task.delay(v622, function() -- line: 3329
					-- upvalues: u625 (ref), p109 (copy), u624 (ref), TextChatService (copy), v621 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
					u625 = nil

					local v1141 = p109

					if v1141 == u624 then
						return
					end

					local v1142 = v1141 == 2

					task.spawn(function() -- line: 3309
						-- upvalues: TextChatService (copy), v1142 (copy), v621 (copy), u624 (ref), v1141 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
						if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1142 and "Disabled" or "Enabled") then
							v621.setIsSettingEnabled(v1142)
							u624 = v1141
							reportSettingsChangeForAnalytics("chat_summaries", not v1142, v1142)

							return
						end

						v175.ChatSummariesSelector:SetSelectionIndex(u624)
					end)
				end)
			end)
		else
			v175.ChatSummariesSelector.IndexChanged:connect(function(p110) -- line: 3303
				-- upvalues: u624 (ref), TextChatService (copy), v621 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
				if p110 == u624 then
					return
				end

				local v1021 = p110 == 2

				task.spawn(function() -- line: 3309
					-- upvalues: TextChatService (copy), v1021 (copy), v621 (copy), u624 (ref), p110 (copy), reportSettingsChangeForAnalytics (copy), v175 (copy)
					if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1021 and "Disabled" or "Enabled") then
						v621.setIsSettingEnabled(v1021)
						u624 = p110
						reportSettingsChangeForAnalytics("chat_summaries", not v1021, v1021)

						return
					end

					v175.ChatSummariesSelector:SetSelectionIndex(u624)
				end)
			end)
		end
	end
	local function createCameraDeviceOptions() -- line: 3342
		-- upvalues: v175 (copy), v119 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v120 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
		local v626 = v175.CameraDeviceIndex or 1
		local v627 = v175.CameraDeviceNames or {}
		local v628 = v175.CameraDeviceGuids or {}
		local v629 = v119
		local v630 = v175
		local v631 = v175
		local v632, v633, v634 = Utility:AddNewRow(v175, v629, "Selector", v627, v626)

		v630.CameraDeviceFrame = v632
		_ = v633
		v631.CameraDeviceSelector = v634
		v175.CameraDeviceFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraDeviceFrame
		v175.CameraDeviceInfo = {
			Name = v626 > 0 and v627[v626] or nil,
			Guid = v626 > 0 and v628[v626] or nil
		}
		v175.prevCameraDeviceName = v175.CameraDeviceInfo.Name
		v175.CameraDeviceSelector.IndexChanged:connect(function(p111) -- line: 3359
			-- upvalues: v175 (copy), v120 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
			if v175.CameraDeviceInfo.Name == v175.CameraDeviceNames[p111] and v175.CameraDeviceInfo.Guid == v175.CameraDeviceGuids[p111] then
				return
			end

			v175.CameraDeviceInfo = {
				Name = v175.CameraDeviceNames[p111],
				Guid = v175.CameraDeviceGuids[p111]
			}

			local Guid = v175.CameraDeviceInfo.Guid

			v120:info("Changed webcam to: {}", Guid)
			UserGameSettings.DefaultCameraID = Guid
			reportSettingsChangeForAnalytics("video_camera", v175.prevCameraDeviceName or "None", v175.CameraDeviceInfo.Name)
			v175.prevCameraDeviceName = v175.CameraDeviceInfo.Name
		end)
	end
	local function updateAudioDevices(p112) -- line: 3384
		-- upvalues: SoundService (copy), u24 (ref), v175 (copy), GetFFlagVoiceChatUILogging (copy), v120 (copy), createDeviceOptions (copy)
		local ok, result, v638, v639 = pcall(function() -- line: 3385
			-- upvalues: p112 (copy), SoundService (copy)
			if p112 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v638 and (v639 and (#result > 0 and (v639 > 0 and (v639 <= #result and #result == #v638)))))) then
			if v638[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v175[p112 .. "DeviceNames"] = result
			v175[p112 .. "DeviceGuids"] = v638
			v175[p112 .. "DeviceIndex"] = v639
		else
			if GetFFlagVoiceChatUILogging() then
				v120:warning("Errors in get {} device info", p112)
			end

			v175[p112 .. "DeviceNames"] = {}
			v175[p112 .. "DeviceGuids"] = {}
			v175[p112 .. "DeviceIndex"] = 0
		end

		if not v175[p112 .. "DeviceSelector"] then
			createDeviceOptions(p112)

			return
		end

		v175[p112 .. "DeviceSelector"]:UpdateOptions(result)
		v175[p112 .. "DeviceSelector"]:SetSelectionIndex(v639)
	end
	local function updateVoiceChatDevices(p113) -- line: 3417
		-- upvalues: GetFFlagVoiceChatUILogging (copy), v120 (copy), SoundService (copy), u24 (ref), v175 (copy), createDeviceOptions (copy)
		if p113 ~= "Input" and (p113 ~= "Output" and GetFFlagVoiceChatUILogging()) then
			v120:warning("{} is not supported in VoiceChat devices", p113)
		end

		local ok, result, v643, v644 = pcall(function() -- line: 3424
			-- upvalues: p113 (copy), SoundService (copy)
			if p113 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v643 and (v644 and (#result > 0 and (v644 > 0 and (v644 <= #result and #result == #v643)))))) then
			if v643[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v175[p113 .. "DeviceNames"] = result
			v175[p113 .. "DeviceGuids"] = v643
			v175[p113 .. "DeviceIndex"] = v644
		else
			if GetFFlagVoiceChatUILogging() then
				if #result > 0 then
					v120:warning("Errors in get {} device info success: {}", p113, ok)
				else
					v120:warning("Empty deviceNames list for {}", p113)
				end
			end

			v175[p113 .. "DeviceNames"] = {}
			v175[p113 .. "DeviceGuids"] = {}
			v175[p113 .. "DeviceIndex"] = 0
		end

		if not v175[p113 .. "DeviceSelector"] then
			createDeviceOptions(p113)
		else
			v175[p113 .. "DeviceSelector"]:UpdateOptions(result)
			v175[p113 .. "DeviceSelector"]:SetSelectionIndex(v644)
		end

		if v175[p113 .. "DeviceFrame"] then
			if #result > 0 then
				v175[p113 .. "DeviceFrame"].Visible = true

				return
			end

			v175[p113 .. "DeviceFrame"].Visible = false
		end
	end
	local function updateCameraDevices() -- line: 3476
		-- upvalues: VideoCaptureService (copy), v118 (copy), UserGameSettings (copy), v175 (copy), createCameraDeviceOptions (copy)
		local CameraDevices = VideoCaptureService:GetCameraDevices()
		local t31 = {}
		local t32 = {}
		local n13 = 1

		table.insert(t31, v118)
		table.insert(t32, "{DefaultDeviceGuid}")

		for k, v in pairs(CameraDevices) do
			if k == UserGameSettings.DefaultCameraID then
				n13 = #t31 + 1
			end

			table.insert(t31, v)
			table.insert(t32, k)
		end

		v175.CameraDeviceNames = t31
		v175.CameraDeviceGuids = t32
		v175.CameraDeviceIndex = 0

		if not v175.CameraDeviceSelector then
			createCameraDeviceOptions()
		else
			v175.CameraDeviceSelector:UpdateOptions(t31)
		end

		v175.CameraDeviceSelector:SetSelectionIndex(n13)
	end

	local connection = nil
	local connection2 = nil

	local function updateAudioOptions() -- line: 3506
		-- upvalues: v175 (copy), updateVoiceChatDevices (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), updateAudioDevices (copy)
		if v175.VoiceChatOptionsEnabled then
			updateVoiceChatDevices("Input")
			updateVoiceChatDevices("Output")

			return
		end

		if GetFFlagEnableCrossExpVoice() and default4:getIsConnected() then
			updateAudioDevices("Input")
		end

		updateAudioDevices("Output")
	end
	local function setupDeviceChangedListener() -- line: 3518
		-- upvalues: SoundService (copy), connection (ref), v175 (copy), updateAudioOptions (copy)
		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3520
				-- upvalues: v175 (copy), updateAudioOptions (copy)
				if v175.PageOpen then
					updateAudioOptions()
				end
			end)
		end
	end
	local function setupVideoCameraDeviceChangedListener() -- line: 3528
		-- upvalues: VideoCaptureService (copy), connection2 (ref), v175 (copy), updateCameraDevices (copy)
		if VideoCaptureService.DevicesChanged then
			connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3530
				-- upvalues: v175 (copy), updateCameraDevices (copy)
				if v175.PageOpen then
					updateCameraDevices()
				end
			end)
		end
	end
	local function teardownDeviceChangedListener() -- line: 3538
		-- upvalues: SoundService (copy), connection (ref)
		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end
	end
	local function teardownVideoCameraDeviceChangedListener() -- line: 3544
		-- upvalues: VideoCaptureService (copy), connection2 (ref)
		if VideoCaptureService.DevicesChanged and connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end
	local function checkVoiceChatOptions() -- line: 3552
		-- upvalues: default3 (copy), v175 (copy)
		if default3:VoiceChatAvailable() then
			v175.VoiceChatOptionsEnabled = true
		end
	end
	local function updateInputDeviceVisibility() -- line: 3558
		-- upvalues: v175 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy)
		local v651 = v175.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

		if v175.InputDeviceFrame then
			v175.InputDeviceFrame.Visible = v651
		end
	end

	local u228 = false
	local u229 = nil

	if v59 then
		u229 = false
	end

	local function createVoiceChatSelector() -- line: 3571
		-- upvalues: v58 (copy), v175 (copy), v52 (copy), u24 (ref), default3 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v59 (copy), GetFIntDebounceDisconnectButtonDelay (copy), u229 (ref), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v65 (copy), u228 (ref), ThrottleFunctionCall (copy), v55 (copy), GuiService (copy), v64 (copy), v60 (copy)
		if v58 and (v175.VoiceConnectDisconnectFrame and v175.VoiceConnectDisconnectSelector) then
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

		local v655 = not default3:VoiceChatEnded() and 2 or 1
		local v656 = v175
		local v657 = v175
		local v658, v659, v660 = Utility:AddNewRow(v175, s15, "Selector", {
			s16,
			s17
		}, v655)

		v656.VoiceConnectDisconnectFrame = v658
		_ = v659
		v657.VoiceConnectDisconnectSelector = v660
		v175.VoiceConnectDisconnectFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectDisconnectSelector

		local v661 = default3:getService()

		if v661 and not v59 then
			v661.StateChanged:Connect(function(oldState, newState) -- line: 3596
				-- upvalues: v58 (copy), v175 (copy), default3 (copy)
				if v58 then
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined and v175.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if (newState == Enum.VoiceChatState.Ended or newState == Enum.VoiceChatState.Failed or newState == Enum.VoiceChatState.Idle) and v175.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

						return
					end
				else
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if default3:VoiceChatEnded() then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end
			end)
		end

		local u662 = v655
		local v663 = GetFIntDebounceDisconnectButtonDelay()
		local v664 = v663 > 0

		local function v665(p114) -- line: 3630
			-- upvalues: u662 (ref), v59 (copy), u229 (ref), FFlagVoiceRewarmTelemetry (copy), default3 (copy), Constants2 (copy), v65 (copy), u228 (ref), v175 (copy)
			if p114 == u662 then
				return
			end

			u662 = p114

			if v59 and u229 then
				return
			end

			if FFlagVoiceRewarmTelemetry then
				local v1028, v1029, v1030, v1031 = default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2)

				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1028, v1029, v1030, v1031, default3.joinVoiceButtonContext)
			else
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2))
			end

			if p114 == 2 then
				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			elseif v65 then
				local v1032 = default3:getService()
				local v1033 = v1032 ~= nil and v1032.VoiceChatState == Enum.VoiceChatState.Failed

				if not default3:VoiceChatEnded() and not v1033 then
					default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
					default3:Leave()
				end
			elseif not default3:VoiceChatEnded() then
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			if u228 then
				task.spawn(function() -- line: 3674
					-- upvalues: p114 (copy), v175 (copy)
					task.wait(0.5)

					if p114 ~= 1 then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end)
			end
		end

		v175.VoiceConnectDisconnectSelector.IndexChanged:connect(if not v664 then v665 else ThrottleFunctionCall(v663, v665))

		if v55 then
			v175.VoiceConnectDisconnectFrame.SelectionChanged:Connect(function(__, p116, p117) -- line: 3688
				-- upvalues: s15 (ref), v175 (copy), GuiService (copy)
				if p117 and (p116 and p116.Parent and p116.Parent.Name == s15 .. "Frame" and p117.Name == "ImageButton" and v175.Active) then
					GuiService.SelectedCoreObject = p116
				end
			end)
		end

		default3:subscribe("OnStateChanged", function(__, p119) -- line: 3695
			-- upvalues: v59 (copy), u229 (ref), v64 (copy), v175 (copy), v60 (copy)
			if v59 then
				u229 = true

				if v64 then
					if p119 == Enum.VoiceChatState.Joined and v175.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					end
				elseif p119 == Enum.VoiceChatState.Joined then
					v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
				end
			end

			if v64 then
				if p119 == Enum.VoiceChatState.Failed and v175.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
					v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
				end
			elseif p119 == Enum.VoiceChatState.Failed then
				v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
			end

			if v59 then
				if v60 then
					task.defer(function() -- line: 3727
						-- upvalues: u229 (ref)
						u229 = false
					end)

					return
				end

				u229 = false
			end
		end)
		default3:subscribe("OnRequestMicPermissionRejected", function() -- line: 3736
			-- upvalues: u228 (ref), v59 (copy), u229 (ref), v175 (copy), v60 (copy)
			task.spawn(function() -- line: 3737
				-- upvalues: u228 (ref), v59 (copy), u229 (ref), v175 (copy), v60 (copy)
				task.wait(0.5)
				u228 = true

				if v59 then
					u229 = true
				end

				v175.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

				if v59 then
					if v60 then
						task.defer(function() -- line: 3746
							-- upvalues: u229 (ref)
							u229 = false
						end)

						return
					end

					u229 = false
				end
			end)
		end)
	end
	local function createVoiceConnectDisconnect() -- line: 3757
		-- upvalues: default3 (copy), u24 (ref), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), Utility (copy), ThrottleFunctionCall (copy), v175 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy)
		if default3:IsSeamlessVoice() and not default3.isShowingFTUX then
			local v666 = u24:Format("Feature.GameDetails.Label.VoiceChat")
			local v667 = u24:Format("Feature.SettingsHub.Label.Connect")
			local v668 = u24:Format("Feature.SettingsHub.Label.Disconnect")
			local v669 = GetFIntDebounceDisconnectButtonDelay()
			local v670 = v669 > 0

			local function v671() -- line: 3767
				-- upvalues: default3 (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy)
				if default3:getService() then
					local connection3 = nil

					connection3 = default3:getService().StateChanged:Connect(function(__, newState) -- line: 3771
						-- upvalues: FFlagVoiceRewarmTelemetry (copy), default3 (copy), connection3 (ref)
						if newState == Enum.VoiceChatState.Joined then
							if FFlagVoiceRewarmTelemetry then
								local v1145, v1146, v1147, v1148 = default3:GetConnectDisconnectButtonAnalyticsData(true)

								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1145, v1146, v1147, v1148, default3.joinVoiceButtonContext)
							else
								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
							end

							connection3:Disconnect()
						end
					end)
				elseif FFlagVoiceRewarmTelemetry then
					local v1040, v1041, v1042, v1043 = default3:GetConnectDisconnectButtonAnalyticsData(false)

					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1040, v1041, v1042, v1043, default3.joinVoiceButtonContext)
				else
					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(false))
				end

				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			end
			local function v672() -- line: 3804
				-- upvalues: default3 (copy), Constants2 (copy)
				default3.Analytics:reportLeaveVoiceButtonEvent("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			local v673, v674, v675 = Utility:MakeStyledButton("VoiceConnectButton", v667, UDim2.new(1, 0, 1, -20), if not v670 then v671 else ThrottleFunctionCall(v669, v671), v175)

			voiceConnectSetRowRef = v675

			local v676, v677, v678 = Utility:MakeStyledButton("VoiceDisconnectButton", v668, UDim2.new(1, 0, 1, -20), if not v670 then v672 else ThrottleFunctionCall(v669, v672), v175)

			voiceDisconnectSetRowRef = v678
			v673.Size = UDim2.new(0.6, 0, 0, 40)
			v673.Position = UDim2.new(0.4, 0, 0.5, 0)
			v673.AnchorPoint = Vector2.new(0, 0.5)
			v673.ZIndex = 2
			v673.Selectable = true
			v674.ZIndex = 2
			v676.Size = UDim2.new(0.6, 0, 0, 40)
			v676.Position = UDim2.new(0.4, 0, 0.5, 0)
			v676.AnchorPoint = Vector2.new(0, 0.5)
			v676.ZIndex = 2
			v676.Selectable = true
			v677.ZIndex = 2

			local v679 = Utility:AddNewRowObject(v175, v666, v673, nil, true)
			local v680 = Utility:AddNewRowObject(v175, v666, v676, nil, true)

			v175.VoiceConnectFrame = v679
			v175.VoiceDisconnectFrame = v680
			v679.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectFrame
			v680.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceDisconnectFrame
			voiceConnectSetRowRef(v679)
			voiceDisconnectSetRowRef(v680)

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused() then
				v679.Visible = false
				v680.Visible = false

				return
			end

			if default3:ShouldShowJoinVoice() then
				v679.Visible = true
				v680.Visible = false

				return
			end

			v679.Visible = false
			v680.Visible = true
		end
	end
	local function createVRComfortSettingOptions() -- line: 3867
		-- upvalues: u24 (ref), GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
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

		local v686 = table.find(EnumItems, GameSettings.VRComfortSetting)
		local v687 = v175
		local v688 = v175
		local v689 = v175
		local v690, v691, v692 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.PageTitle.VRComfortSettings"), "Selector", t34, v686, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription"))

		v687.VRComfortSettingFrame = v690
		v688.VRComfortSettingLabel = v691
		v689.VRComfortSettingSelector = v692
		v175.VRComfortSettingFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRComfortSettingFrame

		local v693 = not GameSettings.VignetteEnabled and 2 or 1
		local v694 = v175
		local v695 = v175
		local v696 = v175
		local v697, v698, v699 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.GameSettings.VignetteEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v693)

		v694.VRVignetteEnabledFrame = v697
		v695.VRVignetteEnabledLabel = v698
		v696.VRVignetteEnabledSelector = v699
		v175.VRVignetteEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRVignetteEnabledFrame

		local v700 = not GameSettings.VRSmoothRotationEnabled and 1 or 2
		local v701 = v175
		local v702 = v175
		local v703 = v175
		local v704, v705, v706 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v700)

		v701.VRSteppedRotationEnabledFrame = v704
		v702.VRSteppedRotationEnabledLabel = v705
		v703.VRSteppedRotationEnabledSelector = v706
		v175.VRSteppedRotationEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSteppedRotationEnabledFrame

		local v707 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2
		local v708 = v175
		local v709 = v175
		local v710 = v175
		local v711, v712, v713 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v707)

		v708.VRThirdPersonFixedCamEnabledFrame = v711
		v709.VRThirdPersonFixedCamEnabledLabel = v712
		v710.VRThirdPersonFixedCamEnabledSelector = v713
		v175.VRThirdPersonFixedCamEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRThirdPersonFixedCamEnabledFrame

		local function v714(p121) -- line: 3933
			-- upvalues: v175 (copy)
			if p121 == Enum.VRComfortSetting.Custom then
				v175.VRVignetteEnabledSelector:SetZIndex(2)
				v175.VRVignetteEnabledLabel.ZIndex = 2
				v175.VRVignetteEnabledSelector:SetInteractable(true)
				v175.VRSteppedRotationEnabledSelector:SetZIndex(2)
				v175.VRSteppedRotationEnabledLabel.ZIndex = 2
				v175.VRSteppedRotationEnabledSelector:SetInteractable(true)
				v175.VRThirdPersonFixedCamEnabledSelector:SetZIndex(2)
				v175.VRThirdPersonFixedCamEnabledLabel.ZIndex = 2
				v175.VRThirdPersonFixedCamEnabledSelector:SetInteractable(true)

				return
			end

			v175.VRVignetteEnabledSelector:SetZIndex(1)
			v175.VRVignetteEnabledLabel.ZIndex = 1
			v175.VRVignetteEnabledSelector:SetInteractable(false)
			v175.VRSteppedRotationEnabledSelector:SetZIndex(1)
			v175.VRSteppedRotationEnabledLabel.ZIndex = 1
			v175.VRSteppedRotationEnabledSelector:SetInteractable(false)
			v175.VRThirdPersonFixedCamEnabledSelector:SetZIndex(1)
			v175.VRThirdPersonFixedCamEnabledLabel.ZIndex = 1
			v175.VRThirdPersonFixedCamEnabledSelector:SetInteractable(false)
		end

		v175.VRComfortSettingSelector.IndexChanged:connect(function(p122) -- line: 3957
			-- upvalues: EnumItems (copy), GameSettings (copy), v714 (copy)
			local v1046 = EnumItems[p122]

			GameSettings.VRComfortSetting = v1046
			v714(v1046)
		end)
		v714(GameSettings.VRComfortSetting)
		v175.VRVignetteEnabledSelector.IndexChanged:connect(function(p123) -- line: 3964
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VignetteEnabledCustomOption = p123 == 1
			end
		end)
		v175.VRSteppedRotationEnabledSelector.IndexChanged:connect(function(p124) -- line: 3970
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRSmoothRotationEnabledCustomOption = p124 == 2
			end
		end)
		v175.VRThirdPersonFixedCamEnabledSelector.IndexChanged:connect(function(p125) -- line: 3976
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRThirdPersonFollowCamEnabledCustomOption = p125 == 2
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function() -- line: 3982
			-- upvalues: EnumItems (copy), GameSettings (copy), v175 (copy)
			local v1050 = table.find(EnumItems, GameSettings.VRComfortSetting)

			if v1050 ~= v175.VRComfortSettingSelector:GetSelectedIndex() then
				v175.VRComfortSettingSelector:SetSelectionIndex(v1050)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function() -- line: 3989
			-- upvalues: GameSettings (copy), v175 (copy)
			local v1051 = not GameSettings.VignetteEnabled and 2 or 1

			if v1051 ~= v175.VRVignetteEnabledSelector:GetSelectedIndex() then
				v175.VRVignetteEnabledSelector:SetSelectionIndex(v1051)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function() -- line: 3996
			-- upvalues: GameSettings (copy), v175 (copy)
			local v1052 = not GameSettings.VRSmoothRotationEnabled and 1 or 2

			if v1052 ~= v175.VRSteppedRotationEnabledSelector:GetSelectedIndex() then
				v175.VRSteppedRotationEnabledSelector:SetSelectionIndex(v1052)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function() -- line: 4003
			-- upvalues: GameSettings (copy), v175 (copy)
			local v1053 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2

			if v1053 ~= v175.VRThirdPersonFixedCamEnabledSelector:GetSelectedIndex() then
				v175.VRThirdPersonFixedCamEnabledSelector:SetSelectionIndex(v1053)
			end
		end)
	end
	local function createVRSafetyBubbleModeOptions() -- line: 4011
		-- upvalues: u24 (ref), GameSettings (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
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

		local v720 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

		task.defer(function() -- line: 4027
			-- upvalues: v175 (copy), Utility (copy), u24 (ref), t36 (copy), v720 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), EnumItems (copy), GameSettings (copy)
			local v1054 = v175
			local v1055 = v175
			local v1056 = v175
			local v1057, v1058, v1059 = Utility:AddNewRow(v175, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle"), "DropDown", t36, v720, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription"))

			v1054.VRSafetyBubbleModeFrame = v1057
			v1055.VRSafetyBubbleModeLabel = v1058
			v1056.VRSafetyBubbleModeSelector = v1059
			v175.VRSafetyBubbleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSafetyBubbleModeFrame
			v175.VRSafetyBubbleModeSelector.IndexChanged:connect(function(p126) -- line: 4040
				-- upvalues: EnumItems (copy), GameSettings (copy)
				GameSettings.VRSafetyBubbleMode = EnumItems[p126]
			end)
			GameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function() -- line: 4045
				-- upvalues: EnumItems (copy), GameSettings (copy), v175 (copy)
				local v1150 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

				if v1150 ~= v175.VRSafetyBubbleModeSelector:GetSelectedIndex() then
					v175.VRSafetyBubbleModeSelector:SetSelectionIndex(v1150)
				end
			end)
		end)
	end

	v175.VoiceChatOptionsEnabled = false

	local connection4 = nil
	local connection5 = nil
	local u236 = nil

	if game:GetEngineFeature("VoiceChatSupported") and (GetFFlagEnableVrVoiceConnectDisconnect() or (not isInExperienceUIVREnabled or not isSpatial())) then
		spawn(function() -- line: 4059
			-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), default3 (copy), createVoiceChatSelector (copy), isVoiceFocused (copy), v175 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v120 (copy), v58 (copy), GetFFlagEnableUniveralVoiceToasts (copy), v59 (copy), v60 (copy), u229 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagVoiceChatUILogging (copy)
			if GetFFlagEnableVoiceUxUpdates() and ((not v53 and default3:EligibleForFaeUpsell() or default3:IsSeamlessVoice()) and default3:verifyUniverseAndPlaceCanUseVoice()) then
				createVoiceChatSelector()

				if isVoiceFocused() and v175.VoiceConnectDisconnectFrame then
					v175.VoiceConnectDisconnectFrame.Visible = false
				end

				observeIsVoiceFocused(function(p127) -- line: 4069
					-- upvalues: v175 (copy)
					if p127 then
						if v175.VoiceConnectDisconnectFrame then
							v175.VoiceConnectDisconnectFrame.Visible = false

							return
						end
					elseif v175.VoiceConnectDisconnectFrame then
						v175.VoiceConnectDisconnectFrame.Visible = true
					end
				end)
			end

			default3:asyncInit():andThen(function() -- line: 4082
				-- upvalues: default3 (copy), v175 (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v120 (copy), v58 (copy), GetFFlagEnableVoiceUxUpdates (copy), createVoiceChatSelector (copy), GetFFlagEnableUniveralVoiceToasts (copy), v59 (copy), v60 (copy), u229 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), observeIsVoiceFocused (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
				VoiceChatService = default3:getService()

				if default3:VoiceChatAvailable() then
					v175.VoiceChatOptionsEnabled = true
				end

				if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v175.VoiceChatVolumeFrame then
					local function updateVoiceChatVolumeVisibility() -- line: 4086
						-- upvalues: default3 (copy), v175 (copy), v120 (copy)
						local ok, result = pcall(function() -- line: 4087
							-- upvalues: default3 (copy), v175 (copy)
							local VoiceChatService2 = game:GetService("VoiceChatService")
							local v1202 = default3:getService()
							local v1203 = v1202 and v1202.VoiceChatState == Enum.VoiceChatState.Joined
							local v1204 = VoiceChatService2 and VoiceChatService2.UseNewAudioApi

							v175.VoiceChatVolumeFrame.Visible = v1203 and v1204
						end)

						if not ok then
							v120:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
						end
					end

					local ok, result = pcall(function() -- line: 4087
						-- upvalues: default3 (copy), v175 (copy)
						local VoiceChatService3 = game:GetService("VoiceChatService")
						local v1154 = default3:getService()
						local v1155 = v1154 and v1154.VoiceChatState == Enum.VoiceChatState.Joined
						local v1156 = VoiceChatService3 and VoiceChatService3.UseNewAudioApi

						v175.VoiceChatVolumeFrame.Visible = v1155 and v1156
					end)

					if not ok then
						v120:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
					end

					local v1064 = default3:getService()

					if v1064 then
						v1064.StateChanged:Connect(function() -- line: 4102
							-- upvalues: default3 (copy), v175 (copy), v120 (copy)
							local ok2, result2 = pcall(function() -- line: 4087
								-- upvalues: default3 (copy), v175 (copy)
								local VoiceChatService4 = game:GetService("VoiceChatService")
								local v1206 = default3:getService()
								local v1207 = v1206 and v1206.VoiceChatState == Enum.VoiceChatState.Joined
								local v1208 = VoiceChatService4 and VoiceChatService4.UseNewAudioApi

								v175.VoiceChatVolumeFrame.Visible = v1207 and v1208
							end)

							if not ok2 then
								v120:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result2)
							end
						end)
					end
				end

				if v58 and GetFFlagEnableVoiceUxUpdates() and default3:UserVoiceEnabled() and default3:verifyUniverseAndPlaceCanUseVoice() then
					createVoiceChatSelector()
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowNotAudiblePrompt()
				end

				if GetFFlagEnableVoiceUxUpdates() then
					if v59 and v60 then
						u229 = true
						v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
						task.defer(function() -- line: 4128
							-- upvalues: u229 (ref)
							u229 = false
						end)

						return
					end

					v175.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

					return
				end

				local u1065 = false

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
					createVoiceConnectDisconnect()

					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						u1065 = isVoiceFocused()
						observeIsVoiceFocused(function(p128) -- line: 4143
							-- upvalues: u1065 (ref), v175 (copy), default3 (copy)
							u1065 = p128

							if p128 then
								if v175.VoiceConnectFrame then
									v175.VoiceConnectFrame.Visible = false
								end

								if v175.VoiceDisconnectFrame then
									v175.VoiceDisconnectFrame.Visible = false

									return
								end
							elseif default3:ShouldShowJoinVoice() then
								if v175.VoiceConnectFrame then
									v175.VoiceConnectFrame.Visible = true
								end

								if v175.VoiceDisconnectFrame then
									v175.VoiceDisconnectFrame.Visible = false
								end
							end
						end)
					end
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceConnectFrame then
					v175.VoiceConnectFrame.Visible = false
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceDisconnectFrame then
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						v175.VoiceDisconnectFrame.Visible = not u1065
					else
						v175.VoiceDisconnectFrame.Visible = true
					end
				end

				default3.showVoiceUI.Event:Connect(function() -- line: 4176
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1065 (ref), v175 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1065 then
						return
					end

					v175.VoiceChatOptionsEnabled = true

					local v1160 = v175.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v175[t5.Input .. "DeviceFrame"] then
						v175[t5.Input .. "DeviceFrame"].Visible = v1160
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceConnectFrame then
						v175.VoiceConnectFrame.Visible = false
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceDisconnectFrame then
						v175.VoiceDisconnectFrame.Visible = true
					end
				end)
				default3.hideVoiceUI.Event:Connect(function() -- line: 4194
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1065 (ref), v175 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1065 then
						return
					end

					v175.VoiceChatOptionsEnabled = false

					local v1161 = v175.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v175[t5.Input .. "DeviceFrame"] then
						v175[t5.Input .. "DeviceFrame"].Visible = v1161
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceConnectFrame then
						v175.VoiceConnectFrame.Visible = true
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v175.VoiceDisconnectFrame then
						v175.VoiceDisconnectFrame.Visible = false
					end
				end)
			end):catch(function() -- line: 4214
				-- upvalues: GetFFlagVoiceChatUILogging (copy), v120 (copy), GetFFlagEnableUniveralVoiceToasts (copy), default3 (copy)
				if GetFFlagVoiceChatUILogging() then
					v120:warning("Failed to init VoiceChatServiceManager")
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowPermissionPrompt()
				end
			end)
		end)
	end

	if GetFFlagEnableCrossExpVoice() and (not isInExperienceUIVREnabled or not isSpatial()) then
		connection4 = default4.ExperienceJoined.Event:Connect(function() -- line: 4227
			-- upvalues: v175 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v721 = v175.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v175[t5.Input .. "DeviceFrame"] then
				v175[t5.Input .. "DeviceFrame"].Visible = v721
			end
		end)
		connection5 = default4.ExperienceLeft.Event:Connect(function() -- line: 4230
			-- upvalues: v175 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v722 = v175.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v175[t5.Input .. "DeviceFrame"] then
				v175[t5.Input .. "DeviceFrame"].Visible = v722
			end
		end)

		function u236() -- line: 4233
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

	v175.VideoOptionsEnabled = false

	local u237 = nil

	if GetFFlagSelfViewCameraSettings() and (not isInExperienceUIVREnabled or not isSpatial()) and isCamEnabledForUserAndPlace() then
		getCamMicPermissions(function(p129) -- line: 4255
			-- upvalues: v175 (copy)
			v175.VideoOptionsEnabled = p129.hasCameraPermissions
		end, { default.Permissions.CAMERA_ACCESS }, true)

		if u237 then
			u237:disconnect()
		end

		u237 = cameraDevicePermissionGrantedSignal:connect(function() -- line: 4271
			-- upvalues: v175 (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref)
			v175.VideoOptionsEnabled = true
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3530
					-- upvalues: v175 (copy), updateCameraDevices (copy)
					if v175.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end)
	end

	if not isInExperienceUIVREnabled then
		createCameraModeOptions(not v111 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))
	end

	if UserInputService.MouseEnabled then
		createMouseOptions()
	elseif UserInputService.GamepadEnabled then
		if GameSettings.IsUsingGamepadCameraSensitivity then
			createGamepadOptions()
		else
			local u238 = nil

			u238 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4293
				-- upvalues: GameSettings (copy), u238 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u238 then
						u238:disconnect()
					end

					createGamepadOptions()
				end
			end)
		end
	else
		local u239 = nil

		u239 = UserInputService.GamepadConnected:connect(function() -- line: 4311
			-- upvalues: u239 (ref), GameSettings (copy), createGamepadOptions (copy)
			if u239 then
				u239:disconnect()
			end

			if GameSettings.IsUsingGamepadCameraSensitivity then
				createGamepadOptions()

				return
			end

			local u725 = nil

			u725 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4293
				-- upvalues: GameSettings (copy), u725 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u725 then
						u725:disconnect()
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
			local u240 = nil

			u240 = GameSettings.Changed:connect(function(p130) -- line: 4325
				-- upvalues: GameSettings (copy), u240 (ref), createCameraInvertedOptions (copy)
				if p130 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
					u240:disconnect()
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
			createCameraModeOptions(not v111 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))

			if GameSettings.IsUsingCameraYInverted then
				createCameraInvertedOptions()
			else
				local u241 = nil

				u241 = GameSettings.Changed:connect(function(p131) -- line: 4354
					-- upvalues: GameSettings (copy), u241 (ref), createCameraInvertedOptions (copy)
					if p131 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
						u241:disconnect()
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

	if v71 then
		createPartyVoiceVolumeOptions()
	end

	createHapticsToggle()
	createGraphicsOptions()

	if v46 and GetFFlagEnablePlayerNamesEnabledSetting() then
		createPlayerNamesEnabledOptions()
	end

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		PlayerChoiceTranslationSettingInitializer(v175, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
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

	if v125 then
		createMicroProfilerOptions()
	end

	if v111 and getAppFeaturePolicies().getSupportsOverscan() then
		createOverscanOption()
	end

	if v46 and FFlagBadgeVisibilitySettingEnabled then
		spawn(function() -- line: 3126
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v143 (copy), v175 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n14 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n14 = 1
			end

			local v729 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v730 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v731 = if not v143 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v732 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v733 = v175
			local v734 = v175
			local v735 = v175
			local v736, v737, v738 = Utility:AddNewRow(v175, v731, "Selector", {
				v730,
				v729
			}, n14, nil, v732)

			v733.badgeVisibleRow = v736
			v734.badgeVisibleFrame = v737
			v735.badgeVisibleSelector = v738
			v175.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v175.badgeVisibleSelector.IndexChanged:connect(function(p132) -- line: 3140
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p132 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p132 == 1)
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
	GetHasGuiHidingPermission(RunService:IsStudio(), LocalPlayer, PlayerPermissionsModule):andThen(function(p133) -- line: 4428
		-- upvalues: createUiToggleOptions (copy)
		if p133 then
			createUiToggleOptions()
		end
	end):catch(function(p134) -- line: 4433
		warn(p134)
	end)
	u176 = true

	if VRService.VREnabled then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	if FFlagIEMSettingsGroups then
		v175.AudioHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.AudioHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioHeader,
			parent = v175.Page
		})
		v175.AudioDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioDivider,
			parent = v175.Page
		})
		v175.DisplayHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.DisplayHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayHeader,
			parent = v175.Page
		})
		v175.DisplayDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayDivider,
			parent = v175.Page
		})

		if not isSpatial() then
			v175.LanguageHeader = renderSettingsHeader({
				headerText = "CoreScripts.InGameMenu.GameSettings.LanguageHeader",
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageHeader,
				parent = v175.Page
			})
			v175.LanguageDivider = renderSettingsDivider({
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageDivider,
				parent = v175.Page
			})
		end

		v175.ViewAndControlsHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.ViewandControlsHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ViewAndControlsHeader,
			parent = v175.Page
		})
	end

	v175.TabHeader.Name = "GameSettingsTab"

	local v245 = Migration.uiblox["icons/common/settings"]

	v175.TabHeader.TabLabel.Icon.Text = v245.name
	v175.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v245.variant]
	v175.TabHeader.TabLabel.Title.Text = "Settings"
	v175.Page.ZIndex = 5

	if v175.PageListLayout then
		v175.PageListLayout.Padding = UDim.new(0, 0)
	end

	v175.PageOpen = false

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		v175.FeedbackEntryPointEnabled = true
	end

	local function staticFeedbackEntryPointChecksPassed() -- line: 4502
		-- upvalues: RunService (copy), v136 (copy), v111 (copy)
		if RunService:IsStudio() then
			return false
		end

		if game:GetEngineFeature("CaptureModeEnabled") == false then
			return false
		end

		if v136 and v111 then
			return false
		end

		return true
	end

	function v175.OpenSettingsPage() -- line: 4518
		-- upvalues: v175 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), updateAudioOptions (copy), SoundService (copy), connection (ref), GameSettings (copy), GetFFlagSelfViewCameraSettings (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref), updateUiToggleSelection (copy), ExperienceStateCaptureService (ref), v83 (copy), Theme (copy), v82 (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy)
		v175.PageOpen = true

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if GetFFlagLazyInitiateExperienceLanguageSwitcher() and not v175.LanguageSwitcherInitialized and isLangaugeSelectionDropdownEnabled() and GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
			v175.LanguageSwitcherInitialized = true
			ExperienceLanguageSwitcherInitializer(v175, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		updateAudioOptions()

		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3520
				-- upvalues: v175 (copy), updateAudioOptions (copy)
				if v175.PageOpen then
					updateAudioOptions()
				end
			end)
		end

		v175.startVolume = GameSettings.MasterVolume

		if GetFFlagSelfViewCameraSettings() and v175.VideoOptionsEnabled and game:GetEngineFeature("VideoCaptureService") then
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3530
					-- upvalues: v175 (copy), updateCameraDevices (copy)
					if v175.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end

		updateUiToggleSelection()

		if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and v175.toggleFeedbackModeButton and v175.toggleFeedbackModeText then
			v175.FeedbackEntryPointEnabled = ExperienceStateCaptureService ~= nil and ExperienceStateCaptureService:CanEnterCaptureMode()

			if v175.FeedbackEntryPointEnabled then
				v175.toggleFeedbackModeButton.Active = true
				v175.toggleFeedbackModeButton.Enabled.Value = true
				v175.toggleFeedbackModeText.Text = v83
			else
				v175.toggleFeedbackModeButton.Active = false
				v175.toggleFeedbackModeButton.Enabled.Value = false
				v175.toggleFeedbackModeText.TextColor3 = Theme.color("ButtonNonInteractable", Color3.fromRGB(100, 100, 100))
				v175.toggleFeedbackModeText.Text = v82
			end
		end

		if FFlagIEMFocusNavToButtons then
			table.insert(v175.LastSelectableObjects, getLastValueChangerFrame(v175))
		end

		if FFlagIEMTabFocusNav then
			table.insert(v175.FirstSelectableObjects, getFirstValueChangerFrame(v175))
			v175.FirstSelectableObjectsUpdated:fire()
		end
	end
	function v175.CloseSettingsPage() -- line: 4585
		-- upvalues: v175 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), SoundService (copy), connection (ref), GetFFlagEnableCrossExpVoice (copy), u236 (ref), GetFFlagSelfViewCameraSettings (copy), VideoCaptureService (copy), connection2 (ref), u237 (ref), default3 (copy)
		v175.PageOpen = false

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end

		if GetFFlagEnableCrossExpVoice() and u236 then
			u236()
		end

		if GetFFlagSelfViewCameraSettings() then
			if game:GetEngineFeature("VideoCaptureService") and VideoCaptureService.DevicesChanged and connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u237 then
				u237:disconnect()
				u237 = nil
			end
		end

		if game:GetEngineFeature("VoiceChatSupported") and v175.VoiceChatOptionsEnabled and v175.startVolume ~= nil and v175.startVolume > 0 then
			default3:CheckAndShowNotAudiblePrompt()
		end
	end
	function isLangaugeSelectionDropdownEnabled() -- line: 4618
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
	function v175.SetHub(__, p136) -- line: 4641
		-- upvalues: v175 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), createTranslationOptions (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), getChatTranslationLayerData (copy), EngineFeature (copy), GetFFlagChatTranslationNewDefaults (copy), GameSettings (copy), TextChatService (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy), RunService (copy), v136 (copy), v111 (copy), createFeedbackModeOptions (copy)
		v175.HubRef = p136

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if isLangaugeSelectionDropdownEnabled() then
			if GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
				if not GetFFlagLazyInitiateExperienceLanguageSwitcher() then
					ExperienceLanguageSwitcherInitializer(v175, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
				end
			else
				createTranslationOptions()
			end
		end

		if game:GetEngineFeature("EnableTCSChatTranslation") and GetFFlagChatTranslationSettingEnabled() then
			if GetFFlagChatTranslationHoldoutEnabled() then
				local v744 = GetFStringChatTranslationLayerName()

				if not getChatTranslationLayerData(v744).ChatTranslationEnabled then
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
						pcall(function() -- line: 4679
							-- upvalues: TextChatService (copy)
							TextChatService.ChatTranslationEnabled = false
						end)
					end
				elseif GetFFlagChatTranslationForceSetting() then
					GameSettings.ChatTranslationEnabled = true
				end
			end

			ChatTranslationOptionsWithChatLanguageSwitcherInitializer(v175, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		if not RunService:IsStudio() and (game:GetEngineFeature("CaptureModeEnabled") ~= false and (not v136 or not v111)) then
			createFeedbackModeOptions()
		end
	end

	return v175
end

return (Initialize())
