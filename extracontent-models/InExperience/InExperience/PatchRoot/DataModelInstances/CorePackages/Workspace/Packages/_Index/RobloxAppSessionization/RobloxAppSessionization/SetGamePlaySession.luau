local SessionType = require(script.Parent.SessionType)

return function(object, p, p2)
	assert(object, "sessionManager can't be nil")

	object:RemoveSessionsWithMetadataKey(SessionType.Metadata.GamePlay.GamePlaySession)
	object:SetSession(SessionType.StructuralIdentifier.Level1, p, p)
	object:SetMetadata(p, SessionType.Metadata.GamePlay.GamePlaySession, "True")

	if p2 then
		object:SetMetadata(p, SessionType.Metadata.GamePlay.DeleteOnGameLeave, "True")
	end
end
