local CorePackages = game:GetService("CorePackages")

local Constants = require(script.Parent.Parent.Constants)
local Roact = require(CorePackages.Packages.Roact)

local extended = Roact.Component:extend("Checkbox")

function extended.render(p)
	local size = p.props.Size
	local position = p.props.Position or UDim2.new(0, 0, 0, 0)
	local layoutOrder = p.props.LayoutOrder or 0

	local name = p.props.Name

	local backgroundColor = p.props.SelectedColor or Constants.Color.SelectedBlue
	local unselectedColor = p.props.UnselectedColor or Constants.Color.UnselectedGray
	local onSelectedStateChanged = p.props.OnSelectedStateChanged
	local image, borderSizePixel

	if p.props.IsSelected then
		image = Constants.Image.Check
		borderSizePixel = 0
	else
		backgroundColor = unselectedColor
		image = ""
		borderSizePixel = 1
	end

	return Roact.createElement("ImageButton", {
		Size = size,
		Position = position,
		Image = image,
		BackgroundColor3 = backgroundColor,
		BackgroundTransparency = 0,
		BorderColor3 = Constants.Color.Text,
		BorderSizePixel = borderSizePixel,
		LayoutOrder = layoutOrder,
		[Roact.Event.Activated] = function(_)
			if onSelectedStateChanged then
				onSelectedStateChanged(name, not p.props.IsSelected)
			end
		end
	})
end

return extended
