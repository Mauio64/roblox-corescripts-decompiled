require(script.Parent.FollowingStoreTypes)
local FollowingUpdateErrorTypeEnum = require(script.Parent.FollowingUpdateErrorTypeEnum)

local v = {
	[2] = FollowingUpdateErrorTypeEnum.Blocked,
	[3] = FollowingUpdateErrorTypeEnum.Blocked,
	[8] = FollowingUpdateErrorTypeEnum.SelfFollow,
	[9] = FollowingUpdateErrorTypeEnum.FloodLimit,
	[14] = FollowingUpdateErrorTypeEnum.Captcha,
	[429] = FollowingUpdateErrorTypeEnum.FloodLimit,
	[503] = FollowingUpdateErrorTypeEnum.Unavailable
}

local function classifyFollowingError(p)
	local responseCode

	if type(p) == "table" then
		responseCode = p.responseCode
	end

	local errorType

	if type(responseCode) == "number" then
		errorType = v[responseCode]
	end

	if errorType == nil then
		errorType = FollowingUpdateErrorTypeEnum.NetworkError
	end

	return { type = "error", errorType = errorType, responseCode = responseCode }
end

return classifyFollowingError
