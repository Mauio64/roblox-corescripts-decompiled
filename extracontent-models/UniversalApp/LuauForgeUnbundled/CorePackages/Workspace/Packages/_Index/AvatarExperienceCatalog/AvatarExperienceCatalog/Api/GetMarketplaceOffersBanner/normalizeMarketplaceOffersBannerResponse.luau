local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeRequired = normalize.makeRequired

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/MarketplaceOffersBannerTypes")
local decodeLuauUnicodeEscapes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetMarketplaceOffersBanner/decodeLuauUnicodeEscapes")

local fFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

local function normalizeDisplayString(p2)
	local notEmptyString, v5 = normalizeNotEmptyString(p2)

	if notEmptyString == nil then
		return nil, v5
	end

	return decodeLuauUnicodeEscapes(notEmptyString), nil
end

local normalizeTableFn = makeNormalizeTableFn({
	modalTitle = makeRequired(normalizeDisplayString),
	offerBodyLinkText = makeRequired(normalizeDisplayString),
	modalHeroIcon = normalizeNotEmptyString,
	termsBody = normalizeDisplayString,
	termsModalTitle = normalizeDisplayString
})

local function normalizeModalForOfferRow(p2)
	local v5 = nil

	if type(p2.modal) == "table" then
		v5 = p2.modal
	elseif normalizeNotEmptyString(p2.modalTitle) ~= nil then
		v5 = p2
	end

	if not v5 then
		return nil
	end

	local tableFn = normalizeTableFn(v5)

	if tableFn and tableFn.modalTitle and tableFn.offerBodyLinkText then
		return tableFn
	end

	return nil
end

local function normalizeOfferRow(offer)
	if type(offer) ~= "table" then
		return nil, `expected offer row to be a table, got {type(offer)}`
	end

	local notEmptyString = normalizeNotEmptyString(offer.icon)
	local notEmptyString2, v5 = normalizeNotEmptyString(offer.localizedText)
	local v6 = if notEmptyString2 ~= nil then decodeLuauUnicodeEscapes(notEmptyString2) else nil

	local notEmptyString3 = normalizeNotEmptyString(offer.offerId)
	local v7

	if fFlagAXUpdateOffersEndsUIWithBadge then
		v7 = normalizeNotEmptyString(offer.expirationTimeInUTC)
	end

	if not (notEmptyString or v6 or notEmptyString3) then
		return nil, "offer row has no recognized identity fields (icon, localizedText, offerId)"
	end

	local v8 = {}

	if notEmptyString then
		v8.icon = notEmptyString
	end

	if v6 then
		v8.localizedText = v6
	end

	if notEmptyString3 then
		v8.offerId = notEmptyString3
	end

	if fFlagAXUpdateOffersEndsUIWithBadge and v7 then
		v8.expirationTimeInUTC = v7
	end

	local v9 = nil

	if type(offer.modal) == "table" then
		v9 = offer.modal
	elseif normalizeNotEmptyString(offer.modalTitle) ~= nil then
		v9 = offer
	end

	local v10

	if v9 then
		v10 = normalizeTableFn(v9)

		if not (v10 and v10.modalTitle and v10.offerBodyLinkText) then
			v10 = nil
		end
	end

	v8.modal = v10
	return v8, nil
end

local function normalizeMarketplaceOffersBannerResponse(p2)
	if p2 == nil then
		return nil, nil
	end

	if type(p2) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected response body to be a table, got {type(p2)}`
	end

	local offers = p2.offers

	if offers == nil then
		return nil, nil
	end

	if type(offers) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected 'offers' field to be a table, got {type(offers)}`
	end

	if #offers == 0 then
		return nil, nil
	end

	local v5 = {}
	local offerRows = {}

	for k, offer in offers do
		local offerRow, v6 = normalizeOfferRow(offer)

		if v6 then
			table.insert(v5, `offers[{k}]: {v6}`)
		end

		if offerRow then
			table.insert(offerRows, offerRow)
		end
	end

	local v6 = if next(v5) then "MarketplaceOffersBanner: " .. table.concat(v5, "; ") else nil

	if #offerRows == 0 then
		return nil, v6
	end

	return { offers = offerRows }, v6
end

return normalizeMarketplaceOffersBannerResponse
