local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/store")

local interface = t.interface({
	userEligible = t.boolean,
	universeEligible = t.boolean,
	freeCreditsRemaining = t.integer,
	cardType = t.union(
		t.literal("promote_free"),
		t.literal("promote_paid"),
		t.literal("none")
	),
	ineligibleReasons = t.array(t.string),
	offer = t.optional(t.interface({
		displayAmountRobux = t.integer,
		durationDays = t.integer
	}))
})

local function decodeAdCampaignEligibilityResult(p2)
	local v5, v6 = interface(p2)

	if not v5 then
		return nil, "Invalid ad campaign eligibility response: " .. tostring(v6)
	end

	if p2.freeCreditsRemaining < 0 then
		return nil, "Invalid ad campaign eligibility response: freeCreditsRemaining must be non-negative"
	end

	if p2.offer == nil then
		return p2, nil
	end

	if p2.offer.displayAmountRobux < 0 then
		return
			nil,
			"Invalid ad campaign eligibility response: offer.displayAmountRobux must be non-negative"
	end

	if p2.offer.durationDays <= 0 then
		return nil, "Invalid ad campaign eligibility response: offer.durationDays must be positive"
	end

	return p2, nil
end

return decodeAdCampaignEligibilityResult
