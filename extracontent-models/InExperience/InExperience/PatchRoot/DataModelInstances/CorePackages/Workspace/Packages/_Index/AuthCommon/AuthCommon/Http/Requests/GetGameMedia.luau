local parent = script:FindFirstAncestor("AuthCommon").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: string)
	return callback(string.format("%sv2/games/%s/media", Url.GAME_URL, p), "GET")
end
