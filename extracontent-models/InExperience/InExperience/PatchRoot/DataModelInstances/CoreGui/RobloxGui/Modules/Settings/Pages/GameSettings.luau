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
local FFlagVoiceRewarmTelemetry = SharedFlags.FFlagVoiceRewarmTelemetry
local v65 = game:DefineFastFlag("DebounceVoiceSelectorIndexChange", false)
local v66 = game:DefineFastFlag("VoiceSelectorIgnoreFailedStateDisconnect", false)
local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)
local v68 = game:DefineFastFlag("VoiceVolumeControlsFixSliderVisibilityOnEligibleGames", false)
local v69 = game:DefineFastFlag("VoiceVolumeControlsDisableInteractionWhenNoMasterVolume", false)
local v70 = require(CorePackages.Workspace.Packages.VoiceChatCore).Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()
local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(RobloxGui.Modules.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local default2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local GameSettingsConstants = require(RobloxGui.Modules.Settings.Resources.GameSettingsConstants)
local v76 = default2 and default2.getHasPartyVoiceVolume()
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

local function voiceChatVolumeToSlider(n1: number) -- line: 140
	return (math.floor(n1 * 5 + 0.5))
end
local function voiceChatVolumeFromSlider(n2: number) -- line: 144
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
local v86 = RobloxTranslator:FormatByKey("Feature.SettingsHub.TouchMovementMode.ClassicThumbstick")
local v87 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")
local v88 = RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.ButtonText")
local t7 = {
	On = 1,
	Off = 2
}

local function getDefaultCameraMode() -- line: 187
	-- upvalues: UserInputService (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Default (Follow)"
	end

	return "Default (Classic)"
end
local function getDefaultMovementMode() -- line: 196
	-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy)
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
	end

	return "Default (Keyboard)"
end
local function getDefaultSelectToMove() -- line: 205
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

local v116 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local LocalPlayer = Players.LocalPlayer
local Platform = UserInputService:GetPlatform()
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local default3 = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local VoiceVolumeControlsEligibility = require(CorePackages.Workspace.Packages.VoiceChatCore).VoiceVolumeControlsEligibility
local default4 = require(CorePackages.Workspace.Packages.CrossExperienceVoice).CrossExperienceVoiceManager.default
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v124 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.SystemDefault")
local v125 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.VideoCamera")
local v126 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

game:DefineFastInt("RomarkStartWithGraphicQualityLevel", -1)

local FastInt = game:GetFastInt("RomarkStartWithGraphicQualityLevel")
local v128 = not CachedPolicyService:IsSubjectToChinaPolicies()
local v129 = Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.UWP)
local v130 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local v131 = if not isInExperienceUIVREnabled then (v130 or v129) and v128 else (v130 or (v129 or isSpatial())) and v128
local GetFIntVoiceChatDeviceChangeDebounceDelay = require(RobloxGui.Modules.Flags.GetFIntVoiceChatDeviceChangeDebounceDelay)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)
local GetFFlagEnableExplicitSettingsChangeAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableExplicitSettingsChangeAnalytics)
local GetFFlagFixCyclicFullscreenIndexEvent = require(RobloxGui.Modules.Settings.Flags.GetFFlagFixCyclicFullscreenIndexEvent)
local v138 = game:DefineFastFlag("DisableFeedbackSoothsayerCheck", false)
local v139 = game:DefineFastFlag("UserShowGuiHideToggles", false)
local v140 = game:DefineFastFlag("UserFreecamGuiDestabilization", false)
local v141 = game:DefineFastFlag("FixDeveloperConsoleButtonSizeAndPositioning", false)
local v142 = game:DefineFastFlag("EnableTFFeedbackModeEntryCheck", false)
local v143 = game:DefineFastFlag("FeedbackEntryPointButtonSizeAdjustment2", false)
local v144 = game:DefineFastFlag("FeedbackEntryPointImprovedStrictnessCheck", false)
local GetFFlagEnableLocalesForExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLocalesForExperienceLanguageSwitcher)
local GetFFlagLazyInitiateExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagLazyInitiateExperienceLanguageSwitcher)
local ExperienceLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ExperienceLanguageSwitcherInitializer)
local PlayerChoiceTranslationSettingInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.PlayerChoiceTranslationSettingInitializer)
local v149 = game:DefineFastFlag("UpdateVisibilitySettingsCopy", false)
local v150 = game:DefineFastFlag("ExpChatDebounceRephraseIndexSelection", false)
local v151 = game:DefineFastFlag("EraseFPSFromDefaultSetting", false)

local function reportSettingsChangeForAnalytics(p1, p2, p3, p4) -- line: 332
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
local function reportSettingsForAnalytics() -- line: 363
	-- upvalues: UserInputService (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), EngineFeature2 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), RbxAnalyticsService (copy), Constants (copy)
	local t9 = {}
	local v166 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

	if v166 then
		t9.camera_mode_touch = tostring(GameSettings.TouchCameraMovementMode)
	else
		t9.camera_mode_desktop = tostring(GameSettings.ComputerCameraMovementMode)
	end

	if v166 then
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

local v154 = game:DefineFastFlag("IGMEnableGFXReset", false)

