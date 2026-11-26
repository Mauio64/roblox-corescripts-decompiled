local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local v5 = {
	[Enum.KeyCode.ButtonL2] = focusNavigationEventNameEnum.ItemDetailsMoveToTop,
	[Enum.KeyCode.ButtonR2] = focusNavigationEventNameEnum.ItemDetailsMoveToRecItems
}

local function useItemDetailsContainerFocusNavigationBindings(p2, p3)
	local v6 = ReactFocusNavigation.useEventMap(v5, p2)
	local v7 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.ItemDetailsMoveToTop] = {
				handler = InputHandlers.onRelease(p3.onMoveToTop)
			},
			[focusNavigationEventNameEnum.ItemDetailsMoveToRecItems] = {
				handler = InputHandlers.onRelease(p3.onMoveToRecItems)
			}
		}
	end, { p3.onMoveToTop, p3.onMoveToRecItems })
	return ReactFocusNavigation.useEventHandlerMap(v7, v6)
end

return useItemDetailsContainerFocusNavigationBindings
