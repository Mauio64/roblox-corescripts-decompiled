local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)
local FFlagLuaAppDataHydrationUpdateItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationUpdateItem

return {
	syncExperienceGenreToGameInfo = function(n1: number, s1: string?, s2: string?) -- line: 8
		-- upvalues: FFlagLuaAppDataHydrationUpdateItem (copy), getGameInfoStore (copy)
		if not FFlagLuaAppDataHydrationUpdateItem then
			return
		end

		if not s1 and not s2 then
			return
		end

		getGameInfoStore(false).updateGameInfo(tostring(n1), {
			genreL1 = s1,
			genreL2 = s2
		})
	end
}
