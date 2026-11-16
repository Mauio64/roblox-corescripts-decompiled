local parent = script:FindFirstAncestor("SessionizationUtil").Parent

local SessionService = game:GetService("SessionService")
local AppCommonLib = require(parent.AppCommonLib)
local SessionServiceWrapper = { SessionChangedSignal = AppCommonLib.Signal.new() }

function SessionServiceWrapper:GetRootSID()
	return SessionService:GetRootSID()
end

function SessionServiceWrapper:SetSession(p, p2, p3)
	local sessionTag = SessionService:GetSessionTag(p2)

	SessionService:SetSession(p, p2, p3)

	local sessionTag2 = SessionService:GetSessionTag(p2)

	if sessionTag2 ~= sessionTag then
		self.SessionChangedSignal:fire(p2, sessionTag2)
	end
end

function SessionServiceWrapper:ReplaceSession(p, p2)
	local sessionTag = SessionService:GetSessionTag(p)

	SessionService:ReplaceSession(p, p2)

	local sessionTag2 = SessionService:GetSessionTag(p)

	if sessionTag2 ~= sessionTag then
		self.SessionChangedSignal:fire(p, sessionTag2)
	end
end

function SessionServiceWrapper:RemoveSession(p)
	SessionService:RemoveSession(p)
end

function SessionServiceWrapper:RemoveSessionsWithMetadataKey(p)
	SessionService:RemoveSessionsWithMetadataKey(p)
end

function SessionServiceWrapper:GetMetadata(p, p2)
	return SessionService:GetMetadata(p, p2)
end

function SessionServiceWrapper:SetMetadata(p, p2, p3)
	SessionService:SetMetadata(p, p2, p3)
end

function SessionServiceWrapper:RemoveMetadata(p, p2)
	SessionService:RemoveMetadata(p, p2)
end

function SessionServiceWrapper:SessionExists(p)
	return SessionService:SessionExists(p)
end

function SessionServiceWrapper:GetSessionTag(p)
	return SessionService:GetSessionTag(p)
end

function SessionServiceWrapper.generateSessionInfoString(_, p, p2, p3, p4)
	return SessionService:GenerateSessionInfoString(p, p2, p3, p4)
end

return SessionServiceWrapper
