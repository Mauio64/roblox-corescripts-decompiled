local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

return function(callback, p2)
	return callback(string.format("%sv2/games/%s/media", url.GAME_URL, p2), "GET")
end
