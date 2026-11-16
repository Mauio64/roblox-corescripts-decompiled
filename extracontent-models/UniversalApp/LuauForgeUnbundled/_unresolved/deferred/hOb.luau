local sessionType = require("@luauforge/bundled/foF").SessionType

local searchLandingPageSession = require("@luauforge/bundled/dpZ").Modules.Personalization.Sessions.SearchLandingPageSession

return function(object, p2)
	if object:SessionExists(sessionType.StructuralIdentifier.SearchLandingPage) then
		if p2 then
			searchLandingPageSession:Refresh()
		end
	else
		searchLandingPageSession:Refresh()
		object:SetSession(
			sessionType.StructuralIdentifier.Level1,
			sessionType.StructuralIdentifier.SearchLandingPage,
			sessionType.StructuralIdentifier.SearchLandingPage
		)
	end

	object:SetMetadata(
		sessionType.StructuralIdentifier.SearchLandingPage,
		sessionType.Metadata.SearchLandingPage.SearchLandingPageSessionId,
		searchLandingPageSession:Get()
	)
end
