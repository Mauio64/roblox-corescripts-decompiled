local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local view = Foundation.View
local icon = Foundation.Icon
local image = Foundation.Image
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local fFlagSduiAttributionRowV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiAttributionRowV2
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function SduiAttributionRow(props)
	local layoutOrder = props.layoutOrder
	local zIndex = props.zIndex
	local position = props.position
	local size = props.size

	local v5 = useTokens()

	local titleMedium = v5.Typography.TitleMedium
	local bodyMedium = v5.Typography.BodyMedium

	if fFlagSduiAttributionRowV2 then
		local titleFontStyle = props.titleFontStyle or titleMedium
		local subtitleFontStyle = props.subtitleFontStyle or bodyMedium

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
			local v19 = {
				size = v20,
				name = props.subtitleBackgroundIconName,
				style = 0
			}
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
	else
		local createElement = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 0, v5.Size.Size_1000),
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
		local v8 = if props.testId then `data-testid={props.testId}` else nil
		v7[tag] = v8
		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, v5.Gap.Medium),
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
				Size = UDim2.new(0, v5.Size.Size_1000, 0, v5.Size.Size_1000),
				LayoutOrder = 1
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Medium)
				})
			}),
			TextContainer = 0,
			ButtonContainer = 0
		}

		local createElement2 = React.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2
		}

		local children2 = {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Title = 0,
			Subtitle = 0
		}

		local createElement3 = React.createElement
		local v12 = {
			Text = props.title,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, v5.Size.Size_500),
			TextSize = titleMedium.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local v13 = if not foundationFontFaceMigration then titleMedium.Font else nil
		v12.Font = v13
		local v14 = if foundationFontFaceMigration then normalizeFontFace(titleMedium.Font) else nil
		v12.FontFace = v14
		v12.TextColor3 = v5.DarkMode.Content.Emphasis.Color3

		v12.TextXAlignment = Enum.TextXAlignment.Left
		v12.TextTruncate = Enum.TextTruncate.SplitWord
		children2.Title = createElement3("TextLabel", v12)

		local createElement4 = React.createElement
		local v16 = {
			Text = props.subtitle,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, v5.Size.Size_500),
			TextSize = bodyMedium.FontSize,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0,
			BackgroundTransparency = 1,
			TextXAlignment = 0,
			TextTruncate = 0
		}
		local v17 = if not foundationFontFaceMigration then bodyMedium.Font else nil
		v16.Font = v17
		local v18 = if foundationFontFaceMigration then normalizeFontFace(bodyMedium.Font) else nil
		v16.FontFace = v18
		v16.TextColor3 = v5.DarkMode.Content.Emphasis.Color3

		v16.TextXAlignment = Enum.TextXAlignment.Left
		v16.TextTruncate = Enum.TextTruncate.SplitWord
		children2.Subtitle = createElement4("TextLabel", v16)
		children.TextContainer = createElement2("Frame", v10, children2)

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
		return createElement("TextButton", v7, children)
	end
end

return React.memo(SduiAttributionRow)
