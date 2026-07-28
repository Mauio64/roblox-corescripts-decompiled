local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local BulkPurchaseAppParent = BulkPurchaseApp.Parent
local React = require(BulkPurchaseAppParent.React)
local useLocalization = require(BulkPurchaseAppParent.Localization).Hooks.useLocalization
local useDesignTokens = require(BulkPurchaseAppParent.Style).useDesignTokens
local StyledTextLabel = require(BulkPurchaseAppParent.UIBlox).App.Text.StyledTextLabel
local IAPExperience = require(BulkPurchaseAppParent.IAPExperience)
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization
local AlertPrompt = require(BulkPurchaseApp.Components.AlertPrompt)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)

local function BulkPurchaseErrorText(t1: {[any]: any}) -- line: 22
	-- upvalues: useDesignTokens (copy), React (copy), StyledTextLabel (copy)
	local v17 = useDesignTokens()

	return React.createElement(StyledTextLabel, {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		fontStyle = v17.Typography.BodyLarge,
		colorStyle = v17.Color.Content.Default,
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

local function BulkPurchaseError(t4: {[any]: any}) -- line: 74
	-- upvalues: useDesignTokens (copy), t2 (copy), t3 (copy), addEconomicRestrictionKeysToLocalization (copy), useLocalization (copy), ErrorCodeEnum (copy), formatEconomicRestrictionText (copy), React (copy), BulkPurchaseErrorText (copy), AlertPrompt (copy)
	local v19 = useDesignTokens()
	local t5 = {
		title = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorHeading",
		dismissCTA = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.DismissCTA",
		errorReason = t2[t4.errorCode],
		tryAgain = t3[t4.errorCode]
	}

	addEconomicRestrictionKeysToLocalization(t5)

	local u21 = useLocalization(t5)

	if t4.errorCode == ErrorCodeEnum.EconomicRestriction and t4.errorMetadata then
		u21.errorReason = formatEconomicRestrictionText(u21, t4.errorMetadata, true)
	end

	return React.createElement(AlertPrompt, {
		title = u21.title,
		dismissCTA = u21.dismissCTA,
		onDismiss = t4.onDismiss,
		middleContent = function() -- line: 89
			-- upvalues: React (copy), v19 (copy), BulkPurchaseErrorText (copy), u21 (ref)
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
					Padding = UDim.new(0, v19.Size.Size_400)
				}),
				ErrorReason = React.createElement(BulkPurchaseErrorText, {
					layoutOrder = 1,
					text = u21.errorReason
				}),
				TryAgain = if not u21.tryAgain then nil else React.createElement(BulkPurchaseErrorText, {
					layoutOrder = 2,
					text = u21.tryAgain
				})
			})
		end
	})
end

return BulkPurchaseError
