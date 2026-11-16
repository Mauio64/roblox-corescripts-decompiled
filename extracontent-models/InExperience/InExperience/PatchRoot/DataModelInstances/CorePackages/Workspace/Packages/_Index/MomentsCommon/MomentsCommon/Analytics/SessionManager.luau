local HttpService = game:GetService("HttpService")

local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

require(MomentsCommon.Analytics.FunnelEventNames)

local v = {}
local SessionManager = {}

function SessionManager.startSession(p)
	local guid = HttpService:GenerateGUID()
	v[p] = guid
	return guid
end

function SessionManager.getSessionId(p)
	return v[p]
end

function SessionManager.endSession(p): boolean
	if not v[p] then
		return false
	end

	v[p] = nil
	return true
end

return SessionManager
