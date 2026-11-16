local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function LineItemLayout(props)
	local v = useDesignTokens()
	local v2, v3 = React.useBinding(Vector2.new(0, 0))

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder
	}, {
		Start = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v2:map(function(vector2: Vector2)
				return UDim2.new(1, -(vector2.X + v.Size.Size_400), 1, 0)
			end)
		}, props.startSlot),
		End = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			[React.Change.AbsoluteSize] = function(p)
				v3(p.AbsoluteSize)
			end
		}, props.endSlot)
	})
end

return LineItemLayout
