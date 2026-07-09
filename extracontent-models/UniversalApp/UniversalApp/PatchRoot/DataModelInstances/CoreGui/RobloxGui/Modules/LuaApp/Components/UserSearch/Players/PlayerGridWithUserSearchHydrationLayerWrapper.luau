local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local UserSearchHydrationLayer = require(Modules.LuaApp.Components.UserSearch.api).UserSearchHydrationLayer
local PlayerGrid = require(script.Parent.PlayerGrid)

require(script.Parent.Parent.UserSearchTileUniversalWrapper.UserSearchTileUniversalWrapper)
require(CorePackages.Workspace.Packages.GraphQLServer)

local FFlagPlayerSearchEnableOnlineFrequents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequents
local FFlagPlayerSearchEnableOnlineFrequentsForAll = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerSearchEnableOnlineFrequentsForAll

return function(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), UserSearchHydrationLayer (copy), FFlagPlayerSearchEnableOnlineFrequents (copy), FFlagPlayerSearchEnableOnlineFrequentsForAll (copy), PlayerGrid (copy), Cryo (copy)
	return React.createElement(UserSearchHydrationLayer, {
		users = t1.entries,
		searchParameters = t1.searchParameters,
		enableOnlineFrequents = if not FFlagPlayerSearchEnableOnlineFrequents or FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else t1.enableOnlineFrequents,
		renderComponent = function(t2: {[any]: any}) -- line: 47
			-- upvalues: React (copy), PlayerGrid (copy), Cryo (copy), t1 (copy)
			return React.createElement(PlayerGrid, Cryo.Dictionary.join(t1, {
				mappedProfilesInsights = t2.mappedProfilesInsights
			}))
		end
	})
end
