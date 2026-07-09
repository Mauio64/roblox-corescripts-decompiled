local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(Parent.Style).useDesignTokens

local function LineItemLayout(t1: {[any]: any}) -- line: 14
	-- upvalues: useDesignTokens (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v7 = useDesignTokens()
	local v8, v9 = React.useBinding(Vector2.new(0, 0))

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
			Size = v8:map(function(vector2: Vector2) -- line: 29
				-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), v7 (copy)
				return UDim2.new(1, -(vector2.X + if not FFlagRenameDeprecatedUIBloxTokens then v7.Global.Space_200 else v7.Size.Size_400), 1, 0)
			end)
		}, t1.startSlot),
		End = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			[React.Change.AbsoluteSize] = function(p1) -- line: 52
				-- upvalues: v9 (copy)
				v9(p1.AbsoluteSize)
			end
		}, t1.endSlot)
	})
end

return LineItemLayout
