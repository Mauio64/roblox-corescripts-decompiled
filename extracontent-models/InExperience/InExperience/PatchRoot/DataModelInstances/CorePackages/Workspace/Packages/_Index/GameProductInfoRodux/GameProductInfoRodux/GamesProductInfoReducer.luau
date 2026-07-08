local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local GameProductInfoRoduxParent = GameProductInfoRodux.Parent
local Immutable = require(GameProductInfoRoduxParent.AppCommonLib).Immutable
local SetGamesProductInfo = require(GameProductInfoRodux.SetGamesProductInfo)

require(GameProductInfoRodux.GameProductInfo)

return {
	key = "GamesProductInfoKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 13
		-- upvalues: SetGamesProductInfo (copy), Immutable (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1.type == SetGamesProductInfo.name then
			v7 = Immutable.JoinDictionaries(v7, p1.gamesProductInfo)
		end

		return v7
	end
}
