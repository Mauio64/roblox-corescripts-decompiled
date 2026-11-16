local FFlagRobloxSubscriptionProductsDirectFetch = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxSubscriptionProductsDirectFetch")
local engineFeature = game:GetEngineFeature("EnableSubscriptionFreeTrialOfferDetails")

return game:DefineFastFlag("RobloxPlusTrialDiscountTiming", false) and (engineFeature or FFlagRobloxSubscriptionProductsDirectFetch)
