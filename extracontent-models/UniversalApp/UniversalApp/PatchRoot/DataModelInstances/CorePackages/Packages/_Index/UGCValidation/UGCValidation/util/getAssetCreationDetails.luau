local parent = script.Parent.Parent

local APIUtil = require(parent.util.APIUtil)

local HttpService = game:GetService("HttpService")

local baseDomain = APIUtil.getBaseDomain()
local v = string.format("https://itemconfiguration.%s", baseDomain) .. "v1/creations/get-asset-details"

local function getAssetCreationDetails(assetIds)
	local requestAndRetryPost, v2 = APIUtil.requestAndRetryPost(v, HttpService:JSONEncode({
		assetIds = assetIds
	}))

	if requestAndRetryPost then
		return true, HttpService:JSONDecode(v2)
	end

	return false, v2
end

return getAssetCreationDetails
