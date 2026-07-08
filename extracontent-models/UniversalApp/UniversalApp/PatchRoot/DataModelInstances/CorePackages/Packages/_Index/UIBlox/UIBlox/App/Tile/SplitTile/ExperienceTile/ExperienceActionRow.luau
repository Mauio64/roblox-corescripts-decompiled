local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent
local React = require(ParentParent2.React)
local Button = require(ParentParent.Button.Button)
local ButtonType = require(ParentParent.Button.Enum.ButtonType)
local ComboButton = require(ParentParent.Button.ComboButton)
local Images = require(ParentParent.ImageSet.Images)

local function v8() -- line: 21
end
local function ExperienceActionRow(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), ComboButton (copy), v8 (copy), Images (copy), Button (copy), ButtonType (copy)
	local isActionable = t1.isActionable
	local v12 = t1.horizontalPadding or 6
	local v13 = t1.verticalPadding or 6
	local v14 = t1.height or 48
	local text = t1.text
	local icon = t1.icon

	if t1.onOverflowPressed then
		return React.createElement(ComboButton, {
			position = UDim2.new(0, v12, 1, -v13 - 36),
			size = UDim2.new(1, -2 * v12, 0, v14 - 2 * v13),
			button = {
				text = text,
				icon = icon,
				onActivated = t1.onPlayPressed or v8,
				isDisabled = not isActionable
			},
			overflow = {
				icon = Images["icons/actions/truncationCollapse"],
				onActivated = t1.onOverflowPressed,
				isDisabled = not isActionable
			}
		})
	end

	return React.createElement(Button, {
		buttonType = if not t1.buttonType then ButtonType.PrimaryContextual else t1.buttonType,
		text = text,
		icon = icon,
		size = UDim2.new(1, -2 * v12, 0, v14 - 2 * v13),
		position = UDim2.new(0, v12, 1, -v13 - 36),
		userInteractionEnabled = isActionable,
		onActivated = t1.onPlayPressed or v8,
		isDisabled = not isActionable,
		isLoading = t1.buttonLoading,
		feedbackType = t1.feedbackType,
		DO_NOT_USE_useUIBloxButton = t1.DO_NOT_USE_useUIBloxButton
	})
end

return ExperienceActionRow
