local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local t1 = {
	[Enum.KeyCode.ButtonL2] = FocusNavigationEventNameEnum.ItemDetailsMoveToTop,
	[Enum.KeyCode.ButtonR2] = FocusNavigationEventNameEnum.ItemDetailsMoveToRecItems
}

local function useItemDetailsContainerFocusNavigationBindings(p1, t2: {[any]: any}) -- line: 18
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v10 = ReactFocusNavigation.useEventMap(t1, p1)
	local v11 = React.useMemo(function() -- line: 20
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t2 (copy)
		return {
			[FocusNavigationEventNameEnum.ItemDetailsMoveToTop] = {
				handler = InputHandlers.onRelease(t2.onMoveToTop)
			},
			[FocusNavigationEventNameEnum.ItemDetailsMoveToRecItems] = {
				handler = InputHandlers.onRelease(t2.onMoveToRecItems)
			}
		}
	end, {
		t2.onMoveToTop,
		t2.onMoveToRecItems
	})

	return ReactFocusNavigation.useEventHandlerMap(v11, v10)
end

return useItemDetailsContainerFocusNavigationBindings
