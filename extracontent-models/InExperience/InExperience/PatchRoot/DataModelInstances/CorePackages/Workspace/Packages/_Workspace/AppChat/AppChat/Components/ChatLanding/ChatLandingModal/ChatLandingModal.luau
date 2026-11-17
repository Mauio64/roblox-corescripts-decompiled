local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

require(AppChat.types)
local Cryo = require(parent.Cryo)
local React = require(parent.React)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ButtonStack = UIBlox.App.Button.ButtonStack
local enum = UIBlox.App.Button.Enum
local Label = require(AppChat.Components.Label.Label)
local useChatPagePadding = require(AppChat.Contexts.ChatPagePadding.useChatPagePadding)
local AppChatNetworking = require(parent.AppChatNetworking)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FFlagAppChatLandingModalThemedBackground = require(AppChat.Flags.FFlagAppChatLandingModalThemedBackground)

local iconsactionsfavoriteOn = UIBlox.App.ImageSet.Images["icons/actions/favoriteOn"]
local x = Foundation.Enums.IconName.X

local v2 = {
	[AppChatNetworking.Constants.ModalContentType.Link] = function(p)
		local v2 = useStyle()
		return React.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = p.layoutOrder,
			FontFace = normalizeFontFace(v2.Tokens.Typography.BodyLarge.Font),
			BorderSizePixel = 0,
			Text = `<u>{p.content.text}</u>`,
			RichText = true,
			TextColor3 = v2.Theme.TextDefault.Color,
			TextSize = v2.Font.CaptionBody.RelativeSize * v2.Font.BaseSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			[React.Event.Activated] = p.content.onActivated
		})
	end,
	[AppChatNetworking.Constants.ModalContentType.Text] = function(p)
		local v2 = useStyle()
		return React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			LayoutOrder = p.layoutOrder,
			FontFace = normalizeFontFace(v2.Tokens.Typography.BodyLarge.Font),
			BorderSizePixel = 0,
			Text = p.content.text,
			TextColor3 = v2.Theme.TextDefault.Color,
			TextSize = v2.Font.CaptionBody.RelativeSize * v2.Font.BaseSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		})
	end
}

local v3 = {
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

return React.forwardRef(function(p, ref)
	local joined = Cryo.Dictionary.join(v3, p)
	local v4 = useStyle()
	local style = joined.style or v4
	local v5 = useChatPagePadding()

	local size_200 = style.Tokens.Size.Size_200
	local size_1000 = style.Tokens.Size.Size_1000
	local v6 = Foundation.Hooks.useTokens()
	local size_600 = v6.Size.Size_600

	local v7, v8 = React.useMemo(function()
		local mapped = Cryo.Dictionary.map(joined.additionalContent, function(content, p2: number)
			local v7 = v2[content.type]
			local layoutOrder = p2 + 2
			local selected

			if v7 then
				selected = React.createElement(v7, { layoutOrder = layoutOrder, content = content })
			end

			if selected then
				return selected, `additionalContent_{p2}`
			end

			v:warning(`Unsupported additional content type: {content.type}`)

			return nil, nil
		end)

		return mapped, not Cryo.isEmpty(mapped)
	end, { joined.additionalContent })

	local createElement = React.createElement
	local v9 = {
		BackgroundTransparency = 1,
		LayoutOrder = joined.LayoutOrder,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = ref
	}

	local v10 = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_200),
			PaddingBottom = UDim.new(0, size_200),
			PaddingLeft = UDim.new(0, v5.left),
			PaddingRight = UDim.new(0, v5.right)
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local backgroundTransparency

	if FFlagAppChatLandingModalThemedBackground then
		backgroundTransparency = style.Theme.BackgroundUIDefault.Transparency
	else
		backgroundTransparency = style.Theme.SystemPrimaryContent.Transparency
	end

	local backgroundColor

	if FFlagAppChatLandingModalThemedBackground then
		backgroundColor = style.Theme.BackgroundUIDefault.Color
	else
		backgroundColor = style.Theme.SystemPrimaryContent.Color
	end

	local v11 = {
		BackgroundTransparency = backgroundTransparency,
		BackgroundColor3 = backgroundColor,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v12 = {
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
	local v13 = {
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
	local v14 = {
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
	local v15 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v16 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, size_200)
		}),
		TitleLabelWithIcon = 0,
		TitleTextLabel = 0
	}
	local titleLabelWithIcon

	if joined.titleLabelText then
		titleLabelWithIcon = React.createElement(Label, {
			bodyText = joined.titleLabelText,
			iconImage = iconsactionsfavoriteOn,
			layoutOrder = 1
		})
	end

	v16.TitleLabelWithIcon = titleLabelWithIcon

	v16.TitleTextLabel = React.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v6.Typography.HeadingLarge.Font),
		BorderSizePixel = 0,
		Text = joined.titleText,
		TextColor3 = style.Theme.TextEmphasis.Color,
		TextSize = style.Font.Header2.RelativeSize * style.Font.BaseSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	})
	children2.LabelAndTextFrame = createElement5("Frame", v15, v16)

	children2.BodyTextLabel = React.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
		BorderSizePixel = 0,
		Text = joined.bodyText,
		TextColor3 = style.Theme.TextDefault.Color,
		TextSize = style.Font.CaptionBody.RelativeSize * style.Font.BaseSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	})
	local additionalContent

	if v8 then
		additionalContent = React.createElement(React.Fragment, {}, v7)
	end

	children2.AdditionalContent = additionalContent
	children.TextFrame = createElement4("Frame", v14, children2)

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
	v12.IconAndTextFrame = createElement3("Frame", v13, children)
	local buttons

	if not joined.hideActionButton then
		buttons = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, LayoutOrder = 2, Size = UDim2.new(1, 0, 0, size_1000) },
			{
				ButtonStack = React.createElement(ButtonStack, {
					forcedFillDirection = Enum.FillDirection.Horizontal,
					buttons = {
						{
							buttonType = joined.buttonType,
							props = { onActivated = joined.onActivated, text = joined.actionText }
						}
					}
				})
			}
		)
	end

	v12.Buttons = buttons
	v10.Content = createElement2("Frame", v11, v12)
	return createElement("Frame", v9, v10)
end)
