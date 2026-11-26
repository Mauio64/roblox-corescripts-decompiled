local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local view = Foundation.View
local text = Foundation.Text

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local getPeriodTypeDisplayLabel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getPeriodTypeDisplayLabel")
local getFreeTrialOffer = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getFreeTrialOffer")
local isSupportedTrialPeriodType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isSupportedTrialPeriodType")
local FFlagRobloxPlusDynamicFreeTrialLength = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusDynamicFreeTrialLength")

local function RobloxSubscriptionPriceRow(p2)
	local v5 = RobloxSubscriptionStore.get()

	local v6 = SignalsReact.useSignalState(v5.getRobloxSubscriptionProduct)

	local localizedPriceDisplayString = v6 and v6.LocalizedPriceDisplayString
	local periodType = v6 and v6.PeriodType
	local isFreeTrial = p2.isFreeTrial == true
	local v7 = getPeriodTypeDisplayLabel(periodType or "", false)

	local v8 = if FFlagRobloxPlusDynamicFreeTrialLength and isFreeTrial then getFreeTrialOffer(v6) else nil

	if v8 == nil or not isSupportedTrialPeriodType(v8.PeriodType) then
		v8 = nil
	end

	local v9 = not v8 and 1 or v8.Duration

	local v10 = { periodType = v7 }

	if v8 then
		v10.trialPeriodLabel = getPeriodTypeDisplayLabel(v8.PeriodType, v9 > 1)
	end

	local v11 = useLocalization(v10)

	local v12 = useLocalization({
		price = {
			"Feature.RobloxSubscription.Label.BlackbirdPriceTag",
			price = localizedPriceDisplayString or "",
			periodType = v11.periodType
		},
		freeTrialPrice = {
			"Feature.RobloxSubscription.Label.RobloxPlusPriceRowV2",
			boldStart = "<b>",
			boldEnd = "</b>",
			price = localizedPriceDisplayString or "",
			periodType = v11.periodType
		},
		freeTrialPriceV3 = v8 and {
			"Feature.RobloxSubscription.Label.RobloxPlusPriceRowV3",
			boldStart = "<b>",
			boldEnd = "</b>",
			price = localizedPriceDisplayString or "",
			periodType = v11.periodType,
			trialDuration = v9,
			trialPeriodLabel = v11.trialPeriodLabel
		} or nil
	})

	if not (localizedPriceDisplayString and periodType) then
		return nil
	end

	local v13 = if v8 then v12.freeTrialPriceV3 else v12.freeTrialPrice

	if not isFreeTrial then
		v13 = v12.price
	end

	return React.createElement(
		view,
		{
			tag = "row auto-y size-full-0 align-y-center align-x-left gap-small",
			LayoutOrder = p2.layoutOrder
		},
		{
			Price = React.createElement(text, {
				Text = v13,
				tag = "size-full-0 auto-y text-title-medium content-emphasis text-align-x-left",
				RichText = isFreeTrial and true or nil
			})
		}
	)
end

return RobloxSubscriptionPriceRow
