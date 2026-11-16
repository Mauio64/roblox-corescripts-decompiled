local parent = script:FindFirstAncestor("DataHydration").Parent

local t = require(parent.t)

require(script.Parent.Types.store)

local interface = t.interface({
	status = t.union(t.literal("none"), t.literal("processing"), t.literal("created"), t.literal("failed")),
	campaignId = t.optional(t.string)
})

local function decodeAdCampaignToolCallStatusResult(p)
	local v, v2 = interface(p)

	if not v then
		return nil, "Invalid ad campaign tool-call status response: " .. tostring(v2)
	end

	if p.status == "" or p.campaignId == "" then
		return nil, "Invalid ad campaign tool-call status response: status and campaignId must be non-empty"
	end

	return p, nil
end

return decodeAdCampaignToolCallStatusResult
