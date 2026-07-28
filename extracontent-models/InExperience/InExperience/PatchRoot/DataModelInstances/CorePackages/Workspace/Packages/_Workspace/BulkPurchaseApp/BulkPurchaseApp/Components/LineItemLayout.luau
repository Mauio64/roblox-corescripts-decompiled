local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens

local function LineItemLayout(t1: {[any]: any}) -- line: 12
	-- upvalues: useDesignTokens (copy), React (copy)
	local v6 = useDesignTokens()
	local v7, v8 = React.useBinding(Vector2.new(0, 0))

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder
	}, {
		Start = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0),
			Size = v7:map(function(vector2: Vector2) -- line: 27
				-- upvalues: v6 (copy)
				return UDim2.new(1, -(vector2.X + v6.Size.Size_400), 1, 0)
			end)
		}, t1.startSlot),
		End = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			[React.Change.AbsoluteSize] = function(p1) -- line: 38
				-- upvalues: v8 (copy)
				v8(p1.AbsoluteSize)
			end
		}, t1.endSlot)
	})
end

return LineItemLayout
