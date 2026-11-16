require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/FollowingStoreTypes")
local FollowingUpdateErrorTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/FollowingUpdateErrorTypeEnum")

local v5 = {
	[2] = FollowingUpdateErrorTypeEnum.Blocked,
	[3] = FollowingUpdateErrorTypeEnum.Blocked,
	[8] = FollowingUpdateErrorTypeEnum.SelfFollow,
	[9] = FollowingUpdateErrorTypeEnum.FloodLimit,
	[14] = FollowingUpdateErrorTypeEnum.Captcha,
	[429] = FollowingUpdateErrorTypeEnum.FloodLimit,
	[503] = FollowingUpdateErrorTypeEnum.Unavailable
}

local function classifyFollowingError(p2)
	local responseCode = if type(p2) == "table" then p2.responseCode else nil
	local v6 = if type(responseCode) == "number" then v5[responseCode] else nil

	if v6 == nil then
		v6 = FollowingUpdateErrorTypeEnum.NetworkError
	end

	return { type = "error", errorType = v6, responseCode = responseCode }
end

return classifyFollowingError
