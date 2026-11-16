local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local Cryo = require(parent3.Cryo)
local React = require(parent3.React)
local ReactOtter = require(parent3.ReactOtter)
require(parent.Style.StyleTypes)
local useStyle = require(parent2.Core.Style.useStyle)
local NavigationBarAlignment = require(parent.Navigation.Enum.NavigationBarAlignment)

local v = {
	visible = true,
	zIndex = 1,
	animated = false,
	maxWidth = 600,
	animationConfig = { dampingRatio = 1, frequency = 3 }
}

local function NavigationBar(p)
	assert(#p.items > 0, "At least one item should be present!")
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
	local state, setState = React.useState(not joined.size and 0 or joined.size.Y.Offset)
	local v3

	if joined.paddings and joined.paddings.Top then
		v3 = joined.paddings.Top
	else
		v3 = v2.Tokens.Size.Size_150
	end

	local v4

	if joined.paddings and joined.paddings.Bottom then
		v4 = joined.paddings.Bottom
	else
		v4 = v2.Tokens.Size.Size_150
	end

	local v5

	if joined.paddings and joined.paddings.Left then
		v5 = joined.paddings.Left
	else
		v5 = v2.Tokens.Size.Size_150
	end

	local v6

	if joined.paddings and joined.paddings.Right then
		v6 = joined.paddings.Right
	else
		v6 = v2.Tokens.Size.Size_150
	end

	local horizontalAlignment = nil
	local spaceAround = nil

	if joined.alignment == NavigationBarAlignment.Left then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	elseif joined.alignment == NavigationBarAlignment.EvenlyDistributed then
		spaceAround = Enum.UIFlexAlignment.SpaceAround
		horizontalAlignment = Enum.HorizontalAlignment.Center
	else
		error("NavigationBar Alignment type is incorrect!")
	end

	local v7 = React.useCallback(function(p2)
		if joined.visibility or joined.animated then
			setState(p2.AbsoluteSize.Y)
		end
	end, { joined.visibility, joined.animated })
	local v8, v9 = ReactOtter.useAnimatedBinding(0)
	React.useEffect(function(): nil
		if not joined.visibility and joined.animated then
			if joined.isVisible then
				v9(ReactOtter.spring(0, joined.animationConfig))
			else
				v9(ReactOtter.spring(state, joined.animationConfig))
			end
		end

		return nil
	end, { joined.visibility, joined.animated, joined.isVisible, state, joined.animationConfig })
	local constraint

	if joined.maxWidth ~= nil then
		constraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(joined.maxWidth, 1e999)
		})
	end

	local children = {
		Constraint = constraint,
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v3),
			PaddingBottom = UDim.new(0, v4),
			PaddingLeft = UDim.new(0, v5),
			PaddingRight = UDim.new(0, v6)
		}),
		Layout = React.createElement("UIListLayout", {
			Padding = joined.spacing,
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalFlex = spaceAround,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		})
	}

	for i, item in ipairs(joined.items) do
		local v10 = i == joined.selection
		children[tostring(i)] = joined.renderItem(item, v10)
	end

	local position

	if joined.visibility then
		position = joined.visibility:map(function(p2: number)
			local v10 = (1 - p2) * state
			return UDim2.new(0, 0, 0, (math.floor(v10 + 0.5)))
		end)
	else
		position = v8:map(function(p2: number)
			return UDim2.new(0, 0, 0, (math.floor(p2 + 0.5)))
		end)
	end

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		ClipsDescendants = joined.clipsDescendants,
		Size = joined.size,
		AutomaticSize = joined.automaticSize,
		Position = joined.position,
		Visible = joined.visible,
		[React.Change.AbsoluteSize] = v7
	}

	local createElement2 = React.createElement
	local v11 = {
		Active = joined.active,
		Position = position,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = joined.automaticSize,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		Selectable = false,
		Visible = 0,
		ZIndex = 0
	}
	local backgroundColor

	if joined.backgroundColor then
		backgroundColor = joined.backgroundColor.Color
	else
		backgroundColor = v2.Theme.NavigationBar.Color
	end

	v11.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if joined.backgroundColor then
		backgroundTransparency = joined.backgroundColor.Transparency
	else
		backgroundTransparency = v2.Theme.NavigationBar.Transparency
	end

	v11.BackgroundTransparency = backgroundTransparency

	v11.Visible = joined.visible
	v11.ZIndex = joined.zIndex
	return createElement("Frame", v10, {
		AnimatedFrame = createElement2("Frame", v11, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = horizontalAlignment
			}),
			InnerFrame = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = joined.automaticSize
				},
				children
			)
		})
	})
end

return NavigationBar
