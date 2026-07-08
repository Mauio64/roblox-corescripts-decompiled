local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local withStyle = require(ParentParent.Core.Style.withStyle)
local Images = require(ParentParent.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local v8 = Roact.PureComponent:extend("TileSelectionOverlay")

v8.validateProps = t.strictInterface({
	ZIndex = t.optional(t.integer),
	cornerRadius = t.optional(t.UDim)
})
v8.defaultProps = {
	cornerRadius = UDim.new(0, 0)
}

function v8.render(p1) -- line: 26
	-- upvalues: Images (copy), withStyle (copy), Roact (copy), ImageSetComponent (copy)
	local propsZIndex = p1.props.ZIndex
	local cornerRadius = p1.props.cornerRadius
	local v12 = Images["icons/actions/selectOn"]
	local v13 = v12.ImageRectSize / Images.ImagesResolutionScale

	return withStyle(function(p2) -- line: 33
		-- upvalues: Roact (copy), propsZIndex (copy), ImageSetComponent (copy), v12 (copy), v13 (copy), cornerRadius (copy)
		local Theme = p2.Theme
		local Tokens = p2.Tokens

		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.Overlay.Color,
			BackgroundTransparency = Theme.Overlay.Transparency,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = propsZIndex
		}, {
			SelectionImage = Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Image = v12,
				Position = UDim2.new(1, -Tokens.Global.Size_25, 0, Tokens.Global.Size_25),
				Size = UDim2.new(0, v13.X, 0, v13.Y)
			}),
			UICorner = cornerRadius ~= UDim.new(0, 0) and Roact.createElement("UICorner", {
				CornerRadius = cornerRadius
			}) or nil
		})
	end)
end

return v8
