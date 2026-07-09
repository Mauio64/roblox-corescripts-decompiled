local CorePackages = game:GetService("CorePackages")
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local SearchLandingPageSession = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Sessions.SearchLandingPageSession

return function(p1, b1: boolean?) -- line: 6
	-- upvalues: SessionType (copy), SearchLandingPageSession (copy)
	if not p1:SessionExists(SessionType.StructuralIdentifier.SearchLandingPage) then
		SearchLandingPageSession:Refresh()
		p1:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.SearchLandingPage, SessionType.StructuralIdentifier.SearchLandingPage)
	elseif b1 then
		SearchLandingPageSession:Refresh()
	end

	p1:SetMetadata(SessionType.StructuralIdentifier.SearchLandingPage, SessionType.Metadata.SearchLandingPage.SearchLandingPageSessionId, SearchLandingPageSession:Get())
end
