local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("ChatLandingModal")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local buttonStack = UIBlox.App.Button.ButtonStack
local enum = UIBlox.App.Button.Enum
local Label = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Label/Label")
local useChatPagePadding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPagePadding/useChatPagePadding")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FFlagAppChatLandingModalThemedBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatLandingModalThemedBackground")

local iconsactionsfavoriteOn = UIBlox.App.ImageSet.Images["icons/actions/favoriteOn"]
local x = Foundation.Enums.IconName.X

local v6 = {
	[AppChatNetworking.Constants.ModalContentType.Link] = function(p2)
		local v7 = useStyle()
		return React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = p2.layoutOrder,
			FontFace = normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font),
			BorderSizePixel = 0,
			Text = `<u>{p2.content.text}</u>`,
			RichText = true,
			TextColor3 = v7.Theme.TextDefault.Color,
			TextSize = v7.Font.CaptionBody.RelativeSize * v7.Font.BaseSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Event.Activated] = p2.content.onActivated
		})
	end,
	[AppChatNetworking.Constants.ModalContentType.Text] = function(p2)
		local v7 = useStyle()
		return React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = p2.layoutOrder,
			FontFace = normalizeFontFace(v7.Tokens.Typography.BodyLarge.Font),
			BorderSizePixel = 0,
			Text = p2.content.text,
			TextColor3 = v7.Theme.TextDefault.Color,
			TextSize = v7.Font.CaptionBody.RelativeSize * v7.Font.BaseSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})
	end
}

local v7 = {
	titleText = "",
	bodyText = "",
	actionText = "",
	additionalContent = {},
	buttonType = enum.ButtonType.PrimarySystem,
	paddingX = 12,
	hideActionButton = false,
	onActivated = function() end,
	onDismissed = function() end
}

return React.forwardRef(function(p2, p3)
	local joined = Cryo.Dictionary.join(v7, p2)
	local v8 = useStyle()
	local style = joined.style or v8
	local v9 = useChatPagePadding()

	local size_200 = style.Tokens.Size.Size_200
	local size_1000 = style.Tokens.Size.Size_1000
	local v10 = Foundation.Hooks.useTokens()
	local size_600 = v10.Size.Size_600

	local v11, v12 = React.useMemo(function()
		local mapped = Cryo.Dictionary.map(joined.additionalContent, function(p4, p5)
			local v13 = v6[p4.type]
			local v14 = p5 + 2
			local v15

			if v13 then
				v15 = React.createElement(v13, { layoutOrder = v14, content = p4 })
			end

			if v15 then
				return v15, `additionalContent_{p5}`
			end

			v5:warning(`Unsupported additional content type: {p4.type}`)

			return nil, nil
		end)

		return mapped, not Cryo.isEmpty(mapped)
	end, { joined.additionalContent })

	local createElement = React.createElement
	local v14 = {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p3
	}

	local v15 = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_200),
			PaddingBottom = UDim.new(0, size_200),
			PaddingLeft = UDim.new(0, v9.left),
			PaddingRight = UDim.new(0, v9.right)
		}),
		Content = 0
	}

	local createElement2 = React.createElement

	local v18 = if FFlagAppChatLandingModalThemedBackground then style.Theme.BackgroundUIDefault.Transparency else style.Theme.SystemPrimaryContent.Transparency

	local v19 = if FFlagAppChatLandingModalThemedBackground then style.Theme.BackgroundUIDefault.Color else style.Theme.SystemPrimaryContent.Color
	local v17 = {
		BackgroundTransparency = v18,
		BackgroundColor3 = v19,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v20 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_200 * 2)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, style.Tokens.Radius.Medium)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = style.Tokens.Stroke.Standard,
			Color = style.Theme.Divider.Color,
			Transparency = style.Theme.Divider.Transparency
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_200),
			PaddingBottom = UDim.new(0, size_200),
			PaddingLeft = UDim.new(0, size_200),
			PaddingRight = UDim.new(0, size_200)
		}),
		IconAndTextFrame = 0,
		Buttons = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local children = {
		HorizontalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, size_200)
		}),
		TextFrame = 0,
		ImageIcon = 0
	}

	local createElement4 = React.createElement
	local v24 = {
		Size = UDim2.new(1, -size_600 - size_200, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local children2 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_200)
		}),
		LabelAndTextFrame = 0,
		BodyTextLabel = 0,
		AdditionalContent = 0
	}

	local createElement5 = React.createElement
	local v26 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v27 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_200)
		}),
		TitleLabelWithIcon = 0,
		TitleTextLabel = 0
	}

	local v28 = if joined.titleLabelText then React.createElement(Label, {
		bodyText = joined.titleLabelText,
		iconImage = iconsactionsfavoriteOn,
		layoutOrder = 1
	}) else nil
	v27.TitleLabelWithIcon = v28

	v27.TitleTextLabel = React.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v10.Typography.HeadingLarge.Font),
		BorderSizePixel = 0,
		Text = joined.titleText,
		TextColor3 = style.Theme.TextEmphasis.Color,
		TextSize = style.Font.Header2.RelativeSize * style.Font.BaseSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		})
	})
	children2.LabelAndTextFrame = createElement5("Frame", v26, v27)

	children2.BodyTextLabel = React.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v10.Typography.BodyLarge.Font),
		BorderSizePixel = 0,
		Text = joined.bodyText,
		TextColor3 = style.Theme.TextDefault.Color,
		TextSize = style.Font.CaptionBody.RelativeSize * style.Font.BaseSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	})

	local v29 = if v12 then React.createElement(React.Fragment, {}, v11) else nil
	children2.AdditionalContent = v29
	children.TextFrame = createElement4("Frame", v24, children2)

	children.ImageIcon = React.createElement(
		Foundation.View,
		{
			onActivated = joined.onDismissed,
			LayoutOrder = 2,
			tag = "auto-xy x-default-transparent radius-xsmall"
		},
		{
			Icon = React.createElement(Foundation.Icon, { size = size_600, name = x })
		}
	)
	v20.IconAndTextFrame = createElement3("Frame", v22, children)

	local v30 = if not joined.hideActionButton then React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, size_1000)
		},
		{
			ButtonStack = React.createElement(buttonStack, {
				forcedFillDirection = Enum.FillDirection.Horizontal,
				buttons = {
					{
						buttonType = joined.buttonType,
						props = {
							onActivated = joined.onActivated,
							text = joined.actionText
						}
					}
				}
			})
		}
	) else nil
	v20.Buttons = v30
	v15.Content = createElement2("Frame", v17, v20)
	return createElement("Frame", v14, v15)
end)
