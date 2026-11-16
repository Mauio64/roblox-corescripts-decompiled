local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AXCommon = require(parent.AXCommon)

local CatalogRowItemCard = AXCommon.Components.CatalogItemCard.CatalogRowItemCard

local function SelectableItemCardRowView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "row align-y-top gap-medium auto-xy",
		testId = "SelectableItemCardRowView",
		LayoutOrder = props.LayoutOrder
	}
	local selectionCheckbox

	if props.isSelectionEnabled then
		selectionCheckbox = React.createElement(Foundation.Checkbox, {
			label = "",
			isChecked = props.isSelected,
			isDisabled = props.isSelectionDisabled,
			onActivated = props.onSelectionToggled,
			size = props.checkboxSize or Foundation.Enums.InputSize.Small,
			LayoutOrder = 1
		})
	end

	return createElement(view, v, {
		SelectionCheckbox = selectionCheckbox,
		ItemCard = React.createElement(CatalogRowItemCard, props.cardProps)
	})
end

return SelectableItemCardRowView
