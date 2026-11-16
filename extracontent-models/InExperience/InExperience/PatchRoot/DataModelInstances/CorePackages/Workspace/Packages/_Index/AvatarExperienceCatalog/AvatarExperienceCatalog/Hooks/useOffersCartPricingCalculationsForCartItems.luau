local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local tutils = require(parent.tutils)
local SignalsReact = require(parent.SignalsReact)
local ToastRodux = require(parent.ToastRodux)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local postCartPricingForOffers = require(AvatarExperienceCatalog.Api.PostCartPricingForOffers.postCartPricingForOffers)
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
local decodeLuauUnicodeEscapes = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.decodeLuauUnicodeEscapes)

local ToastType = ToastRodux.Enums.ToastType
local DiscountTypeEnum = AvatarExperienceCommon.Enums.DiscountTypeEnum
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local Constants = AvatarExperienceCommon.Constants

local defineFastFlag = game:DefineFastFlag("AXDoNotPass356FetchCartPricing", false)

local function buildItemsForOffersCartPricingRequest(items)
	local itemsForOffersCartPricingRequest = {}

	for _, item in items do
		local v = item.selectedTimedOptionDays == nil or item.selectedTimedOptionDays == 0

		if not (not defineFastFlag or item.itemId ~= Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID) then
			continue
		end

		local v2 = {
			collectibleItemId = item.collectibleItemId,
			collectibleProductId = item.collectibleProductId,
			isPermanent = item.selectedTimedOptionDays == nil or item.selectedTimedOptionDays == 0,
			rentalDays = 0
		}
		local rentalDays

		if not v then
			rentalDays = item.selectedTimedOptionDays
		end

		v2.rentalDays = rentalDays
		table.insert(itemsForOffersCartPricingRequest, v2)
	end

	return itemsForOffersCartPricingRequest
end

local function getOffersAvailableMap(availableOffers)
	local offersAvailableMap = {}

	if availableOffers == nil then
		return offersAvailableMap
	end

	for _, item in availableOffers do
		offersAvailableMap[item.offerId] = item

		if item.localizedDescription then
			item.localizedDescription = decodeLuauUnicodeEscapes(item.localizedDescription)
		end
	end

	return offersAvailableMap
end

local function calculateTotalDiscountFromSelectedOffers(items, offersAvailableMap)
	local offerIdSet = {}

	for _, item in offersAvailableMap do
		if item.selected then
			offerIdSet[item.offerId] = true
		end
	end

	local totalDiscountFromSelectedOffers = 0

	for _, item in items do
		local discountInformation = item.discountInformation

		if not (discountInformation ~= nil and discountInformation.discounts ~= nil) then
			continue
		end

		for _, discount in discountInformation.discounts do
			if offerIdSet[discount.discountCampaign] then
				totalDiscountFromSelectedOffers += discount.robuxDiscountAmount
			end
		end
	end

	return totalDiscountFromSelectedOffers
end

local function getDiscountedItemsFromItemsData(items, offersAvailableMap)
	local discountedItems = {}

	for _, item in items do
		local discountCampaigns = {}

		if item.discountInformation and item.discountInformation.discounts then
			for _, discount in item.discountInformation.discounts do
				if
					offersAvailableMap[discount.discountCampaign]
					and offersAvailableMap[discount.discountCampaign].selected
				then
					table.insert(discountCampaigns, discount.discountCampaign)
				end
			end
		end

		discountedItems[item.collectibleItemId] = {
			collectibleItemId = item.collectibleItemId,
			priceInRobux = item.priceInRobux,
			discountInformation = item.discountInformation,
			offerIdsApplied = discountCampaigns
		}
	end

	return discountedItems
end

local function getAllDiscountSummaryEntries(items, offersAvailableMap)
	local allDiscountSummaryEntries = {}

	for _, item in items do
		local discountInformation = item.discountInformation

		if not (discountInformation ~= nil and discountInformation.discounts ~= nil) then
			continue
		end

		for _, discount in discountInformation.discounts do
			if offersAvailableMap[discount.discountCampaign] ~= nil then
				table.insert(allDiscountSummaryEntries, {
					type = DiscountTypeEnum.Uncategorized,
					amountInRobux = discount.robuxDiscountAmount,
					percent = discount.robuxDiscountPercentage,
					localizedDiscountAttribution = discount.localizedDiscountAttribution
				})
			end
		end
	end

	return allDiscountSummaryEntries
