local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigateDown = require(Parent.NavigationRodux).Thunks.NavigateDown

require(Parent.SduiCoreSystem)

local FFlagCreateConnectionsHub = require(Parent.SharedFlags).FFlagCreateConnectionsHub
local FFlagSignalsNavP3Dispatch = require(Parent.SharedFlags).FFlagSignalsNavP3Dispatch
local v6 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands

return function(_, _, p3, _) -- line: 18
	-- upvalues: FFlagCreateConnectionsHub (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v6 (copy), NavigateDown (copy)
	if FFlagCreateConnectionsHub then
		p3.dependencies.getNavigation().navigate(AppPage.CoHubAddConnections)

		return
	end

	local t1 = {
		name = AppPage.AddFriendsPage
	}

	if FFlagSignalsNavP3Dispatch then
		v6.down(v6.fromLegacyPage(t1))

		return
	end

	p3.dependencies.dispatch(NavigateDown(t1))
end
