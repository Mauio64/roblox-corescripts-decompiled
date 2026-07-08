local GameIconRodux = script:FindFirstAncestor("GameIconRodux")
local GamesGetIcons = require(GameIconRodux.GamesGetIcons)
local SetBigGameIcons = require(GameIconRodux.BigGameIcons.SetBigGameIcons)
local BigGameIconReducer = require(GameIconRodux.BigGameIcons.BigGameIconReducer)
local GameIconRoduxParent = GameIconRodux.Parent
local Promise = require(GameIconRoduxParent.Promise)
local ApiFetchThumbnails = require(GameIconRoduxParent.Http).Utils.ApiFetchThumbnails

return function(p1, p2, s1: string?) -- line: 12
	-- upvalues: BigGameIconReducer (copy), Promise (copy), ApiFetchThumbnails (copy), GamesGetIcons (copy), SetBigGameIcons (copy)
	return function(p3) -- line: 13
		-- upvalues: BigGameIconReducer (copy), p2 (copy), Promise (copy), ApiFetchThumbnails (copy), p1 (copy), s1 (copy), GamesGetIcons (copy), SetBigGameIcons (copy)
		local v12 = p3:getState()[BigGameIconReducer.key]
		local t1 = {}

		for _, v in pairs(p2) do
			if v12[v] == nil then
				table.insert(t1, v)
			end
		end

		if #t1 == 0 then
			return Promise.resolve()
		end

		return ApiFetchThumbnails.Fetch(p1, t1, s1 or "512x512", "Game", GamesGetIcons, SetBigGameIcons, p3)
	end
end
