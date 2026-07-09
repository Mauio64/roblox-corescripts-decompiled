local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local UIBlox = require(BulkPurchaseAppParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(BulkPurchaseAppParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local IAPExperience = require(BulkPurchaseAppParent.IAPExperience)
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization
local AlertPrompt = require(BulkPurchaseApp.Components.AlertPrompt)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)

local function BulkPurchaseErrorText(t1: {[any]: any}) -- line: 24
	-- upvalues: useDesignTokens (copy), React (copy), StyledTextLabel (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v19 = useDesignTokens()

	return React.createElement(StyledTextLabel, {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		fontStyle = if not FFlagRenameDeprecatedUIBloxTokens then v19.Semantic.Typography.Body else v19.Typography.BodyLarge,
		colorStyle = if not FFlagRenameDeprecatedUIBloxTokens then v19.Semantic.Color.Text.Default else v19.Color.Content.Default,
		textXAlignment = Enum.TextXAlignment.Center,
		text = t1.text,
		layoutOrder = t1.layoutOrder
	})
end

local t2 = {
	[ErrorCodeEnum.InsufficientRobux] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonInsufficientRobux",
	[ErrorCodeEnum.QuotaExceeded] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonQuotaExceeded",
	[ErrorCodeEnum.NotForSale] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonNotForSale",
	[ErrorCodeEnum.AlreadyOwned] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonAlreadyOwned",
	[ErrorCodeEnum.PurchaserIsSeller] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonPurchaserIsSeller",
	[ErrorCodeEnum.NotAvailableForPurchaser] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonNotAvailableForPurchaser",
	[ErrorCodeEnum.PriceMismatch] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonPriceMismatch",
	[ErrorCodeEnum.QuantityLimitExceeded] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonQuantityLimitExceeded",
	[ErrorCodeEnum.InsufficientMembership] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonInsufficientMembership",
	[ErrorCodeEnum.Generic] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonGeneric",
	[ErrorCodeEnum.SoldOut] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonSoldOut",
	[ErrorCodeEnum.TwoStepVerificationRequired] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReason2SV",
	[ErrorCodeEnum.PlaceInvalid] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.ErrorReasonNotAvailableInExperience"
}
local t3 = {
	[ErrorCodeEnum.InsufficientRobux] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainMoreRobux",
	[ErrorCodeEnum.QuotaExceeded] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainWait",
	[ErrorCodeEnum.NotForSale] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.AlreadyOwned] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.PurchaserIsSeller] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.NotAvailableForPurchaser] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.PriceMismatch] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainNow",
	[ErrorCodeEnum.QuantityLimitExceeded] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.InsufficientMembership] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.Generic] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainLater",
	[ErrorCodeEnum.SoldOut] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainNow",
	[ErrorCodeEnum.TwoStepVerificationRequired] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems",
	[ErrorCodeEnum.PlaceInvalid] = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorPrompt.TryAgainOtherItems"
}

local function BulkPurchaseError(t4: {[any]: any}) -- line: 80
	-- upvalues: useDesignTokens (copy), t2 (copy), t3 (copy), addEconomicRestrictionKeysToLocalization (copy), useLocalization (copy), ErrorCodeEnum (copy), formatEconomicRestrictionText (copy), React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), BulkPurchaseErrorText (copy), AlertPrompt (copy)
	local v21 = useDesignTokens()
	local t5 = {
		title = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorHeading",
		dismissCTA = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.DismissCTA",
		errorReason = t2[t4.errorCode],
		tryAgain = t3[t4.errorCode]
	}

	addEconomicRestrictionKeysToLocalization(t5)

	local u23 = useLocalization(t5)

	if t4.errorCode == ErrorCodeEnum.EconomicRestriction and t4.errorMetadata then
		u23.errorReason = formatEconomicRestrictionText(u23, t4.errorMetadata, true)
	end

	return React.createElement(AlertPrompt, {
		title = u23.title,
		dismissCTA = u23.dismissCTA,
		onDismiss = t4.onDismiss,
		middleContent = function() -- line: 95
			-- upvalues: React (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v21 (copy), BulkPurchaseErrorText (copy), u23 (ref)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_200 else v21.Size.Size_400)
				}),
				ErrorReason = React.createElement(BulkPurchaseErrorText, {
					layoutOrder = 1,
					text = u23.errorReason
				}),
				TryAgain = if not u23.tryAgain then nil else React.createElement(BulkPurchaseErrorText, {
					layoutOrder = 2,
					text = u23.tryAgain
				})
			})
		end
	})
end

return BulkPurchaseError
