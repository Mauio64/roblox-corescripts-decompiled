local FFlagRobloxSubscriptionProductsDirectFetch = require(script.Parent.FFlagRobloxSubscriptionProductsDirectFetch)
local engineFeature = game:GetEngineFeature("EnableSubscriptionFreeTrialOfferDetails")

return game:DefineFastFlag("RobloxPlusDynamicFreeTrialLength", false)
	and (engineFeature or FFlagRobloxSubscriptionProductsDirectFetch)
