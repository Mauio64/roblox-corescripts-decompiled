local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
	[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward
}

local function useTabNavigationFocusNavigationBindings(t2: {[any]: any}, p1) -- line: 21
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy)
	local v10 = React.useMemo(function() -- line: 23
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(t2.onNavigateBack)
			},
			[FocusNavigationEventNameEnum.TabForward] = {
				handler = InputHandlers.onRelease(t2.onTabForward)
			},
			[FocusNavigationEventNameEnum.TabBackward] = {
				handler = InputHandlers.onRelease(t2.onTabBackward)
			}
		}
	end, {
		t2.onNavigateBack,
		t2.onTabForward,
		t2.onTabBackward
	})
	local v11 = ReactFocusNavigation.useEventMap(t1, p1)

	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useTabNavigationFocusNavigationBindings
