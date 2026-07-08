local ParentParent = script.Parent.Parent
local APIUtil = require(ParentParent.util.APIUtil)
local HttpService = game:GetService("HttpService")
local v4 = APIUtil.getBaseDomain()
local v5 = string.format("https://apis.%s", v4) .. "assets/rcc/v1/assets/%s"

local function getAssetCreationDetailsRCC(s1: string) -- line: 15
	-- upvalues: v5 (copy), APIUtil (copy), HttpService (copy)
	local v8 = string.format(v5, s1)
	local v9, v10 = APIUtil.requestAndRetryGet(v8)

	if v9 then
		return true, HttpService:JSONDecode(v10)
	end

	return false, v10
end

return getAssetCreationDetailsRCC
