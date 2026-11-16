local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
require(parent.SduiCompat)

local Chip = Foundation.Chip

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiChipAccessoryProps = SharedFlags.FFlagSduiChipAccessoryProps
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiChipSizeAndVariant = SharedFlags2.FFlagSduiChipSizeAndVariant

local function SduiChip(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local position = props.position

	local leading = nil

	if FFlagSduiChipAccessoryProps and props.leading then
		leading = props.leading
	elseif props.leadingIconName then
		if props.leadingIconVariant or props.leadingIsCircular or props.leadingOnActivated then
			leading = {
				iconName = props.leadingIconName,
				iconVariant = props.leadingIconVariant,
				isCircular = props.leadingIsCircular,
				onActivated = props.leadingOnActivated
			}
		else
			leading = props.leadingIconName
		end
	end

	local trailing = nil

	if FFlagSduiChipAccessoryProps and props.trailing then
		trailing = props.trailing
	elseif props.trailingIconName then
		if props.trailingIconVariant or props.trailingIsCircular or props.trailingOnActivated then
			trailing = {
				iconName = props.trailingIconName,
				iconVariant = props.trailingIconVariant,
				isCircular = props.trailingIsCircular,
				onActivated = props.trailingOnActivated
			}
		else
			trailing = props.trailingIconName
		end
	end

	local createElement = React.createElement
	local v = {
		text = props.text,
		leading = leading,
		trailing = trailing,
		onActivated = props.onActivated,
		isChecked = props.isChecked,
		Selectable = props.selectable,
		size = 0,
		variant = 0,
		LayoutOrder = 0,
		AnchorPoint = 0,
		Position = 0
	}
	local size

	if FFlagSduiChipSizeAndVariant then
		size = props.chipSize
	else
		size = props.size
	end

	v.size = size
	local variant

	if FFlagSduiChipSizeAndVariant then
		variant = props.variant
	end

	v.variant = variant
	v.LayoutOrder = layoutOrder
	v.AnchorPoint = anchorPoint
	v.Position = position
	return createElement(Chip, v)
end

return React.memo(SduiChip)
