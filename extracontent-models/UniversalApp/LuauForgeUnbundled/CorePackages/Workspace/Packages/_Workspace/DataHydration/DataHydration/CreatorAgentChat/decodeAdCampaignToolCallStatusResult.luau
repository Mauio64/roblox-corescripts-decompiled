local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/store")

local interface = t.interface({
	status = t.union(
		t.literal("none"),
		t.literal("processing"),
		t.literal("created"),
		t.literal("failed")
	),
	campaignId = t.optional(t.string)
})

local function decodeAdCampaignToolCallStatusResult(p2)
	local v5, v6 = interface(p2)

	if not v5 then
		return nil, "Invalid ad campaign tool-call status response: " .. tostring(v6)
	end

	if p2.status == "" or p2.campaignId == "" then
		return nil, "Invalid ad campaign tool-call status response: status and campaignId must be non-empty"
	end

	return p2, nil
end

return decodeAdCampaignToolCallStatusResult
