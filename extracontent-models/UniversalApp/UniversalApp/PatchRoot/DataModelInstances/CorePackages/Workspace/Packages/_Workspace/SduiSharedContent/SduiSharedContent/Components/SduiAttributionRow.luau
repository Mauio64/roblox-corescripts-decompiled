local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Icon = Foundation.Icon
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local FFlagSduiAttributionRowV2 = require(Parent.SharedFlags).FFlagSduiAttributionRowV2

local function SduiAttributionRow(t1: {[any]: any}) -- line: 58
	-- upvalues: useTokens (copy), FFlagSduiAttributionRowV2 (copy), React (copy), View (copy), Foundation (copy), FoundationImage (copy), FoundationText (copy), Icon (copy)
	local layoutOrder = t1.layoutOrder
	local zIndex = t1.zIndex
	local position = t1.position
	local size = t1.size
	local v16 = useTokens()
	local TitleMedium = v16.Typography.TitleMedium
	local BodyMedium = v16.Typography.BodyMedium

	if FFlagSduiAttributionRowV2 then
		local v19 = t1.titleFontStyle or TitleMedium
		local v20 = t1.subtitleFontStyle or BodyMedium

		return React.createElement(View, {
			tag = "row size-full-0 auto-y align-y-center align-x-left gap-medium",
			ZIndex = zIndex,
			Position = position,
			LayoutOrder = layoutOrder,
			Active = t1.onActivated ~= nil,
			onActivated = t1.onActivated,
			selection = {
				Selectable = false
			},
			Size = size or UDim2.new(1, 0, 0, v16.Size.Size_1000),
			testId = t1.testId,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			Image = t1.image and React.createElement(FoundationImage, {
				tag = "radius-medium",
				LayoutOrder = 1,
				Image = t1.image,
				Size = t1.imageSize or UDim2.new(0, v16.Size.Size_1000, 0, v16.Size.Size_1000)
			}),
			TextContainer = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col auto-xy fill"
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-align-x-left",
					Text = t1.title,
					TextWrapped = t1.titleTextWrap,
					TextTruncate = t1.titleTextTruncate or Enum.TextTruncate.SplitWord,
					textStyle = t1.titleTextColor or v16.DarkMode.Content.Emphasis,
					fontStyle = t1.titleFontStyle or v19,
					Size = t1.textContainerSize or UDim2.new(1, 0, 0, v16.Size.Size_500)
				}),
				SubtitleContainer = React.createElement(View, {
					LayoutOrder = 2,
					Size = t1.textContainerSize or UDim2.new(1, 0, 0, v16.Size.Size_500),
					onActivated = t1.subtitleOnActivated,
					tag = {
						["row size-full-0 auto-y"] = true,
						["align-y-center gap-xsmall"] = t1.subtitleIconName ~= nil
					}
				}, {
					Subtitle = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = "auto-xy text-align-x-left",
						Text = t1.subtitle,
						onActivated = t1.subtitleOnActivated,
						fontStyle = t1.subtitleFontStyle or v20,
						textStyle = t1.subtitleTextColor or v16.DarkMode.Content.Emphasis,
						TextWrapped = t1.subtitleTextWrap,
						TextTruncate = t1.subtitleTextTruncate or Enum.TextTruncate.SplitWord
					}),
					Icon = if not t1.subtitleIconName or not t1.subtitleBackgroundIconName then if not t1.subtitleIconName then nil else React.createElement(Icon, {
						LayoutOrder = 2,
						size = if not t1.subtitleIconSize then nil else t1.subtitleIconSize,
						name = t1.subtitleIconName,
						variant = if not t1.subtitleIconVariant then nil else t1.subtitleIconVariant,
						style = if not t1.subtitleIconStyle then v16.Color.System.Emphasis else t1.subtitleIconStyle
					}) else React.createElement(View, {
						LayoutOrder = 2,
						tag = "auto-xy"
					}, {
						BackgroundIcon = React.createElement(Icon, {
							size = if not t1.subtitleIconSize then nil else t1.subtitleIconSize,
							name = t1.subtitleBackgroundIconName,
							style = if not t1.subtitleBackgroundIconStyle then v16.Color.System.Emphasis else t1.subtitleBackgroundIconStyle
						}),
						ForegroundIcon = React.createElement(Icon, {
							size = if not t1.subtitleIconSize then nil else t1.subtitleIconSize,
							variant = if not t1.subtitleIconVariant then nil else t1.subtitleIconVariant,
							name = t1.subtitleIconName,
							style = t1.subtitleIconStyle
						})
					})
				}),
				Caption = if not t1.caption then nil else React.createElement(FoundationText, {
					LayoutOrder = 3,
					tag = "auto-xy text-align-x-left text-truncate-split-word",
					Text = t1.caption,
					textStyle = t1.captionTextColor or v16.Color.Content.Default,
					fontStyle = t1.captionFontStyle or v16.Typography.CaptionBody,
					Size = t1.textContainerSize
				})
			}),
			RightButtonContent = t1.rightButtonContent and React.createElement(View, {
				LayoutOrder = 3,
				tag = "auto-xy row"
			}, {
				ButtonContent = t1.rightButtonContent
			})
		})
	end

	return React.createElement("TextButton", {
		Size = UDim2.new(1, 0, 0, v16.Size.Size_1000),
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		Position = position,
		[React.Event.Activated] = t1.onActivated,
		Text = "",
		Active = t1.onActivated ~= nil,
		Selectable = false,
		[React.Tag] = if not t1.testId then nil else `data-testid={ t1.testId }`
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v16.Gap.Medium),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			ItemLineAlignment = Enum.ItemLineAlignment.Start
		}),
		Image = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Image = t1.image,
			Size = UDim2.new(0, v16.Size.Size_1000, 0, v16.Size.Size_1000)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v16.Radius.Medium)
			})
		}),
		TextContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = t1.title,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, v16.Size.Size_500),
				TextSize = TitleMedium.FontSize,
				Font = TitleMedium.Font,
				TextColor3 = v16.DarkMode.Content.Emphasis.Color3,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.SplitWord
			}),
			Subtitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = t1.subtitle,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v16.Size.Size_500),
				TextSize = BodyMedium.FontSize,
				Font = BodyMedium.Font,
				TextColor3 = v16.DarkMode.Content.Emphasis.Color3,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.SplitWord
			})
		}),
		ButtonContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 3,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			ButtonContent = t1.rightButtonContent
		})
	})
end

return React.memo(SduiAttributionRow)
