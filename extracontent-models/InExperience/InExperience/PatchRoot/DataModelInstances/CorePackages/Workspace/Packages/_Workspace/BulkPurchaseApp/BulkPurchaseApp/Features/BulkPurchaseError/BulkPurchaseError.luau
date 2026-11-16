local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel

local IAPExperience = require(parent.IAPExperience)
local formatEconomicRestrictionText = IAPExperience.Utility.formatEconomicRestrictionText
local addEconomicRestrictionKeysToLocalization = IAPExperience.Utility.addEconomicRestrictionKeysToLocalization

local AlertPrompt = require(BulkPurchaseApp.Components.AlertPrompt)
local ErrorCodeEnum = require(BulkPurchaseApp.Enums.ErrorCodeEnum)

local function BulkPurchaseErrorText(p)
	local v = useDesignTokens()

	return React.createElement(StyledTextLabel, {
		size = UDim2.fromScale(1, 0),
		automaticSize = Enum.AutomaticSize.Y,
		fontStyle = v.Typography.BodyLarge,
		colorStyle = v.Color.Content.Default,
		textXAlignment = Enum.TextXAlignment.Center,
		text = p.text,
		layoutOrder = p.layoutOrder
	})
end

local v = {
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

local v2 = {
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

local function BulkPurchaseError(props)
	local v3 = useDesignTokens()

	local v4 = {
		title = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.ErrorHeading",
		errorReason = v[props.errorCode],
		tryAgain = v2[props.errorCode],
		dismissCTA = "CoreScripts.BulkPurchasePrompt.CompletedPrompt.DismissCTA"
	}

	addEconomicRestrictionKeysToLocalization(v4)
	local v5 = useLocalization(v4)

	if props.errorCode == ErrorCodeEnum.EconomicRestriction and props.errorMetadata then
		v5.errorReason = formatEconomicRestrictionText(v5, props.errorMetadata, true)
	end

	local function fn()
		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v7 = {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, v3.Size.Size_400)
			}),
			ErrorReason = React.createElement(BulkPurchaseErrorText, {
				text = v5.errorReason,
				layoutOrder = 1
			}),
			TryAgain = 0
		}
		local tryAgain

		if v5.tryAgain then
			tryAgain = React.createElement(BulkPurchaseErrorText, {
				text = v5.tryAgain,
				layoutOrder = 2
			})
		end

		v7.TryAgain = tryAgain
		return createElement("Frame", v6, v7)
	end

	return React.createElement(AlertPrompt, {
		title = v5.title,
		dismissCTA = v5.dismissCTA,
		onDismiss = props.onDismiss,
		middleContent = fn
	})
end

return BulkPurchaseError
