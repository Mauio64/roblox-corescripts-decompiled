local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local function useItemCardFocusNavigationBindings(t1: {[any]: any}, p1) -- line: 15
	-- upvalues: React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy)
	local v9 = React.useMemo(function() -- line: 16
		-- upvalues: t1 (copy), FocusNavigationEventNameEnum (copy)
		return {
			[Enum.KeyCode.ButtonA] = if not t1.onSlotEmote then if not t1.onUnslotEmote then FocusNavigationEventNameEnum.SelectItem else FocusNavigationEventNameEnum.UnslotEmote else FocusNavigationEventNameEnum.SlotEmote,
			[Enum.KeyCode.ButtonL3] = FocusNavigationEventNameEnum.OpenEditorDetailsPage
		}
	end, {
		t1.onSelectItem,
		t1.onSlotEmote,
		t1.onUnslotEmote
	})
	local v10 = React.useMemo(function() -- line: 27
		-- upvalues: FocusNavigationEventNameEnum (copy), t1 (copy), InputHandlers (copy)
		return {
			[FocusNavigationEventNameEnum.OpenEditorDetailsPage] = if not t1.onOpenEditorDetailsPage then nil else {
				handler = InputHandlers.onRelease(t1.onOpenEditorDetailsPage)
			},
			[FocusNavigationEventNameEnum.SelectItem] = if not t1.onSelectItem then nil else {
				handler = InputHandlers.onRelease(t1.onSelectItem)
			},
			[FocusNavigationEventNameEnum.SlotEmote] = if not t1.onSlotEmote then nil else {
				handler = InputHandlers.onRelease(t1.onSlotEmote)
			},
			[FocusNavigationEventNameEnum.UnslotEmote] = if not t1.onUnslotEmote then nil else {
				handler = InputHandlers.onRelease(t1.onUnslotEmote)
			}
		}
	end, {
		t1.onOpenEditorDetailsPage,
		t1.onSelectItem,
		t1.onSlotEmote,
		t1.onUnslotEmote
	})
	local v11 = ReactFocusNavigation.useEventMap(v9, p1)

	return ReactFocusNavigation.useEventHandlerMap(v10, v11)
end

return useItemCardFocusNavigationBindings
