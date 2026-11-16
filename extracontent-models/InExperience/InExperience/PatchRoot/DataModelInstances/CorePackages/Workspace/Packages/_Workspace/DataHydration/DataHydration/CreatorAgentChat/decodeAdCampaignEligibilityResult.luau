local parent = script:FindFirstAncestor("DataHydration").Parent

local t = require(parent.t)

require(script.Parent.Types.store)

local interface = t.interface({
	userEligible = t.boolean,
	universeEligible = t.boolean,
	freeCreditsRemaining = t.integer,
	cardType = t.union(t.literal("promote_free"), t.literal("promote_paid"), t.literal("none")),
	ineligibleReasons = t.array(t.string),
	offer = t.optional(t.interface({ displayAmountRobux = t.integer, durationDays = t.integer }))
})

local function decodeAdCampaignEligibilityResult(p)
	local v, v2 = interface(p)

	if not v then
		return nil, "Invalid ad campaign eligibility response: " .. tostring(v2)
	end

	if p.freeCreditsRemaining < 0 then
		return nil, "Invalid ad campaign eligibility response: freeCreditsRemaining must be non-negative"
	end

	if p.offer == nil then
		return p, nil
	end

	if p.offer.displayAmountRobux < 0 then
		return nil, "Invalid ad campaign eligibility response: offer.displayAmountRobux must be non-negative"
	end

	if p.offer.durationDays <= 0 then
		return nil, "Invalid ad campaign eligibility response: offer.durationDays must be positive"
	end

	return p, nil
end

return decodeAdCampaignEligibilityResult
