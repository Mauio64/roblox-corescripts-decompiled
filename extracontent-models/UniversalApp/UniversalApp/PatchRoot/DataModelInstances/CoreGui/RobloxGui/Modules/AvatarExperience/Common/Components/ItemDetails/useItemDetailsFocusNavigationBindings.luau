local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useItemDetailsFocusNavigationBindings(p1, p2, t1: {[any]: any}) -- line: 19
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v11 = ReactFocusNavigation.useEventMap(p2, p1)
	local v12 = React.useMemo(function() -- line: 22
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 25
					-- upvalues: t1 (copy)
					p3.cancelled = true
					t1.onGoBack()
				end)
			},
			[FocusNavigationEventNameEnum.OpenItemDetailsPrompt] = {
				handler = InputHandlers.onRelease(function(_) -- line: 31
					-- upvalues: t1 (copy)
					t1.onOpenItemPrompt()
				end)
			},
			[FocusNavigationEventNameEnum.OpenItemDetailsPeekView] = if not t1.onOpenPeekView then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 37
					-- upvalues: t1 (copy)
					t1.onOpenPeekView()
				end)
			},
			[FocusNavigationEventNameEnum.CloseItemDetailsPeekView] = if not t1.onClosePeekView then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 44
					-- upvalues: t1 (copy)
					t1.onClosePeekView()
				end)
			},
			[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not t1.onOpenCatalogContextMenu then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 51
					-- upvalues: t1 (copy)
					t1.onOpenCatalogContextMenu()
				end)
			},
			[FocusNavigationEventNameEnum.MoveToItemDetails] = if not t1.onMoveToItemDetails then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 58
					-- upvalues: t1 (copy)
					t1.onMoveToItemDetails()
				end)
			}
		}
	end, {
		t1.onGoBack,
		t1.onOpenItemPrompt,
		t1.onOpenPeekView,
		t1.onClosePeekView,
		t1.onOpenCatalogContextMenu,
		t1.onMoveToItemDetails
	})

	return ReactFocusNavigation.useEventHandlerMap(v12, v11)
end

return useItemDetailsFocusNavigationBindings
