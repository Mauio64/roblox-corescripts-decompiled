local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/AppCommonLib").Immutable
local AddGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/AddGameDetails")

return function(options, p2)
	local v5 = options or {}

	if p2.type == AddGameDetails.name then
		v5 = immutable.JoinDictionaries(v5, p2.gameDetails)
	end

	return v5
end
