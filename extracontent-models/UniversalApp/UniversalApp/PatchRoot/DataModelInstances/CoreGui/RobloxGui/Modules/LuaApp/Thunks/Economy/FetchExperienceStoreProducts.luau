local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local ApiFetchGameDeveloperProducts = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchGameDeveloperProducts)
local ApiFetchGameSubscriptionProducts = require(Modules.LuaApp.Thunks.Subscription.ApiFetchGameSubscriptionProducts)
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)

return function(p1, p2) -- line: 17
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), ApiFetchGamePasses (copy), ApiFetchGameSubscriptionProducts (copy), ApiFetchGameDeveloperProducts (copy)
	if type(p2) ~= "string" then
		error(string.format("FetchExperienceStoreProducts thunk expects universeId to be a string. Got type: '%s', value: '%s'", type(p2), (tostring(p2))))
	end

	return function(p3) -- line: 28
		-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), p2 (copy), ApiFetchGamePasses (copy), p1 (copy), ApiFetchGameSubscriptionProducts (copy), ApiFetchGameDeveloperProducts (copy)
		if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(p2)
		else
			p3:dispatch(ApiFetchGamePasses(p1, p2))
		end

		p3:dispatch(ApiFetchGameSubscriptionProducts(p1, p2))

		local v12 = p3:getState()
		local GameDetailsV2 = v12.GameDetailsV2
		local v14 = GameDetailsV2 and GameDetailsV2[p2]

		if not v14 or not v14.rootPlaceId then
			local GameDetails = v12.GameDetails

			v14 = GameDetails and GameDetails[p2]
		end

		if v14 and v14.rootPlaceId and v12.LocalUserId then
			p3:dispatch(ApiFetchGameDeveloperProducts(p1, p2, v14.rootPlaceId, v12.LocalUserId))
		end
	end
end
