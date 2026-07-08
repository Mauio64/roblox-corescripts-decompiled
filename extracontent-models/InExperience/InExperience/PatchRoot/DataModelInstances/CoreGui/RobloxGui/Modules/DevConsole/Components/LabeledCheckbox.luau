local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local Checkbox = require(script.Parent.Checkbox)
local CheckboxInnerPadding = Constants.UtilityBarFormatting.CheckboxInnerPadding
local v7 = Roact.Component:extend("LabeledCheckbox")

function v7.render(p1) -- line: 11
	-- upvalues: TextService (copy), Roact (copy), CheckboxInnerPadding (copy), Checkbox (copy), Constants (copy)
	local checkboxHeight = p1.props.checkboxHeight
	local frameHeight = p1.props.frameHeight
	local layoutOrder = p1.props.layoutOrder
	local name = p1.props.name
	local font = p1.props.font
	local fontSize = p1.props.fontSize
	local isSelected = p1.props.isSelected
	local selectedColor = p1.props.selectedColor
	local unselectedColor = p1.props.unselectedColor
	local onCheckboxClicked = p1.props.onCheckboxClicked
	local X = TextService:GetTextSize(name, fontSize, font, Vector2.new(0, frameHeight)).X

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, checkboxHeight + X + CheckboxInnerPadding * 2, 0, frameHeight),
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
			BackgroundTransparency = 1,
			Text = name,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = font,
			TextSize = fontSize,
			Size = UDim2.new(1, -frameHeight, 1, 0),
			Position = UDim2.new(0, checkboxHeight + CheckboxInnerPadding, 0, 0)
		})
	})
end

return v7
