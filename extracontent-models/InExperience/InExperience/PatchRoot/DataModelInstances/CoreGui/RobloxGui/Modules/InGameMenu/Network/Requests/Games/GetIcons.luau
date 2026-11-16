local parent = script.Parent.Parent.Parent.Parent
local Url = require(parent.Network.Url)

return function(callback, p)
	return callback(string.format("%sv1/games/%d/icon", Url.GAME_URL, p), "GET")
end
