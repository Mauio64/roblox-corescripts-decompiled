local SessionType = require(script.Parent.SessionType)

return function(p1, p2, p3) -- line: 8
	-- upvalues: SessionType (copy)
	assert(p1, "sessionManager can't be nil")
	p1:RemoveSessionsWithMetadataKey(SessionType.Metadata.GamePlay.GamePlaySession)
	p1:SetSession(SessionType.StructuralIdentifier.Level1, p2, p2)
	p1:SetMetadata(p2, SessionType.Metadata.GamePlay.GamePlaySession, "True")

	if p3 then
		p1:SetMetadata(p2, SessionType.Metadata.GamePlay.DeleteOnGameLeave, "True")
	end
end
