local parent = script:FindFirstAncestor("ExpChat").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local function PresetCategoryTab(props)
	return React.createElement(Foundation.Chip, {
		LayoutOrder = props.layoutOrder or 0,
		text = props.name,
		isChecked = props.isSelected,
		onActivated = props.onActivated,
		size = Foundation.Enums.ChipSize.Small
	})
end

return React.memo(PresetCategoryTab)
