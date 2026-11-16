local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local Cryo = require(parent3.Cryo)
local React = require(parent3.React)
local ReactOtter = require(parent3.ReactOtter)
require(parent.Style.StyleTypes)
local useStyle = require(parent2.Core.Style.useStyle)
local NavigationRailAlignment = require(parent.Navigation.Enum.NavigationRailAlignment)

local v = {
	visible = true,
	isVisible = true,
	zIndex = 1,
	animated = false,
	animationConfig = { dampingRatio = 1, frequency = 3 }
}

local function NavigationRail(p)
	assert(#p.items > 0, "At least one item should be present!")
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useStyle()
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

	local verticalAlignment = nil

	if joined.alignment == NavigationRailAlignment.Justified then
		verticalAlignment = Enum.VerticalAlignment.Top
	elseif joined.alignment == NavigationRailAlignment.Centered then
		verticalAlignment = Enum.VerticalAlignment.Center
	else
		error("NavigationRail alignment type is incorrect!")
	end

	local state, setState = React.useState(not joined.size and 0 or joined.size.X.Offset)
	local v7 = React.useCallback(function(p2)
		if joined.animated then
			setState(p2.AbsoluteSize.X)
		end
	end, { joined.animated })

	local v8, v9 = ReactOtter.useAnimatedBinding((not joined.animated or joined.isVisible) and 0 or -state)
	React.useEffect(function(): nil
		if joined.animated then
			if joined.isVisible then
				v9(ReactOtter.spring(0, joined.animationConfig))
			else
				v9(ReactOtter.spring(-state, joined.animationConfig))
			end
		end

		return nil
	end, { joined.animated, joined.isVisible, state, joined.animationConfig })

	local v10 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = joined.spacing,
			SortOrder = Enum.SortOrder.Name
		})
	}

	local v11 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = joined.spacing,
			SortOrder = Enum.SortOrder.Name
		})
	}
	local v12 = false

	for i, item in ipairs(joined.items) do
		local v13 = i == joined.selection

		if item.isSecondary then
			v11[tostring(i)] = joined.renderItem(item, v13)
			v12 = true
		else
			v10[tostring(i)] = joined.renderItem(item, v13)
		end
	end

	local mapped = v8:map(function(p2: number)
		return UDim2.new(0, math.floor(p2 + 0.5), 0, 0)
	end)

	if joined.leadingComponent then
		v10["0"] = joined.leadingComponent
	end

	if joined.trailingComponent then
		v10[":"] = joined.trailingComponent
	end

	local createElement = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		ClipsDescendants = joined.clipsDescendants,
		Size = joined.size,
		Position = joined.position,
		Visible = joined.visible,
		ZIndex = joined.zIndex,
		[React.Change.AbsoluteSize] = v7
	}

	local createElement2 = React.createElement
	local v14 = {
		Position = mapped,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = 0,
		BackgroundTransparency = 0
	}
	local backgroundColor

	if joined.backgroundColor then
		backgroundColor = joined.backgroundColor.Color
	else
		backgroundColor = v2.Theme.NavigationBar.Color
	end

	v14.BackgroundColor3 = backgroundColor
	local backgroundTransparency

	if joined.backgroundColor then
		backgroundTransparency = joined.backgroundColor.Transparency
	else
		backgroundTransparency = v2.Theme.NavigationBar.Transparency
	end

	v14.BackgroundTransparency = backgroundTransparency

	local v15 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v3),
			PaddingBottom = UDim.new(0, v4),
			PaddingLeft = UDim.new(0, v5),
			PaddingRight = UDim.new(0, v6)
		}),
		MainFrame = 0,
		JustifiedSecondaryItems = 0
	}

	local createElement3 = React.createElement
	local v16 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local v17 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = verticalAlignment,
			Padding = UDim.new(0, v2.Tokens.Size.Size_400)
		}),
		PrimaryItems = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			v10
		),
		CenteredSecondaryItems = 0
	}
	local centeredSecondaryItems

	if v12 and joined.alignment == NavigationRailAlignment.Centered then
		centeredSecondaryItems = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			},
			v11
		)
	end

	v17.CenteredSecondaryItems = centeredSecondaryItems
	v15.MainFrame = createElement3("Frame", v16, v17)
	local justifiedSecondaryItems

	if v12 and joined.alignment == NavigationRailAlignment.Justified then
		justifiedSecondaryItems = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
			v11
		)
	end

	v15.JustifiedSecondaryItems = justifiedSecondaryItems
	return createElement("Frame", v13, {
		AnimatedFrame = createElement2("Frame", v14, v15)
	})
end

return NavigationRail
