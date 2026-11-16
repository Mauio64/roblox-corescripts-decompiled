local errorCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/AcpProtocol").ErrorCodes
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/store")

local v5 = {
	[errorCodes.InsufficientFunds] = "payment_required",
	[errorCodes.Forbidden] = "ineligible",
	[errorCodes.MissingThumbnail] = "missing_thumbnail"
}

local function classifyAdCampaignFailure(p2)
	local responseCode = if type(p2) == "table" and type(p2.responseCode) == "number" then p2.responseCode else nil
	local v6 = if type(p2) == "table" and type(p2.errorMessage) == "string" then p2.errorMessage else tostring(p2)

	return {
		kind = responseCode == nil and "unknown" or v5[responseCode] or "unknown",
		code = responseCode,
		message = v6
	}
end

return classifyAdCampaignFailure
