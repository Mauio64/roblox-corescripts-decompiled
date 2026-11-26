local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")
local sessionType = require("@luauforge/deferred/eiG").SessionType

return {
	initializeSession = function()
		local guid = HttpService:GenerateGUID(false)

		SessionService:SetSession(
			sessionType.StructuralIdentifier.Level2a,
			sessionType.StructuralIdentifier.AddFriendsPage,
			sessionType.StructuralIdentifier.AddFriendsPage
		)

		SessionService:SetMetadata(
			sessionType.StructuralIdentifier.AddFriendsPage,
			sessionType.Metadata.AddFriendsPage.AddFriendsSessionId,
			guid
		)

		return guid
	end,
	getSessionId = function()
		if SessionService:SessionExists(sessionType.StructuralIdentifier.AddFriendsPage) then
			return SessionService:GetMetadata(
				sessionType.StructuralIdentifier.AddFriendsPage,
				sessionType.Metadata.AddFriendsPage.AddFriendsSessionId
			)
		end

		return ""
	end,
	setPymkSessionId = function(p2)
		if SessionService:SessionExists(sessionType.StructuralIdentifier.AddFriendsPage) then
			SessionService:SetMetadata(
				sessionType.StructuralIdentifier.AddFriendsPage,
				sessionType.Metadata.AddFriendsPage.PymkSessionId,
				p2
			)
		end
	end,
	getPymkSessionId = function()
		if SessionService:SessionExists(sessionType.StructuralIdentifier.AddFriendsPage) then
			return SessionService:GetMetadata(
				sessionType.StructuralIdentifier.AddFriendsPage,
				sessionType.Metadata.AddFriendsPage.PymkSessionId
			)
		end

		return ""
	end,
	destroySession = function()
		SessionService:RemoveSession(sessionType.StructuralIdentifier.AddFriendsPage)
	end
}
