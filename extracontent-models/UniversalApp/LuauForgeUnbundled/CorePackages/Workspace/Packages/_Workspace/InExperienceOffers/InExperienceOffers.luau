local module = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Api/getAllUserOffers")
local GetOffersStore = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Stores/GetOffersStore/createOffersStore")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/createOfferBadgeTextSignal")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOfferBadgeText")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getOffersForKey")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/getRemainingTimeText")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/hasOfferForAnyKey")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/isNotificationEligible")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Utils/selectActiveOffer")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Hooks/useOfferBadgeText")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Hooks/useOffersForKey")
local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Hooks/useRemainingTimeText")
local module13 = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Hooks/useShopHasItems")
require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Types")

return {
	getAllUserOffers = module,
	getOffersStore = GetOffersStore,
	FeatureKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/FeatureKey"),
	NotificationLocation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/NotificationLocation"),
	OfferStatuses = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceOffers/InExperienceOffers/Enums/OfferStatus"),
	Hooks = {
		useOfferBadgeText = module10,
		useOffersForKey = module11,
		useRemainingTimeText = module12,
		useShopHasItems = module13
	},
	Utils = {
		createOfferBadgeTextSignal = module3,
		getOfferBadgeText = module4,
		getOffersForKey = module5,
		getRemainingTimeText = module6,
		hasOfferForAnyKey = module7,
		isNotificationEligible = module8,
		selectActiveOffer = module9
	}
}
