local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local normalize = require(Parent.AvatarExperienceCommon).Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeNumber = normalize.normalizeNumber
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeNormalizeListFn = normalize.makeNormalizeListFn
local makeRequired = normalize.makeRequired

require(script.Parent.CartPricingForOffersTypes)

local v9 = makeNormalizeTableFn({
	discounts = {
		fn = makeNormalizeListFn((makeNormalizeTableFn({
			discountCampaign = {
				fn = normalizeNotEmptyString
			},
			localizedDiscountAttribution = {
				fn = normalizeNotEmptyString
			},
			robuxDiscountAmount = {
				fn = normalizeNumber
			},
			robuxDiscountPercentage = {
				fn = normalizeNumber
			}
		})))
	},
	originalPrice = {
		fn = normalizeNumber
	},
	totalDiscountAmount = {
		fn = normalizeNumber
	},
	totalDiscountPercentage = {
		fn = normalizeNumber
	}
})
local v10 = makeNormalizeTableFn({
	collectibleItemId = makeRequired(normalizeNotEmptyString),
	discountInformation = {
		fn = v9
	},
	priceInRobux = {
		fn = normalizeNumber
	},
	regularPriceInRobux = {
		fn = normalizeNumber
	}
})
local v11 = makeNormalizeTableFn({
	localizedDescription = {
		fn = normalizeNotEmptyString
	},
	offerId = makeRequired(normalizeNotEmptyString),
	selected = {
		fn = normalizeBoolean
	}
})

local function normalizeCartPricingForOffersResponse(p1) -- line: 47
	-- upvalues: makeNormalizeListFn (copy), v10 (copy), v11 (copy), normalizeNotEmptyString (copy)
	if p1 == nil then
		return nil, nil
	end

	if type(p1) ~= "table" then
		return nil, "CartPricingForOffers: unexpected response body type"
	end

	local t1 = {
		items = {}
	}
	local t2 = {}

	if p1.items ~= nil then
		local v16, v17 = makeNormalizeListFn(v10)(p1.items)

		if v17 then
			table.insert(t2, `items normalization failed with: { v17 }`)
		end

		t1.items = v16
	end

	if p1.availableOffers ~= nil then
		local v18, v19 = makeNormalizeListFn(v11)(p1.availableOffers)

		if v19 then
			table.insert(t2, `availableOffers normalization failed with: { v19 }`)
		end

		t1.availableOffers = v18
	end

	t1.savingsSummary = normalizeNotEmptyString(p1.savingsSummary)

	return t1, if not next(t2) then nil else table.concat(t2, " ")
end

return normalizeCartPricingForOffersResponse
