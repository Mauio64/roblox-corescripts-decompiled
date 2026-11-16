local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local getGameInfoStore = require(DataHydration.Game.GameInfo.getGameInfoStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

return {
	syncExperienceGenreToGameInfo = function(p: number, genreL: string?, genreL2: string?)
		if not FFlagLuaAppDataHydrationUpdateItem then
			return
		end

		if genreL or genreL2 then
			getGameInfoStore(false).updateGameInfo(tostring(p), {
				genreL1 = genreL,
				genreL2 = genreL2
			})
		end
	end
}
