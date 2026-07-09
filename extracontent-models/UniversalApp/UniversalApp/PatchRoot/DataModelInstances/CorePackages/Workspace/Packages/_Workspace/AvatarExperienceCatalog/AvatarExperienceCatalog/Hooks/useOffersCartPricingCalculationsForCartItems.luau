local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Cryo = require(AvatarExperienceCatalogParent.Cryo)
local React = require(AvatarExperienceCatalogParent.React)
local RoactUtils = require(AvatarExperienceCatalogParent.RoactUtils)
local mutedError = require(AvatarExperienceCatalogParent.Loggers).mutedError
local tutils = require(AvatarExperienceCatalogParent.tutils)
local SignalsReact = require(AvatarExperienceCatalogParent.SignalsReact)
local ToastRodux = require(AvatarExperienceCatalogParent.ToastRodux)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local useLocalization = require(AvatarExperienceCatalogParent.Localization).Hooks.useLocalization
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local postCartPricingForOffers = require(AvatarExperienceCatalog.Api.PostCartPricingForOffers.postCartPricingForOffers)
local useAXCatalogStoreContext = require(AvatarExperienceCatalog.Context.useAXCatalogStoreContext)
local decodeLuauUnicodeEscapes = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.decodeLuauUnicodeEscapes)
local ToastType = ToastRodux.Enums.ToastType
local DiscountTypeEnum = AvatarExperienceCommon.Enums.DiscountTypeEnum
local useSignalState = SignalsReact.useSignalState
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local function buildItemsForOffersCartPricingRequest(p1) -- line: 28
	local t1 = {}

	for _, v31 in p1 do
		local v32 = v31.selectedTimedOptionDays == nil or v31.selectedTimedOptionDays == 0

		table.insert(t1, {
			collectibleItemId = v31.collectibleItemId,
			collectibleProductId = v31.collectibleProductId,
			isPermanent = v31.selectedTimedOptionDays == nil or v31.selectedTimedOptionDays == 0,
			rentalDays = if v32 then nil else v31.selectedTimedOptionDays
		})
	end

	return t1
end
local function getOffersAvailableMap(p2) -- line: 43
	-- upvalues: decodeLuauUnicodeEscapes (copy)
	local t2 = {}

	if p2 ~= nil then
		for _, v36 in p2 do
			t2[v36.offerId] = v36

			if v36.localizedDescription then
				v36.localizedDescription = decodeLuauUnicodeEscapes(v36.localizedDescription)
			end
		end
	end

	return t2
end
local function calculateTotalDiscountFromSelectedOffers(p3, p4) -- line: 56
	local t3 = {}

	for _, v41 in p4 do
		if v41.selected then
			t3[v41.offerId] = true
		end
	end

	local n1 = 0

	for _, v44 in p3 do
		local discountInformation = v44.discountInformation

		if discountInformation ~= nil and discountInformation.discounts ~= nil then
			for _, v47 in discountInformation.discounts do
				if t3[v47.discountCampaign] then
					n1 += v47.robuxDiscountAmount
				end
			end
		end
	end

	return n1
end
local function getDiscountedItemsFromItemsData(p5, p6) -- line: 79
	local t4 = {}

	for _, v52 in p5 do
		local t5 = {}

		if v52.discountInformation and v52.discountInformation.discounts then
			for _, v55 in v52.discountInformation.discounts do
				if p6[v55.discountCampaign] and p6[v55.discountCampaign].selected then
					table.insert(t5, v55.discountCampaign)
				end
			end
		end

		t4[v52.collectibleItemId] = {
			collectibleItemId = v52.collectibleItemId,
			priceInRobux = v52.priceInRobux,
			discountInformation = v52.discountInformation,
			offerIdsApplied = t5
		}
	end

	return t4
end
local function getAllDiscountSummaryEntries(p7, p8) -- line: 105
	-- upvalues: DiscountTypeEnum (copy)
	local t6 = {}

	for _, v60 in p7 do
		local discountInformation = v60.discountInformation

		if discountInformation ~= nil and discountInformation.discounts ~= nil then
			for _, v63 in discountInformation.discounts do
				if p8[v63.discountCampaign] ~= nil then
					table.insert(t6, {
						type = DiscountTypeEnum.Uncategorized,
						amountInRobux = v63.robuxDiscountAmount,
						percent = v63.robuxDiscountPercentage,
						localizedDiscountAttribution = v63.localizedDiscountAttribution
					})
				end
			end
		end
	end

	return t6
end

local t7 = {}

