local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Loggers").mutedError
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/tutils")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SignalsReact")
local ToastRodux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/ToastRodux")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Localization").Hooks.useLocalization

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local postCartPricingForOffers = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/postCartPricingForOffers")
local useAXCatalogStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Context/useAXCatalogStoreContext")
local decodeLuauUnicodeEscapes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/decodeLuauUnicodeEscapes")

local toastType = ToastRodux.Enums.ToastType
local discountTypeEnum = AvatarExperienceCommon.Enums.DiscountTypeEnum
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local setCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local constants = AvatarExperienceCommon.Constants

local defineFastFlag = game:DefineFastFlag("AXDoNotPass356FetchCartPricing", false)

local function buildItemsForOffersCartPricingRequest(items)
	local itemsForOffersCartPricingRequest = {}

	for k, item in items do
		local v5 = item.selectedTimedOptionDays == nil or item.selectedTimedOptionDays == 0

		if not (not defineFastFlag or item.itemId ~= constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID) then
			continue
		end

		local v6 = {
			collectibleItemId = item.collectibleItemId,
			collectibleProductId = item.collectibleProductId,
			isPermanent = item.selectedTimedOptionDays == nil or item.selectedTimedOptionDays == 0,
			rentalDays = 0
		}
		local v7 = if not v5 then item.selectedTimedOptionDays else nil
		v6.rentalDays = v7
		table.insert(itemsForOffersCartPricingRequest, v6)
	end

	return itemsForOffersCartPricingRequest
end

local function getOffersAvailableMap(availableOffers)
	local offersAvailableMap = {}

	if availableOffers == nil then
		return offersAvailableMap
	end

	for k, item in availableOffers do
		offersAvailableMap[item.offerId] = item

		if item.localizedDescription then
			item.localizedDescription = decodeLuauUnicodeEscapes(item.localizedDescription)
		end
	end

	return offersAvailableMap
end

local function calculateTotalDiscountFromSelectedOffers(items, offersAvailableMap)
	local offerIdSet = {}

	for k, item in offersAvailableMap do
		if item.selected then
			offerIdSet[item.offerId] = true
		end
	end

	local totalDiscountFromSelectedOffers = 0

	for k, item in items do
		local discountInformation = item.discountInformation

		if not (discountInformation ~= nil and discountInformation.discounts ~= nil) then
			continue
		end

		for k2, discount in discountInformation.discounts do
			if offerIdSet[discount.discountCampaign] then
				totalDiscountFromSelectedOffers += discount.robuxDiscountAmount
			end
		end
	end

	return totalDiscountFromSelectedOffers
end

local function getDiscountedItemsFromItemsData(items, offersAvailableMap)
	local discountedItems = {}

	for k, item in items do
		local discountCampaigns = {}

		if item.discountInformation and item.discountInformation.discounts then
			for k2, discount in item.discountInformation.discounts do
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

	for k, item in items do
		local discountInformation = item.discountInformation

		if not (discountInformation ~= nil and discountInformation.discounts ~= nil) then
			continue
		end

		for k2, discount in discountInformation.discounts do
			if offersAvailableMap[discount.discountCampaign] ~= nil then
				table.insert(allDiscountSummaryEntries, {
					type = discountTypeEnum.Uncategorized,
					amountInRobux = discount.robuxDiscountAmount,
					percent = discount.robuxDiscountPercentage,
					localizedDiscountAttribution = discount.localizedDiscountAttribution
				})
			end
		end
	end

	return allDiscountSummaryEntries
end

local v5 = {}

local function useOffersCartPricingCalculationsForCartItems(p2, p3, p4)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v6 = useNetworking()
	local v7 = useDispatch()

	local v8 = useSignalState(catalogOffersBannerStore.getPayload)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState({})
	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(0)

	local state5, setState5 = React.useState({})
	local ref = React.useRef(false)

	local itemsForOffersCartPricingRequest = buildItemsForOffersCartPricingRequest(p2)
	local ref2 = React.useRef({})

	local v9 = useLocalization({
		fetchFailed = "Feature.Catalog.Title.Checkout.OfferFailedToFetch",
		toggleFailed = "Feature.Catalog.Title.Checkout.OfferFailedToUpdate"
	})

	local v10 = React.useCallback(function(p5)
		v7(setCurrentToastMessage({
			isLocalized = true,
			toastMessage = p5,
			toastType = toastType.NetworkingError
		}))
	end, { v7 })

	React.useEffect(function()
		if
			not v8
			or not p4
			or #itemsForOffersCartPricingRequest == 0
			or tutils.deepEqual(itemsForOffersCartPricingRequest, ref2.current)
		then
			return
		end

		ref2.current = itemsForOffersCartPricingRequest

		local v11, v12 = postCartPricingForOffers(v6, {
			items = itemsForOffersCartPricingRequest,
			featureKey = "MARKETPLACE_CART",
			unselectedOffers = Cryo.Dictionary.keys(v5)
		})

		v11:andThen(function(data)
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
		end):catch(function(p5)
			v10(v9.fetchFailed)
		end)
	end, { v6, itemsForOffersCartPricingRequest, v8, p4, v10, v9 })

	React.useEffect(function()
		if not p3 then
			ref2.current = {}
			setState(nil)
			setState2({})
			setState3({})
			setState4(0)
			setState5({})
		end
	end, { p3 })

	local v11 = React.useCallback(function(p5)
		if ref.current then
			return
		end

		ref.current = true

		local clone = table.clone(v5)

		if v5[p5] then
			v5[p5] = nil
		else
			v5[p5] = true
		end

		local v12, v13 = postCartPricingForOffers(v6, {
			items = itemsForOffersCartPricingRequest,
			featureKey = "MARKETPLACE_CART",
			unselectedOffers = Cryo.Dictionary.keys(v5)
		})

		v12:andThen(function(data)
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
		end):catch(function(p6)
			v5 = clone
			v10(v9.toggleFailed)

			ref.current = false
		end)
	end, { v6, itemsForOffersCartPricingRequest, v10, v9 })

	local v13 = if state then decodeLuauUnicodeEscapes(state) else nil
	return {
		offersAvailable = state2,
		discountedItemsFromOffers = state3,
		totalSelectedOffersDiscount = state4,
		discountSummaryEntriesFromOffers = state5,
		savingsSummary = v13,
		handleDeselectOfferId = v11
	}
end

return useOffersCartPricingCalculationsForCartItems
