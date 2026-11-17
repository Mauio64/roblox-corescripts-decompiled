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
local v = UserSettings()
local gameSettings = v.GameSettings
local VideoCaptureService = game:GetService("VideoCaptureService")
local UserGameSettings = v:GetService("UserGameSettings")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
local TextChatService = game:GetService("TextChatService")
local SafetyService = game:GetService("SafetyService")
local ExperienceStateCaptureService

if game:GetEngineFeature("CaptureModeEnabled") then
	ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
else
	ExperienceStateCaptureService = nil
end

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local LocalizationService = game:GetService("LocalizationService")
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local localization = InExperienceLocales.Localization.new(LocalizationService.RobloxLocaleId)

local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local isCamEnabledForUserAndPlace = require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)
local renderSettingsHeader = require(RobloxGui.Modules.Settings.Components.renderSettingsHeader)
local renderSettingsDivider = require(RobloxGui.Modules.Settings.Components.renderSettingsDivider)

local FFlagEnablePioneerIGMSettingsBanner = require(RobloxGui.Modules.Settings.Flags.FFlagEnablePioneerIGMSettingsBanner)
local renderMoreSettingsBanner = nil

if FFlagEnablePioneerIGMSettingsBanner then
	local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)

	if PioneerUtils.isPioneerLaunch() then
		renderMoreSettingsBanner = require(RobloxGui.Modules.Settings.Components.renderMoreSettingsBanner)
	end
end

local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default
local CrossExperience = require(CorePackages.Workspace.Packages.CrossExperience)
local isVoiceFocused = CrossExperience.Utils.isVoiceFocused
local CrossExperience2 = require(CorePackages.Workspace.Packages.CrossExperience)
local observeIsVoiceFocused = CrossExperience2.Utils.observeIsVoiceFocused

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
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local defineFastFlag = game:DefineFastFlag("ShowAntiHarassmentSettings", false)
local GetFFlagEnablePlayerNamesEnabledSetting = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnablePlayerNamesEnabledSetting)
local FFlagUpdatePeopleNamesSettingCopy = require(RobloxGui.Modules.Settings.Flags.FFlagUpdatePeopleNamesSettingCopy)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags.FFlagBadgeVisibilitySettingEnabled
local defineFastFlag2 = game:DefineFastFlag("HideVoiceChatSelectorForFae_AEGIS2", false)
local defineFastFlag3 = game:DefineFastFlag("CenterShiftLockOverride", true)
local defineFastFlag4 = game:DefineFastFlag("VoiceChatSelectorReconnectFocus2_AEGIS2", false)
local defineFastFlag5 = game:DefineFastFlag("MicroProfilerReadOnlyInformationLabel", false)
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local defineFastFlag6 = game:DefineFastFlag("VoiceSelectorAvailableAfterFae", false)
local defineFastFlag7 = game:DefineFastFlag("InGameGraphicsFollowsSavedQuality", false)
local defineFastFlag8 = game:DefineFastFlag("DifferentiateVoiceSelectorSystemAndUser", false)
local defineFastFlag9 = game:DefineFastFlag("DeferProgrammaticChange", false)
local FFlagRenameVolumeToMainVolume = require(RobloxGui.Modules.Flags.FFlagRenameVolumeToMainVolume)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAIRephraseSettingEnabled = SharedFlags2.FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = SharedFlags.FFlagChatSummariesSettingEnabled

local fFlagExpChatDictation = SharedFlags.FFlagExpChatDictationVoiceTypingModeSetting
	and (SharedFlags.FFlagExpChatDictation or SharedFlags.FFlagExpChatContinuousDictation)
local FFlagVoiceRewarmTelemetry = SharedFlags.FFlagVoiceRewarmTelemetry
local defineFastFlag10 = game:DefineFastFlag("DebounceVoiceSelectorIndexChange", false)
local defineFastFlag11 = game:DefineFastFlag("VoiceSelectorIgnoreFailedStateDisconnect", false)

local FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider)

local FFlagFriendsCallingCallVolumeSlider = require(RobloxGui.Modules.Settings.Flags.FFlagFriendsCallingCallVolumeSlider)
local FriendsCallingService, GetFriendsCallingStore

if FFlagFriendsCallingCallVolumeSlider then
	FriendsCallingService = game:GetService("FriendsCallingService")
	GetFriendsCallingStore = require(CorePackages.Workspace.Packages.FriendsCalling.GetFriendsCallingStore)
else
	FriendsCallingService = nil
	GetFriendsCallingStore = nil
end

local defineFastFlag12 = game:DefineFastFlag("VoiceVolumeControlsFixSliderVisibilityOnEligibleGames", false)

local defineFastFlag13 = game:DefineFastFlag("VoiceVolumeControlsDisableInteractionWhenNoMasterVolume", false)

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = VoiceChatCore.Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()

local FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast = require(RobloxGui.Modules.VoiceChat.Flags.FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast)

local defineFastFlag14 = game:DefineFastFlag("VoiceVolumeControlsSuppressInExperienceUiForPartyVoice", false)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local default2 = CrossExperienceVoice.IXPManager.default
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local GameSettingsConstants = require(RobloxGui.Modules.Settings.Resources.GameSettingsConstants)

local v2 = default2 and default2.getHasPartyVoiceVolume()

local Constants = require(RobloxGui:WaitForChild("Modules"):WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local v3 = {
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

local function voiceChatVolumeToSlider(voiceChatVolume: number) -- 4 equivalent calls inferred from this helper
	return (math.floor(voiceChatVolume * 5 + 0.5))
end

local function voiceChatVolumeFromSlider(p: number) -- 1 equivalent call inferred from this helper
	return p / 5
end

local v4 = {
	DevComputerMovementMode = true,
	DevComputerCameraMode = true,
	DevEnableMouseLock = true
}

local v5 = { DevTouchMovementMode = true, DevTouchCameraMode = true }

local v6 = { DEFAULT_FOLLOW = "Default (Follow)", DEFAULT_CLASSIC = "Default (Classic)" }

local v7 = { Input = "Input", Output = "Output" }

local v8 = {
	DEFAULT_THUMBSTICK = "Default (Dynamic Thumbstick)",
	DEFAULT_KEYBOARD = "Default (Keyboard)",
	TAP_TO_MOVE = "Tap to Move",
	CLICK_TO_MOVE = "Click to Move"
}

local formatByKey = RobloxTranslator:FormatByKey("Feature.SettingsHub.TouchMovementMode.ClassicThumbstick")

local formatByKey2 = RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.Unavailable")
local formatByKey3 = RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.ButtonText")

local v9 = { On = 1, Off = 2 }

local function getDefaultCameraMode(): string
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Default (Follow)"
	end

	return "Default (Classic)"
end

local function getDefaultMovementMode()
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
	end

	return "Default (Keyboard)"
end

local function getDefaultSelectToMove(): string
	if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
		return "Tap to Move"
	end

	return "Click to Move"
end

local SETTINGS_MENU_LAYOUT_ORDER = GameSettingsConstants.SETTINGS_MENU_LAYOUT_ORDER

local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local GetFFlagChatTranslationSettingEnabled = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationSettingEnabled)
local GetFStringChatTranslationLayerName = require(RobloxGui.Modules.Flags.GetFStringChatTranslationLayerName)
local GetFFlagChatTranslationHoldoutEnabled = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationHoldoutEnabled)
local GetFFlagChatTranslationWaitForIXP = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationWaitForIXP)
local GetFFlagChatTranslationForceSetting = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationForceSetting)
local GetFFlagChatTranslationNewDefaults = require(RobloxGui.Modules.Flags.GetFFlagChatTranslationNewDefaults)

local engineFeature = game:GetEngineFeature("TextChatServiceSettingsSaved")
local ChatTranslationOptionsWithChatLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ChatTranslationOptionsWithChatLanguageSwitcherInitializer)

local engineFeature2 = game:GetEngineFeature("GameBasicSettingsFramerateCap")
local engineFeature3 = game:GetEngineFeature("RUUserScalePreferenceAPI")
local FFlagUIScaleEngineOptions = SharedFlags.FFlagUIScaleEngineOptions
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local UIScaleOptions = Responsive.UIScaleOptions

local defineFastFlag15 = game:DefineFastFlag("FramerateCapIOSOptions", false)

local Utility = require(RobloxGui.Modules.Settings.Utility)

local CoreUtility = require(RobloxGui.Modules.CoreUtility)

local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)
local GetHasGuiHidingPermission = require(RobloxGui.Modules.Common.GetHasGuiHidingPermission)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local Cryo = require(CorePackages.Packages.Cryo)
local GfxReset = require(script.Parent.Parent.GfxReset)
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib2.Create
local ThrottleFunctionCall = require(CoreGui.RobloxGui.Modules.Settings.Pages.ShareGame.ThrottleFunctionCall)
local SavedQualityFollower = require(RobloxGui.Modules.Settings.Pages.SavedQualityFollower)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local Signals = require(CorePackages.Packages.Signals)
local Migration = BuilderIcons.Migration

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
RobloxGui:WaitForChild("Modules"):WaitForChild("Settings"):WaitForChild("SettingsHub")
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()

local LocalPlayer = Players.LocalPlayer
local platform = UserInputService:GetPlatform()
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default3 = VoiceChatServiceManager.default

local VoiceChatCore2 = require(CorePackages.Workspace.Packages.VoiceChatCore)
local VoiceVolumeControlsEligibility = VoiceChatCore2.VoiceVolumeControlsEligibility
local CrossExperienceVoice2 = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
local default4 = CrossExperienceVoice2.CrossExperienceVoiceManager.default

local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local formatByKey4 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.SystemDefault")
local formatByKey5 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Video.VideoCamera")

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v10 = CoreScriptsInitializer.CoreLogger:new(script.Name)
game:DefineFastInt("RomarkStartWithGraphicQualityLevel", -1)
local fastInt = game:GetFastInt("RomarkStartWithGraphicQualityLevel")

local v11 = not CachedPolicyService:IsSubjectToChinaPolicies()

local v12 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.UWP
local v13 = platform == Enum.Platform.IOS or platform == Enum.Platform.Android

if isInExperienceUIVREnabled then
	if not (v13 or v12) then
		v11 = isSpatial() and v11
	end
elseif not (v13 or v12) then
	v11 = v12
end

local GetFIntVoiceChatDeviceChangeDebounceDelay = require(RobloxGui.Modules.Flags.GetFIntVoiceChatDeviceChangeDebounceDelay)
local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local GetFFlagEnableUniveralVoiceToasts = require(RobloxGui.Modules.Flags.GetFFlagEnableUniveralVoiceToasts)

local GetFFlagEnableExplicitSettingsChangeAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableExplicitSettingsChangeAnalytics)

local GetFFlagFixCyclicFullscreenIndexEvent = require(RobloxGui.Modules.Settings.Flags.GetFFlagFixCyclicFullscreenIndexEvent)
local defineFastFlag16 = game:DefineFastFlag("DisableFeedbackSoothsayerCheck", false)
local defineFastFlag17 = game:DefineFastFlag("UserShowGuiHideToggles", false)
local defineFastFlag18 = game:DefineFastFlag("UserFreecamGuiDestabilization", false)

local defineFastFlag19 = game:DefineFastFlag("FixDeveloperConsoleButtonSizeAndPositioning", false)
local defineFastFlag20 = game:DefineFastFlag("EnableTFFeedbackModeEntryCheck", false)

local defineFastFlag21 = game:DefineFastFlag("FeedbackEntryPointButtonSizeAdjustment2", false)

local defineFastFlag22 = game:DefineFastFlag("FeedbackEntryPointImprovedStrictnessCheck", false)
local GetFFlagEnableLocalesForExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLocalesForExperienceLanguageSwitcher)
local GetFFlagLazyInitiateExperienceLanguageSwitcher = require(RobloxGui.Modules.Settings.Flags.GetFFlagLazyInitiateExperienceLanguageSwitcher)
local ExperienceLanguageSwitcherInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.ExperienceLanguageSwitcherInitializer)

local PlayerChoiceTranslationSettingInitializer = require(RobloxGui.Modules.Settings.Pages.GameSettingsRowInitializers.PlayerChoiceTranslationSettingInitializer)

local defineFastFlag23 = game:DefineFastFlag("UpdateVisibilitySettingsCopy", false)
local defineFastFlag24 = game:DefineFastFlag("ExpChatDebounceRephraseIndexSelection", false)
local defineFastFlag25 = game:DefineFastFlag("EraseFPSFromDefaultSetting", false)

local function reportSettingsChangeForAnalytics(name, p, p2, p3)
	if not GetFFlagEnableExplicitSettingsChangeAnalytics() or p == p2 or p == nil or p2 == nil then
		return
	end

	local joined = {
		universe_id = tostring(game.GameId),
		name = name,
		old_value = tostring(p),
		new_value = tostring(p2),
		has_touch = UserInputService.TouchEnabled,
		has_mouse = UserInputService.MouseEnabled,
		has_gamepad = UserInputService.GamepadEnabled
	}

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	RbxAnalyticsService:SetRBXEventStream(
		Constants.AnalyticsTargetName,
		Constants.AnalyticsInGameMenuName,
		Constants.AnalyticsExplicitSettingsChangeName,
		joined
	)
end

local function reportSettingsForAnalytics()
	local v14 = {}
	local v15 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

	if v15 then
		v14.camera_mode_touch = tostring(gameSettings.TouchCameraMovementMode)
	else
		v14.camera_mode_desktop = tostring(gameSettings.ComputerCameraMovementMode)
	end

	if v15 then
		v14.movement_mode_touch = tostring(gameSettings.TouchMovementMode)
	else
		v14.movement_mode_desktop = tostring(gameSettings.ComputerMovementMode)
	end

	if UserInputService.MouseEnabled then
		v14.shift_lock_enabled = tostring(gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch)
	end

	if UserInputService.GamepadEnabled and gameSettings.IsUsingGamepadCameraSensitivity then
		local gamepadCameraSensitivity = gameSettings.GamepadCameraSensitivity
		v14.camera_sensitivity_gamepad = tostring((tonumber(string.format("%.2f", gamepadCameraSensitivity))))
	end

	if UserInputService.MouseEnabled then
		local x = gameSettings.MouseSensitivityFirstPerson.X
		v14.camera_sensitivity_mouse = tostring((tonumber(string.format("%.2f", x))))
	end

	v14.camera_y_inverted = tostring(gameSettings.CameraYInverted)
	v14.show_performance_stats = tostring(gameSettings.PerformanceStatsVisible)
	v14.volume = tostring((math.floor(gameSettings.MasterVolume * 10 + 0.5)))

	if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider then
		v14.voice_chat_volume = tostring(voiceChatVolumeToSlider(gameSettings.VoiceChatVolume)) -- inferred equivalent call
	end

	v14.gfx_quality_level = tostring(settings().Rendering.QualityLevel)

	if engineFeature2 then
		v14.framerate_cap = tostring(gameSettings.FramerateCap)
	end

	v14.fullscreen_enabled = tostring(gameSettings:InFullScreen())
	v14.microprofiler_enabled = tostring(gameSettings.OnScreenProfilerEnabled)
	v14.microprofiler_webserver_enabled = tostring(gameSettings.MicroProfilerWebServerEnabled)

	v14.reduced_motion = tostring(gameSettings.ReducedMotion)
	v14.preferred_transparency = tostring(gameSettings.PreferredTransparency)
	v14.preferred_text_size = tostring(gameSettings.PreferredTextSize)
	v14.ui_navigation_key_bind_enabled = tostring(gameSettings.UiNavigationKeyBindEnabled)

	v14.universeid = tostring(game.GameId)

	if GetFFlagEnablePlayerNamesEnabledSetting() then
		v14.player_names_enabled = tostring(gameSettings.PlayerNamesEnabled)
	end

	RbxAnalyticsService:SetRBXEventStream(
		Constants.AnalyticsTargetName,
		Constants.AnalyticsInGameMenuName,
		Constants.AnalyticsSettingsChangeName,
		v14
	)
end

game:DefineFastInt("V1MenuLanguageSelectionFeaturePerMillageRollout", 0)
game:DefineFastString("V1MenuLanguageSelectionFeatureForcedUserIds", "")
local defineFastFlag26 = game:DefineFastFlag("IGMEnableGFXReset", false)

local function getLastValueChangerFrame(newPage)
	local layoutOrder = nil
	local lastValueChangerFrame = nil

	for k, v14 in pairs(newPage:GetRows()) do
		local selectionFrame = v14.SelectionFrame

		if not (not layoutOrder or layoutOrder <= selectionFrame.LayoutOrder) then
			continue
		end

		layoutOrder = selectionFrame.LayoutOrder
		lastValueChangerFrame = newPage:getValueChangerFrame(v14.ValueChanger)
	end

	return lastValueChangerFrame
end

local function getFirstValueChangerFrame(newPage)
	if not FFlagIEMTabFocusNav then
		return
	end

	local layoutOrder = nil
	local v14 = nil

	for k, v15 in pairs(newPage:GetRows()) do
		local selectionFrame = v15.SelectionFrame

		if not (not layoutOrder or selectionFrame.LayoutOrder < layoutOrder) then
			continue
		end

		layoutOrder = selectionFrame.LayoutOrder
		v14 = newPage:getValueChangerFrame(v15.ValueChanger)
	end

	return v14
end

