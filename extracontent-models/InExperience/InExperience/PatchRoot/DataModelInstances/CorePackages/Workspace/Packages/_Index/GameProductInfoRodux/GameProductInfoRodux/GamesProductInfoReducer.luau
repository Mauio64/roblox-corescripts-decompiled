local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local parent = GameProductInfoRodux.Parent
local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local SetGamesProductInfo = require(GameProductInfoRodux.SetGamesProductInfo)
require(GameProductInfoRodux.GameProductInfo)

return {
	key = "GamesProductInfoKey",
	reducer = function(options, p)
		options = options or {}
		assert(options, "")

		if p.type == SetGamesProductInfo.name then
			options = Immutable.JoinDictionaries(options, p.gamesProductInfo)
		end

		return options
	end
}
