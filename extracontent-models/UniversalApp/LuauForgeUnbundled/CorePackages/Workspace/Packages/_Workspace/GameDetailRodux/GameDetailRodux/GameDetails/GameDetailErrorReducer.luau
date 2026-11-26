local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/AppCommonLib").Immutable
local AddGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/AddGameDetails")
local SetGameDetailError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/SetGameDetailError")

return function(options, data)
	local v5 = options or {}

	if data.type == SetGameDetailError.name then
		return (immutable.Set(v5, data.universeId, { errorType = data.errorType }))
	end

	if not (data.type == AddGameDetails.name and next(v5)) then
		return v5
	end

	for k, gameDetail in pairs(data.gameDetails) do
		if v5[k] then
			v5 = immutable.RemoveFromDictionary(v5, k)
		end
	end

	return v5
end
