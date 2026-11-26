local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local Foundation = require(CorePackages.Packages.Foundation)
local view = Foundation.View
local useFocusOnMount = require("@luauforge/bundled/ehL").useFocusOnMount
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/fvR")
local sduiSettingsPage = require("@luauforge/bundled/hTy").SduiSettingsPage
local useThemeBackground = require("@luauforge/bundled/ehR").useThemeBackground

local module2 = require("@luauforge/bundled/hTw")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local fFlagSduiSettingsFocusRef = SharedFlags.FFlagSduiSettingsFocusRef

local function SduiSettingsPageContainer()
	local v5 = useSelector(function(p2)
		return p2.TopBar.topBarHeight
	end)
	local v6

	if module2 then
		local v7 = useThemeBackground()
		v6 = React.useMemo(function()
			if v7 then
				return { Color3 = v7.baseColor, Transparency = 1 }
			end

			return nil
		end, { v7 })
	end

	local v7, v8

	if fFlagSduiSettingsFocusRef and fFlagAppPageShellScrollToTopFocus then
		local v9
		v9, v7 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
		v8 = useFocusOnMount(v9)
	end

	local createElement = React.createElement

	if not fFlagSduiSettingsFocusRef then
		v7 = nil
	end

	local v10 = {
		ref = v7,
		tag = module2 and {
			["size-full"] = true,
			["bg-surface-0"] = v6 == nil
		} or "size-full bg-surface-0",
		backgroundStyle = v6
	}

	local v11 = {
		TopBar = React.createElement(module.Container, {
			leftItem = module.BackButton,
			rightItems = { module.BuyRobuxButton, module.NotificationsButton }
		}),
		SettingsContent = 0
	}

	local createElement2 = React.createElement

	if not fFlagSduiSettingsFocusRef then
		v8 = nil
	end

	v11.SettingsContent = createElement2(sduiSettingsPage, {
		pageTopPadding = v5,
		defaultFocusRef = v8,
		backgroundStyle = v6
	})
	return createElement(view, v10, v11)
end

return SduiSettingsPageContainer
