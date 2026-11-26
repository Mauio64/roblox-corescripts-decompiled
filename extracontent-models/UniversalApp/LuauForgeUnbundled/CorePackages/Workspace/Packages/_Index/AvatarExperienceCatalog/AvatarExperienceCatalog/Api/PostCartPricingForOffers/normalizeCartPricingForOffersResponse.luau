local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local normalize = AvatarExperienceCommon.Utils.normalize
local normalizeBoolean = normalize.normalizeBoolean
local normalizeNumber = normalize.normalizeNumber
local normalizeNotEmptyString = normalize.normalizeNotEmptyString
local makeNormalizeTableFn = normalize.makeNormalizeTableFn
local makeNormalizeListFn = normalize.makeNormalizeListFn
local makeRequired = normalize.makeRequired

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/PostCartPricingForOffers/CartPricingForOffersTypes")

local fFlagAXUpdateOffersEndsUIWithBadge = AvatarExperienceFlags.FFlagAXUpdateOffersEndsUIWithBadge

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
local v5

if fFlagAXUpdateOffersEndsUIWithBadge then
	v5 = makeNormalizeTableFn({
		expirationTimeUtc = { fn = normalizeNotEmptyString },
		localizedDescription = { fn = normalizeNotEmptyString },
		offerId = makeRequired(normalizeNotEmptyString),
		selected = { fn = normalizeBoolean }
	})
else
	v5 = makeNormalizeTableFn({
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

	local v6 = { items = {} }
	local v7 = {}

	if data.items ~= nil then
		local v8, v9 = makeNormalizeListFn(normalizeTableFn2)(data.items)

		if v9 then
			table.insert(v7, `items normalization failed with: {v9}`)
		end

		v6.items = v8
	end

	if data.availableOffers ~= nil then
		local v8, v9 = makeNormalizeListFn(v5)(data.availableOffers)

		if v9 then
			table.insert(v7, `availableOffers normalization failed with: {v9}`)
		end

		v6.availableOffers = v8
	end

	v6.savingsSummary = normalizeNotEmptyString(data.savingsSummary)

	local v8 = if next(v7) then table.concat(v7, " ") else nil
	return v6, v8
end

return normalizeCartPricingForOffersResponse
