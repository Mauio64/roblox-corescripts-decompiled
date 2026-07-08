local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)
local Constants = require(script.Parent.Parent.Constants)
local CheckboxInnerPadding = Constants.UtilityBarFormatting.CheckboxInnerPadding
local v6 = Roact.Component:extend("Checkbox")

function v6.render(p1) -- line: 10
	-- upvalues: Constants (copy), TextService (copy), Roact (copy), CheckboxInnerPadding (copy)
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
	local s1 = ""
	local n1 = 1

	if isSelected then
		s1 = Constants.Image.Check
		n1 = 0
		unselectedColor = selectedColor
	end

	local X = TextService:GetTextSize(name, fontSize, font, Vector2.new(0, frameHeight)).X

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, checkboxHeight + X + CheckboxInnerPadding * 2, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = function(_) -- line: 43
			-- upvalues: onCheckboxClicked (copy), name (copy), isSelected (copy)
			onCheckboxClicked(name, not isSelected)
		end
	}, {
		Icon = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 0,
			Image = s1,
			Size = UDim2.new(0, checkboxHeight, 0, checkboxHeight),
			Position = UDim2.new(0, 0, 0.5, -checkboxHeight / 2),
			BackgroundColor3 = unselectedColor,
			BorderColor3 = Constants.Color.Text,
			BorderSizePixel = n1
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

return v6
