local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local getFriendsActiveGamesPlaceIdsFromUsersPresence = require(UserLib.Utils.getFriendsActiveGamesPlaceIdsFromUsersPresence)
local receiveUsersPresence = require(UserLib.Utils.receiveUsersPresence)

local GameDetailRodux = require(parent.GameDetailRodux)
local ApiFetchGamesDataByPlaceIds = GameDetailRodux.GamesByPlaceId.ApiFetchGamesDataByPlaceIds

local UsersGetPresence = require(UserLib.Requests.UsersGetPresence)

return function(p, p2)
	return function(object)
		return UsersGetPresence(p, p2):andThen(function(p3)
			local userPresences = p3.responseBody.userPresences
			receiveUsersPresence(userPresences, object)

			object:dispatch(ApiFetchGamesDataByPlaceIds(
				p,
				(getFriendsActiveGamesPlaceIdsFromUsersPresence(userPresences, object))
			))
		end)
	end
end
