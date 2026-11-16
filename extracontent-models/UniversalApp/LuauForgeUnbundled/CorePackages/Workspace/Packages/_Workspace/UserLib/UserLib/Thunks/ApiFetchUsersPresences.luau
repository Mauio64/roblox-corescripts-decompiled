local getFriendsActiveGamesPlaceIdsFromUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/getFriendsActiveGamesPlaceIdsFromUsersPresence")
local receiveUsersPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Utils/receiveUsersPresence")

local apiFetchGamesDataByPlaceIds = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/GameDetailRodux").GamesByPlaceId.ApiFetchGamesDataByPlaceIds

local UsersGetPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Requests/UsersGetPresence")

return function(p2, p3)
	return function(object)
		return UsersGetPresence(p2, p3):andThen(function(p4)
			local userPresences = p4.responseBody.userPresences
			receiveUsersPresence(userPresences, object)

			object:dispatch(apiFetchGamesDataByPlaceIds(p2, (getFriendsActiveGamesPlaceIdsFromUsersPresence(userPresences, object))))
		end)
	end
end
