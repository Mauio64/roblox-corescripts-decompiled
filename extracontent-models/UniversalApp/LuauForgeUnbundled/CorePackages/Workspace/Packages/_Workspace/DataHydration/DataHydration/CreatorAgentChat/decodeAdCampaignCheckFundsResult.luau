local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/store")

local interface = t.interface({
	canFund = t.boolean,
	fundingSource = t.union(
		t.literal("ad_credit"),
		t.literal("robux"),
		t.literal("none")
	)
})

local function decodeAdCampaignCheckFundsResult(p2)
	local v5, v6 = interface(p2)

	if v5 then
		return p2, nil
	end

	return nil, "Invalid ad campaign check funds response: " .. tostring(v6)
end

return decodeAdCampaignCheckFundsResult
