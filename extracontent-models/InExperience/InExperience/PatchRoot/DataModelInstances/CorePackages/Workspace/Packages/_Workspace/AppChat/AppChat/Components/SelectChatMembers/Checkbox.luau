local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local extended = Roact.PureComponent:extend("Checkbox")
extended.defaultProps = { activated = false }

function extended.render(p)
	return UIBlox.Style.withStyle(function(p2)
		local createElement = Roact.createElement
		local v = { Size = UDim2.new(0, 64, 1, 0), BackgroundTransparency = 1 }

		local v2 = {
			layout = Roact.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			image = 0
		}

		local createElement2 = Roact.createElement
		local v3 = {
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundTransparency = 1,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}
		local image

		if p.props.activated then
			image = Images["squircles/fill"]
		else
			image = Images["squircles/hollow"]
		end

		v3.Image = image
		local imageColor

		if p.props.activated then
			imageColor = p2.Tokens.Color.System.Emphasis.Color3
		else
			imageColor = p2.Theme.IconEmphasis.Color
		end

		v3.ImageColor3 = imageColor

		v3.ImageTransparency = p.props.activated and 0 or p2.Theme.IconEmphasis.Transparency
		local fillImage

		if p.props.activated then
			fillImage = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.fromOffset(16, 16),
				Image = Images["icons/status/success_small"]
			})
		end

		v2.image = createElement2(ImageSetLabel, v3, { FillImage = fillImage })
		return createElement("Frame", v, v2)
	end)
end

return extended
