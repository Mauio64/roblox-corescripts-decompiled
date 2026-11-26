local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize

local module = require("@luauforge/bundled/dFu")
local useSetDrawerVisible = require("@luauforge/bundled/iaK").Hooks.useSetDrawerVisible
local module2 = require("@luauforge/bundled/hRH")

local module3 = require("@luauforge/bundled/fGa")

local fFlagCTAChangeMorePageFlyoutButtonText = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutLogoutButton(p2)
	local v5 = useSetDrawerVisible()
	local v6 = React.useCallback(function()
		v5(false)
	end, {})

	return React.createElement(module2, {
		item = {
			badgeCount = 0,
			context = { page = module.LogoutConfirmation },
			itemType = "LogOut",
			textKey = (fFlagCTAChangeMorePageFlyoutButtonText or module3) and "Feature.AccountLock.Action.Signout" or "Application.Logout.Action.Logout"
		},
		willActivate = v6,
		layoutOrder = p2.layoutOrder,
		foundationButtonType = buttonVariant.Standard,
		foundationButtonSize = buttonSize.Large
	})
end

return FlyoutLogoutButton
