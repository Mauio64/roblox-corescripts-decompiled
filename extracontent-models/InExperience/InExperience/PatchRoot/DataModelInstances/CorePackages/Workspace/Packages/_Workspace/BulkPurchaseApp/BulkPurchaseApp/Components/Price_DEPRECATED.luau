local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local function PriceIcon(props)
	return React.createElement(ImageSetLabel, {
		Size = props.Size,
		Image = Images["icons/common/robux_small"],
		ImageColor3 = props.color,
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	})
end

local function Price_DEPRECATED(props)
	local v = useDesignTokens()

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, v.Size.Size_100)
		}),
		React.createElement(PriceIcon, {
			Size = UDim2.fromOffset(props.fontStyle.FontSize, props.fontStyle.FontSize),
			color = props.colorStyle.Color3,
			LayoutOrder = 1
		}),
		React.createElement(StyledTextLabel, {
			fontStyle = props.fontStyle,
			colorStyle = props.colorStyle,
			text = NumberLocalization.localize(props.amount, LocalizationService.RobloxLocaleId),
			textXAlignment = Enum.TextXAlignment.Right,
			layoutOrder = 2
		})
	)
end

return Price_DEPRECATED
