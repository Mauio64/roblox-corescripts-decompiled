local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Display = require(CorePackages.Workspace.Packages.Display)
local getUIScale = Display.GetDisplayStore(false).getUIScale

local parent = script.Parent.Parent
local TenFootInterface = require(parent.TenFootInterface)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled
local chromeShared = parent.Chrome.ChromeShared
local isNewTiltIconEnabled = require(parent.isNewTiltIconEnabled)
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarRefactor = InExperienceTopBar.Flags.FFlagTopBarRefactor
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags.FFlagResponsiveUnitsDeprecateTenFoot

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local v

if Enabled() then
	local GetStyleTokens = require(chromeShared.Utility.GetStyleTokens)
	v = GetStyleTokens()
end

local function withUIScale(p: number)
	if FFlagResponsiveUnitsDeprecateTenFoot then
		return p
	end

	local v2 = TenFootInterface:IsEnabled() and 1.5 or 1

	if Enabled() then
		return v2 * p
	end

	return p
end

local v2 = not Enabled() and 36 or v.Size.Size_900
local topBarButtonHeight = v2 - 4
local v3

if Enabled() and not FFlagResponsiveUnitsDeprecateTenFoot then
	local v4 = TenFootInterface:IsEnabled() and 1.5 or 1
	v3 = not Enabled() and 58 or v4 * 58
else
	v3 = 58
end

local v4 = not Enabled() and 44 or v.Size.Size_1100
local function getTopbarHeight() -- 1 equivalent call inferred from this helper
	if not isNewTiltIconEnabled() then
		return v2
	end

	return if Enabled() then v3 else v2
end

local topbarHeight = getTopbarHeight() -- inferred equivalent call

if Enabled() then
	topBarButtonHeight = v4
end

local topBarButtonPadding = not Enabled() and 2 or v.Padding.XXSmall
local screenSideOffset = not Enabled() and 16 or v.Gap.Large
local topBarPadding = not Enabled() and 12 or v.Padding.Small

local gamepadInputTypes = {
	Enum.UserInputType.Gamepad1,
	Enum.UserInputType.Gamepad2,
	Enum.UserInputType.Gamepad3,
	Enum.UserInputType.Gamepad4,
	Enum.UserInputType.Gamepad5,
	Enum.UserInputType.Gamepad6,
	Enum.UserInputType.Gamepad7,
	Enum.UserInputType.Gamepad8
}

local Constants = {
	ApplyDisplayScale = function(p: number)
		return getUIScale(false) * p
	end,
	useDisplayScaleState = function(p: number)
		return SignalsReact.useSignalState(Signals.createComputed(function(p2)
			return p * Display.GetDisplayStore(p2).getUIScale(p2)
		end))
	end,
	TopBarHeight = topbarHeight,
	TopBarHeightTenFoot = not Enabled() and 72 or nil,
	TopBarButtonHeight = topBarButtonHeight,
	TopBarButtonPadding = topBarButtonPadding,
	TopBarTopMargin = 0,
	LegacyCloseMenuIconSize = 0,
	MENU_ICON_SIZE = 0,
	MenuIconOpenScale = 1.25,
	UnibarFrame = 0,
	MenuIconKeepOutAreaId = "roblox-menu-icon",
	HealthBarKeepOutAreaId = "health-bar",
	MoreMenuKeepOutAreaId = "more-menu",
	ChatIconKeepOutAreaId = "chat-icon",
	BackIconKeepOutAreaId = "back-icon",
	TopBarKeepOutAreaId = "roblox-topbar",
	ScreenSideOffset = 0,
	ScreenSideOffsetTenFoot = 0,
	TopBarPadding = 0,
	InitialHealth = 100,
	HealthPercentForOverlay = 0.05,
	HealthRedColor = 0,
	HealthYellowColor = 0,
	HealthGreenColor = 0,
	InputType = 0,
	GamepadInputTypes = 0,
	Analytics = 0,
	LocalizedKeys = 0
}
local topBarTopMargin

if FFlagTopBarRefactor then
	topBarTopMargin = v.Gap.Medium
else
	topBarTopMargin = topbarHeight - topBarButtonHeight - 2 * topBarButtonPadding
end

Constants.TopBarTopMargin = topBarTopMargin

Constants.LegacyCloseMenuIconSize = not isNewTiltIconEnabled() and 30 or topbarHeight - v.Size.Size_100
Constants.MENU_ICON_SIZE = not Enabled() and 24 or v.Size.Size_600

Constants.UnibarFrame = {
	PaddingTop = not Enabled() and 2 or v.Padding.XXSmall,
	PaddingBottom = not Enabled() and 2 or v.Padding.XXSmall,
	PaddingLeft = screenSideOffset + topBarPadding + (isSideSheetEnabled and 0 or topbarHeight) + (not Enabled() and 2 or v.Padding.XXSmall),
	ExtendedSize = topbarHeight - (not Enabled() and 4 or v.Size.Size_100)
}

Constants.ScreenSideOffset = screenSideOffset
Constants.ScreenSideOffsetTenFoot = not Enabled() and 48 or nil

Constants.TopBarPadding = topBarPadding

Constants.HealthRedColor = Color3.fromRGB(255, 28, 0)
Constants.HealthYellowColor = Color3.fromRGB(250, 235, 0)
Constants.HealthGreenColor = Color3.fromRGB(27, 252, 107)

Constants.InputType = {
	MouseAndKeyBoard = "MouseAndKeyboard",
	Touch = "Touch",
	Gamepad = "Gamepad"
}

Constants.GamepadInputTypes = gamepadInputTypes

Constants.Analytics = {
	ShowGamepadNavigationDialog = "show-gamepad-navigation-dialog",
	DismissGamepadNavigationDialog = "dismiss-gamepad-navigation-dialog",
	EventNameTopBarButtonActivated = "topbar-button-activated",
	ChatButtonName = "chat",
	MoreMenuButtonName = "more-menu",
	InventoryButtonName = "inventory",
	LeaderboardButtonName = "leaderboard",
	EmotesButtonName = "emotes",
	StatusActive = "active",
	StatusInactive = "inactive"
}

Constants.LocalizedKeys = {
	UILessTooltipTitle = "CoreScripts.TopBar.Label.UILessHintTitle",
	UILessTooltipDescription = "CoreScripts.TopBar.Label.UILessHintDescription"
}
return Constants
