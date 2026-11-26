local GetUserSettingsAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/GetUserSettingsAndOptions")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Promise")

return function(p2)
	return GetUserSettingsAndOptions(p2):andThen(function(p3)
		local responseBody = p3.responseBody

		if not responseBody then
			Promise.reject("Unexpected response when fetching user settings and options")
		end

		return Promise.resolve(responseBody)
	end, function(p3)
		return Promise.reject(p3)
	end)
end
