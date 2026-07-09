local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local function useCatalogPageFocusNavigationBindings(p1, t1: {[any]: any}, p2) -- line: 17
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy)
	local v10 = React.useMemo(function() -- line: 19
		-- upvalues: FocusNavigationEventNameEnum (copy), t1 (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = if not t1.onNavigateBack then nil else {
				handler = InputHandlers.onRelease(t1.onNavigateBack)
			},
			[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not t1.onOpenBuyItemPrompt then nil else {
				handler = InputHandlers.onRelease(t1.onOpenBuyItemPrompt)
			},
			[FocusNavigationEventNameEnum.OpenQuickMenu] = if not t1.onOpenQuickMenu then nil else {
				handler = InputHandlers.onRelease(t1.onOpenQuickMenu)
			},
			[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not t1.onOpenContextMenu then nil else {
				handler = InputHandlers.onRelease(t1.onOpenContextMenu)
			},
			[FocusNavigationEventNameEnum.ToggleTryOnManager] = if not t1.onToggleTryOnManager then nil else {
				handler = InputHandlers.onRelease(t1.onToggleTryOnManager)
			},
			[FocusNavigationEventNameEnum.Search] = if not t1.onToggleSearch then nil else {
				handler = InputHandlers.onRelease(t1.onToggleSearch)
			}
		}
	end, {
		t1.onNavigateBack,
		t1.onOpenBuyItemPrompt,
		t1.onOpenQuickMenu,
		t1.onOpenContextMenu,
		t1.onToggleTryOnManager,
		t1.onToggleSearch
	})
	local v11 = ReactFocusNavigation.useEventMap(p1, p2)

	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useCatalogPageFocusNavigationBindings
