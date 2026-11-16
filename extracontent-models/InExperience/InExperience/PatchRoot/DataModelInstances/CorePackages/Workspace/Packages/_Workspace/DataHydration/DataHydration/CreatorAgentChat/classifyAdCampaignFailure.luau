local AcpProtocol = require(script.Parent.Acp.AcpProtocol)
local ErrorCodes = AcpProtocol.ErrorCodes
require(script.Parent.Types.store)

local v = {
	[ErrorCodes.InsufficientFunds] = "payment_required",
	[ErrorCodes.Forbidden] = "ineligible",
	[ErrorCodes.MissingThumbnail] = "missing_thumbnail"
}

local function classifyAdCampaignFailure(p)
	local responseCode

	if type(p) == "table" and type(p.responseCode) == "number" then
		responseCode = p.responseCode
	end

	local message

	if type(p) == "table" and type(p.errorMessage) == "string" then
		message = p.errorMessage
	else
		message = tostring(p)
	end

	return {
		kind = responseCode == nil and "unknown" or v[responseCode] or "unknown",
		code = responseCode,
		message = message
	}
end

return classifyAdCampaignFailure
