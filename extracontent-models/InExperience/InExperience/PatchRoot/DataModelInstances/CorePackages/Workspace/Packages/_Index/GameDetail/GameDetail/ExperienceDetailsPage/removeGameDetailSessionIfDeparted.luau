local parent = script:FindFirstAncestor("GameDetail").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
require(parent.NavigationRodux)
local RobloxAppSessionization = require(parent.RobloxAppSessionization)
local SessionType = RobloxAppSessionization.SessionType
local DiscoveryRouting = require(parent.DiscoveryRouting)
local hasPageInCurrentRoute = DiscoveryRouting.hasPageInCurrentRoute

local function removeGameDetailSessionIfDeparted(object, p)
	if
		object
		and p
		and not (hasPageInCurrentRoute(p, AppPage.GameDetail, true) or hasPageInCurrentRoute(p, AppPage.ExperienceDetail, true))
	then
		object:RemoveSession(SessionType.StructuralIdentifier.GameDetailSource)
	end
end

return removeGameDetailSessionIfDeparted
