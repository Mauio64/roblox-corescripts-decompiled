local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useManageOutfitPageFocusNavigationBindings(p1, p2, t1: {[any]: any}) -- line: 18
	-- upvalues: ReactFocusNavigation (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v11 = ReactFocusNavigation.useEventMap(p2, p1)
	local v12 = React.useMemo(function() -- line: 21
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 24
					-- upvalues: t1 (copy)
					p3.cancelled = true
					t1.onGoBack()
				end)
			},
			[FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = if not t1.onToggleMultiselect then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 31
					-- upvalues: t1 (copy)
					t1.onToggleMultiselect()
				end)
			},
			[FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = if not t1.onCancelMultiselect then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 38
					-- upvalues: t1 (copy)
					t1.onCancelMultiselect()
				end)
			},
			[FocusNavigationEventNameEnum.ManageOutfitsDelete] = if not t1.onDelete then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 45
					-- upvalues: t1 (copy)
					t1.onDelete()
				end)
			},
			[FocusNavigationEventNameEnum.ManageOutfitsRename] = if not t1.onRename then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 52
					-- upvalues: t1 (copy)
					t1.onRename()
				end)
			}
		}
	end, {
		t1.onGoBack,
		t1.onToggleMultiselect,
		t1.onCancelMultiselect,
		t1.onDelete,
		t1.onRename
	})

	return ReactFocusNavigation.useEventHandlerMap(v12, v11)
end

return useManageOutfitPageFocusNavigationBindings
