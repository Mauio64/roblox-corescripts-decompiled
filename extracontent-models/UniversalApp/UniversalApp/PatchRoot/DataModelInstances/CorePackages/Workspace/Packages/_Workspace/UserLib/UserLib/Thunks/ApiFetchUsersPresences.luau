local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local getFriendsActiveGamesPlaceIdsFromUsersPresence = require(UserLib.Utils.getFriendsActiveGamesPlaceIdsFromUsersPresence)
local receiveUsersPresence = require(UserLib.Utils.receiveUsersPresence)
local ApiFetchGamesDataByPlaceIds = require(UserLibParent.GameDetailRodux).GamesByPlaceId.ApiFetchGamesDataByPlaceIds
local UsersGetPresence = require(UserLib.Requests.UsersGetPresence)

return function(p1, p2) -- line: 12
	-- upvalues: UsersGetPresence (copy), receiveUsersPresence (copy), getFriendsActiveGamesPlaceIdsFromUsersPresence (copy), ApiFetchGamesDataByPlaceIds (copy)
	return function(p3) -- line: 13
		-- upvalues: UsersGetPresence (copy), p1 (copy), p2 (copy), receiveUsersPresence (copy), getFriendsActiveGamesPlaceIdsFromUsersPresence (copy), ApiFetchGamesDataByPlaceIds (copy)
		return UsersGetPresence(p1, p2):andThen(function(p4) -- line: 14
			-- upvalues: receiveUsersPresence (copy), p3 (copy), getFriendsActiveGamesPlaceIdsFromUsersPresence (copy), ApiFetchGamesDataByPlaceIds (copy), p1 (copy)
			local userPresences = p4.responseBody.userPresences

			receiveUsersPresence(userPresences, p3)

			local v12 = getFriendsActiveGamesPlaceIdsFromUsersPresence(userPresences, p3)

			p3:dispatch(ApiFetchGamesDataByPlaceIds(p1, v12))
		end)
	end
end
