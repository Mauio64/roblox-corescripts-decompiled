local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local React = require(ParentParentParentParent.React)
local ReactOtter = require(ParentParentParentParent.ReactOtter)

require(ParentParent.Style.StyleTypes)

local useStyle = require(ParentParentParent.Core.Style.useStyle)
local NavigationBarAlignment = require(ParentParent.Navigation.Enum.NavigationBarAlignment)
local t1 = {
	visible = true,
	zIndex = 1,
	animated = false,
	maxWidth = 600,
	animationConfig = {
		dampingRatio = 1,
		frequency = 3
	}
}

local function NavigationBar(t2: {[any]: any}) -- line: 68
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), NavigationBarAlignment (copy), ReactOtter (copy)
	assert(#t2.items > 0, "At least one item should be present!")

	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = useStyle()
	local v14, v15 = React.useState(not v12.size and 0 or v12.size.Y.Offset)
	local v16 = if not v12.paddings or not v12.paddings.Top then v13.Tokens.Global.Space_75 else v12.paddings.Top
	local v17 = if not v12.paddings or not v12.paddings.Bottom then v13.Tokens.Global.Space_75 else v12.paddings.Bottom
	local v18 = if not v12.paddings or not v12.paddings.Left then v13.Tokens.Global.Space_75 else v12.paddings.Left
	local v19 = if not v12.paddings or not v12.paddings.Right then v13.Tokens.Global.Space_75 else v12.paddings.Right
	local Left = nil
	local SpaceAround = nil

	if v12.alignment == NavigationBarAlignment.Left then
		Left = Enum.HorizontalAlignment.Left
	elseif v12.alignment == NavigationBarAlignment.EvenlyDistributed then
		SpaceAround = Enum.UIFlexAlignment.SpaceAround
		Left = Enum.HorizontalAlignment.Center
	else
		error("NavigationBar Alignment type is incorrect!")
	end

	local v22 = React.useCallback(function(p1) -- line: 96
		-- upvalues: v12 (copy), v15 (copy)
		if v12.visibility or v12.animated then
			v15(p1.AbsoluteSize.Y)
		end
	end, {
		v12.visibility,
		v12.animated
	})
	local v23, v24 = ReactOtter.useAnimatedBinding(0)

	React.useEffect(function() -- line: 102
		-- upvalues: v12 (copy), v24 (copy), ReactOtter (copy), v14 (copy)
		if not v12.visibility and v12.animated then
			if v12.isVisible then
				v24(ReactOtter.spring(0, v12.animationConfig))
			else
				v24(ReactOtter.spring(v14, v12.animationConfig))
			end
		end

		return nil
	end, {
		v12.visibility,
		v12.animated,
		v12.isVisible,
		v14,
		v12.animationConfig
	})

	local t3 = {
		Constraint = if v12.maxWidth == nil then nil else React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(v12.maxWidth, 1e999)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v16),
			PaddingBottom = UDim.new(0, v17),
			PaddingLeft = UDim.new(0, v18),
			PaddingRight = UDim.new(0, v19)
		}),
		Layout = React.createElement("UIListLayout", {
			Padding = v12.spacing,
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = SpaceAround,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})
	}

	for i, v in ipairs(v12.items) do
		local v28 = i == v12.selection

		t3[tostring(i)] = v12.renderItem(v, v28)
	end

	local v29 = if not v12.visibility then v23:map(function(n1: number) -- line: 144
		return UDim2.new(0, 0, 0, (math.floor(n1 + 0.5)))
	end) else v12.visibility:map(function(n2: number) -- line: 140
		-- upvalues: v14 (copy)
		local v32 = (1 - n2) * v14

		return UDim2.new(0, 0, 0, (math.floor(v32 + 0.5)))
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = v12.clipsDescendants,
		Size = v12.size,
		AutomaticSize = v12.automaticSize,
		Position = v12.position,
		Visible = v12.visible,
		[React.Change.AbsoluteSize] = v22
	}, {
		AnimatedFrame = React.createElement("Frame", {
			BorderSizePixel = 0,
			Selectable = false,
			Active = v12.active,
			Position = v29,
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = v12.automaticSize,
			BackgroundColor3 = if not v12.backgroundColor then v13.Theme.NavigationBar.Color else v12.backgroundColor.Color,
			BackgroundTransparency = if not v12.backgroundColor then v13.Theme.NavigationBar.Transparency else v12.backgroundColor.Transparency,
			Visible = v12.visible,
			ZIndex = v12.zIndex
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Left
			}),
			InnerFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AutomaticSize = v12.automaticSize
			}, t3)
		})
	})
end

return NavigationBar
