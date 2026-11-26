local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationEventNameEnum = require("@luauforge/bundled/ehL").FocusNavigationEventNameEnum
local InputHandlers = require(CorePackages.Packages.InputHandlers)

local function useItemCardFocusNavigationBindings(data, p2)
	local v5 = React.useMemo(function()
		local buttonA = Enum.KeyCode.ButtonA
		local v7

		if data.onSlotEmote then
			v7 = focusNavigationEventNameEnum.SlotEmote
		elseif data.onUnslotEmote then
			v7 = focusNavigationEventNameEnum.UnslotEmote
		else
			v7 = focusNavigationEventNameEnum.SelectItem
		end

		return {
			[buttonA] = v7,
			[Enum.KeyCode.ButtonL3] = focusNavigationEventNameEnum.OpenEditorDetailsPage
		}
	end, { data.onSelectItem, data.onSlotEmote, data.onUnslotEmote })

	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.OpenEditorDetailsPage] = data.onOpenEditorDetailsPage and {
				handler = InputHandlers.onRelease(data.onOpenEditorDetailsPage)
			} or nil,
			[focusNavigationEventNameEnum.SelectItem] = data.onSelectItem and {
				handler = InputHandlers.onRelease(data.onSelectItem)
			} or nil,
			[focusNavigationEventNameEnum.SlotEmote] = data.onSlotEmote and {
				handler = InputHandlers.onRelease(data.onSlotEmote)
			} or nil,
			[focusNavigationEventNameEnum.UnslotEmote] = data.onUnslotEmote and {
				handler = InputHandlers.onRelease(data.onUnslotEmote)
			} or nil
		}
	end, {
		data.onOpenEditorDetailsPage,
		data.onSelectItem,
		data.onSlotEmote,
		data.onUnslotEmote
	})

	local v7 = ReactFocusNavigation.useEventMap(v5, p2)
	return ReactFocusNavigation.useEventHandlerMap(v6, v7)
end

return useItemCardFocusNavigationBindings
