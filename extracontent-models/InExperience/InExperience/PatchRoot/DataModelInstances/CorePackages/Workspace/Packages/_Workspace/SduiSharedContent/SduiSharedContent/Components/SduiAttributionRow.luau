local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local Image = Foundation.Image
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAttributionRowV2 = SharedFlags.FFlagSduiAttributionRowV2
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function SduiAttributionRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position
	local size = props.size

	local v = useTokens()

	local titleMedium = v.Typography.TitleMedium
	local bodyMedium = v.Typography.BodyMedium

	if FFlagSduiAttributionRowV2 then
		local titleFontStyle = props.titleFontStyle or titleMedium
		local subtitleFontStyle = props.subtitleFontStyle or bodyMedium

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
	else
		local createElement = React.createElement
		local v2 = {
			Size = UDim2.new(1, 0, 0, v.Size.Size_1000),
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = layoutOrder,
			ZIndex = zIndex,
			Position = position,
			[React.Event.Activated] = props.onActivated,
			Text = "",
			Active = props.onActivated ~= nil,
			Selectable = false
		}

		local tag = React.Tag
		local v3

		if props.testId then
			v3 = `data-testid={props.testId}`
		end

		v2[tag] = v3
		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v.Gap.Medium),
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				ItemLineAlignment = Enum.ItemLineAlignment.Start
			}),
			Image = React.createElement("ImageLabel", {
				Image = props.image,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, v.Size.Size_1000, 0, v.Size.Size_1000),
				LayoutOrder = 1
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v.Radius.Medium)
				})
			}),
			TextContainer = 0,
			ButtonContainer = 0
		}

		local createElement2 = React.createElement
		local v4 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2
		}

		local children2 = {
			UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
			Title = 0,
			Subtitle = 0
		}

		local createElement3 = React.createElement
		local v5 = {
			Text = props.title,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, v.Size.Size_500),
			TextSize = titleMedium.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = titleMedium.Font
		end

		v5.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(titleMedium.Font)
		end

		v5.FontFace = fontFace
		v5.TextColor3 = v.DarkMode.Content.Emphasis.Color3

		v5.TextXAlignment = Enum.TextXAlignment.Left
		v5.TextTruncate = Enum.TextTruncate.SplitWord
		children2.Title = createElement3("TextLabel", v5)

		local createElement4 = React.createElement
		local v6 = {
			Text = props.subtitle,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, v.Size.Size_500),
			TextSize = bodyMedium.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = bodyMedium.Font
		end

		v6.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(bodyMedium.Font)
		end

		v6.FontFace = fontFace2
		v6.TextColor3 = v.DarkMode.Content.Emphasis.Color3

		v6.TextXAlignment = Enum.TextXAlignment.Left
		v6.TextTruncate = Enum.TextTruncate.SplitWord
		children2.Subtitle = createElement4("TextLabel", v6)
		children.TextContainer = createElement2("Frame", v4, children2)

		children.ButtonContainer = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 3
			},
			{ ButtonContent = props.rightButtonContent }
		)
		return createElement("TextButton", v2, children)
	end
end

return React.memo(SduiAttributionRow)
