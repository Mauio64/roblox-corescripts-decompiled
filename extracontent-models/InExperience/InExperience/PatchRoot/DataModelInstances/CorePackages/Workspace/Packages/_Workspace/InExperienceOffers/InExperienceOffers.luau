local getAllUserOffers = require(script.Api.getAllUserOffers)
local GetOffersStore = require(script.Stores.GetOffersStore)
require(script.Stores.GetOffersStore.createOffersStore)
local createOfferBadgeTextSignal = require(script.Utils.createOfferBadgeTextSignal)
local getOfferBadgeText = require(script.Utils.getOfferBadgeText)
local getOffersForKey = require(script.Utils.getOffersForKey)
local getRemainingTimeText = require(script.Utils.getRemainingTimeText)
local hasOfferForAnyKey = require(script.Utils.hasOfferForAnyKey)
local isNotificationEligible = require(script.Utils.isNotificationEligible)
local selectActiveOffer = require(script.Utils.selectActiveOffer)
local useOfferBadgeText = require(script.Hooks.useOfferBadgeText)
local useOffersForKey = require(script.Hooks.useOffersForKey)
local useRemainingTimeText = require(script.Hooks.useRemainingTimeText)
local useShopHasItems = require(script.Hooks.useShopHasItems)
require(script.Types)

return {
	getAllUserOffers = getAllUserOffers,
	getOffersStore = GetOffersStore,
	FeatureKeys = require(script.Enums.FeatureKey),
	NotificationLocation = require(script.Enums.NotificationLocation),
	OfferStatuses = require(script.Enums.OfferStatus),
	Hooks = {
		useOfferBadgeText = useOfferBadgeText,
		useOffersForKey = useOffersForKey,
		useRemainingTimeText = useRemainingTimeText,
		useShopHasItems = useShopHasItems
	},
	Utils = {
		createOfferBadgeTextSignal = createOfferBadgeTextSignal,
		getOfferBadgeText = getOfferBadgeText,
		getOffersForKey = getOffersForKey,
		getRemainingTimeText = getRemainingTimeText,
		hasOfferForAnyKey = hasOfferForAnyKey,
		isNotificationEligible = isNotificationEligible,
		selectActiveOffer = selectActiveOffer
	},
	["jest.config"] = script["jest.config"]
}
