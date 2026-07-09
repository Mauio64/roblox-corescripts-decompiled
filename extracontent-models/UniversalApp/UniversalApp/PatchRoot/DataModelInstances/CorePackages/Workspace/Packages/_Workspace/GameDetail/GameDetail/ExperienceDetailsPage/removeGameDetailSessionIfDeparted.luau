local Parent = script:FindFirstAncestor("GameDetail").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

require(Parent.NavigationRodux)

local SessionType = require(Parent.RobloxAppSessionization).SessionType
local hasPageInCurrentRoute = require(Parent.DiscoveryRouting).hasPageInCurrentRoute

local function removeGameDetailSessionIfDeparted(p1, p2) -- line: 11
	-- upvalues: hasPageInCurrentRoute (copy), AppPage (copy), SessionType (copy)
	if not p1 or not p2 then
		return
	end

	if not hasPageInCurrentRoute(p2, AppPage.GameDetail, true) and not hasPageInCurrentRoute(p2, AppPage.ExperienceDetail, true) then
		p1:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
	end
end

return removeGameDetailSessionIfDeparted
