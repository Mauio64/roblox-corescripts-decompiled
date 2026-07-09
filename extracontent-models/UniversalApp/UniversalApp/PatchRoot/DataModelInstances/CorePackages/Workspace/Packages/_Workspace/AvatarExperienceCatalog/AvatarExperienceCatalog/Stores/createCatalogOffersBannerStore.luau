local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Players = game:GetService("Players")
local sendAXCounterV2 = require(AvatarExperienceCatalogParent.AvatarExperienceAnalytics).sendAXCounterV2
local FFlagAXCatalogOffersBannerMockApi = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogOffersBannerMockApi
local FFlagPurchasePromptFetchCartPricing = require(AvatarExperienceCatalogParent.SharedFlags).FFlagPurchasePromptFetchCartPricing
local PurchasePromptLite = require(AvatarExperienceCatalogParent.PurchasePromptLite)
local Signals = require(AvatarExperienceCatalogParent.Signals)

require(AvatarExperienceCatalogParent.LuauPolyfill)

local Constants = require(AvatarExperienceCatalog.Constants)
local getMarketplaceOffersBanner = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.getMarketplaceOffersBanner).getMarketplaceOffersBanner
local mockGetOffersForUser = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.mockGetOffersForUser).mockGetOffersForUser

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)

local getLocalUserId = require(AvatarExperienceCatalog.Utils.getLocalUserId)

local function createCatalogOffersBannerStore() -- line: 55
	-- upvalues: Signals (copy), FFlagPurchasePromptFetchCartPricing (copy), FFlagAXCatalogOffersBannerMockApi (copy), mockGetOffersForUser (copy), sendAXCounterV2 (copy), Constants (copy), getLocalUserId (copy), Players (copy), getMarketplaceOffersBanner (copy), PurchasePromptLite (copy)
	local v14, v15 = Signals.createSignal(nil)
	local v16, v17 = Signals.createSignal(false)
	local v18, v19 = Signals.createSignal(false)
	local v20, v21 = Signals.createSignal(false)
	local u22 = nil

	local function fetchOffers(p1: ((...any) -> ...any), p2) -- line: 69
		-- upvalues: FFlagPurchasePromptFetchCartPricing (copy), u22 (ref), v19 (copy), v21 (copy), FFlagAXCatalogOffersBannerMockApi (copy), mockGetOffersForUser (copy), sendAXCounterV2 (copy), Constants (copy), v15 (copy), getLocalUserId (copy), Players (copy), getMarketplaceOffersBanner (copy)
		if FFlagPurchasePromptFetchCartPricing then
			u22 = p1
		end

		v19(true)

		local u26 = false
		local u27 = false
		local u28 = nil

		local function finishOnce(b1: boolean) -- line: 82
			-- upvalues: u27 (ref), v19 (copy), v21 (copy)
			if u27 then
				return
			end

			u27 = true
			v19(false)

			if not b1 then
				v21(true)
			end
		end
		local function cleanup() -- line: 93
			-- upvalues: u26 (ref), u28 (ref), u27 (ref), v19 (copy)
			if u26 then
				return
			end

			u26 = true

			if u28 then
				u28()
			end

			if u27 then
				return
			end

			u27 = true
			v19(false)
		end

		if FFlagAXCatalogOffersBannerMockApi then
			local v31, v32 = mockGetOffersForUser()

			u28 = v32
			v31:andThen(function(p3) -- line: 108
				-- upvalues: u26 (ref), sendAXCounterV2 (copy), Constants (copy), v15 (copy), u27 (ref), v19 (copy), v21 (copy)
				if not u26 and p3 then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
					v15(p3)
				end

				local v38 = u26

				if u27 then
					return
				end

				u27 = true
				v19(false)

				if not v38 then
					v21(true)
				end
			end):catch(function(p4) -- line: 115
				-- upvalues: u26 (ref), sendAXCounterV2 (copy), Constants (copy), u27 (ref), v19 (copy), v21 (copy)
				if not u26 then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
					warn("[catalogOffersBannerStore] mock failed:", p4)
				end

				local v40 = u26

				if u27 then
					return
				end

				u27 = true
				v19(false)

				if not v40 then
					v21(true)
				end
			end)

			return cleanup
		end

		local v33 = getLocalUserId(Players)

		if v33 == nil then
			warn("[catalogOffersBannerStore] no LocalPlayer; skipping offers fetch")

			if not u27 then
				u27 = true
				v19(false)
				v21(true)
			end

			return function() -- line: 129
			end
		end

		local v34, v35 = getMarketplaceOffersBanner(v33, p1, p2)

		u28 = v35
		v34:andThen(function(p5) -- line: 135
			-- upvalues: u26 (ref), sendAXCounterV2 (copy), Constants (copy), v15 (copy), u27 (ref), v19 (copy), v21 (copy)
			if not u26 then
				if p5 then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
				end

				v15(p5)
			end

			local v42 = u26

			if u27 then
				return
			end

			u27 = true
			v19(false)

			if not v42 then
				v21(true)
			end
		end):catch(function(p6) -- line: 144
			-- upvalues: u26 (ref), sendAXCounterV2 (copy), Constants (copy), u27 (ref), v19 (copy), v21 (copy)
			if not u26 then
				sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
				warn("[catalogOffersBannerStore] fetch failed:", p6)
			end

			local v44 = u26

			if u27 then
				return
			end

			u27 = true
			v19(false)

			if not v44 then
				v21(true)
			end
		end)

		return cleanup
	end

	if FFlagPurchasePromptFetchCartPricing then
		PurchasePromptLite.Events.purchaseCompletedEvent:Connect(function() -- line: 159
			-- upvalues: u22 (ref), v18 (copy), fetchOffers (copy)
			if not u22 then
				return
			end

			if v18(false) then
				return
			end

			fetchOffers(u22, "cart")
		end)
	end

	return {
		getPayload = v14,
		setPayload = v15,
		getDismissed = v16,
		setDismissed = v17,
		getHasCompletedOffersFetch = v20,
		getOffersFetchInProgress = v18,
		fetchOffers = fetchOffers,
		notifyPurchaseCompleted = function() -- line: 67
		end
	}
end

return createCatalogOffersBannerStore
