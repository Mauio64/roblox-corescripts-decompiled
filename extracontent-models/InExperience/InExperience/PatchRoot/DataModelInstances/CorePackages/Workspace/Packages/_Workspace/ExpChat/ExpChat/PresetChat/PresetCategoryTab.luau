local Parent = script:FindFirstAncestor("ExpChat").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)

local function PresetCategoryTab(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.Chip, {
		LayoutOrder = t1.layoutOrder or 0,
		text = t1.name,
		isChecked = t1.isSelected,
		onActivated = t1.onActivated,
		size = Foundation.Enums.ChipSize.Small
	})
end

return React.memo(PresetCategoryTab)
