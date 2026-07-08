local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableGameLeftMessage = SharedFlags.FFlagEnableGameLeftMessage
local FFlagRenameRespawnConfirmationPage = SharedFlags.FFlagRenameRespawnConfirmationPage
local t1 = {
	MouseAndKeyboard = "MouseAndKeyboard",
	Touch = "Touch",
	Gamepad = "Gamepad"
}

return {
	InviteStatus = {
		Success = "Success",
		Moderated = "Moderated",
		Failed = "Failed",
		Pending = "Pending"
	},
	InputType = t1,
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
	Zone = {
		PortalSize = 1,
		ContentOffset = 2
	},
	InputTypeMap = {
		[Enum.UserInputType.MouseButton1] = t1.MouseAndKeyboard,
		[Enum.UserInputType.MouseButton2] = t1.MouseAndKeyboard,
		[Enum.UserInputType.MouseButton3] = t1.MouseAndKeyboard,
		[Enum.UserInputType.MouseWheel] = t1.MouseAndKeyboard,
		[Enum.UserInputType.MouseMovement] = t1.MouseAndKeyboard,
		[Enum.UserInputType.Keyboard] = t1.MouseAndKeyboard,
		[Enum.UserInputType.Gamepad1] = t1.Gamepad,
		[Enum.UserInputType.Gamepad2] = t1.Gamepad,
		[Enum.UserInputType.Gamepad3] = t1.Gamepad,
		[Enum.UserInputType.Gamepad4] = t1.Gamepad,
		[Enum.UserInputType.Gamepad5] = t1.Gamepad,
		[Enum.UserInputType.Gamepad6] = t1.Gamepad,
		[Enum.UserInputType.Gamepad7] = t1.Gamepad,
		[Enum.UserInputType.Gamepad8] = t1.Gamepad,
		[Enum.UserInputType.Touch] = t1.Touch
	},
	FramerateCaps = if not game:DefineFastFlag("MoreFramerateOptions", false) then {
		60,
		120,
		144,
		240
	} else {
		60,
		120,
		144,
		160,
		165,
		180,
		200,
		240
	},
	OnAppRatingPromptEventDescriptor = if not FFlagEnableGameLeftMessage then nil else {
		mid = MessageBus.getMessageId("AppRatingPrompt", "leftGame"),
		validateParams = t.strictInterface({
			gameTime = t.number
		})
	},
	OnSurveyEventDescriptor = {
		mid = MessageBus.getMessageId("Game", "openSurvey"),
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
	ConfirmResetCharacterLocalizedKey = not FFlagRenameRespawnConfirmationPage and "CoreScripts.InGameMenu.Prompt.ConfirmResetCharacter" or "CoreScripts.InGameMenu.Prompt.ConfirmRespawnCharacter",
	DontLeaveGameLocalizedKey = "CoreScripts.InGameMenu.Action.DontLeaveGame",
	DontResetCharacterLocalizedKey = not FFlagRenameRespawnConfirmationPage and "CoreScripts.InGameMenu.Action.DontResetCharacter" or "CoreScripts.InGameMenu.Action.DontRespawnCharacter",
	ConnectionLocalizedKey = "CommonUI.Features.Label.Connection",
	FriendLocalizedKey = "Feature.Friends.Label.Friend",
	AddConnectionLocalizedKey = "CommonUI.Features.Label.AddConnection",
	AddFriendLocalizedKey = "Feature.Profile.Label.AddFriend",
	InviteConnectionsLocalizedKey = "CommonUI.Features.Label.InviteConnections",
	InviteFriendsLocalizedKey = "Feature.SettingsHub.Heading.InviteFriends",
	MovementModeDynamicThumbstickKey = "Feature.SettingsHub.Default.DynamicThumbstick"
}
