local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GetUserSettingsAndOptions = require(GameDetailRodux.GameDetails.GetUserSettingsAndOptions)

local parent = GameDetailRodux.Parent
local Promise = require(parent.Promise)

return function(p)
	return GetUserSettingsAndOptions(p):andThen(function(p2)
		local responseBody = p2.responseBody

		if not responseBody then
			Promise.reject("Unexpected response when fetching user settings and options")
		end

		return Promise.resolve(responseBody)
	end, function(p2)
		return Promise.reject(p2)
	end)
end
