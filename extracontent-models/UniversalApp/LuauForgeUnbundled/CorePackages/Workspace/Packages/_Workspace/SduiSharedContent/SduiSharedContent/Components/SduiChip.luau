local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local chip = Foundation.Chip

local fFlagSduiChipAccessoryProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiChipAccessoryProps
local fFlagSduiChipSizeAndVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiChipSizeAndVariant

local function SduiChip(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local position = props.position

	local v5 = nil

	if fFlagSduiChipAccessoryProps and props.leading then
		v5 = props.leading
	elseif props.leadingIconName then
		if props.leadingIconVariant or props.leadingIsCircular or props.leadingOnActivated then
			v5 = {
				iconName = props.leadingIconName,
				iconVariant = props.leadingIconVariant,
				isCircular = props.leadingIsCircular,
				onActivated = props.leadingOnActivated
			}
		else
			v5 = props.leadingIconName
		end
	end

	local v6 = nil

	if fFlagSduiChipAccessoryProps and props.trailing then
		v6 = props.trailing
	elseif props.trailingIconName then
		if props.trailingIconVariant or props.trailingIsCircular or props.trailingOnActivated then
			v6 = {
				iconName = props.trailingIconName,
				iconVariant = props.trailingIconVariant,
				isCircular = props.trailingIsCircular,
				onActivated = props.trailingOnActivated
			}
		else
			v6 = props.trailingIconName
		end
	end

	local createElement = React.createElement
	local v8 = {
		text = props.text,
		leading = v5,
		trailing = v6,
		onActivated = props.onActivated,
		isChecked = props.isChecked,
		Selectable = props.selectable,
		size = 0,
		variant = 0,
		LayoutOrder = 0,
		AnchorPoint = 0,
		Position = 0
	}
	local v9 = if fFlagSduiChipSizeAndVariant then props.chipSize else props.size
	v8.size = v9
	local v10 = if fFlagSduiChipSizeAndVariant then props.variant else nil
	v8.variant = v10
	v8.LayoutOrder = layoutOrder
	v8.AnchorPoint = anchorPoint
	v8.Position = position
	return createElement(chip, v8)
end

return React.memo(SduiChip)
