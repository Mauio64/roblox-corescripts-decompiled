local parent = script.Parent.Parent

local APIUtil = require(parent.util.APIUtil)

local HttpService = game:GetService("HttpService")

local baseDomain = APIUtil.getBaseDomain()
local v = string.format("https://apis.%s", baseDomain) .. "assets/rcc/v1/assets/%s"

local function getAssetCreationDetailsRCC(p: string)
	local v2 = string.format(v, p)
	local requestAndRetryGet, v3 = APIUtil.requestAndRetryGet(v2)

	if requestAndRetryGet then
		return true, HttpService:JSONDecode(v3)
	end

	return false, v3
end

return getAssetCreationDetailsRCC
