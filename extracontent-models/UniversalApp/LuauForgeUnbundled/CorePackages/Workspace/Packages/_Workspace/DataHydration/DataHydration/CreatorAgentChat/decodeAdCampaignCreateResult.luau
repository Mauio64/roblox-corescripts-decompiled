local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/store")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagBuildAgentAdCampaignCard")

local interface = t.interface({
	campaignId = t.string,
	status = t.string,
	toolCallId = t.optional(t.string)
})

local function decodeAdCampaignCreateResult(data)
	local v5, v6 = interface(data)

	if not v5 then
		return nil, "Invalid ad campaign create response: " .. tostring(v6)
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
