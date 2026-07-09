local Parent = script:FindFirstAncestor("PlaceInfoRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 6
	-- upvalues: Url (copy)
	local t1 = {
		placeIds = p2
	}
	local v6 = Url:makeQueryString(t1)

	return p1(string.format("%s/v1/games/multiget-place-details?%s", Url.GAME_URL, v6), "GET")
end
