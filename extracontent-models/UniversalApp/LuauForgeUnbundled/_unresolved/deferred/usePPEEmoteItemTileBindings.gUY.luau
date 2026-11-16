local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local v5 = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.SelectItem,
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenItemDetailsPage
}

local function usePPEEmoteItemTileBindings(p2, p3)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SelectItem] = {
				handler = InputHandlers.onRelease(p2.onSelectItem)
			},
			[focusNavigationEventNameEnum.OpenItemDetailsPage] = p2.onOpenItemDetailsPage and {
				handler = InputHandlers.onRelease(p2.onOpenItemDetailsPage)
			} or nil
		}
	end, { p2.onSelectItem, p2.onOpenItemDetailsPage })

	local v7 = ReactFocusNavigation.useEventMap(v5, p3)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

return usePPEEmoteItemTileBindings
