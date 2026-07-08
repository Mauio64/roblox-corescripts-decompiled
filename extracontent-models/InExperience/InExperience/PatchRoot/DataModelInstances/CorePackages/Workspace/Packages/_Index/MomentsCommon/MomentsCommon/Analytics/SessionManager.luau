local HttpService = game:GetService("HttpService")
local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Analytics.FunnelEventNames)

local t1 = {}

return {
	startSession = function(p1) -- line: 16
		-- upvalues: HttpService (copy), t1 (copy)
		local guid = HttpService:GenerateGUID()

		t1[p1] = guid

		return guid
	end,
	getSessionId = function(p2) -- line: 22
		-- upvalues: t1 (copy)
		return t1[p2]
	end,
	endSession = function(p3) -- line: 26
		-- upvalues: t1 (copy)
		if t1[p3] then
			t1[p3] = nil

			return true
		end

		return false
	end
}
