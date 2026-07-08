local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local React = require(ParentParentParent.React)
local Object = require(ParentParentParent.LuauPolyfill).Object
local InteractableList = require(ParentParent.Core.Control.InteractableList)
local SelectionMode = require(ParentParent.Core.Control.Enum.SelectionMode)
local useCursor = require(ParentParent.App.SelectionCursor.useCursor)
local IconTab = require(script.Parent.IconTab)
local HorizontalContainer = require(script.Parent.HorizontalContainer)

require(script.Parent.Types)

local Constants = require(script.Parent.Constants)
local t1 = {
	selection = { 1 },
	items = {},
	padding = {
		left = Constants.ICON_TAB_PADDING,
		right = Constants.ICON_TAB_PADDING
	},
	itemSpacing = UDim.new(0, Constants.ICON_TAB_ITEM_SPACING),
	itemPadding = {
		left = Constants.ICON_TAB_ITEM_PADDING_LEFT,
		right = Constants.ICON_TAB_ITEM_PADDING_RIGHT
	}
}

local function IconTabGroup(p1) -- line: 43
	-- upvalues: Object (copy), t1 (copy), useCursor (copy), HorizontalContainer (copy), Constants (copy), React (copy), InteractableList (copy), Cryo (copy), IconTab (copy), SelectionMode (copy)
	local v15 = Object.assign({}, t1, p1)
	local v16 = useCursor(UDim.new(0.5, 0), 0)

	return HorizontalContainer({
		showRoundedBackground = false,
		size = UDim2.new(0, 0, 0, Constants.ICON_TAB_GROUP_HEIGHT),
		automaticSize = Enum.AutomaticSize.X,
		padding = v15.padding
	}, {
		MainTabList = React.createElement(InteractableList, {
			size = UDim2.new(0, 0, 1, 0),
			automaticSize = Enum.AutomaticSize.X,
			fillDirection = Enum.FillDirection.Horizontal,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			sortOrder = Enum.SortOrder.LayoutOrder,
			itemList = v15.items,
			itemSize = UDim2.fromScale(0, 0),
			renderItem = function(p2, p3, b1: boolean) -- line: 60
				-- upvalues: Cryo (copy), v15 (copy), v16 (copy), React (copy), IconTab (copy)
				local t2 = {
					LayoutOrder = Cryo.List.find(v15.items, p2),
					AutomaticSize = Enum.AutomaticSize.XY,
					SelectionImageObject = v16
				}

				return React.createElement(IconTab, {
					item = p2,
					selected = b1,
					controlState = p3,
					padding = v15.itemPadding
				}), t2
			end,
			onSelectionChanged = function(p4) -- line: 75
				-- upvalues: v15 (copy)
				local v22 = v15.items[p4[1]]

				if v22 ~= nil and v22.onActivated ~= nil then
					v22.onActivated()
				end
			end,
			selection = v15.selection,
			selectionMode = SelectionMode.Single,
			padding = v15.itemSpacing
		})
	})
end

return IconTabGroup
