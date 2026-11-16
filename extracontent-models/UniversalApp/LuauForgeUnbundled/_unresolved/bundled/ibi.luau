local getFriendsActiveGamesPlaceIdsFromUsersPresence = require("@luauforge/bundled/cgr").Utils.getFriendsActiveGamesPlaceIdsFromUsersPresence

local apiFetchGamesDataByPlaceIds = require("@luauforge/bundled/dyi").GamesByPlaceId.ApiFetchGamesDataByPlaceIds

return function(p2, p3)
	return function(object)
		object:dispatch(apiFetchGamesDataByPlaceIds(
			p2,
			(getFriendsActiveGamesPlaceIdsFromUsersPresence(p3, object))
		))
	end
end
