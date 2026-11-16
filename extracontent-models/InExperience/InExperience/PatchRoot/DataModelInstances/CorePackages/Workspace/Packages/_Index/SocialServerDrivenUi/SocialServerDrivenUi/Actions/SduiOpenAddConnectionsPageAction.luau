local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
require(parent.SduiCoreSystem)

local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

return function(_, _, p, _)
	if FFlagCreateConnectionsHub then
		p.dependencies.getNavigation().navigate(AppPage.CoHubAddConnections)
		return
	end

	local v = { name = AppPage.AddFriendsPage }

	if FFlagSignalsNavP3Dispatch then
		navigationCommands.down(navigationCommands.fromLegacyPage(v))
	else
		p.dependencies.dispatch(NavigateDown(v))
	end
end
