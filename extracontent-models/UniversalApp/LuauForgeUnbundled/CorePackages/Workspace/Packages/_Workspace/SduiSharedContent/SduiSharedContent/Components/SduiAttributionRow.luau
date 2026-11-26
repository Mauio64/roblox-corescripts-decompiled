local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local view = Foundation.View
local icon = Foundation.Icon
local image = Foundation.Image
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function SduiAttributionRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position
	local size = props.size

	local v5 = useTokens()

	local titleFontStyle = props.titleFontStyle or v5.Typography.TitleMedium
	local subtitleFontStyle = props.subtitleFontStyle or v5.Typography.BodyMedium

	local createElement = React.createElement
	local v7 = {
		tag = "row size-full-0 auto-y align-y-center align-x-left gap-medium",
		ZIndex = zIndex,
		Position = position,
		LayoutOrder = layoutOrder,
		Active = props.onActivated ~= nil,
		onActivated = props.onActivated,
		selection = { Selectable = false },
		Size = size or UDim2.new(1, 0, 0, v5.Size.Size_1000),
		testId = props.testId,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	}

	local v8 = {
		Image = props.image and React.createElement(image, {
			tag = "radius-medium",
			Image = props.image,
			Size = props.imageSize or UDim2.new(0, v5.Size.Size_1000, 0, v5.Size.Size_1000),
			LayoutOrder = 1
		}),
		TextContainer = 0,
		RightButtonContent = 0
	}

	local createElement2 = React.createElement

	local v11 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			TextWrapped = props.titleTextWrap,
			TextTruncate = props.titleTextTruncate or Enum.TextTruncate.SplitWord,
			textStyle = props.titleTextColor or v5.DarkMode.Content.Emphasis,
			fontStyle = props.titleFontStyle or titleFontStyle,
			tag = "auto-xy text-align-x-left",
			Size = props.textContainerSize or UDim2.new(1, 0, 0, v5.Size.Size_500)
		}),
		SubtitleContainer = 0,
		Caption = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		LayoutOrder = 2,
		Size = props.textContainerSize or UDim2.new(1, 0, 0, v5.Size.Size_500),
		onActivated = props.subtitleOnActivated,
		tag = {
			["row size-full-0 auto-y"] = true,
			["align-y-center gap-xsmall"] = props.subtitleIconName ~= nil
		}
	}

	local v14 = {
		Subtitle = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.subtitle,
			onActivated = props.subtitleOnActivated,
			fontStyle = props.subtitleFontStyle or subtitleFontStyle,
			textStyle = props.subtitleTextColor or v5.DarkMode.Content.Emphasis,
			TextWrapped = props.subtitleTextWrap,
			TextTruncate = props.subtitleTextTruncate or Enum.TextTruncate.SplitWord,
			tag = "auto-xy text-align-x-left"
		}),
		Icon = 0
	}
	local v15

	if props.subtitleIconName and props.subtitleBackgroundIconName then
		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local v20 = if props.subtitleIconSize then props.subtitleIconSize else nil
		local v19 = { size = v20, name = props.subtitleBackgroundIconName, style = 0 }
		local v21 = if props.subtitleBackgroundIconStyle then props.subtitleBackgroundIconStyle else v5.Color.System.Emphasis
		v19.style = v21
		local children = {
			BackgroundIcon = createElement5(icon, v19),
			ForegroundIcon = 0
		}

		local createElement6 = React.createElement
		local v24 = if props.subtitleIconSize then props.subtitleIconSize else nil
		local v25 = if props.subtitleIconVariant then props.subtitleIconVariant else nil
		children.ForegroundIcon = createElement6(icon, {
			size = v24,
			variant = v25,
			name = props.subtitleIconName,
			style = props.subtitleIconStyle
		})
		v15 = createElement4(view, { LayoutOrder = 2, tag = "auto-xy" }, children)
	elseif props.subtitleIconName then
		local createElement4 = React.createElement

		local v18 = if props.subtitleIconSize then props.subtitleIconSize else nil
		local v17 = {
			LayoutOrder = 2,
			size = v18,
			name = props.subtitleIconName,
			variant = 0,
			style = 0
		}
		local v19 = if props.subtitleIconVariant then props.subtitleIconVariant else nil
		v17.variant = v19
		local v20 = if props.subtitleIconStyle then props.subtitleIconStyle else v5.Color.System.Emphasis
		v17.style = v20
		v15 = createElement4(icon, v17)
	end

	v14.Icon = v15
	v11.SubtitleContainer = createElement3(view, v13, v14)

	local v16 = if props.caption then React.createElement(text, {
		LayoutOrder = 3,
		Text = props.caption,
		textStyle = props.captionTextColor or v5.Color.Content.Default,
		fontStyle = props.captionFontStyle or v5.Typography.CaptionBody,
		tag = "auto-xy text-align-x-left text-truncate-split-word",
		Size = props.textContainerSize
	}) else nil
	v11.Caption = v16
	v8.TextContainer = createElement2(view, {
		LayoutOrder = 2,
		tag = "col auto-xy fill"
	}, v11)

	v8.RightButtonContent = props.rightButtonContent
		and React.createElement(view, { LayoutOrder = 3, tag = "auto-xy row" }, {
			ButtonContent = props.rightButtonContent
		})
	return createElement(view, v7, v8)
end

return React.memo(SduiAttributionRow)
