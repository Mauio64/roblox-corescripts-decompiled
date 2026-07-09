local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local normalize = require(Parent.AvatarExperienceCommon).Utils.normalize
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeRequired = normalize.makeRequired

require(script.Parent.MarketplaceOffersBannerTypes)

local decodeLuauUnicodeEscapes = require(script.Parent.decodeLuauUnicodeEscapes)

local function normalizeDisplayString(p1) -- line: 18
	-- upvalues: normalizeNotEmptyString (copy), decodeLuauUnicodeEscapes (copy)
	local v13, v14 = normalizeNotEmptyString(p1)

	if v13 == nil then
		return nil, v14
	end

	return decodeLuauUnicodeEscapes(v13), nil
end

local v8 = makeNormalizeTableFn({
	modalTitle = makeRequired(normalizeDisplayString),
	offerBodyLinkText = makeRequired(normalizeDisplayString),
	modalHeroIcon = normalizeNotEmptyString,
	termsBody = normalizeDisplayString,
	termsModalTitle = normalizeDisplayString
})

local function normalizeModalForOfferRow(t1: {[any]: any}) -- line: 77
	-- upvalues: normalizeNotEmptyString (copy), v8 (copy)
	local modal = nil

	if type(t1.modal) == "table" then
		modal = t1.modal
	elseif normalizeNotEmptyString(t1.modalTitle) ~= nil then
		modal = t1
	end

	if not modal then
		return nil
	end

	local v17 = v8(modal)

	if not v17 or not v17.modalTitle or not v17.offerBodyLinkText then
		return nil
	end

	return v17
end
local function normalizeOfferRow(p2) -- line: 96
	-- upvalues: normalizeNotEmptyString (copy), decodeLuauUnicodeEscapes (copy), v8 (copy)
	if type(p2) ~= "table" then
		return nil, `expected offer row to be a table, got { type(p2) }`
	end

	local v19 = normalizeNotEmptyString(p2.icon)
	local localizedText = p2.localizedText
	local v21, _ = normalizeNotEmptyString(localizedText)
	local v23 = if v21 ~= nil then decodeLuauUnicodeEscapes(v21) else nil
	local v24 = normalizeNotEmptyString(p2.offerId)

	if not v19 and not v23 and not v24 then
		return nil, "offer row has no recognized identity fields (icon, localizedText, offerId)"
	end

	local t2 = {}

	if v19 then
		t2.icon = v19
	end

	if v23 then
		t2.localizedText = v23
	end

	if v24 then
		t2.offerId = v24
	end

	local modal = nil

	if type(p2.modal) == "table" then
		modal = p2.modal
	elseif normalizeNotEmptyString(p2.modalTitle) ~= nil then
		modal = p2
	end

	local v27

	if not modal then
		v27 = nil
	else
		local v28 = v8(modal)

		v27 = if not not v28 and (not not v28.modalTitle and v28.offerBodyLinkText) then v28 else nil
	end

	t2.modal = v27

	return t2, nil
end
local function normalizeMarketplaceOffersBannerResponse(p3) -- line: 123
	-- upvalues: normalizeOfferRow (copy)
	if p3 == nil then
		return nil, nil
	end

	if type(p3) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected response body to be a table, got { type(p3) }`
	end

	local offers = p3.offers

	if offers == nil then
		return nil, nil
	end

	if type(offers) ~= "table" then
		return nil, `MarketplaceOffersBanner: expected 'offers' field to be a table, got { type(offers) }`
	end

	if #offers == 0 then
		return nil, nil
	end

	local t3 = {}
	local t4 = {}

	for v33, v34 in offers do
		local v35, v36 = normalizeOfferRow(v34)

		if v36 then
			table.insert(t3, `offers[{ v33 }]: { v36 }`)
		end

		if v35 then
			table.insert(t4, v35)
		end
	end

	local v37 = nil

	if next(t3) then
		v37 = "MarketplaceOffersBanner: " .. table.concat(t3, "; ")
	end

	if #t4 == 0 then
		return nil, v37
	end

	return {
		offers = t4
	}, v37
end

return normalizeMarketplaceOffersBannerResponse
