local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize

local function DescriptionLinkChipView(props, ref)
	local createElement = React.createElement
	local v = {
		text = props.text,
		leading = props.icon,
		size = ChipSize.Small,
		onActivated = props.onActivated,
		isDisabled = props.isInvalid,
		LayoutOrder = props.LayoutOrder,
		testId = props.isInvalid and "--item-description-link-chip-invalid" or "--item-description-link-chip",
		ref = 0
	}

	if props.isInvalid then
		ref = nil
	end

	v.ref = ref
	return createElement(Chip, v)
end

return React.forwardRef(DescriptionLinkChipView)
