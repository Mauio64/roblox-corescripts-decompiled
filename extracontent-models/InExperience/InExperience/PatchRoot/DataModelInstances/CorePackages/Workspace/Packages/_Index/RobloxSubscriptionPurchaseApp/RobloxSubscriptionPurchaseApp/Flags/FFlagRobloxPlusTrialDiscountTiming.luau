local FFlagRobloxSubscriptionProductsDirectFetch = require(script.Parent.FFlagRobloxSubscriptionProductsDirectFetch)
local engineFeature = game:GetEngineFeature("EnableSubscriptionFreeTrialOfferDetails")

return game:DefineFastFlag("RobloxPlusTrialDiscountTiming", false)
	and (engineFeature or FFlagRobloxSubscriptionProductsDirectFetch)