local function Initialize()
	if defineFastFlag26 then
		GfxReset.RunGfxReset()
	end

	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	if GetFFlagLazyInitiateExperienceLanguageSwitcher() then
		newPage.LanguageSwitcherInitialized = false
	end

	local v14 = false
	local set = {}
	local function onVRSettingsReady() -- 2 equivalent calls inferred from this helper
		local vrEnabled = VRService.VREnabled

		for k, v15 in pairs(set) do
			k.Visible = not vrEnabled
		end
	end

	local function onVREnabled() -- 1 equivalent call inferred from this helper
		if VRService.VREnabled and v14 then
			onVRSettingsReady() -- inferred equivalent call
		end
	end
	VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabled)
	onVREnabled() -- inferred equivalent call

	local function createGraphicsOptions()
		local fullscreenFrame, fullscreenLabel, fullscreenEnabler = Utility:AddNewRow(
			newPage,
			"Fullscreen",
			"Selector",
			{ "On", "Off" },
			gameSettings:InFullScreen() and 1 or 2
		)
		newPage.FullscreenFrame = fullscreenFrame
		newPage.FullscreenLabel = fullscreenLabel
		newPage.FullscreenEnabler = fullscreenEnabler

		newPage.FullscreenFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FullScreenFrame

		set[newPage.FullscreenFrame] = true

		newPage.FullscreenEnabler.IndexChanged:connect(function(p)
			local v15 = gameSettings:InFullScreen()

			if p == 1 then
				if not gameSettings:InFullScreen() then
					GuiService:ToggleFullscreen()

					if GetFFlagFixCyclicFullscreenIndexEvent() then
						if newPage.FullscreenEnabler.GetSelectedIndex() ~= 1 then
							newPage.FullscreenEnabler:SetSelectionIndex(1)
						end
					else
						newPage.FullscreenEnabler:SetSelectionIndex(1)
					end
				end
			elseif p == 2 and gameSettings:InFullScreen() then
				GuiService:ToggleFullscreen()

				if GetFFlagFixCyclicFullscreenIndexEvent() then
					if newPage.FullscreenEnabler.GetSelectedIndex() ~= 2 then
						newPage.FullscreenEnabler:SetSelectionIndex(2)
					end
				else
					newPage.FullscreenEnabler:SetSelectionIndex(2)
				end
			end

			spawn(function()
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("fullscreen_enabled", v15, gameSettings:InFullScreen())
				end

				reportSettingsForAnalytics()
			end)
		end)

		gameSettings.FullscreenChanged:connect(function(enabled)
			if enabled then
				if newPage.FullscreenEnabler:GetSelectedIndex() ~= 1 then
					newPage.FullscreenEnabler:SetSelectionIndex(1)
				end
			elseif newPage.FullscreenEnabler:GetSelectedIndex() ~= 2 then
				newPage.FullscreenEnabler:SetSelectionIndex(2)
			end

			RbxAnalyticsService:SetRBXEventStream(
				Constants.AnalyticsTargetName,
				Constants.AnalyticsInGameMenuName,
				Constants.AnalyticsFullscreenModeName,
				{ enabled = enabled }
			)
		end)

		local graphicsEnablerFrame, graphicsEnablerLabel, graphicsQualityEnabler = Utility:AddNewRow(
			newPage,
			"Graphics Mode",
			"Selector",
			{ "Automatic", "Manual" },
			gameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic and 1 or 2
		)
		newPage.GraphicsEnablerFrame = graphicsEnablerFrame
		newPage.GraphicsEnablerLabel = graphicsEnablerLabel
		newPage.GraphicsQualityEnabler = graphicsQualityEnabler

		newPage.GraphicsEnablerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsEnablerFrame

		local graphicsQualityFrame, graphicsQualityLabel, graphicsQualitySlider = Utility:AddNewRow(
			newPage,
			"Graphics Quality",
			"Slider",
			10,
			1
		)
		newPage.GraphicsQualityFrame = graphicsQualityFrame
		newPage.GraphicsQualityLabel = graphicsQualityLabel
		newPage.GraphicsQualitySlider = graphicsQualitySlider

		newPage.GraphicsQualityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GraphicsQualityFrame
		newPage.GraphicsQualitySlider:SetMinStep(1)

		if engineFeature2 and not VRService.VREnabled then
			local v15 = Constants.FramerateCaps

			if defineFastFlag15 and platform == Enum.Platform.IOS then
				v15 = Constants.FramerateCapsIOS
			end

			local clone = table.clone(v15)
			local v16 = { nil }
			local v17

			if defineFastFlag25 then
				v17 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.Default")
			else
				v17 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateCapDefaultEntry", {
					Frames = gameSettings:GetDefaultFramerateCap()
				})
			end

			v16[1] = v17

			for k, frames in clone do
				table.insert(
					v16,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.FramerateEntry", {
						Frames = frames
					})
				)
			end

			table.insert(clone, 1, -1)

			task.defer(function()
				local formatByKey6 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate")
				local v18

				if defineFastFlag15 then
					v18 = table.find(clone, gameSettings.FramerateCap) or 1
				else
					v18 = table.find(clone, gameSettings.FramerateCap)
				end

				local framerateCapFrame, framerateCapLabel, framerateCapMode = Utility:AddNewRow(
					newPage,
					formatByKey6,
					"DropDown",
					v16,
					v18,
					nil,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MaximumFramerate.Description")
				)
				newPage.FramerateCapFrame = framerateCapFrame
				newPage.FramerateCapLabel = framerateCapLabel
				newPage.FramerateCapMode = framerateCapMode

				newPage.FramerateCapFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FramerateCap

				newPage.FramerateCapMode.IndexChanged:Connect(function(p)
					local framerateCap = gameSettings.FramerateCap
					gameSettings.FramerateCap = clone[p]

					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						reportSettingsChangeForAnalytics("framerate_cap", framerateCap, gameSettings.FramerateCap)
					end

					reportSettingsForAnalytics()
				end)
			end)
		end

		local settings_2 = settings()
		settings_2.Rendering.EnableFRM = true
		local v15

		if defineFastFlag7 then
			v15 = SavedQualityFollower.new(newPage.GraphicsQualityEnabler, newPage.GraphicsQualitySlider)
		else
			v15 = nil
		end

		function SetGraphicsQuality(savedQualityLevel, p)
			if defineFastFlag7 and v15:isShowing() then
				return
			end

			if defineFastFlag26 then
				local temporaryOverride, qualityLevel = GfxReset.TemporaryOverride(savedQualityLevel)

				if temporaryOverride then
					local settings = settings()
					settings.Rendering.QualityLevel = qualityLevel
					return
				end
			end

			local v16 = savedQualityLevel / 10
			local qualityLevel = math.floor((settings().Rendering:GetMaxQualityLevel() - 1) * v16)

			if qualityLevel == 20 then
				qualityLevel = 21
			elseif savedQualityLevel == 1 then
				qualityLevel = 1
			elseif savedQualityLevel < 1 and not p then
				savedQualityLevel = 1
				qualityLevel = 1
			elseif settings().Rendering:GetMaxQualityLevel() < qualityLevel then
				qualityLevel = settings().Rendering:GetMaxQualityLevel() - 1
			end

			gameSettings.SavedQualityLevel = savedQualityLevel
			local settings = settings()
			settings.Rendering.QualityLevel = qualityLevel
		end

		local function setGraphicsToAuto() -- 3 equivalent calls inferred from this helper
			newPage.GraphicsQualitySlider:SetZIndex(1)
			newPage.GraphicsQualityLabel.ZIndex = 1
			newPage.GraphicsQualitySlider:SetInteractable(false)

			SetGraphicsQuality(Enum.QualityLevel.Automatic.Value, true)
		end

		local function setGraphicsToManual(p)
			newPage.GraphicsQualitySlider:SetZIndex(2)
			newPage.GraphicsQualityLabel.ZIndex = 2
			newPage.GraphicsQualitySlider:SetInteractable(true)

			if newPage.GraphicsQualitySlider:GetValue() == p then
				SetGraphicsQuality(p)
			else
				newPage.GraphicsQualitySlider:SetValue(p)
			end
		end

		local v16 = false
		newPage.GraphicsQualitySlider.ValueChanged:connect(function(p)
			SetGraphicsQuality(p)

			if v16 == true and not (defineFastFlag7 and v15:isShowing()) then
				reportSettingsForAnalytics()
			end

			v16 = true
		end)

		newPage.GraphicsQualityEnabler.IndexChanged:connect(function(p)
			local v17 = {
				Automatic = { Name = "Automatic", Value = 1 },
				Manual = { Name = "Manual", Value = 2 }
			}

			local name = v17.Automatic.Name
			local name2 = v17.Manual.Name

			if p == v17.Automatic.Value then
				name = v17.Manual.Name
				name2 = v17.Automatic.Name
				setGraphicsToAuto() -- inferred equivalent call
			elseif p == v17.Manual.Value then
				setGraphicsToManual(newPage.GraphicsQualitySlider:GetValue())
			end

			if not (defineFastFlag7 and v15:isShowing()) then
				reportSettingsForAnalytics()
				reportSettingsChangeForAnalytics("gfx_mode", name, name2)
			end
		end)

		game.GraphicsQualityChangeRequest:Connect(function(p)
			if gameSettings.SavedQualityLevel ~= Enum.SavedQualitySetting.Automatic then
				local value = newPage.GraphicsQualitySlider:GetValue()
				local v17

				if p then
					v17 = value + 1
				else
					v17 = value - 1
				end

				newPage.GraphicsQualitySlider:SetValue(v17)
			end
		end)

		if fastInt >= 0 then
			if fastInt == 0 then
				newPage.GraphicsQualityEnabler:SetSelectionIndex(1)
				setGraphicsToAuto() -- inferred equivalent call
			else
				newPage.GraphicsQualityEnabler:SetSelectionIndex(2)
				setGraphicsToManual(fastInt)
			end
		elseif gameSettings.SavedQualityLevel == Enum.SavedQualitySetting.Automatic then
			newPage.GraphicsQualitySlider:SetValue(5)
			setGraphicsToAuto() -- inferred equivalent call
		else
			local savedQualityLevel = tostring(gameSettings.SavedQualityLevel)
			local v17 = not v3[savedQualityLevel] and 10 or v3[savedQualityLevel]

			SetGraphicsQuality(v17)
			spawn(function()
				newPage.GraphicsQualitySlider:SetValue(v17)
			end)
		end

		if defineFastFlag7 then
			gameSettings:GetPropertyChangedSignal("SavedQualityLevel"):Connect(function()
				v15:show(gameSettings.SavedQualityLevel)
			end)
		end
	end

	local function createReducedMotionOptions()
		local v15 = gameSettings.ReducedMotion and 1 or 2

		local formatByKey6 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.ReducedMotion")
		local formatByKey7 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.ReducedMotion")
		local reducedMotionFrame, reducedMotionLabel, reducedMotionMode = Utility:AddNewRow(
			newPage,
			formatByKey6,
			"Selector",
			{
				RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On"),
				(RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off"))
			},
			v15,
			nil,
			formatByKey7
		)
		newPage.ReducedMotionFrame = reducedMotionFrame
		newPage.ReducedMotionLabel = reducedMotionLabel
		newPage.ReducedMotionMode = reducedMotionMode

		newPage.ReducedMotionFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ReducedMotionFrame

		newPage.ReducedMotionMode.IndexChanged:connect(function(p)
			local reducedMotion = gameSettings.ReducedMotion
			gameSettings.ReducedMotion = p == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("reduced_motion", reducedMotion, gameSettings.ReducedMotion)
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createPlayerNamesEnabledOptions()
		local v15

		if defineFastFlag23 then
			v15 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeoplesNames")
		elseif FFlagUpdatePeopleNamesSettingCopy then
			v15 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames")
		else
			v15 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PlayerNames")
		end

		local v16

		if FFlagUpdatePeopleNamesSettingCopy then
			v16 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.PeopleNames.Description")
		end

		local function GetPlayerNamesEnabledStartIndex(): number
			return if gameSettings.PlayerNamesEnabled then 1 else 2
		end

		local v17

		if gameSettings.PlayerNamesEnabled then
			v17 = v9.On
		else
			v17 = v9.Off
		end

		local v18

		if defineFastFlag23 then
			v18 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
		else
			v18 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		end

		local v19

		if defineFastFlag23 then
			v19 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
		else
			v19 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")
		end

		local playerNamesEnabledFrame, playerNamesEnabledLabel, playerNamesEnabledMode = Utility:AddNewRow(
			newPage,
			v15,
			"Selector",
			{ v18, v19 },
			v17,
			nil,
			v16
		)
		newPage.PlayerNamesEnabledFrame = playerNamesEnabledFrame
		newPage.playerNamesEnabledLabel = playerNamesEnabledLabel
		newPage.playerNamesEnabledMode = playerNamesEnabledMode

		newPage.PlayerNamesEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PlayerNamesEnabledFrame

		newPage.playerNamesEnabledMode.IndexChanged:connect(function(p)
			local playerNamesEnabled = gameSettings.PlayerNamesEnabled
			gameSettings.PlayerNamesEnabled = p == 1

			reportSettingsChangeForAnalytics(
				"player_names_enabled",
				playerNamesEnabled,
				gameSettings.PlayerNamesEnabled
			)
			reportSettingsForAnalytics()
		end)
	end

	local function createPreferredTransparencyOptions()
		local v15 = 10 - math.clamp(math.floor(gameSettings.PreferredTransparency * 10 + 0.5), 0, 10)

		local preferredTransparencyFrame, preferredTransparencyLabel, preferredTransparencySlider = Utility:AddNewRow(
			newPage,
			RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTransparency"),
			"Slider",
			10,
			v15,
			nil,
			RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTransparency"),
			RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Transparent"),
			(RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTransparency.Opaque"))
		)
		newPage.PreferredTransparencyFrame = preferredTransparencyFrame
		newPage.PreferredTransparencyLabel = preferredTransparencyLabel
		newPage.PreferredTransparencySlider = preferredTransparencySlider

		newPage.PreferredTransparencyFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTransparencyFrame

		newPage.PreferredTransparencySlider.ValueChanged:connect(function(p)
			local preferredTransparency2 = (10 - math.clamp(math.floor(p), 0, 10)) / 10
			local preferredTransparency = gameSettings.PreferredTransparency
			gameSettings.PreferredTransparency = preferredTransparency2

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"preferred_transparency",
					preferredTransparency,
					gameSettings.PreferredTransparency
				)
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createPreferredTextSizeOptions()
		local enumItems = Enum.PreferredTextSize:GetEnumItems()
		local v15 = gameSettings.PreferredTextSize.Value - 1

		local preferredTextSizeFrame, preferredTextSizeLabel, preferredTextSizeSlider = Utility:AddNewRow(
			newPage,
			RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.PreferredTextSize"),
			"Slider",
			3,
			v15,
			nil,
			RobloxTranslator:FormatByKey("Feature.Accessibility.Description.PreferredTextSize"),
			RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Default"),
			(RobloxTranslator:FormatByKey("Feature.Accessibility.PreferredTextSize.Largest"))
		)
		newPage.PreferredTextSizeFrame = preferredTextSizeFrame
		newPage.PreferredTextSizeLabel = preferredTextSizeLabel
		newPage.PreferredTextSizeSlider = preferredTextSizeSlider

		newPage.PreferredTextSizeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PreferredTextSizeFrame

		newPage.PreferredTextSizeSlider.ValueChanged:connect(function(p)
			local preferredTextSize = gameSettings.PreferredTextSize
			gameSettings.PreferredTextSize = enumItems[p + 1]

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"preferred_text_size",
					preferredTextSize,
					gameSettings.PreferredTextSize
				)
			end

			reportSettingsForAnalytics()
		end)
	end

	local v15 = nil
	local v16 = nil

	local function createUIScaleOptionsImpl()
		local autoUIScaleHundredths = GuiService:GetAutoUIScaleHundredths()
		local rawScreenScale = GuiService:GetRawScreenScale()
		local currentCamera = workspace.CurrentCamera

		if not currentCamera then
			return
		end

		local v17 = currentCamera.ViewportSize.Y * rawScreenScale * GuiService:GetEffectiveUIScaleHundredths() / 100

		local v18 = math.ceil(100 / rawScreenScale / 25) * 25
		local v19 = math.floor(v17 / (540 * rawScreenScale) * 4) / 4 * 100
		local v20 = math.round((v19 - v18) / 25)

		if v20 <= 0 then
			v15 = nil
			v16 = nil

			if newPage.UIScaleModeFrame then
				newPage.UIScaleModeFrame:Destroy()
				newPage.UIScaleModeFrame = nil
			end

			if newPage.UIScaleFrame then
				newPage.UIScaleFrame:Destroy()
				newPage.UIScaleFrame = nil
			end
		else
			if newPage.UIScaleModeFrame and v18 == v15 and v19 == v16 then
				return
			end

			v15 = v18
			v16 = v19

			if newPage.UIScaleModeFrame then
				newPage.UIScaleModeFrame:Destroy()
				newPage.UIScaleModeFrame = nil
			end

			if newPage.UIScaleFrame then
				newPage.UIScaleFrame:Destroy()
				newPage.UIScaleFrame = nil
			end

			local function indexToHundredths(p) -- 2 equivalent calls inferred from this helper
				return v18 + p * 25
			end
			local function hundredthsToIndex(p) -- 2 equivalent calls inferred from this helper
				return (math.clamp(math.round((p - v18) / 25), 0, v20))
			end

			local uiScaleMultiplierHundredths = UserGameSettings.UIScaleMultiplierHundredths
			local visible = uiScaleMultiplierHundredths ~= 0
			local v21 = not visible and 0 or hundredthsToIndex(uiScaleMultiplierHundredths) -- inferred equivalent call
			local v22 = {
				modeTitle = "CoreScripts.InGameMenu.GameSettings.UIScaleMode",
				modeAuto = "CoreScripts.InGameMenu.GameSettings.UIScaleModeAuto",
				modeManual = "CoreScripts.InGameMenu.GameSettings.UIScaleModeManual",
				sliderTitle = "CoreScripts.InGameMenu.GameSettings.UIScale",
				smallest = "CoreScripts.InGameMenu.GameSettings.UIScaleSmallest",
				largest = "CoreScripts.InGameMenu.GameSettings.UIScaleLargest"
			}

			local uiScaleModeFrame, uiScaleModeLabel, uiScaleModeSelector = Utility:AddNewRow(
				newPage,
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleMode"),
				"Selector",
				{
					localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleModeAuto"),
					localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleModeManual")
				},
				visible and 2 or 1
			)
			newPage.UIScaleModeFrame = uiScaleModeFrame
			newPage.UIScaleModeLabel = uiScaleModeLabel
			newPage.UIScaleModeSelector = uiScaleModeSelector

			newPage.UIScaleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UIScaleModeFrame

			local uiScaleFrame, uiScaleLabel, uiScaleSlider = Utility:AddNewRow(
				newPage,
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScale"),
				"Slider",
				v20,
				v21,
				nil,
				nil,
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleSmallest"),
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleLargest")
			)
			newPage.UIScaleFrame = uiScaleFrame
			newPage.UIScaleLabel = uiScaleLabel
			newPage.UIScaleSlider = uiScaleSlider

			newPage.UIScaleFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UIScaleFrame
			newPage.UIScaleFrame.Visible = visible

			newPage.UIScaleModeSelector.IndexChanged:connect(function(p)
				local visible2 = p == 2
				newPage.UIScaleFrame.Visible = visible2

				if visible2 then
					local v23 = math.clamp(math.round(autoUIScaleHundredths / 25) * 25, v18, indexToHundredths(v20)) -- inferred equivalent call

					newPage.UIScaleSlider:SetValue(hundredthsToIndex(v23)) -- inferred equivalent call
					GuiService:SetUIScaleMultiplier(v23)
					reportSettingsChangeForAnalytics("ui_scale_mode", "auto", "manual")
				else
					GuiService:SetUIScaleMultiplier(0)
					reportSettingsChangeForAnalytics("ui_scale_mode", "manual", "auto")
				end

				reportSettingsForAnalytics()
			end)

			newPage.UIScaleSlider.ValueChanged:connect(function(p)
				local uiScaleMultiplierHundredths2 = UserGameSettings.UIScaleMultiplierHundredths
				local v23 = indexToHundredths(p) -- inferred equivalent call
				GuiService:SetUIScaleMultiplier(v23)
				reportSettingsChangeForAnalytics("ui_scale_value", uiScaleMultiplierHundredths2, v23)
				reportSettingsForAnalytics()
			end)
		end
	end

	local function createUIScaleOptions() -- 3 equivalent calls inferred from this helper
		local success, result = pcall(createUIScaleOptionsImpl)

		if not success then
			warn("createUIScaleOptions failed: " .. tostring(result))
		end
	end

	local v17 = nil
	local flag = false

	local function getUIScaleModeIndex(p): number -- 2 equivalent calls inferred from this helper
		return if p.savedHundredths == 0 then 1 else 2
	end

	local function refreshUIScaleRows()
		local v18 = UIScaleOptions.get(GuiService)

		if not (newPage.UIScaleModeFrame and v18) or v17 and UIScaleOptions.equal(v18, v17) then
			return
		end

		v17 = v18
		local uiScaleModeIndex = getUIScaleModeIndex(v18) -- inferred equivalent call
		local visible = uiScaleModeIndex == 2
		local selectedIndex = v18.selectedIndex
		flag = true
		newPage.UIScaleFrame.Visible = visible

		if newPage.UIScaleModeSelector:GetSelectedIndex() ~= uiScaleModeIndex then
			newPage.UIScaleModeSelector:SetSelectionIndex(uiScaleModeIndex)
		end

		newPage.UIScaleSlider:SetEnabledSteps(v18.enabled)
		newPage.UIScaleSlider:SetValue(selectedIndex)
		flag = false
	end

	local function onUIScaleModeChanged(p)
		if flag or p ~= newPage.UIScaleModeSelector:GetSelectedIndex() then
			return
		end

		local v18 = p == 2
		local v19 = UIScaleOptions.get(GuiService)
		local v20

		if v19 then
			v20 = UIScaleOptions.valueForMode(v19, v18)
		end

		if v20 == nil then
			return
		end

		GuiService:SetUIScaleMultiplier(v20)
		reportSettingsChangeForAnalytics("ui_scale_mode", v18 and "auto" or "manual", v18 and "manual" or "auto")

		refreshUIScaleRows()
	end

	local function onUIScaleSliderChanged(p)
		if flag then
			return
		end

		local v18 = UIScaleOptions.get(GuiService)

		if not v18 then
			return
		end

		local valueFromSlider = UIScaleOptions.valueFromSlider(p, newPage.UIScaleSlider:GetValue(), v17, v18)

		if valueFromSlider then
			GuiService:SetUIScaleMultiplier(valueFromSlider)
			reportSettingsChangeForAnalytics("ui_scale_value", v18.savedHundredths, valueFromSlider)
		end

		refreshUIScaleRows()
	end

	local function createUIScaleRows()
		local v18 = UIScaleOptions.get(GuiService)

		if not v18 then
			return
		end

		local uiScaleModeFrame, uiScaleModeLabel, uiScaleModeSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleMode"),
			"Selector",
			{
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleModeAuto"),
				localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleModeManual")
			},
			getUIScaleModeIndex(v18), -- inferred equivalent call
			nil,
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleModeDescription")
		)
		newPage.UIScaleModeFrame = uiScaleModeFrame
		newPage.UIScaleModeLabel = uiScaleModeLabel
		newPage.UIScaleModeSelector = uiScaleModeSelector

		newPage.UIScaleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UIScaleEngineModeFrame
		local uiScaleFrame, uiScaleLabel, uiScaleSlider = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScale"),
			"Slider",
			#v18.values,
			v18.selectedIndex,
			nil,
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleDescription"),
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleSmallest"),
			localization:Format("CoreScripts.InGameMenu.GameSettings.UIScaleLargest")
		)
		newPage.UIScaleFrame = uiScaleFrame
		newPage.UIScaleLabel = uiScaleLabel
		newPage.UIScaleSlider = uiScaleSlider

		newPage.UIScaleFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UIScaleEngineFrame
		newPage.UIScaleSlider:SetMinStep(1)

		newPage.UIScaleModeSelector.IndexChanged:Connect(onUIScaleModeChanged)
		newPage.UIScaleSlider.ValueChanged:connect(onUIScaleSliderChanged)

		refreshUIScaleRows()
	end

	local function createUiNavigationKeyBindOptions()
		local v18 = { On = 1, Off = 2 }

		local v19 = gameSettings.UiNavigationKeyBindEnabled and 1 or 2

		local formatByKey6 = RobloxTranslator:FormatByKey("Feature.Accessibility.Heading.UiNavigationKeyBind")

		local formatByKey7 = RobloxTranslator:FormatByKey("Feature.Accessibility.Description.UiNavigationKeyBind", {
			uiNavigationKey = UserInputService:GetStringForKeyCode(Enum.KeyCode.BackSlash)
		})

		local uiNavigationKeyBindEnabledFrame, uiNavigationKeyBindEnabledLabel, uiNavigationKeyBindEnabledMode = Utility:AddNewRow(
			newPage,
			formatByKey6,
			"Selector",
			{
				RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On"),
				(RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off"))
			},
			v19,
			nil,
			formatByKey7
		)
		newPage.UiNavigationKeyBindEnabledFrame = uiNavigationKeyBindEnabledFrame
		newPage.UiNavigationKeyBindEnabledLabel = uiNavigationKeyBindEnabledLabel
		newPage.UiNavigationKeyBindEnabledMode = uiNavigationKeyBindEnabledMode

		newPage.UiNavigationKeyBindEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiNavigationKeyBindEnabledFrame

		newPage.UiNavigationKeyBindEnabledMode.IndexChanged:connect(function(p)
			local uiNavigationKeyBindEnabled = gameSettings.UiNavigationKeyBindEnabled
			gameSettings.UiNavigationKeyBindEnabled = p == 1

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"ui_navigation_key_bind_enabled",
					uiNavigationKeyBindEnabled,
					gameSettings.UiNavigationKeyBindEnabled
				)
			end

			reportSettingsForAnalytics()
		end)
		local function updateUiNavigationKeyBindVisibility()
			local keyboardEnabled = UserInputService.KeyboardEnabled

			if newPage.UiNavigationKeyBindEnabledFrame then
				newPage.UiNavigationKeyBindEnabledFrame.Visible = keyboardEnabled

				if keyboardEnabled then
					newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(gameSettings.UiNavigationKeyBindEnabled and 1 or 2)
				else
					newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(2)
					gameSettings.UiNavigationKeyBindEnabled = false
				end
			end
		end

		local keyboardEnabled = UserInputService.KeyboardEnabled

		if newPage.UiNavigationKeyBindEnabledFrame then
			newPage.UiNavigationKeyBindEnabledFrame.Visible = keyboardEnabled

			if keyboardEnabled then
				newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(gameSettings.UiNavigationKeyBindEnabled and v18.On or v18.Off)
			else
				newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(v18.Off)
				gameSettings.UiNavigationKeyBindEnabled = false
			end
		end

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
			local keyboardEnabled2 = UserInputService.KeyboardEnabled

			if newPage.UiNavigationKeyBindEnabledFrame then
				newPage.UiNavigationKeyBindEnabledFrame.Visible = keyboardEnabled2

				if keyboardEnabled2 then
					newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(gameSettings.UiNavigationKeyBindEnabled and v18.On or v18.Off)
				else
					newPage.UiNavigationKeyBindEnabledMode:SetSelectionIndex(v18.Off)
					gameSettings.UiNavigationKeyBindEnabled = false
				end
			end
		end)
	end

	local function createPerformanceStatsOptions()
		newPage.PerformanceStatsFrame = nil
		newPage.PerformanceStatsLabel = nil
		newPage.PerformanceStatsMode = nil
		newPage.PerformanceStatsOverrideText = nil

		function GetDesiredPerformanceStatsIndex(): number
			return if gameSettings.PerformanceStatsVisible then 1 else 2
		end

		local performanceStatsFrame, performanceStatsLabel2, performanceStatsMode = Utility:AddNewRow(
			newPage,
			"Performance Stats",
			"Selector",
			{ "On", "Off" },
			(GetDesiredPerformanceStatsIndex())
		)
		newPage.PerformanceStatsFrame = performanceStatsFrame
		newPage.PerformanceStatsLabel = performanceStatsLabel2
		newPage.PerformanceStatsMode = performanceStatsMode

		newPage.PerformanceStatsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PerformanceStatsFrame

		local create = Create("TextLabel")
		local performanceStatsLabel = {
			Name = "PerformanceStatsLabel",
			Text = "Set by Developer",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			BackgroundTransparency = 1,
			Size = 0,
			Position = 0,
			AnchorPoint = 0,
			Visible = false,
			ZIndex = 2,
			Parent = 0
		}
		local size

		if defineFastFlag3 then
			size = UDim2.new(0.6, 0, 1, 0)
		else
			size = UDim2.new(0, 200, 1, 0)
		end

		performanceStatsLabel.Size = size
		local position

		if defineFastFlag3 then
			position = UDim2.new(1, 0, 0.5, 0)
		else
			position = UDim2.new(1, -350, 0, 0)
		end

		performanceStatsLabel.Position = position
		local anchorPoint

		if defineFastFlag3 then
			anchorPoint = Vector2.new(1, 0.5)
		end

		performanceStatsLabel.AnchorPoint = anchorPoint

		performanceStatsLabel.Parent = newPage.PerformanceStatsFrame
		newPage.PerformanceStatsOverrideText = create(performanceStatsLabel)

		newPage.PerformanceStatsMode.IndexChanged:connect(function(p)
			local performanceStatsVisible

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				performanceStatsVisible = gameSettings.PerformanceStatsVisible
			end

			if p == 1 then
				gameSettings.PerformanceStatsVisible = true
			else
				gameSettings.PerformanceStatsVisible = false
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"show_performance_stats",
					performanceStatsVisible,
					gameSettings.PerformanceStatsVisible
				)
			end

			reportSettingsForAnalytics()
		end)

		gameSettings.PerformanceStatsVisibleChanged:connect(function()
			local v18 = GetDesiredPerformanceStatsIndex()

			if v18 ~= newPage.PerformanceStatsMode.CurrentIndex then
				newPage.PerformanceStatsMode:SetSelectionIndex(v18)
			end
		end)
	end

	local function createWebServerInformationRow()
		local v18

		if defineFastFlag5 then
			v18 = false
		end

		local informationFrame, informationLabel, informationTextBox = Utility:AddNewRow(
			newPage,
			"MicroProfiler Information",
			"TextBox",
			nil,
			nil,
			5,
			nil,
			nil,
			nil,
			v18
		)
		newPage.InformationFrame = informationFrame
		newPage.InformationLabel = informationLabel
		newPage.InformationTextBox = informationTextBox

		newPage.InformationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.InformationFrame

		newPage.InformationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

		if TouchEnabled then
			newPage.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size18),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(0, 5, 0, 0),
				Visible = true,
				ZIndex = 2,
				Parent = newPage.InformationFrame
			})
		else
			newPage.InformationText = Create("TextLabel")({
				Name = "InformationLabel",
				Text = "Information Loading",
				Font = Theme.font(Enum.Font.SourceSans),
				FontSize = Theme.fontSize(Enum.FontSize.Size14),
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 800, 1, 0),
				Position = UDim2.new(1, -650, 0, 20),
				Visible = true,
				ZIndex = 2,
				Parent = newPage.InformationFrame
			})
		end

		return newPage.InformationFrame, newPage.InformationText
	end

	local function createMicroProfilerOptions()
		newPage.MicroProfilerFrame = nil
		newPage.MicroProfilerLabel = nil
		newPage.MicroProfilerMode = nil
		newPage.MicroProfilerOverrideText = nil

		local function tryContentLabel(): boolean -- 2 equivalent calls inferred from this helper
			local microProfilerWebServerPort = gameSettings.MicroProfilerWebServerPort

			if microProfilerWebServerPort == 0 then
				return false
			end

			local webServerInformationRow, informationText = createWebServerInformationRow()
			newPage.InformationFrame = webServerInformationRow
			newPage.InformationText = informationText
			newPage.InformationText.Text = gameSettings.MicroProfilerWebServerIP .. microProfilerWebServerPort
			return true
		end

		local function setMicroProfilerIndex(p)
			local function hideContentLabel() -- 2 equivalent calls inferred from this helper
				gameSettings.MicroProfilerWebServerEnabled = false

				if newPage.InformationFrame or newPage.InformationText then
					newPage.InformationFrame.Visible = false
					newPage.InformationFrame.Parent = nil
					newPage.InformationText.Parent = nil
					newPage.InformationFrame = nil
					newPage.InformationText = nil
				end
			end

			local microprofiler_type = nil
			local v18 = nil
			local v19 = nil

			if v13 then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					v18 = gameSettings.MicroProfilerWebServerEnabled
					microprofiler_type = "webserver"
				end

				if p == 1 then
					gameSettings.MicroProfilerWebServerEnabled = true
					local v20 = 30

					while v20 >= 1 do
						if tryContentLabel() then -- inferred equivalent call
							break
						end

						v20 -= 1
						wait(0.1)
					end

					if v20 <= 0 then
						newPage.MicroProfilerMode:SetSelectionIndex(2)
						hideContentLabel() -- inferred equivalent call
					end
				else
					hideContentLabel() -- inferred equivalent call
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					v19 = gameSettings.MicroProfilerWebServerEnabled
				end
			elseif v12 or isInExperienceUIVREnabled and isSpatial() then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					v18 = gameSettings.OnScreenProfilerEnabled
					microprofiler_type = "regular"
				end

				gameSettings.OnScreenProfilerEnabled = p == 1

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					v19 = gameSettings.OnScreenProfilerEnabled
				end
			end

			RbxAnalyticsService:ReportCounter("MicroprofilerSettingsPressed")

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("microprofiler_enabled", v18, v19, {
					microprofiler_type = microprofiler_type
				})
			end

			reportSettingsForAnalytics()
		end

		local function GetDesiredWebServerIndex(): number -- 1 equivalent call inferred from this helper
			if v13 then
				if gameSettings.MicroProfilerWebServerEnabled then
					return 1
				end
			elseif (v12 or isInExperienceUIVREnabled and isSpatial()) and gameSettings.OnScreenProfilerEnabled then
				return 1
			end

			return 2
		end

		local desiredWebServerIndex = GetDesiredWebServerIndex() -- inferred equivalent call
		local microProfilerFrame, microProfilerLabel, microProfilerMode = Utility:AddNewRow(
			newPage,
			RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MicroProfiler"),
			"Selector",
			{ "On", "Off" },
			desiredWebServerIndex
		)
		newPage.MicroProfilerFrame = microProfilerFrame
		newPage.MicroProfilerLabel = microProfilerLabel
		newPage.MicroProfilerMode = microProfilerMode

		newPage.MicroProfilerFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MicroProfilerFrame
		tryContentLabel() -- inferred equivalent call
		local flag2 = false

		gameSettings:GetPropertyChangedSignal("OnScreenProfilerEnabled"):Connect(function()
			flag2 = true

			if gameSettings.OnScreenProfilerEnabled then
				newPage.MicroProfilerMode:SetSelectionIndex(1)
			else
				newPage.MicroProfilerMode:SetSelectionIndex(2)
			end
		end)

		local function onIndexChanged(...)
			if flag2 then
				flag2 = false
			else
				setMicroProfilerIndex(...)
			end
		end

		newPage.MicroProfilerMode.IndexChanged:connect(onIndexChanged)
	end

	local function createCameraModeOptions(touchEnabled)
		newPage.ShiftLockFrame = nil
		newPage.ShiftLockLabel = nil
		newPage.ShiftLockMode = nil
		newPage.ShiftLockOverrideText = nil

		local shiftLockFrame, shiftLockLabel, shiftLockMode = Utility:AddNewRow(
			newPage,
			"Shift Lock Switch",
			"Selector",
			{ "On", "Off" },
			gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch and 1 or 2
		)
		newPage.ShiftLockFrame = shiftLockFrame
		newPage.ShiftLockLabel = shiftLockLabel
		newPage.ShiftLockMode = shiftLockMode

		newPage.ShiftLockFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ShiftLockFrame

		set[newPage.ShiftLockFrame] = true

		local create = Create("TextLabel")
		local shiftLockOverrideLabel = {
			Name = "ShiftLockOverrideLabel",
			Text = "Set by Developer",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			BackgroundTransparency = 1,
			Size = 0,
			Position = 0,
			AnchorPoint = 0,
			Visible = false,
			ZIndex = 2,
			Parent = 0
		}
		local size

		if defineFastFlag3 then
			size = UDim2.new(0.6, 0, 1, 0)
		else
			size = UDim2.new(0, 200, 1, 0)
		end

		shiftLockOverrideLabel.Size = size
		local position

		if defineFastFlag3 then
			position = UDim2.new(1, 0, 0.5, 0)
		else
			position = UDim2.new(1, -350, 0, 0)
		end

		shiftLockOverrideLabel.Position = position
		local anchorPoint

		if defineFastFlag3 then
			anchorPoint = Vector2.new(1, 0.5)
		end

		shiftLockOverrideLabel.AnchorPoint = anchorPoint

		shiftLockOverrideLabel.Parent = newPage.ShiftLockFrame
		newPage.ShiftLockOverrideText = create(shiftLockOverrideLabel)

		newPage.ShiftLockMode.IndexChanged:connect(function(p)
			local v18

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v18 = gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
			end

			if p == 1 then
				gameSettings.ControlMode = Enum.ControlMode.MouseLockSwitch
			else
				gameSettings.ControlMode = Enum.ControlMode.Classic
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"shift_lock_enabled",
					v18,
					gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
				)
			end

			reportSettingsForAnalytics()
		end)

		local function setShiftLockSelectorVisible(flag2: boolean) -- 1 equivalent call inferred from this helper
			local devEnableMouseLock = flag2 and LocalPlayer.DevEnableMouseLock

			if newPage.ShiftLockMode then
				newPage.ShiftLockMode.SelectorFrame.Visible = devEnableMouseLock
				newPage.ShiftLockMode:SetInteractable(devEnableMouseLock)
			end
		end

		local function applyDevOverrideShiftLockSelector() -- 3 equivalent calls inferred from this helper
			local visible = not LocalPlayer.DevEnableMouseLock

			if newPage.ShiftLockOverrideText then
				newPage.ShiftLockOverrideText.Visible = visible
				setShiftLockSelectorVisible(not visible) -- inferred equivalent call
			end
		end

		local function updateShiftLockVisibility() -- 3 equivalent calls inferred from this helper
			local keyboardEnabled = UserInputService.MouseEnabled and UserInputService.KeyboardEnabled

			if newPage.ShiftLockFrame then
				newPage.ShiftLockFrame.Visible = keyboardEnabled
			end

			applyDevOverrideShiftLockSelector() -- inferred equivalent call
		end

		updateShiftLockVisibility() -- inferred equivalent call
		UserInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(function()
			updateShiftLockVisibility() -- inferred equivalent call
		end)

		UserInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(function()
			updateShiftLockVisibility() -- inferred equivalent call
		end)

		function cameraModeIsUserChoice(): boolean
			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				return LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
			end

			return LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end

		function setCameraModeVisible(visible)
			if newPage.CameraMode then
				newPage.CameraMode.SelectorFrame.Visible = visible
				newPage.CameraMode:SetInteractable(visible)
				newPage.CameraModeOverrideText.Visible = not visible
			end
		end

		local v18 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

		local v19 = {}
		local v20 = {}

		local function updateCurrentCameraMovementIndex(p)
			local v21 = nil

			if not pcall(function()
				v21 = v20[v19[p]]
			end) or v21 == nil then
				return false
			end

			local value = nil
			local v22

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					value = gameSettings.TouchCameraMovementMode.Value
				end

				v22 = gameSettings.TouchCameraMovementMode.Value ~= v21
				gameSettings.TouchCameraMovementMode = v21
			else
				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					value = gameSettings.ComputerCameraMovementMode.Value
				end

				v22 = gameSettings.ComputerCameraMovementMode.Value ~= v21
				gameSettings.ComputerCameraMovementMode = v21
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() and v22 then
				reportSettingsChangeForAnalytics("camera_mode", value, v21)
			end

			return v22
		end

		local function updateCameraMovementModes()
			local v21

			if v18 then
				if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
					v21 = v18:GetRegisteredTouchCameraMovementModes()
				else
					v21 = v18:GetRegisteredComputerCameraMovementModes()
				end
			else
				v21 = {}
			end

			v19 = {}
			v20 = {}

			if #v21 <= 0 then
				setCameraModeVisible(false)
				return
			end

			for i = 1, #v21 do
				local v22 = v21[i]
				local v23 = v22.Name

				if v23 == "Default" then
					if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
						v23 = v6.DEFAULT_FOLLOW
					else
						v23 = v6.DEFAULT_CLASSIC
					end
				end

				v19[#v19 + 1] = v23
				v20[v23] = v22.Value
			end

			if newPage.CameraMode then
				newPage.CameraMode:UpdateOptions(v19)
			end

			local v22 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
			local value

			if v22 then
				value = gameSettings.TouchCameraMovementMode.Value
			else
				value = gameSettings.ComputerCameraMovementMode.Value
			end

			if value > -1 then
				if v22 or gameSettings.ComputerCameraMovementMode ~= Enum.ComputerCameraMovementMode.CameraToggle then
					value += 1
				end

				updateCurrentCameraMovementIndex(value)
				newPage.CameraMode:SetSelectionIndex(value)
			end

			setCameraModeVisible(cameraModeIsUserChoice())
		end

		local cameraModeFrame, cameraModeLabel, cameraMode = Utility:AddNewRow(
			newPage,
			"Camera Mode",
			"Selector",
			v19,
			1
		)
		newPage.CameraModeFrame = cameraModeFrame
		newPage.CameraModeLabel = cameraModeLabel
		newPage.CameraMode = cameraMode

		newPage.CameraModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraModeFrame

		set[newPage.CameraMode] = true

		newPage.CameraModeOverrideText = Create("TextLabel")({
			Name = "CameraDevOverrideLabel",
			Text = "Set by Developer",
			TextColor3 = Color3.new(1, 1, 1),
			Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
			FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
			BackgroundTransparency = 1,
			Size = UDim2.new(0.6, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			Visible = false,
			ZIndex = 2,
			Parent = newPage.CameraModeFrame
		})

		if v18 then
			v18.TouchCameraMovementModeRegistered:connect(function(p)
				if UserInputService.TouchEnabled then
					updateCameraMovementModes()
				end
			end)

			v18.ComputerCameraMovementModeRegistered:connect(function(p)
				if UserInputService.MouseEnabled then
					updateCameraMovementModes()
				end
			end)
		end

		UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			updateCameraMovementModes()
		end)

		local flag2 = false
		newPage.CameraMode.IndexChanged:connect(function(p)
			if updateCurrentCameraMovementIndex(p) then
				if flag2 then
					reportSettingsForAnalytics()
				end

				flag2 = true
			end
		end)

		updateCameraMovementModes()

		local v21 = false
		local function createVROption()
			if not v21 then
				v21 = true

				local v22 = gameSettings.VREnabled and { "On", "Off (restart pending)" }
					or { "On (restart pending)", "Off" }

				local vrEnabledFrame, vrEnabledLabel, vrEnabledSelector = Utility:AddNewRow(
					newPage,
					"VR",
					"Selector",
					v22,
					gameSettings.VREnabled and 1 or 2
				)
				newPage.VREnabledFrame = vrEnabledFrame
				newPage.VREnabledLabel = vrEnabledLabel
				newPage.VREnabledSelector = vrEnabledSelector

				newPage.VREnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VREnabledFrame

				newPage.VREnabledSelector.IndexChanged:connect(function(p)
					local v23 = {
						On = { Name = "On", Value = 1 },
						Off = { Name = "Off", Value = 2 }
					}

					local vrEnabled = p == v23.On.Value

					if gameSettings.VREnabled ~= vrEnabled then
						gameSettings.VREnabled = vrEnabled
						local v24 = v22[v23.On.Value]
						local v25 = v22[p]

						if v25 == v22[v23.On.Value] then
							v24 = v22[v23.Off.Value]
						end

						reportSettingsChangeForAnalytics("vr_mode", v24, v25)
					end
				end)
			end
		end

		local function onVREnabledChanged() -- 1 equivalent call inferred from this helper
			if VRService.VREnabled then
				gameSettings.HasEverUsedVR = true
				createVROption()
			elseif gameSettings.HasEverUsedVR then
				createVROption()
			end
		end

		if GetFFlagAlwaysShowVRToggle() and getAppFeaturePolicies().getIsLinkedVRModeAvailable() then
			createVROption()
		else
			onVREnabledChanged() -- inferred equivalent call
			VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabledChanged)
		end

		local v22 = {}
		local v23 = {}
		local v24 = {}
		local v25 = {}

		local function setMovementModeVisible(p) -- 5 equivalent calls inferred from this helper
			if newPage.MovementMode then
				local visible = p and #v22 > 0
				newPage.MovementMode.SelectorFrame.Visible = visible
				newPage.MovementMode:SetInteractable(visible)
				newPage.MovementModeOverrideText.Visible = not visible
			end
		end

		local fn

		if touchEnabled then
			local v26 = CoreUtility.waitForChildOfClass(LocalPlayer, "PlayerScripts")

			local function getDisplayName(p)
				if p == "Default" then
					if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
						return (RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey))
					end

					return v8.DEFAULT_KEYBOARD
				end

				if p == "KeyboardMouse" then
					return "Keyboard + Mouse"
				end

				if p == "ClickToMove" then
					if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
						return v8.TAP_TO_MOVE
					end

					return v8.CLICK_TO_MOVE
				end

				if p == "DynamicThumbstick" then
					return "Dynamic Thumbstick"
				end

				if p == "Thumbstick" then
					p = formatByKey
				end

				return p
			end

			local movementModeFrame, movementModeLabel, movementMode = Utility:AddNewRow(
				newPage,
				"Movement Mode",
				"Selector",
				{},
				1
			)
			newPage.MovementModeFrame = movementModeFrame
			newPage.MovementModeLabel = movementModeLabel
			newPage.MovementMode = movementMode

			newPage.MovementModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MovementModeFrame

			set[newPage.MovementMode] = true

			newPage.MovementModeOverrideText = Create("TextLabel")({
				Name = "MovementDevOverrideLabel",
				Text = "Set by Developer",
				TextColor3 = Color3.new(1, 1, 1),
				Font = Theme.font(Enum.Font.SourceSans, "GameSettings"),
				FontSize = Theme.fontSize(Enum.FontSize.Size24, "GameSettings"),
				BackgroundTransparency = 1,
				Size = UDim2.new(0.6, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Visible = false,
				ZIndex = 2,
				Parent = newPage.MovementModeFrame
			})

			local function setMovementMode(p)
				local v27 = nil

				if p.EnumType == Enum.TouchMovementMode then
					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						v27 = gameSettings.TouchMovementMode
					end

					gameSettings.TouchMovementMode = p
				else
					if GetFFlagEnableExplicitSettingsChangeAnalytics() then
						v27 = gameSettings.ComputerMovementMode
					end

					gameSettings.ComputerMovementMode = p
				end

				if GetFFlagEnableExplicitSettingsChangeAnalytics() then
					reportSettingsChangeForAnalytics("movement_mode", v27, p)
				end
			end
			fn = function(flag3: boolean)
				local v27

				if flag3 then
					v27 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice
				else
					v27 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice
				end

				setMovementModeVisible(v27) -- inferred equivalent call

				if newPage.MovementModeOverrideText then
					newPage.MovementModeOverrideText.Visible = not v27
				end
			end
			local function updateMovementModes()
				local v27 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

				if v26 then
					if v27 then
						v22 = v26:GetRegisteredTouchMovementModes()
					else
						v22 = v26:GetRegisteredComputerMovementModes()
					end
				end

				v23 = {}
				v24 = {}
				v25 = {}

				if #v22 <= 0 then
					if newPage.MovementMode then
						newPage.MovementMode.SelectorFrame.Visible = false
						newPage.MovementMode:SetInteractable(false)
						newPage.MovementModeOverrideText.Visible = true
					end
				else
					setMovementModeVisible(true) -- inferred equivalent call

					for k, v28 in v22 do
						v24[k] = v28
						local v29 = v25
						local v30 = v28.Name

						if v30 == "Default" then
							if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
								v30 = RobloxTranslator:FormatByKey(Constants.MovementModeDynamicThumbstickKey)
							else
								v30 = v8.DEFAULT_KEYBOARD
							end
						elseif v30 == "KeyboardMouse" then
							v30 = "Keyboard + Mouse"
						elseif v30 == "ClickToMove" then
							if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
								v30 = v8.TAP_TO_MOVE
							else
								v30 = v8.CLICK_TO_MOVE
							end
						elseif v30 == "DynamicThumbstick" then
							v30 = "Dynamic Thumbstick"
						elseif v30 == "Thumbstick" then
							v30 = formatByKey
						end

						v29[k] = v30
						v23[v28] = k
					end

					if newPage.MovementMode then
						newPage.MovementMode:UpdateOptions(v25)
					end

					local v28

					if v27 then
						v28 = gameSettings.TouchMovementMode
					else
						v28 = gameSettings.ComputerMovementMode
					end

					if v28 then
						setMovementMode(v28)
						newPage.MovementMode:SetSelectionIndex(v23[v28])
					end

					fn(v27)
				end
			end

			updateMovementModes()

			if v26 then
				v26.TouchMovementModeRegistered:connect(function(p)
					if UserInputService.TouchEnabled then
						updateMovementModes()
					end
				end)

				v26.ComputerMovementModeRegistered:connect(function(p)
					if UserInputService.MouseEnabled then
						updateMovementModes()
					end
				end)
			end

			UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
				updateMovementModes()
			end)

			newPage.MovementMode.IndexChanged:connect(function(p)
				setMovementMode(v24[p])
				reportSettingsForAnalytics()
			end)
		else
			fn = function(flag3: boolean) end
		end

		local v26 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
		local v27

		if v26 then
			v27 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
		else
			v27 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
		end

		if v27 then
			newPage.CameraModeOverrideText.Visible = false
			setCameraModeVisible(true)
		else
			newPage.CameraModeOverrideText.Visible = true
			setCameraModeVisible(false)
		end

		local v28

		if v26 then
			v28 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice
		else
			v28 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice
		end

		if newPage.MovementModeOverrideText then
			if v28 then
				newPage.MovementModeOverrideText.Visible = false
				setMovementModeVisible(true) -- inferred equivalent call
			else
				newPage.MovementModeOverrideText.Visible = true

				if newPage.MovementMode then
					newPage.MovementMode.SelectorFrame.Visible = false
					newPage.MovementMode:SetInteractable(false)
					newPage.MovementModeOverrideText.Visible = true
				end
			end
		end

		applyDevOverrideShiftLockSelector() -- inferred equivalent call

		local function updateUserSettingsMenu(p)
			if p == "DevEnableMouseLock" then
				applyDevOverrideShiftLockSelector() -- inferred equivalent call
			elseif p == "DevComputerCameraMode" then
				local v29 = LocalPlayer.DevComputerCameraMode == Enum.DevComputerCameraMovementMode.UserChoice
				setCameraModeVisible(v29)
				newPage.CameraModeOverrideText.Visible = not v29
			elseif p == "DevComputerMovementMode" then
				if fn ~= nil then
					fn(false)
					return
				end

				local v29 = LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice
				setMovementModeVisible(v29) -- inferred equivalent call

				if newPage.MovementModeOverrideText then
					newPage.MovementModeOverrideText.Visible = not v29
				end
			elseif p == "DevTouchMovementMode" then
				if fn ~= nil then
					fn(true)
					return
				end

				local v29 = LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice
				setMovementModeVisible(v29) -- inferred equivalent call

				if newPage.MovementModeOverrideText then
					newPage.MovementModeOverrideText.Visible = not v29
				end
			elseif p == "DevTouchCameraMode" then
				local v29 = LocalPlayer.DevTouchCameraMode == Enum.DevTouchCameraMovementMode.UserChoice
				setCameraModeVisible(v29)
				newPage.CameraModeOverrideText.Visible = not v29
			end
		end

		LocalPlayer.Changed:connect(function(p)
			if v5[p] then
				updateUserSettingsMenu(p)
			end

			if v4[p] then
				updateUserSettingsMenu(p)
			end
		end)
	end

	local function createFeedbackModeOptions()
		local url = Url.ROLES_URL .. "v1/users/authenticated/roles"
		local internal = HttpService:RequestInternal({ Url = url, Method = "GET" })

		local function rolesCheckCallback(p)
			if p then
				if
					not defineFastFlag22
					and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
					and not newPage.FeedbackEntryPointEnabled
				then
					return
				end

				local function onToggleFeedbackMode()
					if
						defineFastFlag22
						and game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
						and not newPage.FeedbackEntryPointEnabled
					then
						return
					end

					newPage.HubRef:PopMenu(false, true)

					if game:GetEngineFeature("SafetyServiceCaptureModeReportProp") then
						SafetyService.IsCaptureModeForReport = false
					end

					if ExperienceStateCaptureService ~= nil then
						ExperienceStateCaptureService:ToggleCaptureMode()
					end

					reportSettingsChangeForAnalytics("translation_feedback", "", "pressed")
				end

				local toggleFeedbackModeButton, toggleFeedbackModeText

				if defineFastFlag21 then
					toggleFeedbackModeButton, toggleFeedbackModeText = Utility:MakeStyledButton(
						"toggleFeedbackModeButton",
						formatByKey3,
						UDim2.new(1, 0, 1, -20),
						onToggleFeedbackMode,
						newPage
					)

					toggleFeedbackModeButton.Size = UDim2.new(0.6, 0, 0, 40)
				else
					toggleFeedbackModeButton, toggleFeedbackModeText = Utility:MakeStyledButton(
						"toggleFeedbackModeButton",
						formatByKey3,
						UDim2.new(0, 300, 1, -20),
						onToggleFeedbackMode,
						newPage
					)

					toggleFeedbackModeButton.Size = UDim2.new(0, 300, 0, 30)
				end

				toggleFeedbackModeButton.Position = UDim2.new(0.4, 0, 0.5, 0)
				toggleFeedbackModeButton.AnchorPoint = Vector2.new(0, 0.5)

				toggleFeedbackModeButton.ZIndex = 2
				toggleFeedbackModeButton.Selectable = true
				toggleFeedbackModeText.ZIndex = 2

				if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
					newPage.toggleFeedbackModeButton = toggleFeedbackModeButton
					newPage.toggleFeedbackModeText = toggleFeedbackModeText
				end

				if defineFastFlag21 then
					local addNewRowObject = Utility:AddNewRowObject(
						newPage,
						RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"),
						toggleFeedbackModeButton,
						nil,
						true
					)

					addNewRowObject.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
				else
					local addNewRowObject = Utility:AddNewRowObject(
						newPage,
						RobloxTranslator:FormatByKey("CoreScripts.Feedback.EntryPoint.OptionText"),
						toggleFeedbackModeButton
					)

					addNewRowObject.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FeedbackModeButton
				end
			end
		end

		if defineFastFlag16 then
			rolesCheckCallback(true)
		else
			internal:Start(function(p, p2)
				local v18 = false
				local success = false
				local result

				if p then
					if p2.StatusCode == 401 then
						result = "Roles Api Request: Unauthorized"
					elseif p2.StatusCode < 200 or p2.StatusCode >= 400 then
						result = "Roles Api Status code: " .. p2.StatusCode
					else
						success, result = pcall(function()
							local jsonDecode = HttpService:JSONDecode(p2.Body)

							for k, role in pairs(jsonDecode.roles) do
								if role == "Soothsayer" then
									v18 = true
								end
							end
						end)
					end
				else
					result = "Roles Api Request: Connection error"
				end

				if not success then
					v10:warning("Feedback Mode initialization api call failed with url: " .. url .. " and with error message: " .. result)
				end

				rolesCheckCallback(v18)
			end)
		end
	end

	local function createTranslationOptions()
		local v18 = 1
		local v19 = 1
		local v20 = false

		local languageCode = nil
		local localeCode = nil
		local localeId = Players.LocalPlayer.LocaleId
		local languageCode2 = nil

		local v21 = nil
		local languageCodes = {}
		local languageCodesByName = {}
		local v22 = {}
		local languageCodesById = {}

		local v23 = {}

		local url = Url.LOCALE_URL .. string.format(
			"v1/locales?displayValueLocale=%s",
			Players.LocalPlayer.LocaleId:gsub("-", "_")
		)
		local internal = HttpService:RequestInternal({ Url = url, Method = "GET" })

		local url2 = Url.GAME_INTERNATIONALIZATION_URL .. string.format("v1/source-language/games/%d", game.GameId)
		local internal2 = HttpService:RequestInternal({ Url = url2, Method = "GET" })

		local url3 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
			"v1/supported-languages/games/%d/in-experience-language-selection",
			game.GameId
		)
		local internal3 = HttpService:RequestInternal({ Url = url3, Method = "GET" })

		local url4 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
			"v1/user-localization-settings/universe/%d",
			game.GameId
		)
		local internal4 = HttpService:RequestInternal({ Url = url4, Method = "GET" })

		local function userExperienceLanguageSettingsCallback(success, result)
			if success then
				table.insert(v23, v22[languageCode].languageName .. " (Original)")
				local v24 = false

				for k, v25 in pairs(languageCodes) do
					v24 = v25 == v21 or v24

					if v25 ~= languageCode then
						table.insert(v23, v22[v25].languageName)
					end
				end

				if v24 == true then
					for k, v25 in pairs(v23) do
						if not (k ~= 1 and languageCodesByName[v25] == v21) then
							continue
						end

						v18 = k
						v19 = k
					end
				end

				local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
					newPage,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
					"DropDown",
					v23,
					v18
				)
				newPage.LanguageSelectorFrame = languageSelectorFrame
				newPage.LanguageSelectorLabel = languageSelectorLabel
				newPage.LanguageSelectorMode = languageSelectorMode

				newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame

				if v18 == 1 then
					LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
				else
					LocalPlayer:SetExperienceSettingsLocaleId(v22[languageCodesByName[v23[v18]]].localeCode)
				end

				newPage.LanguageSelectorMode.CurrentLanguage = newPage.LanguageSelectorMode.DropDownFrame.DropDownFrameTextLabel.Text

				local function toggleTranslation(p)
					newPage.LanguageSelectorMode:SetInteractable(false)
					local id

					if p == 1 then
						id = v22[languageCode].id
					else
						id = v22[languageCodesByName[v23[p]]].id
					end

					local currentLanguage = newPage.LanguageSelectorMode.CurrentLanguage
					local currentLanguage2 = v23[p]

					if currentLanguage ~= currentLanguage2 then
						newPage.LanguageSelectorMode.CurrentLanguage = currentLanguage2
						reportSettingsChangeForAnalytics("experience_language", currentLanguage, currentLanguage2)
					end

					local url5 = Url.GAME_INTERNATIONALIZATION_URL .. string.format(
						"v1/user-localization-settings/universe/%d",
						game.GameId
					)
					local internal5 = HttpService:RequestInternal({
						Url = url5,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = HttpService:JSONEncode({
							settingValue = { settingType = "LanguageFamily", settingTargetId = id }
						})
					})

					local function callback(p2, p3)
						if p2 then
							v19 = p

							if p == 1 then
								LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
							else
								LocalPlayer:SetExperienceSettingsLocaleId(v22[languageCodesByName[v23[p]]].localeCode)
							end
						else
							v10:warning("Request to update user experience language status failed, keeping language toggle disabled for the remainder of the session. Error: " .. p3)

							v20 = true
							newPage.LanguageSelectorMode:SetSelectionIndex(v19)
						end

						newPage.LanguageSelectorMode:SetInteractable(true)
					end

					if not RunService:IsStudio() then
						if not v20 then
							internal5:Start(function(p2, p3)
								local v25 = false
								local v26 = nil

								if p2 then
									if p3.StatusCode == 401 then
										v26 = "User Experience Language Settings Update Request: Unauthorized"
									elseif p3.StatusCode < 200 or p3.StatusCode >= 400 then
										v26 = "User Experience Language Settings Update Request Status Code: " .. p3.StatusCode
									else
										v10:info("User Experience Language Settings Update Request succeeded with code: " .. p3.StatusCode)
										v25 = true
									end
								else
									v26 = "User Experience Language Settings Update Request: Connection error"
								end

								if not v25 then
									v10:warning("GameSettings language selector toggle: Failed to update user experience language status from GameInternationalization API for " .. url5 .. " with error message: " .. v26)
								end

								callback(v25, v26)
							end)

							return
						end

						v20 = false
					end

					v19 = p

					if p == 1 then
						LocalPlayer:SetExperienceSettingsLocaleId(localeCode)
					else
						LocalPlayer:SetExperienceSettingsLocaleId(v22[languageCodesByName[v23[p]]].localeCode)
					end

					newPage.LanguageSelectorMode:SetInteractable(true)
				end

				newPage.LanguageSelectorMode.IndexChanged:connect(toggleTranslation)
			else
				v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (result == nil and "Execution path did not set earliest error to non-nil value." or result))

				local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
					newPage,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
					"DropDown",
					{ formatByKey2 },
					1
				)
				newPage.LanguageSelectorFrame = languageSelectorFrame
				newPage.LanguageSelectorLabel = languageSelectorLabel
				newPage.LanguageSelectorMode = languageSelectorMode

				newPage.LanguageSelectorMode:SetInteractable(false)
				newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		local function experienceSupportedLanguagesCallback(p, p2) -- 3 equivalent calls inferred from this helper
			if p then
				internal4:Start(function(p3, p4)
					local success = false
					local result

					if p3 then
						if p4.StatusCode == 401 then
							result = "User Experience Language Setting Request: Unauthorized"
						elseif p4.StatusCode < 200 or p4.StatusCode >= 400 then
							result = "User Experience Language Setting Request Status code: " .. p4.StatusCode
						else
							success, result = pcall(function()
								local userUniverseLocalizationSettingValue = HttpService:JSONDecode(p4.Body).userUniverseLocalizationSettingValue

								if userUniverseLocalizationSettingValue == nil then
									v21 = languageCode2
									return
								end

								if userUniverseLocalizationSettingValue.settingType == "SourceOrTranslation" then
									if userUniverseLocalizationSettingValue.settingTargetId == 1 then
										v21 = languageCode
									else
										v21 = languageCode2
									end
								end

								if userUniverseLocalizationSettingValue.settingType == "LanguageFamily" then
									if languageCodesById[userUniverseLocalizationSettingValue.settingTargetId] == nil then
										v21 = languageCode2
									else
										v21 = languageCodesById[userUniverseLocalizationSettingValue.settingTargetId]
									end
								end
							end)
						end
					else
						result = "User Experience Language Setting Request: Connection error"
					end

					if not success then
						v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. url4 .. " with error message: " .. result)
					end

					userExperienceLanguageSettingsCallback(success, result)
				end)
				return
			end

			v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (p2 == nil and "Execution path did not set earliest error to non-nil value." or p2))

			local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
				newPage,
				RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
				"DropDown",
				{ formatByKey2 },
				1
			)
			newPage.LanguageSelectorFrame = languageSelectorFrame
			newPage.LanguageSelectorLabel = languageSelectorLabel
			newPage.LanguageSelectorMode = languageSelectorMode

			newPage.LanguageSelectorMode:SetInteractable(false)
			newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
		end

		local function experienceSourceLanguageCallback(p, p2)
			if p then
				internal3:Start(function(p3, p4)
					local success = false
					local result

					if p3 then
						if p4.StatusCode == 401 then
							result = "Experience Supported Language Request: Unauthorized"
						elseif p4.StatusCode < 200 or p4.StatusCode >= 400 then
							result = "Experience Supported Language Request Status code: " .. p4.StatusCode
						else
							success, result = pcall(function()
								local jsonDecode = HttpService:JSONDecode(p4.Body)

								for k, v24 in pairs(jsonDecode.data) do
									languageCodes[k] = v24.languageCode
								end
							end)
						end
					else
						result = "Experience Supported Language Request: Connection error"
					end

					if not success then
						v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url3 .. " with error message: " .. result)
					end

					if p2 == nil then
						p2 = result
					end

					local v24 = p2

					if success and p then
						experienceSupportedLanguagesCallback(true) -- inferred equivalent call
						return
					end

					v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v24 == nil and "Execution path did not set earliest error to non-nil value." or v24))

					local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
						newPage,
						RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
						"DropDown",
						{ formatByKey2 },
						1
					)
					newPage.LanguageSelectorFrame = languageSelectorFrame
					newPage.LanguageSelectorLabel = languageSelectorLabel
					newPage.LanguageSelectorMode = languageSelectorMode

					newPage.LanguageSelectorMode:SetInteractable(false)
					newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
				end)
			else
				v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (p2 == nil and "Execution path did not set earliest error to non-nil value." or p2))

				local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
					newPage,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
					"DropDown",
					{ formatByKey2 },
					1
				)
				newPage.LanguageSelectorFrame = languageSelectorFrame
				newPage.LanguageSelectorLabel = languageSelectorLabel
				newPage.LanguageSelectorMode = languageSelectorMode

				newPage.LanguageSelectorMode:SetInteractable(false)
				newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		local function localeCodeToLanguageCodeMappingCallback(p, p2)
			if p then
				internal2:Start(function(p3, p4)
					local success = false
					local result

					if p3 then
						if p4.StatusCode == 401 then
							result = "Experience Source Language Request: Unauthorized"
						elseif p4.StatusCode < 200 or p4.StatusCode >= 400 then
							result = "Experience Source Language Status code: " .. p4.StatusCode
						else
							success, result = pcall(function()
								languageCode = HttpService:JSONDecode(p4.Body).languageCode
								localeCode = v22[languageCode].localeCode
							end)
						end
					else
						result = "Experience Source Language Request: Connection error"
					end

					if not success then
						v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. url2 .. " with error message: " .. result)
					end

					if p2 == nil then
						p2 = result
					end

					local v24 = success and p
					local v25 = p2

					if v24 then
						internal3:Start(function(p5, p6)
							local success2 = false
							local result2

							if p5 then
								if p6.StatusCode == 401 then
									result2 = "Experience Supported Language Request: Unauthorized"
								elseif p6.StatusCode < 200 or p6.StatusCode >= 400 then
									result2 = "Experience Supported Language Request Status code: " .. p6.StatusCode
								else
									success2, result2 = pcall(function()
										local jsonDecode = HttpService:JSONDecode(p6.Body)

										for k, v26 in pairs(jsonDecode.data) do
											languageCodes[k] = v26.languageCode
										end
									end)
								end
							else
								result2 = "Experience Supported Language Request: Connection error"
							end

							if not success2 then
								v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url3 .. " with error message: " .. result2)
							end

							if v25 == nil then
								v25 = result2
							end

							local v26 = v25

							if success2 and v24 then
								experienceSupportedLanguagesCallback(true) -- inferred equivalent call
								return
							end

							v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v26 == nil and "Execution path did not set earliest error to non-nil value." or v26))

							local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
								newPage,
								RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
								"DropDown",
								{ formatByKey2 },
								1
							)
							newPage.LanguageSelectorFrame = languageSelectorFrame
							newPage.LanguageSelectorLabel = languageSelectorLabel
							newPage.LanguageSelectorMode = languageSelectorMode

							newPage.LanguageSelectorMode:SetInteractable(false)
							newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v25 == nil and "Execution path did not set earliest error to non-nil value." or v25))

						local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
							newPage,
							RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
							"DropDown",
							{ formatByKey2 },
							1
						)
						newPage.LanguageSelectorFrame = languageSelectorFrame
						newPage.LanguageSelectorLabel = languageSelectorLabel
						newPage.LanguageSelectorMode = languageSelectorMode

						newPage.LanguageSelectorMode:SetInteractable(false)
						newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (p2 == nil and "Execution path did not set earliest error to non-nil value." or p2))

				local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
					newPage,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
					"DropDown",
					{ formatByKey2 },
					1
				)
				newPage.LanguageSelectorFrame = languageSelectorFrame
				newPage.LanguageSelectorLabel = languageSelectorLabel
				newPage.LanguageSelectorMode = languageSelectorMode

				newPage.LanguageSelectorMode:SetInteractable(false)
				newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end

		internal:Start(function(p, p2)
			local success = false
			local result

			if p then
				if p2.StatusCode == 401 then
					result = "Locale Code to Language Code Mapping Request: Unauthorized"
				elseif p2.StatusCode < 200 or p2.StatusCode >= 400 then
					result = "Locale Code to Language Code Mapping Request Status code: " .. p2.StatusCode
				else
					success, result = pcall(function()
						local jsonDecode = HttpService:JSONDecode(p2.Body)

						for k, v24 in pairs(jsonDecode.data) do
							local languageCode3 = v24.locale.language.languageCode
							local locale = v24.locale.locale
							local name = v24.locale.language.name
							local id = v24.locale.language.id
							v22[languageCode3] = {
								localeCode = locale,
								languageName = name,
								id = id
							}

							languageCodesById[id] = languageCode3
							languageCodesByName[name] = languageCode3

							if v24.locale.locale == localeId:gsub("-", "_") then
								languageCode2 = v24.locale.language.languageCode
							end
						end
					end)
				end
			else
				result = "Locale Code to Language Code Mapping Request: Connection error"
			end

			if not success then
				v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url .. " with error message: " .. result)
			end

			local v24 = result

			if success then
				internal2:Start(function(p3, p4)
					local success2 = false
					local result2

					if p3 then
						if p4.StatusCode == 401 then
							result2 = "Experience Source Language Request: Unauthorized"
						elseif p4.StatusCode < 200 or p4.StatusCode >= 400 then
							result2 = "Experience Source Language Status code: " .. p4.StatusCode
						else
							success2, result2 = pcall(function()
								languageCode = HttpService:JSONDecode(p4.Body).languageCode
								localeCode = v22[languageCode].localeCode
							end)
						end
					else
						result2 = "Experience Source Language Request: Connection error"
					end

					if not success2 then
						v10:warning("GameSettings language selector initialization: Failed to get response from GameInternationalization API for " .. url2 .. " with error message: " .. result2)
					end

					if v24 == nil then
						v24 = result2
					end

					local v25 = success2 and success
					local v26 = v24

					if v25 then
						internal3:Start(function(p5, p6)
							local success3 = false
							local result3

							if p5 then
								if p6.StatusCode == 401 then
									result3 = "Experience Supported Language Request: Unauthorized"
								elseif p6.StatusCode < 200 or p6.StatusCode >= 400 then
									result3 = "Experience Supported Language Request Status code: " .. p6.StatusCode
								else
									success3, result3 = pcall(function()
										local jsonDecode = HttpService:JSONDecode(p6.Body)

										for k, v27 in pairs(jsonDecode.data) do
											languageCodes[k] = v27.languageCode
										end
									end)
								end
							else
								result3 = "Experience Supported Language Request: Connection error"
							end

							if not success3 then
								v10:warning("GameSettings language selector initialization: Failed to get response from Localization API for " .. url3 .. " with error message: " .. result3)
							end

							if v26 == nil then
								v26 = result3
							end

							local v27 = v26

							if success3 and v25 then
								experienceSupportedLanguagesCallback(true) -- inferred equivalent call
								return
							end

							v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v27 == nil and "Execution path did not set earliest error to non-nil value." or v27))

							local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
								newPage,
								RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
								"DropDown",
								{ formatByKey2 },
								1
							)
							newPage.LanguageSelectorFrame = languageSelectorFrame
							newPage.LanguageSelectorLabel = languageSelectorLabel
							newPage.LanguageSelectorMode = languageSelectorMode

							newPage.LanguageSelectorMode:SetInteractable(false)
							newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
						end)
					else
						v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v26 == nil and "Execution path did not set earliest error to non-nil value." or v26))

						local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
							newPage,
							RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
							"DropDown",
							{ formatByKey2 },
							1
						)
						newPage.LanguageSelectorFrame = languageSelectorFrame
						newPage.LanguageSelectorLabel = languageSelectorLabel
						newPage.LanguageSelectorMode = languageSelectorMode

						newPage.LanguageSelectorMode:SetInteractable(false)
						newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
					end
				end)
			else
				v10:warning("GameSettings language selector initialization failed to get all required information; defaulting to player locale and disabling language selection toggle. Earliest error message: " .. (v24 == nil and "Execution path did not set earliest error to non-nil value." or v24))

				local languageSelectorFrame, languageSelectorLabel, languageSelectorMode = Utility:AddNewRow(
					newPage,
					RobloxTranslator:FormatByKey("Feature.SettingsHub.LanguageSelection.SettingLabel"),
					"DropDown",
					{ formatByKey2 },
					1
				)
				newPage.LanguageSelectorFrame = languageSelectorFrame
				newPage.LanguageSelectorLabel = languageSelectorLabel
				newPage.LanguageSelectorMode = languageSelectorMode

				newPage.LanguageSelectorMode:SetInteractable(false)
				newPage.LanguageSelectorFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageSelectorFrame
			end
		end)
	end

	local function getChatTranslationLayerData(p)
		local chatTranslationLayerData = {
			ChatTranslationEnabled = false,
			ChatTranslationToggleEnabled = false
		}

		if not p or p == "" then
			return chatTranslationLayerData
		end

		if p == "override" then
			chatTranslationLayerData.ChatTranslationEnabled = true
			return chatTranslationLayerData
		end

		if GetFFlagChatTranslationWaitForIXP() then
			IXPServiceWrapper:WaitForInitialization()
		end

		local success, result = pcall(function()
			return IXPServiceWrapper:GetLayerData(p)
		end)

		if not success then
			return chatTranslationLayerData
		end

		if GetFFlagChatTranslationNewDefaults() then
			chatTranslationLayerData.ChatTranslationEnabled = result.ChatTranslationEnabled or true
			chatTranslationLayerData.ChatTranslationToggleEnabled = result.ChatTranslationToggleEnabled or false
			return chatTranslationLayerData
		end

		chatTranslationLayerData.ChatTranslationEnabled = result.chatTranslationEnabled or false
		chatTranslationLayerData.ChatTranslationToggleEnabled = result.chatTranslationToggleEnabled or false

		return chatTranslationLayerData
	end

	local function createVolumeOptions()
		local v18 = math.floor(gameSettings.MasterVolume * 10)

		local volumeFrame, volumeLabel, volumeSlider = Utility:AddNewRow(
			newPage,
			not FFlagRenameVolumeToMainVolume and "Volume" or RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.MainVolume"),
			"Slider",
			10,
			v18
		)
		newPage.VolumeFrame = volumeFrame
		newPage.VolumeLabel = volumeLabel
		newPage.VolumeSlider = volumeSlider

		newPage.VolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VolumeFrame

		local CoreGui2 = game:GetService("CoreGui")
		local volumeChangeSound = Instance.new("Sound", CoreGui2.RobloxGui.Sounds)
		volumeChangeSound.Name = "VolumeChangeSound"
		volumeChangeSound.SoundId = "rbxasset://sounds/uuhhh.mp3"

		newPage.VolumeSlider.ValueChanged:connect(function(p)
			local v19

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v19 = math.floor(gameSettings.MasterVolume * 10 + 0.5)
			end

			local v20 = p / 10
			volumeChangeSound.Volume = v20
			volumeChangeSound:Play()
			gameSettings.MasterVolume = v20

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("volume", v19, (math.floor(gameSettings.MasterVolume * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createPartyVoiceVolumeOptions()
		local v18 = math.floor(gameSettings.PartyVoiceVolume * 10)

		local partyVoiceVolumeFrame, partyVoiceVolumeLabel, partyVoiceVolumeSlider = Utility:AddNewRow(
			newPage,
			"Party Voice Volume",
			"Slider",
			10,
			v18
		)
		newPage.PartyVoiceVolumeFrame = partyVoiceVolumeFrame
		newPage.PartyVoiceVolumeLabel = partyVoiceVolumeLabel
		newPage.PartyVoiceVolumeSlider = partyVoiceVolumeSlider

		newPage.PartyVoiceVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.PartyVoiceVolumeFrame

		if GetFFlagEnablePartyVoiceVolumeOnlyWhenInEligibleParty() then
			newPage.PartyVoiceVolumeFrame.Visible = default4.hasExperienceStarted
			default4.ExperienceJoined.Event:Connect(function()
				newPage.PartyVoiceVolumeFrame.Visible = true
			end)
			default4.ExperienceLeft.Event:Connect(function()
				newPage.PartyVoiceVolumeFrame.Visible = false
			end)
		end

		newPage.PartyVoiceVolumeSlider.ValueChanged:connect(function(p)
			local v19

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v19 = v18 == nil and 0 or math.floor(v18 * 10 + 0.5)
			end

			gameSettings.PartyVoiceVolume = p / 10

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("party_voice_volume", v19, (math.floor(p * 10 + 0.5)))
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createCallVolumeOptions()
		if FriendsCallingService == nil or GetFriendsCallingStore == nil then
			return
		end

		local friendsCallingStore = GetFriendsCallingStore(false)

		local v18 = 10

		local callVolumeFrame, v19, callVolumeSlider = Utility:AddNewRow(newPage, "Call Volume", "Slider", 10, v18)
		newPage.CallVolumeFrame = callVolumeFrame
		_ = v19
		newPage.CallVolumeSlider = callVolumeSlider

		newPage.CallVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CallVolumeFrame
		newPage.CallVolumeFrame.Visible = false

		local callId = nil
		newPage.CallVolumeDisposeEffect = Signals.createEffect(function(p)
			local call = friendsCallingStore.getCall(p)

			if not call or call.phase ~= Enum.FriendsCallingPhase.Active then
				call = nil
			end

			newPage.CallVolumeFrame.Visible = call ~= nil

			if call and call.callId ~= callId then
				callId = call.callId
				v18 = math.floor(call.volume * 10 + 0.5)
				newPage.CallVolumeSlider:SetValue(v18)
			end
		end)

		newPage.CallVolumeSlider.ValueChanged:connect(function(p)
			if p == v18 then
				return
			end

			local v20 = v18
			v18 = p
			FriendsCallingService:SetVolume(p / 10)

			reportSettingsChangeForAnalytics("call_volume", v20, p)
			reportSettingsForAnalytics()
		end)
	end

	local function createVoiceChatVolumeOptions()
		local v18 = voiceChatVolumeToSlider(gameSettings.VoiceChatVolume) -- inferred equivalent call
		local success, result = pcall(function()
			return localization:Format("CoreScripts.InGameMenu.GameSettings.VoiceChatVolume")
		end)

		if not success then
			v10:debug("[GameSettings] createVoiceChatVolumeOptions failed to get translation for Voice Chat Volume label, using placeholder text instead")
			result = "Voice Chat Volume"
		end

		local voiceChatVolumeFrame, voiceChatVolumeLabel, voiceChatVolumeSlider = Utility:AddNewRow(newPage, result, "Slider", 10, v18)
		newPage.VoiceChatVolumeFrame = voiceChatVolumeFrame
		newPage.VoiceChatVolumeLabel = voiceChatVolumeLabel
		newPage.VoiceChatVolumeSlider = voiceChatVolumeSlider

		newPage.VoiceChatVolumeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceChatVolumeFrame
		newPage.VoiceChatVolumeFrame.Visible = false

		if defineFastFlag13 then
			local function updateVoiceChatVolumeSliderInteractable(p: number?)
				local v19

				if p == nil then
					v19 = gameSettings.MasterVolume == 0
				else
					v19 = p == 0
				end

				if v19 then
					newPage.VoiceChatVolumeSlider:SetZIndex(1)
					newPage.VoiceChatVolumeLabel.ZIndex = 1
					newPage.VoiceChatVolumeSlider:SetInteractable(false)
				else
					newPage.VoiceChatVolumeSlider:SetZIndex(2)
					newPage.VoiceChatVolumeLabel.ZIndex = 2
					newPage.VoiceChatVolumeSlider:SetInteractable(true)
				end
			end

			updateVoiceChatVolumeSliderInteractable()
			newPage.VolumeSlider.ValueChanged:connect(updateVoiceChatVolumeSliderInteractable)
		end

		newPage.VoiceChatVolumeSlider.ValueChanged:connect(function(p)
			local v19

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v19 = voiceChatVolumeToSlider(gameSettings.VoiceChatVolume) -- inferred equivalent call
			end

			gameSettings.VoiceChatVolume = voiceChatVolumeFromSlider(p) -- inferred equivalent call

			if
				FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast
				and newPage.maxVoiceChatVolumeDuringSession ~= nil
			then
				newPage.maxVoiceChatVolumeDuringSession = math.max(
					newPage.maxVoiceChatVolumeDuringSession,
					gameSettings.VoiceChatVolume
				)
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics(
					"voice_chat_volume",
					v19,
					voiceChatVolumeToSlider(gameSettings.VoiceChatVolume) -- inferred equivalent call
				)
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createHapticsToggle()
		local v18 = gameSettings.HapticStrength == 0 and 1 or 2

		local hapticsFrame, v19, hapticsSelector = Utility:AddNewRow(
			newPage,
			not getAppFeaturePolicies().getShouldUseVibrationInsteadOfHaptics() and "Haptics" or localization:Format("CoreScripts.InGameMenu.Vibration"),
			"Selector",
			{ "Off", "On" },
			v18
		)
		newPage.HapticsFrame = hapticsFrame
		_ = v19
		newPage.HapticsSelector = hapticsSelector

		newPage.HapticsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.HapticsFrame

		newPage.HapticsSelector.IndexChanged:connect(function(p)
			local hapticStrength = gameSettings.HapticStrength

			if p == 2 then
				gameSettings.HapticStrength = 1
			else
				gameSettings.HapticStrength = 0
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("haptics_toggle", hapticStrength, gameSettings.HapticStrength)
			end

			reportSettingsForAnalytics()
		end)
	end

	local function createCameraInvertedOptions()
		local v18 = 1

		if pcall(function()
			if gameSettings.CameraYInverted == true then
				v18 = 2
			end
		end) == false then
			return
		end

		local cameraInvertedFrame, v19, cameraInvertedSelector = Utility:AddNewRow(
			newPage,
			"Camera Inverted",
			"Selector",
			{ "Off", "On" },
			v18
		)
		newPage.CameraInvertedFrame = cameraInvertedFrame
		_ = v19
		newPage.CameraInvertedSelector = cameraInvertedSelector

		newPage.CameraInvertedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraInvertedFrame
		set[newPage.CameraInvertedFrame] = true

		newPage.CameraInvertedSelector.IndexChanged:connect(function(p)
			local cameraYInverted

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				cameraYInverted = gameSettings.CameraYInverted
			end

			if p == 2 then
				gameSettings.CameraYInverted = true
			else
				gameSettings.CameraYInverted = false
			end

			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				reportSettingsChangeForAnalytics("camera_y_inverted", cameraYInverted, gameSettings.CameraYInverted)
			end

			reportSettingsForAnalytics()
		end)
	end

	local function setCameraSensitivity(gamepadCameraSensitivity)
		local sensitivity_type = nil
		local v18 = nil

		if UserInputService.GamepadEnabled and gameSettings.IsUsingGamepadCameraSensitivity then
			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v18 = gameSettings.GamepadCameraSensitivity
				sensitivity_type = "gamepad"
			end

			gameSettings.GamepadCameraSensitivity = gamepadCameraSensitivity
		end

		if UserInputService.MouseEnabled then
			if GetFFlagEnableExplicitSettingsChangeAnalytics() then
				v18 = gameSettings.MouseSensitivityFirstPerson.X
				sensitivity_type = "mouse"
			end

			local vector2 = Vector2.new(gamepadCameraSensitivity, gamepadCameraSensitivity)
			gameSettings.MouseSensitivityFirstPerson = vector2
			gameSettings.MouseSensitivityThirdPerson = vector2
		end

		if
			GetFFlagEnableExplicitSettingsChangeAnalytics()
			and typeof(v18) == "number"
			and typeof(gamepadCameraSensitivity) == "number"
		then
			reportSettingsChangeForAnalytics(
				"camera_sensitivity",
				tonumber(string.format("%.2f", v18)),
				tonumber(string.format("%.2f", gamepadCameraSensitivity)),
				{ sensitivity_type = sensitivity_type }
			)
		end

		reportSettingsForAnalytics()
	end

	local function createMouseOptions()
		local function translateEngineMouseSensitivityToGui(p) -- 3 equivalent calls inferred from this helper
			local v18 = p <= 1 and math.floor((p - 0.2) / 0.16 + 0.5) or math.floor((p + 2) / 0.6 + 0.5)
			return if p <= 0.2 then 0 else v18
		end

		local function translateGuiMouseSensitivityToEngine(p) -- 1 equivalent call inferred from this helper
			local v18 = p <= 5 and 0.16 * p + 0.2 or 0.6 * p - 2
			return if v18 <= 0.2 then 0.2 else v18
		end

		local v18 = translateEngineMouseSensitivityToGui(gameSettings.MouseSensitivity) -- inferred equivalent call

		local v19 = true
		tostring(gameSettings.MouseSensitivityFirstPerson.X)

		local mouseAdvancedFrame, mouseAdvancedLabel, mouseAdvancedEntry = Utility:AddNewRow(
			newPage,
			"Camera Sensitivity",
			"Slider",
			10,
			v18
		)
		newPage.MouseAdvancedFrame = mouseAdvancedFrame
		newPage.MouseAdvancedLabel = mouseAdvancedLabel
		newPage.MouseAdvancedEntry = mouseAdvancedEntry

		newPage.MouseAdvancedFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MouseAdvancedFrame
		set[newPage.MouseAdvancedFrame] = true

		newPage.MouseAdvancedEntry.SliderFrame.Size = UDim2.new(
			newPage.MouseAdvancedEntry.SliderFrame.Size.X.Scale,
			newPage.MouseAdvancedEntry.SliderFrame.Size.X.Offset - 60 - 20,
			newPage.MouseAdvancedEntry.SliderFrame.Size.Y.Scale,
			newPage.MouseAdvancedEntry.SliderFrame.Size.Y.Offset - 6
		)

		newPage.MouseAdvancedEntry.SliderFrame.Position = UDim2.new(
			newPage.MouseAdvancedEntry.SliderFrame.Position.X.Scale,
			newPage.MouseAdvancedEntry.SliderFrame.Position.X.Offset - 60 - 20,
			newPage.MouseAdvancedEntry.SliderFrame.Position.Y.Scale,
			newPage.MouseAdvancedEntry.SliderFrame.Position.Y.Offset
		)

		newPage.MouseAdvancedLabel.ZIndex = 2
		newPage.MouseAdvancedEntry:SetInteractable(true)

		local parent = Create("TextBox")({
			Name = "CameraSensitivityTextBox",
			TextColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0.8, 0.8, 0.8),
			BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
			Font = Theme.font(Enum.Font.SourceSans),
			TextSize = Theme.textSize(18),
			Size = UDim2.new(0, 60, 0.8, 0),
			Position = UDim2.new(1, 10, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ZIndex = 3,
			Selectable = false,
			Parent = newPage.MouseAdvancedEntry.SliderFrame,
			BorderSizePixel = 0
		})

		Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = parent })

		local function setMouseSensitivityText(p) -- 1 equivalent call inferred from this helper
			local v20 = math.floor(p * 1000 + 0.5) / 1000
			local v21 = string.format("%.3f", v20)

			parent.Text = tostring((tonumber(v21)))
		end

		local v20 = math.floor(gameSettings.MouseSensitivityFirstPerson.X * 1000 + 0.5) / 1000
		parent.Text = tostring((tonumber((string.format("%.3f", v20)))))

		newPage.MouseAdvancedEntry:SetValue(translateEngineMouseSensitivityToGui(gameSettings.MouseSensitivityFirstPerson.X)) -- inferred equivalent call

		function clampMouseSensitivity(p)
			if p < 0 then
				p = -p
			end

			if p > 100 then
				return 100
			end

			return p < 0.001 and 0.001 or p
		end

		function setMouseSensitivity(gamepadCameraSensitivity, p)
			if not v19 then
				return
			end

			setCameraSensitivity(gamepadCameraSensitivity)

			v19 = false

			if p ~= newPage.MouseAdvancedEntry then
				newPage.MouseAdvancedEntry:SetValue(translateEngineMouseSensitivityToGui(gamepadCameraSensitivity)) -- inferred equivalent call
			end

			setMouseSensitivityText(gamepadCameraSensitivity) -- inferred equivalent call
			v19 = true
		end

		parent.FocusLost:connect(function()
			newPage.MouseAdvancedEntry:SetInteractable(true)

			local v21 = tonumber((string.match(parent.Text, "([%d%.]+)")))

			if v21 then
				setMouseSensitivity(clampMouseSensitivity(v21), parent)
			else
				setMouseSensitivity(gameSettings.MouseSensitivityFirstPerson.X, parent)
			end
		end)

		parent.Focused:connect(function()
			newPage.MouseAdvancedEntry:SetInteractable(false)
		end)

		newPage.MouseAdvancedEntry.ValueChanged:connect(function(p)
			local v21 = translateGuiMouseSensitivityToEngine(clampMouseSensitivity(p)) -- inferred equivalent call

			setMouseSensitivity(v21, newPage.MouseAdvancedEntry)
		end)
	end

	local function createGamepadOptions()
		local function translateEngineGamepadSensitivityToGui(gamepadCameraSensitivity) -- 1 equivalent call inferred from this helper
			local v18 = gamepadCameraSensitivity <= 1 and math.floor((gamepadCameraSensitivity - 0.2) / 0.16 + 0.5)
				or math.floor((gamepadCameraSensitivity + 2) / 0.6 + 0.5)
			return if gamepadCameraSensitivity <= 0.2 then 0 else v18
		end

		local function translateGuiGamepadSensitivityToEngine(p) -- 1 equivalent call inferred from this helper
			local v18 = p <= 5 and 0.16 * p + 0.2 or 0.6 * p - 2
			return if v18 <= 0.2 then 0.2 else v18
		end

		local v18 = translateEngineGamepadSensitivityToGui(gameSettings.GamepadCameraSensitivity) -- inferred equivalent call

		local gamepadSensitivityFrame, gamepadSensitivityLabel, gamepadSensitivitySlider = Utility:AddNewRow(
			newPage,
			"Camera Sensitivity",
			"Slider",
			10,
			v18
		)
		newPage.GamepadSensitivityFrame = gamepadSensitivityFrame
		newPage.GamepadSensitivityLabel = gamepadSensitivityLabel
		newPage.GamepadSensitivitySlider = gamepadSensitivitySlider

		newPage.GamepadSensitivityFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.GamepadSensitivityFrame
		newPage.GamepadSensitivitySlider.ValueChanged:connect(function(p)
			setCameraSensitivity(translateGuiGamepadSensitivityToEngine(p)) -- inferred equivalent call
		end)
	end

	local function createOverscanOption()
		local function fn()
			local SettingsHub = require(RobloxGui.Modules.Settings.SettingsHub)

			local Overscan = require(RobloxGui.Modules.Shell.Components.Overscan10ft.Overscan)
			local OverscanWrapper = require(RobloxGui.Modules.Settings.Components.OverscanWrapper)
			local overscanWrapper = OverscanWrapper(Overscan)

			local Roact = require(CorePackages.Packages.Roact)
			local v18 = nil

			local v19 = {
				onUnmount = function()
					if v18 then
						Roact.unmount(v18)

						ContextActionService:UnbindCoreAction("RbxStopOverscanMovement")
						SettingsHub:SetVisibility(true, true)
					end
				end,
				ImageVisible = false,
				BackgroundTransparency = 0.2
			}

			SettingsHub:SetVisibility(false, true)

			ContextActionService:BindCoreAction(
				"RbxStopOverscanMovement",
				function() end,
				false,
				Enum.UserInputType.Gamepad1,
				Enum.UserInputType.Gamepad2,
				Enum.UserInputType.Gamepad3,
				Enum.UserInputType.Gamepad4
			)

			local element = Roact.createElement(overscanWrapper, v19)
			v18 = Roact.mount(element, RobloxGui, (tostring(overscanWrapper)))
		end

		local styledButton, v18, v19 = Utility:MakeStyledButton(
			"AdjustButton",
			"Adjust",
			UDim2.new(0, 300, 1, -20),
			fn,
			newPage
		)
		v18.Font = Theme.font(Enum.Font.SourceSans)
		styledButton.Position = UDim2.new(1, -400, 0, 12)
		styledButton.Size = UDim2.new(0, 300, 0, 40)
		styledButton.Position = UDim2.new(1, -400, 0.5, 0)
		styledButton.AnchorPoint = Vector2.new(0, 0.5)

		if RunService:IsStudio() then
			styledButton.Selectable = false
			styledButton.Active = false
			styledButton.Enabled.Value = false
			v18.TextColor3 = Color3.fromRGB(100, 100, 100)
		end

		local v20 = Utility:AddNewRowObject(newPage, "Safe Zone", styledButton)
		v20.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.OverscanAdjustButton
		v19(v20)
	end

	local function createDeveloperConsoleOption()
		local function makeDevConsoleOption()
			local function onOpenDevConsole()
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

			if defineFastFlag19 then
				local styledButton, v18, v19 = Utility:MakeStyledButton(
					"DevConsoleButton",
					"Open",
					UDim2.new(1, 0, 1, -20),
					onOpenDevConsole,
					newPage
				)

				v18.Font = Theme.font(Enum.Font.SourceSans)
				styledButton.Size = UDim2.new(0.6, -10, 0, 35)
				styledButton.Position = UDim2.new(0.4, 10, 0.5, 0)
				styledButton.AnchorPoint = Vector2.new(0, 0.5)

				local v20 = Utility:AddNewRowObject(newPage, "Developer Console", styledButton, nil, true)
				v20.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v19(v20)
			else
				local styledButton, v18, v19 = Utility:MakeStyledButton(
					"DevConsoleButton",
					"Open",
					UDim2.new(0, 300, 1, -20),
					onOpenDevConsole,
					newPage
				)

				v18.Font = Theme.font(Enum.Font.SourceSans)
				styledButton.Size = UDim2.new(0.6, -10, 0, 35)
				styledButton.Position = UDim2.new(1, -400, 0.5, 0)
				styledButton.AnchorPoint = Vector2.new(0, 0.5)

				local v20 = Utility:AddNewRowObject(newPage, "Developer Console", styledButton)
				v20.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DeveloperConsoleButton
				v19(v20)
			end
		end

		if RunService:IsStudio() then
			makeDevConsoleOption()
		else
			spawn(function()
				if PlayerPermissionsModule.CanPlayerManagePlaceAsync(Players.LocalPlayer) then
					makeDevConsoleOption()
				end
			end)
		end
	end

	local function createUiToggleOptions()
		if defineFastFlag18 or defineFastFlag17 then
			local v18 = {
				{
					label = "Custom",
					type = Enum.GuiType.Custom,
					layoutOrderKey = "UiToggleRowCustom"
				},
				{
					label = "CustomBillboards",
					type = Enum.GuiType.CustomBillboards,
					layoutOrderKey = "UiToggleRowBillboards"
				},
				{
					label = "PlayerNameplates",
					type = Enum.GuiType.PlayerNameplates,
					layoutOrderKey = "UiToggleRowNameplates"
				}
			}

			local formatByKey6 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
			local formatByKey7 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

			newPage.uiToggleSelectors = {}

			for k, v19 in v18 do
				local formatByKey8 = RobloxTranslator:FormatByKey(
					"Feature.SettingsHub.GameSettings.GuiVisibility.ShowGuiType",
					{ GuiType = v19.label }
				)

				local row, frame, selector = Utility:AddNewRow(
					newPage,
					formatByKey8,
					"Selector",
					{ formatByKey6, formatByKey7 },
					1
				)
				row.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER[v19.layoutOrderKey]

				selector.IndexChanged:Connect(function(p)
					if (GuiService:GetGuiIsVisible(v19.type) and 1 or 2) ~= p then
						GuiService:ToggleGuiIsVisibleIfAllowed(v19.type)
					end
				end)

				newPage.uiToggleSelectors[v19.label] = {
					label = formatByKey8,
					type = v19.type,
					row = row,
					frame = frame,
					selector = selector
				}
			end

			local freecamRow, freecamFrame, freecamSelector = Utility:AddNewRow(
				newPage,
				RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.GuiVisibility.Freecam"),
				"Selector",
				{ formatByKey7, formatByKey6 },
				1
			)
			newPage.freecamRow = freecamRow
			newPage.freecamFrame = freecamFrame
			newPage.freecamSelector = freecamSelector

			newPage.freecamRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.FreecamToggleRow

			newPage.freecamSelector.IndexChanged:Connect(function(p)
				local v19 = p == 2
				local freecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

				if freecamScript then
					freecamScript:SetAttribute("FreecamEnabled", v19)
				else
					warn("Freecam not present")
				end
			end)
		else
			local uiToggleRow, uiToggleFrame, uiToggleSelector = Utility:AddNewRow(
				newPage,
				"BillboardGui Visibility",
				"Selector",
				{ "All visible", "Hide nameplates/bubble chat" },
				1
			)
			newPage.uiToggleRow = uiToggleRow
			newPage.uiToggleFrame = uiToggleFrame
			newPage.uiToggleSelector = uiToggleSelector

			newPage.uiToggleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.UiToggleRow

			newPage.uiToggleSelector.IndexChanged:connect(function(p)
				GuiService:ToggleGuiIsVisibleIfAllowed(Enum.GuiType.PlayerNameplates)
			end)
		end
	end

	local function updateUiToggleSelection()
		if defineFastFlag18 or defineFastFlag17 then
			if not newPage.uiToggleSelectors then
				return
			end

			for k, uiToggleSelector in newPage.uiToggleSelectors do
				local v18 = GuiService:GetGuiIsVisible(uiToggleSelector.type) and 1 or 2

				if v18 ~= uiToggleSelector.selector:GetSelectedIndex() then
					uiToggleSelector.selector:SetSelectionIndex(v18)
				end
			end

			local freecamScript = LocalPlayer:FindFirstChild("FreecamScript", true)

			if freecamScript then
				local v18 = freecamScript:GetAttribute("FreecamEnabled") and 2 or 1

				newPage.freecamSelector:SetSelectionIndex(v18)
			end
		else
			if not newPage.uiToggleSelector then
				return
			end

			local v18 = GuiService:GetGuiIsVisible(Enum.GuiType.PlayerNameplates) and 1 or 2

			if v18 == newPage.uiToggleSelector:GetSelectedIndex() then
				return
			end

			newPage.uiToggleSelector:SetSelectionIndex(v18)
		end
	end

	local function isValidDeviceList(list, list2, p)
		if list then
			if list2 then
				if p then
					if #list > 0 and p > 0 and p <= #list then
						p = #list == #list2
					else
						p = false
					end
				end
			else
				p = list2
			end
		else
			p = list
		end

		return p
	end

	local function SwitchOutputDevice(name, guid) -- 1 equivalent call inferred from this helper
		SoundService:SetOutputDevice(name, guid)
		v10:info("[SwitchOutputDevice] Setting SS Speaker Device To {} {}", name, guid)
	end

	local function createDeviceOptions(p)
		local v18 = newPage[p .. "DeviceIndex"] or 0
		local v19 = newPage[p .. "DeviceNames"] or {}
		local v20 = newPage[p .. "DeviceGuids"] or {}

		local v21 = p == "Input" and RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.InputDevice")
			or RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.OutputDevice")
		local v22 = p .. "DeviceFrame"
		local v23 = p .. "DeviceSelector"
		local v24, v25, v26 = Utility:AddNewRow(newPage, v21, "Selector", v19, v18)
		newPage[v22] = v24
		_ = v25
		newPage[v23] = v26

		newPage[p .. "DeviceFrame"].LayoutOrder = p == "Input" and SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameInput
			or SETTINGS_MENU_LAYOUT_ORDER.DeviceFrameOutput

		local v27 = p .. "DeviceInfo"
		local name2

		if v18 > 0 then
			name2 = v19[v18] or nil
		end

		newPage[v27] = {
			Name = name2,
			Guid = v18 > 0 and v20[v18] or nil
		}

		newPage[p .. "PrevDeviceName"] = newPage[p .. "DeviceInfo"].Name

		local v28 = 0
		local fIntVoiceChatDeviceChangeDebounceDelay = GetFIntVoiceChatDeviceChangeDebounceDelay()
		newPage[p .. "DeviceSelector"].IndexChanged:connect(function(p2)
			if
				newPage[p .. "DeviceInfo"].Name == newPage[p .. "DeviceNames"][p2]
				and newPage[p .. "DeviceInfo"].Guid == newPage[p .. "DeviceGuids"][p2]
			then
				return
			end

			local v29 = v28 + 1
			v28 = v29
			wait(fIntVoiceChatDeviceChangeDebounceDelay)

			if v29 == v28 then
				v28 = 0
				newPage[p .. "DeviceInfo"] = {
					Name = newPage[p .. "DeviceNames"][p2],
					Guid = newPage[p .. "DeviceGuids"][p2]
				}

				local name = newPage[p .. "DeviceInfo"].Name
				local guid = newPage[p .. "DeviceInfo"].Guid

				if newPage.VoiceChatOptionsEnabled then
					default3:SwitchDevice(p, name, guid)
				else
					SwitchOutputDevice(name, guid) -- inferred equivalent call
				end

				if GetFFlagEnableCrossExpVoice() then
					v10:debug("[GameSettings] Changing {} device to {} {} ", p, name, guid)

					if p == "Input" then
						default4:changeInputDevice(name, guid)
					else
						default4:changeOutputDevice(name, guid)
					end
				end

				reportSettingsChangeForAnalytics(p, newPage[p .. "PrevDeviceName"], name)
				newPage[p .. "PrevDeviceName"] = name
			end
		end)
	end

	local function createBadgeVisibilityOptions() -- 1 equivalent call inferred from this helper
		spawn(function()
			local v18 = PlayerPermissionsModule.IsPlayerInExperienceNameEnabledAsync(LocalPlayer) and 1 or 2

			local formatByKey6 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Show")
			local formatByKey7 = RobloxTranslator:FormatByKey("Feature.SettingsHub.Label.Hide")
			local v19

			if defineFastFlag23 then
				v19 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.MyBadges")
			else
				v19 = RobloxTranslator:FormatByKey("Feature.SettingsHub.GameSettings.DisplayBadges")
			end

			local badgeVisibleRow, badgeVisibleFrame, badgeVisibleSelector = Utility:AddNewRow(
				newPage,
				v19,
				"Selector",
				{ formatByKey7, formatByKey6 },
				v18,
				nil,
				(RobloxTranslator:FormatByKey("Feature.SettingsHub.Description.PeoplesNames"))
			)
			newPage.badgeVisibleRow = badgeVisibleRow
			newPage.badgeVisibleFrame = badgeVisibleFrame
			newPage.badgeVisibleSelector = badgeVisibleSelector

			newPage.badgeVisibleRow.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.BadgeVisibilityFrame

			newPage.badgeVisibleSelector.IndexChanged:connect(function(p)
				gameSettings.BadgeVisible = p == 2
				PlayerPermissionsModule.SetPlayerInExperienceNameEnabled(LocalPlayer, p == 1)
			end)
		end)
	end

	local function createChatModerationOptions()
		local v18 = {
			title = "CoreScripts.InGameMenu.GameSettings.ReadOnlyView",
			description = "CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription",
			on = "InGame.CommonUI.Label.On",
			off = "InGame.CommonUI.Label.Off"
		}

		local chatModerationFrame, v19, chatModerationSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyView"),
			"Selector",
			{ localization:Format("InGame.CommonUI.Label.Off"), localization:Format("InGame.CommonUI.Label.On") },
			1,
			nil,
			localization:Format("CoreScripts.InGameMenu.GameSettings.ReadOnlyViewDescription")
		)
		newPage.ChatModerationFrame = chatModerationFrame
		_ = v19
		newPage.ChatModerationSelector = chatModerationSelector

		newPage.ChatModerationFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatModerationFrame
		newPage.ChatModerationFrame.Visible = false

		local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
		local chatModerationStore = ExpChat.Stores.GetChatModerationStore(false)

		newPage.ChatModerationDisposeEffect = Signals.createEffect(function(p)
			newPage.ChatModerationFrame.Visible = chatModerationStore.getIsSettingVisible(p)

			local v20 = chatModerationStore.getIsSettingEnabled(p) and 2 or 1

			if newPage.ChatModerationSelector:GetSelectedIndex() ~= v20 then
				newPage.ChatModerationSelector:SetSelectionIndex(v20)
			end
		end)
		newPage.ChatModerationSelector.IndexChanged:connect(function(p)
			local v20 = p == 2
			chatModerationStore.setIsSettingEnabled(v20)
			reportSettingsChangeForAnalytics("moderate_chat", not v20, v20)
		end)

		chatModerationStore.initialize()
	end

	local function createAIRephraseSettingOptions()
		local formatByKey6 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessages")
		local formatByKey7 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.AIRephraseMessagesDescription")
		local formatByKey8 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local aiRephraseFrame, v18, aiRephraseSelector = Utility:AddNewRow(
			newPage,
			formatByKey6,
			"Selector",
			{ RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off"), formatByKey8 },
			1,
			nil,
			formatByKey7
		)
		newPage.AIRephraseFrame = aiRephraseFrame
		_ = v18
		newPage.AIRephraseSelector = aiRephraseSelector

		newPage.AIRephraseFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AIRephraseFrame
		newPage.AIRephraseFrame.Visible = false

		local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
		local v19 = ExpChat.Stores.GetUserChatSettingsStore.getAIRephraseSettingStore(false)
		local fIntDebounceAIRephraseSettingDelay = GetFIntDebounceAIRephraseSettingDelay()
		local v20 = fIntDebounceAIRephraseSettingDelay > 0
		local v21 = v19.getIsSettingEnabled(false) and 2 or 1

		newPage.AIRephraseDisposeEffect = Signals.createEffect(function(p)
			newPage.AIRephraseFrame.Visible = v19.getIsSettingVisible(p)

			local v22 = v19.getIsSettingEnabled(p) and 2 or 1

			if newPage.AIRephraseSelector:GetSelectedIndex() ~= v22 then
				v21 = v22
				newPage.AIRephraseSelector:SetSelectionIndex(v22)
			end
		end)

		local function fn(p)
			if p == v21 then
				return
			end

			local v22 = p == 2
			task.spawn(function()
				if not TextChatService:OnUserChatSettingUpdateAsync("allowAIRephrase", v22 and "Enabled" or "Disabled") then
					newPage.AIRephraseSelector:SetSelectionIndex(v21)

					return
				end

				v19.setIsSettingEnabled(v22)
				v21 = p
				reportSettingsChangeForAnalytics("ai_rephrase", not v22, v22)
			end)
		end

		if defineFastFlag24 then
			if v20 then
				local thread = nil
				newPage.AIRephraseSelector.IndexChanged:connect(function(p)
					if thread then
						task.cancel(thread)
					end

					thread = task.delay(fIntDebounceAIRephraseSettingDelay, function()
						thread = nil
						local v22 = p

						if v22 == v21 then
							return
						end

						local v23 = v22 == 2
						task.spawn(function()
							if not TextChatService:OnUserChatSettingUpdateAsync(
								"allowAIRephrase",
								v23 and "Enabled" or "Disabled"
							) then
								newPage.AIRephraseSelector:SetSelectionIndex(v21)

								return
							end

							v19.setIsSettingEnabled(v23)
							v21 = v22
							reportSettingsChangeForAnalytics("ai_rephrase", not v23, v23)
						end)
					end)
				end)
			else
				newPage.AIRephraseSelector.IndexChanged:connect(fn)
			end
		else
			local indexChanged = newPage.AIRephraseSelector.IndexChanged

			if v20 then
				fn = ThrottleFunctionCall(fIntDebounceAIRephraseSettingDelay, fn)
			end

			indexChanged:connect(fn)
		end
	end

	local function createChatSummariesSettingOptions()
		local formatByKey6 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummaries")
		local formatByKey7 = RobloxTranslator:FormatByKey("CoreScripts.InGameMenu.GameSettings.ChatSummariesDescription")
		local formatByKey8 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local chatSummariesFrame, v18, chatSummariesSelector = Utility:AddNewRow(
			newPage,
			formatByKey6,
			"Selector",
			{ RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off"), formatByKey8 },
			1,
			nil,
			formatByKey7
		)
		newPage.ChatSummariesFrame = chatSummariesFrame
		_ = v18
		newPage.ChatSummariesSelector = chatSummariesSelector

		newPage.ChatSummariesFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatSummariesFrame
		newPage.ChatSummariesFrame.Visible = false

		local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
		local chatSummariesSettingStore = ExpChat.Stores.GetUserChatSettingsStore.getChatSummariesSettingStore(false)
		local fIntDebounceChatSummariesSettingDelay = GetFIntDebounceChatSummariesSettingDelay()
		local v19 = fIntDebounceChatSummariesSettingDelay > 0
		local v20 = chatSummariesSettingStore.getIsSettingEnabled(false) and 2 or 1

		newPage.ChatSummariesDisposeEffect = Signals.createEffect(function(p)
			newPage.ChatSummariesFrame.Visible = chatSummariesSettingStore.getIsSettingVisible(p)

			local v21 = chatSummariesSettingStore.getIsSettingEnabled(p) and 2 or 1

			if newPage.ChatSummariesSelector:GetSelectedIndex() ~= v21 then
				v20 = v21
				newPage.ChatSummariesSelector:SetSelectionIndex(v21)
			end
		end)

		local function fn(p) -- 1 equivalent call inferred from this helper
			if p == v20 then
				return
			end

			local v21 = p == 2
			task.spawn(function()
				if not TextChatService:OnUserChatSettingUpdateAsync(
					"AllowThirdPartySummary",
					v21 and "Enabled" or "Disabled"
				) then
					newPage.ChatSummariesSelector:SetSelectionIndex(v20)

					return
				end

				chatSummariesSettingStore.setIsSettingEnabled(v21)
				v20 = p
				reportSettingsChangeForAnalytics("chat_summaries", not v21, v21)
			end)
		end

		if v19 then
			local thread = nil
			newPage.ChatSummariesSelector.IndexChanged:connect(function(p)
				if thread then
					task.cancel(thread)
				end

				thread = task.delay(fIntDebounceChatSummariesSettingDelay, function()
					thread = nil
					fn(p) -- inferred equivalent call
				end)
			end)
		else
			newPage.ChatSummariesSelector.IndexChanged:connect(fn)
		end
	end

	local function createVoiceTypingModeSettingOptions()
		local v18 = { "standard", "continuous" }

		local function formatWithFallback(p: string, p2: string)
			local success, result = pcall(function()
				return localization:Format(p)
			end)

			if success then
				return result
			end

			v10:debug("[GameSettings] createVoiceTypingModeSettingOptions missing translation for {}", p)
			return p2
		end

		local v19
		v19 = "CoreScripts.InGameMenu.GameSettings.VoiceTypingMode"
		local success, result = pcall(function()
			return localization:Format(v19)
		end)

		if not success then
			v10:debug(
				"[GameSettings] createVoiceTypingModeSettingOptions missing translation for {}",
				"CoreScripts.InGameMenu.GameSettings.VoiceTypingMode"
			)
			result = "Voice typing mode"
		end

		local v20
		v20 = "CoreScripts.InGameMenu.GameSettings.VoiceTypingModeStandard"
		local success2, result2 = pcall(function()
			return localization:Format(v20)
		end)

		if not success2 then
			v10:debug(
				"[GameSettings] createVoiceTypingModeSettingOptions missing translation for {}",
				"CoreScripts.InGameMenu.GameSettings.VoiceTypingModeStandard"
			)
			result2 = "Manual Send"
		end

		local v21
		v21 = "CoreScripts.InGameMenu.GameSettings.VoiceTypingModeContinuous"
		local success3, result3 = pcall(function()
			return localization:Format(v21)
		end)

		if not success3 then
			v10:debug(
				"[GameSettings] createVoiceTypingModeSettingOptions missing translation for {}",
				"CoreScripts.InGameMenu.GameSettings.VoiceTypingModeContinuous"
			)
			result3 = "Auto Send"
		end

		local voiceTypingModeFrame, v22, voiceTypingModeSelector = Utility:AddNewRow(
			newPage,
			result,
			"Selector",
			{ result2, result3 },
			1
		)
		newPage.VoiceTypingModeFrame = voiceTypingModeFrame
		_ = v22
		newPage.VoiceTypingModeSelector = voiceTypingModeSelector

		newPage.VoiceTypingModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceTypingModeFrame

		local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
		local dictationModeSettingStore = ExpChat.Stores.GetDictationModeSettingStore(false)

		newPage.VoiceTypingModeDisposeEffect = Signals.createEffect(function(p)
			local index = table.find(v18, dictationModeSettingStore.getMode(p)) or 1

			if newPage.VoiceTypingModeSelector:GetSelectedIndex() ~= index then
				newPage.VoiceTypingModeSelector:SetSelectionIndex(index)
			end
		end)

		newPage.VoiceTypingModeSelector.IndexChanged:connect(function(p)
			local mode = dictationModeSettingStore.getMode(false)
			local v23 = v18[p]

			if v23 == nil or v23 == mode then
				return
			end

			dictationModeSettingStore.setMode(v23)
			reportSettingsChangeForAnalytics("voice_typing_mode", mode, v23)
		end)
	end

	local function createChatNotificationsSettingOptions()
		local ToastNotification = require(CorePackages.Workspace.Packages.ToastNotification)
		local default5 = ToastNotification.ToastNotificationSnoozeManager.default
		local notificationGroups = ToastNotification.NotificationGroups
		local toastNotificationTypeModule = ToastNotification.ToastNotificationTypeModule
		local notificationSnoozedSignal = ToastNotification.Signals.NotificationSnoozedSignal
		local notificationTypeEnum = toastNotificationTypeModule.NotificationTypeEnum
		local snoozeActionEnum = toastNotificationTypeModule.SnoozeActionEnum

		local v18 = { Off = 1, On = 2 }

		local formatByKey6 = RobloxTranslator:FormatByKey("Feature.Chat.Label.InGameFriendsChatNotifications")
		local formatByKey7 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.On")
		local formatByKey8 = RobloxTranslator:FormatByKey("InGame.CommonUI.Label.Off")

		local function getSelectorIndex(): number
			if default5:isSnoozedNotificationType(notificationTypeEnum.ChatNewMessage) then
				return 1
			end

			return 2
		end

		local v19

		if default5:isSnoozedNotificationType(notificationTypeEnum.ChatNewMessage) then
			v19 = v18.Off
		else
			v19 = v18.On
		end

		local chatNotificationsFrame, v20, chatNotificationsSelector = Utility:AddNewRow(
			newPage,
			formatByKey6,
			"Selector",
			{ formatByKey8, formatByKey7 },
			v19
		)
		newPage.ChatNotificationsFrame = chatNotificationsFrame
		_ = v20
		newPage.ChatNotificationsSelector = chatNotificationsSelector

		newPage.ChatNotificationsFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ChatNotificationsFrame

		newPage.ChatNotificationsSelector.IndexChanged:connect(function(p)
			if p == v19 then
				return
			end

			local v21 = v19 == 2
			local v22 = p == 2
			v19 = p

			if v22 then
				default5:unmuteNotification({
					notificationType = notificationGroups.ChatLandingNotificationsGroup,
					context = "InGameSettings"
				})
			else
				default5:snoozeNotification({
					notificationType = notificationGroups.ChatLandingNotificationsGroup,
					durationMinutes = -1,
					context = "InGameSettings"
				})
			end

			reportSettingsChangeForAnalytics("chat_notifications", v21, v22)
		end)

		notificationSnoozedSignal:connect(function(p)
			if p.notificationType ~= notificationTypeEnum.ChatNewMessage then
				return
			end

			local v21 = p.actionType == snoozeActionEnum.Mute and 1 or 2

			if newPage.ChatNotificationsSelector:GetSelectedIndex() ~= v21 then
				v19 = v21
				newPage.ChatNotificationsSelector:SetSelectionIndex(v21)
			end
		end)

		newPage.Displayed.Event:Connect(function()
			local v21

			if default5:isSnoozedNotificationType(notificationTypeEnum.ChatNewMessage) then
				v21 = v18.Off
			else
				v21 = v18.On
			end

			if newPage.ChatNotificationsSelector:GetSelectedIndex() ~= v21 then
				v19 = v21
				newPage.ChatNotificationsSelector:SetSelectionIndex(v21)
			end
		end)
	end

	local function createCameraDeviceOptions()
		local cameraDeviceIndex = newPage.CameraDeviceIndex or 1
		local cameraDeviceNames = newPage.CameraDeviceNames or {}
		local cameraDeviceGuids = newPage.CameraDeviceGuids or {}

		local cameraDeviceFrame, v18, cameraDeviceSelector = Utility:AddNewRow(
			newPage,
			formatByKey5,
			"Selector",
			cameraDeviceNames,
			cameraDeviceIndex
		)
		newPage.CameraDeviceFrame = cameraDeviceFrame
		_ = v18
		newPage.CameraDeviceSelector = cameraDeviceSelector

		newPage.CameraDeviceFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.CameraDeviceFrame
		local name

		if cameraDeviceIndex > 0 then
			name = cameraDeviceNames[cameraDeviceIndex] or nil
		end

		newPage.CameraDeviceInfo = {
			Name = name,
			Guid = cameraDeviceIndex > 0 and cameraDeviceGuids[cameraDeviceIndex] or nil
		}

		newPage.prevCameraDeviceName = newPage.CameraDeviceInfo.Name

		newPage.CameraDeviceSelector.IndexChanged:connect(function(p)
			if
				newPage.CameraDeviceInfo.Name == newPage.CameraDeviceNames[p]
				and newPage.CameraDeviceInfo.Guid == newPage.CameraDeviceGuids[p]
			then
				return
			end

			newPage.CameraDeviceInfo = {
				Name = newPage.CameraDeviceNames[p],
				Guid = newPage.CameraDeviceGuids[p]
			}

			local guid = newPage.CameraDeviceInfo.Guid
			v10:info("Changed webcam to: {}", guid)
			UserGameSettings.DefaultCameraID = guid
			reportSettingsChangeForAnalytics(
				"video_camera",
				newPage.prevCameraDeviceName or "None",
				newPage.CameraDeviceInfo.Name
			)

			newPage.prevCameraDeviceName = newPage.CameraDeviceInfo.Name
		end)
	end

	local function updateAudioDevices(p)
		local success, result, v18, v19 = pcall(function()
			if p == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if success then
			local v20

			if result then
				if v18 then
					if v19 then
						if #result > 0 and v19 > 0 and v19 <= #result then
							v20 = #result == #v18
						else
							v20 = false
						end
					else
						v20 = v19
					end
				else
					v20 = v18
				end
			else
				v20 = result
			end

			if v20 then
				if v18[1] == "" then
					result[1] = localization:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
				end

				newPage[p .. "DeviceNames"] = result
				newPage[p .. "DeviceGuids"] = v18
				newPage[p .. "DeviceIndex"] = v19
			else
				if GetFFlagVoiceChatUILogging() then
					v10:warning("Errors in get {} device info", p)
				end

				newPage[p .. "DeviceNames"] = {}
				newPage[p .. "DeviceGuids"] = {}
				newPage[p .. "DeviceIndex"] = 0
			end
		else
			if GetFFlagVoiceChatUILogging() then
				v10:warning("Errors in get {} device info", p)
			end

			newPage[p .. "DeviceNames"] = {}
			newPage[p .. "DeviceGuids"] = {}
			newPage[p .. "DeviceIndex"] = 0
		end

		if not newPage[p .. "DeviceSelector"] then
			createDeviceOptions(p)
			return
		end

		newPage[p .. "DeviceSelector"]:UpdateOptions(result)
		newPage[p .. "DeviceSelector"]:SetSelectionIndex(v19)
	end

	local function updateVoiceChatDevices(p)
		if p ~= "Input" and p ~= "Output" and GetFFlagVoiceChatUILogging() then
			v10:warning("{} is not supported in VoiceChat devices", p)
		end

		local success, result, v18, v19 = pcall(function()
			if p == "Input" then
				return SoundService:GetInputDevices()
			end

			return SoundService:GetOutputDevices()
		end)

		if success then
			local v20

			if result then
				if v18 then
					if v19 then
						if #result > 0 and v19 > 0 and v19 <= #result then
							v20 = #result == #v18
						else
							v20 = false
						end
					else
						v20 = v19
					end
				else
					v20 = v18
				end
			else
				v20 = result
			end

			if v20 then
				if v18[1] == "" then
					result[1] = localization:Format("CoreScripts.InGameMenu.GameSettings.Default") .. " (" .. result[1] .. ")"
				end

				newPage[p .. "DeviceNames"] = result
				newPage[p .. "DeviceGuids"] = v18
				newPage[p .. "DeviceIndex"] = v19
			else
				if GetFFlagVoiceChatUILogging() then
					if #result > 0 then
						v10:warning("Errors in get {} device info success: {}", p, success)
					else
						v10:warning("Empty deviceNames list for {}", p)
					end
				end

				newPage[p .. "DeviceNames"] = {}
				newPage[p .. "DeviceGuids"] = {}
				newPage[p .. "DeviceIndex"] = 0
			end
		else
			if GetFFlagVoiceChatUILogging() then
				if #result > 0 then
					v10:warning("Errors in get {} device info success: {}", p, success)
				else
					v10:warning("Empty deviceNames list for {}", p)
				end
			end

			newPage[p .. "DeviceNames"] = {}
			newPage[p .. "DeviceGuids"] = {}
			newPage[p .. "DeviceIndex"] = 0
		end

		if newPage[p .. "DeviceSelector"] then
			newPage[p .. "DeviceSelector"]:UpdateOptions(result)
			newPage[p .. "DeviceSelector"]:SetSelectionIndex(v19)
		else
			createDeviceOptions(p)
		end

		if newPage[p .. "DeviceFrame"] then
			if #result > 0 then
				newPage[p .. "DeviceFrame"].Visible = true
			else
				newPage[p .. "DeviceFrame"].Visible = false
			end
		end
	end

	local function updateCameraDevices()
		local cameraDevices = VideoCaptureService:GetCameraDevices()
		local cameraDeviceNames = {}
		local cameraDeviceGuids = {}

		table.insert(cameraDeviceNames, formatByKey4)
		table.insert(cameraDeviceGuids, "{DefaultDeviceGuid}")
		local v18 = 1

		for k, cameraDevice in pairs(cameraDevices) do
			if k == UserGameSettings.DefaultCameraID then
				v18 = #cameraDeviceNames + 1
			end

			table.insert(cameraDeviceNames, cameraDevice)
			table.insert(cameraDeviceGuids, k)
		end

		newPage.CameraDeviceNames = cameraDeviceNames
		newPage.CameraDeviceGuids = cameraDeviceGuids
		newPage.CameraDeviceIndex = 0

		if newPage.CameraDeviceSelector then
			newPage.CameraDeviceSelector:UpdateOptions(cameraDeviceNames)
		else
			createCameraDeviceOptions()
		end

		newPage.CameraDeviceSelector:SetSelectionIndex(v18)
	end

	local deviceListChangedConnection = nil
	local devicesChangedConnection = nil

	local function updateAudioOptions()
		if newPage.VoiceChatOptionsEnabled then
			updateVoiceChatDevices("Input")
			updateVoiceChatDevices("Output")
		else
			if GetFFlagEnableCrossExpVoice() and default4:getIsConnected() then
				updateAudioDevices("Input")
			end

			updateAudioDevices("Output")
		end
	end

	local function setupDeviceChangedListener() -- 1 equivalent call inferred from this helper
		if SoundService.DeviceListChanged then
			deviceListChangedConnection = SoundService.DeviceListChanged:Connect(function()
				if newPage.PageOpen then
					updateAudioOptions()
				end
			end)
		end
	end

	local function setupVideoCameraDeviceChangedListener() -- 2 equivalent calls inferred from this helper
		if VideoCaptureService.DevicesChanged then
			devicesChangedConnection = VideoCaptureService.DevicesChanged:Connect(function()
				if newPage.PageOpen then
					updateCameraDevices()
				end
			end)
		end
	end

	local function teardownDeviceChangedListener() -- 1 equivalent call inferred from this helper
		if SoundService.DeviceListChanged and deviceListChangedConnection then
			deviceListChangedConnection:Disconnect()
		end
	end

	local function teardownVideoCameraDeviceChangedListener() -- 1 equivalent call inferred from this helper
		if VideoCaptureService.DevicesChanged and devicesChangedConnection then
			devicesChangedConnection:Disconnect()
			devicesChangedConnection = nil
		end
	end

	local heartbeatConnection = nil
	local viewportSizeChangedConnection = nil
	local currentCameraChangedConnection = nil

	local function setupUIScaleViewportChangedListener()
		if not engineFeature3 then
			return
		end

		if FFlagUIScaleEngineOptions and not heartbeatConnection then
			local total = 0
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				total += dt

				if total >= 0.1 and newPage.PageOpen then
					total = 0
					refreshUIScaleRows()
				end
			end)
		end

		local function rebindToCurrentCamera()
			if viewportSizeChangedConnection then
				viewportSizeChangedConnection:Disconnect()
				viewportSizeChangedConnection = nil
			end

			local currentCamera = workspace.CurrentCamera

			if not currentCamera then
				return
			end

			viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				if newPage.PageOpen then
					if FFlagUIScaleEngineOptions then
						refreshUIScaleRows()
						return
					end

					createUIScaleOptions() -- inferred equivalent call
				end
			end)
		end

		rebindToCurrentCamera()

		currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(rebindToCurrentCamera)
	end

	local function teardownUIScaleViewportChangedListener() -- 1 equivalent call inferred from this helper
		if heartbeatConnection then
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
		end

		if viewportSizeChangedConnection then
			viewportSizeChangedConnection:Disconnect()
			viewportSizeChangedConnection = nil
		end

		if currentCameraChangedConnection then
			currentCameraChangedConnection:Disconnect()
			currentCameraChangedConnection = nil
		end

		v15 = nil
		v16 = nil
	end

	local function checkVoiceChatOptions() -- 1 equivalent call inferred from this helper
		if default3:VoiceChatAvailable() then
			newPage.VoiceChatOptionsEnabled = true
		end
	end

	local function updateInputDeviceVisibility()
		local voiceChatOptionsEnabled = newPage.VoiceChatOptionsEnabled
			or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

		if newPage.InputDeviceFrame then
			newPage.InputDeviceFrame.Visible = voiceChatOptionsEnabled
		end
	end

	local flag2 = false
	local v18

	if defineFastFlag8 then
		v18 = false
	else
		v18 = nil
	end

	local function createVoiceChatSelector()
		if defineFastFlag6 and newPage.VoiceConnectDisconnectFrame and newPage.VoiceConnectDisconnectSelector then
			return
		end

		local formatted = localization:Format("Feature.GameDetails.Label.VoiceChat")
		local formatted2 = localization:Format("Feature.SettingsHub.Label.Disconnected")
		local formatted3 = localization:Format("Feature.SettingsHub.Label.Connected")

		local v19 = default3:VoiceChatEnded() and 1 or 2

		local voiceConnectDisconnectFrame, v20, voiceConnectDisconnectSelector = Utility:AddNewRow(
			newPage,
			formatted,
			"Selector",
			{ formatted2, formatted3 },
			v19
		)
		newPage.VoiceConnectDisconnectFrame = voiceConnectDisconnectFrame
		_ = v20
		newPage.VoiceConnectDisconnectSelector = voiceConnectDisconnectSelector

		newPage.VoiceConnectDisconnectFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VoiceConnectDisconnectSelector

		local service = default3:getService()

		if service and not defineFastFlag8 then
			service.StateChanged:Connect(function(p, p2)
				if defineFastFlag6 then
					if p == p2 then
						return
					end

					if
						p2 == Enum.VoiceChatState.Joined
						and newPage.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2
					then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					elseif
						(p2 == Enum.VoiceChatState.Ended or p2 == Enum.VoiceChatState.Failed or p2 == Enum.VoiceChatState.Idle)
						and newPage.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1
					then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				else
					if p == p2 then
						return
					end

					if p2 == Enum.VoiceChatState.Joined then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					elseif default3:VoiceChatEnded() then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end
			end)
		end

		local v21 = v19

		local fIntDebounceDisconnectButtonDelay = GetFIntDebounceDisconnectButtonDelay()
		local v22 = fIntDebounceDisconnectButtonDelay > 0

		local function fn(p)
			if p == v21 then
				return
			end

			v21 = p

			if defineFastFlag8 and v18 then
				return
			end

			if FFlagVoiceRewarmTelemetry then
				local connectDisconnectButtonAnalyticsData, v23, v24, v25 = default3:GetConnectDisconnectButtonAnalyticsData(p == 2)
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId(
					"clicked",
					connectDisconnectButtonAnalyticsData,
					v23,
					v24,
					v25,
					default3.joinVoiceButtonContext
				)
			else
				default3.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId(
					"clicked",
					default3:GetConnectDisconnectButtonAnalyticsData(p == 2)
				)
			end

			if p == 2 then
				default3.pendingConnectionSource = Constants2.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default3:JoinVoice()
			elseif defineFastFlag11 then
				local service2 = default3:getService()
				local v23

				if service2 == nil then
					v23 = false
				else
					v23 = service2.VoiceChatState == Enum.VoiceChatState.Failed
				end

				if not (default3:VoiceChatEnded() or v23) then
					default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
					default3:Leave()
				end
			elseif not default3:VoiceChatEnded() then
				default3.pendingDisconnectReason = Constants2.VOICE_DISCONNECT_REASON.USER_DISCONNECT
				default3:Leave()
			end

			if flag2 then
				task.spawn(function()
					task.wait(0.5)

					if p ~= 1 then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
					end
				end)
			end
		end

		local indexChanged = newPage.VoiceConnectDisconnectSelector.IndexChanged

		if v22 then
			fn = ThrottleFunctionCall(fIntDebounceDisconnectButtonDelay, fn)
		end

		indexChanged:connect(fn)

		if defineFastFlag4 then
			newPage.VoiceConnectDisconnectFrame.SelectionChanged:Connect(function(p, selectedCoreObject, p2)
				if
					p2
					and selectedCoreObject
					and selectedCoreObject.Parent
					and selectedCoreObject.Parent.Name == formatted .. "Frame"
					and p2.Name == "ImageButton"
					and newPage.Active
				then
					GuiService.SelectedCoreObject = selectedCoreObject
				end
			end)
		end

		default3:subscribe("OnStateChanged", function(p, p2)
			if defineFastFlag8 then
				v18 = true

				if defineFastFlag10 then
					if
						p2 == Enum.VoiceChatState.Joined
						and newPage.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 2
					then
						newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
					end
				elseif p2 == Enum.VoiceChatState.Joined then
					newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)
				end
			end

			if defineFastFlag10 then
				if
					p2 == Enum.VoiceChatState.Failed
					and newPage.VoiceConnectDisconnectSelector:GetSelectedIndex() ~= 1
				then
					newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
				end
			elseif p2 == Enum.VoiceChatState.Failed then
				newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)
			end

			if defineFastFlag8 then
				if defineFastFlag9 then
					task.defer(function()
						v18 = false
					end)
				else
					v18 = false
				end
			end
		end)

		default3:subscribe("OnRequestMicPermissionRejected", function()
			task.spawn(function()
				task.wait(0.5)
				flag2 = true

				if defineFastFlag8 then
					v18 = true
				end

				newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(1)

				if defineFastFlag8 then
					if defineFastFlag9 then
						task.defer(function()
							v18 = false
						end)
					else
						v18 = false
					end
				end
			end)
		end)
	end

	local function createVRComfortSettingOptions()
		local enumItems = Enum.VRComfortSetting:GetEnumItems()
		local v19 = {
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

		local v20 = {}

		for i, enumItem in ipairs(enumItems) do
			v20[i] = localization:Format(v19[tostring(enumItem)])
		end

		local index = table.find(enumItems, gameSettings.VRComfortSetting)
		local vrComfortSettingFrame, vrComfortSettingLabel, vrComfortSettingSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.PageTitle.VRComfortSettings"),
			"Selector",
			v20,
			index,
			nil,
			localization:Format("CoreScripts.InGameMenu.GameSettings.ComfortSettingsDescription")
		)
		newPage.VRComfortSettingFrame = vrComfortSettingFrame
		newPage.VRComfortSettingLabel = vrComfortSettingLabel
		newPage.VRComfortSettingSelector = vrComfortSettingSelector

		newPage.VRComfortSettingFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRComfortSettingFrame

		local v21 = gameSettings.VignetteEnabled and 1 or 2
		local vrVignetteEnabledFrame, vrVignetteEnabledLabel, vrVignetteEnabledSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.VignetteEnabled"),
			"Selector",
			{ localization:Format("InGame.CommonUI.Label.On"), localization:Format("InGame.CommonUI.Label.Off") },
			v21
		)
		newPage.VRVignetteEnabledFrame = vrVignetteEnabledFrame
		newPage.VRVignetteEnabledLabel = vrVignetteEnabledLabel
		newPage.VRVignetteEnabledSelector = vrVignetteEnabledSelector

		newPage.VRVignetteEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRVignetteEnabledFrame

		local v22 = gameSettings.VRSmoothRotationEnabled and 2 or 1

		local vrSteppedRotationEnabledFrame, vrSteppedRotationEnabledLabel, vrSteppedRotationEnabledSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.VRSteppedRotationEnabled"),
			"Selector",
			{ localization:Format("InGame.CommonUI.Label.On"), localization:Format("InGame.CommonUI.Label.Off") },
			v22
		)
		newPage.VRSteppedRotationEnabledFrame = vrSteppedRotationEnabledFrame
		newPage.VRSteppedRotationEnabledLabel = vrSteppedRotationEnabledLabel
		newPage.VRSteppedRotationEnabledSelector = vrSteppedRotationEnabledSelector

		newPage.VRSteppedRotationEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSteppedRotationEnabledFrame

		local v23 = gameSettings.VRThirdPersonFollowCamEnabled and 2 or 1

		local vrThirdPersonFixedCamEnabledFrame, vrThirdPersonFixedCamEnabledLabel, vrThirdPersonFixedCamEnabledSelector = Utility:AddNewRow(
			newPage,
			localization:Format("CoreScripts.InGameMenu.GameSettings.VRThirdPersonFixedCamEnabled"),
			"Selector",
			{ localization:Format("InGame.CommonUI.Label.On"), localization:Format("InGame.CommonUI.Label.Off") },
			v23
		)
		newPage.VRThirdPersonFixedCamEnabledFrame = vrThirdPersonFixedCamEnabledFrame
		newPage.VRThirdPersonFixedCamEnabledLabel = vrThirdPersonFixedCamEnabledLabel
		newPage.VRThirdPersonFixedCamEnabledSelector = vrThirdPersonFixedCamEnabledSelector

		newPage.VRThirdPersonFixedCamEnabledFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRThirdPersonFixedCamEnabledFrame

		local function fn(p)
			if p == Enum.VRComfortSetting.Custom then
				newPage.VRVignetteEnabledSelector:SetZIndex(2)
				newPage.VRVignetteEnabledLabel.ZIndex = 2
				newPage.VRVignetteEnabledSelector:SetInteractable(true)
				newPage.VRSteppedRotationEnabledSelector:SetZIndex(2)
				newPage.VRSteppedRotationEnabledLabel.ZIndex = 2
				newPage.VRSteppedRotationEnabledSelector:SetInteractable(true)
				newPage.VRThirdPersonFixedCamEnabledSelector:SetZIndex(2)
				newPage.VRThirdPersonFixedCamEnabledLabel.ZIndex = 2
				newPage.VRThirdPersonFixedCamEnabledSelector:SetInteractable(true)
			else
				newPage.VRVignetteEnabledSelector:SetZIndex(1)
				newPage.VRVignetteEnabledLabel.ZIndex = 1
				newPage.VRVignetteEnabledSelector:SetInteractable(false)
				newPage.VRSteppedRotationEnabledSelector:SetZIndex(1)
				newPage.VRSteppedRotationEnabledLabel.ZIndex = 1
				newPage.VRSteppedRotationEnabledSelector:SetInteractable(false)
				newPage.VRThirdPersonFixedCamEnabledSelector:SetZIndex(1)
				newPage.VRThirdPersonFixedCamEnabledLabel.ZIndex = 1
				newPage.VRThirdPersonFixedCamEnabledSelector:SetInteractable(false)
			end
		end

		newPage.VRComfortSettingSelector.IndexChanged:connect(function(p)
			local enumItem = enumItems[p]
			gameSettings.VRComfortSetting = enumItem
			fn(enumItem)
		end)
		fn(gameSettings.VRComfortSetting)

		newPage.VRVignetteEnabledSelector.IndexChanged:connect(function(p)
			if gameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				gameSettings.VignetteEnabledCustomOption = p == 1
			end
		end)

		newPage.VRSteppedRotationEnabledSelector.IndexChanged:connect(function(p)
			if gameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				gameSettings.VRSmoothRotationEnabledCustomOption = p == 2
			end
		end)

		newPage.VRThirdPersonFixedCamEnabledSelector.IndexChanged:connect(function(p)
			if gameSettings.VRComfortSetting == Enum.VRComfortSetting.Custom then
				gameSettings.VRThirdPersonFollowCamEnabledCustomOption = p == 2
			end
		end)

		gameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function()
			local index2 = table.find(enumItems, gameSettings.VRComfortSetting)

			if newPage.VRComfortSettingSelector:GetSelectedIndex() ~= index2 then
				newPage.VRComfortSettingSelector:SetSelectionIndex(index2)
			end
		end)

		gameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function()
			local v24 = gameSettings.VignetteEnabled and 1 or 2

			if newPage.VRVignetteEnabledSelector:GetSelectedIndex() ~= v24 then
				newPage.VRVignetteEnabledSelector:SetSelectionIndex(v24)
			end
		end)

		gameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function()
			local v24 = gameSettings.VRSmoothRotationEnabled and 2 or 1

			if newPage.VRSteppedRotationEnabledSelector:GetSelectedIndex() ~= v24 then
				newPage.VRSteppedRotationEnabledSelector:SetSelectionIndex(v24)
			end
		end)

		gameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function()
			local v24 = gameSettings.VRThirdPersonFollowCamEnabled and 2 or 1

			if newPage.VRThirdPersonFixedCamEnabledSelector:GetSelectedIndex() ~= v24 then
				newPage.VRThirdPersonFixedCamEnabledSelector:SetSelectionIndex(v24)
			end
		end)
	end

	local function createVRSafetyBubbleModeOptions()
		local enumItems = Enum.VRSafetyBubbleMode:GetEnumItems()
		local v19 = {
			title = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle",
			description = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription",
			["Enum.VRSafetyBubbleMode.NoOne"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeNoOne",
			["Enum.VRSafetyBubbleMode.OnlyFriends"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeOnlyFriends",
			["Enum.VRSafetyBubbleMode.Anyone"] = "CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeAnyone"
		}

		local v20 = {}

		for i, enumItem in ipairs(enumItems) do
			v20[i] = localization:Format(v19[tostring(enumItem)])
		end

		local index = table.find(enumItems, gameSettings.VRSafetyBubbleMode)
		task.defer(function()
			local vrSafetyBubbleModeFrame, vrSafetyBubbleModeLabel, vrSafetyBubbleModeSelector = Utility:AddNewRow(
				newPage,
				localization:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeTitle"),
				"DropDown",
				v20,
				index,
				nil,
				localization:Format("CoreScripts.InGameMenu.GameSettings.SafetyBubbleModeDescription")
			)
			newPage.VRSafetyBubbleModeFrame = vrSafetyBubbleModeFrame
			newPage.VRSafetyBubbleModeLabel = vrSafetyBubbleModeLabel
			newPage.VRSafetyBubbleModeSelector = vrSafetyBubbleModeSelector

			newPage.VRSafetyBubbleModeFrame.LayoutOrder = SETTINGS_MENU_LAYOUT_ORDER.VRSafetyBubbleModeFrame

			newPage.VRSafetyBubbleModeSelector.IndexChanged:connect(function(p)
				gameSettings.VRSafetyBubbleMode = enumItems[p]
			end)

			gameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function()
				local index2 = table.find(enumItems, gameSettings.VRSafetyBubbleMode)

				if newPage.VRSafetyBubbleModeSelector:GetSelectedIndex() ~= index2 then
					newPage.VRSafetyBubbleModeSelector:SetSelectionIndex(index2)
				end
			end)
		end)
	end

	newPage.VoiceChatOptionsEnabled = false
	local eventConnection = nil
	local eventConnection2 = nil
	local fn

	if game:GetEngineFeature("VoiceChatSupported") then
		spawn(function()
			if
				(not defineFastFlag2 and default3:EligibleForFaeUpsell() or default3:IsSeamlessVoice())
				and default3:verifyUniverseAndPlaceCanUseVoice()
			then
				createVoiceChatSelector()

				if isVoiceFocused() and newPage.VoiceConnectDisconnectFrame then
					newPage.VoiceConnectDisconnectFrame.Visible = false
				end

				observeIsVoiceFocused(function(p)
					if p then
						if newPage.VoiceConnectDisconnectFrame then
							newPage.VoiceConnectDisconnectFrame.Visible = false
						end
					elseif newPage.VoiceConnectDisconnectFrame then
						newPage.VoiceConnectDisconnectFrame.Visible = true
					end
				end)
			end

			default3:asyncInit():andThen(function()
				VoiceChatService = default3:getService()
				checkVoiceChatOptions() -- inferred equivalent call

				if FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider and newPage.VoiceChatVolumeFrame then
					local function updateVoiceChatVolumeVisibility(p) -- 4 equivalent calls inferred from this helper
						local success, result = pcall(function()
							local VoiceChatService = game:GetService("VoiceChatService")
							local service = default3:getService()
							local v19

							if defineFastFlag12 then
								v19 = p or service and service.VoiceChatState
							else
								v19 = service and service.VoiceChatState
							end

							local v20 = v19 == Enum.VoiceChatState.Joined
							local useNewAudioApi = VoiceChatService and VoiceChatService.UseNewAudioApi

							local v21 = defineFastFlag14
								and GetFFlagEnableCrossExpVoice()
								and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice()
								and isVoiceFocused()
							newPage.VoiceChatVolumeFrame.Visible = VoiceVolumeControlsEligibility.isVoiceChatVolumeSliderVisible(
									v20,
									useNewAudioApi
								)
								and not v21
						end)

						if not success then
							v10:debug("[GameSettings] updateVoiceChatVolumeVisibility ERROR:", result)
						end
					end

					updateVoiceChatVolumeVisibility(nil) -- inferred equivalent call

					if
						defineFastFlag14
						and GetFFlagEnableCrossExpVoice()
						and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice()
					then
						observeIsVoiceFocused(function()
							updateVoiceChatVolumeVisibility(nil) -- inferred equivalent call
						end)
					end

					if defineFastFlag12 then
						default3:subscribe("OnStateChanged", function(p, p2)
							updateVoiceChatVolumeVisibility(p2) -- inferred equivalent call
						end)
					else
						local service = default3:getService()

						if service then
							service.StateChanged:Connect(function()
								updateVoiceChatVolumeVisibility(nil) -- inferred equivalent call
							end)
						end
					end
				end

				if defineFastFlag6 and default3:UserVoiceEnabled() and default3:verifyUniverseAndPlaceCanUseVoice() then
					createVoiceChatSelector()
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowNotAudiblePrompt()

					local v19 = defineFastFlag14
						and GetFFlagEnableCrossExpVoice()
						and GetFFlagFixSeamlessVoiceIntegrationWithPrivateVoice()
						and isVoiceFocused()

					if FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast and not v19 then
						default3:ShowNotAudiblePromptVoiceChatVolume()
					end
				end

				if not (defineFastFlag8 and defineFastFlag9) then
					newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

					return
				end

				v18 = true

				newPage.VoiceConnectDisconnectSelector:SetSelectionIndex(2)

				task.defer(function()
					v18 = false
				end)
			end):catch(function()
				if GetFFlagVoiceChatUILogging() then
					v10:warning("Failed to init VoiceChatServiceManager")
				end

				if not GetFFlagEnableUniveralVoiceToasts() then
					default3:CheckAndShowPermissionPrompt()
				end
			end)
		end)
	end

	if GetFFlagEnableCrossExpVoice() and not (isInExperienceUIVREnabled and isSpatial()) then
		eventConnection = default4.ExperienceJoined.Event:Connect(function()
			local voiceChatOptionsEnabled = newPage.VoiceChatOptionsEnabled
				or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if newPage[v7.Input .. "DeviceFrame"] then
				newPage[v7.Input .. "DeviceFrame"].Visible = voiceChatOptionsEnabled
			end
		end)
		eventConnection2 = default4.ExperienceLeft.Event:Connect(function()
			local voiceChatOptionsEnabled = newPage.VoiceChatOptionsEnabled
				or GetFFlagEnableCrossExpVoice() and default4:getIsConnected()

			if newPage[v7.Input .. "DeviceFrame"] then
				newPage[v7.Input .. "DeviceFrame"].Visible = voiceChatOptionsEnabled
			end
		end)
		fn = function()
			if eventConnection then
				eventConnection:Disconnect()
				eventConnection = nil
			end

			if eventConnection2 then
				eventConnection2:Disconnect()
				eventConnection2 = nil
			end
		end
	end

	newPage.VideoOptionsEnabled = false
	local connection = nil

	if GetFFlagSelfViewCameraSettings() and not (isInExperienceUIVREnabled and isSpatial()) then
		local function fn2(p)
			newPage.VideoOptionsEnabled = p.hasCameraPermissions
		end

		if isCamEnabledForUserAndPlace() then
			getCamMicPermissions(fn2, { default.Permissions.CAMERA_ACCESS }, true)

			if connection then
				connection:disconnect()
			end

			connection = cameraDevicePermissionGrantedSignal:connect(function()
				newPage.VideoOptionsEnabled = true
				updateCameraDevices()
				setupVideoCameraDeviceChangedListener() -- inferred equivalent call
			end)
		end
	end

	if not isInExperienceUIVREnabled then
		createCameraModeOptions(not isEnabled and (UserInputService.TouchEnabled or UserInputService.MouseEnabled or UserInputService.KeyboardEnabled))
	end

	local function fn2() -- 2 equivalent calls inferred from this helper
		if gameSettings.IsUsingGamepadCameraSensitivity then
			createGamepadOptions()
			return
		end

		local isUsingGamepadCameraSensitivityChangedConnection = nil
		isUsingGamepadCameraSensitivityChangedConnection = gameSettings:GetPropertyChangedSignal("IsUsingGamepadCameraSensitivity"):connect(function()
			if gameSettings.IsUsingGamepadCameraSensitivity then
				if isUsingGamepadCameraSensitivityChangedConnection then
					isUsingGamepadCameraSensitivityChangedConnection:disconnect()
				end

				createGamepadOptions()
			end
		end)
	end

	if UserInputService.MouseEnabled then
		createMouseOptions()
	elseif UserInputService.GamepadEnabled then
		fn2() -- inferred equivalent call
	else
		local gamepadConnectedConnection = nil
		gamepadConnectedConnection = UserInputService.GamepadConnected:connect(function()
			if gamepadConnectedConnection then
				gamepadConnectedConnection:disconnect()
			end

			fn2() -- inferred equivalent call
		end)
	end

	if not isInExperienceUIVREnabled then
		if gameSettings.IsUsingCameraYInverted then
			createCameraInvertedOptions()
		else
			local changedConnection = nil
			changedConnection = gameSettings.Changed:connect(function(p)
				if p == "IsUsingCameraYInverted" and gameSettings.IsUsingCameraYInverted then
					changedConnection:disconnect()
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
			createCameraModeOptions(not isEnabled and (UserInputService.TouchEnabled or UserInputService.MouseEnabled or UserInputService.KeyboardEnabled))

			if gameSettings.IsUsingCameraYInverted then
				createCameraInvertedOptions()
			else
				local changedConnection = nil
				changedConnection = gameSettings.Changed:connect(function(p)
					if p == "IsUsingCameraYInverted" and gameSettings.IsUsingCameraYInverted then
						changedConnection:disconnect()
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

	if
		fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry
		and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider
	then
		local v19 = false

		newPage.Displayed.Event:Connect(function()
			v19 = true

			if newPage.VoiceChatVolumeFrame and newPage.VoiceChatVolumeFrame.Visible then
				default3:RecordGameSettingsOpened()
			end
		end)

		newPage.Hidden.Event:Connect(function()
			v19 = false
		end)

		newPage.VoiceChatVolumeFrame:GetPropertyChangedSignal("Visible"):Connect(function()
			if newPage.VoiceChatVolumeFrame.Visible and v19 then
				default3:RecordGameSettingsOpened()
			end
		end)
	end

	if v2 then
		createPartyVoiceVolumeOptions()
	end

	if FFlagFriendsCallingCallVolumeSlider then
		createCallVolumeOptions()
	end

	createHapticsToggle()
	createGraphicsOptions()

	if defineFastFlag and GetFFlagEnablePlayerNamesEnabledSetting() then
		createPlayerNamesEnabledOptions()
	end

	if game:GetEngineFeature("InExperiencePlayerChoiceToggle") then
		PlayerChoiceTranslationSettingInitializer(newPage, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
	end

	if not isInExperienceUIVREnabled then
		createReducedMotionOptions()
		createPreferredTransparencyOptions()
	end

	createPreferredTextSizeOptions()

	if FFlagUIScaleEngineOptions then
		createUIScaleRows()
	elseif engineFeature3 then
		createUIScaleOptions() -- inferred equivalent call
	end

	createUiNavigationKeyBindOptions()

	if not CachedPolicyService:IsSubjectToChinaPolicies() then
		createPerformanceStatsOptions()
	end

	if v11 then
		createMicroProfilerOptions()
	end

	if isEnabled and getAppFeaturePolicies().getSupportsOverscan() then
		createOverscanOption()
	end

	if defineFastFlag and FFlagBadgeVisibilitySettingEnabled then
		createBadgeVisibilityOptions() -- inferred equivalent call
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

	if fFlagExpChatDictation then
		createVoiceTypingModeSettingOptions()
	end

	createChatNotificationsSettingOptions()

	createDeveloperConsoleOption()

	GetHasGuiHidingPermission(RunService:IsStudio(), LocalPlayer, PlayerPermissionsModule):andThen(function(p)
		if p then
			createUiToggleOptions()
		end
	end):catch(function(p)
		warn(p)
	end)

	v14 = true

	if VRService.VREnabled then
		onVRSettingsReady() -- inferred equivalent call
	end

	if renderMoreSettingsBanner then
		newPage.MoreSettingsBanner = renderMoreSettingsBanner({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.MoreSettingsBanner,
			parent = newPage.Page
		})
	end

	newPage.AudioHeader = renderSettingsHeader({
		headerText = "CoreScripts.InGameMenu.GameSettings.AudioHeader",
		layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioHeader,
		parent = newPage.Page
	})

	newPage.AudioDivider = renderSettingsDivider({
		layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.AudioDivider,
		parent = newPage.Page
	})

	newPage.DisplayHeader = renderSettingsHeader({
		headerText = "CoreScripts.InGameMenu.GameSettings.DisplayHeader",
		layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayHeader,
		parent = newPage.Page
	})

	newPage.DisplayDivider = renderSettingsDivider({
		layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.DisplayDivider,
		parent = newPage.Page
	})

	if not isSpatial() then
		newPage.LanguageHeader = renderSettingsHeader({
			headerText = "CoreScripts.InGameMenu.GameSettings.LanguageHeader",
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageHeader,
			parent = newPage.Page
		})

		newPage.LanguageDivider = renderSettingsDivider({
			layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.LanguageDivider,
			parent = newPage.Page
		})
	end

	newPage.ViewAndControlsHeader = renderSettingsHeader({
		headerText = "CoreScripts.InGameMenu.GameSettings.ViewandControlsHeader",
		layoutOrder = SETTINGS_MENU_LAYOUT_ORDER.ViewAndControlsHeader,
		parent = newPage.Page
	})

	newPage.TabHeader.Name = "GameSettingsTab"
	local iconscommonsettings = Migration.uiblox["icons/common/settings"]
	newPage.TabHeader.TabLabel.Icon.Text = iconscommonsettings.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[iconscommonsettings.variant]
	newPage.TabHeader.TabLabel.Title.Text = "Settings"

	newPage.Page.ZIndex = 5

	if newPage.PageListLayout then
		newPage.PageListLayout.Padding = UDim.new(0, 0)
	end

	newPage.PageOpen = false

	if game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled") then
		newPage.FeedbackEntryPointEnabled = true
	end

	local function staticFeedbackEntryPointChecksPassed(): boolean -- 1 equivalent call inferred from this helper
		if RunService:IsStudio() then
			return false
		end

		return game:GetEngineFeature("CaptureModeEnabled") ~= false and not (defineFastFlag20 and isEnabled)
	end

	function newPage.OpenSettingsPage()
		newPage.PageOpen = true

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if FFlagUIScaleEngineOptions then
			refreshUIScaleRows()
		elseif engineFeature3 then
			createUIScaleOptions() -- inferred equivalent call
		end

		if
			GetFFlagLazyInitiateExperienceLanguageSwitcher()
			and not newPage.LanguageSwitcherInitialized
			and isLangaugeSelectionDropdownEnabled()
			and GetFFlagEnableLocalesForExperienceLanguageSwitcher()
		then
			newPage.LanguageSwitcherInitialized = true
			ExperienceLanguageSwitcherInitializer(newPage, SETTINGS_MENU_LAYOUT_ORDER, reportSettingsChangeForAnalytics)
		end

		updateAudioOptions()
		setupDeviceChangedListener() -- inferred equivalent call

		if engineFeature3 then
			setupUIScaleViewportChangedListener()
		end

		newPage.startVolume = gameSettings.MasterVolume

		if
			FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast
			and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider
		then
			newPage.maxVoiceChatVolumeDuringSession = gameSettings.VoiceChatVolume
		end

		if
			GetFFlagSelfViewCameraSettings()
			and newPage.VideoOptionsEnabled
			and game:GetEngineFeature("VideoCaptureService")
		then
			updateCameraDevices()
			setupVideoCameraDeviceChangedListener() -- inferred equivalent call
		end

		updateUiToggleSelection()

		if
			game:GetEngineFeature("ExperienceStateCaptureMinMemEnabled")
			and newPage.toggleFeedbackModeButton
			and newPage.toggleFeedbackModeText
		then
			newPage.FeedbackEntryPointEnabled = ExperienceStateCaptureService ~= nil
				and ExperienceStateCaptureService:CanEnterCaptureMode()

			if newPage.FeedbackEntryPointEnabled then
				newPage.toggleFeedbackModeButton.Active = true
				newPage.toggleFeedbackModeButton.Enabled.Value = true
				newPage.toggleFeedbackModeText.Text = formatByKey3
			else
				newPage.toggleFeedbackModeButton.Active = false
				newPage.toggleFeedbackModeButton.Enabled.Value = false
				newPage.toggleFeedbackModeText.TextColor3 = Theme.color(
					"ButtonNonInteractable",
					Color3.fromRGB(100, 100, 100)
				)
				newPage.toggleFeedbackModeText.Text = formatByKey2
			end
		end

		table.insert(newPage.LastSelectableObjects, getLastValueChangerFrame(newPage))

		if FFlagIEMTabFocusNav then
			table.insert(newPage.FirstSelectableObjects, getFirstValueChangerFrame(newPage))
			newPage.FirstSelectableObjectsUpdated:fire()
		end
	end

	local function fn3() -- 1 equivalent call inferred from this helper
		if connection then
			connection:disconnect()
			connection = nil
		end
	end

	function newPage.CloseSettingsPage()
		newPage.PageOpen = false

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		teardownDeviceChangedListener() -- inferred equivalent call

		if engineFeature3 then
			teardownUIScaleViewportChangedListener() -- inferred equivalent call
		end

		if GetFFlagEnableCrossExpVoice() and fn then
			fn()
		end

		if GetFFlagSelfViewCameraSettings() then
			if game:GetEngineFeature("VideoCaptureService") then
				teardownVideoCameraDeviceChangedListener() -- inferred equivalent call
			end

			fn3() -- inferred equivalent call
		end

		if
			game:GetEngineFeature("VoiceChatSupported")
			and newPage.VoiceChatOptionsEnabled
			and newPage.startVolume ~= nil
			and newPage.startVolume > 0
		then
			default3:CheckAndShowNotAudiblePrompt()
		end

		if
			game:GetEngineFeature("VoiceChatSupported")
			and newPage.VoiceChatOptionsEnabled
			and FFlagVoiceVolumeControlsEnableNotAudibleVoiceChatVolumeToast
			and FFlagVoiceVolumeControlsEnableVoiceChatVolumeSlider
			and newPage.maxVoiceChatVolumeDuringSession ~= nil
			and newPage.maxVoiceChatVolumeDuringSession > 0
		then
			default3:ShowNotAudiblePromptVoiceChatVolume()
		end
	end

	function isLangaugeSelectionDropdownEnabled(): boolean
		if game:GetEngineFeature("EnableSetExperienceSettingsLocaleIdApi") ~= true then
			return false
		end

		if LocalPlayer.UserId % 1000 + 1 <= game:GetFastInt("V1MenuLanguageSelectionFeaturePerMillageRollout") then
			return true
		end

		for k in game:GetFastString("V1MenuLanguageSelectionFeatureForcedUserIds"):gmatch("%d+") do
			if tonumber(k) == LocalPlayer.UserId then
				return true
			end
		end

		return false
	end

	function newPage.SetHub(p, hubRef)
		newPage.HubRef = hubRef

		if isInExperienceUIVREnabled and isSpatial() then
			return
		end

		if isLangaugeSelectionDropdownEnabled() then
			if GetFFlagEnableLocalesForExperienceLanguageSwitcher() then
				if not GetFFlagLazyInitiateExperienceLanguageSwitcher() then
					ExperienceLanguageSwitcherInitializer(
						newPage,
						SETTINGS_MENU_LAYOUT_ORDER,
						reportSettingsChangeForAnalytics
					)
				end
			else
				createTranslationOptions()
			end
		end

		if game:GetEngineFeature("EnableTCSChatTranslation") and GetFFlagChatTranslationSettingEnabled() then
			if GetFFlagChatTranslationHoldoutEnabled() then
				if getChatTranslationLayerData(GetFStringChatTranslationLayerName()).ChatTranslationEnabled then
					if GetFFlagChatTranslationForceSetting() then
						gameSettings.ChatTranslationEnabled = true
					end
				elseif engineFeature then
					if GetFFlagChatTranslationNewDefaults() then
						if gameSettings.ChatTranslationLocale == "" then
							gameSettings.ChatTranslationEnabled = false
							gameSettings.ChatTranslationLocale = "en_us"
						end
					else
						gameSettings.ChatTranslationEnabled = false
					end
				else
					pcall(function()
						TextChatService.ChatTranslationEnabled = false
					end)
				end
			end

			ChatTranslationOptionsWithChatLanguageSwitcherInitializer(
				newPage,
				SETTINGS_MENU_LAYOUT_ORDER,
				reportSettingsChangeForAnalytics
			)
		end

		if staticFeedbackEntryPointChecksPassed() then -- inferred equivalent call
			createFeedbackModeOptions()
		end
	end
	return newPage
end

return Initialize()
