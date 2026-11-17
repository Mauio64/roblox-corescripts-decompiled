local parent = script.Parent.Parent.Parent

local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
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
	return withStyle(function(p2)
		local theme = p2.Theme

		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = data.layoutOrder
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = p and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 8)
				})
			},
			{
				AppName = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = data.subscriptionProviderName,
					TextSize = 16,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = data.layoutOrder
				})
			},
			{
				Title = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = data.name,
					TextSize = 20,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = data.layoutOrder + 1
				})
			},
			{
				PriceFrame = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = data.layoutOrder + 2
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = p and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					Price = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = data.displayPrice,
						TextSize = 16,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = data.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					}),
					Period = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = data.period,
						TextSize = 16,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = data.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					})
				})
			},
			{
				DisclaimerText = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = data.disclaimerText,
					TextSize = 16,
					TextColor3 = theme.TextDefault.Color,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = data.layoutOrder + 3
				})
			}
		)
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
