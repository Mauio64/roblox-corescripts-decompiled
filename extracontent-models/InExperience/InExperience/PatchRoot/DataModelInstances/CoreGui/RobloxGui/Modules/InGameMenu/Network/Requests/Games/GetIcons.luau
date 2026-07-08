local ParentParent = script.Parent.Parent.Parent.Parent
local Url = require(ParentParent.Network.Url)

return function(p1, p2) -- line: 20
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/games/%d/icon", Url.GAME_URL, p2), "GET")
end
