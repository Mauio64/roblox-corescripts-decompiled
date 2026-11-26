local SessionService = game:GetService("SessionService")

if game:DefineFastFlag("UseSessionServiceWrapperModule", false) then
	return require("@luauforge/bundled/ifx").SessionServiceWrapper
end

local v5 = {
	SessionChangedSignal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal.new()
}

function v5:GetRootSID()
	return SessionService:GetRootSID()
end

function v5:SetSession(p3, p4, p5)
	local sessionTag = SessionService:GetSessionTag(p4)

	SessionService:SetSession(p3, p4, p5)

	local sessionTag2 = SessionService:GetSessionTag(p4)

	if sessionTag2 ~= sessionTag then
		self.SessionChangedSignal:fire(p4, sessionTag2)
	end
end

function v5:ReplaceSession(p3, p4)
	local sessionTag = SessionService:GetSessionTag(p3)

	SessionService:ReplaceSession(p3, p4)

	local sessionTag2 = SessionService:GetSessionTag(p3)

	if sessionTag2 ~= sessionTag then
		self.SessionChangedSignal:fire(p3, sessionTag2)
	end
end

function v5:RemoveSession(p3)
	SessionService:RemoveSession(p3)
end

function v5:RemoveSessionsWithMetadataKey(p3)
	SessionService:RemoveSessionsWithMetadataKey(p3)
end

function v5.GetMetadata(p2, p3, p4)
	return SessionService:GetMetadata(p3, p4)
end

function v5:SetMetadata(p3, p4, p5)
	SessionService:SetMetadata(p3, p4, p5)
end

function v5:RemoveMetadata(p3, p4)
	SessionService:RemoveMetadata(p3, p4)
end

function v5:SessionExists(p3)
	return SessionService:SessionExists(p3)
end

function v5:GetSessionTag(p3)
	return SessionService:GetSessionTag(p3)
end

function v5:generateSessionInfoString(p3, p4, p5, p6)
	return SessionService:GenerateSessionInfoString(p3, p4, p5, p6)
end

return v5
