local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation").Utility.normalizeFontFace
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local withStyle = UIBlox.Style.withStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/t")
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

local function createSubscriptionInfo(data, p2)
	return withStyle(function(p3)
		local theme = p3.Theme

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
					HorizontalAlignment = p2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
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
					FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
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
					FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
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
						HorizontalAlignment = p2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					Price = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = data.displayPrice,
						TextSize = 16,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
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
						FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
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
					FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = data.layoutOrder + 3
				})
			}
		)
	end)
end

local function createCompactSubscriptionTitle(props)
	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local v6 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 24)
		}),
		Icon = React.createElement(imageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 96, 0, 96),
			ScaleType = Enum.ScaleType.Fit,
			AutomaticSize = Enum.AutomaticSize.X,
			Image = props.itemIcon
		}),
		SubscriptionInfo = 0
	}
	local v7 = true
	v6.SubscriptionInfo = withStyle(function(p2)
		local theme = p2.Theme

		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = props.layoutOrder
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 8)
				})
			},
			{
				AppName = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = props.subscriptionProviderName,
					TextSize = 16,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder
				})
			},
			{
				Title = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = props.name,
					TextSize = 20,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder + 1
				})
			},
			{
				PriceFrame = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = props.layoutOrder + 2
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					Price = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = props.displayPrice,
						TextSize = 16,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = props.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					}),
					Period = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = props.period,
						TextSize = 16,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = props.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					})
				})
			},
			{
				DisclaimerText = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = props.disclaimerText,
					TextSize = 16,
					TextColor3 = theme.TextDefault.Color,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder + 3
				})
			}
		)
	end)
	return createElement("Frame", v5, v6)
end

local function createNormalSubscriptionTitle(props)
	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local v6 = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 24)
		}),
		Icon = React.createElement(imageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 96, 0, 96),
			ScaleType = Enum.ScaleType.Fit,
			AutomaticSize = Enum.AutomaticSize.X,
			Image = props.itemIcon
		}),
		SubscriptionInfo = 0
	}
	local v7 = false
	v6.SubscriptionInfo = withStyle(function(p2)
		local theme = p2.Theme

		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				LayoutOrder = props.layoutOrder
			},
			{
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 8)
				})
			},
			{
				AppName = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = props.subscriptionProviderName,
					TextSize = 16,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder
				})
			},
			{
				Title = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 20),
					BackgroundTransparency = 1,
					Text = props.name,
					TextSize = 20,
					TextColor3 = theme.TextEmphasis.Color,
					TextTransparency = theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder + 1
				})
			},
			{
				PriceFrame = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = Color3.fromRGB(255, 0, 0),
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = props.layoutOrder + 2
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal
					}),
					Price = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = props.displayPrice,
						TextSize = 16,
						TextColor3 = theme.TextEmphasis.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = props.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					}),
					Period = React.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 16),
						BackgroundTransparency = 1,
						Text = props.period,
						TextSize = 16,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
						RichText = true,
						TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
						TextWrapped = true,
						LayoutOrder = props.layoutOrder + 1,
						AutomaticSize = Enum.AutomaticSize.X
					})
				})
			},
			{
				DisclaimerText = React.createElement("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					BackgroundTransparency = 1,
					Text = props.disclaimerText,
					TextSize = 16,
					TextColor3 = theme.TextDefault.Color,
					FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
					TextWrapped = true,
					LayoutOrder = props.layoutOrder + 3
				})
			}
		)
	end)
	return createElement("Frame", v5, v6)
end

function extended:getTitleHeight(p3): number
	if p3 > 216 then
		return 216
	end

	return 96
end

function extended.render(p2)
	if p2.props.contentHeight > 216 then
		return createNormalSubscriptionTitle(p2.props)
	end

	return createCompactSubscriptionTitle(p2.props)
end

return extended
