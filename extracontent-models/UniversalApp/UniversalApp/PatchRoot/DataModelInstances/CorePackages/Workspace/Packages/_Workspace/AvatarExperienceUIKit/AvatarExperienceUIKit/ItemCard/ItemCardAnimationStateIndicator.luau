local Parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent
local React = require(Parent.React)
local useTokens = require(Parent.Foundation).Hooks.useTokens

local function ItemCardAnimationStateIndicator(t1: {[any]: any}) -- line: 23
	-- upvalues: useTokens (copy), React (copy)
	local v6 = useTokens()
	local t2 = {
		TabsLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, v6.Gap.XSmall)
		})
	}
	local text = nil

	for v9, v10 in t1.states do
		local v11 = if not v10.isSelected then v6.Color.Stroke.Muted else v6.Color.Stroke.Emphasis

		t2[`{ v9 }-{ v10.text }`] = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v11.Color3,
			Transparency = v11.Transparency,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_150),
			LayoutOrder = v9
		})

		if v10.isSelected then
			text = v10.text
		end
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = t1.ZIndex
	}, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		Padding = if not t1.paddingTop and (not t1.paddingBottom and (not t1.paddingLeft and not t1.paddingRight)) then nil else React.createElement("UIPadding", {
			PaddingTop = t1.paddingTop,
			PaddingBottom = t1.paddingBottom,
			PaddingLeft = t1.paddingLeft,
			PaddingRight = t1.paddingRight
		}),
		Tabs = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, t2),
		Label = if not text then nil else React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0),
			Text = text,
			Font = v6.Typography.TitleLarge.Font,
			TextSize = v6.Typography.TitleLarge.FontSize,
			TextColor3 = v6.Color.Content.Emphasis.Color3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
	})
end

return ItemCardAnimationStateIndicator
