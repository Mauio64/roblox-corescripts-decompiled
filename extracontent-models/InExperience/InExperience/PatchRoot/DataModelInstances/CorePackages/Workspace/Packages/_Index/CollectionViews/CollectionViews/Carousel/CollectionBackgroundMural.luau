local Parent = script:FindFirstAncestor("CollectionViews").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local useStyle = require(Parent.UIBlox).Core.Style.useStyle

local function CollectionBackgroundMural(t1: {[any]: any}) -- line: 23
	-- upvalues: useStyle (copy), useDesignTokens (copy), React (copy)
	local BackgroundDefaultColor = useStyle().Theme.BackgroundDefault.Color
	local v8 = useDesignTokens()

	return React.createElement("ImageLabel", {
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		Image = t1.backgroundMuralUrl,
		Size = t1.containerSizeBinding:map(function(vector2: Vector2) -- line: 34
			return UDim2.new(1, 0, 0, vector2.Y)
		end),
		ZIndex = t1.ZIndex or -1,
		LayoutOrder = t1.LayoutOrder,
		ScaleType = Enum.ScaleType.Crop
	}, {
		GradientFrame = React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(1, 1, 1)
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v8.Color.Extended.Black.Black_100.Color3),
					ColorSequenceKeypoint.new(1, BackgroundDefaultColor)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		})
	})
end

return React.memo(CollectionBackgroundMural)
