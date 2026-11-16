local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local t = require(parent2.t)
local withStyle = require(parent.Core.Style.withStyle)

local Images = require(parent.App.ImageSet.Images)
local ImageSetComponent = require(parent.Core.ImageSet.ImageSetComponent)

local extended = Roact.PureComponent:extend("TileSelectionOverlay")

extended.validateProps = t.strictInterface({
	ZIndex = t.optional(t.integer),
	cornerRadius = t.optional(t.UDim)
})

extended.defaultProps = { cornerRadius = UDim.new(0, 0) }

function extended.render(p)
	local zIndex = p.props.ZIndex
	local cornerRadius = p.props.cornerRadius

	local iconsactionsselectOn = Images["icons/actions/selectOn"]
	local v = iconsactionsselectOn.ImageRectSize / Images.ImagesResolutionScale

	return withStyle(function(p2)
		local theme = p2.Theme
		local tokens = p2.Tokens

		local createElement = Roact.createElement
		local v2 = {
			BackgroundColor3 = theme.Overlay.Color,
			BackgroundTransparency = theme.Overlay.Transparency,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = zIndex
		}

		local v3 = {
			SelectionImage = Roact.createElement(ImageSetComponent.Label, {
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Image = iconsactionsselectOn,
				Position = UDim2.new(1, -tokens.Size.Size_50, 0, tokens.Size.Size_50),
				Size = UDim2.new(0, v.X, 0, v.Y)
			}),
			UICorner = 0
		}
		local uiCorner

		if cornerRadius ~= UDim.new(0, 0) then
			uiCorner = Roact.createElement("UICorner", { CornerRadius = cornerRadius }) or nil
		end

		v3.UICorner = uiCorner
		return createElement("Frame", v2, v3)
	end)
end

return extended
