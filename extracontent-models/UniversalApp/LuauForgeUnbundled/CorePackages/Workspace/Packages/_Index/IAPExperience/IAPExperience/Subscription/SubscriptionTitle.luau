local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font.Body.Font

		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = data.layoutOrder
		}
		local v7 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = p2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}

		local createElement2 = React.createElement
		local v10 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = data.subscriptionProviderName,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v10.FontFace = v12

		v10.TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v10.LayoutOrder = data.layoutOrder
		local v8 = {
			AppName = createElement2("TextLabel", v10)
		}

		local createElement3 = React.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = data.name,
			TextSize = 20,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v17 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v15.FontFace = v17

		v15.TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v15.LayoutOrder = data.layoutOrder + 1
		local v13 = {
			Title = createElement3("TextLabel", v15)
		}

		local createElement4 = React.createElement
		local v20 = {
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
				HorizontalAlignment = p2 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			Price = 0,
			Period = 0
		}

		local createElement5 = React.createElement
		local v22 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = data.displayPrice,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v24 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v22.FontFace = v24

		v22.TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v22.LayoutOrder = data.layoutOrder + 1
		v22.AutomaticSize = Enum.AutomaticSize.X
		children.Price = createElement5("TextLabel", v22)

		local createElement6 = React.createElement
		local v26 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = data.period,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v28 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v26.FontFace = v28

		v26.TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v26.LayoutOrder = data.layoutOrder + 1
		v26.AutomaticSize = Enum.AutomaticSize.X
		children.Period = createElement6("TextLabel", v26)
		local v18 = {
			PriceFrame = createElement4("Frame", v20, children)
		}

		local createElement7 = React.createElement
		local v31 = {
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

		if foundationFontFaceMigration then
			font = nil
		end

		v31.Font = font

		local v32 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
		v31.FontFace = v32

		v31.TextXAlignment = p2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v31.LayoutOrder = data.layoutOrder + 3
		return createElement("Frame", v6, v7, v8, v13, v18, {
			DisclaimerText = createElement7("TextLabel", v31)
		})
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
	v6.SubscriptionInfo = withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font.Body.Font

		local createElement2 = React.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local v10 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}

		local createElement3 = React.createElement
		local v13 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = props.subscriptionProviderName,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v15 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v13.FontFace = v15

		v13.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v13.LayoutOrder = props.layoutOrder
		local v11 = {
			AppName = createElement3("TextLabel", v13)
		}

		local createElement4 = React.createElement
		local v18 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = props.name,
			TextSize = 20,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v20 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v18.FontFace = v20

		v18.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v18.LayoutOrder = props.layoutOrder + 1
		local v16 = {
			Title = createElement4("TextLabel", v18)
		}

		local createElement5 = React.createElement
		local v23 = {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.layoutOrder + 2
		}
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			Price = 0,
			Period = 0
		}

		local createElement6 = React.createElement
		local v25 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.displayPrice,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v27 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v25.FontFace = v27

		v25.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v25.LayoutOrder = props.layoutOrder + 1
		v25.AutomaticSize = Enum.AutomaticSize.X
		children.Price = createElement6("TextLabel", v25)

		local createElement7 = React.createElement
		local v29 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.period,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v31 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v29.FontFace = v31

		v29.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v29.LayoutOrder = props.layoutOrder + 1
		v29.AutomaticSize = Enum.AutomaticSize.X
		children.Period = createElement7("TextLabel", v29)
		local v21 = {
			PriceFrame = createElement5("Frame", v23, children)
		}

		local createElement8 = React.createElement
		local v34 = {
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.disclaimerText,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		if foundationFontFaceMigration then
			font = nil
		end

		v34.Font = font

		local v35 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v34.FontFace = v35

		v34.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v34.LayoutOrder = props.layoutOrder + 3
		return createElement2("Frame", v9, v10, v11, v16, v21, {
			DisclaimerText = createElement8("TextLabel", v34)
		})
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
	v6.SubscriptionInfo = withStyle(function(props2)
		local theme = props2.Theme
		local font = props2.Font.Body.Font

		local createElement2 = React.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		}
		local v10 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, 8)
			})
		}

		local createElement3 = React.createElement
		local v13 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = props.subscriptionProviderName,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v15 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v13.FontFace = v15

		v13.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v13.LayoutOrder = props.layoutOrder
		local v11 = {
			AppName = createElement3("TextLabel", v13)
		}

		local createElement4 = React.createElement
		local v18 = {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundTransparency = 1,
			Text = props.name,
			TextSize = 20,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextEmphasis.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		local v20 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v18.FontFace = v20

		v18.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v18.LayoutOrder = props.layoutOrder + 1
		local v16 = {
			Title = createElement4("TextLabel", v18)
		}

		local createElement5 = React.createElement
		local v23 = {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = props.layoutOrder + 2
		}
		local children = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = v7 and Enum.HorizontalAlignment.Left or Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			Price = 0,
			Period = 0
		}

		local createElement6 = React.createElement
		local v25 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.displayPrice,
			TextSize = 16,
			TextColor3 = theme.TextEmphasis.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v27 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v25.FontFace = v27

		v25.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v25.LayoutOrder = props.layoutOrder + 1
		v25.AutomaticSize = Enum.AutomaticSize.X
		children.Price = createElement6("TextLabel", v25)

		local createElement7 = React.createElement
		local v29 = {
			Size = UDim2.new(0, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.period,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			Font = if not foundationFontFaceMigration then font else nil,
			FontFace = 0,
			RichText = true,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0,
			AutomaticSize = 0
		}

		local v31 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v29.FontFace = v31

		v29.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v29.LayoutOrder = props.layoutOrder + 1
		v29.AutomaticSize = Enum.AutomaticSize.X
		children.Period = createElement7("TextLabel", v29)
		local v21 = {
			PriceFrame = createElement5("Frame", v23, children)
		}

		local createElement8 = React.createElement
		local v34 = {
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = props.disclaimerText,
			TextSize = 16,
			TextColor3 = theme.TextDefault.Color,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextWrapped = true,
			LayoutOrder = 0
		}

		if foundationFontFaceMigration then
			font = nil
		end

		v34.Font = font

		local v35 = if foundationFontFaceMigration then normalizeFontFace(props2.Tokens.Typography.BodyLarge.Font) else nil
		v34.FontFace = v35

		v34.TextXAlignment = v7 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center

		v34.LayoutOrder = props.layoutOrder + 3
		return createElement2("Frame", v9, v10, v11, v16, v21, {
			DisclaimerText = createElement8("TextLabel", v34)
		})
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
