local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)
local React = require(ParentParentParentParent.React)
local ReactOtter = require(ParentParentParentParent.ReactOtter)

require(ParentParent.Style.StyleTypes)

local useStyle = require(ParentParentParent.Core.Style.useStyle)
local NavigationRailAlignment = require(ParentParent.Navigation.Enum.NavigationRailAlignment)
local t1 = {
	visible = true,
	isVisible = true,
	zIndex = 1,
	animated = false,
	animationConfig = {
		dampingRatio = 1,
		frequency = 3
	}
}

local function NavigationRail(t2: {[any]: any}) -- line: 64
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), NavigationRailAlignment (copy), React (copy), ReactOtter (copy)
	assert(#t2.items > 0, "At least one item should be present!")

	local v12 = Cryo.Dictionary.join(t1, t2)
	local v13 = useStyle()
	local v14 = if not v12.paddings or not v12.paddings.Top then v13.Tokens.Global.Space_75 else v12.paddings.Top
	local v15 = if not v12.paddings or not v12.paddings.Bottom then v13.Tokens.Global.Space_75 else v12.paddings.Bottom
	local v16 = if not v12.paddings or not v12.paddings.Left then v13.Tokens.Global.Space_75 else v12.paddings.Left
	local v17 = if not v12.paddings or not v12.paddings.Right then v13.Tokens.Global.Space_75 else v12.paddings.Right
	local Top = nil

	if v12.alignment == NavigationRailAlignment.Justified then
		Top = Enum.VerticalAlignment.Top
	elseif v12.alignment == NavigationRailAlignment.Centered then
		Top = Enum.VerticalAlignment.Center
	else
		error("NavigationRail alignment type is incorrect!")
	end

	local v19, v20 = React.useState(not v12.size and 0 or v12.size.X.Offset)
	local v21 = React.useCallback(function(p1) -- line: 90
		-- upvalues: v12 (copy), v20 (copy)
		if v12.animated then
			v20(p1.AbsoluteSize.X)
		end
	end, { v12.animated })
	local v22, v23 = ReactOtter.useAnimatedBinding((not v12.animated or v12.isVisible) and 0 or -v19)

	React.useEffect(function() -- line: 97
		-- upvalues: v12 (copy), v23 (copy), ReactOtter (copy), v19 (copy)
		if v12.animated then
			if v12.isVisible then
				v23(ReactOtter.spring(0, v12.animationConfig))
			else
				v23(ReactOtter.spring(-v19, v12.animationConfig))
			end
		end

		return nil
	end, {
		v12.animated,
		v12.isVisible,
		v19,
		v12.animationConfig
	})

	local t3 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = v12.spacing,
			SortOrder = Enum.SortOrder.Name
		})
	}
	local t4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = v12.spacing,
			SortOrder = Enum.SortOrder.Name
		})
	}
	local v26 = false

	for i, v in ipairs(v12.items) do
		local v29 = i == v12.selection

		if v.isSecondary then
			v26 = true
			t4[tostring(i)] = v12.renderItem(v, v29)
		else
			t3[tostring(i)] = v12.renderItem(v, v29)
		end
	end

	local v30 = v22:map(function(n1: number) -- line: 136
		return UDim2.new(0, math.floor(n1 + 0.5), 0, 0)
	end)

	if v12.leadingComponent then
		t3["0"] = v12.leadingComponent
	end

	if v12.trailingComponent then
		t3[":"] = v12.trailingComponent
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = v12.clipsDescendants,
		Size = v12.size,
		Position = v12.position,
		Visible = v12.visible,
		ZIndex = v12.zIndex,
		[React.Change.AbsoluteSize] = v21
	}, {
		AnimatedFrame = React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = v30,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = if not v12.backgroundColor then v13.Theme.NavigationBar.Color else v12.backgroundColor.Color,
			BackgroundTransparency = if not v12.backgroundColor then v13.Theme.NavigationBar.Transparency else v12.backgroundColor.Transparency
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v14),
				PaddingBottom = UDim.new(0, v15),
				PaddingLeft = UDim.new(0, v16),
				PaddingRight = UDim.new(0, v17)
			}),
			MainFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Top,
					Padding = UDim.new(0, v13.Tokens.Global.Space_200)
				}),
				PrimaryItems = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, t3),
				CenteredSecondaryItems = if not v26 or v12.alignment ~= NavigationRailAlignment.Centered then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, t4)
			}),
			JustifiedSecondaryItems = if not v26 or v12.alignment ~= NavigationRailAlignment.Justified then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, t4)
		})
	})
end

return NavigationRail
