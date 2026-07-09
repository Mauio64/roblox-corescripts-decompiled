local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonStart] = FocusNavigationEventNameEnum.OpenQuickMenu,
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenCatalogContextMenu
}

local function useAvatarEditorPageFocusNavigationBindings(t2: {[any]: any}, p1) -- line: 23
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), t1 (copy)
	local v10 = React.useMemo(function() -- line: 25
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(t2.onNavigateBack)
			},
			[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not t2.onOpenBuyItemPrompt then nil else {
				handler = InputHandlers.onRelease(t2.onOpenBuyItemPrompt)
			},
			[FocusNavigationEventNameEnum.OpenQuickMenu] = if not t2.onOpenQuickMenu then nil else {
				handler = InputHandlers.onRelease(t2.onOpenQuickMenu)
			},
			[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not t2.onOpenContextMenu then nil else {
				handler = InputHandlers.onRelease(t2.onOpenContextMenu)
			}
		}
	end, {
		t2.onNavigateBack,
		t2.onOpenBuyItemPrompt,
		t2.onOpenQuickMenu,
		t2.onOpenContextMenu
	})
	local v11 = ReactFocusNavigation.useEventMap(t1, p1)

	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useAvatarEditorPageFocusNavigationBindings
