local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local module = require("@luauforge/deferred/gmj")
local module2 = require("@luauforge/deferred/gmk")

local openQuickMenusByButtonStart = {
	[Enum.KeyCode.ButtonStart] = focusNavigationEventNameEnum.OpenQuickMenu
}

local function useAvatarExperienceFocusNavigationBindings(p2, p3)
	local v5 = module2()
	local v6 = module(p2.overlayClosedCallback)
	local v7 = React.useMemo(function()
		local openQuickMenu = focusNavigationEventNameEnum.OpenQuickMenu
		local v10 = if v5 then InputHandlers.onRelease(v6) else nil
		return {
			[openQuickMenu] = { handler = v10 }
		}
	end, { p2 })

	local v8 = ReactFocusNavigation.useEventMap(openQuickMenusByButtonStart, p3)
	return ReactFocusNavigation.useEventHandlerMap(v7, v8)
end

return useAvatarExperienceFocusNavigationBindings
