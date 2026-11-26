local getFriendsActiveGamesPlaceIdsFromUsersPresence = require("@luauforge/bundled/ciE").Utils.getFriendsActiveGamesPlaceIdsFromUsersPresence

local apiFetchGamesDataByPlaceIds = require("@luauforge/bundled/dBl").GamesByPlaceId.ApiFetchGamesDataByPlaceIds

return function(p2, p3)
	return function(object)
		object:dispatch(apiFetchGamesDataByPlaceIds(
			p2,
			(getFriendsActiveGamesPlaceIdsFromUsersPresence(p3, object))
		))
	end
end
