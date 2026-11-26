local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/AppCommonLib").Immutable
local AddGameDetailsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/AddGameDetailsV2")

return function(options, p2)
	local v5 = options or {}

	if p2.type == AddGameDetailsV2.name then
		v5 = immutable.JoinDictionaries(v5, p2.gameDetails)
	end

	return v5
end
