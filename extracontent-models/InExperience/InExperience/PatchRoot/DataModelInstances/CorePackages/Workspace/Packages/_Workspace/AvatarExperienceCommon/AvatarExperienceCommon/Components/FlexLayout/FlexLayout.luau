local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)
local useDesignTokens = require(Parent.Style).useDesignTokens

local function FlexLayout(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), React (copy), Dash (copy)
	local v7 = useDesignTokens()
	local v8 = (not t1.flexSlot or not t1.rigidSlot) and 0 or (t1.margin or v7.Size.Size_400)
	local v9 = t1.flexDirection or Enum.FillDirection.Horizontal
	local v10 = t1.reverse or false
	local v11, v12 = React.useBinding(Vector2.new(0, 0))
	local v13 = React.useCallback(function(vector2: Vector2) -- line: 31
		-- upvalues: v9 (copy), v8 (copy)
		if v9 == Enum.FillDirection.Horizontal then
			return UDim2.new(1, -(vector2.X + v8), 1, 0)
		end

		return UDim2.new(1, 0, 1, -(vector2.Y + v8))
	end, {
		v9,
		v8
	})
	local v14 = table.clone(t1)

	v14.flexDirection = nil
	v14.reverse = nil
	v14.rigidSlot = nil
	v14.flexSlot = nil
	v14.margin = nil
	v14.padding = nil

	return React.createElement("Frame", Dash.join({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = if v9 ~= Enum.FillDirection.Horizontal then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 0),
		AutomaticSize = if v9 ~= Enum.FillDirection.Horizontal then Enum.AutomaticSize.X else Enum.AutomaticSize.Y
	}, v14), {
		UILayout = React.createElement("UIListLayout", {
			FillDirection = v9,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v8)
		}),
		Padding = if not t1.padding then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, t1.padding.top or 0),
			PaddingRight = UDim.new(0, t1.padding.right or 0),
			PaddingBottom = UDim.new(0, t1.padding.bottom or 0),
			PaddingLeft = UDim.new(0, t1.padding.left or 0)
		}),
		Flex = if not t1.flexSlot then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = not v10 and 0 or 1,
			Size = v11:map(v13)
		}, t1.flexSlot),
		Rigid = if not t1.rigidSlot then nil else React.createElement("Frame", {
			LayoutOrder = not v10 and 1 or 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if v9 ~= Enum.FillDirection.Horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = function(p1) -- line: 90
				-- upvalues: v12 (copy)
				v12(p1.AbsoluteSize)
			end
		}, t1.rigidSlot)
	})
end

return FlexLayout