end

local v = {}

local function useOffersCartPricingCalculationsForCartItems(p, flag: boolean, flag2: boolean)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v2 = useNetworking()
	local v3 = useDispatch()

	local v4 = useSignalState(catalogOffersBannerStore.getPayload)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(0)

	local state5, setState5 = React.useState({})
	local ref = React.useRef(false)

	local itemsForOffersCartPricingRequest = buildItemsForOffersCartPricingRequest(p)
	local ref2 = React.useRef({})

	local v5 = useLocalization({
		fetchFailed = "Feature.Catalog.Title.Checkout.OfferFailedToFetch",
		toggleFailed = "Feature.Catalog.Title.Checkout.OfferFailedToUpdate"
	})

	local v6 = React.useCallback(function(toastMessage)
		v3(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = toastMessage,
			toastType = ToastType.NetworkingError
		}))
	end, { v3 })

	React.useEffect(function()
		if
			not v4
			or not flag2
			or #itemsForOffersCartPricingRequest == 0
			or tutils.deepEqual(itemsForOffersCartPricingRequest, ref2.current)
		then
			return
		end

		ref2.current = itemsForOffersCartPricingRequest

		local v7, _ = postCartPricingForOffers(v2, {
			items = itemsForOffersCartPricingRequest,
			featureKey = "MARKETPLACE_CART",
			unselectedOffers = Cryo.Dictionary.keys(v)
		})

		v7:andThen(function(data)
			if not (data and data.items) then
				mutedError("marketplace-sales/v1/cart-pricing did not return items in payload")

				return
			end

			local offersAvailableMap = getOffersAvailableMap(data.availableOffers)
			setState(data.savingsSummary)
			setState2(offersAvailableMap)
			setState3(getDiscountedItemsFromItemsData(data.items, offersAvailableMap))
			setState4(calculateTotalDiscountFromSelectedOffers(data.items, offersAvailableMap))

			setState5(getAllDiscountSummaryEntries(data.items, offersAvailableMap))
		end):catch(function(_)
			v6(v5.fetchFailed)
		end)
	end, { v2, itemsForOffersCartPricingRequest, v4, flag2, v6, v5 })

	React.useEffect(function()
		if not flag then
			ref2.current = {}
			setState(nil)
			setState2({})
			setState3({})
			setState4(0)
			setState5({})
		end
	end, { flag })

	local handleDeselectOfferId = React.useCallback(function(p2)
		if ref.current then
			return
		end

		ref.current = true

		local clone = table.clone(v)

		if v[p2] then
			v[p2] = nil
		else
			v[p2] = true
		end

		local v7, _ = postCartPricingForOffers(v2, {
			items = itemsForOffersCartPricingRequest,
			featureKey = "MARKETPLACE_CART",
			unselectedOffers = Cryo.Dictionary.keys(v)
		})

		v7:andThen(function(data)
			if data and data.items then
				local offersAvailableMap = getOffersAvailableMap(data.availableOffers)
				setState(data.savingsSummary)
				setState2(offersAvailableMap)
				setState3(getDiscountedItemsFromItemsData(data.items, offersAvailableMap))
				setState4(calculateTotalDiscountFromSelectedOffers(data.items, offersAvailableMap))

				setState5(getAllDiscountSummaryEntries(data.items, offersAvailableMap))
			else
				mutedError("marketplace-sales/v1/cart-pricing did not return items in payload")
			end

			ref.current = false
		end):catch(function(_)
			v = clone
			v6(v5.toggleFailed)

			ref.current = false
		end)
	end, { v2, itemsForOffersCartPricingRequest, v6, v5 })
	local savingsSummary

	if state then
		savingsSummary = decodeLuauUnicodeEscapes(state)
	end

	return {
		offersAvailable = state2,
		discountedItemsFromOffers = state3,
		totalSelectedOffersDiscount = state4,
		discountSummaryEntriesFromOffers = state5,
		savingsSummary = savingsSummary,
		handleDeselectOfferId = handleDeselectOfferId
	}
end

return useOffersCartPricingCalculationsForCartItems
