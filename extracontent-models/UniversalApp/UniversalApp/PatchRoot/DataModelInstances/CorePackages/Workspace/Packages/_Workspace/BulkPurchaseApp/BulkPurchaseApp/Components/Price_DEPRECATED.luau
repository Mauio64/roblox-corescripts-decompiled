local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local NumberLocalization = require(Parent.Localization).NumberLocalization
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images

local function PriceIcon(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), ImageSetLabel (copy), Images (copy)
	return React.createElement(ImageSetLabel, {
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		Size = t1.Size,
		Image = Images["icons/common/robux_small"],
		ImageColor3 = t1.color,
		LayoutOrder = t1.LayoutOrder
	})
end
local function Price_DEPRECATED(t2: {[any]: any}) -- line: 38
	-- upvalues: useDesignTokens (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), PriceIcon (copy), StyledTextLabel (copy), NumberLocalization (copy), LocalizationService (copy)
	local v15 = useDesignTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v15.Global.Space_50 else v15.Size.Size_100)
	}), React.createElement(PriceIcon, {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(t2.fontStyle.FontSize, t2.fontStyle.FontSize),
		color = t2.colorStyle.Color3
	}), React.createElement(StyledTextLabel, {
		layoutOrder = 2,
		fontStyle = t2.fontStyle,
		colorStyle = t2.colorStyle,
		text = NumberLocalization.localize(t2.amount, LocalizationService.RobloxLocaleId),
		textXAlignment = Enum.TextXAlignment.Right
	}))
end

return Price_DEPRECATED
