local Parent = script:FindFirstAncestor("AvatarExperienceSearch").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Dash = require(Parent.Dash)
local useDesignTokens = require(Parent.Style).useDesignTokens

local function FlexLayout(t1: {[any]: any}) -- line: 25
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), Dash (copy)
	local v8 = useDesignTokens()
	local v9 = (not t1.flexSlot or not t1.rigidSlot) and 0 or (t1.margin or if not FFlagRenameDeprecatedUIBloxTokens then v8.Global.Space_200 else v8.Size.Size_400)
	local v10 = t1.flexDirection or Enum.FillDirection.Horizontal
	local v11 = t1.reverse or false
	local v12, v13 = React.useBinding(Vector2.new(0, 0))
	local v14 = React.useCallback(function(vector2: Vector2) -- line: 37
		-- upvalues: v10 (copy), v9 (copy)
		if v10 == Enum.FillDirection.Horizontal then
			return UDim2.new(1, -(vector2.X + v9), 1, 0)
		end

		return UDim2.new(1, 0, 1, -(vector2.Y + v9))
	end, {
		v10,
		v9
	})
	local v15 = table.clone(t1)

	v15.flexDirection = nil
	v15.reverse = nil
	v15.rigidSlot = nil
	v15.flexSlot = nil
	v15.margin = nil
	v15.padding = nil

	return React.createElement("Frame", Dash.join({
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = if v10 ~= Enum.FillDirection.Horizontal then UDim2.fromScale(0, 1) else UDim2.fromScale(1, 0),
		AutomaticSize = if v10 ~= Enum.FillDirection.Horizontal then Enum.AutomaticSize.X else Enum.AutomaticSize.Y
	}, v15), {
		UILayout = React.createElement("UIListLayout", {
			FillDirection = v10,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v9)
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
			LayoutOrder = not v11 and 0 or 1,
			Size = v12:map(v14)
		}, t1.flexSlot),
		Rigid = if not t1.rigidSlot then nil else React.createElement("Frame", {
			LayoutOrder = not v11 and 1 or 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if v10 ~= Enum.FillDirection.Horizontal then UDim2.new(1, 0, 0, 0) else UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = function(p1) -- line: 96
				-- upvalues: v13 (copy)
				v13(p1.AbsoluteSize)
			end
		}, t1.rigidSlot)
	})
end

return FlexLayout
