local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local v5 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonR1] = focusNavigationEventNameEnum.TabForward,
	[Enum.KeyCode.ButtonL1] = focusNavigationEventNameEnum.TabBackward
}

local function useTabNavigationFocusNavigationBindings(data, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(data.onNavigateBack)
			},
			[focusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(data.onTabForward)
			},
			[focusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(data.onTabBackward)
			}
		}
	end, { data.onNavigateBack, data.onTabForward, data.onTabBackward })

	local v7 = ReactFocusNavigation.useEventMap(v5, p2)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

return useTabNavigationFocusNavigationBindings