local function getLastValueChangerFrame(p5) -- line: 432
	-- upvalues: FFlagIEMFocusNavToButtons (copy)
	if not FFlagIEMFocusNavToButtons then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v171 = nil

	for __, v in pairs(p5:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder <= SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v171 = p5:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v171
end
local function getFirstValueChangerFrame(p6) -- line: 451
	-- upvalues: FFlagIEMTabFocusNav (copy)
	if not FFlagIEMTabFocusNav then
		return
	end

	local SelectionFrameLayoutOrder = nil
	local v177 = nil

	for __, v in pairs(p6:GetRows()) do
		local SelectionFrame = v.SelectionFrame

		if not SelectionFrameLayoutOrder or SelectionFrameLayoutOrder > SelectionFrame.LayoutOrder then
			SelectionFrameLayoutOrder = SelectionFrame.LayoutOrder
			v177 = p6:getValueChangerFrame(v.ValueChanger)
		end
	end

	return v177
end
local function Initialize() -- line: 470
	-- upvalues: v154 (copy), GfxReset (copy), RobloxGui (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), VRService (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), v151 (copy), RobloxTranslator (copy), FastInt (copy), t1 (copy), v149 (copy), FFlagUpdatePeopleNamesSettingCopy (copy), t7 (copy), UserInputService (copy), Create (copy), Theme (copy), v54 (copy), v56 (copy), TouchEnabled (copy), v130 (copy), v129 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), LocalPlayer (copy), CoreUtility (copy), t4 (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), t6 (copy), v86 (copy), t3 (copy), t2 (copy), Url (copy), HttpService (copy), v144 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), v143 (copy), v88 (copy), v138 (copy), v126 (copy), Players (copy), v87 (copy), RunService (copy), GetFFlagChatTranslationWaitForIXP (copy), IXPServiceWrapper (copy), GetFFlagChatTranslationNewDefaults (copy), FFlagRenameVolumeToMainVolume (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), u24 (ref), v69 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), CorePackages (copy), ContextActionService (copy), v141 (copy), PlayerPermissionsModule (copy), v140 (copy), v139 (copy), SoundService (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), GetFFlagEnableCrossExpVoice (copy), Signals (copy), GetFIntDebounceAIRephraseSettingDelay (copy), TextChatService (copy), v150 (copy), ThrottleFunctionCall (copy), GetFIntDebounceChatSummariesSettingDelay (copy), v125 (copy), UserGameSettings (copy), GetFFlagVoiceChatUILogging (copy), VideoCaptureService (copy), v124 (copy), v59 (copy), v58 (copy), v52 (copy), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v66 (copy), v55 (copy), v65 (copy), v60 (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), GetFFlagEnableVrVoiceConnectDisconnect (copy), GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v68 (copy), VoiceVolumeControlsEligibility (copy), GetFFlagEnableUniveralVoiceToasts (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), t5 (copy), GetFFlagSelfViewCameraSettings (copy), isCamEnabledForUserAndPlace (copy), getCamMicPermissions (copy), default (copy), cameraDevicePermissionGrantedSignal (copy), v116 (copy), v70 (copy), v76 (copy), v46 (copy), GetFFlagEnablePlayerNamesEnabledSetting (copy), PlayerChoiceTranslationSettingInitializer (copy), CachedPolicyService (copy), v131 (copy), FFlagBadgeVisibilitySettingEnabled (copy), FFlagEnableModerateChatRemoteEvent (copy), FFlagAIRephraseSettingEnabled (copy), FFlagChatSummariesSettingEnabled (copy), GetHasGuiHidingPermission (copy), FFlagIEMSettingsGroups (copy), renderSettingsHeader (ref), renderSettingsDivider (ref), Migration (copy), BuilderIcons (copy), v142 (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), EngineFeature (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy)
	if v154 then
		GfxReset.RunGfxReset()
	end

	local v181 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	if GetFFlagLazyInitiateExperienceLanguageSwitcher() then
		v181.LanguageSwitcherInitialized = false
	end

	local u182 = false
	local t10 = {}

	local function onVRSettingsReady() -- line: 483
		-- upvalues: VRService (copy), t10 (copy)
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end
	local function onVREnabled() -- line: 490
		-- upvalues: VRService (copy), u182 (ref), t10 (copy)
		if VRService.VREnabled and u182 then
			local VREnabled = VRService.VREnabled

			for k, __ in pairs(t10) do
				k.Visible = not VREnabled
			end
		end
	end

	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)

	if VRService.VREnabled and u182 then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	local function createGraphicsOptions() -- line: 502
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RbxAnalyticsService (copy), Constants (copy), EngineFeature2 (copy), VRService (copy), v151 (copy), RobloxTranslator (copy), v154 (copy), GfxReset (copy), FastInt (copy), t1 (copy)
		local n3 = 1

		if not GameSettings:InFullScreen() then
			n3 = 2
		end

		local v261 = v181
		local v262 = v181
		local v263 = v181
		local v264, v265, v266 = Utility:AddNewRow(v181, "Fullscreen", "Selector", {
			"On",
			"Off"
		}, n3)

		v261.FullscreenFrame = v264
		v262.FullscreenLabel = v265
		v263.FullscreenEnabler = v266
		v181.FullscreenFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FullScreenFrame
		t10[v181.FullscreenFrame] = true
		v181.FullscreenEnabler.IndexChanged:connect(function(p7) -- line: 515
			-- upvalues: GameSettings (copy), GuiService (copy), GetFFlagFixCyclicFullscreenIndexEvent (copy), v181 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v754 = GameSettings:InFullScreen()

			if p7 == 1 then
				if not GameSettings:InFullScreen() then
					GuiService:ToggleFullscreen()

					if GetFFlagFixCyclicFullscreenIndexEvent() then
						if v181.FullscreenEnabler.GetSelectedIndex() ~= 1 then
							v181.FullscreenEnabler:SetSelectionIndex(1)
						end
					else
						v181.FullscreenEnabler:SetSelectionIndex(1)
					end
				end
			elseif p7 == 2 and GameSettings:InFullScreen() then
				GuiService:ToggleFullscreen()

				if GetFFlagFixCyclicFullscreenIndexEvent() then
					if v181.FullscreenEnabler.GetSelectedIndex() ~= 2 then
						v181.FullscreenEnabler:SetSelectionIndex(2)
					end
				else
					v181.FullscreenEnabler:SetSelectionIndex(2)
				end
			end

			spawn(function() -- line: 540
				-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), v754 (copy), GameSettings (copy), reportSettingsForAnalytics (copy)
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("fullscreen_enabled", v754, GameSettings:InFullScreen())
				end

				reportSettingsForAnalytics()
			end)
		end)
		GameSettings.FullscreenChanged:connect(function(p8) -- line: 548
			-- upvalues: v181 (copy), RbxAnalyticsService (copy), Constants (copy)
			if p8 then
				if v181.FullscreenEnabler:GetSelectedIndex() ~= 1 then
					v181.FullscreenEnabler:SetSelectionIndex(1)
				end
			elseif v181.FullscreenEnabler:GetSelectedIndex() ~= 2 then
				v181.FullscreenEnabler:SetSelectionIndex(2)
			end

			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsFullscreenModeName, {
				enabled = p8
			})
		end)

		local n4 = 1

		if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
			n4 = 2
		end

		local v268 = v181
		local v269 = v181
		local v270 = v181
		local v271, v272, v273 = Utility:AddNewRow(v181, "Graphics Mode", "Selector", {
			"Automatic",
			"Manual"
		}, n4)

		v268.GraphicsEnablerFrame = v271
		v269.GraphicsEnablerLabel = v272
		v270.GraphicsQualityEnabler = v273
		v181.GraphicsEnablerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsEnablerFrame

		local v274 = v181
		local v275 = v181
		local v276 = v181
		local v277, v278, v279 = Utility:AddNewRow(v181, "Graphics Quality", "Slider", 10, 1)

		v274.GraphicsQualityFrame = v277
		v275.GraphicsQualityLabel = v278
		v276.GraphicsQualitySlider = v279
		v181.GraphicsQualityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsQualityFrame
		v181.GraphicsQualitySlider:SetMinStep(1)

		if EngineFeature2 and not VRService.VREnabled then
			local v280 = table.clone(Constants.FramerateCaps)
			local t11 = { if not v151 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateCapDefaultEntry", {
				Frames = GameSettings:GetDefaultFramerateCap()
			}) else RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.Default") }

			for __, v283 in v280 do
				table.insert(t11, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateEntry", {
					Frames = v283
				}))
			end

			table.insert(v280, 1, -1)
			task.defer(function() -- line: 614
				-- upvalues: v181 (copy), Utility (copy), RobloxTranslator (copy), t11 (copy), v280 (copy), GameSettings (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
				local v756 = v181
				local v757 = v181
				local v758 = v181
				local v759, v760, v761 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate"), "DropDown", t11, table.find(v280, GameSettings.FramerateCap), nil, RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate.Description"))

				v756.FramerateCapFrame = v759
				v757.FramerateCapLabel = v760
				v758.FramerateCapMode = v761
				v181.FramerateCapFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FramerateCap
				v181.FramerateCapMode.IndexChanged:Connect(function(p9) -- line: 626
					-- upvalues: GameSettings (copy), v280 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
					local FramerateCap = GameSettings.FramerateCap

					GameSettings.FramerateCap = v280[p9]

					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						reportSettingsChangeForAnalytics("framerate_cap", FramerateCap, GameSettings.FramerateCap)
					end

					reportSettingsForAnalytics()
				end)
			end)
		end

		settings().Rendering.EnableFRM = true

		function SetGraphicsQuality(p10, p11) -- line: 644
			-- upvalues: v154 (copy), GfxReset (copy), GameSettings (copy)
			if v154 then
				local v764, v765 = GfxReset.TemporaryOverride(p10)

				if v764 then
					settings().Rendering.QualityLevel = v765

					return
				end
			end

			local v766 = p10 / 10
			local v767 = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * v766)

			if v767 == 20 then
				v767 = 21
			elseif p10 == 1 then
				v767 = 1
			elseif p10 < 1 and not p11 then
				p10 = 1
				v767 = 1
			elseif v767 > settings().Rendering:GetMaxQualityLevel() then
				v767 = settings().Rendering:GetMaxQualityLevel() - 1
			end

			GameSettings.SavedQualityLevel = p10
			settings().Rendering.QualityLevel = v767
		end

		local function setGraphicsToAuto() -- line: 670
			-- upvalues: v181 (copy)
			v181.GraphicsQualitySlider:SetZIndex(1)
			v181.GraphicsQualityLabel.ZIndex = 1
			v181.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		end
		local function setGraphicsToManual(p12) -- line: 678
			-- upvalues: v181 (copy)
			v181.GraphicsQualitySlider:SetZIndex(2)
			v181.GraphicsQualityLabel.ZIndex = 2
			v181.GraphicsQualitySlider:SetInteractable(true)

			if p12 == v181.GraphicsQualitySlider:GetValue() then
				SetGraphicsQuality(p12)

				return
			end

			v181.GraphicsQualitySlider:SetValue(p12)
		end

		local u286 = false

		v181.GraphicsQualitySlider.ValueChanged:connect(function(p13) -- line: 692
			-- upvalues: u286 (ref), reportSettingsForAnalytics (copy)
			SetGraphicsQuality(p13)

			if u286 == true then
				reportSettingsForAnalytics()
			end

			u286 = true
		end)
		v181.GraphicsQualityEnabler.IndexChanged:connect(function(p14) -- line: 700
			-- upvalues: v181 (copy), setGraphicsToManual (copy), reportSettingsForAnalytics (copy), reportSettingsChangeForAnalytics (copy)
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
				v181.GraphicsQualitySlider:SetZIndex(1)
				v181.GraphicsQualityLabel.ZIndex = 1
				v181.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			elseif p14 == t12.Manual.Value then
				setGraphicsToManual(v181.GraphicsQualitySlider:GetValue())
			end

			reportSettingsForAnalytics()
			reportSettingsChangeForAnalytics("gfx_mode", AutomaticName, ManualName)
		end)
		game.GraphicsQualityChangeRequest:Connect(function(p15) -- line: 718
			-- upvalues: GameSettings (copy), v181 (copy)
			if GameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
				local Value = v181.GraphicsQualitySlider:GetValue()
				local v776 = if not p15 then Value - 1 else Value + 1

				v181.GraphicsQualitySlider:SetValue(v776)
			end
		end)

		if FastInt >= 0 then
			if FastInt == 0 then
				v181.GraphicsQualityEnabler:SetSelectionIndex(1)
				v181.GraphicsQualitySlider:SetZIndex(1)
				v181.GraphicsQualityLabel.ZIndex = 1
				v181.GraphicsQualitySlider:SetInteractable(false)
				SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
			else
				v181.GraphicsQualityEnabler:SetSelectionIndex(2)
				setGraphicsToManual(FastInt)
			end
		elseif GameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			v181.GraphicsQualitySlider:SetValue(5)
			v181.GraphicsQualitySlider:SetZIndex(1)
			v181.GraphicsQualityLabel.ZIndex = 1
			v181.GraphicsQualitySlider:SetInteractable(false)
			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		else
			local str = tostring(GameSettings.SavedQualityLevel)
			local u288 = not t1[str] and 10 or t1[str]

			SetGraphicsQuality(u288)
			spawn(function() -- line: 751
				-- upvalues: v181 (copy), u288 (ref)
				v181.GraphicsQualitySlider:SetValue(u288)
			end)
		end
	end
	local function createReducedMotionOptions() -- line: 757
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n5 = 2

		if GameSettings.ReducedMotion then
			n5 = 1
		end

		local v290 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.ReducedMotion")
		local v291 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.ReducedMotion")
		local v292 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v293 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v294 = v181
		local v295 = v181
		local v296 = v181
		local v297, v298, v299 = Utility:AddNewRow(v181, v290, "Selector", {
			v292,
			v293
		}, n5, nil, v291)

		v294.ReducedMotionFrame = v297
		v295.ReducedMotionLabel = v298
		v296.ReducedMotionMode = v299
		v181.ReducedMotionFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ReducedMotionFrame
		v181.ReducedMotionMode.IndexChanged:connect(function(p16) -- line: 779
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local ReducedMotion = GameSettings.ReducedMotion

			GameSettings.ReducedMotion = p16 == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("reduced_motion", ReducedMotion, GameSettings.ReducedMotion)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPlayerNamesEnabledOptions() -- line: 790
		-- upvalues: v149 (copy), RobloxTranslator (copy), FFlagUpdatePeopleNamesSettingCopy (copy), GameSettings (copy), t7 (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v300 = if not v149 then if not FFlagUpdatePeopleNamesSettingCopy then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PlayerNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeoplesNames")
		local v301 = if not FFlagUpdatePeopleNamesSettingCopy then nil else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames.Description")

		local function GetPlayerNamesEnabledStartIndex() -- line: 798
			-- upvalues: GameSettings (copy)
			if GameSettings.PlayerNamesEnabled then
				return 1
			end

			return 2
		end

		local v303 = if not GameSettings.PlayerNamesEnabled then t7.Off else t7.On
		local v304 = if not v149 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
		local v305 = if not v149 then RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off") else RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
		local v306 = v181
		local v307 = v181
		local v308 = v181
		local v309, v310, v311 = Utility:AddNewRow(v181, v300, "Selector", {
			v304,
			v305
		}, v303, nil, v301)

		v306.PlayerNamesEnabledFrame = v309
		v307.playerNamesEnabledLabel = v310
		v308.playerNamesEnabledMode = v311
		v181.PlayerNamesEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PlayerNamesEnabledFrame
		v181.playerNamesEnabledMode.IndexChanged:connect(function(p17) -- line: 817
			-- upvalues: GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PlayerNamesEnabled = GameSettings.PlayerNamesEnabled

			GameSettings.PlayerNamesEnabled = p17 == 1
			reportSettingsChangeForAnalytics("player_names_enabled", PlayerNamesEnabled, GameSettings.PlayerNamesEnabled)
			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTransparencyOptions() -- line: 826
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v312 = 10 - math.clamp(math.floor(GameSettings.PreferredTransparency * 10 + 0.5), 0, 10)
		local v313 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTransparency")
		local v314 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTransparency")
		local v315 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Transparent")
		local v316 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Opaque")
		local v317 = v181
		local v318 = v181
		local v319 = v181
		local v320, v321, v322 = Utility:AddNewRow(v181, v313, "Slider", 10, v312, nil, v314, v315, v316)

		v317.PreferredTransparencyFrame = v320
		v318.PreferredTransparencyLabel = v321
		v319.PreferredTransparencySlider = v322
		v181.PreferredTransparencyFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTransparencyFrame
		v181.PreferredTransparencySlider.ValueChanged:connect(function(p18) -- line: 852
			-- upvalues: GameSettings (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v782 = (10 - math.clamp(math.floor(p18), 0, 10)) / 10
			local PreferredTransparency = GameSettings.PreferredTransparency

			GameSettings.PreferredTransparency = v782

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_transparency", PreferredTransparency, GameSettings.PreferredTransparency)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPreferredTextSizeOptions() -- line: 864
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local EnumItems = Enum.PreferredTextSize:GetEnumItems()
		local v324 = GameSettings.PreferredTextSize.Value - 1
		local v325 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTextSize")
		local v326 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTextSize")
		local v327 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Default")
		local v328 = RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Largest")
		local v329 = v181
		local v330 = v181
		local v331 = v181
		local v332, v333, v334 = Utility:AddNewRow(v181, v325, "Slider", 3, v324, nil, v326, v327, v328)

		v329.PreferredTextSizeFrame = v332
		v330.PreferredTextSizeLabel = v333
		v331.PreferredTextSizeSlider = v334
		v181.PreferredTextSizeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTextSizeFrame
		v181.PreferredTextSizeSlider.ValueChanged:connect(function(p19) -- line: 889
			-- upvalues: GameSettings (copy), EnumItems (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local PreferredTextSize = GameSettings.PreferredTextSize

			GameSettings.PreferredTextSize = EnumItems[p19 + 1]

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("preferred_text_size", PreferredTextSize, GameSettings.PreferredTextSize)
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createUiNavigationKeyBindOptions() -- line: 899
		-- upvalues: GameSettings (copy), RobloxTranslator (copy), UserInputService (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local t13 = {
			On = 1,
			Off = 2
		}
		local Off = t13.Off

		if GameSettings.UiNavigationKeyBindEnabled then
			Off = t13.On
		end

		local v337 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.UiNavigationKeyBind")
		local v338 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.UiNavigationKeyBind", {
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})
		local v339 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v340 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v341 = v181
		local v342 = v181
		local v343 = v181
		local v344, v345, v346 = Utility:AddNewRow(v181, v337, "Selector", {
			v339,
			v340
		}, Off, nil, v338)

		v341.UiNavigationKeyBindEnabledFrame = v344
		v342.UiNavigationKeyBindEnabledLabel = v345
		v343.UiNavigationKeyBindEnabledMode = v346
		v181.UiNavigationKeyBindEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame
		v181.UiNavigationKeyBindEnabledMode.IndexChanged:connect(function(p20) -- line: 930
			-- upvalues: GameSettings (copy), t13 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local UiNavigationKeyBindEnabled = GameSettings.UiNavigationKeyBindEnabled

			GameSettings.UiNavigationKeyBindEnabled = p20 == t13.On

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("ui_navigation_key_bind_enabled", UiNavigationKeyBindEnabled, GameSettings.UiNavigationKeyBindEnabled)
			end

			reportSettingsForAnalytics()
		end)

		local function updateUiNavigationKeyBindVisibility() -- line: 943
			-- upvalues: UserInputService (copy), v181 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled = UserInputService.KeyboardEnabled

			if v181.UiNavigationKeyBindEnabledFrame then
				v181.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

				if KeyboardEnabled then
					v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		local KeyboardEnabled = UserInputService.KeyboardEnabled

		if v181.UiNavigationKeyBindEnabledFrame then
			v181.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled

			if KeyboardEnabled then
				v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)
			else
				v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 958
			-- upvalues: UserInputService (copy), v181 (copy), GameSettings (copy), t13 (copy)
			local KeyboardEnabled2 = UserInputService.KeyboardEnabled

			if v181.UiNavigationKeyBindEnabledFrame then
				v181.UiNavigationKeyBindEnabledFrame.Visible = KeyboardEnabled2

				if KeyboardEnabled2 then
					v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(GameSettings.UiNavigationKeyBindEnabled and t13.On or t13.Off)

					return
				end

				v181.UiNavigationKeyBindEnabledMode:SetSelectionIndex(t13.Off)
				GameSettings.UiNavigationKeyBindEnabled = false
			end
		end)
	end
	local function createPerformanceStatsOptions() -- line: 963
		-- upvalues: v181 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v349 = v181
		local v350 = v181
		local v351 = v181
		local v352 = v181

		v349.PerformanceStatsFrame = nil
		v350.PerformanceStatsLabel = nil
		v351.PerformanceStatsMode = nil
		v352.PerformanceStatsOverrideText = nil

		function GetDesiredPerformanceStatsIndex() -- line: 969
			-- upvalues: GameSettings (copy)
			if GameSettings.PerformanceStatsVisible then
				return 1
			end

			return 2
		end

		local v353 = GetDesiredPerformanceStatsIndex()
		local v354 = v181
		local v355 = v181
		local v356 = v181
		local v357, v358, v359 = Utility:AddNewRow(v181, "Performance Stats", "Selector", {
			"On",
			"Off"
		}, v353)

		v354.PerformanceStatsFrame = v357
		v355.PerformanceStatsLabel = v358
		v356.PerformanceStatsMode = v359
		v181.PerformanceStatsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PerformanceStatsFrame
		v181.PerformanceStatsOverrideText = Create("TextLabel")({
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
			Parent = v181.PerformanceStatsFrame
		})
		v181.PerformanceStatsMode.IndexChanged:connect(function(p21) -- line: 998
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
		GameSettings.PerformanceStatsVisibleChanged:connect(function() -- line: 1020
			-- upvalues: v181 (copy)
			local v792 = GetDesiredPerformanceStatsIndex()

			if v792 ~= v181.PerformanceStatsMode.CurrentIndex then
				v181.PerformanceStatsMode:SetSelectionIndex(v792)
			end
		end)
	end
	local function createWebServerInformationRow() -- line: 1030
		-- upvalues: v181 (copy), Utility (copy), v56 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), TouchEnabled (copy), Create (copy), Theme (copy)
		local v360 = v181
		local v361 = v181
		local v362 = v181
		local v363, v364, v365 = Utility:AddNewRow(v181, "MicroProfiler Information", "TextBox", nil, nil, 5, nil, nil, nil, not v56 and nil)

		v360.InformationFrame = v363
		v361.InformationLabel = v364
		v362.InformationTextBox = v365
		v181.InformationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.InformationFrame
		v181.InformationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		if TouchEnabled then
			v181.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size18),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				Parent = v181.InformationFrame
			})
		else
			v181.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				BackgroundTransparency = 1,
				Visible = true,
				ZIndex = 2,
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size14),
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(1, -650, 0, 20),
				Parent = v181.InformationFrame
			})
		end

		return v181.InformationFrame, v181.InformationText
	end
	local function createMicroProfilerOptions() -- line: 1070
		-- upvalues: v181 (copy), GameSettings (copy), createWebServerInformationRow (copy), v130 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v129 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v366 = v181
		local v367 = v181
		local v368 = v181
		local v369 = v181

		v366.MicroProfilerFrame = nil
		v367.MicroProfilerLabel = nil
		v368.MicroProfilerMode = nil
		v369.MicroProfilerOverrideText = nil

		local function tryContentLabel() -- line: 1075
			-- upvalues: GameSettings (copy), v181 (copy), createWebServerInformationRow (copy)
			local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

			if MicroProfilerWebServerPort ~= 0 then
				local v794 = v181
				local v795 = v181
				local v796, v797 = createWebServerInformationRow()

				v794.InformationFrame = v796
				v795.InformationText = v797
				v181.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort

				return true
			end

			return false
		end
		local function setMicroProfilerIndex(p22) -- line: 1087
			-- upvalues: GameSettings (copy), v181 (copy), v130 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), createWebServerInformationRow (copy), v129 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), RbxAnalyticsService (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local function hideContentLabel() -- line: 1088
				-- upvalues: GameSettings (copy), v181 (copy)
				GameSettings.MicroProfilerWebServerEnabled = false

				if v181.InformationFrame or v181.InformationText then
					v181.InformationFrame.Visible = false
					v181.InformationFrame.Parent = nil
					v181.InformationText.Parent = nil
					v181.InformationFrame = nil
					v181.InformationText = nil
				end
			end

			local s1 = nil
			local MicroProfilerWebServerEnabled = nil
			local MicroProfilerWebServerEnabled2 = nil

			if v130 then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					s1 = "webserver"
					MicroProfilerWebServerEnabled = GameSettings.MicroProfilerWebServerEnabled
				end

				if p22 == 1 then
					GameSettings.MicroProfilerWebServerEnabled = true

					local n6 = 30

					while n6 >= 1 do
						local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort
						local v809

						if MicroProfilerWebServerPort ~= 0 then
							local v805 = v181
							local v806 = v181
							local v807, v808 = createWebServerInformationRow()

							v805.InformationFrame = v807
							v806.InformationText = v808
							v181.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
							v809 = true
						else
							v809 = false
						end

						if v809 then
							break
						end

						n6 -= 1
						wait(0.1)
					end

					if n6 <= 0 then
						v181.MicroProfilerMode:SetSelectionIndex(2)
						GameSettings.MicroProfilerWebServerEnabled = false

						if v181.InformationFrame or v181.InformationText then
							v181.InformationFrame.Visible = false
							v181.InformationFrame.Parent = nil
							v181.InformationText.Parent = nil
							v181.InformationFrame = nil
							v181.InformationText = nil
						end
					end
				else
					GameSettings.MicroProfilerWebServerEnabled = false

					if v181.InformationFrame or v181.InformationText then
						v181.InformationFrame.Visible = false
						v181.InformationFrame.Parent = nil
						v181.InformationText.Parent = nil
						v181.InformationFrame = nil
						v181.InformationText = nil
					end
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					MicroProfilerWebServerEnabled2 = GameSettings.MicroProfilerWebServerEnabled
				end
			elseif v129 or isInExperienceUIVREnabled and isSpatial() then
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
		local function GetDesiredWebServerIndex() -- line: 1161
			-- upvalues: v130 (copy), GameSettings (copy), v129 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy)
			if v130 then
				if GameSettings.MicroProfilerWebServerEnabled then
					return 1
				end

				return 2
			end

			if v129 or isInExperienceUIVREnabled and isSpatial() then
				if GameSettings.OnScreenProfilerEnabled then
					return 1
				end

				return 2
			end

			return 2
		end

		local v373 = if not v130 then not v129 and (not isInExperienceUIVREnabled or not isSpatial()) and 2 or (not GameSettings.OnScreenProfilerEnabled and 2 or 1) else not GameSettings.MicroProfilerWebServerEnabled and 2 or 1
		local v374 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MicroProfiler")
		local v375 = v181
		local v376 = v181
		local v377 = v181
		local v378, v379, v380 = Utility:AddNewRow(v181, v374, "Selector", {
			"On",
			"Off"
		}, v373)

		v375.MicroProfilerFrame = v378
		v376.MicroProfilerLabel = v379
		v377.MicroProfilerMode = v380
		v181.MicroProfilerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MicroProfilerFrame

		local MicroProfilerWebServerPort = GameSettings.MicroProfilerWebServerPort

		if MicroProfilerWebServerPort ~= 0 then
			local v382 = v181
			local v383 = v181
			local v384, v385 = createWebServerInformationRow()

			v382.InformationFrame = v384
			v383.InformationText = v385
			v181.InformationText.Text = GameSettings.MicroProfilerWebServerIP .. MicroProfilerWebServerPort
		end

		local u386 = false

		GameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function() -- line: 1190
			-- upvalues: u386 (ref), GameSettings (copy), v181 (copy)
			u386 = true

			if GameSettings.OnScreenProfilerEnabled then
				v181.MicroProfilerMode:SetSelectionIndex(1)

				return
			end

			v181.MicroProfilerMode:SetSelectionIndex(2)
		end)

		local function onIndexChanged(...) -- line: 1200
			-- upvalues: u386 (ref), setMicroProfilerIndex (copy)
			if u386 then
				u386 = false

				return
			end

			setMicroProfilerIndex(...)
		end

		v181.MicroProfilerMode.IndexChanged:connect(onIndexChanged)
	end
	local function createCameraModeOptions(p23) -- line: 1211
		-- upvalues: v181 (copy), GameSettings (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), v54 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy), LocalPlayer (copy), UserInputService (copy), CoreUtility (copy), t4 (copy), VRService (copy), GetFFlagAlwaysShowVRToggle (copy), getAppFeaturePolicies (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v86 (copy), t3 (copy), t2 (copy)
		local v389 = v181
		local v390 = v181
		local v391 = v181
		local v392 = v181

		v389.ShiftLockFrame = nil
		v390.ShiftLockLabel = nil
		v391.ShiftLockMode = nil
		v392.ShiftLockOverrideText = nil

		local n7 = 2

		if GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch then
			n7 = 1
		end

		local v394 = v181
		local v395 = v181
		local v396 = v181
		local v397, v398, v399 = Utility:AddNewRow(v181, "Shift Lock Switch", "Selector", {
			"On",
			"Off"
		}, n7)

		v394.ShiftLockFrame = v397
		v395.ShiftLockLabel = v398
		v396.ShiftLockMode = v399
		v181.ShiftLockFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ShiftLockFrame
		t10[v181.ShiftLockFrame] = true
		v181.ShiftLockOverrideText = Create("TextLabel")({
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
			Parent = v181.ShiftLockFrame
		})
		v181.ShiftLockMode.IndexChanged:connect(function(p24) -- line: 1242
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v811 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v811 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			end

			if p24 == 1 then
				GameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
			else
				GameSettings.ControlMode = Enum.ControlMode.Classic
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("shift_lock_enabled", v811, GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
			end

			reportSettingsForAnalytics()
		end)

		local function setShiftLockSelectorVisible(b1: boolean) -- line: 1264
			-- upvalues: LocalPlayer (copy), v181 (copy)
			local v813 = b1 and LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockMode then
				v181.ShiftLockMode.SelectorFrame.Visible = v813
				v181.ShiftLockMode:SetInteractable(v813)
			end
		end
		local function applyDevOverrideShiftLockSelector() -- line: 1272
			-- upvalues: LocalPlayer (copy), v181 (copy)
			local v814 = not LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockOverrideText then
				v181.ShiftLockOverrideText.Visible = v814

				local v815 = not v814 and LocalPlayer.DevEnableMouseLock

				if v181.ShiftLockMode then
					v181.ShiftLockMode.SelectorFrame.Visible = v815
					v181.ShiftLockMode:SetInteractable(v815)
				end
			end
		end
		local function updateShiftLockVisibility() -- line: 1280
			-- upvalues: UserInputService (copy), v181 (copy), LocalPlayer (copy)
			local v816 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v181.ShiftLockFrame then
				v181.ShiftLockFrame.Visible = v816
			end

			local v817 = not LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockOverrideText then
				v181.ShiftLockOverrideText.Visible = v817

				local v818 = not v817 and LocalPlayer.DevEnableMouseLock

				if v181.ShiftLockMode then
					v181.ShiftLockMode.SelectorFrame.Visible = v818
					v181.ShiftLockMode:SetInteractable(v818)
				end
			end
		end

		local v403 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

		if v181.ShiftLockFrame then
			v181.ShiftLockFrame.Visible = v403
		end

		local v404 = not LocalPlayer.DevEnableMouseLock

		if v181.ShiftLockOverrideText then
			v181.ShiftLockOverrideText.Visible = v404

			local v405 = not v404 and LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockMode then
				v181.ShiftLockMode.SelectorFrame.Visible = v405
				v181.ShiftLockMode:SetInteractable(v405)
			end
		end

		UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function() -- line: 1290
			-- upvalues: UserInputService (copy), v181 (copy), LocalPlayer (copy)
			local v819 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v181.ShiftLockFrame then
				v181.ShiftLockFrame.Visible = v819
			end

			local v820 = not LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockOverrideText then
				v181.ShiftLockOverrideText.Visible = v820

				local v821 = not v820 and LocalPlayer.DevEnableMouseLock

				if v181.ShiftLockMode then
					v181.ShiftLockMode.SelectorFrame.Visible = v821
					v181.ShiftLockMode:SetInteractable(v821)
				end
			end
		end)
		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function() -- line: 1294
			-- upvalues: UserInputService (copy), v181 (copy), LocalPlayer (copy)
			local v822 = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if v181.ShiftLockFrame then
				v181.ShiftLockFrame.Visible = v822
			end

			local v823 = not LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockOverrideText then
				v181.ShiftLockOverrideText.Visible = v823

				local v824 = not v823 and LocalPlayer.DevEnableMouseLock

				if v181.ShiftLockMode then
					v181.ShiftLockMode.SelectorFrame.Visible = v824
					v181.ShiftLockMode:SetInteractable(v824)
				end
			end
		end)

		function cameraModeIsUserChoice() -- line: 1300
			-- upvalues: UserInputService (copy), LocalPlayer (copy)
			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				return LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
			end

			return LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end
		function setCameraModeVisible(p25) -- line: 1309
			-- upvalues: v181 (copy)
			if v181.CameraMode then
				v181.CameraMode.SelectorFrame.Visible = p25
				v181.CameraMode:SetInteractable(p25)
				v181.CameraModeOverrideText.Visible = not p25
			end
		end

		local v406 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")
		local t14 = {}
		local t15 = {}

		local function updateCurrentCameraMovementIndex(p26) -- line: 1323
			-- upvalues: t15 (ref), t14 (ref), UserInputService (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy)
			local u827 = nil

			if not pcall(function() -- line: 1325
				-- upvalues: u827 (ref), t15 (ref), t14 (ref), p26 (copy)
				u827 = t15[t14[p26]]
			end) or u827 == nil then
				return false
			end

			local TouchCameraMovementModeValue = nil
			local v829

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.TouchCameraMovementMode.Value
				end

				v829 = GameSettings.TouchCameraMovementMode.Value ~= u827
				GameSettings.TouchCameraMovementMode = u827
			else
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					TouchCameraMovementModeValue = GameSettings.ComputerCameraMovementMode.Value
				end

				v829 = GameSettings.ComputerCameraMovementMode.Value ~= u827
				GameSettings.ComputerCameraMovementMode = u827
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() and v829 then
				reportSettingsChangeForAnalytics("camera_mode", TouchCameraMovementModeValue, u827)
			end

			return v829
		end
		local function updateCameraMovementModes() -- line: 1359
			-- upvalues: v406 (copy), UserInputService (copy), t14 (ref), t15 (ref), t4 (copy), v181 (copy), GameSettings (copy), updateCurrentCameraMovementIndex (copy)
			local t16 = {}

			if v406 then
				t16 = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then v406:GetRegisteredComputerCameraMovementModes() else v406:GetRegisteredTouchCameraMovementModes()
			end

			t14 = {}
			t15 = {}

			if #t16 <= 0 then
				setCameraModeVisible(false)

				return
			end

			for i = 1, #t16 do
				local v832 = t16[i]
				local Name = v832.Name

				if Name == "Default" then
					Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t4.DEFAULT_CLASSIC else t4.DEFAULT_FOLLOW
				end

				t14[#t14 + 1] = Name
				t15[Name] = v832.Value
			end

			if v181.CameraMode then
				v181.CameraMode:UpdateOptions(t14)
			end

			local v834 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
			local v835 = if not v834 then GameSettings.ComputerCameraMovementMode.Value else GameSettings.TouchCameraMovementMode.Value

			if v835 > -1 then
				if v834 or GameSettings.ComputerCameraMovementMode ~= Enum.ComputerCameraMovementMode.CameraToggle then
					v835 += 1
				end

				updateCurrentCameraMovementIndex(v835)
				v181.CameraMode:SetSelectionIndex(v835)
			end

			setCameraModeVisible(cameraModeIsUserChoice())
		end

		local v411 = v181
		local v412 = v181
		local v413 = v181
		local v414, v415, v416 = Utility:AddNewRow(v181, "Camera Mode", "Selector", t14, 1)

		v411.CameraModeFrame = v414
		v412.CameraModeLabel = v415
		v413.CameraMode = v416
		v181.CameraModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraModeFrame
		t10[v181.CameraMode] = true
		v181.CameraModeOverrideText = Create("TextLabel")({
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
			Parent = v181.CameraModeFrame
		})

		if v406 then
			v406.TouchCameraMovementModeRegistered:connect(function(__) -- line: 1445
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.TouchEnabled then
					updateCameraMovementModes()
				end
			end)
			v406.ComputerCameraMovementModeRegistered:connect(function(__) -- line: 1451
				-- upvalues: UserInputService (copy), updateCameraMovementModes (copy)
				if UserInputService.MouseEnabled then
					updateCameraMovementModes()
				end
			end)
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1458
			-- upvalues: updateCameraMovementModes (copy)
			updateCameraMovementModes()
		end)

		local u417 = false

		v181.CameraMode.IndexChanged:connect(function(p29) -- line: 1463
			-- upvalues: updateCurrentCameraMovementIndex (copy), u417 (ref), reportSettingsForAnalytics (copy)
			if updateCurrentCameraMovementIndex(p29) then
				if u417 then
					reportSettingsForAnalytics()
				end

				u417 = true
			end
		end)
		updateCameraMovementModes()

		local u418 = false

		local function createVROption() -- line: 1479
			-- upvalues: u418 (ref), GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy)
			if not u418 then
				u418 = true

				local u839 = if not GameSettings.VREnabled then {
					"On (restart pending)",
					"Off"
				} else {
					"On",
					"Off (restart pending)"
				}
				local v840 = v181
				local v841 = v181
				local v842 = v181
				local v843, v844, v845 = Utility:AddNewRow(v181, "VR", "Selector", u839, not GameSettings.VREnabled and 2 or 1)

				v840.VREnabledFrame = v843
				v841.VREnabledLabel = v844
				v842.VREnabledSelector = v845
				v181.VREnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VREnabledFrame
				v181.VREnabledSelector.IndexChanged:connect(function(p30) -- line: 1494
					-- upvalues: GameSettings (copy), u839 (ref), reportSettingsChangeForAnalytics (copy)
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
					local v1081 = p30 == t17.On.Value

					if v1081 ~= GameSettings.VREnabled then
						GameSettings.VREnabled = v1081

						local v1082 = u839[t17.On.Value]
						local v1083 = u839[p30]

						if v1083 == u839[t17.On.Value] then
							v1082 = u839[t17.Off.Value]
						end

						reportSettingsChangeForAnalytics("vr_mode", v1082, v1083)
					end
				end)
			end
		end
		local function onVREnabledChanged() -- line: 1513
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

		local function u425(__: boolean) -- line: 1538
		end
		local function setMovementModeVisible(p31) -- line: 1542
			-- upvalues: v181 (copy), t18 (ref)
			if v181.MovementMode then
				local v848 = p31 and #t18 > 0

				v181.MovementMode.SelectorFrame.Visible = v848
				v181.MovementMode:SetInteractable(v848)
				v181.MovementModeOverrideText.Visible = not v848
			end
		end

		if p23 then
			local v427 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

			local function getDisplayName(p32) -- line: 1556
				-- upvalues: UserInputService (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v86 (copy)
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
					p32 = v86
				end

				return p32
			end

			local v429 = v181
			local v430 = v181
			local v431 = v181
			local v432, v433, v434 = Utility:AddNewRow(v181, "Movement Mode", "Selector", {}, 1)

			v429.MovementModeFrame = v432
			v430.MovementModeLabel = v433
			v431.MovementMode = v434
			v181.MovementModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MovementModeFrame
			t10[v181.MovementMode] = true
			v181.MovementModeOverrideText = Create("TextLabel")({
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
				Parent = v181.MovementModeFrame
			})

			local function setMovementMode(p33) -- line: 1597
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

			function u425(b3: boolean) -- line: 1614
				-- upvalues: LocalPlayer (copy), v181 (copy), t18 (ref)
				local v853 = if not b3 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

				if v181.MovementMode then
					local v854 = v853 and #t18 > 0

					v181.MovementMode.SelectorFrame.Visible = v854
					v181.MovementMode:SetInteractable(v854)
					v181.MovementModeOverrideText.Visible = not v854
				end

				if v181.MovementModeOverrideText then
					v181.MovementModeOverrideText.Visible = not v853
				end
			end

			local function updateMovementModes() -- line: 1626
				-- upvalues: UserInputService (copy), v427 (copy), t18 (ref), t19 (ref), t20 (ref), t21 (ref), v181 (copy), RobloxTranslator (copy), Constants (copy), t6 (copy), v86 (copy), GameSettings (copy), setMovementMode (copy), u425 (ref)
				local v855 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

				if v427 then
					if v855 then
						t18 = v427:GetRegisteredTouchMovementModes()
					else
						t18 = v427:GetRegisteredComputerMovementModes()
					end
				end

				t19 = {}
				t20 = {}
				t21 = {}

				if #t18 <= 0 then
					if v181.MovementMode then
						v181.MovementMode.SelectorFrame.Visible = false
						v181.MovementMode:SetInteractable(false)
						v181.MovementModeOverrideText.Visible = true
					end

					return
				end

				if v181.MovementMode then
					local v856 = #t18 > 0

					v181.MovementMode.SelectorFrame.Visible = v856
					v181.MovementMode:SetInteractable(v856)
					v181.MovementModeOverrideText.Visible = not v856
				end

				for v857, v858 in t18 do
					t20[v857] = v858

					local v859 = t21
					local Name = v858.Name

					if Name == "Default" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.DEFAULT_KEYBOARD else RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
					elseif Name == "KeyboardMouse" then
						Name = "Keyboard + Mouse"
					elseif Name == "ClickToMove" then
						Name = if UserInputService.PreferredInput ~= Enum.PreferredInput.Touch then t6.CLICK_TO_MOVE else t6.TAP_TO_MOVE
					elseif Name == "DynamicThumbstick" then
						Name = "Dynamic Thumbstick"
					elseif Name == "Thumbstick" then
						Name = v86
					end

					v859[v857] = Name
					t19[v858] = v857
				end

				if v181.MovementMode then
					v181.MovementMode:UpdateOptions(t21)
				end

				local v861 = if not v855 then GameSettings.ComputerMovementMode else GameSettings.TouchMovementMode

				if v861 then
					setMovementMode(v861)
					v181.MovementMode:SetSelectionIndex(t19[v861])
				end

				u425(v855)
			end

			updateMovementModes()

			if v427 then
				v427.TouchMovementModeRegistered:connect(function(__) -- line: 1670
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.TouchEnabled then
						updateMovementModes()
					end
				end)
				v427.ComputerMovementModeRegistered:connect(function(__) -- line: 1676
					-- upvalues: UserInputService (copy), updateMovementModes (copy)
					if UserInputService.MouseEnabled then
						updateMovementModes()
					end
				end)
			end

			UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 1683
				-- upvalues: updateMovementModes (copy)
				updateMovementModes()
			end)
			v181.MovementMode.IndexChanged:connect(function(p36) -- line: 1687
				-- upvalues: setMovementMode (copy), t20 (ref), reportSettingsForAnalytics (copy)
				setMovementMode(t20[p36])
				reportSettingsForAnalytics()
			end)
		end

		local v437 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

		if not if not v437 then LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice else LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice then
			v181.CameraModeOverrideText.Visible = true
			setCameraModeVisible(false)
		else
			v181.CameraModeOverrideText.Visible = false
			setCameraModeVisible(true)
		end

		local v438 = if not v437 then LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice else LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

		if v181.MovementModeOverrideText then
			if not v438 then
				v181.MovementModeOverrideText.Visible = true

				if v181.MovementMode then
					v181.MovementMode.SelectorFrame.Visible = false
					v181.MovementMode:SetInteractable(false)
					v181.MovementModeOverrideText.Visible = true
				end
			else
				v181.MovementModeOverrideText.Visible = false

				if v181.MovementMode then
					local v439 = #t18 > 0

					v181.MovementMode.SelectorFrame.Visible = v439
					v181.MovementMode:SetInteractable(v439)
					v181.MovementModeOverrideText.Visible = not v439
				end
			end
		end

		local v440 = not LocalPlayer.DevEnableMouseLock

		if v181.ShiftLockOverrideText then
			v181.ShiftLockOverrideText.Visible = v440

			local v441 = not v440 and LocalPlayer.DevEnableMouseLock

			if v181.ShiftLockMode then
				v181.ShiftLockMode.SelectorFrame.Visible = v441
				v181.ShiftLockMode:SetInteractable(v441)
			end
		end

		local function updateUserSettingsMenu(p37) -- line: 1733
			-- upvalues: LocalPlayer (copy), v181 (copy), u425 (ref), t18 (ref)
			if p37 == "DevEnableMouseLock" then
				local v866 = not LocalPlayer.DevEnableMouseLock

				if v181.ShiftLockOverrideText then
					v181.ShiftLockOverrideText.Visible = v866

					local v867 = not v866 and LocalPlayer.DevEnableMouseLock

					if v181.ShiftLockMode then
						v181.ShiftLockMode.SelectorFrame.Visible = v867
						v181.ShiftLockMode:SetInteractable(v867)

						return
					end
				end
			else
				if p37 == "DevComputerCameraMode" then
					local v868 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice

					setCameraModeVisible(v868)
					v181.CameraModeOverrideText.Visible = not v868

					return
				end

				if p37 == "DevComputerMovementMode" then
					if u425 ~= nil then
						u425(false)

						return
					end

					local v869 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice

					if v181.MovementMode then
						local v870 = v869 and #t18 > 0

						v181.MovementMode.SelectorFrame.Visible = v870
						v181.MovementMode:SetInteractable(v870)
						v181.MovementModeOverrideText.Visible = not v870
					end

					if v181.MovementModeOverrideText then
						v181.MovementModeOverrideText.Visible = not v869

						return
					end
				elseif p37 == "DevTouchMovementMode" then
					if u425 ~= nil then
						u425(true)

						return
					end

					local v871 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice

					if v181.MovementMode then
						local v872 = v871 and #t18 > 0

						v181.MovementMode.SelectorFrame.Visible = v872
						v181.MovementMode:SetInteractable(v872)
						v181.MovementModeOverrideText.Visible = not v872
					end

					if v181.MovementModeOverrideText then
						v181.MovementModeOverrideText.Visible = not v871

						return
					end
				elseif p37 == "DevTouchCameraMode" then
					local v873 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice

					setCameraModeVisible(v873)
					v181.CameraModeOverrideText.Visible = not v873
				end
			end
		end

		LocalPlayer.Changed:connect(function(p38) -- line: 1768
			-- upvalues: t3 (copy), updateUserSettingsMenu (copy), t2 (copy)
			if t3[p38] then
				updateUserSettingsMenu(p38)
			end

			if t2[p38] then
				updateUserSettingsMenu(p38)
			end
		end)
	end
	local function createFeedbackModeOptions() -- line: 1781
		-- upvalues: Url (copy), HttpService (copy), v144 (copy), v181 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v143 (copy), Utility (copy), v88 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v138 (copy), v126 (copy)
		local v443 = Url.ROLES_URL .. "v1/users/authenticated/roles"
		local v444 = HttpService:RequestInternal({
			Method = "GET",
			Url = v443
		})

		local function rolesCheckCallback(p39) -- line: 1788
			-- upvalues: v144 (copy), v181 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy), v143 (copy), Utility (copy), v88 (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p39 then
				if not v144 and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v181.FeedbackEntryPointEnabled then
					return
				end

				local function onToggleFeedbackMode() -- line: 1800
					-- upvalues: v144 (copy), v181 (copy), SafetyService (copy), ExperienceStateCaptureService (ref), reportSettingsChangeForAnalytics (copy)
					if v144 and (game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and not v181.FeedbackEntryPointEnabled) then
						return
					end

					v181.HubRef:PopMenu(false, true)

					if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
						SafetyService.IsCaptureModeForReport = false
					end

					if ExperienceStateCaptureService ~= nil then
						ExperienceStateCaptureService:ToggleCaptureMode()
					end

					reportSettingsChangeForAnalytics("translation_feedback", "", "pressed")
				end

				local v877, v878

				if v143 then
					v877, v878 = Utility:MakeStyledButton("toggleFeedbackModeButton", v88, UDim2.new(1, 0, 1, -20), onToggleFeedbackMode, v181)
					v877.Size = UDim2.new(0.6, 0, 0, 40)
					v877.Position = UDim2.new(0.4, 0, 0.5, 0)
					v877.AnchorPoint = Vector2.new(0, 0.5)
				else
					v877, v878 = Utility:MakeStyledButton("toggleFeedbackModeButton", v88, UDim2.new(0, 300, 1, -20), onToggleFeedbackMode, v181)
					v877.Size = UDim2.new(0, 300, 0, 30)
					v877.Position = UDim2.new(0.4, 0, 0.5, 0)
					v877.AnchorPoint = Vector2.new(0, 0.5)
				end

				v877.ZIndex = 2
				v877.Selectable = true
				v878.ZIndex = 2

				if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
					v181.toggleFeedbackModeButton = v877
					v181.toggleFeedbackModeText = v878
				end

				if v143 then
					Utility:AddNewRowObject(v181, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v877, nil, true).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton

					return
				end

				Utility:AddNewRowObject(v181, RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"), v877).LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
			end
		end

		if v138 then
			rolesCheckCallback(true)

			return
		end

		v444:Start(function(p40, p41) -- line: 1884
			-- upvalues: HttpService (copy), v126 (copy), v443 (copy), rolesCheckCallback (copy)
			local u881 = false
			local v882 = false
			local s2

			if not p40 then
				s2 = "Roles Api Request: Connection error"
			elseif p41.StatusCode == 401 then
				s2 = "Roles Api Request: Unauthorized"
			elseif p41.StatusCode < 200 or p41.StatusCode >= 400 then
				s2 = "Roles Api Status code: " .. p41.StatusCode
			else
				v882, s2 = pcall(function() -- line: 1896
					-- upvalues: HttpService (copy), p41 (copy), u881 (ref)
					local data = HttpService:JSONDecode(p41.Body)

					for __, v in pairs(data.roles) do
						if v == "Soothsayer" then
							u881 = true
						end
					end
				end)
			end

			if not v882 then
				v126:warning("Feedback Mode initialization api call failed with url: " .. v443 .. " and with error message: " .. s2)
			end

			rolesCheckCallback(u881)
		end)
	end
	local function createTranslationOptions() -- line: 1924
		-- upvalues: Players (copy), Url (copy), HttpService (copy), v126 (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), LocalPlayer (copy), reportSettingsChangeForAnalytics (copy), RunService (copy)
		local n8 = 1
		local n9 = 1
		local u448 = false
		local languageCode = nil
		local localeCode = nil
		local LocaleId = Players.LocalPlayer.LocaleId
		local languageCode2 = nil
		local u453 = nil
		local t22 = {}
		local t23 = {}
		local t24 = {}
		local t25 = {}
		local t26 = {}
		local v459 = Url.LOCALE_URL .. string.format("v1/locales?displayValueLocale=%s", Players.LocalPlayer.LocaleId:gsub("-", "_"))
		local v460 = HttpService:RequestInternal({
			Method = "GET",
			Url = v459
		})
		local v461 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
		local v462 = HttpService:RequestInternal({
			Method = "GET",
			Url = v461
		})
		local v463 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/supported-languages/games/%d/in-experience-language-selection", game.GameId)
		local v464 = HttpService:RequestInternal({
			Method = "GET",
			Url = v463
		})
		local v465 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
		local v466 = HttpService:RequestInternal({
			Method = "GET",
			Url = v465
		})

		local function userExperienceLanguageSettingsCallback(p42, p43) -- line: 1989
			-- upvalues: v126 (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t26 (copy), t24 (copy), languageCode (ref), t22 (copy), u453 (ref), t23 (copy), n8 (ref), n9 (ref), LocalPlayer (copy), localeCode (ref), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), u448 (ref), RunService (copy)
			if not p42 then
				if p43 == nil then
					p43 = "Execution path did not set earliest error to non-nil value."
				end

				v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p43)

				local v886 = v181
				local v887 = v181
				local v888 = v181
				local v889, v890, v891 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

				v886.LanguageSelectorFrame = v889
				v887.LanguageSelectorLabel = v890
				v888.LanguageSelectorMode = v891
				v181.LanguageSelectorMode:SetInteractable(false)
				v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

				return
			end

			local v892 = false

			table.insert(t26, t24[languageCode].languageName .. " (Original)")

			for __, v in pairs(t22) do
				if v == u453 then
					v892 = true
				end

				if v ~= languageCode then
					table.insert(t26, t24[v].languageName)
				end
			end

			if v892 == true then
				for k, v in pairs(t26) do
					if k ~= 1 and t23[v] == u453 then
						n8 = k
						n9 = k
					end
				end
			end

			local v897 = v181
			local v898 = v181
			local v899 = v181
			local v900, v901, v902 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", t26, n8)

			v897.LanguageSelectorFrame = v900
			v898.LanguageSelectorLabel = v901
			v899.LanguageSelectorMode = v902
			v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

			if n8 == 1 then
				LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
			else
				local v903 = t23[t26[n8]]

				LocalPlayer:SetExperienceSettingsLocaleId(t24[v903].localeCode)
			end

			v181.LanguageSelectorMode.CurrentLanguage = v181.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

			local function toggleTranslation(p44) -- line: 2069
				-- upvalues: v181 (copy), t24 (copy), languageCode (ref), t23 (copy), t26 (copy), reportSettingsChangeForAnalytics (copy), Url (copy), HttpService (copy), n9 (ref), LocalPlayer (copy), localeCode (ref), v126 (copy), u448 (ref), RunService (copy)
				v181.LanguageSelectorMode:SetInteractable(false)

				local v1088 = if p44 ~= 1 then t24[t23[t26[p44]]].id else t24[languageCode].id
				local CurrentLanguage = v181.LanguageSelectorMode.CurrentLanguage
				local v1090 = t26[p44]

				if CurrentLanguage ~= v1090 then
					v181.LanguageSelectorMode.CurrentLanguage = v1090
					reportSettingsChangeForAnalytics("experience_language", CurrentLanguage, v1090)
				end

				local t27 = {
					settingValue = {
						settingType = "LanguageFamily",
						settingTargetId = v1088
					}
				}
				local v1092 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/user-localization-settings/universe/%d", game.GameId)
				local v1093 = HttpService:RequestInternal({
					Method = "POST",
					Url = v1092,
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode(t27)
				})

				local function callback(p45, p46) -- line: 2116
					-- upvalues: n9 (ref), p44 (copy), LocalPlayer (copy), localeCode (ref), t23 (copy), t26 (copy), t24 (copy), v126 (copy), u448 (ref), v181 (copy)
					if p45 then
						n9 = p44

						if p44 == 1 then
							LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
						else
							local v1180 = t23[t26[p44]]

							LocalPlayer:SetExperienceSettingsLocaleId(t24[v1180].localeCode)
						end
					else
						v126:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p46)
						u448 = true
						v181.LanguageSelectorMode:SetSelectionIndex(n9)
					end

					v181.LanguageSelectorMode:SetInteractable(true)
				end

				if RunService:IsStudio() then
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1095 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1095].localeCode)
					end

					v181.LanguageSelectorMode:SetInteractable(true)

					return
				end

				if u448 then
					u448 = false
					n9 = p44

					if p44 == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						local v1096 = t23[t26[p44]]

						LocalPlayer:SetExperienceSettingsLocaleId(t24[v1096].localeCode)
					end

					v181.LanguageSelectorMode:SetInteractable(true)

					return
				end

				v1093:Start(function(p47, p48) -- line: 2159
					-- upvalues: v126 (copy), v1092 (copy), callback (copy)
					local v1183 = false
					local s3 = nil

					if not p47 then
						s3 = "User Experience Language Settings Update Request: Connection error"
					elseif p48.StatusCode == 401 then
						s3 = "User Experience Language Settings Update Request: Unauthorized"
					elseif p48.StatusCode < 200 or p48.StatusCode >= 400 then
						s3 = "User Experience Language Settings Update Request Status Code: " .. p48.StatusCode
					else
						v126:info("User Experience Language Settings Update Request succeeded with code: " .. p48.StatusCode)
						v1183 = true
					end

					if not v1183 then
						v126:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. v1092 .. " with error message: " .. s3)
					end

					callback(v1183, s3)
				end)
			end

			v181.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
		end
		local function experienceSupportedLanguagesCallback(p49, p50) -- line: 2194
			-- upvalues: v466 (copy), HttpService (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v126 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p49 then
				v466:Start(function(p51, p52) -- line: 2196
					-- upvalues: HttpService (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v126 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy)
					local v1099 = false
					local s4

					if not p51 then
						s4 = "User Experience Language Setting Request: Connection error"
					elseif p52.StatusCode == 401 then
						s4 = "User Experience Language Setting Request: Unauthorized"
					elseif p52.StatusCode < 200 or p52.StatusCode >= 400 then
						s4 = "User Experience Language Setting Request Status code: " .. p52.StatusCode
					else
						v1099, s4 = pcall(function() -- line: 2207
							-- upvalues: HttpService (copy), p52 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
							local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p52.Body).userUniverseLocalizationSettingValue

							if userUniverseLocalizationSettingValue == nil then
								u453 = languageCode2

								return
							end

							if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
								if userUniverseLocalizationSettingValue.settingTargetId == 1 then
									u453 = languageCode
								else
									u453 = languageCode2
								end
							end

							if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
								if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
									u453 = languageCode2

									return
								end

								u453 = t25[userUniverseLocalizationSettingValue.settingTargetId]
							end
						end)
					end

					if not v1099 then
						v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v465 .. " with error message: " .. s4)
					end

					userExperienceLanguageSettingsCallback(v1099, s4)
				end)

				return
			end

			if p50 == nil then
				p50 = "Execution path did not set earliest error to non-nil value."
			end

			v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. p50)

			local v907 = v181
			local v908 = v181
			local v909 = v181
			local v910, v911, v912 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

			v907.LanguageSelectorFrame = v910
			v908.LanguageSelectorLabel = v911
			v909.LanguageSelectorMode = v912
			v181.LanguageSelectorMode:SetInteractable(false)
			v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
		end
		local function experienceSourceLanguageCallback(p53, p54) -- line: 2256
			-- upvalues: v464 (copy), HttpService (copy), t22 (copy), v126 (copy), v463 (copy), v466 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p53 then
				v464:Start(function(p55, p56) -- line: 2258
					-- upvalues: HttpService (copy), t22 (copy), v126 (copy), v463 (copy), p54 (ref), p53 (copy), v466 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1103 = false
					local s5

					if not p55 then
						s5 = "Experience Supported Language Request: Connection error"
					elseif p56.StatusCode == 401 then
						s5 = "Experience Supported Language Request: Unauthorized"
					elseif p56.StatusCode < 200 or p56.StatusCode >= 400 then
						s5 = "Experience Supported Language Request Status code: " .. p56.StatusCode
					else
						v1103, s5 = pcall(function() -- line: 2268
							-- upvalues: HttpService (copy), p56 (copy), t22 (copy)
							local data = HttpService:JSONDecode(p56.Body)

							for k, v in pairs(data.data) do
								t22[k] = v.languageCode
							end
						end)
					end

					if not v1103 then
						v126:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v463 .. " with error message: " .. s5)
					end

					if p54 == nil then
						p54 = s5
					end

					local v1105 = v1103 and p53
					local v1106 = p54

					if v1105 then
						v466:Start(function(p57, p58) -- line: 2196
							-- upvalues: HttpService (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v126 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy)
							local v1191 = false
							local s6

							if not p57 then
								s6 = "User Experience Language Setting Request: Connection error"
							elseif p58.StatusCode == 401 then
								s6 = "User Experience Language Setting Request: Unauthorized"
							elseif p58.StatusCode < 200 or p58.StatusCode >= 400 then
								s6 = "User Experience Language Setting Request Status code: " .. p58.StatusCode
							else
								v1191, s6 = pcall(function() -- line: 2207
									-- upvalues: HttpService (copy), p58 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
									local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p58.Body).userUniverseLocalizationSettingValue

									if userUniverseLocalizationSettingValue == nil then
										u453 = languageCode2

										return
									end

									if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
										if userUniverseLocalizationSettingValue.settingTargetId == 1 then
											u453 = languageCode
										else
											u453 = languageCode2
										end
									end

									if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
										if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
											u453 = languageCode2

											return
										end

										u453 = t25[userUniverseLocalizationSettingValue.settingTargetId]
									end
								end)
							end

							if not v1191 then
								v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v465 .. " with error message: " .. s6)
							end

							userExperienceLanguageSettingsCallback(v1191, s6)
						end)

						return
					end

					if v1106 == nil then
						v1106 = "Execution path did not set earliest error to non-nil value."
					end

					v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1106)

					local v1107 = v181
					local v1108 = v181
					local v1109 = v181
					local v1110, v1111, v1112 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

					v1107.LanguageSelectorFrame = v1110
					v1108.LanguageSelectorLabel = v1111
					v1109.LanguageSelectorMode = v1112
					v181.LanguageSelectorMode:SetInteractable(false)
					v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
				end)
			else
				local v916 = p54

				if v916 == nil then
					v916 = "Execution path did not set earliest error to non-nil value."
				end

				v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v916)

				local v917 = v181
				local v918 = v181
				local v919 = v181
				local v920, v921, v922 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

				v917.LanguageSelectorFrame = v920
				v918.LanguageSelectorLabel = v921
				v919.LanguageSelectorMode = v922
				v181.LanguageSelectorMode:SetInteractable(false)
				v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end
		local function localeCodeToLanguageCodeMappingCallback(p59, p60) -- line: 2297
			-- upvalues: v462 (copy), HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v126 (copy), v461 (copy), v464 (copy), t22 (copy), v463 (copy), v466 (copy), u453 (ref), languageCode2 (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			if p59 then
				v462:Start(function(p61, p62) -- line: 2299
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v126 (copy), v461 (copy), p60 (ref), p59 (copy), v464 (copy), t22 (copy), v463 (copy), v466 (copy), u453 (ref), languageCode2 (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1115 = false
					local s7

					if not p61 then
						s7 = "Experience Source Language Request: Connection error"
					elseif p62.StatusCode == 401 then
						s7 = "Experience Source Language Request: Unauthorized"
					elseif p62.StatusCode < 200 or p62.StatusCode >= 400 then
						s7 = "Experience Source Language Status code: " .. p62.StatusCode
					else
						v1115, s7 = pcall(function() -- line: 2310
							-- upvalues: HttpService (copy), p62 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p62.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1115 then
						v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v461 .. " with error message: " .. s7)
					end

					if p60 == nil then
						p60 = s7
					end

					local v1117 = v1115 and p59
					local u1118 = p60

					if v1117 then
						v464:Start(function(p63, p64) -- line: 2258
							-- upvalues: HttpService (copy), t22 (copy), v126 (copy), v463 (copy), u1118 (ref), v1117 (copy), v466 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1195 = false
							local s8

							if not p63 then
								s8 = "Experience Supported Language Request: Connection error"
							elseif p64.StatusCode == 401 then
								s8 = "Experience Supported Language Request: Unauthorized"
							elseif p64.StatusCode < 200 or p64.StatusCode >= 400 then
								s8 = "Experience Supported Language Request Status code: " .. p64.StatusCode
							else
								v1195, s8 = pcall(function() -- line: 2268
									-- upvalues: HttpService (copy), p64 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p64.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1195 then
								v126:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v463 .. " with error message: " .. s8)
							end

							if u1118 == nil then
								u1118 = s8
							end

							local v1197 = v1195 and v1117
							local v1198 = u1118

							if v1197 then
								v466:Start(function(p65, p66) -- line: 2196
									-- upvalues: HttpService (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v126 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1235 = false
									local s9

									if not p65 then
										s9 = "User Experience Language Setting Request: Connection error"
									elseif p66.StatusCode == 401 then
										s9 = "User Experience Language Setting Request: Unauthorized"
									elseif p66.StatusCode < 200 or p66.StatusCode >= 400 then
										s9 = "User Experience Language Setting Request Status code: " .. p66.StatusCode
									else
										v1235, s9 = pcall(function() -- line: 2207
											-- upvalues: HttpService (copy), p66 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p66.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u453 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u453 = languageCode
												else
													u453 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u453 = languageCode2

													return
												end

												u453 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1235 then
										v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v465 .. " with error message: " .. s9)
									end

									userExperienceLanguageSettingsCallback(v1235, s9)
								end)

								return
							end

							if v1198 == nil then
								v1198 = "Execution path did not set earliest error to non-nil value."
							end

							v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1198)

							local v1199 = v181
							local v1200 = v181
							local v1201 = v181
							local v1202, v1203, v1204 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

							v1199.LanguageSelectorFrame = v1202
							v1200.LanguageSelectorLabel = v1203
							v1201.LanguageSelectorMode = v1204
							v181.LanguageSelectorMode:SetInteractable(false)
							v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1119 = u1118

						if v1119 == nil then
							v1119 = "Execution path did not set earliest error to non-nil value."
						end

						v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1119)

						local v1120 = v181
						local v1121 = v181
						local v1122 = v181
						local v1123, v1124, v1125 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

						v1120.LanguageSelectorFrame = v1123
						v1121.LanguageSelectorLabel = v1124
						v1122.LanguageSelectorMode = v1125
						v181.LanguageSelectorMode:SetInteractable(false)
						v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v926 = p60

				if v926 == nil then
					v926 = "Execution path did not set earliest error to non-nil value."
				end

				v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v926)

				local v927 = v181
				local v928 = v181
				local v929 = v181
				local v930, v931, v932 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

				v927.LanguageSelectorFrame = v930
				v928.LanguageSelectorLabel = v931
				v929.LanguageSelectorMode = v932
				v181.LanguageSelectorMode:SetInteractable(false)
				v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		v460:Start(function(p67, p68) -- line: 2341
			-- upvalues: HttpService (copy), t24 (copy), t25 (copy), t23 (copy), LocaleId (copy), languageCode2 (ref), v126 (copy), v459 (copy), v462 (copy), languageCode (ref), localeCode (ref), v461 (copy), v464 (copy), t22 (copy), v463 (copy), v466 (copy), u453 (ref), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local v935 = false
			local s10

			if not p67 then
				s10 = "Locale Code to Language Code Mapping Request: Connection error"
			elseif p68.StatusCode == 401 then
				s10 = "Locale Code to Language Code Mapping Request: Unauthorized"
			elseif p68.StatusCode < 200 or p68.StatusCode >= 400 then
				s10 = "Locale Code to Language Code Mapping Request Status code: " .. p68.StatusCode
			else
				v935, s10 = pcall(function() -- line: 2352
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

			if not v935 then
				v126:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v459 .. " with error message: " .. s10)
			end

			local v937 = v935
			local u938 = s10

			if v937 then
				v462:Start(function(p69, p70) -- line: 2299
					-- upvalues: HttpService (copy), languageCode (ref), localeCode (ref), t24 (copy), v126 (copy), v461 (copy), u938 (ref), v937 (copy), v464 (copy), t22 (copy), v463 (copy), v466 (copy), u453 (ref), languageCode2 (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
					local v1135 = false
					local s11

					if not p69 then
						s11 = "Experience Source Language Request: Connection error"
					elseif p70.StatusCode == 401 then
						s11 = "Experience Source Language Request: Unauthorized"
					elseif p70.StatusCode < 200 or p70.StatusCode >= 400 then
						s11 = "Experience Source Language Status code: " .. p70.StatusCode
					else
						v1135, s11 = pcall(function() -- line: 2310
							-- upvalues: HttpService (copy), p70 (copy), languageCode (ref), localeCode (ref), t24 (copy)
							languageCode = HttpService:JSONDecode(p70.Body).languageCode
							localeCode = t24[languageCode].localeCode
						end)
					end

					if not v1135 then
						v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v461 .. " with error message: " .. s11)
					end

					if u938 == nil then
						u938 = s11
					end

					local v1137 = v1135 and v937
					local u1138 = u938

					if v1137 then
						v464:Start(function(p71, p72) -- line: 2258
							-- upvalues: HttpService (copy), t22 (copy), v126 (copy), v463 (copy), u1138 (ref), v1137 (copy), v466 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy), v181 (copy), Utility (copy), RobloxTranslator (copy), v87 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
							local v1207 = false
							local s12

							if not p71 then
								s12 = "Experience Supported Language Request: Connection error"
							elseif p72.StatusCode == 401 then
								s12 = "Experience Supported Language Request: Unauthorized"
							elseif p72.StatusCode < 200 or p72.StatusCode >= 400 then
								s12 = "Experience Supported Language Request Status code: " .. p72.StatusCode
							else
								v1207, s12 = pcall(function() -- line: 2268
									-- upvalues: HttpService (copy), p72 (copy), t22 (copy)
									local data = HttpService:JSONDecode(p72.Body)

									for k, v in pairs(data.data) do
										t22[k] = v.languageCode
									end
								end)
							end

							if not v1207 then
								v126:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. v463 .. " with error message: " .. s12)
							end

							if u1138 == nil then
								u1138 = s12
							end

							local v1209 = v1207 and v1137
							local v1210 = u1138

							if v1209 then
								v466:Start(function(p73, p74) -- line: 2196
									-- upvalues: HttpService (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy), v126 (copy), v465 (copy), userExperienceLanguageSettingsCallback (copy)
									local v1242 = false
									local s13

									if not p73 then
										s13 = "User Experience Language Setting Request: Connection error"
									elseif p74.StatusCode == 401 then
										s13 = "User Experience Language Setting Request: Unauthorized"
									elseif p74.StatusCode < 200 or p74.StatusCode >= 400 then
										s13 = "User Experience Language Setting Request Status code: " .. p74.StatusCode
									else
										v1242, s13 = pcall(function() -- line: 2207
											-- upvalues: HttpService (copy), p74 (copy), u453 (ref), languageCode2 (ref), languageCode (ref), t25 (copy)
											local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p74.Body).userUniverseLocalizationSettingValue

											if userUniverseLocalizationSettingValue == nil then
												u453 = languageCode2

												return
											end

											if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
												if userUniverseLocalizationSettingValue.settingTargetId == 1 then
													u453 = languageCode
												else
													u453 = languageCode2
												end
											end

											if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
												if t25[userUniverseLocalizationSettingValue.settingTargetId] == nil then
													u453 = languageCode2

													return
												end

												u453 = t25[userUniverseLocalizationSettingValue.settingTargetId]
											end
										end)
									end

									if not v1242 then
										v126:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. v465 .. " with error message: " .. s13)
									end

									userExperienceLanguageSettingsCallback(v1242, s13)
								end)

								return
							end

							if v1210 == nil then
								v1210 = "Execution path did not set earliest error to non-nil value."
							end

							v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1210)

							local v1211 = v181
							local v1212 = v181
							local v1213 = v181
							local v1214, v1215, v1216 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

							v1211.LanguageSelectorFrame = v1214
							v1212.LanguageSelectorLabel = v1215
							v1213.LanguageSelectorMode = v1216
							v181.LanguageSelectorMode:SetInteractable(false)
							v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						local v1139 = u1138

						if v1139 == nil then
							v1139 = "Execution path did not set earliest error to non-nil value."
						end

						v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v1139)

						local v1140 = v181
						local v1141 = v181
						local v1142 = v181
						local v1143, v1144, v1145 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

						v1140.LanguageSelectorFrame = v1143
						v1141.LanguageSelectorLabel = v1144
						v1142.LanguageSelectorMode = v1145
						v181.LanguageSelectorMode:SetInteractable(false)
						v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				local v939 = u938

				if v939 == nil then
					v939 = "Execution path did not set earliest error to non-nil value."
				end

				v126:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. v939)

				local v940 = v181
				local v941 = v181
				local v942 = v181
				local v943, v944, v945 = Utility:AddNewRow(v181, RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"), "DropDown", { v87 }, 1)

				v940.LanguageSelectorFrame = v943
				v941.LanguageSelectorLabel = v944
				v942.LanguageSelectorMode = v945
				v181.LanguageSelectorMode:SetInteractable(false)
				v181.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end)
	end
	local function getChatTranslationLayerData(p75) -- line: 2391
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

		local ok, result = pcall(function() -- line: 2413
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
	local function createVolumeOptions() -- line: 2431
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), FFlagRenameVolumeToMainVolume (copy), RobloxTranslator (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v475 = math.floor(GameSettings.MasterVolume * 10)
		local v476 = v181
		local v477 = v181
		local v478 = v181
		local v479, v480, v481 = Utility:AddNewRow(v181, not FFlagRenameVolumeToMainVolume and "Volume" or RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.MainVolume"), "Slider", 10, v475)

		v476.VolumeFrame = v479
		v477.VolumeLabel = v480
		v478.VolumeSlider = v481
		v181.VolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VolumeFrame

		local Sound = Instance.new("Sound", game:GetService("CoreGui").RobloxGui.Sounds)

		Sound.Name = "VolumeChangeSound"
		Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"
		v181.VolumeSlider.ValueChanged:connect(function(p76) -- line: 2444
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), Sound (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v947 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v947 = math.floor(GameSettings.MasterVolume * 10 + 0.5)
			end

			local v948 = p76 / 10

			Sound.Volume = v948
			Sound:Play()
			GameSettings.MasterVolume = v948

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("volume", v947, (math.floor(GameSettings.MasterVolume * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createPartyVoiceVolumeOptions() -- line: 2462
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty (copy), default4 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v483 = math.floor(GameSettings.PartyVoiceVolume * 10)
		local v484 = v181
		local v485 = v181
		local v486 = v181
		local v487, v488, v489 = Utility:AddNewRow(v181, "Party Voice Volume", "Slider", 10, v483)

		v484.PartyVoiceVolumeFrame = v487
		v485.PartyVoiceVolumeLabel = v488
		v486.PartyVoiceVolumeSlider = v489
		v181.PartyVoiceVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PartyVoiceVolumeFrame

		if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			v181.PartyVoiceVolumeFrame.Visible = default4.hasExperienceStarted
			default4.ExperienceJoined.Event:Connect(function() -- line: 2471
				-- upvalues: v181 (copy)
				v181.PartyVoiceVolumeFrame.Visible = true
			end)
			default4.ExperienceLeft.Event:Connect(function() -- line: 2474
				-- upvalues: v181 (copy)
				v181.PartyVoiceVolumeFrame.Visible = false
			end)
		end

		v181.PartyVoiceVolumeSlider.ValueChanged:connect(function(p77) -- line: 2479
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), v483 (copy), GameSettings (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v950 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v950 = v483 == nil and 0 or math.floor(v483 * 10 + 0.5)
			end

			GameSettings.PartyVoiceVolume = p77 / 10

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("party_voice_volume", v950, (math.floor(p77 * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createVoiceChatVolumeOptions() -- line: 2495
		-- upvalues: GameSettings (copy), u24 (ref), v126 (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v69 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v490 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
		local ok, result = pcall(function() -- line: 2497
			-- upvalues: u24 (ref)
			return u24:Format("CoreScripts.InGameMenu.GameSettings.VoiceChatVolume")
		end)

		if not ok then
			result = "Voice Chat Volume"
			v126:debug("[GameSettings] createVoiceChatVolumeOptions failed to get translation for Voice Chat Volume label, using placeholder text instead")
		end

		local v493 = v181
		local v494 = v181
		local v495 = v181
		local v496, v497, v498 = Utility:AddNewRow(v181, result, "Slider", 10, v490)

		v493.VoiceChatVolumeFrame = v496
		v494.VoiceChatVolumeLabel = v497
		v495.VoiceChatVolumeSlider = v498
		v181.VoiceChatVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceChatVolumeFrame
		v181.VoiceChatVolumeFrame.Visible = false

		if v69 then
			local function updateVoiceChatVolumeSliderInteractable(n10: number?) -- line: 2512
				-- upvalues: GameSettings (copy), v181 (copy)
				if if n10 == nil then GameSettings.MasterVolume == 0 else n10 == 0 then
					v181.VoiceChatVolumeSlider:SetZIndex(1)
					v181.VoiceChatVolumeLabel.ZIndex = 1
					v181.VoiceChatVolumeSlider:SetInteractable(false)

					return
				end

				v181.VoiceChatVolumeSlider:SetZIndex(2)
				v181.VoiceChatVolumeLabel.ZIndex = 2
				v181.VoiceChatVolumeSlider:SetInteractable(true)
			end

			updateVoiceChatVolumeSliderInteractable()
			v181.VolumeSlider.ValueChanged:connect(updateVoiceChatVolumeSliderInteractable)
		end

		v181.VoiceChatVolumeSlider.ValueChanged:connect(function(p78) -- line: 2532
			-- upvalues: GetFFlagEnableExplicitSettingsChangeAnalytics (copy), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v181 (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
			local v953 = nil

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v953 = math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)
			end

			GameSettings.VoiceChatVolume = p78 / 5

			if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and v181.maxVoiceChatVolumeDuringSession ~= nil then
				v181.maxVoiceChatVolumeDuringSession = math.max(v181.maxVoiceChatVolumeDuringSession, GameSettings.VoiceChatVolume)
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("voice_chat_volume", v953, (math.floor(GameSettings.VoiceChatVolume * 5 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end
	local function createHapticsToggle() -- line: 2557
		-- upvalues: GameSettings (copy), getAppFeaturePolicies (copy), u24 (ref), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local v500 = GameSettings.HapticStrength ~= 0 and 2 or 1
		local v501 = not getAppFeaturePolicies().getShouldUseVibrationInsteadOfHaptics() and "Haptics" or u24:Format("CoreScripts.InGameMenu.Vibration")
		local v502 = v181
		local v503 = v181
		local v504, v505, v506 = Utility:AddNewRow(v181, v501, "Selector", {
			"Off",
			"On"
		}, v500)

		v502.HapticsFrame = v504
		_ = v505
		v503.HapticsSelector = v506
		v181.HapticsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.HapticsFrame
		v181.HapticsSelector.IndexChanged:connect(function(p79) -- line: 2566
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
	local function createCameraInvertedOptions() -- line: 2582
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), GetFFlagEnableExplicitSettingsChangeAnalytics (copy), reportSettingsChangeForAnalytics (copy), reportSettingsForAnalytics (copy)
		local n11 = 1

		if pcall(function() -- line: 2584
			-- upvalues: GameSettings (copy), n11 (ref)
			if GameSettings.CameraYInverted == true then
				n11 = 2
			end
		end) == false then
			return
		end

		local v508 = v181
		local v509 = v181
		local v510, v511, v512 = Utility:AddNewRow(v181, "Camera Inverted", "Selector", {
			"Off",
			"On"
		}, n11)

		v508.CameraInvertedFrame = v510
		_ = v511
		v509.CameraInvertedSelector = v512
		v181.CameraInvertedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraInvertedFrame
		t10[v181.CameraInvertedFrame] = true
		v181.CameraInvertedSelector.IndexChanged:connect(function(p80) -- line: 2599
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
	local function setCameraSensitivity(p81) -- line: 2618
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
	local function createMouseOptions() -- line: 2656
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), t10 (copy), Create (copy), Theme (copy), setCameraSensitivity (copy)
		local function translateEngineMouseSensitivityToGui(p82) -- line: 2661
			local v959 = p82 <= 1 and math.floor((p82 - 0.2) / 0.16 + 0.5) or math.floor((p82 + 2) / 0.6 + 0.5)

			if p82 <= 0.2 then
				return 0
			end

			return v959
		end
		local function translateGuiMouseSensitivityToEngine(p83) -- line: 2669
			local v961 = p83 <= 5 and 0.16 * p83 + 0.2 or 0.6 * p83 - 2

			if v961 <= 0.2 then
				return 0.2
			end

			return v961
		end

		local MouseSensitivity = GameSettings.MouseSensitivity
		local v520 = MouseSensitivity <= 1 and math.floor((MouseSensitivity - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivity + 2) / 0.6 + 0.5)
		local v521 = if not (MouseSensitivity <= 0.2) then v520 else 0
		local u522 = true

		tostring(GameSettings.MouseSensitivityFirstPerson.X)

		local v523 = v181
		local v524 = v181
		local v525 = v181
		local v526, v527, v528 = Utility:AddNewRow(v181, "Camera Sensitivity", "Slider", 10, v521)

		v523.MouseAdvancedFrame = v526
		v524.MouseAdvancedLabel = v527
		v525.MouseAdvancedEntry = v528
		v181.MouseAdvancedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MouseAdvancedFrame
		t10[v181.MouseAdvancedFrame] = true
		v181.MouseAdvancedEntry.SliderFrame.Size = UDim2.new(v181.MouseAdvancedEntry.SliderFrame.Size.X.Scale, v181.MouseAdvancedEntry.SliderFrame.Size.X.Offset - 60 - 20, v181.MouseAdvancedEntry.SliderFrame.Size.Y.Scale, v181.MouseAdvancedEntry.SliderFrame.Size.Y.Offset - 6)
		v181.MouseAdvancedEntry.SliderFrame.Position = UDim2.new(v181.MouseAdvancedEntry.SliderFrame.Position.X.Scale, v181.MouseAdvancedEntry.SliderFrame.Position.X.Offset - 60 - 20, v181.MouseAdvancedEntry.SliderFrame.Position.Y.Scale, v181.MouseAdvancedEntry.SliderFrame.Position.Y.Offset)
		v181.MouseAdvancedLabel.ZIndex = 2
		v181.MouseAdvancedEntry:SetInteractable(true)

		local v529 = Create("TextBox")({
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
			Parent = v181.MouseAdvancedEntry.SliderFrame
		})

		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = v529
		})

		local function setMouseSensitivityText(p84) -- line: 2728
			-- upvalues: v529 (copy)
			local v963 = math.floor(p84 * 1000 + 0.5) / 1000

			v529.Text = tostring((tonumber((string.format("%.3f", v963)))))
		end

		local v531 = math.floor(GameSettings.MouseSensitivityFirstPerson.X * 1000 + 0.5) / 1000

		v529.Text = tostring((tonumber((string.format("%.3f", v531)))))

		local MouseAdvancedEntry = v181.MouseAdvancedEntry
		local MouseSensitivityFirstPersonX = GameSettings.MouseSensitivityFirstPerson.X
		local v534 = MouseSensitivityFirstPersonX <= 1 and math.floor((MouseSensitivityFirstPersonX - 0.2) / 0.16 + 0.5) or math.floor((MouseSensitivityFirstPersonX + 2) / 0.6 + 0.5)

		MouseAdvancedEntry:SetValue(if not (MouseSensitivityFirstPersonX <= 0.2) then v534 else 0)

		function clampMouseSensitivity(p85) -- line: 2743
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
		function setMouseSensitivity(p86, p87) -- line: 2761
			-- upvalues: u522 (ref), setCameraSensitivity (copy), v181 (copy), v529 (copy)
			if not u522 then
				return
			end

			setCameraSensitivity(p86)
			u522 = false

			if p87 ~= v181.MouseAdvancedEntry then
				local MouseAdvancedEntry2 = v181.MouseAdvancedEntry
				local v968 = p86 <= 1 and math.floor((p86 - 0.2) / 0.16 + 0.5) or math.floor((p86 + 2) / 0.6 + 0.5)

				MouseAdvancedEntry2:SetValue(if not (p86 <= 0.2) then v968 else 0)
			end

			local v969 = math.floor(p86 * 1000 + 0.5) / 1000

			v529.Text = tostring((tonumber((string.format("%.3f", v969)))))
			u522 = true
		end

		v529.FocusLost:connect(function() -- line: 2779
			-- upvalues: v181 (copy), v529 (copy), GameSettings (copy)
			v181.MouseAdvancedEntry:SetInteractable(true)

			local num = tonumber((string.match(v529.Text, "([%d%.]+)")))

			if num then
				setMouseSensitivity(clampMouseSensitivity(num), v529)

				return
			end

			setMouseSensitivity(GameSettings.MouseSensitivityFirstPerson.X, v529)
		end)
		v529.Focused:connect(function() -- line: 2791
			-- upvalues: v181 (copy)
			v181.MouseAdvancedEntry:SetInteractable(false)
		end)
		v181.MouseAdvancedEntry.ValueChanged:connect(function(p88) -- line: 2795
			-- upvalues: v181 (copy)
			local v972 = clampMouseSensitivity(p88)
			local v973 = v972 <= 5 and 0.16 * v972 + 0.2 or 0.6 * v972 - 2
			local v974 = if not (v973 <= 0.2) then v973 else 0.2

			setMouseSensitivity(v974, v181.MouseAdvancedEntry)
		end)
	end
	local function createGamepadOptions() -- line: 2802
		-- upvalues: GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), setCameraSensitivity (copy)
		local function translateEngineGamepadSensitivityToGui(p89) -- line: 2807
			local v976 = p89 <= 1 and math.floor((p89 - 0.2) / 0.16 + 0.5) or math.floor((p89 + 2) / 0.6 + 0.5)

			if p89 <= 0.2 then
				return 0
			end

			return v976
		end
		local function translateGuiGamepadSensitivityToEngine(p90) -- line: 2814
			local v978 = p90 <= 5 and 0.16 * p90 + 0.2 or 0.6 * p90 - 2

			if v978 <= 0.2 then
				return 0.2
			end

			return v978
		end

		local GamepadCameraSensitivity = GameSettings.GamepadCameraSensitivity
		local v538 = GamepadCameraSensitivity <= 1 and math.floor((GamepadCameraSensitivity - 0.2) / 0.16 + 0.5) or math.floor((GamepadCameraSensitivity + 2) / 0.6 + 0.5)
		local v539 = if not (GamepadCameraSensitivity <= 0.2) then v538 else 0
		local v540 = v181
		local v541 = v181
		local v542 = v181
		local v543, v544, v545 = Utility:AddNewRow(v181, "Camera Sensitivity", "Slider", 10, v539)

		v540.GamepadSensitivityFrame = v543
		v541.GamepadSensitivityLabel = v544
		v542.GamepadSensitivitySlider = v545
		v181.GamepadSensitivityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GamepadSensitivityFrame
		v181.GamepadSensitivitySlider.ValueChanged:connect(function(p91) -- line: 2829
			-- upvalues: setCameraSensitivity (copy)
			local v980 = setCameraSensitivity
			local v981 = p91 <= 5 and 0.16 * p91 + 0.2 or 0.6 * p91 - 2

			v980(if not (v981 <= 0.2) then v981 else 0.2)
		end)
	end
	local function createOverscanOption() -- line: 2834
		-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy), Utility (copy), v181 (copy), Theme (copy), RunService (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
		local v546, v547, v548 = Utility:MakeStyledButton("AdjustButton", "Adjust", UDim2.new(0, 300, 1, -20), function() -- line: 2835
			-- upvalues: RobloxGui (copy), CorePackages (copy), ContextActionService (copy)
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)
			local Overscan = require(RobloxGui.Modules.Shell.Components.Overscan10ft.Overscan)
			local v984 = require(RobloxGui.Modules.Settings.Components.OverscanWrapper)(Overscan)
			local Roact = require(CorePackages.Packages.Roact)
			local u986 = nil
			local t29 = {
				onUnmount = function() -- line: 2846
					-- upvalues: u986 (ref), Roact (copy), ContextActionService (copy), SettingsHub (copy)
					if u986 then
						Roact.unmount(u986)
						ContextActionService:UnbindCoreAction("RbxStopOverscanMovement")
						SettingsHub:SetVisibility(true, true)
					end
				end,
				ImageVisible = false,
				BackgroundTransparency = 0.2
			}

			SettingsHub:SetVisibility(false, true)
			ContextActionService:BindCoreAction("RbxStopOverscanMovement", function() -- line: 2862
			end, false, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

			local v988 = Roact.createElement(v984, t29)

			u986 = Roact.mount(v988, RobloxGui, (tostring(v984)))
		end, v181)

		v547.Font = Theme.font(Enum.Font.SourceSans)
		v546.Position = UDim2.new(1, -400, 0, 12)
		v546.Size = UDim2.new(0, 300, 0, 40)
		v546.Position = UDim2.new(1, -400, 0.5, 0)
		v546.AnchorPoint = Vector2.new(0, 0.5)

		if RunService:IsStudio() then
			v546.Selectable = false
			v546.Active = false
			v546.Enabled.Value = false
			v547.TextColor3 = Color3.fromRGB(100, 100, 100)
		end

		local v549 = Utility:AddNewRowObject(v181, "Safe Zone", v546)

		v549.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.OverscanAdjustButton
		v548(v549)
	end
	local function createDeveloperConsoleOption() -- line: 2901
		-- upvalues: reportSettingsChangeForAnalytics (copy), v141 (copy), Utility (copy), v181 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), RunService (copy), PlayerPermissionsModule (copy), Players (copy)
		local function makeDevConsoleOption() -- line: 2903
			-- upvalues: reportSettingsChangeForAnalytics (copy), v141 (copy), Utility (copy), v181 (copy), Theme (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
			local function onOpenDevConsole() -- line: 2904
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

			if v141 then
				local v990, v991, v992 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(1, 0, 1, -20), onOpenDevConsole, v181)

				v991.Font = Theme.font(Enum.Font.SourceSans)
				v990.Size = UDim2.new(0.6, -10, 0, 35)
				v990.Position = UDim2.new(0.4, 10, 0.5, 0)
				v990.AnchorPoint = Vector2.new(0, 0.5)

				local v993 = Utility:AddNewRowObject(v181, "Developer Console", v990, nil, true)

				v993.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v992(v993)

				return
			end

			local v994, v995, v996 = Utility:MakeStyledButton("DevConsoleButton", "Open", UDim2.new(0, 300, 1, -20), onOpenDevConsole, v181)

			v995.Font = Theme.font(Enum.Font.SourceSans)
			v994.Size = UDim2.new(0.6, -10, 0, 35)
			v994.Position = UDim2.new(1, -400, 0.5, 0)
			v994.AnchorPoint = Vector2.new(0, 0.5)

			local v997 = Utility:AddNewRowObject(v181, "Developer Console", v994)

			v997.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
			v996(v997)
		end

		if RunService:IsStudio() then
			makeDevConsoleOption()

			return
		end

		spawn(function() -- line: 2956
			-- upvalues: PlayerPermissionsModule (copy), Players (copy), makeDevConsoleOption (copy)
			if PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer) then
				makeDevConsoleOption()
			end
		end)
	end
	local function createUiToggleOptions() -- line: 2965
		-- upvalues: v140 (copy), v139 (copy), RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GuiService (copy), LocalPlayer (copy)
		if v140 or v139 then
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
			local v552 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
			local v553 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

			v181.uiToggleSelectors = {}

			for __, v555 in t30 do
				local v556 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.ShowGuiType", {
					GuiType = v555.label
				})
				local v557, v558, v559 = Utility:AddNewRow(v181, v556, "Selector", {
					v552,
					v553
				}, 1)

				v557.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER[v555.layoutOrderKey]
				v559.IndexChanged:Connect(function(p92) -- line: 2993
					-- upvalues: GuiService (copy), v555 (copy)
					if p92 ~= (not GuiService:GetGuiIsVisible(v555.type) and 2 or 1) then
						GuiService:ToggleGuiIsVisibleIfAllowed(v555.type)
					end
				end)
				v181.uiToggleSelectors[v555.label] = {
					label = v556,
					type = v555.type,
					row = v557,
					frame = v558,
					selector = v559
				}
			end

			local v560 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.Freecam")
			local v561 = v181
			local v562 = v181
			local v563 = v181
			local v564, v565, v566 = Utility:AddNewRow(v181, v560, "Selector", {
				v553,
				v552
			}, 1)

			v561.freecamRow = v564
			v562.freecamFrame = v565
			v563.freecamSelector = v566
			v181.freecamRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FreecamToggleRow
			v181.freecamSelector.IndexChanged:Connect(function(p93) -- line: 3015
				-- upvalues: LocalPlayer (copy)
				local v1000 = p93 == 2
				local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

				if not FreecamScript then
					warn("Freecam not present")

					return
				end

				FreecamScript:SetAttribute("FreecamEnabled", v1000)
			end)

			return
		end

		local v567 = v181
		local v568 = v181
		local v569 = v181
		local v570, v571, v572 = Utility:AddNewRow(v181, "BillboardGui Visibility", "Selector", {
			"All visible",
			"Hide nameplates/bubble chat"
		}, 1)

		v567.uiToggleRow = v570
		v568.uiToggleFrame = v571
		v569.uiToggleSelector = v572
		v181.uiToggleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiToggleRow
		v181.uiToggleSelector.IndexChanged:connect(function(__) -- line: 3034
			-- upvalues: GuiService (copy)
			GuiService:ToggleGuiIsVisibleIfAllowed(Enum.GuiType.PlayerNameplates)
		end)
	end
	local function updateUiToggleSelection() -- line: 3040
		-- upvalues: v140 (copy), v139 (copy), v181 (copy), GuiService (copy), LocalPlayer (copy)
		if v140 or v139 then
			if not v181.uiToggleSelectors then
				return
			end

			for __, v574 in v181.uiToggleSelectors do
				local v575 = not GuiService:GetGuiIsVisible(v574.type) and 2 or 1

				if v575 ~= v574.selector:GetSelectedIndex() then
					v574.selector:SetSelectionIndex(v575)
				end
			end

			local FreecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

			if FreecamScript then
				local v577 = not FreecamScript:GetAttribute("FreecamEnabled") and 1 or 2

				v181.freecamSelector:SetSelectionIndex(v577)

				return
			end
		else
			if not v181.uiToggleSelector then
				return
			end

			local v578 = not GuiService:GetGuiIsVisible(Enum.GuiType.PlayerNameplates) and 2 or 1

			if v578 == v181.uiToggleSelector:GetSelectedIndex() then
				return
			end

			v181.uiToggleSelector:SetSelectionIndex(v578)
		end
	end
	local function isValidDeviceList(p95, p96, p97) -- line: 3082
		return p95 and (p96 and (p97 and (#p95 > 0 and (p97 > 0 and (p97 <= #p95 and #p95 == #p96)))))
	end
	local function SwitchOutputDevice(p98, p99) -- line: 3095
		-- upvalues: SoundService (copy), v126 (copy)
		SoundService:SetOutputDevice(p98, p99)
		v126:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", p98, p99)
	end
	local function createDeviceOptions(p100) -- line: 3100
		-- upvalues: v181 (copy), RobloxTranslator (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFIntVoiceChatDeviceChangeDebounceDelay (copy), default3 (copy), SoundService (copy), v126 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
		local v585 = v181[p100 .. "DeviceIndex"] or 0
		local v586 = v181[p100 .. "DeviceNames"] or {}
		local v587 = v181[p100 .. "DeviceGuids"] or {}
		local v588 = p100 == "Input" and RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.InputDevice") or RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.OutputDevice")
		local v589 = v181
		local v590 = p100 .. "DeviceFrame"
		local v591 = v181
		local v592 = p100 .. "DeviceSelector"
		local v593, v594, v595 = Utility:AddNewRow(v181, v588, "Selector", v586, v585)

		v589[v590] = v593
		_ = v594
		v591[v592] = v595
		v181[p100 .. "DeviceFrame"].LayoutOrder = p100 == "Input" and SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameInput or SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameOutput
		v181[p100 .. "DeviceInfo"] = {
			Name = v585 > 0 and v586[v585] or nil,
			Guid = v585 > 0 and v587[v585] or nil
		}
		v181[p100 .. "PrevDeviceName"] = v181[p100 .. "DeviceInfo"].Name

		local n12 = 0
		local v597 = GetFIntVoiceChatDeviceChangeDebounceDelay()

		v181[p100 .. "DeviceSelector"].IndexChanged:connect(function(p101) -- line: 3123
			-- upvalues: v181 (copy), p100 (copy), n12 (ref), v597 (copy), default3 (copy), SoundService (copy), v126 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), reportSettingsChangeForAnalytics (copy)
			if v181[p100 .. "DeviceInfo"].Name == v181[p100 .. "DeviceNames"][p101] and v181[p100 .. "DeviceInfo"].Guid == v181[p100 .. "DeviceGuids"][p101] then
				return
			end

			local v1004 = n12 + 1

			n12 = v1004
			wait(v597)

			if v1004 == n12 then
				n12 = 0
				v181[p100 .. "DeviceInfo"] = {
					Name = v181[p100 .. "DeviceNames"][p101],
					Guid = v181[p100 .. "DeviceGuids"][p101]
				}

				local Name = v181[p100 .. "DeviceInfo"].Name
				local Guid = v181[p100 .. "DeviceInfo"].Guid

				if v181.VoiceChatOptionsEnabled then
					default3:SwitchDevice(p100, Name, Guid)
				else
					SoundService:SetOutputDevice(Name, Guid)
					v126:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", Name, Guid)
				end

				if GetFFlagEnableCrossExpVoice() then
					v126:debug("[GameSettings] Changing {} device to {} {} ", p100, Name, Guid)

					if p100 == "Input" then
						default4:changeInputDevice(Name, Guid)
					else
						default4:changeOutputDevice(Name, Guid)
					end
				end

				reportSettingsChangeForAnalytics(p100, v181[p100 .. "PrevDeviceName"], Name)
				v181[p100 .. "PrevDeviceName"] = Name
			end
		end)
	end
	local function createBadgeVisibilityOptions() -- line: 3165
		-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v149 (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
		spawn(function() -- line: 3166
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v149 (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n13 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n13 = 1
			end

			local v1008 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v1009 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v1010 = if not v149 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v1011 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v1012 = v181
			local v1013 = v181
			local v1014 = v181
			local v1015, v1016, v1017 = Utility:AddNewRow(v181, v1010, "Selector", {
				v1009,
				v1008
			}, n13, nil, v1011)

			v1012.badgeVisibleRow = v1015
			v1013.badgeVisibleFrame = v1016
			v1014.badgeVisibleSelector = v1017
			v181.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v181.badgeVisibleSelector.IndexChanged:connect(function(p102) -- line: 3180
				-- upvalues: GameSettings (copy), PlayerPermissionsModule (copy), LocalPlayer (copy)
				GameSettings.BadgeVisible = p102 == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p102 == 1)
			end)
		end)
	end
	local function createChatModerationOptions() -- line: 3187
		-- upvalues: v181 (copy), Utility (copy), u24 (ref), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), Signals (copy), reportSettingsChangeForAnalytics (copy)
		local __ = {
			title = "CoreScripts.InGameMenu.GameSettings.ReadOnlyView",
			description = "CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}
		local v599 = v181
		local v600 = v181
		local v601, v602, v603 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyView"), "Selector", {
			u24:Format("InGame.CommonUI.Label.Off"),
			u24:Format("InGame.CommonUI.Label.On")
		}, 1, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription"))

		v599.ChatModerationFrame = v601
		_ = v602
		v600.ChatModerationSelector = v603
		v181.ChatModerationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatModerationFrame
		v181.ChatModerationFrame.Visible = false

		local v604 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetChatModerationStore(false)

		v181.ChatModerationDisposeEffect = Signals.createEffect(function(p103) -- line: 3211
			-- upvalues: v181 (copy), v604 (copy)
			v181.ChatModerationFrame.Visible = v604.getIsSettingVisible(p103)

			local v1019 = not v604.getIsSettingEnabled(p103) and 1 or 2

			if v1019 ~= v181.ChatModerationSelector:GetSelectedIndex() then
				v181.ChatModerationSelector:SetSelectionIndex(v1019)
			end
		end)
		v181.ChatModerationSelector.IndexChanged:connect(function(p104) -- line: 3220
			-- upvalues: v604 (copy), reportSettingsChangeForAnalytics (copy)
			local v1021 = p104 == 2

			v604.setIsSettingEnabled(v1021)
			reportSettingsChangeForAnalytics("moderate_chat", not v1021, v1021)
		end)
		v604.initialize()
	end
	local function createAIRephraseSettingOptions() -- line: 3229
		-- upvalues: RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceAIRephraseSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy), v150 (copy), ThrottleFunctionCall (copy)
		local v605 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessages")
		local v606 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessagesDescription")
		local v607 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v608 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v609 = v181
		local v610 = v181
		local v611, v612, v613 = Utility:AddNewRow(v181, v605, "Selector", {
			v608,
			v607
		}, 1, nil, v606)

		v609.AIRephraseFrame = v611
		_ = v612
		v610.AIRephraseSelector = v613
		v181.AIRephraseFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AIRephraseFrame
		v181.AIRephraseFrame.Visible = false

		local v614 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getAIRephraseSettingStore(false)
		local v615 = GetFIntDebounceAIRephraseSettingDelay()
		local v616 = v615 > 0
		local u617 = not v614.getIsSettingEnabled(false) and 1 or 2

		v181.AIRephraseDisposeEffect = Signals.createEffect(function(p105) -- line: 3255
			-- upvalues: v181 (copy), v614 (copy), u617 (ref)
			v181.AIRephraseFrame.Visible = v614.getIsSettingVisible(p105)

			local v1023 = not v614.getIsSettingEnabled(p105) and 1 or 2

			if v1023 ~= v181.AIRephraseSelector:GetSelectedIndex() then
				u617 = v1023
				v181.AIRephraseSelector:SetSelectionIndex(v1023)
			end
		end)

		local function v618(p106) -- line: 3266
			-- upvalues: u617 (ref), TextChatService (copy), v614 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
			if p106 == u617 then
				return
			end

			local v1025 = p106 == 2

			task.spawn(function() -- line: 3272
				-- upvalues: TextChatService (copy), v1025 (copy), v614 (copy), u617 (ref), p106 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
				if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1025 and "Disabled" or "Enabled") then
					v614.setIsSettingEnabled(v1025)
					u617 = p106
					reportSettingsChangeForAnalytics("ai_rephrase", not v1025, v1025)

					return
				end

				v181.AIRephraseSelector:SetSelectionIndex(u617)
			end)
		end

		if v150 then
			if v616 then
				local u619 = nil

				v181.AIRephraseSelector.IndexChanged:connect(function(p107) -- line: 3289
					-- upvalues: u619 (ref), v615 (copy), u617 (ref), TextChatService (copy), v614 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
					if u619 then
						task.cancel(u619)
					end

					u619 = task.delay(v615, function() -- line: 3293
						-- upvalues: u619 (ref), p107 (copy), u617 (ref), TextChatService (copy), v614 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
						u619 = nil

						local v1149 = p107

						if v1149 == u617 then
							return
						end

						local v1150 = v1149 == 2

						task.spawn(function() -- line: 3272
							-- upvalues: TextChatService (copy), v1150 (copy), v614 (copy), u617 (ref), v1149 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
							if TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", not v1150 and "Disabled" or "Enabled") then
								v614.setIsSettingEnabled(v1150)
								u617 = v1149
								reportSettingsChangeForAnalytics("ai_rephrase", not v1150, v1150)

								return
							end

							v181.AIRephraseSelector:SetSelectionIndex(u617)
						end)
					end)
				end)
			else
				v181.AIRephraseSelector.IndexChanged:connect(v618)
			end
		else
			v181.AIRephraseSelector.IndexChanged:connect(if not v616 then v618 else ThrottleFunctionCall(v615, v618))
		end
	end
	local function createChatSummariesSettingOptions() -- line: 3306
		-- upvalues: RobloxTranslator (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), CorePackages (copy), GetFIntDebounceChatSummariesSettingDelay (copy), Signals (copy), TextChatService (copy), reportSettingsChangeForAnalytics (copy)
		local v620 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummaries")
		local v621 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummariesDescription")
		local v622 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local v623 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		local v624 = v181
		local v625 = v181
		local v626, v627, v628 = Utility:AddNewRow(v181, v620, "Selector", {
			v623,
			v622
		}, 1, nil, v621)

		v624.ChatSummariesFrame = v626
		_ = v627
		v625.ChatSummariesSelector = v628
		v181.ChatSummariesFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatSummariesFrame
		v181.ChatSummariesFrame.Visible = false

		local v629 = require(CorePackages.Workspace.Packages.ExpChat).Stores.GetUserChatSettingsStore.getChatSummariesSettingStore(false)
		local v630 = GetFIntDebounceChatSummariesSettingDelay()
		local v631 = v630 > 0
		local u632 = not v629.getIsSettingEnabled(false) and 1 or 2

		v181.ChatSummariesDisposeEffect = Signals.createEffect(function(p108) -- line: 3332
			-- upvalues: v181 (copy), v629 (copy), u632 (ref)
			v181.ChatSummariesFrame.Visible = v629.getIsSettingVisible(p108)

			local v1028 = not v629.getIsSettingEnabled(p108) and 1 or 2

			if v1028 ~= v181.ChatSummariesSelector:GetSelectedIndex() then
				u632 = v1028
				v181.ChatSummariesSelector:SetSelectionIndex(v1028)
			end
		end)

		if v631 then
			local u633 = nil

			v181.ChatSummariesSelector.IndexChanged:connect(function(p109) -- line: 3365
				-- upvalues: u633 (ref), v630 (copy), u632 (ref), TextChatService (copy), v629 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
				if u633 then
					task.cancel(u633)
				end

				u633 = task.delay(v630, function() -- line: 3369
					-- upvalues: u633 (ref), p109 (copy), u632 (ref), TextChatService (copy), v629 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
					u633 = nil

					local v1151 = p109

					if v1151 == u632 then
						return
					end

					local v1152 = v1151 == 2

					task.spawn(function() -- line: 3349
						-- upvalues: TextChatService (copy), v1152 (copy), v629 (copy), u632 (ref), v1151 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
						if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1152 and "Disabled" or "Enabled") then
							v629.setIsSettingEnabled(v1152)
							u632 = v1151
							reportSettingsChangeForAnalytics("chat_summaries", not v1152, v1152)

							return
						end

						v181.ChatSummariesSelector:SetSelectionIndex(u632)
					end)
				end)
			end)
		else
			v181.ChatSummariesSelector.IndexChanged:connect(function(p110) -- line: 3343
				-- upvalues: u632 (ref), TextChatService (copy), v629 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
				if p110 == u632 then
					return
				end

				local v1030 = p110 == 2

				task.spawn(function() -- line: 3349
					-- upvalues: TextChatService (copy), v1030 (copy), v629 (copy), u632 (ref), p110 (copy), reportSettingsChangeForAnalytics (copy), v181 (copy)
					if TextChatService:OnUserChatSettingUpdateAsync("AllowThirdPartySummary", not v1030 and "Disabled" or "Enabled") then
						v629.setIsSettingEnabled(v1030)
						u632 = p110
						reportSettingsChangeForAnalytics("chat_summaries", not v1030, v1030)

						return
					end

					v181.ChatSummariesSelector:SetSelectionIndex(u632)
				end)
			end)
		end
	end
	local function createCameraDeviceOptions() -- line: 3382
		-- upvalues: v181 (copy), v125 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v126 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
		local v634 = v181.CameraDeviceIndex or 1
		local v635 = v181.CameraDeviceNames or {}
		local v636 = v181.CameraDeviceGuids or {}
		local v637 = v125
		local v638 = v181
		local v639 = v181
		local v640, v641, v642 = Utility:AddNewRow(v181, v637, "Selector", v635, v634)

		v638.CameraDeviceFrame = v640
		_ = v641
		v639.CameraDeviceSelector = v642
		v181.CameraDeviceFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraDeviceFrame
		v181.CameraDeviceInfo = {
			Name = v634 > 0 and v635[v634] or nil,
			Guid = v634 > 0 and v636[v634] or nil
		}
		v181.prevCameraDeviceName = v181.CameraDeviceInfo.Name
		v181.CameraDeviceSelector.IndexChanged:connect(function(p111) -- line: 3399
			-- upvalues: v181 (copy), v126 (copy), UserGameSettings (copy), reportSettingsChangeForAnalytics (copy)
			if v181.CameraDeviceInfo.Name == v181.CameraDeviceNames[p111] and v181.CameraDeviceInfo.Guid == v181.CameraDeviceGuids[p111] then
				return
			end

			v181.CameraDeviceInfo = {
				Name = v181.CameraDeviceNames[p111],
				Guid = v181.CameraDeviceGuids[p111]
			}

			local Guid = v181.CameraDeviceInfo.Guid

			v126:info("Changed webcam to: {}", Guid)
			UserGameSettings.DefaultCameraID = Guid
			reportSettingsChangeForAnalytics("video_camera", v181.prevCameraDeviceName or "None", v181.CameraDeviceInfo.Name)
			v181.prevCameraDeviceName = v181.CameraDeviceInfo.Name
		end)
	end
	local function updateAudioDevices(p112) -- line: 3424
		-- upvalues: SoundService (copy), u24 (ref), v181 (copy), GetFFlagVoiceChatUILogging (copy), v126 (copy), createDeviceOptions (copy)
		local ok, result, v646, v647 = pcall(function() -- line: 3425
			-- upvalues: p112 (copy), SoundService (copy)
			if p112 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v646 and (v647 and (#result > 0 and (v647 > 0 and (v647 <= #result and #result == #v646)))))) then
			if v646[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v181[p112 .. "DeviceNames"] = result
			v181[p112 .. "DeviceGuids"] = v646
			v181[p112 .. "DeviceIndex"] = v647
		else
			if GetFFlagVoiceChatUILogging() then
				v126:warning("Errors in get {} device info", p112)
			end

			v181[p112 .. "DeviceNames"] = {}
			v181[p112 .. "DeviceGuids"] = {}
			v181[p112 .. "DeviceIndex"] = 0
		end

		if not v181[p112 .. "DeviceSelector"] then
			createDeviceOptions(p112)

			return
		end

		v181[p112 .. "DeviceSelector"]:UpdateOptions(result)
		v181[p112 .. "DeviceSelector"]:SetSelectionIndex(v647)
	end
	local function updateVoiceChatDevices(p113) -- line: 3457
		-- upvalues: GetFFlagVoiceChatUILogging (copy), v126 (copy), SoundService (copy), u24 (ref), v181 (copy), createDeviceOptions (copy)
		if p113 ~= "Input" and (p113 ~= "Output" and GetFFlagVoiceChatUILogging()) then
			v126:warning("{} is not supported in VoiceChat devices", p113)
		end

		local ok, result, v651, v652 = pcall(function() -- line: 3464
			-- upvalues: p113 (copy), SoundService (copy)
			if p113 == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if ok and (result and (v651 and (v652 and (#result > 0 and (v652 > 0 and (v652 <= #result and #result == #v651)))))) then
			if v651[1] == "" then
				result[1] = u24:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
			end

			v181[p113 .. "DeviceNames"] = result
			v181[p113 .. "DeviceGuids"] = v651
			v181[p113 .. "DeviceIndex"] = v652
		else
			if GetFFlagVoiceChatUILogging() then
				if #result > 0 then
					v126:warning("Errors in get {} device info success: {}", p113, ok)
				else
					v126:warning("Empty deviceNames list for {}", p113)
				end
			end

			v181[p113 .. "DeviceNames"] = {}
			v181[p113 .. "DeviceGuids"] = {}
			v181[p113 .. "DeviceIndex"] = 0
		end

		if not v181[p113 .. "DeviceSelector"] then
			createDeviceOptions(p113)
		else
			v181[p113 .. "DeviceSelector"]:UpdateOptions(result)
			v181[p113 .. "DeviceSelector"]:SetSelectionIndex(v652)
		end

		if v181[p113 .. "DeviceFrame"] then
			if #result > 0 then
				v181[p113 .. "DeviceFrame"].Visible = true

				return
			end

			v181[p113 .. "DeviceFrame"].Visible = false
		end
	end
	local function updateCameraDevices() -- line: 3516
		-- upvalues: VideoCaptureService (copy), v124 (copy), UserGameSettings (copy), v181 (copy), createCameraDeviceOptions (copy)
		local CameraDevices = VideoCaptureService:GetCameraDevices()
		local t31 = {}
		local t32 = {}
		local n14 = 1

		table.insert(t31, v124)
		table.insert(t32, "{DefaultDeviceGuid}")

		for k, v in pairs(CameraDevices) do
			if k == UserGameSettings.DefaultCameraID then
				n14 = #t31 + 1
			end

			table.insert(t31, v)
			table.insert(t32, k)
		end

		v181.CameraDeviceNames = t31
		v181.CameraDeviceGuids = t32
		v181.CameraDeviceIndex = 0

		if not v181.CameraDeviceSelector then
			createCameraDeviceOptions()
		else
			v181.CameraDeviceSelector:UpdateOptions(t31)
		end

		v181.CameraDeviceSelector:SetSelectionIndex(n14)
	end

	local connection = nil
	local connection2 = nil

	local function updateAudioOptions() -- line: 3546
		-- upvalues: v181 (copy), updateVoiceChatDevices (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), updateAudioDevices (copy)
		if v181.VoiceChatOptionsEnabled then
			updateVoiceChatDevices("Input")
			updateVoiceChatDevices("Output")

			return
		end

		if GetFFlagEnableCrossExpVoice() and default4:getIsConnected() then
			updateAudioDevices("Input")
		end

		updateAudioDevices("Output")
	end
	local function setupDeviceChangedListener() -- line: 3558
		-- upvalues: SoundService (copy), connection (ref), v181 (copy), updateAudioOptions (copy)
		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3560
				-- upvalues: v181 (copy), updateAudioOptions (copy)
				if v181.PageOpen then
					updateAudioOptions()
				end
			end)
		end
	end
	local function setupVideoCameraDeviceChangedListener() -- line: 3568
		-- upvalues: VideoCaptureService (copy), connection2 (ref), v181 (copy), updateCameraDevices (copy)
		if VideoCaptureService.DevicesChanged then
			connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3570
				-- upvalues: v181 (copy), updateCameraDevices (copy)
				if v181.PageOpen then
					updateCameraDevices()
				end
			end)
		end
	end
	local function teardownDeviceChangedListener() -- line: 3578
		-- upvalues: SoundService (copy), connection (ref)
		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end
	end
	local function teardownVideoCameraDeviceChangedListener() -- line: 3584
		-- upvalues: VideoCaptureService (copy), connection2 (ref)
		if VideoCaptureService.DevicesChanged and connection2 then
			connection2:Disconnect()
			connection2 = nil
		end
	end
	local function checkVoiceChatOptions() -- line: 3592
		-- upvalues: default3 (copy), v181 (copy)
		if default3:VoiceChatAvailable() then
			v181.VoiceChatOptionsEnabled = true
		end
	end
	local function updateInputDeviceVisibility() -- line: 3598
		-- upvalues: v181 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy)
		local v659 = v181.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

		if v181.InputDeviceFrame then
			v181.InputDeviceFrame.Visible = v659
		end
	end

	local u234 = false
	local u235 = nil

	if v59 then
		u235 = false
	end

	local function createVoiceChatSelector() -- line: 3611
		-- upvalues: v58 (copy), v181 (copy), v52 (copy), u24 (ref), default3 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), v59 (copy), GetFIntDebounceDisconnectButtonDelay (copy), u235 (ref), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), v66 (copy), u234 (ref), ThrottleFunctionCall (copy), v55 (copy), GuiService (copy), v65 (copy), v60 (copy)
		if v58 and (v181.VoiceConnectDisconnectFrame and v181.VoiceConnectDisconnectSelector) then
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

		local v663 = not default3:VoiceChatEnded() and 2 or 1
		local v664 = v181
		local v665 = v181
		local v666, v667, v668 = Utility:AddNewRow(v181, s15, "Selector", {
			s16,
			s17
		}, v663)

		v664.VoiceConnectDisconnectFrame = v666
		_ = v667
		v665.VoiceConnectDisconnectSelector = v668
		v181.VoiceConnectDisconnectFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectDisconnectSelector

		local v669 = default3:getService()

		if v669 and not v59 then
			v669.StateChanged:Connect(function(oldState, newState) -- line: 3636
				-- upvalues: v58 (copy), v181 (copy), default3 (copy)
				if v58 then
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined and v181.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if (newState == Enum.VoiceChatState.Ended or newState == Enum.VoiceChatState.Failed or newState == Enum.VoiceChatState.Idle) and v181.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

						return
					end
				else
					if oldState == newState then
						return
					end

					if newState == Enum.VoiceChatState.Joined then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

						return
					end

					if default3:VoiceChatEnded() then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end
			end)
		end

		local u670 = v663
		local v671 = GetFIntDebounceDisconnectButtonDelay()
		local v672 = v671 > 0

		local function v673(p114) -- line: 3670
			-- upvalues: u670 (ref), v59 (copy), u235 (ref), FFlagVoiceRewarmTelemetry (copy), default3 (copy), Constants2 (copy), v66 (copy), u234 (ref), v181 (copy)
			if p114 == u670 then
				return
			end

			u670 = p114

			if v59 and u235 then
				return
			end

			if FFlagVoiceRewarmTelemetry then
				local v1037, v1038, v1039, v1040 = default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2)

				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1037, v1038, v1039, v1040, default3.joinVoiceButtonContext)
			else
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(p114 == 2))
			end

			if p114 == 2 then
				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			elseif v66 then
				local v1041 = default3:getService()
				local v1042 = v1041 ~= nil and v1041.VoiceChatState == Enum.VoiceChatState.Failed

				if not default3:VoiceChatEnded() and not v1042 then
					default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
					default3:Leave()
				end
			elseif not default3:VoiceChatEnded() then
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			if u234 then
				task.spawn(function() -- line: 3714
					-- upvalues: p114 (copy), v181 (copy)
					task.wait(0.5)

					if p114 ~= 1 then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end)
			end
		end

		v181.VoiceConnectDisconnectSelector.IndexChanged:connect(if not v672 then v673 else ThrottleFunctionCall(v671, v673))

		if v55 then
			v181.VoiceConnectDisconnectFrame.SelectionChanged:Connect(function(__, p116, p117) -- line: 3728
				-- upvalues: s15 (ref), v181 (copy), GuiService (copy)
				if p117 and (p116 and p116.Parent and p116.Parent.Name == s15 .. "Frame" and p117.Name == "ImageButton" and v181.Active) then
					GuiService.SelectedCoreObject = p116
				end
			end)
		end

		default3:subscribe("OnStateChanged", function(__, p119) -- line: 3735
			-- upvalues: v59 (copy), u235 (ref), v65 (copy), v181 (copy), v60 (copy)
			if v59 then
				u235 = true

				if v65 then
					if p119 == Enum.VoiceChatState.Joined and v181.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2 then
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					end
				elseif p119 == Enum.VoiceChatState.Joined then
					v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
				end
			end

			if v65 then
				if p119 == Enum.VoiceChatState.Failed and v181.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1 then
					v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
				end
			elseif p119 == Enum.VoiceChatState.Failed then
				v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
			end

			if v59 then
				if v60 then
					task.defer(function() -- line: 3767
						-- upvalues: u235 (ref)
						u235 = false
					end)

					return
				end

				u235 = false
			end
		end)
		default3:subscribe("OnRequestMicPermissionRejected", function() -- line: 3776
			-- upvalues: u234 (ref), v59 (copy), u235 (ref), v181 (copy), v60 (copy)
			task.spawn(function() -- line: 3777
				-- upvalues: u234 (ref), v59 (copy), u235 (ref), v181 (copy), v60 (copy)
				task.wait(0.5)
				u234 = true

				if v59 then
					u235 = true
				end

				v181.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

				if v59 then
					if v60 then
						task.defer(function() -- line: 3786
							-- upvalues: u235 (ref)
							u235 = false
						end)

						return
					end

					u235 = false
				end
			end)
		end)
	end
	local function createVoiceConnectDisconnect() -- line: 3797
		-- upvalues: default3 (copy), u24 (ref), GetFIntDebounceDisconnectButtonDelay (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy), Utility (copy), ThrottleFunctionCall (copy), v181 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy)
		if default3:IsSeamlessVoice() and not default3.isShowingFTUX then
			local v674 = u24:Format("Feature.GameDetails.Label.VoiceChat")
			local v675 = u24:Format("Feature.SettingsHub.Label.Connect")
			local v676 = u24:Format("Feature.SettingsHub.Label.Disconnect")
			local v677 = GetFIntDebounceDisconnectButtonDelay()
			local v678 = v677 > 0

			local function v679() -- line: 3807
				-- upvalues: default3 (copy), FFlagVoiceRewarmTelemetry (copy), Constants2 (copy)
				if default3:getService() then
					local connection3 = nil

					connection3 = default3:getService().StateChanged:Connect(function(__, newState) -- line: 3811
						-- upvalues: FFlagVoiceRewarmTelemetry (copy), default3 (copy), connection3 (ref)
						if newState == Enum.VoiceChatState.Joined then
							if FFlagVoiceRewarmTelemetry then
								local v1155, v1156, v1157, v1158 = default3:GetConnectDisconnectButtonAnalyticsData(true)

								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1155, v1156, v1157, v1158, default3.joinVoiceButtonContext)
							else
								default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
							end

							connection3:Disconnect()
						end
					end)
				elseif FFlagVoiceRewarmTelemetry then
					local v1049, v1050, v1051, v1052 = default3:GetConnectDisconnectButtonAnalyticsData(false)

					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", v1049, v1050, v1051, v1052, default3.joinVoiceButtonContext)
				else
					default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("clicked", default3:GetConnectDisconnectButtonAnalyticsData(false))
				end

				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			end
			local function v680() -- line: 3844
				-- upvalues: default3 (copy), Constants2 (copy)
				default3.Analytics:reportLeaveVoiceButtonEvent("clicked", default3:GetConnectDisconnectButtonAnalyticsData(true))
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			local v681, v682, v683 = Utility:MakeStyledButton("VoiceConnectButton", v675, UDim2.new(1, 0, 1, -20), if not v678 then v679 else ThrottleFunctionCall(v677, v679), v181)

			voiceConnectSetRowRef = v683

			local v684, v685, v686 = Utility:MakeStyledButton("VoiceDisconnectButton", v676, UDim2.new(1, 0, 1, -20), if not v678 then v680 else ThrottleFunctionCall(v677, v680), v181)

			voiceDisconnectSetRowRef = v686
			v681.Size = UDim2.new(0.6, 0, 0, 40)
			v681.Position = UDim2.new(0.4, 0, 0.5, 0)
			v681.AnchorPoint = Vector2.new(0, 0.5)
			v681.ZIndex = 2
			v681.Selectable = true
			v682.ZIndex = 2
			v684.Size = UDim2.new(0.6, 0, 0, 40)
			v684.Position = UDim2.new(0.4, 0, 0.5, 0)
			v684.AnchorPoint = Vector2.new(0, 0.5)
			v684.ZIndex = 2
			v684.Selectable = true
			v685.ZIndex = 2

			local v687 = Utility:AddNewRowObject(v181, v674, v681, nil, true)
			local v688 = Utility:AddNewRowObject(v181, v674, v684, nil, true)

			v181.VoiceConnectFrame = v687
			v181.VoiceDisconnectFrame = v688
			v687.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectFrame
			v688.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceDisconnectFrame
			voiceConnectSetRowRef(v687)
			voiceDisconnectSetRowRef(v688)

			if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and isVoiceFocused() then
				v687.Visible = false
				v688.Visible = false

				return
			end

			if default3:ShouldShowJoinVoice() then
				v687.Visible = true
				v688.Visible = false

				return
			end

			v687.Visible = false
			v688.Visible = true
		end
	end
	local function createVRComfortSettingOptions() -- line: 3907
		-- upvalues: u24 (ref), GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
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

		local v694 = table.find(EnumItems, GameSettings.VRComfortSetting)
		local v695 = v181
		local v696 = v181
		local v697 = v181
		local v698, v699, v700 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.PageTitle.VRComfortSettings"), "Selector", t34, v694, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription"))

		v695.VRComfortSettingFrame = v698
		v696.VRComfortSettingLabel = v699
		v697.VRComfortSettingSelector = v700
		v181.VRComfortSettingFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRComfortSettingFrame

		local v701 = not GameSettings.VignetteEnabled and 2 or 1
		local v702 = v181
		local v703 = v181
		local v704 = v181
		local v705, v706, v707 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.GameSettings.VignetteEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v701)

		v702.VRVignetteEnabledFrame = v705
		v703.VRVignetteEnabledLabel = v706
		v704.VRVignetteEnabledSelector = v707
		v181.VRVignetteEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRVignetteEnabledFrame

		local v708 = not GameSettings.VRSmoothRotationEnabled and 1 or 2
		local v709 = v181
		local v710 = v181
		local v711 = v181
		local v712, v713, v714 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v708)

		v709.VRSteppedRotationEnabledFrame = v712
		v710.VRSteppedRotationEnabledLabel = v713
		v711.VRSteppedRotationEnabledSelector = v714
		v181.VRSteppedRotationEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSteppedRotationEnabledFrame

		local v715 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2
		local v716 = v181
		local v717 = v181
		local v718 = v181
		local v719, v720, v721 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled"), "Selector", {
			u24:Format("InGame.CommonUI.Label.On"),
			u24:Format("InGame.CommonUI.Label.Off")
		}, v715)

		v716.VRThirdPersonFixedCamEnabledFrame = v719
		v717.VRThirdPersonFixedCamEnabledLabel = v720
		v718.VRThirdPersonFixedCamEnabledSelector = v721
		v181.VRThirdPersonFixedCamEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRThirdPersonFixedCamEnabledFrame

		local function v722(p121) -- line: 3973
			-- upvalues: v181 (copy)
			if p121 == Enum.VRComfortSetting.Custom then
				v181.VRVignetteEnabledSelector:SetZIndex(2)
				v181.VRVignetteEnabledLabel.ZIndex = 2
				v181.VRVignetteEnabledSelector:SetInteractable(true)
				v181.VRSteppedRotationEnabledSelector:SetZIndex(2)
				v181.VRSteppedRotationEnabledLabel.ZIndex = 2
				v181.VRSteppedRotationEnabledSelector:SetInteractable(true)
				v181.VRThirdPersonFixedCamEnabledSelector:SetZIndex(2)
				v181.VRThirdPersonFixedCamEnabledLabel.ZIndex = 2
				v181.VRThirdPersonFixedCamEnabledSelector:SetInteractable(true)

				return
			end

			v181.VRVignetteEnabledSelector:SetZIndex(1)
			v181.VRVignetteEnabledLabel.ZIndex = 1
			v181.VRVignetteEnabledSelector:SetInteractable(false)
			v181.VRSteppedRotationEnabledSelector:SetZIndex(1)
			v181.VRSteppedRotationEnabledLabel.ZIndex = 1
			v181.VRSteppedRotationEnabledSelector:SetInteractable(false)
			v181.VRThirdPersonFixedCamEnabledSelector:SetZIndex(1)
			v181.VRThirdPersonFixedCamEnabledLabel.ZIndex = 1
			v181.VRThirdPersonFixedCamEnabledSelector:SetInteractable(false)
		end

		v181.VRComfortSettingSelector.IndexChanged:connect(function(p122) -- line: 3997
			-- upvalues: EnumItems (copy), GameSettings (copy), v722 (copy)
			local v1055 = EnumItems[p122]

			GameSettings.VRComfortSetting = v1055
			v722(v1055)
		end)
		v722(GameSettings.VRComfortSetting)
		v181.VRVignetteEnabledSelector.IndexChanged:connect(function(p123) -- line: 4004
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VignetteEnabledCustomOption = p123 == 1
			end
		end)
		v181.VRSteppedRotationEnabledSelector.IndexChanged:connect(function(p124) -- line: 4010
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRSmoothRotationEnabledCustomOption = p124 == 2
			end
		end)
		v181.VRThirdPersonFixedCamEnabledSelector.IndexChanged:connect(function(p125) -- line: 4016
			-- upvalues: GameSettings (copy)
			if GameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				GameSettings.VRThirdPersonFollowCamEnabledCustomOption = p125 == 2
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function() -- line: 4022
			-- upvalues: EnumItems (copy), GameSettings (copy), v181 (copy)
			local v1059 = table.find(EnumItems, GameSettings.VRComfortSetting)

			if v1059 ~= v181.VRComfortSettingSelector:GetSelectedIndex() then
				v181.VRComfortSettingSelector:SetSelectionIndex(v1059)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function() -- line: 4029
			-- upvalues: GameSettings (copy), v181 (copy)
			local v1060 = not GameSettings.VignetteEnabled and 2 or 1

			if v1060 ~= v181.VRVignetteEnabledSelector:GetSelectedIndex() then
				v181.VRVignetteEnabledSelector:SetSelectionIndex(v1060)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function() -- line: 4036
			-- upvalues: GameSettings (copy), v181 (copy)
			local v1061 = not GameSettings.VRSmoothRotationEnabled and 1 or 2

			if v1061 ~= v181.VRSteppedRotationEnabledSelector:GetSelectedIndex() then
				v181.VRSteppedRotationEnabledSelector:SetSelectionIndex(v1061)
			end
		end)
		GameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function() -- line: 4043
			-- upvalues: GameSettings (copy), v181 (copy)
			local v1062 = not GameSettings.VRThirdPersonFollowCamEnabled and 1 or 2

			if v1062 ~= v181.VRThirdPersonFixedCamEnabledSelector:GetSelectedIndex() then
				v181.VRThirdPersonFixedCamEnabledSelector:SetSelectionIndex(v1062)
			end
		end)
	end
	local function createVRSafetyBubbleModeOptions() -- line: 4051
		-- upvalues: u24 (ref), GameSettings (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy)
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

		local v728 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

		task.defer(function() -- line: 4067
			-- upvalues: v181 (copy), Utility (copy), u24 (ref), t36 (copy), v728 (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), EnumItems (copy), GameSettings (copy)
			local v1063 = v181
			local v1064 = v181
			local v1065 = v181
			local v1066, v1067, v1068 = Utility:AddNewRow(v181, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle"), "DropDown", t36, v728, nil, u24:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription"))

			v1063.VRSafetyBubbleModeFrame = v1066
			v1064.VRSafetyBubbleModeLabel = v1067
			v1065.VRSafetyBubbleModeSelector = v1068
			v181.VRSafetyBubbleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSafetyBubbleModeFrame
			v181.VRSafetyBubbleModeSelector.IndexChanged:connect(function(p126) -- line: 4080
				-- upvalues: EnumItems (copy), GameSettings (copy)
				GameSettings.VRSafetyBubbleMode = EnumItems[p126]
			end)
			GameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function() -- line: 4085
				-- upvalues: EnumItems (copy), GameSettings (copy), v181 (copy)
				local v1160 = table.find(EnumItems, GameSettings.VRSafetyBubbleMode)

				if v1160 ~= v181.VRSafetyBubbleModeSelector:GetSelectedIndex() then
					v181.VRSafetyBubbleModeSelector:SetSelectionIndex(v1160)
				end
			end)
		end)
	end

	v181.VoiceChatOptionsEnabled = false

	local connection4 = nil
	local connection5 = nil
	local u242 = nil

	if game:GetEngineFeature("VoiceChatSupported") and (GetFFlagEnableVrVoiceConnectDisconnect() or (not isInExperienceUIVREnabled or not isSpatial())) then
		spawn(function() -- line: 4099
			-- upvalues: GetFFlagEnableVoiceUxUpdates (copy), v53 (copy), default3 (copy), createVoiceChatSelector (copy), isVoiceFocused (copy), v181 (copy), observeIsVoiceFocused (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v68 (copy), VoiceVolumeControlsEligibility (copy), v126 (copy), v58 (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u235 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagVoiceChatUILogging (copy)
			if GetFFlagEnableVoiceUxUpdates() and ((not v53 and default3:EligibleForFaeUpsell() or default3:IsSeamlessVoice()) and default3:verifyUniverseAndPlaceCanUseVoice()) then
				createVoiceChatSelector()

				if isVoiceFocused() and v181.VoiceConnectDisconnectFrame then
					v181.VoiceConnectDisconnectFrame.Visible = false
				end

				observeIsVoiceFocused(function(p127) -- line: 4109
					-- upvalues: v181 (copy)
					if p127 then
						if v181.VoiceConnectDisconnectFrame then
							v181.VoiceConnectDisconnectFrame.Visible = false

							return
						end
					elseif v181.VoiceConnectDisconnectFrame then
						v181.VoiceConnectDisconnectFrame.Visible = true
					end
				end)
			end

			default3:asyncInit():andThen(function() -- line: 4122
				-- upvalues: default3 (copy), v181 (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), v68 (copy), VoiceVolumeControlsEligibility (copy), v126 (copy), v58 (copy), GetFFlagEnableVoiceUxUpdates (copy), createVoiceChatSelector (copy), GetFFlagEnableUniveralVoiceToasts (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), v59 (copy), v60 (copy), u235 (ref), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy), createVoiceConnectDisconnect (copy), GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), isVoiceFocused (copy), observeIsVoiceFocused (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
				VoiceChatService = default3:getService()

				if default3:VoiceChatAvailable() then
					v181.VoiceChatOptionsEnabled = true
				end

				if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v181.VoiceChatVolumeFrame then
					local function updateVoiceChatVolumeVisibility(p128) -- line: 4126
						-- upvalues: default3 (copy), v68 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy), v126 (copy)
						local ok, result = pcall(function() -- line: 4127
							-- upvalues: default3 (copy), v68 (copy), p128 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy)
							local VoiceChatService2 = game:GetService("VoiceChatService")
							local v1218 = default3:getService()
							local v1219 = ((if not v68 then v1218 and v1218.VoiceChatState else p128 or v1218 and v1218.VoiceChatState)) == Enum.VoiceChatState.Joined
							local v1220 = VoiceChatService2 and VoiceChatService2.UseNewAudioApi

							v181.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1219, v1220)
						end)

						if not ok then
							v126:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
						end
					end

					local v1071 = nil
					local ok, result = pcall(function() -- line: 4127
						-- upvalues: default3 (copy), v68 (copy), v1071 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy)
						local VoiceChatService3 = game:GetService("VoiceChatService")
						local v1165 = default3:getService()
						local v1166 = ((if not v68 then v1165 and v1165.VoiceChatState else v1071 or v1165 and v1165.VoiceChatState)) == Enum.VoiceChatState.Joined
						local v1167 = VoiceChatService3 and VoiceChatService3.UseNewAudioApi

						v181.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1166, v1167)
					end)

					if not ok then
						v126:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
					end

					if v68 then
						default3:subscribe("OnStateChanged", function(__, p130) -- line: 4147
							-- upvalues: default3 (copy), v68 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy), v126 (copy)
							local ok2, result2 = pcall(function() -- line: 4127
								-- upvalues: default3 (copy), v68 (copy), p130 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy)
								local VoiceChatService4 = game:GetService("VoiceChatService")
								local v1222 = default3:getService()
								local v1223 = ((if not v68 then v1222 and v1222.VoiceChatState else p130 or v1222 and v1222.VoiceChatState)) == Enum.VoiceChatState.Joined
								local v1224 = VoiceChatService4 and VoiceChatService4.UseNewAudioApi

								v181.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1223, v1224)
							end)

							if not ok2 then
								v126:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result2)
							end
						end)
					else
						local v1074 = default3:getService()

						if v1074 then
							v1074.StateChanged:Connect(function() -- line: 4153
								-- upvalues: default3 (copy), v68 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy), v126 (copy)
								local v1172 = nil
								local ok3, result3 = pcall(function() -- line: 4127
									-- upvalues: default3 (copy), v68 (copy), v1172 (copy), v181 (copy), VoiceVolumeControlsEligibility (copy)
									local VoiceChatService5 = game:GetService("VoiceChatService")
									local v1226 = default3:getService()
									local v1227 = ((if not v68 then v1226 and v1226.VoiceChatState else v1172 or v1226 and v1226.VoiceChatState)) == Enum.VoiceChatState.Joined
									local v1228 = VoiceChatService5 and VoiceChatService5.UseNewAudioApi

									v181.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(v1227, v1228)
								end)

								if not ok3 then
									v126:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result3)
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
						u235 = true
						v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
						task.defer(function() -- line: 4183
							-- upvalues: u235 (ref)
							u235 = false
						end)

						return
					end

					v181.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

					return
				end

				local u1075 = false

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() then
					createVoiceConnectDisconnect()

					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						u1075 = isVoiceFocused()
						observeIsVoiceFocused(function(p131) -- line: 4198
							-- upvalues: u1075 (ref), v181 (copy), default3 (copy)
							u1075 = p131

							if p131 then
								if v181.VoiceConnectFrame then
									v181.VoiceConnectFrame.Visible = false
								end

								if v181.VoiceDisconnectFrame then
									v181.VoiceDisconnectFrame.Visible = false

									return
								end
							elseif default3:ShouldShowJoinVoice() then
								if v181.VoiceConnectFrame then
									v181.VoiceConnectFrame.Visible = true
								end

								if v181.VoiceDisconnectFrame then
									v181.VoiceDisconnectFrame.Visible = false
								end
							end
						end)
					end
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceConnectFrame then
					v181.VoiceConnectFrame.Visible = false
				end

				if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceDisconnectFrame then
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() then
						v181.VoiceDisconnectFrame.Visible = not u1075
					else
						v181.VoiceDisconnectFrame.Visible = true
					end
				end

				default3.showVoiceUI.Event:Connect(function() -- line: 4231
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1075 (ref), v181 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1075 then
						return
					end

					v181.VoiceChatOptionsEnabled = true

					local v1176 = v181.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v181[t5.Input .. "DeviceFrame"] then
						v181[t5.Input .. "DeviceFrame"].Visible = v1176
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceConnectFrame then
						v181.VoiceConnectFrame.Visible = false
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceDisconnectFrame then
						v181.VoiceDisconnectFrame.Visible = true
					end
				end)
				default3.hideVoiceUI.Event:Connect(function() -- line: 4249
					-- upvalues: GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice (copy), u1075 (ref), v181 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy), GetFFlagEnableConnectDisconnectInSettingsAndChrome (copy)
					if GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice() and u1075 then
						return
					end

					v181.VoiceChatOptionsEnabled = false

					local v1177 = v181.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

					if v181[t5.Input .. "DeviceFrame"] then
						v181[t5.Input .. "DeviceFrame"].Visible = v1177
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceConnectFrame then
						v181.VoiceConnectFrame.Visible = true
					end

					if GetFFlagEnableConnectDisconnectInSettingsAndChrome() and v181.VoiceDisconnectFrame then
						v181.VoiceDisconnectFrame.Visible = false
					end
				end)
			end):catch(function() -- line: 4269
				-- upvalues: GetFFlagVoiceChatUILogging (copy), v126 (copy), GetFFlagEnableUniveralVoiceToasts (copy), default3 (copy)
				if GetFFlagVoiceChatUILogging() then
					v126:warning("Failed to init VoiceChatServiceManager")
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowPermissionPrompt()
				end
			end)
		end)
	end

	if GetFFlagEnableCrossExpVoice() and (not isInExperienceUIVREnabled or not isSpatial()) then
		connection4 = default4.ExperienceJoined.Event:Connect(function() -- line: 4282
			-- upvalues: v181 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v729 = v181.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v181[t5.Input .. "DeviceFrame"] then
				v181[t5.Input .. "DeviceFrame"].Visible = v729
			end
		end)
		connection5 = default4.ExperienceLeft.Event:Connect(function() -- line: 4285
			-- upvalues: v181 (copy), GetFFlagEnableCrossExpVoice (copy), default4 (copy), t5 (copy)
			local v730 = v181.VoiceChatOptionsEnabled or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if v181[t5.Input .. "DeviceFrame"] then
				v181[t5.Input .. "DeviceFrame"].Visible = v730
			end
		end)

		function u242() -- line: 4288
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

	v181.VideoOptionsEnabled = false

	local u243 = nil

	if GetFFlagSelfViewCameraSettings() and (not isInExperienceUIVREnabled or not isSpatial()) and isCamEnabledForUserAndPlace() then
		getCamMicPermissions(function(p132) -- line: 4310
			-- upvalues: v181 (copy)
			v181.VideoOptionsEnabled = p132.hasCameraPermissions
		end, { default.Permissions.CAMERA_ACCESS }, true)

		if u243 then
			u243:disconnect()
		end

		u243 = cameraDevicePermissionGrantedSignal:connect(function() -- line: 4326
			-- upvalues: v181 (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref)
			v181.VideoOptionsEnabled = true
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3570
					-- upvalues: v181 (copy), updateCameraDevices (copy)
					if v181.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end)
	end

	if not isInExperienceUIVREnabled then
		createCameraModeOptions(not v116 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))
	end

	if UserInputService.MouseEnabled then
		createMouseOptions()
	elseif UserInputService.GamepadEnabled then
		if GameSettings.IsUsingGamepadCameraSensitivity then
			createGamepadOptions()
		else
			local u244 = nil

			u244 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4348
				-- upvalues: GameSettings (copy), u244 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u244 then
						u244:disconnect()
					end

					createGamepadOptions()
				end
			end)
		end
	else
		local u245 = nil

		u245 = UserInputService.GamepadConnected:connect(function() -- line: 4366
			-- upvalues: u245 (ref), GameSettings (copy), createGamepadOptions (copy)
			if u245 then
				u245:disconnect()
			end

			if GameSettings.IsUsingGamepadCameraSensitivity then
				createGamepadOptions()

				return
			end

			local u733 = nil

			u733 = GameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function() -- line: 4348
				-- upvalues: GameSettings (copy), u733 (ref), createGamepadOptions (copy)
				if GameSettings.IsUsingGamepadCameraSensitivity then
					if u733 then
						u733:disconnect()
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
			local u246 = nil

			u246 = GameSettings.Changed:connect(function(p133) -- line: 4380
				-- upvalues: GameSettings (copy), u246 (ref), createCameraInvertedOptions (copy)
				if p133 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
					u246:disconnect()
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
			createCameraModeOptions(not v116 and (UserInputService.TouchEnabled or (UserInputService.MouseEnabled or UserInputService.KeyboardEnabled)))

			if GameSettings.IsUsingCameraYInverted then
				createCameraInvertedOptions()
			else
				local u247 = nil

				u247 = GameSettings.Changed:connect(function(p134) -- line: 4409
					-- upvalues: GameSettings (copy), u247 (ref), createCameraInvertedOptions (copy)
					if p134 == "IsUsingCameraYInverted" and GameSettings.IsUsingCameraYInverted then
						u247:disconnect()
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

	if v70 and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		local u248 = false

		v181.Displayed.Event:Connect(function() -- line: 4432
			-- upvalues: u248 (ref), v181 (copy), default3 (copy)
			u248 = true

			if v181.VoiceChatVolumeFrame and v181.VoiceChatVolumeFrame.Visible then
				default3:RecordGameSettingsOpened()
			end
		end)
		v181.Hidden.Event:Connect(function() -- line: 4439
			-- upvalues: u248 (ref)
			u248 = false
		end)
		v181.VoiceChatVolumeFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 4443
			-- upvalues: v181 (copy), u248 (ref), default3 (copy)
			if v181.VoiceChatVolumeFrame.Visible and u248 then
				default3:RecordGameSettingsOpened()
			end
		end)
	end

	if v76 then
		createPartyVoiceVolumeOptions()
	end

	createHapticsToggle()
	createGraphicsOptions()

	if v46 and GetFFlagEnablePlayerNamesEnabledSetting() then
		createPlayerNamesEnabledOptions()
	end

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		PlayerChoiceTranslationSettingInitializer(v181, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
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

	if v131 then
		createMicroProfilerOptions()
	end

	if v116 and getAppFeaturePolicies().getSupportsOverscan() then
		createOverscanOption()
	end

	if v46 and FFlagBadgeVisibilitySettingEnabled then
		spawn(function() -- line: 3166
			-- upvalues: PlayerPermissionsModule (copy), LocalPlayer (copy), RobloxTranslator (copy), v149 (copy), v181 (copy), Utility (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), GameSettings (copy)
			local n15 = 2

			if PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) then
				n15 = 1
			end

			local v737 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local v738 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v739 = if not v149 then RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges") else RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			local v740 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames")
			local v741 = v181
			local v742 = v181
			local v743 = v181
			local v744, v745, v746 = Utility:AddNewRow(v181, v739, "Selector", {
				v738,
				v737
			}, n15, nil, v740)

			v741.badgeVisibleRow = v744
			v742.badgeVisibleFrame = v745
			v743.badgeVisibleSelector = v746
			v181.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame
			v181.badgeVisibleSelector.IndexChanged:connect(function(p135) -- line: 3180
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
	GetHasGuiHidingPermission(RunService:IsStudio(), LocalPlayer, PlayerPermissionsModule):andThen(function(p136) -- line: 4504
		-- upvalues: createUiToggleOptions (copy)
		if p136 then
			createUiToggleOptions()
		end
	end):catch(function(p137) -- line: 4509
		warn(p137)
	end)
	u182 = true

	if VRService.VREnabled then
		local VREnabled = VRService.VREnabled

		for k, __ in pairs(t10) do
			k.Visible = not VREnabled
		end
	end

	if FFlagIEMSettingsGroups then
		v181.AudioHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.AudioHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioHeader,
			parent = v181.Page
		})
		v181.AudioDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioDivider,
			parent = v181.Page
		})
		v181.DisplayHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.DisplayHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayHeader,
			parent = v181.Page
		})
		v181.DisplayDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayDivider,
			parent = v181.Page
		})

		if not isSpatial() then
			v181.LanguageHeader = renderSettingsHeader({
				headerText = "CoreScripts.InGameMenu.GameSettings.LanguageHeader",
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageHeader,
				parent = v181.Page
			})
			v181.LanguageDivider = renderSettingsDivider({
				layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageDivider,
				parent = v181.Page
			})
		end

		v181.ViewAndControlsHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.ViewandControlsHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ViewAndControlsHeader,
			parent = v181.Page
		})
	end

	v181.TabHeader.Name = "GameSettingsTab"

	local v252 = Migration.uiblox["icons/common/settings"]

	v181.TabHeader.TabLabel.Icon.Text = v252.name
	v181.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v252.variant]
	v181.TabHeader.TabLabel.Title.Text = "Settings"
	v181.Page.ZIndex = 5

	if v181.PageListLayout then
		v181.PageListLayout.Padding = UDim.new(0, 0)
	end

	v181.PageOpen = false

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		v181.FeedbackEntryPointEnabled = true
	end

	local function staticFeedbackEntryPointChecksPassed() -- line: 4578
		-- upvalues: RunService (copy), v142 (copy), v116 (copy)
		if RunService:IsStudio() then
			return false
		end

		if game:GetEngineFeature("CaptureModeEnabled") == false then
			return false
		end

		if v142 and v116 then
			return false
		end

		return true
	end

	function v181.OpenSettingsPage() -- line: 4594
		-- upvalues: v181 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), updateAudioOptions (copy), SoundService (copy), connection (ref), GameSettings (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy), GetFFlagSelfViewCameraSettings (copy), updateCameraDevices (copy), VideoCaptureService (copy), connection2 (ref), updateUiToggleSelection (copy), ExperienceStateCaptureService (ref), v88 (copy), Theme (copy), v87 (copy), FFlagIEMFocusNavToButtons (copy), getLastValueChangerFrame (copy), FFlagIEMTabFocusNav (copy), getFirstValueChangerFrame (copy)
		v181.PageOpen = true

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if GetFFlagLazyInitiateExperienceLanguageSwitcher() and not v181.LanguageSwitcherInitialized and isLangaugeSelectionDropdownEnabled() and GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
			v181.LanguageSwitcherInitialized = true
			ExperienceLanguageSwitcherInitializer(v181, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		updateAudioOptions()

		if SoundService.DeviceListChanged then
			connection = SoundService.DeviceListChanged:Connect(function() -- line: 3560
				-- upvalues: v181 (copy), updateAudioOptions (copy)
				if v181.PageOpen then
					updateAudioOptions()
				end
			end)
		end

		v181.startVolume = GameSettings.MasterVolume

		if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
			v181.maxVoiceChatVolumeDuringSession = GameSettings.VoiceChatVolume
		end

		if GetFFlagSelfViewCameraSettings() and v181.VideoOptionsEnabled and game:GetEngineFeature("VideoCaptureService") then
			updateCameraDevices()

			if VideoCaptureService.DevicesChanged then
				connection2 = VideoCaptureService.DevicesChanged:Connect(function() -- line: 3570
					-- upvalues: v181 (copy), updateCameraDevices (copy)
					if v181.PageOpen then
						updateCameraDevices()
					end
				end)
			end
		end

		updateUiToggleSelection()

		if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") and v181.toggleFeedbackModeButton and v181.toggleFeedbackModeText then
			v181.FeedbackEntryPointEnabled = ExperienceStateCaptureService ~= nil and ExperienceStateCaptureService:CanEnterCaptureMode()

			if v181.FeedbackEntryPointEnabled then
				v181.toggleFeedbackModeButton.Active = true
				v181.toggleFeedbackModeButton.Enabled.Value = true
				v181.toggleFeedbackModeText.Text = v88
			else
				v181.toggleFeedbackModeButton.Active = false
				v181.toggleFeedbackModeButton.Enabled.Value = false
				v181.toggleFeedbackModeText.TextColor3 = Theme.color("ButtonNonInteractable", Color3.fromRGB(100, 100, 100))
				v181.toggleFeedbackModeText.Text = v87
			end
		end

		if FFlagIEMFocusNavToButtons then
			table.insert(v181.LastSelectableObjects, getLastValueChangerFrame(v181))
		end

		if FFlagIEMTabFocusNav then
			table.insert(v181.FirstSelectableObjects, getFirstValueChangerFrame(v181))
			v181.FirstSelectableObjectsUpdated:fire()
		end
	end
	function v181.CloseSettingsPage() -- line: 4665
		-- upvalues: v181 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), SoundService (copy), connection (ref), GetFFlagEnableCrossExpVoice (copy), u242 (ref), GetFFlagSelfViewCameraSettings (copy), VideoCaptureService (copy), connection2 (ref), u243 (ref), default3 (copy), FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast (copy), FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider (copy)
		v181.PageOpen = false

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if SoundService.DeviceListChanged and connection then
			connection:Disconnect()
		end

		if GetFFlagEnableCrossExpVoice() and u242 then
			u242()
		end

		if GetFFlagSelfViewCameraSettings() then
			if game:GetEngineFeature("VideoCaptureService") and VideoCaptureService.DevicesChanged and connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if u243 then
				u243:disconnect()
				u243 = nil
			end
		end

		if game:GetEngineFeature("VoiceChatSupported") and v181.VoiceChatOptionsEnabled and v181.startVolume ~= nil and v181.startVolume > 0 then
			default3:CheckAndShowNotAudiblePrompt()
		end

		if game:GetEngineFeature("VoiceChatSupported") and v181.VoiceChatOptionsEnabled and FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and v181.maxVoiceChatVolumeDuringSession ~= nil and v181.maxVoiceChatVolumeDuringSession > 0 then
			default3:ShowNotAudiblePromptVoiceChatVolume()
		end
	end
	function isLangaugeSelectionDropdownEnabled() -- line: 4709
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
	function v181.SetHub(__, p139) -- line: 4732
		-- upvalues: v181 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), GetFFlagEnableLocalesForExperienceLanguageSwitcher (copy), GetFFlagLazyInitiateExperienceLanguageSwitcher (copy), ExperienceLanguageSwitcherInitializer (copy), SETTINGS_MENU_LAYOUT_ORDER (copy), reportSettingsChangeForAnalytics (copy), createTranslationOptions (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFFlagChatTranslationHoldoutEnabled (copy), GetFStringChatTranslationLayerName (copy), getChatTranslationLayerData (copy), EngineFeature (copy), GetFFlagChatTranslationNewDefaults (copy), GameSettings (copy), TextChatService (copy), GetFFlagChatTranslationForceSetting (copy), ChatTranslationOptionsWithChatLanguageSwitcherInitializer (copy), RunService (copy), v142 (copy), v116 (copy), createFeedbackModeOptions (copy)
		v181.HubRef = p139

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if isLangaugeSelectionDropdownEnabled() then
			if GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
				if not GetFFlagLazyInitiateExperienceLanguageSwitcher() then
					ExperienceLanguageSwitcherInitializer(v181, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
				end
			else
				createTranslationOptions()
			end
		end

		if game:GetEngineFeature("EnableTCSChatTranslation") and GetFFlagChatTranslationSettingEnabled() then
			if GetFFlagChatTranslationHoldoutEnabled() then
				local v752 = GetFStringChatTranslationLayerName()

				if not getChatTranslationLayerData(v752).ChatTranslationEnabled then
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
						pcall(function() -- line: 4770
							-- upvalues: TextChatService (copy)
							TextChatService.ChatTranslationEnabled = false
						end)
					end
				elseif GetFFlagChatTranslationForceSetting() then
					GameSettings.ChatTranslationEnabled = true
				end
			end

			ChatTranslationOptionsWithChatLanguageSwitcherInitializer(v181, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		if not RunService:IsStudio() and (game:GetEngineFeature("CaptureModeEnabled") ~= false and (not v142 or not v116)) then
			createFeedbackModeOptions()
		end
	end

	return v181
end

return (Initialize())
