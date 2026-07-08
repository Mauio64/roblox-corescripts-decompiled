local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local SignalsReact = require(RobloxSubscriptionPurchaseAppParent.SignalsReact)

require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)

local View = Foundation.View
local FoundationText = Foundation.Text
local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local getPeriodTypeDisplayLabel = require(RobloxSubscriptionPurchaseApp.Utils.getPeriodTypeDisplayLabel)
local FFlagSupportFreeTrialPriceRow = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrialPriceRow)

local function RobloxSubscriptionPriceRow(t1: {[any]: any}) -- line: 22
	-- upvalues: RobloxSubscriptionStore (copy), SignalsReact (copy), FFlagSupportFreeTrialPriceRow (copy), getPeriodTypeDisplayLabel (copy), useLocalization (copy), React (copy), View (copy), FoundationText (copy)
	local v14 = RobloxSubscriptionStore.get()
	local v15 = SignalsReact.useSignalState(v14.getRobloxSubscriptionProduct)
	local v16 = v15 and v15.LocalizedPriceDisplayString
	local v17 = v15 and v15.PeriodType
	local v18 = not not FFlagSupportFreeTrialPriceRow and t1.isFreeTrial == true
	local v19 = getPeriodTypeDisplayLabel(v17 or "", false)
	local v20 = useLocalization({
		periodType = v19
	})
	local v21 = useLocalization({
		price = {
			"Feature.RobloxSubscription.Label.BlackbirdPriceTag",
			price = v16 or "",
			periodType = v20.periodType
		},
		freeTrialPrice = if not FFlagSupportFreeTrialPriceRow then nil else {
			"Feature.RobloxSubscription.Label.RobloxPlusPriceRowV2",
			boldStart = "<b>",
			boldEnd = "</b>",
			price = v16 or "",
			periodType = v20.periodType
		}
	})

	if not v16 or not v17 then
		return nil
	end

	local v22 = if not FFlagSupportFreeTrialPriceRow or not v18 then v21.price else v21.freeTrialPrice

	return React.createElement(View, {
		tag = "row auto-y size-full-0 align-y-center align-x-left gap-small",
		LayoutOrder = t1.layoutOrder
	}, {
		Price = React.createElement(FoundationText, {
			tag = "size-full-0 auto-y text-title-medium content-emphasis text-align-x-left",
			Text = v22,
			RichText = FFlagSupportFreeTrialPriceRow and not not v18 or nil
		})
	})
end

return RobloxSubscriptionPriceRow
