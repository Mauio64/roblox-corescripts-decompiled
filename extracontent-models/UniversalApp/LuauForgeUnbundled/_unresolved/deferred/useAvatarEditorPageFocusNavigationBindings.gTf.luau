local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/eeo").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local v5 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonStart] = focusNavigationEventNameEnum.OpenQuickMenu,
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt,
	[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenCatalogContextMenu
}

local function useAvatarEditorPageFocusNavigationBindings(data, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(data.onNavigateBack)
			},
			[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = data.onOpenBuyItemPrompt and {
				handler = InputHandlers.onRelease(data.onOpenBuyItemPrompt)
			} or nil,
			[focusNavigationEventNameEnum.OpenQuickMenu] = data.onOpenQuickMenu and {
				handler = InputHandlers.onRelease(data.onOpenQuickMenu)
			} or nil,
			[focusNavigationEventNameEnum.OpenCatalogContextMenu] = data.onOpenContextMenu and {
				handler = InputHandlers.onRelease(data.onOpenContextMenu)
			} or nil
		}
	end, {
		data.onNavigateBack,
		data.onOpenBuyItemPrompt,
		data.onOpenQuickMenu,
		data.onOpenContextMenu
	})

	local v7 = ReactFocusNavigation.useEventMap(v5, p2)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

return useAvatarEditorPageFocusNavigationBindings
