local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local CheckboxInnerPadding = Constants.UtilityBarFormatting.CheckboxInnerPadding

local extended = Roact.Component:extend("Checkbox")

function extended.render(p)
	local checkboxHeight = p.props.checkboxHeight
	local frameHeight = p.props.frameHeight
	local layoutOrder = p.props.layoutOrder

	local name = p.props.name
	local font = p.props.font
	local fontSize = p.props.fontSize

	local isSelected = p.props.isSelected
	local backgroundColor = p.props.selectedColor
	local unselectedColor = p.props.unselectedColor
	local onCheckboxClicked = p.props.onCheckboxClicked
	local image, borderSizePixel

	if isSelected then
		image = Constants.Image.Check
		borderSizePixel = 0
	else
		backgroundColor = unselectedColor
		image = ""
		borderSizePixel = 1
	end

	local x = TextService:GetTextSize(name, fontSize, font, Vector2.new(0, frameHeight)).X

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, checkboxHeight + x + CheckboxInnerPadding * 2, 0, frameHeight),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = function(_)
			onCheckboxClicked(name, not isSelected)
		end
	}, {
		Icon = Roact.createElement("ImageLabel", {
			Image = image,
			Size = UDim2.new(0, checkboxHeight, 0, checkboxHeight),
			Position = UDim2.new(0, 0, 0.5, -checkboxHeight / 2),
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = 0,
			BorderColor3 = Constants.Color.Text,
			BorderSizePixel = borderSizePixel
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
