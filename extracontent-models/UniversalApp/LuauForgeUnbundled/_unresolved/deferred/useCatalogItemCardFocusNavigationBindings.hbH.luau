local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local v5 = {
	[Enum.KeyCode.ButtonA] = focusNavigationEventNameEnum.SelectItem,
	[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenItemDetailsPage
}

local function useCatalogItemCardFocusNavigationBindings(p2, p3)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SelectItem] = p2.onSelectItem and {
				handler = InputHandlers.onRelease(p2.onSelectItem)
			} or nil,
			[focusNavigationEventNameEnum.OpenItemDetailsPage] = {
				handler = InputHandlers.onRelease(p2.onOpenItemDetailsPage)
			}
		}
	end, { p2.onSelectItem, p2.onOpenItemDetailsPage })

	local v7 = ReactFocusNavigation.useEventMap(v5, p3)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

return useCatalogItemCardFocusNavigationBindings
