local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Packages = CorePackages.Workspace.Packages
local AppPage = require(Packages.RobloxAppEnums).AppPage
local FFlagFriendsActivityFeedEnabled = require(Packages.SharedFlags).FFlagFriendsActivityFeedEnabled
local t1 = {
	{
		textKey = "Feature.AddFriends.Heading.FindPeople",
		id = AppPage.CoHubAddConnections,
		getScreen = function() -- line: 15
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.AddFriends.AddFriendsUniversalAppWrapper)
		end
	},
	{
		textKey = "Feature.Friends.Heading.MyConnections",
		id = AppPage.CoHubMyConnections,
		getScreen = function() -- line: 22
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.FriendsLanding.FriendsLandingUniversalAppWrapper.Container)
		end
	}
}

if FFlagFriendsActivityFeedEnabled then
	table.insert(t1, require(CorePackages.Workspace.Packages.FriendsActivityFeed).getActivitiesTabConfig())
end

return t1
