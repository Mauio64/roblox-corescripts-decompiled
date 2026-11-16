local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Checkbox)
local CheckboxInnerPadding = Constants.UtilityBarFormatting.CheckboxInnerPadding

local extended = Roact.Component:extend("LabeledCheckbox")

function extended.render(p)
	local checkboxHeight = p.props.checkboxHeight
	local frameHeight = p.props.frameHeight
	local layoutOrder = p.props.layoutOrder

	local name = p.props.name
	local font = p.props.font
	local fontSize = p.props.fontSize

	local isSelected = p.props.isSelected
	local selectedColor = p.props.selectedColor
	local unselectedColor = p.props.unselectedColor
	local onCheckboxClicked = p.props.onCheckboxClicked

	local x = TextService:GetTextSize(name, fontSize, font, Vector2.new(0, frameHeight)).X

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, checkboxHeight + x + CheckboxInnerPadding * 2, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}, {
		Checkbox = Roact.createElement(Checkbox, {
			Name = name,
			IsSelected = isSelected,
			SelectedColor = selectedColor,
			UnselectedColor = unselectedColor,
			Size = UDim2.new(0, checkboxHeight, 0, checkboxHeight),
			Position = UDim2.new(0, 0, 0.5, -checkboxHeight / 2),
			OnSelectedStateChanged = onCheckboxClicked
		}),
		Text = Roact.createElement("TextLabel", {
			Text = name,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = font,
			TextSize = fontSize,
			Size = UDim2.new(1, -frameHeight, 1, 0),
			Position = UDim2.new(0, checkboxHeight + CheckboxInnerPadding, 0, 0),
			BackgroundTransparency = 1
		})
	})
end

return extended
