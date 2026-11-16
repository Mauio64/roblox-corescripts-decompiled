local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)

local Button = require(parent.Button.Button)
local ButtonType = require(parent.Button.Enum.ButtonType)
local ComboButton = require(parent.Button.ComboButton)
local Images = require(parent.ImageSet.Images)

local function fn() end

local function ExperienceActionRow(props)
	local isActionable = props.isActionable
	local horizontalPadding = props.horizontalPadding or 6
	local verticalPadding = props.verticalPadding or 6
	local height = props.height or 48
	local text = props.text
	local icon = props.icon

	if props.onOverflowPressed then
		return React.createElement(ComboButton, {
			position = UDim2.new(0, horizontalPadding, 1, -verticalPadding - 36),
			size = UDim2.new(1, -2 * horizontalPadding, 0, height - 2 * verticalPadding),
			button = {
				text = text,
				icon = icon,
				onActivated = props.onPlayPressed or fn,
				isDisabled = not isActionable
			},
			overflow = {
				icon = Images["icons/actions/truncationCollapse"],
				onActivated = props.onOverflowPressed,
				isDisabled = not isActionable
			}
		})
	end

	local createElement = React.createElement
	local buttonType

	if props.buttonType then
		buttonType = props.buttonType
	else
		buttonType = ButtonType.PrimaryContextual
	end

	return createElement(Button, {
		buttonType = buttonType,
		text = text,
		icon = icon,
		size = UDim2.new(1, -2 * horizontalPadding, 0, height - 2 * verticalPadding),
		position = UDim2.new(0, horizontalPadding, 1, -verticalPadding - 36),
		userInteractionEnabled = isActionable,
		onActivated = props.onPlayPressed or fn,
		isDisabled = not isActionable,
		isLoading = props.buttonLoading,
		feedbackType = props.feedbackType,
		DO_NOT_USE_useUIBloxButton = props.DO_NOT_USE_useUIBloxButton
	})
end

return ExperienceActionRow
