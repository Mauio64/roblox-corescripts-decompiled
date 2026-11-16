local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)

local Images = require(parent.App.ImageSet.Images)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)
local withStyle = require(parent.Core.Style.withStyle)

local extended = Roact.PureComponent:extend("TileUnselectedOverlay")

local squircleshollow = Images["squircles/hollow"]

extended.validateProps = t.strictInterface({ ZIndex = t.optional(t.integer) })

function extended.render(p)
	local zIndex = p.props.ZIndex

	return withStyle(function(p2)
		local tokens = p2.Tokens

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = zIndex
			},
			{
				SelectionImage = Roact.createElement(ImageSetComponent.Label, {
					AnchorPoint = Vector2.new(1, 0),
					BackgroundTransparency = 1,
					Image = squircleshollow,
					Position = UDim2.new(1, -tokens.Size.Size_200, 0, tokens.Size.Size_200),
					Size = UDim2.fromOffset(24, 24)
				})
			}
		)
	end)
end

return extended
