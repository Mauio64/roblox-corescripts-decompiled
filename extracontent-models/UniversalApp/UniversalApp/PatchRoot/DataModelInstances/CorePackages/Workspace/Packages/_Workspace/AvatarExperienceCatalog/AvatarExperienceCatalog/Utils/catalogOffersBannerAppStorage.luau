local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local SafeAppStorageService = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Lib.SafeAppStorageService
local FFlagAXCatalogOffersDismissedStorageKeyFix = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogOffersDismissedStorageKeyFix

require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.MarketplaceOffersBannerTypes)

local marketplaceOffersBannerDisplay = require(AvatarExperienceCatalog.Api.GetMarketplaceOffersBanner.marketplaceOffersBannerDisplay)
local getLocalUserId = require(script.Parent.getLocalUserId)
local getMarketplaceOffersBannerOfferDisplayId = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayId
local getMarketplaceOffersBannerOfferDisplayTitle = marketplaceOffersBannerDisplay.getMarketplaceOffersBannerOfferDisplayTitle
local v11 = not FFlagAXCatalogOffersDismissedStorageKeyFix and "AXCatalogOffersBannerDismissed" or "AXCatalogOffersDismissed"
local v12 = game:DefineFastFlag("AXCatalogOffersBannerAppStorageUseMemStorage", false)

local function normalizeOfferId(s1: string?) -- line: 53
	return s1 or ""
end
local function offerIdMapContains(t1: {[any]: any}, s2: string) -- line: 57
	return t1[s2] == true
end
local function coerceDecodedToOfferIdMapStorage(p1) -- line: 61
	if typeof(p1) ~= "table" then
		return nil
	end

	local t2 = {}
	local v23 = false

	for v24, v25 in p1 do
		if typeof(v24) == "string" and typeof(v25) == "table" then
			local t3 = {}

			for v27, v28 in v25 do
				if typeof(v27) == "string" and v28 == true then
					t3[v27] = true
				end
			end

			t2[v24] = t3
			v23 = true
		end
	end

	if not v23 then
		return nil
	end

	return t2
end
local function readStorageRecord(s3: string, p2: ((...any) -> ...any)) -- line: 85
	-- upvalues: SafeAppStorageService (copy), v12 (copy), HttpService (copy)
	local v31 = SafeAppStorageService.getItem(s3, v12)

	if not v31 or v31 == "" then
		return nil
	end

	local ok, result = pcall(function() -- line: 90
		-- upvalues: HttpService (copy), v31 (copy)
		return HttpService:JSONDecode(v31)
	end)

	if not ok then
		return nil
	end

	return p2(result)
end
local function resolveVisibleOffer(p3) -- line: 118
	-- upvalues: getLocalUserId (copy), Players (copy), readStorageRecord (copy), v11 (copy), coerceDecodedToOfferIdMapStorage (copy), getMarketplaceOffersBannerOfferDisplayTitle (copy), getMarketplaceOffersBannerOfferDisplayId (copy)
	local v38 = getLocalUserId(Players)
	local t4 = {}

	if v38 ~= nil then
		local v40 = readStorageRecord(v11, coerceDecodedToOfferIdMapStorage)

		if v40 and v40[v38] then
			t4 = v40[v38]
		end
	end

	for _, v42 in p3.offers do
		local v43 = getMarketplaceOffersBannerOfferDisplayTitle(v42)

		if not v43 or v43 == "" then
			continue
		end

		local v44 = getMarketplaceOffersBannerOfferDisplayId(v42) or ""

		if v38 == nil or t4[v44] ~= true then
			return v42
		end
	end

	return nil
end

return {
	SHEET_FTUX_STORAGE_KEY = "AXCatalogOffersSheetFTUX",
	STORAGE_KEY = v11,
	readDismissStorage = function() -- line: 99
		-- upvalues: readStorageRecord (copy), v11 (copy), coerceDecodedToOfferIdMapStorage (copy)
		return readStorageRecord(v11, coerceDecodedToOfferIdMapStorage)
	end,
	readSheetFtuxStorage = function() -- line: 103
		-- upvalues: readStorageRecord (copy), coerceDecodedToOfferIdMapStorage (copy)
		return readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage)
	end,
	dismissRecordMatchesPayload = function(p4, t5: {[any]: any}) -- line: 107
		local v36 = t5.offerId or ""

		return p4[t5.userId] ~= nil and p4[t5.userId][v36] == true
	end,
	dismissedOfferIdsContains = offerIdMapContains,
	normalizeOfferIdForStorage = normalizeOfferId,
	resolveVisibleOffer = resolveVisibleOffer,
	shouldHydrateDismissed = function(p5) -- line: 142
		-- upvalues: getLocalUserId (copy), Players (copy), resolveVisibleOffer (copy)
		if getLocalUserId(Players) == nil then
			return false
		end

		return resolveVisibleOffer(p5) == nil
	end,
	shouldAutoOpenOfferSheetForCurrentOffer = function(s4: string?) -- line: 169
		-- upvalues: getLocalUserId (copy), Players (copy), readStorageRecord (copy), coerceDecodedToOfferIdMapStorage (copy)
		local v52 = getLocalUserId(Players)

		if v52 == nil then
			return false
		end

		local v53 = readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage)

		if v53 == nil or v53[v52] == nil then
			return true
		end

		return v53[v52][s4 or ""] ~= true
	end,
	writeDismissedForCurrentOffer = function(s5: string?) -- line: 149
		-- upvalues: getLocalUserId (copy), Players (copy), readStorageRecord (copy), v11 (copy), coerceDecodedToOfferIdMapStorage (copy), HttpService (copy), SafeAppStorageService (copy), v12 (copy)
		local v47 = getLocalUserId(Players)

		if v47 == nil then
			return
		end

		local v48 = s5 or ""
		local v49 = readStorageRecord(v11, coerceDecodedToOfferIdMapStorage) or {}
		local v50 = v49[v47]

		if v50 == nil then
			v50 = {}
			v49[v47] = v50
		end

		v50[v48] = true
		pcall(function() -- line: 162
			-- upvalues: HttpService (copy), v49 (copy), SafeAppStorageService (copy), v11 (copy), v12 (copy)
			local json = HttpService:JSONEncode(v49)

			SafeAppStorageService.setItem(v11, json, v12)
			SafeAppStorageService.flush()
		end)
	end,
	writeSeenOfferSheetForCurrentOffer = function(s6: string?) -- line: 181
		-- upvalues: getLocalUserId (copy), Players (copy), readStorageRecord (copy), coerceDecodedToOfferIdMapStorage (copy), HttpService (copy), SafeAppStorageService (copy), v12 (copy)
		local v55 = getLocalUserId(Players)

		if v55 == nil then
			return
		end

		local v56 = s6 or ""
		local v57 = readStorageRecord("AXCatalogOffersSheetFTUX", coerceDecodedToOfferIdMapStorage) or {}
		local v58 = v57[v55]

		if v58 == nil then
			v58 = {}
			v57[v55] = v58
		end

		v58[v56] = true
		pcall(function() -- line: 194
			-- upvalues: HttpService (copy), v57 (copy), SafeAppStorageService (copy), v12 (copy)
			local json = HttpService:JSONEncode(v57)

			SafeAppStorageService.setItem("AXCatalogOffersSheetFTUX", json, v12)
			SafeAppStorageService.flush()
		end)
	end
}
