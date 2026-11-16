local parent = script:FindFirstAncestor("DataHydration").Parent

local t = require(parent.t)

require(script.Parent.Types.store)

local interface = t.interface({
	canFund = t.boolean,
	fundingSource = t.union(t.literal("ad_credit"), t.literal("robux"), t.literal("none"))
})

local function decodeAdCampaignCheckFundsResult(p)
	local v, v2 = interface(p)

	if v then
		return p, nil
	end

	return nil, "Invalid ad campaign check funds response: " .. tostring(v2)
end

return decodeAdCampaignCheckFundsResult
