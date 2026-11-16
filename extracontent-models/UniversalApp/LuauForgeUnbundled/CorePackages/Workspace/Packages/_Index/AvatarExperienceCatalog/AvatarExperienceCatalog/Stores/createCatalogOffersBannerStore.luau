local Players = game:GetService("Players")

local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").sendAXCounterV2
local fFlagAXCatalogOffersBannerMockApi = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogOffersBannerMockApi
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/PurchasePromptLite")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")
local getMarketplaceOffersBanner = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/getMarketplaceOffersBanner").getMarketplaceOffersBanner
local mockGetOffersForUser = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/mockGetOffersForUser").mockGetOffersForUser
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getLocalUserId")

local function createCatalogOffersBannerStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(false)
	local signal3, v7 = Signals.createSignal(false)
	local signal4, v8 = Signals.createSignal(false)

	local v9 = nil

	local function fetchOffers(p2, p3)
		v9 = p2
		v7(true)

		local flag = false
		local flag2 = false
		local v10 = nil

		local function finishOnce(p4)
			if flag2 then
				return
			end

			flag2 = true
			v7(false)

			if not p4 then
				v8(true)
			end
		end

		local function cleanup()
			if flag then
				return
			end

			flag = true

			if v10 then
				v10()
			end

			if flag2 then
				return
			end

			flag2 = true
			v7(false)
		end

		if fFlagAXCatalogOffersBannerMockApi then
			local v11, v12 = mockGetOffersForUser()
			v10 = v12

			v11:andThen(function(p4)
				if not flag and p4 then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
					v5(p4)
				end

				local v13 = flag

				if flag2 then
					return
				end

				flag2 = true
				v7(false)

				if not v13 then
					v8(true)
				end
			end):catch(function(p4)
				if not flag then
					sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
					warn("[catalogOffersBannerStore] mock failed:", p4)
				end

				local v13 = flag

				if flag2 then
					return
				end

				flag2 = true
				v7(false)

				if not v13 then
					v8(true)
				end
			end)
			return cleanup
		else
			local v11 = getLocalUserId(Players)

			if v11 == nil then
				warn("[catalogOffersBannerStore] no LocalPlayer; skipping offers fetch")

				if not flag2 then
					flag2 = true
					v7(false)

					v8(true)
				end

				return function() end
			else
				local marketplaceOffersBanner, v12 = getMarketplaceOffersBanner(v11, p2, p3)
				v10 = v12

				marketplaceOffersBanner:andThen(function(p4)
					if not flag then
						if p4 then
							sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchSucceeded)
						end

						v5(p4)
					end

					local v13 = flag

					if flag2 then
						return
					end

					flag2 = true
					v7(false)

					if not v13 then
						v8(true)
					end
				end):catch(function(p4)
					if not flag then
						sendAXCounterV2(Constants.COUNTERS.CatalogOffersBanner.fetchFailed)
						warn("[catalogOffersBannerStore] fetch failed:", p4)
					end

					local v13 = flag

					if flag2 then
						return
					end

					flag2 = true
					v7(false)

					if not v13 then
						v8(true)
					end
				end)
				return cleanup
			end
		end
	end

	PurchasePromptLite.Events.purchaseCompletedEvent:Connect(function()
		if not v9 or signal3(false) then
			return
		end

		fetchOffers(v9, "cart")
	end)
	return {
		getPayload = signal,
		setPayload = v5,
		getDismissed = signal2,
		setDismissed = v6,
		getHasCompletedOffersFetch = signal4,
		getOffersFetchInProgress = signal3,
		fetchOffers = fetchOffers,
		notifyPurchaseCompleted = function() end
	}
end

return createCatalogOffersBannerStore
