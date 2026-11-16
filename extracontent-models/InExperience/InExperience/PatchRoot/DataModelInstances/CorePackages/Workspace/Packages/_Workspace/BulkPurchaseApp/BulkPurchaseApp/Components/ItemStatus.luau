local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

local function mapTokens(p)
	return {
		successColor = p.Color.System.Success,
		failureColor = p.Color.System.Alert,
		fontStyle = p.Typography.BodySmall
	}
end

local function ItemStatus(p)
	local v = useDesignTokens(mapTokens)
	local v2 = useLocalization(ItemStatusKeyToLocalizationKey)
	local colorStyle

	if p.status == Enum.MarketplaceItemPurchaseStatus.Success then
		colorStyle = v.successColor
	else
		colorStyle = v.failureColor
	end

	local text = v2[ItemStatusToItemStatusKey[p.status]]
	return React.createElement(StyledTextLabel, {
		fontStyle = v.fontStyle,
		colorStyle = colorStyle,
		text = text,
		textWrapped = true,
		size = UDim2.fromScale(1, 1),
		textXAlignment = Enum.TextXAlignment.Right,
		textYAlignment = Enum.TextYAlignment.Top,
		lineHeight = v.fontStyle.LineHeight
	})
end

return ItemStatus
