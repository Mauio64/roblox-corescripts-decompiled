local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

require(Parent.SduiCompat)

local Chip = Foundation.Chip
local FFlagSduiChipAccessoryProps = require(Parent.SharedFlags).FFlagSduiChipAccessoryProps
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function SduiChip(t1: {[any]: any}) -- line: 62
	-- upvalues: FFlagSduiChipAccessoryProps (copy), React (copy), Chip (copy), FFlagSduiExperienceDetailsSupport (copy)
	local layoutOrder = t1.layoutOrder
	local anchorPoint = t1.anchorPoint
	local position = t1.position
	local leading = nil

	if FFlagSduiChipAccessoryProps and t1.leading then
		leading = t1.leading
	elseif t1.leadingIconName then
		leading = if not t1.leadingIconVariant and (not t1.leadingIsCircular and not t1.leadingOnActivated) then t1.leadingIconName else {
			iconName = t1.leadingIconName,
			iconVariant = t1.leadingIconVariant,
			isCircular = t1.leadingIsCircular,
			onActivated = t1.leadingOnActivated
		}
	end

	local trailing = nil

	if FFlagSduiChipAccessoryProps and t1.trailing then
		trailing = t1.trailing
	elseif t1.trailingIconName then
		trailing = if not t1.trailingIconVariant and (not t1.trailingIsCircular and not t1.trailingOnActivated) then t1.trailingIconName else {
			iconName = t1.trailingIconName,
			iconVariant = t1.trailingIconVariant,
			isCircular = t1.trailingIsCircular,
			onActivated = t1.trailingOnActivated
		}
	end

	return React.createElement(Chip, {
		text = t1.text,
		leading = leading,
		trailing = trailing,
		onActivated = t1.onActivated,
		isChecked = t1.isChecked,
		Selectable = if not FFlagSduiExperienceDetailsSupport then nil else t1.selectable,
		size = t1.size,
		LayoutOrder = layoutOrder,
		AnchorPoint = anchorPoint,
		Position = position
	})
end

return React.memo(SduiChip)
