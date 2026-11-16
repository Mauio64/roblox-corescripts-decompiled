local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeNumber = normalize.normalizeNumber
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeNormalizeListFn = normalize.makeNormalizeListFn
local makeRequired = normalize.makeRequired

require(script.Parent.CartPricingForOffersTypes)

local FFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

local normalizeTableFn = makeNormalizeTableFn({
	discounts = {
		fn = makeNormalizeListFn((makeNormalizeTableFn({
			discountCampaign = { fn = normalizeNotEmptyString },
			localizedDiscountAttribution = { fn = normalizeNotEmptyString },
			robuxDiscountAmount = { fn = normalizeNumber },
			robuxDiscountPercentage = { fn = normalizeNumber }
		})))
	},
	originalPrice = { fn = normalizeNumber },
	totalDiscountAmount = { fn = normalizeNumber },
	totalDiscountPercentage = { fn = normalizeNumber }
})

local normalizeTableFn2 = makeNormalizeTableFn({
	collectibleItemId = makeRequired(normalizeNotEmptyString),
	discountInformation = { fn = normalizeTableFn },
	priceInRobux = { fn = normalizeNumber },
	regularPriceInRobux = { fn = normalizeNumber }
})
local v

if FFlagAXUpdateOffersEndsUIWithBadge then
	v = makeNormalizeTableFn({
		expirationTimeUtc = { fn = normalizeNotEmptyString },
		localizedDescription = { fn = normalizeNotEmptyString },
		offerId = makeRequired(normalizeNotEmptyString),
		selected = { fn = normalizeBoolean }
	})
else
	v = makeNormalizeTableFn({
		localizedDescription = { fn = normalizeNotEmptyString },
		offerId = makeRequired(normalizeNotEmptyString),
		selected = { fn = normalizeBoolean }
	})
end

local function normalizeCartPricingForOffersResponse(data)
	if data == nil then
		return nil, nil
	end

	if type(data) ~= "table" then
		return nil, "CartPricingForOffers: unexpected response body type"
	end

	local v2 = { items = {} }
	local v3 = {}

	if data.items ~= nil then
		local items, v4 = makeNormalizeListFn(normalizeTableFn2)(data.items)

		if v4 then
			table.insert(v3, `items normalization failed with: {v4}`)
		end

		v2.items = items
	end

	if data.availableOffers ~= nil then
		local availableOffers, v4 = makeNormalizeListFn(v)(data.availableOffers)

		if v4 then
			table.insert(v3, `availableOffers normalization failed with: {v4}`)
		end

		v2.availableOffers = availableOffers
	end

	v2.savingsSummary = normalizeNotEmptyString(data.savingsSummary)
	local v4

	if next(v3) then
		v4 = table.concat(v3, " ")
	end

	return v2, v4
end

return normalizeCartPricingForOffersResponse