local function useOffersCartPricingCalculationsForCartItems(p9, b1: boolean, b2: boolean) -- line: 130
	-- upvalues: useAXCatalogStoreContext (copy), useNetworking (copy), useDispatch (copy), useSignalState (copy), React (copy), buildItemsForOffersCartPricingRequest (copy), useLocalization (copy), ToastType (copy), SetCurrentToastMessage (copy), tutils (copy), postCartPricingForOffers (copy), Cryo (copy), t7 (ref), getOffersAvailableMap (copy), getDiscountedItemsFromItemsData (copy), calculateTotalDiscountFromSelectedOffers (copy), getAllDiscountSummaryEntries (copy), mutedError (copy), decodeLuauUnicodeEscapes (copy)
	local catalogOffersBannerStore = useAXCatalogStoreContext().catalogOffersBannerStore
	local v68 = useNetworking()
	local v69 = useDispatch()
	local v70 = useSignalState(catalogOffersBannerStore.getPayload)
	local v71, v72 = React.useState(nil)
	local v73, v74 = React.useState({})
	local v75, v76 = React.useState({})
	local v77, v78 = React.useState(0)
	local v79, v80 = React.useState({})
	local v81 = React.useRef(false)
	local v82 = buildItemsForOffersCartPricingRequest(p9)
	local v83 = React.useRef({})
	local v84 = useLocalization({
		fetchFailed = "Feature.Catalog.Title.Checkout.OfferFailedToFetch",
		toggleFailed = "Feature.Catalog.Title.Checkout.OfferFailedToUpdate"
	})
	local v85 = React.useCallback(function(p10) -- line: 156
		-- upvalues: ToastType (copy), v69 (copy), SetCurrentToastMessage (copy)
		local t8 = {
			isLocalized = true,
			toastMessage = p10,
			toastType = ToastType.NetworkingError
		}

		v69(SetCurrentToastMessage(t8))
	end, { v69 })

	React.useEffect(function() -- line: 165
		-- upvalues: v70 (copy), b2 (copy), v82 (copy), tutils (copy), v83 (copy), postCartPricingForOffers (copy), v68 (copy), Cryo (copy), t7 (ref), getOffersAvailableMap (copy), v72 (copy), v74 (copy), v76 (copy), getDiscountedItemsFromItemsData (copy), v78 (copy), calculateTotalDiscountFromSelectedOffers (copy), v80 (copy), getAllDiscountSummaryEntries (copy), mutedError (copy), v85 (copy), v84 (copy)
		if not v70 or (not b2 or #v82 == 0 or tutils.deepEqual(v82, v83.current)) then
			return
		end

		v83.current = v82

		local v89, _ = postCartPricingForOffers(v68, {
			featureKey = "MARKETPLACE_CART",
			items = v82,
			unselectedOffers = Cryo.Dictionary.keys(t7)
		})

		v89:andThen(function(p11) -- line: 183
			-- upvalues: getOffersAvailableMap (copy), v72 (copy), v74 (copy), v76 (copy), getDiscountedItemsFromItemsData (copy), v78 (copy), calculateTotalDiscountFromSelectedOffers (copy), v80 (copy), getAllDiscountSummaryEntries (copy), mutedError (copy)
			if p11 and p11.items then
				local v96 = getOffersAvailableMap(p11.availableOffers)

				v72(p11.savingsSummary)
				v74(v96)
				v76((getDiscountedItemsFromItemsData(p11.items, v96)))
				v78((calculateTotalDiscountFromSelectedOffers(p11.items, v96)))
				v80((getAllDiscountSummaryEntries(p11.items, v96)))

				return
			end

			mutedError("marketplace-sales/v1/cart-pricing did not return items in payload")
		end):catch(function(_) -- line: 197
			-- upvalues: v85 (copy), v84 (copy)
			v85(v84.fetchFailed)
		end)
	end, {
		v68,
		v82,
		v70,
		b2,
		v85,
		v84
	})
	React.useEffect(function() -- line: 209
		-- upvalues: b1 (copy), v83 (copy), v72 (copy), v74 (copy), v76 (copy), v78 (copy), v80 (copy)
		if not b1 then
			v83.current = {}
			v72(nil)
			v74({})
			v76({})
			v78(0)
			v80({})
		end
	end, { b1 })

	local v86 = React.useCallback(function(p13) -- line: 221
		-- upvalues: v81 (copy), t7 (ref), postCartPricingForOffers (copy), v68 (copy), v82 (copy), Cryo (copy), getOffersAvailableMap (copy), v72 (copy), v74 (copy), v76 (copy), getDiscountedItemsFromItemsData (copy), v78 (copy), calculateTotalDiscountFromSelectedOffers (copy), v80 (copy), getAllDiscountSummaryEntries (copy), mutedError (copy), v85 (copy), v84 (copy)
		if v81.current then
			return
		end

		v81.current = true

		local v92 = table.clone(t7)

		if t7[p13] then
			t7[p13] = nil
		else
			t7[p13] = true
		end

		local v93, _ = postCartPricingForOffers(v68, {
			featureKey = "MARKETPLACE_CART",
			items = v82,
			unselectedOffers = Cryo.Dictionary.keys(t7)
		})

		v93:andThen(function(p14) -- line: 243
			-- upvalues: getOffersAvailableMap (copy), v72 (copy), v74 (copy), v76 (copy), getDiscountedItemsFromItemsData (copy), v78 (copy), calculateTotalDiscountFromSelectedOffers (copy), v80 (copy), getAllDiscountSummaryEntries (copy), mutedError (copy), v81 (copy)
			if p14 and p14.items then
				local v99 = getOffersAvailableMap(p14.availableOffers)

				v72(p14.savingsSummary)
				v74(v99)
				v76((getDiscountedItemsFromItemsData(p14.items, v99)))
				v78((calculateTotalDiscountFromSelectedOffers(p14.items, v99)))
				v80((getAllDiscountSummaryEntries(p14.items, v99)))
			else
				mutedError("marketplace-sales/v1/cart-pricing did not return items in payload")
			end

			v81.current = false
		end):catch(function(_) -- line: 259
			-- upvalues: t7 (ref), v92 (copy), v85 (copy), v84 (copy), v81 (copy)
			t7 = v92
			v85(v84.toggleFailed)
			v81.current = false
		end)
	end, {
		v68,
		v82,
		v85,
		v84
	})

	return {
		offersAvailable = v73,
		discountedItemsFromOffers = v75,
		totalSelectedOffersDiscount = v77,
		discountSummaryEntriesFromOffers = v79,
		savingsSummary = if not v71 then nil else decodeLuauUnicodeEscapes(v71),
		handleDeselectOfferId = v86
	}
end

return useOffersCartPricingCalculationsForCartItems
