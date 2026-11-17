local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local function ItemCardAnimationStateIndicator(props)
	local v = useTokens()

	local children = {
		TabsLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, v.Gap.XSmall)
		})
	}
	local text = nil

	for k, state in props.states do
		local v2

		if state.isSelected then
			v2 = v.Color.Stroke.Emphasis
		else
			v2 = v.Color.Stroke.Muted
		end

		children[`{k}-{state.text}`] = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v2.Color3,
			Transparency = v2.Transparency,
			Size = UDim2.new(1, 0, 0, v.Size.Size_150),
			LayoutOrder = k
		})

		if state.isSelected then
			text = state.text
		end
	end

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = props.ZIndex
	}
	local v3 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		Padding = 0,
		Tabs = 0,
		Label = 0
	}
	local padding

	if props.paddingTop or props.paddingBottom or props.paddingLeft or props.paddingRight then
		padding = React.createElement("UIPadding", {
			PaddingTop = props.paddingTop,
			PaddingBottom = props.paddingBottom,
			PaddingLeft = props.paddingLeft,
			PaddingRight = props.paddingRight
		})
	end

	v3.Padding = padding

	v3.Tabs = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}, children)
	local label

	if text then
		label = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			Text = text,
			FontFace = normalizeFontFace(v.Typography.TitleLarge.Font),
			TextSize = v.Typography.TitleLarge.FontSize,
			TextColor3 = v.Color.Content.Emphasis.Color3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			LayoutOrder = 2
		})
	end

	v3.Label = label
	return createElement("Frame", v2, v3)
end

return ItemCardAnimationStateIndicator
