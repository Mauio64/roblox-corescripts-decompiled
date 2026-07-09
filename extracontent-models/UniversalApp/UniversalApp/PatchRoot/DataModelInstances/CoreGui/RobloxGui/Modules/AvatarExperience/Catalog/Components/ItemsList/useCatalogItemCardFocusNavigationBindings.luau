local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local t1 = {
	[Enum.KeyCode.ButtonA] = FocusNavigationEventNameEnum.SelectItem,
	[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenItemDetailsPage
}

local function useCatalogItemCardFocusNavigationBindings(t2: {[any]: any}, p1) -- line: 18
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy)
	local v10 = React.useMemo(function() -- line: 20
		-- upvalues: FocusNavigationEventNameEnum (copy), t2 (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.SelectItem] = if not t2.onSelectItem then nil else {
				handler = InputHandlers.onRelease(t2.onSelectItem)
			},
			[FocusNavigationEventNameEnum.OpenItemDetailsPage] = {
				handler = InputHandlers.onRelease(t2.onOpenItemDetailsPage)
			}
		}
	end, {
		t2.onSelectItem,
		t2.onOpenItemDetailsPage
	})
	local v11 = ReactFocusNavigation.useEventMap(t1, p1)

	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useCatalogItemCardFocusNavigationBindings
