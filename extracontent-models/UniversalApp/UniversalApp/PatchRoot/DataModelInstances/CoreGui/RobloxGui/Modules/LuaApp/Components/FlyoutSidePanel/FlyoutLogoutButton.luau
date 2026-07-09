local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppPage = require(Modules.LuaApp.AppPage)
local useSetDrawerVisible = require(CorePackages.Workspace.Packages.Drawer).Hooks.useSetDrawerVisible
local MoreLogOut = require(Modules.LuaApp.Components.More.MoreLogOut)
local FFlagCTAChangeLogOutToSignOut = require(Modules.LuaApp.Flags.FFlagCTAChangeLogOutToSignOut)

local function FlyoutLogoutButton(p1) -- line: 18
	-- upvalues: useSetDrawerVisible (copy), React (copy), MoreLogOut (copy), AppPage (copy), FFlagCTAChangeLogOutToSignOut (copy), ButtonVariant (copy), ButtonSize (copy)
	local v13 = useSetDrawerVisible()
	local v14 = React.useCallback(function() -- line: 20
		-- upvalues: v13 (copy)
		v13(false)
	end, {})

	return React.createElement(MoreLogOut, {
		item = {
			badgeCount = 0,
			itemType = "LogOut",
			context = {
				page = AppPage.LogoutConfirmation
			},
			textKey = not FFlagCTAChangeLogOutToSignOut and "Application.Logout.Action.Logout" or "Feature.AccountLock.Action.Signout"
		},
		willActivate = v14,
		layoutOrder = p1.layoutOrder,
		foundationButtonType = ButtonVariant.Standard,
		foundationButtonSize = ButtonSize.Large
	})
end

return FlyoutLogoutButton
