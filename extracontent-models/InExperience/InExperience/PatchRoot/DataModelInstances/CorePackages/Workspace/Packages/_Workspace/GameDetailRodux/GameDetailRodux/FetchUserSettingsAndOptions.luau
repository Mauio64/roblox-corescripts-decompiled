local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GetUserSettingsAndOptions = require(GameDetailRodux.GameDetails.GetUserSettingsAndOptions)
local GameDetailRoduxParent = GameDetailRodux.Parent
local Promise = require(GameDetailRoduxParent.Promise)

return function(p1) -- line: 7
	-- upvalues: GetUserSettingsAndOptions (copy), Promise (copy)
	return GetUserSettingsAndOptions(p1):andThen(function(p2) -- line: 8
		-- upvalues: Promise (copy)
		local responseBody = p2.responseBody

		if not responseBody then
			Promise.reject("Unexpected response when fetching user settings and options")
		end

		return Promise.resolve(responseBody)
	end, function(p3) -- line: 16
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
