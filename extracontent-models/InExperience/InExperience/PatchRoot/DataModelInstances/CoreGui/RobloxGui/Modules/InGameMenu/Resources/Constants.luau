local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus)
local messageBus = MessageBus.MessageBus
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableGameLeftMessage = SharedFlags.FFlagEnableGameLeftMessage
local FFlagRenameRespawnConfirmationPage = SharedFlags.FFlagRenameRespawnConfirmationPage

local inputType = { MouseAndKeyboard = "MouseAndKeyboard", Touch = "Touch", Gamepad = "Gamepad" }

return {
	InviteStatus = {
		Success = "Success",
		Moderated = "Moderated",
		Failed = "Failed",
		Pending = "Pending"
	},
	InputType = inputType,
	FallbackLocaleId = "UNKNOWN_FALLBACK",
	defaultPageKey = "InitalPage",
	advancedSettingsPageKey = "AdvancedGameSettings",
	vrComfortSettingsPageKey = "VRGameSettings",
	LeaveToAppPromptPageKey = "LeaveToAppPrompt",
	LeaveGamePromptPageKey = "LeaveGamePrompt",
	MainPagePageKey = "MainPage",
	InitalPageKey = "InitalPage",
	ReportDialogKey = "ReportDialog",
	PeoplePageKey = "peoplepage",
	PeoplePageScrollBuffer = 5,
	AnalyticsTargetName = "client",
	AnalyticsInGameMenuName = "ingame_menu",
	AnalyticsRespawnCharacterName = "respawn_character",
	AnalyticsSettingsChangeName = "change_ingame_settings",
	AnalyticsExplicitSettingsChangeName = "change_explicit_ingame_settings",
	AnalyticsSettingsSafetyBubbleModeChangeName = "change_ingame_settings_safety_bubble_mode",
	AnalyticsSettingsVRComfortSettingChangeName = "change_ingame_settings_vr_comfort_setting",
	AnalyticsFullscreenModeName = "FullscreenMode",
	AnalyticsMenuActionName = "ingame_menu_action",
	AnalyticsMenuOpenName = "menu_open",
	AnalyticsMenuOpenTypes = {
		Keyboard = "KeyboardShortcut",
		TopbarButton = "TopbarButton",
		ReportAbuseTriggered = "ReportAbuse",
		PlayersTriggered = "Players",
		SettingsTriggered = "Settings",
		EducationalMenuTriggered = "EducationalMenu",
		GamepadLeaveGame = "GamepadLeaveGame",
		GamepadResetCharacter = "GamepadResetCharacter",
		ScreenshotUnhide = "ScreenshotUnhide"
	},
	AnalyticsMenuCloseName = "menu_close",
	AnalyticsMenuLeaveName = "menu_leave",
	AnalyticsLeaveGameName = "leave_game",
	AnalyticsLeaveToHomeName = "leave_to_home",
	AnalyticsLeaveToHomeSource = "home",
	AnalyticsLeaveGameSource = "leave",
	AnalyticsMenuButtonSource = "menu_button",
	AnalyticsMenuHotkeySource = "gamepad_or_hotkey",
	AnalyticsMenuResetCharacterName = "menu_reset_character",
	AnalyticsResumeGameName = "resume",
	AnalyticsResumeShieldSource = "shield",
	AnalyticsResumeButtonSource = "button",
	AnalyticsResumeGamepadSource = "gamepad",
	AnalyticsResumeXButtonSource = "x_button",
	AnalyticsConfirmedName = "confirmed",
	AnalyticsCancelledName = "cancelled",
	AnalyticsReportLeft = "ingame_menu_report_left",
	AnalyticsReportSubmittedName = "ingame_menu_report_submitted",
	AnalyticsRequestFriendName = "RequestFriendship",
	AnalyticsRequestFriendContext = "PlayersMenu",
	AnalyticsExamineAvatarName = "examine_avatar",
	PlayerScriptStatusStrings = {
		Default = "PlayerScript Status: Default",
		Custom = "PlayerScript Status: Custom",
		PossiblyCustom = "PlayerScript Status: Possibly Custom",
		CustomOld = "PlayerScript Status: Custom Old"
	},
	ControllerBarHeight = 72,
	DisplayOrder = {
		RootMenu = 1,
		BlurredModalPortal = 2,
		FullscreenTitleBar = 7,
		ConfirmationDialog = 8,
		EducationalPopup = 9,
		HeadsetDisconnectedDialog = 100,
		ControllerBar = 9
	},
	ShieldOpenAnimationTweenTime = 0.5,
	ShieldCloseAnimationTweenTime = 0.4,
	ShieldOpenFadeTime2 = 0.25,
	ShieldCloseFadeTime2 = 0.15,
	ShieldExtraFadeTime = 0.05,
	Zone = { PortalSize = 1, ContentOffset = 2 },
	InputTypeMap = {
		[Enum.UserInputType.MouseButton1] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.MouseButton2] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.MouseButton3] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.MouseWheel] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.MouseMovement] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.Keyboard] = inputType.MouseAndKeyboard,
		[Enum.UserInputType.Gamepad1] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad2] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad3] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad4] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad5] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad6] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad7] = inputType.Gamepad,
		[Enum.UserInputType.Gamepad8] = inputType.Gamepad,
		[Enum.UserInputType.Touch] = inputType.Touch
	},
	FramerateCaps = { 60, 120, 144, 160, 165, 180, 200, 240 },
	FramerateCapsIOS = { 60, 120 },
	OnAppRatingPromptEventDescriptor = FFlagEnableGameLeftMessage and {
		mid = messageBus.getMessageId("AppRatingPrompt", "leftGame"),
		validateParams = t.strictInterface({ gameTime = t.number })
	} or nil,
	OnSurveyEventDescriptor = {
		mid = messageBus.getMessageId("Game", "openSurvey"),
		validateParams = t.strictInterface({
			eventType = t.string,
			userId = t.optional(t.string),
			customProps = t.optional(t.table)
		})
	},
	SurveyEventType = "leaveButtonClick",
	ChromeSeenCountKey = "ChromeSeenCount",
	RespawnLocalizedKey = "CoreScripts.InGameMenu.QuickActions.Respawn",
	LeaveGameLocalizedKey = "CoreScripts.InGameMenu.LeaveGame",
	ResumeLocalizedKey = "CoreScripts.InGameMenu.Prompt.ResumeGame",
	ResetCharacterLocalizedKey = not FFlagRenameRespawnConfirmationPage and "CoreScripts.InGameMenu.Action.ResetCharacter" or nil,
	ConfirmLeaveGameLocalizedKey = "CoreScripts.InGameMenu.Prompt.ConfirmLeaveGame",
	ConfirmResetCharacterLocalizedKey = FFlagRenameRespawnConfirmationPage and "CoreScripts.InGameMenu.Prompt.ConfirmRespawnCharacter" or "CoreScripts.InGameMenu.Prompt.ConfirmResetCharacter",
	DontLeaveGameLocalizedKey = "CoreScripts.InGameMenu.Action.DontLeaveGame",
	DontResetCharacterLocalizedKey = FFlagRenameRespawnConfirmationPage and "CoreScripts.InGameMenu.Action.DontRespawnCharacter" or "CoreScripts.InGameMenu.Action.DontResetCharacter",
	ConnectionLocalizedKey = "CommonUI.Features.Label.Connection",
	FriendLocalizedKey = "Feature.Friends.Label.Friend",
	AddConnectionLocalizedKey = "CommonUI.Features.Label.AddConnection",
	AddFriendLocalizedKey = "Feature.Profile.Label.AddFriend",
	InviteConnectionsLocalizedKey = "CommonUI.Features.Label.InviteConnections",
	InviteFriendsLocalizedKey = "Feature.SettingsHub.Heading.InviteFriends",
	MovementModeDynamicThumbstickKey = "Feature.SettingsHub.Default.DynamicThumbstick"
}
