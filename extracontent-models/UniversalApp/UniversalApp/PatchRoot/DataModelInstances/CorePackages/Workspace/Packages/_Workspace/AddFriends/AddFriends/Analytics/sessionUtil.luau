local Parent = script:FindFirstAncestor("AddFriends").Parent
local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")
local SessionType = require(Parent.RobloxAppSessionization).SessionType

return {
	initializeSession = function() -- line: 9
		-- upvalues: HttpService (copy), SessionService (copy), SessionType (copy)
		local guid = HttpService:GenerateGUID(false)

		SessionService:SetSession(SessionType.StructuralIdentifier.Level2a, SessionType.StructuralIdentifier.AddFriendsPage, SessionType.StructuralIdentifier.AddFriendsPage)
		SessionService:SetMetadata(SessionType.StructuralIdentifier.AddFriendsPage, SessionType.Metadata.AddFriendsPage.AddFriendsSessionId, guid)

		return guid
	end,
	getSessionId = function() -- line: 26
		-- upvalues: SessionService (copy), SessionType (copy)
		if SessionService:SessionExists(SessionType.StructuralIdentifier.AddFriendsPage) then
			return SessionService:GetMetadata(SessionType.StructuralIdentifier.AddFriendsPage, SessionType.Metadata.AddFriendsPage.AddFriendsSessionId)
		end

		return ""
	end,
	destroySession = function() -- line: 35
		-- upvalues: SessionService (copy), SessionType (copy)
		SessionService:RemoveSession(SessionType.StructuralIdentifier.AddFriendsPage)
	end
}
