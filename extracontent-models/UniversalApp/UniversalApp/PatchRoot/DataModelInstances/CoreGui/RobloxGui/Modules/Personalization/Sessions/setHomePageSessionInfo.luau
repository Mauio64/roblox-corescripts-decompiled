local CorePackages = game:GetService("CorePackages")
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType

return function(p1, p2, p3) -- line: 4
	-- upvalues: SessionType (copy)
	if p1 == nil then
		return
	end

	p1:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.HomePageSessionInfo, SessionType.StructuralIdentifier.HomePageSessionInfo)

	if p2 then
		p1:SetMetadata(SessionType.StructuralIdentifier.HomePageSessionInfo, SessionType.Metadata.HomePageSessionInfo.RequestId, p2)
	end

	if p3 then
		p1:SetMetadata(SessionType.StructuralIdentifier.HomePageSessionInfo, SessionType.Metadata.HomePageSessionInfo.OmniSessionId, p3)
	end
end
