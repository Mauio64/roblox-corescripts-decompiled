local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local function useCatalogPageFocusNavigationBindings(p2, data, p3)
	local v5 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = data.onNavigateBack and {
				handler = InputHandlers.onRelease(data.onNavigateBack)
			} or nil,
			[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = data.onOpenBuyItemPrompt and {
				handler = InputHandlers.onRelease(data.onOpenBuyItemPrompt)
			} or nil,
			[focusNavigationEventNameEnum.OpenQuickMenu] = data.onOpenQuickMenu and {
				handler = InputHandlers.onRelease(data.onOpenQuickMenu)
			} or nil,
			[focusNavigationEventNameEnum.OpenCatalogContextMenu] = data.onOpenContextMenu and {
				handler = InputHandlers.onRelease(data.onOpenContextMenu)
			} or nil,
			[focusNavigationEventNameEnum.ToggleTryOnManager] = data.onToggleTryOnManager and {
				handler = InputHandlers.onRelease(data.onToggleTryOnManager)
			} or nil,
			[focusNavigationEventNameEnum.Search] = data.onToggleSearch and {
				handler = InputHandlers.onRelease(data.onToggleSearch)
			} or nil
		}
	end, {
		data.onNavigateBack,
		data.onOpenBuyItemPrompt,
		data.onOpenQuickMenu,
		data.onOpenContextMenu,
		data.onToggleTryOnManager,
		data.onToggleSearch
	})

	local v6 = ReactFocusNavigation.useEventMap(p2, p3)
	return ReactFocusNavigation.useEventHandlerMap(v5, v6)
end

return useCatalogPageFocusNavigationBindings
