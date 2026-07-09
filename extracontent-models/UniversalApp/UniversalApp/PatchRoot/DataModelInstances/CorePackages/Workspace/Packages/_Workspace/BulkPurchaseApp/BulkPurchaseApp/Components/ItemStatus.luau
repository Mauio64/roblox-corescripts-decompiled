local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

local function mapTokens(p1) -- line: 14
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		successColor = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Common.Success else p1.Color.System.Success,
		failureColor = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Common.Alert else p1.Color.System.Alert,
		fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.CaptionBody else p1.Typography.BodySmall
	}
end
local function ItemStatus(p2) -- line: 32
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useLocalization (copy), ItemStatusKeyToLocalizationKey (copy), ItemStatusToItemStatusKey (copy), React (copy), StyledTextLabel (copy)
	local v15 = useDesignTokens(mapTokens)
	local v16 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v17 = if p2.status ~= Enum.MarketplaceItemPurchaseStatus.Success then v15.failureColor else v15.successColor
	local v18 = v16[ItemStatusToItemStatusKey[p2.status]]

	return React.createElement(StyledTextLabel, {
		textWrapped = true,
		fontStyle = v15.fontStyle,
		colorStyle = v17,
		text = v18,
		size = UDim2.fromScale(1, 1),
		textXAlignment = Enum.TextXAlignment.Right,
		textYAlignment = Enum.TextYAlignment.Top,
		lineHeight = v15.fontStyle.LineHeight
	})
end

return ItemStatus
