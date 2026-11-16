local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local catalogRowItemCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon").Components.CatalogItemCard.CatalogRowItemCard

local function SelectableItemCardRowView(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "row align-y-top gap-medium auto-xy",
		testId = "SelectableItemCardRowView",
		LayoutOrder = props.LayoutOrder
	}

	local v7 = if props.isSelectionEnabled then React.createElement(Foundation.Checkbox, {
		label = "",
		isChecked = props.isSelected,
		isDisabled = props.isSelectionDisabled,
		onActivated = props.onSelectionToggled,
		size = props.checkboxSize or Foundation.Enums.InputSize.Small,
		LayoutOrder = 1
	}) else nil
	return createElement(view, v5, {
		SelectionCheckbox = v7,
		ItemCard = React.createElement(catalogRowItemCard, props.cardProps)
	})
end

return SelectableItemCardRowView
