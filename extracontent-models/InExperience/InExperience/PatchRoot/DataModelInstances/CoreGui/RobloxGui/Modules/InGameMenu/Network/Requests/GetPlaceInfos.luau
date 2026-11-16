local parent = script.Parent.Parent.Parent
local Url = require(parent.Network.Url)

return function(callback, placeIds)
	for i, item in ipairs(placeIds) do
		placeIds[i] = tostring(item)
	end

	local queryString = Url:makeQueryString({ placeIds = placeIds })
	return callback(string.format("%s/v1/games/multiget-place-details?%s", Url.GAME_URL, queryString), "GET")
end
