local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum

local function useManageOutfitPageFocusNavigationBindings(p2, p3, data)
	local v5 = ReactFocusNavigation.useEventMap(p3, p2)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p4)
					p4.cancelled = true
					data.onGoBack()
				end)
			},
			[focusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = data.onToggleMultiselect and {
				handler = InputHandlers.onRelease(function(p4)
					data.onToggleMultiselect()
				end)
			} or nil,
			[focusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = data.onCancelMultiselect and {
				handler = InputHandlers.onRelease(function(p4)
					data.onCancelMultiselect()
				end)
			} or nil,
			[focusNavigationEventNameEnum.ManageOutfitsDelete] = data.onDelete and {
				handler = InputHandlers.onRelease(function(p4)
					data.onDelete()
				end)
			} or nil,
			[focusNavigationEventNameEnum.ManageOutfitsRename] = data.onRename and {
				handler = InputHandlers.onRelease(function(p4)
					data.onRename()
				end)
			} or nil
		}
	end, {
		data.onGoBack,
		data.onToggleMultiselect,
		data.onCancelMultiselect,
		data.onDelete,
		data.onRename
	})

	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

return useManageOutfitPageFocusNavigationBindings
