local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogOffersDismissedStorageKeyFix = AvatarExperienceFlags.FFlagAXCatalogOffersDismissedStorageKeyFix
require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)
local marketplaceOffersBannerDisplay = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.marketplaceOffersBannerDisplay)
local getLocalUserId = require(script.Parent.getLocalUserId)

local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle
local v = FFlagAXCatalogOffersDismissedStorageKeyFix and "AXCatalogOffersDismissed" or "AXCatalogOffersBannerDismissed"
local defineFastFlag = game:DefineFastFlag("AXCatalogOffersBannerAppStorageUseMemStorage", false)

local function normalizeOfferId(value: string?) -- 5 equivalent calls inferred from this helper
	return value or ""
end

local function offerIdMapContains(p, offerId: string): boolean -- 3 equivalent calls inferred from this helper
	return p[offerId] == true
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

		for k2, v2 in item do
			if typeof(k2) == "string" and v2 == true then
				set[k2] = true
			end
		end

		result[k] = set
		flag = true
	end

	return if flag then result else nil
end

local function readStorageRecord(p: string, coerceDecodedToOfferIdMapStorage2)
	local item = SafeAppStorageService.getItem(p, defineFastFlag)

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

local function readDismissStorage() -- 2 equivalent calls inferred from this helper
	return readStorageRecord(v, coerceDecodedToOfferIdMapStorage)
end

local function readSheetFtuxStorage() -- 2 equivalent calls inferred from this helper
	return readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage)
end

local function resolveVisibleOffer(p)
	local localUserId = getLocalUserId(Players)

	local v2 = {}

	if localUserId ~= nil then
		local dismissStorage = readDismissStorage() -- inferred equivalent call

		if dismissStorage and dismissStorage[localUserId] then
			v2 = dismissStorage[localUserId]
		end
	end

	for _, offer in p.offers do
		local marketplaceOffersBannerOfferDisplayTitle = getMarketplaceOffersBannerOfferDisplayTitle(offer)

		if not (marketplaceOffersBannerOfferDisplayTitle and marketplaceOffersBannerOfferDisplayTitle ~= "") then
			continue
		end

		local offerId = normalizeOfferId(getMarketplaceOffersBannerOfferDisplayId(offer)) -- inferred equivalent call

		if localUserId == nil or not offerIdMapContains(v2, offerId) then -- inferred equivalent call
			return offer
		end
	end

	return nil
end

local CatalogOffersBannerAppStorage = {}
CatalogOffersBannerAppStorage.STORAGE_KEY = v
CatalogOffersBannerAppStorage.SHEET_FTUX_STORAGE_KEY = "AXCatalogOffersSheetFTUX"
CatalogOffersBannerAppStorage.readDismissStorage = readDismissStorage
CatalogOffersBannerAppStorage.readSheetFtuxStorage = readSheetFtuxStorage

function CatalogOffersBannerAppStorage.dismissRecordMatchesPayload(p, p2)
	local offerId = normalizeOfferId(p2.offerId) -- inferred equivalent call
	return p[p2.userId] ~= nil and offerIdMapContains(p[p2.userId], offerId) -- inferred equivalent call
end

CatalogOffersBannerAppStorage.dismissedOfferIdsContains = offerIdMapContains
CatalogOffersBannerAppStorage.normalizeOfferIdForStorage = normalizeOfferId
CatalogOffersBannerAppStorage.resolveVisibleOffer = resolveVisibleOffer

function CatalogOffersBannerAppStorage.shouldHydrateDismissed(p): boolean
	return getLocalUserId(Players) ~= nil and resolveVisibleOffer(p) == nil
end

function CatalogOffersBannerAppStorage.shouldAutoOpenOfferSheetForCurrentOffer(value: string?): boolean
	local localUserId = getLocalUserId(Players)

	if localUserId == nil then
		return false
	end

	local sheetFtuxStorage = readSheetFtuxStorage() -- inferred equivalent call

	if sheetFtuxStorage == nil or sheetFtuxStorage[localUserId] == nil then
		return true
	end

	return not offerIdMapContains(sheetFtuxStorage[localUserId], normalizeOfferId(value)) -- inferred equivalent call
end

function CatalogOffersBannerAppStorage.writeDismissedForCurrentOffer(value: string?)
	local localUserId = getLocalUserId(Players)

	if localUserId == nil then
		return
	end

	local offerId = normalizeOfferId(value) -- inferred equivalent call
	local v2 = readDismissStorage() or {} -- inferred equivalent call
	local v3 = v2[localUserId]

	if v3 == nil then
		v3 = {}
		v2[localUserId] = v3
	end

	v3[offerId] = true
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(v2)
		SafeAppStorageService.setItem(v, jsonEncode, defineFastFlag)
		SafeAppStorageService.flush()
	end)
end

function CatalogOffersBannerAppStorage.writeSeenOfferSheetForCurrentOffer(value: string?)
	local localUserId = getLocalUserId(Players)

	if localUserId == nil then
		return
	end

	local offerId = normalizeOfferId(value) -- inferred equivalent call
	local v2 = readSheetFtuxStorage() or {} -- inferred equivalent call
	local v3 = v2[localUserId]

	if v3 == nil then
		v3 = {}
		v2[localUserId] = v3
	end

	v3[offerId] = true
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(v2)
		SafeAppStorageService.setItem("AXCatalogOffersSheetFTUX", jsonEncode, defineFastFlag)

		SafeAppStorageService.flush()
	end)
end

return CatalogOffersBannerAppStorage
