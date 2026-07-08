local ParentParent = script.Parent.Parent
local APIUtil = require(ParentParent.util.APIUtil)
local HttpService = game:GetService("HttpService")
local v4 = APIUtil.getBaseDomain()
local v5 = string.format("https://itemconfiguration.%s", v4) .. "v1/creations/get-asset-details"

local function getAssetCreationDetails(p1) -- line: 13
	-- upvalues: APIUtil (copy), v5 (copy), HttpService (copy)
	local v8, v9 = APIUtil.requestAndRetryPost(v5, HttpService:JSONEncode({
		assetIds = p1
	}))

	if v8 then
		return true, HttpService:JSONDecode(v9)
	end

	return false, v9
end

return getAssetCreationDetails
