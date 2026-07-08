local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local t = require(ParentParentParent.t)
local Images = require(ParentParent.App.ImageSet.Images)
local ImageSetComponent = require(ParentParent.Core.ImageSet.ImageSetComponent)
local withStyle = require(ParentParent.Core.Style.withStyle)
local v8 = Roact.PureComponent:extend("TileUnselectedOverlay")
local v9 = Images["squircles/hollow"]

v8.validateProps = t.strictInterface({
	ZIndex = t.optional(t.integer)
})

function v8.render(p1) -- line: 28
	-- upvalues: withStyle (copy), Roact (copy), ImageSetComponent (copy), v9 (copy)
	local propsZIndex = p1.props.ZIndex

	return withStyle(function(p2) -- line: 31
		-- upvalues: Roact (copy), propsZIndex (copy), ImageSetComponent (copy), v9 (copy)
		local Tokens = p2.Tokens

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = propsZIndex
		}, {
			SelectionImage = Roact.createElement(ImageSetComponent.Label, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0),
				Image = v9,
				Position = UDim2.new(1, -Tokens.Global.Size_100, 0, Tokens.Global.Size_100),
				Size = UDim2.fromOffset(24, 24)
			})
		})
	end)
end

return v8
