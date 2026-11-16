local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/AppCommonLib").Immutable
local SetGamesProductInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/SetGamesProductInfo")
require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GameProductInfo")

return {
	key = "GamesProductInfoKey",
	reducer = function(options, p2)
		local v5 = options or {}
		assert(v5, "")

		if p2.type == SetGamesProductInfo.name then
			v5 = immutable.JoinDictionaries(v5, p2.gamesProductInfo)
		end

		return v5
	end
}
