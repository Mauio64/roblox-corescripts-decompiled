local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Display = require(CorePackages.Workspace.Packages.Display)
local getUIScale = Display.GetDisplayStore(false).getUIScale
local ParentParent = script.Parent.Parent
local TenFootInterface = require(ParentParent.TenFootInterface)
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local ChromeShared = ParentParent.Chrome.ChromeShared
local isNewTiltIconEnabled = require(ParentParent.isNewTiltIconEnabled)
local FFlagTopBarRefactor = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarRefactor
local FFlagEnableSideSheet = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSideSheet
local v13 = if not Enabled() then nil else require(ChromeShared.Utility.GetStyleTokens)()

local function withUIScale(n1: number) -- line: 22
	-- upvalues: TenFootInterface (copy), Enabled (copy)
	local v29 = not TenFootInterface:IsEnabled() and 1 or 1.5

	if Enabled() then
		return v29 * n1
	end

	return n1
end

local v15 = not Enabled() and 36 or v13.Size.Size_900
local v16 = v15 - 4
local v18

if Enabled() then
	local v17 = not TenFootInterface:IsEnabled() and 1 or 1.5

	v18 = not Enabled() and 58 or v17 * 58
else
	v18 = 58
end

local v19 = v18
local v20 = not Enabled() and 44 or v13.Size.Size_1100

local function getTopbarHeight() -- line: 32
	-- upvalues: isNewTiltIconEnabled (copy), v15 (copy), Enabled (copy), v19 (copy)
	if not isNewTiltIconEnabled() then
		return v15
	end

	if Enabled() then
		return v19
	end

	return v15
end

local v22 = if isNewTiltIconEnabled() then if not Enabled() then v15 else v19 else v15
local v23 = if not Enabled() then v16 else v20
local v24 = not Enabled() and 2 or v13.Padding.XXSmall
local v25 = not Enabled() and 16 or v13.Gap.Large
local v26 = not Enabled() and 12 or v13.Padding.Small
local t1 = {
	Enum.UserInputType.Gamepad1,
	Enum.UserInputType.Gamepad2,
	Enum.UserInputType.Gamepad3,
	Enum.UserInputType.Gamepad4,
	Enum.UserInputType.Gamepad5,
	Enum.UserInputType.Gamepad6,
	Enum.UserInputType.Gamepad7,
	Enum.UserInputType.Gamepad8
}

return {
	MenuIconOpenScale = 1.25,
	MenuIconKeepOutAreaId = "roblox-menu-icon",
	HealthBarKeepOutAreaId = "health-bar",
	MoreMenuKeepOutAreaId = "more-menu",
	ChatIconKeepOutAreaId = "chat-icon",
	BackIconKeepOutAreaId = "back-icon",
	VoiceBetaBadgeKeepOutAreaId = "badge-voice-beta",
	TopBarKeepOutAreaId = "roblox-topbar",
	InitialHealth = 100,
	HealthPercentForOverlay = 0.05,
	ApplyDisplayScale = function(n2: number) -- line: 63
		-- upvalues: getUIScale (copy)
		return getUIScale(false) * n2
	end,
	useDisplayScaleState = function(n3: number) -- line: 66
		-- upvalues: SignalsReact (copy), Signals (copy), Display (copy)
		return SignalsReact.useSignalState(Signals.createComputed(function(p1) -- line: 67
			-- upvalues: Display (copy), n3 (copy)
			local getUIScale2 = Display.GetDisplayStore(p1).getUIScale

			return n3 * getUIScale2(p1)
		end))
	end,
	TopBarHeight = v22,
	TopBarHeightTenFoot = not Enabled() and 72 or nil,
	TopBarButtonHeight = v23,
	TopBarButtonPadding = v24,
	TopBarTopMargin = if not FFlagTopBarRefactor then v22 - v23 - 2 * v24 else v13.Gap.Medium,
	LegacyCloseMenuIconSize = not isNewTiltIconEnabled() and 30 or v22 - v13.Size.Size_100,
	MENU_ICON_SIZE = not Enabled() and 24 or v13.Size.Size_600,
	UnibarFrame = {
		PaddingTop = not Enabled() and 2 or v13.Padding.XXSmall,
		PaddingBottom = not Enabled() and 2 or v13.Padding.XXSmall,
		PaddingLeft = v25 + v26 + (if not FFlagEnableSideSheet then v22 else 0) + (not Enabled() and 2 or v13.Padding.XXSmall),
		ExtendedSize = v22 - (not Enabled() and 4 or v13.Size.Size_100)
	},
	ScreenSideOffset = v25,
	ScreenSideOffsetTenFoot = not Enabled() and 48 or nil,
	TopBarPadding = v26,
	HealthRedColor = Color3.fromRGB(255, 28, 0),
	HealthYellowColor = Color3.fromRGB(250, 235, 0),
	HealthGreenColor = Color3.fromRGB(27, 252, 107),
	InputType = {
		MouseAndKeyBoard = "MouseAndKeyboard",
		Touch = "Touch",
		Gamepad = "Gamepad"
	},
	GamepadInputTypes = t1,
	Analytics = {
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
	},
	LocalizedKeys = {
		UILessTooltipTitle = "CoreScripts.TopBar.Label.UILessHintTitle",
		UILessTooltipDescription = "CoreScripts.TopBar.Label.UILessHintDescription"
	}
}
