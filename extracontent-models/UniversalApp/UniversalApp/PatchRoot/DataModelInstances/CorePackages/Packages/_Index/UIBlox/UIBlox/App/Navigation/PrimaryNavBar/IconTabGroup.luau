local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Cryo = require(parent2.Cryo)

local React = require(parent2.React)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local InteractableList = require(parent.Core.Control.InteractableList)
local SelectionMode = require(parent.Core.Control.Enum.SelectionMode)
local useCursor = require(parent.App.SelectionCursor.useCursor)

local IconTab = require(script.Parent.IconTab)
local HorizontalContainer = require(script.Parent.HorizontalContainer)

require(script.Parent.Types)

local Constants = require(script.Parent.Constants)

local v = {
	selection = { 1 },
	items = {},
	padding = { left = Constants.ICON_TAB_PADDING, right = Constants.ICON_TAB_PADDING },
	itemSpacing = UDim.new(0, Constants.ICON_TAB_ITEM_SPACING),
	itemPadding = {
		left = Constants.ICON_TAB_ITEM_PADDING_LEFT,
		right = Constants.ICON_TAB_ITEM_PADDING_RIGHT
	}
}

local function IconTabGroup(p)
	local v2 = Object.assign({}, v, p)
	local selectionImageObject = useCursor(UDim.new(0.5, 0), 0)
	return HorizontalContainer(
		{
			size = UDim2.new(0, 0, 0, Constants.ICON_TAB_GROUP_HEIGHT),
			showRoundedBackground = false,
			automaticSize = Enum.AutomaticSize.X,
			padding = v2.padding
		},
		{
			MainTabList = React.createElement(InteractableList, {
				size = UDim2.new(0, 0, 1, 0),
				automaticSize = Enum.AutomaticSize.X,
				fillDirection = Enum.FillDirection.Horizontal,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				sortOrder = Enum.SortOrder.LayoutOrder,
				itemList = v2.items,
				itemSize = UDim2.fromScale(0, 0),
				renderItem = function(p2, controlState, selected: boolean)
					local v3 = {
						LayoutOrder = Cryo.List.find(v2.items, p2),
						AutomaticSize = Enum.AutomaticSize.XY,
						SelectionImageObject = selectionImageObject
					}

					return
						React.createElement(IconTab, {
							item = p2,
							selected = selected,
							controlState = controlState,
							padding = v2.itemPadding
						}),
						v3
				end,
				onSelectionChanged = function(list)
					local item = v2.items[list[1]]

					if item ~= nil and item.onActivated ~= nil then
						item.onActivated()
					end
				end,
				selection = v2.selection,
				selectionMode = SelectionMode.Single,
				padding = v2.itemSpacing
			})
		}
	)
end

return IconTabGroup
