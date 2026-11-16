local SessionType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppSessionization/RobloxAppSessionization/SessionType")

return function(object, p2, p3)
	assert(object, "sessionManager can't be nil")

	object:RemoveSessionsWithMetadataKey(SessionType.Metadata.GamePlay.GamePlaySession)
	object:SetSession(SessionType.StructuralIdentifier.Level1, p2, p2)
	object:SetMetadata(p2, SessionType.Metadata.GamePlay.GamePlaySession, "True")

	if p3 then
		object:SetMetadata(p2, SessionType.Metadata.GamePlay.DeleteOnGameLeave, "True")
	end
end
