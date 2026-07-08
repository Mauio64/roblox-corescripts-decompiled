local GameIconRodux = script:FindFirstAncestor("GameIconRodux")
local GameIconRoduxParent = GameIconRodux.Parent
local Promise = require(GameIconRoduxParent.Promise)
local ApiFetchThumbnails = require(GameIconRoduxParent.Http).Utils.ApiFetchThumbnails
local GamesGetIcons = require(GameIconRodux.GamesGetIcons)
local SetGameIcons = require(GameIconRodux.GameIcons.SetGameIcons)
local GameIconReducer = require(GameIconRodux.GameIcons.GameIconReducer)

return function(p1, p2, s1: string?) -- line: 12
	-- upvalues: GameIconReducer (copy), Promise (copy), ApiFetchThumbnails (copy), GamesGetIcons (copy), SetGameIcons (copy)
	return function(p3) -- line: 13
		-- upvalues: GameIconReducer (copy), p2 (copy), Promise (copy), ApiFetchThumbnails (copy), p1 (copy), s1 (copy), GamesGetIcons (copy), SetGameIcons (copy)
		local v12 = p3:getState()[GameIconReducer.key]
		local t1 = {}

		for _, v in pairs(p2) do
			if v12[v] == nil then
				table.insert(t1, v)
			end
		end

		if #t1 == 0 then
			return Promise.resolve()
		end

		return ApiFetchThumbnails.Fetch(p1, t1, s1 or "150x150", "Game", GamesGetIcons, SetGameIcons, p3)
	end
end
