local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function ItemCardAnimationStateIndicator(props)
	local v5 = useTokens()

	local children = {
		TabsLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = UDim.new(0, v5.Gap.XSmall)
		})
	}
	local text = nil

	for k, state in props.states do
		local v6 = if state.isSelected then v5.Color.Stroke.Emphasis else v5.Color.Stroke.Muted
		children[`{k}-{state.text}`] = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = v6.Color3,
			Transparency = v6.Transparency,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_150),
			LayoutOrder = k
		})

		if state.isSelected then
			text = state.text
		end
	end

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ZIndex = props.ZIndex
	}
	local v8 = {
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

	local v9 = if props.paddingTop or props.paddingBottom or props.paddingLeft or props.paddingRight then React.createElement("UIPadding", {
		PaddingTop = props.paddingTop,
		PaddingBottom = props.paddingBottom,
		PaddingLeft = props.paddingLeft,
		PaddingRight = props.paddingRight
	}) else nil
	v8.Padding = v9

	v8.Tabs = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}, children)
	local v10

	if text then
		local createElement2 = React.createElement
		local v12 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			Text = text,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 2
		}

		local v13 = if not foundationFontFaceMigration then v5.Typography.TitleLarge.Font else nil
		v12.Font = v13

		local v14 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
		v12.FontFace = v14

		v12.TextSize = v5.Typography.TitleLarge.FontSize
		v12.TextColor3 = v5.Color.Content.Emphasis.Color3
		v12.TextTruncate = Enum.TextTruncate.AtEnd
		v12.TextXAlignment = Enum.TextXAlignment.Left
		v12.TextYAlignment = Enum.TextYAlignment.Top
		v10 = createElement2("TextLabel", v12)
	end

	v8.Label = v10
	return createElement("Frame", v7, v8)
end

return ItemCardAnimationStateIndicator
