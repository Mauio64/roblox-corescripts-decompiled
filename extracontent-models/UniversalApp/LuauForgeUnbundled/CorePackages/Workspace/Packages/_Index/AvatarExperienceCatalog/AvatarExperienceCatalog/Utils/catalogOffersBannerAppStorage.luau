local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local safeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Lib.SafeAppStorageService
local fFlagAXCatalogOffersDismissedStorageKeyFix = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXCatalogOffersDismissedStorageKeyFix
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local marketplaceOffersBannerDisplay = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/marketplaceOffersBannerDisplay")
local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getLocalUserId")

local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle
local v5 = fFlagAXCatalogOffersDismissedStorageKeyFix and "AXCatalogOffersDismissed"
	or "AXCatalogOffersBannerDismissed"
local defineFastFlag = game:DefineFastFlag("AXCatalogOffersBannerAppStorageUseMemStorage", false)

local function normalizeOfferId(value)
	return value or ""
end

local function offerIdMapContains(p2, p3): boolean
	return p2[p3] == true
end

local function coerceDecodedToOfferIdMapStorage(items)
	if typeof(items) ~= "table" then
		return nil
	end

	local result = {}
	local flag = false

	for k, item in items do
		if not (typeof(k) == "string" and typeof(item) == "table") then
			continue
		end

		local set = {}

		for k2, v6 in item do
			if typeof(k2) == "string" and v6 == true then
				set[k2] = true
			end
		end

		result[k] = set
		flag = true
	end

	if flag then
		return result
	end

	return nil
end

local function readStorageRecord(p2, coerceDecodedToOfferIdMapStorage2)
	local item = safeAppStorageService.getItem(p2, defineFastFlag)

	if not item or item == "" then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(item)
	end)

	if success then
		return coerceDecodedToOfferIdMapStorage2(result)
	end

	return nil
end

local function resolveVisibleOffer(p2)
	local v6 = getLocalUserId(Players)

	local v7 = {}

	if v6 ~= nil then
		local v8 = readStorageRecord(v5, coerceDecodedToOfferIdMapStorage)

		if v8 and v8[v6] then
			v7 = v8[v6]
		end
	end

	for k, offer in p2.offers do
		local marketplaceOffersBannerOfferDisplayTitle = getMarketplaceOffersBannerOfferDisplayTitle(offer)

		if not (marketplaceOffersBannerOfferDisplayTitle and marketplaceOffersBannerOfferDisplayTitle ~= "") then
			continue
		end

		local v8 = getMarketplaceOffersBannerOfferDisplayId(offer) or ""

		if v6 == nil or v7[v8] ~= true then
			return offer
		end
	end

	return nil
end

return {
	STORAGE_KEY = v5,
	SHEET_FTUX_STORAGE_KEY = "AXCatalogOffersSheetFTUX",
	readDismissStorage = function()
		return readStorageRecord(v5, coerceDecodedToOfferIdMapStorage)
	end,
	readSheetFtuxStorage = function()
		return readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage)
	end,
	dismissRecordMatchesPayload = function(p2, p3): boolean
		local offerId = p3.offerId or ""
		return p2[p3.userId] ~= nil and p2[p3.userId][offerId] == true
	end,
	dismissedOfferIdsContains = offerIdMapContains,
	normalizeOfferIdForStorage = normalizeOfferId,
	resolveVisibleOffer = resolveVisibleOffer,
	shouldHydrateDismissed = function(p2): boolean
		if getLocalUserId(Players) == nil then
			return false
		end

		return resolveVisibleOffer(p2) == nil
	end,
	shouldAutoOpenOfferSheetForCurrentOffer = function(value): boolean
		local v6 = getLocalUserId(Players)

		if v6 == nil then
			return false
		end

		local v7 = readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage)

		if v7 == nil or v7[v6] == nil then
			return true
		end

		return v7[v6][value or ""] ~= true
	end,
	writeDismissedForCurrentOffer = function(value)
		local v6 = getLocalUserId(Players)

		if v6 == nil then
			return
		end

		local v7 = value or ""

		local v8 = readStorageRecord(v5, coerceDecodedToOfferIdMapStorage) or {}
		local v9 = v8[v6]

		if v9 == nil then
			v9 = {}
			v8[v6] = v9
		end

		v9[v7] = true
		pcall(function()
			local jsonEncode = HttpService:JSONEncode(v8)
			safeAppStorageService.setItem(v5, jsonEncode, defineFastFlag)
			safeAppStorageService.flush()
		end)
	end,
	writeSeenOfferSheetForCurrentOffer = function(value)
		local v6 = getLocalUserId(Players)

		if v6 == nil then
			return
		end

		local v7 = value or ""

		local v8 = readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage) or {}
		local v9 = v8[v6]

		if v9 == nil then
			v9 = {}
			v8[v6] = v9
		end

		v9[v7] = true
		pcall(function()
			local jsonEncode = HttpService:JSONEncode(v8)
			safeAppStorageService.setItem("AXCatalogOffersSheetFTUX", jsonEncode, defineFastFlag)

			safeAppStorageService.flush()
		end)
	end
}
