local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")

local chip = Foundation.Chip
local chipSize = Foundation.Enums.ChipSize

local function DescriptionLinkChipView(props, ref)
	local createElement = React.createElement
	local v6 = {
		text = props.text,
		leading = props.icon,
		size = chipSize.Small,
		onActivated = props.onActivated,
		isDisabled = props.isInvalid,
		LayoutOrder = props.LayoutOrder,
		testId = props.isInvalid and "--item-description-link-chip-invalid" or "--item-description-link-chip",
		ref = 0
	}

	if props.isInvalid then
		ref = nil
	end

	v6.ref = ref
	return createElement(chip, v6)
end

return React.forwardRef(DescriptionLinkChipView)
