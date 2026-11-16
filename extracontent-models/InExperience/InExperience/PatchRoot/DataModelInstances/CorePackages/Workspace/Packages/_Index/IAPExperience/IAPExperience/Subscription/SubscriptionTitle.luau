local parent = script.Parent.Parent.Parent

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local React = require(parent.React)

local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Roact = require(parent.Roact)
local t = require(parent.t)
local extended = Roact.PureComponent:extend("SubscriptionTitle")

extended.validateProps = t.strictInterface({
	name = t.string,
	displayPrice = t.string,
	subscriptionProviderName = t.string,
	period = t.string,
	disclaimerText = t.string,
	layoutOrder = t.number,
	contentHeight = t.number,
	itemIcon = t.any
})

local function createSubscriptionInfo(data, p) -- 2 equivalent calls inferred from this helper
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font.Body.Font

		local createElement = React.createElement
		local v = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}
		local v2 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = p and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}

		local createElement2 = React.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = data.subscriptionProviderName,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font
		end

		v3.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v3.FontFace = fontFace

		v3.TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v3.LayoutOrder = data.layoutOrder
		local v4 = {
			AppName = createElement2("TextLabel", v3)
		}

		local createElement3 = React.createElement
		local v5 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = data.name,
			TextSize = 20,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}
		local font3

		if not FoundationFontFaceMigration then
			font3 = font
		end

		v5.Font = font3
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v5.FontFace = fontFace2

		v5.TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v5.LayoutOrder = data.layoutOrder + 1
		local v6 = {
			Title = createElement3("TextLabel", v5)
		}

		local createElement4 = React.createElement
		local v7 = {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = data.layoutOrder + 2
		}
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = p and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			Price = 0,
			Period = 0
		}

		local createElement5 = React.createElement
		local v8 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = data.displayPrice,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}
		local font4

		if not FoundationFontFaceMigration then
			font4 = font
		end

		v8.Font = font4
		local fontFace3

		if FoundationFontFaceMigration then
			fontFace3 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v8.FontFace = fontFace3

		v8.TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v8.LayoutOrder = data.layoutOrder + 1
		v8.AutomaticSize = Enum.AutomaticSize.X
		children.Price = createElement5("TextLabel", v8)

		local createElement6 = React.createElement
		local v9 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = data.period,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}
		local font5

		if not FoundationFontFaceMigration then
			font5 = font
		end

		v9.Font = font5
		local fontFace4

		if FoundationFontFaceMigration then
			fontFace4 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v9.FontFace = fontFace4

		v9.TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v9.LayoutOrder = data.layoutOrder + 1
		v9.AutomaticSize = Enum.AutomaticSize.X
		children.Period = createElement6("TextLabel", v9)
		local v10 = {
			PriceFrame = createElement4("Frame", v7, children)
		}

		local createElement7 = React.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = data.disclaimerText,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		if FoundationFontFaceMigration then
			font = nil
		end

		v11.Font = font
		local fontFace5

		if FoundationFontFaceMigration then
			fontFace5 = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v11.FontFace = fontFace5

		v11.TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v11.LayoutOrder = data.layoutOrder + 3
		return createElement("Frame", v, v2, v4, v6, v10, {
			DisclaimerText = createElement7("TextLabel", v11)
		})
	end)
end

local function createCompactSubscriptionTitle(props)
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 24)
			}),
			Icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 96, 0, 96),
				ScaleType = Enum.ScaleType.Fit,
				AutomaticSize = Enum.AutomaticSize.X,
				Image = props.itemIcon
			}),
			SubscriptionInfo = createSubscriptionInfo(props, true) -- inferred equivalent call
		}
	)
end

local function createNormalSubscriptionTitle(props)
	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		},
		{
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 24)
			}),
			Icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 96, 0, 96),
				ScaleType = Enum.ScaleType.Fit,
				AutomaticSize = Enum.AutomaticSize.X,
				Image = props.itemIcon
			}),
			SubscriptionInfo = createSubscriptionInfo(props, false) -- inferred equivalent call
		}
	)
end

function extended.getTitleHeight(_, p): number
	return if p > 216 then 216 else 96
end

function extended.render(p)
	if p.props.contentHeight > 216 then
		return createNormalSubscriptionTitle(p.props)
	end

	return createCompactSubscriptionTitle(p.props)
end

return extended
