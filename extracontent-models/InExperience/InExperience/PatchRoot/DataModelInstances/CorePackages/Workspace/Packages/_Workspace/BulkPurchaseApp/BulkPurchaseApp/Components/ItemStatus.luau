local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local StyledTextLabel = require(BulkPurchaseAppParent.UIBlox).App.Text.StyledTextLabel
local ItemStatusToItemStatusKey = require(BulkPurchaseApp.Enums.ItemStatusToItemStatusKey)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)

local function mapTokens(p1) -- line: 12
	return {
		successColor = p1.Color.System.Success,
		failureColor = p1.Color.System.Alert,
		fontStyle = p1.Typography.BodySmall
	}
end
local function ItemStatus(p2) -- line: 24
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useLocalization (copy), ItemStatusKeyToLocalizationKey (copy), ItemStatusToItemStatusKey (copy), React (copy), StyledTextLabel (copy)
	local v13 = useDesignTokens(mapTokens)
	local v14 = useLocalization(ItemStatusKeyToLocalizationKey)
	local v15 = if p2.status ~= Enum.MarketplaceItemPurchaseStatus.Success then v13.failureColor else v13.successColor
	local v16 = v14[ItemStatusToItemStatusKey[p2.status]]

	return React.createElement(StyledTextLabel, {
		textWrapped = true,
		fontStyle = v13.fontStyle,
		colorStyle = v15,
		text = v16,
		size = UDim2.fromScale(1, 1),
		textXAlignment = Enum.TextXAlignment.Right,
		textYAlignment = Enum.TextYAlignment.Top,
		lineHeight = v13.fontStyle.LineHeight
	})
end

return ItemStatus
