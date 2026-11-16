local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/FunnelEventNames")

local v5 = {}

return {
	startSession = function(p2)
		local guid = HttpService:GenerateGUID()
		v5[p2] = guid
		return guid
	end,
	getSessionId = function(p2)
		return v5[p2]
	end,
	endSession = function(p2): boolean
		if not v5[p2] then
			return false
		end

		v5[p2] = nil
		return true
	end
}
