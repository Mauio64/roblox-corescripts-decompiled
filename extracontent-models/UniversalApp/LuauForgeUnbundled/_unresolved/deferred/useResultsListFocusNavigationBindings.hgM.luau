local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useResultsListFocusNavigationBindings(p2, p3)
	local v5 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(p2.onNavigateBack)
			}
		}
	end, { p2.onNavigateBack })

	local v6 = ReactFocusNavigation.useEventMap(navigateBacks, p3)
	return ReactFocusNavigation.useEventHandlerMap(v5, v6)
end

return useResultsListFocusNavigationBindings
