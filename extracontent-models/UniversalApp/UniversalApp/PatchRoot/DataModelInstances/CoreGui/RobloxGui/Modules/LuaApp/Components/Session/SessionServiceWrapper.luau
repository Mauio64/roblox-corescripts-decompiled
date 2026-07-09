local SessionService = game:GetService("SessionService")
local CorePackages = game:GetService("CorePackages")

if game:DefineFastFlag("UseSessionServiceWrapperModule", false) then
	return require(CorePackages.Workspace.Packages.SessionizationUtil).SessionServiceWrapper
end

return {
	SessionChangedSignal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal.new(),
	GetRootSID = function(_) -- line: 21
		-- upvalues: SessionService (copy)
		return SessionService:GetRootSID()
	end,
	SetSession = function(p2, p3, p4, p5) -- line: 25
		-- upvalues: SessionService (copy)
		local SessionTag = SessionService:GetSessionTag(p4)

		SessionService:SetSession(p3, p4, p5)

		local SessionTag2 = SessionService:GetSessionTag(p4)

		if SessionTag2 ~= SessionTag then
			p2.SessionChangedSignal:fire(p4, SessionTag2)
		end
	end,
	ReplaceSession = function(p6, p7, p8) -- line: 37
		-- upvalues: SessionService (copy)
		local SessionTag = SessionService:GetSessionTag(p7)

		SessionService:ReplaceSession(p7, p8)

		local SessionTag3 = SessionService:GetSessionTag(p7)

		if SessionTag3 ~= SessionTag then
			p6.SessionChangedSignal:fire(p7, SessionTag3)
		end
	end,
	RemoveSession = function(_, p10) -- line: 49
		-- upvalues: SessionService (copy)
		SessionService:RemoveSession(p10)
	end,
	RemoveSessionsWithMetadataKey = function(_, p12) -- line: 53
		-- upvalues: SessionService (copy)
		SessionService:RemoveSessionsWithMetadataKey(p12)
	end,
	GetMetadata = function(_, p14, p15) -- line: 57
		-- upvalues: SessionService (copy)
		return SessionService:GetMetadata(p14, p15)
	end,
	SetMetadata = function(_, p17, p18, p19) -- line: 61
		-- upvalues: SessionService (copy)
		SessionService:SetMetadata(p17, p18, p19)
	end,
	RemoveMetadata = function(_, p21, p22) -- line: 65
		-- upvalues: SessionService (copy)
		SessionService:RemoveMetadata(p21, p22)
	end,
	SessionExists = function(_, p24) -- line: 69
		-- upvalues: SessionService (copy)
		return SessionService:SessionExists(p24)
	end,
	GetSessionTag = function(_, p26) -- line: 73
		-- upvalues: SessionService (copy)
		return SessionService:GetSessionTag(p26)
	end,
	generateSessionInfoString = function(_, p28, p29, p30, p31) -- line: 77
		-- upvalues: SessionService (copy)
		return SessionService:GenerateSessionInfoString(p28, p29, p30, p31)
	end
}
