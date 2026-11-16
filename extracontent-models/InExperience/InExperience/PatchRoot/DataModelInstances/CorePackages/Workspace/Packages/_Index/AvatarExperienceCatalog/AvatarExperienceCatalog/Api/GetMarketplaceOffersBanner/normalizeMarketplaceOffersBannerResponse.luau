local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeRequired = normalize.makeRequired

require(script.Parent.MarketplaceOffersBannerTypes)
local decodeLuauUnicodeEscapes = require(script.Parent.decodeLuauUnicodeEscapes)

local FFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

local function normalizeDisplayString(p)
	local notEmptyString, v = normalizeNotEmptyString(p)

	if notEmptyString == nil then
		return nil, v
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

local function normalizeModalForOfferRow(data) -- 1 equivalent call inferred from this helper
	local v = nil

	if type(data.modal) == "table" then
		v = data.modal
	elseif normalizeNotEmptyString(data.modalTitle) ~= nil then
		v = data
	end

	if not v then
		return nil
	end

	local tableFn = normalizeTableFn(v)

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
	local notEmptyString2, _ = normalizeNotEmptyString(offer.localizedText)
	local localizedText

	if notEmptyString2 ~= nil then
		localizedText = decodeLuauUnicodeEscapes(notEmptyString2)
	end

	local notEmptyString3 = normalizeNotEmptyString(offer.offerId)
	local expirationTimeInUTC

	if FFlagAXUpdateOffersEndsUIWithBadge then
		expirationTimeInUTC = normalizeNotEmptyString(offer.expirationTimeInUTC)
	end

	if not (notEmptyString or localizedText or notEmptyString3) then
		return nil, "offer row has no recognized identity fields (icon, localizedText, offerId)"
	end

	local v = {}

	if notEmptyString then
		v.icon = notEmptyString
	end

	if localizedText then
		v.localizedText = localizedText
	end

	if notEmptyString3 then
		v.offerId = notEmptyString3
	end

	if FFlagAXUpdateOffersEndsUIWithBadge and expirationTimeInUTC then
		v.expirationTimeInUTC = expirationTimeInUTC
	end

	v.modal = normalizeModalForOfferRow(offer) -- inferred equivalent call
	return v, nil
end

local function normalizeMarketplaceOffersBannerResponse(p)
	if p == nil then
		return nil, nil
	end

	if type(p) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected response body to be a table, got {type(p)}`
	end

	local offers = p.offers

	if offers == nil then
		return nil, nil
	end

	if type(offers) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected 'offers' field to be a table, got {type(offers)}`
	end

	if #offers == 0 then
		return nil, nil
	end

	local v = {}
	local offerRows = {}

	for k, offer in offers do
		local offerRow, v2 = normalizeOfferRow(offer)

		if v2 then
			table.insert(v, `offers[{k}]: {v2}`)
		end

		if offerRow then
			table.insert(offerRows, offerRow)
		end
	end

	local selected

	if next(v) then
		selected = "MarketplaceOffersBanner: " .. table.concat(v, "; ")
	end

	if #offerRows == 0 then
		return nil, selected
	end

	return { offers = offerRows }, selected
end

return normalizeMarketplaceOffersBannerResponse
