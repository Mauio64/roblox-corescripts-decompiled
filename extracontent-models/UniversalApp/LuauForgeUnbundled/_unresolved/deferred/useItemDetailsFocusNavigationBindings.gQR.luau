local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local function useItemDetailsFocusNavigationBindings(p2, p3, data)
	local v5 = ReactFocusNavigation.useEventMap(p3, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					data.onGoBack()
				end)
			},
			[focusNavigationEventNameEnum.OpenItemDetailsPrompt] = {
				handler = InputHandlers.onRelease(function(p4)
					data.onOpenItemPrompt()
				end)
			},
			[focusNavigationEventNameEnum.OpenItemDetailsPeekView] = data.onOpenPeekView and {
				handler = InputHandlers.onRelease(function(p4)
					data.onOpenPeekView()
				end)
			} or nil,
			[focusNavigationEventNameEnum.CloseItemDetailsPeekView] = data.onClosePeekView and {
				handler = InputHandlers.onRelease(function(p4)
					data.onClosePeekView()
				end)
			} or nil,
			[focusNavigationEventNameEnum.OpenCatalogContextMenu] = data.onOpenCatalogContextMenu and {
				handler = InputHandlers.onRelease(function(p4)
					data.onOpenCatalogContextMenu()
				end)
			} or nil,
			[focusNavigationEventNameEnum.MoveToItemDetails] = data.onMoveToItemDetails and {
				handler = InputHandlers.onRelease(function(p4)
					data.onMoveToItemDetails()
				end)
			} or nil
		}
	end, {
		data.onGoBack,
		data.onOpenItemPrompt,
		data.onOpenPeekView,
		data.onClosePeekView,
		data.onOpenCatalogContextMenu,
		data.onMoveToItemDetails
	})

	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

return useItemDetailsFocusNavigationBindings
