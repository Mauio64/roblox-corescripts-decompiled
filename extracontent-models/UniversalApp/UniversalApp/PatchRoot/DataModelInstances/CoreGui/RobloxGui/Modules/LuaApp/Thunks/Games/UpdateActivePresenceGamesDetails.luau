local CorePackages = game:GetService("CorePackages")
local getFriendsActiveGamesPlaceIdsFromUsersPresence = require(CorePackages.Workspace.Packages.UserLib).Utils.getFriendsActiveGamesPlaceIdsFromUsersPresence
local ApiFetchGamesDataByPlaceIds = require(CorePackages.Workspace.Packages.GameDetailRodux).GamesByPlaceId.ApiFetchGamesDataByPlaceIds

return function(p1, p2) -- line: 8
	-- upvalues: getFriendsActiveGamesPlaceIdsFromUsersPresence (copy), ApiFetchGamesDataByPlaceIds (copy)
	return function(p3) -- line: 9
		-- upvalues: getFriendsActiveGamesPlaceIdsFromUsersPresence (copy), p2 (copy), ApiFetchGamesDataByPlaceIds (copy), p1 (copy)
		local v7 = getFriendsActiveGamesPlaceIdsFromUsersPresence(p2, p3)

		p3:dispatch(ApiFetchGamesDataByPlaceIds(p1, v7))
	end
end
