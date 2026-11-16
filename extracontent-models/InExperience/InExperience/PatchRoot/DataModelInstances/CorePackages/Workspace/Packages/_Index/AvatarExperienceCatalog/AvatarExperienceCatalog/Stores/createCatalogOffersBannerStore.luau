local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local Players = game:GetService("Players")

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogOffersBannerMockApi = AvatarExperienceFlags.FFlagAXCatalogOffersBannerMockApi
local PurchasePromptLite = require(parent.PurchasePromptLite)
local Signals = require(parent.Signals)
require(parent.LuauPolyfill)

local Constants = require(AvatarExperienceCatalog.Constants)
local getMarketplaceOffersBanner = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.getMarketplaceOffersBanner)
local getMarketplaceOffersBanner2 = getMarketplaceOffersBanner.getMarketplaceOffersBanner
local mockGetOffersForUser = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.mockGetOffersForUser)
local mockGetOffersForUser2 = mockGetOffersForUser.mockGetOffersForUser
require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
local getLocalUserId = require(AvatarExperienceCatalog.Utils.getLocalUserId)

local function createCatalogOffersBannerStore()
	local signal, setPayload = Signals.createSignal(nil)
	local signal2, setDismissed = Signals.createSignal(false)
	local signal3, v = Signals.createSignal(false)
	local signal4, v2 = Signals.createSignal(false)

	local v3 = nil

	local function fetchOffers(callback, p)
		v3 = callback
		v(true)

		local flag = false
		local flag2 = false
		local v4 = nil

		local function finishOnce(flag3: boolean) -- 6 equivalent calls inferred from this helper
			if flag2 then
				return
			end

			flag2 = true
			v(false)

			if not flag3 then
				v2(true)
			end
		end

		local function cleanup()
			if flag then
				return
			end

			flag = true

			if v4 then
				v4()
			end

			finishOnce(true) -- inferred equivalent call
		end

		if FFlagAXCatalogOffersBannerMockApi then
			local v5, v6 = mockGetOffersForUser2()
			v4 = v6

			v5:andThen(function(p2)
				if not flag and p2 then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
					setPayload(p2)
				end

				finishOnce(flag) -- inferred equivalent call
			end):catch(function(p2)
				if not flag then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
					warn("[catalogOffersBannerStore] mock failed:", p2)
				end

				finishOnce(flag) -- inferred equivalent call
			end)
			return cleanup
		else
			local localUserId = getLocalUserId(Players)

			if localUserId == nil then
				warn("[catalogOffersBannerStore] no LocalPlayer; skipping offers fetch")
				finishOnce(false) -- inferred equivalent call
				return function() end
			else
				local marketplaceOffersBanner, v5 = getMarketplaceOffersBanner2(localUserId, callback, p)
				v4 = v5

				marketplaceOffersBanner:andThen(function(p2)
					if not flag then
						if p2 then
							sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
						end

						setPayload(p2)
					end

					finishOnce(flag) -- inferred equivalent call
				end):catch(function(p2)
					if not flag then
						sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
						warn("[catalogOffersBannerStore] fetch failed:", p2)
					end

					finishOnce(flag) -- inferred equivalent call
				end)
				return cleanup
			end
		end
	end

	PurchasePromptLite.Events.purchaseCompletedEvent:Connect(function()
		if not v3 or signal3(false) then
			return
		end

		fetchOffers(v3, "cart")
	end)
	return {
		getPayload = signal,
		setPayload = setPayload,
		getDismissed = signal2,
		setDismissed = setDismissed,
		getHasCompletedOffersFetch = signal4,
		getOffersFetchInProgress = signal3,
		fetchOffers = fetchOffers,
		notifyPurchaseCompleted = function() end
	}
end

return createCatalogOffersBannerStore
