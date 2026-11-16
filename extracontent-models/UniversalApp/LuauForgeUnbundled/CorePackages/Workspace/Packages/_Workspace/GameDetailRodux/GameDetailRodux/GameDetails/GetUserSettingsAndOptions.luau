local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").Url

return function(callback)
	return callback(`{url.APIS_URL}user-settings-api/v1/user-settings/settings-and-options`, "GET")
end
