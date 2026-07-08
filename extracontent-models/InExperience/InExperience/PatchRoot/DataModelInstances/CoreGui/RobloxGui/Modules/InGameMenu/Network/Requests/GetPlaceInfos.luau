local ParentParent = script.Parent.Parent.Parent
local Url = require(ParentParent.Network.Url)

return function(p1, p2) -- line: 4
	-- upvalues: Url (copy)
	for i, v in ipairs(p2) do
		p2[i] = tostring(v)
	end

	local t1 = {
		placeIds = p2
	}
	local v8 = Url:makeQueryString(t1)

	return p1(string.format("%s/v1/games/multiget-place-details?%s", Url.GAME_URL, v8), "GET")
end
