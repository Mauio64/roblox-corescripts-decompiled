local parent = script:FindFirstAncestor("DataHydration").Parent

local t = require(parent.t)

require(script.Parent.Types.store)
local FFlagBuildAgentAdCampaignCard = require(script.Parent.FFlagBuildAgentAdCampaignCard)

local interface = t.interface({
	campaignId = t.string,
	status = t.string,
	toolCallId = t.optional(t.string)
})

local function decodeAdCampaignCreateResult(data)
	local v, v2 = interface(data)

	if not v then
		return nil, "Invalid ad campaign create response: " .. tostring(v2)
	end

	if data.campaignId == "" then
		return nil, "Invalid ad campaign create response: campaignId must be non-empty"
	end

	if FFlagBuildAgentAdCampaignCard and (data.status == "" or data.toolCallId == "") then
		return nil, "Invalid ad campaign create response: status and toolCallId must be non-empty"
	end

	return data, nil
end

return decodeAdCampaignCreateResult
