local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local SignalsReact = require(parent.SignalsReact)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local View = Foundation.View
local Text = Foundation.Text

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local getPeriodTypeDisplayLabel = require(RobloxSubscriptionPurchaseApp.Utils.getPeriodTypeDisplayLabel)
local getFreeTrialOffer = require(RobloxSubscriptionPurchaseApp.Utils.getFreeTrialOffer)
local isSupportedTrialPeriodType = require(RobloxSubscriptionPurchaseApp.Utils.isSupportedTrialPeriodType)
local FFlagRobloxPlusDynamicFreeTrialLength = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusDynamicFreeTrialLength)

local function RobloxSubscriptionPriceRow(p)
	local v = RobloxSubscriptionStore.get()

	local v2 = SignalsReact.useSignalState(v.getRobloxSubscriptionProduct)

	local localizedPriceDisplayString = v2 and v2.LocalizedPriceDisplayString
	local periodType = v2 and v2.PeriodType
	local isFreeTrial = p.isFreeTrial == true
	local periodTypeDisplayLabel = getPeriodTypeDisplayLabel(periodType or "", false)
	local v3

	if FFlagRobloxPlusDynamicFreeTrialLength and isFreeTrial then
		v3 = getFreeTrialOffer(v2)
	end

	if v3 == nil or not isSupportedTrialPeriodType(v3.PeriodType) then
		v3 = nil
	end

	local trialDuration = not v3 and 1 or v3.Duration

	local v4 = { periodType = periodTypeDisplayLabel }

	if v3 then
		v4.trialPeriodLabel = getPeriodTypeDisplayLabel(v3.PeriodType, trialDuration > 1)
	end

	local v5 = useLocalization(v4)

	local v6 = useLocalization({
		price = {
			"Feature.RobloxSubscription.Label.BlackbirdPriceTag",
			price = localizedPriceDisplayString or "",
			periodType = v5.periodType
		},
		freeTrialPrice = {
			"Feature.RobloxSubscription.Label.RobloxPlusPriceRowV2",
			boldStart = "<b>",
			boldEnd = "</b>",
			price = localizedPriceDisplayString or "",
			periodType = v5.periodType
		},
		freeTrialPriceV3 = v3 and {
			"Feature.RobloxSubscription.Label.RobloxPlusPriceRowV3",
			boldStart = "<b>",
			boldEnd = "</b>",
			price = localizedPriceDisplayString or "",
			periodType = v5.periodType,
			trialDuration = trialDuration,
			trialPeriodLabel = v5.trialPeriodLabel
		} or nil
	})

	if not (localizedPriceDisplayString and periodType) then
		return nil
	end

	local text = if v3 then v6.freeTrialPriceV3 else v6.freeTrialPrice

	if not isFreeTrial then
		text = v6.price
	end

	return React.createElement(
		View,
		{
			tag = "row auto-y size-full-0 align-y-center align-x-left gap-small",
			LayoutOrder = p.layoutOrder
		},
		{
			Price = React.createElement(Text, {
				Text = text,
				tag = "size-full-0 auto-y text-title-medium content-emphasis text-align-x-left",
				RichText = isFreeTrial and true or nil
			})
		}
	)
end

return RobloxSubscriptionPriceRow
