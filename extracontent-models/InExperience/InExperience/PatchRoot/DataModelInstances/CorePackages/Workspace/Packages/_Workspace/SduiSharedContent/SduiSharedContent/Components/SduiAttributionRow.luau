local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Image = Foundation.Image
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function SduiAttributionRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position
	local size = props.size

	local v = useTokens()

	local titleFontStyle = props.titleFontStyle or v.Typography.TitleMedium
	local subtitleFontStyle = props.subtitleFontStyle or v.Typography.BodyMedium

	local createElement = React.createElement
	local v2 = {
		tag = "row size-full-0 auto-y align-y-center align-x-left gap-medium",
		ZIndex = zIndex,
		Position = position,
		LayoutOrder = layoutOrder,
		Active = props.onActivated ~= nil,
		onActivated = props.onActivated,
		selection = { Selectable = false },
		Size = size or UDim2.new(1, 0, 0, v.Size.Size_1000),
		testId = props.testId,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}

	local v3 = {
		Image = props.image and React.createElement(Image, {
			tag = "radius-medium",
			Image = props.image,
			Size = props.imageSize or UDim2.new(0, v.Size.Size_1000, 0, v.Size.Size_1000),
			LayoutOrder = 1
		}),
		TextContainer = 0,
		RightButtonContent = 0
	}

	local createElement2 = React.createElement

	local v4 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			TextWrapped = props.titleTextWrap,
			TextTruncate = props.titleTextTruncate or Enum.TextTruncate.SplitWord,
			textStyle = props.titleTextColor or v.DarkMode.Content.Emphasis,
			fontStyle = props.titleFontStyle or titleFontStyle,
			tag = "auto-xy text-align-x-left",
			Size = props.textContainerSize or UDim2.new(1, 0, 0, v.Size.Size_500)
		}),
		SubtitleContainer = 0,
		Caption = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		LayoutOrder = 2,
		Size = props.textContainerSize or UDim2.new(1, 0, 0, v.Size.Size_500),
		onActivated = props.subtitleOnActivated,
		tag = {
			["row size-full-0 auto-y"] = true,
			["align-y-center gap-xsmall"] = props.subtitleIconName ~= nil
		}
	}

	local v6 = {
		Subtitle = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.subtitle,
			onActivated = props.subtitleOnActivated,
			fontStyle = props.subtitleFontStyle or subtitleFontStyle,
			textStyle = props.subtitleTextColor or v.DarkMode.Content.Emphasis,
			TextWrapped = props.subtitleTextWrap,
			TextTruncate = props.subtitleTextTruncate or Enum.TextTruncate.SplitWord,
			tag = "auto-xy text-align-x-left"
		}),
		Icon = 0
	}
	local icon

	if props.subtitleIconName and props.subtitleBackgroundIconName then
		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local size2

		if props.subtitleIconSize then
			size2 = props.subtitleIconSize
		end

		local v7 = { size = size2, name = props.subtitleBackgroundIconName, style = 0 }
		local style

		if props.subtitleBackgroundIconStyle then
			style = props.subtitleBackgroundIconStyle
		else
			style = v.Color.System.Emphasis
		end

		v7.style = style
		local children = { BackgroundIcon = createElement5(Icon, v7), ForegroundIcon = 0 }

		local createElement6 = React.createElement
		local size3

		if props.subtitleIconSize then
			size3 = props.subtitleIconSize
		end

		local variant

		if props.subtitleIconVariant then
			variant = props.subtitleIconVariant
		end

		children.ForegroundIcon = createElement6(Icon, {
			size = size3,
			variant = variant,
			name = props.subtitleIconName,
			style = props.subtitleIconStyle
		})
		icon = createElement4(View, { LayoutOrder = 2, tag = "auto-xy" }, children)
	elseif props.subtitleIconName then
		local createElement4 = React.createElement
		local size2

		if props.subtitleIconSize then
			size2 = props.subtitleIconSize
		end

		local v7 = {
			LayoutOrder = 2,
			size = size2,
			name = props.subtitleIconName,
			variant = 0,
			style = 0
		}
		local variant

		if props.subtitleIconVariant then
			variant = props.subtitleIconVariant
		end

		v7.variant = variant
		local style

		if props.subtitleIconStyle then
			style = props.subtitleIconStyle
		else
			style = v.Color.System.Emphasis
		end

		v7.style = style
		icon = createElement4(Icon, v7)
	end

	v6.Icon = icon
	v4.SubtitleContainer = createElement3(View, v5, v6)
	local caption

	if props.caption then
		caption = React.createElement(Text, {
			LayoutOrder = 3,
			Text = props.caption,
			textStyle = props.captionTextColor or v.Color.Content.Default,
			fontStyle = props.captionFontStyle or v.Typography.CaptionBody,
			tag = "auto-xy text-align-x-left text-truncate-split-word",
			Size = props.textContainerSize
		})
	end

	v4.Caption = caption
	v3.TextContainer = createElement2(View, { LayoutOrder = 2, tag = "col auto-xy fill" }, v4)

	v3.RightButtonContent = props.rightButtonContent
		and React.createElement(View, { LayoutOrder = 3, tag = "auto-xy row" }, {
			ButtonContent = props.rightButtonContent
		})
	return createElement(View, v2, v3)
end

return React.memo(SduiAttributionRow)
