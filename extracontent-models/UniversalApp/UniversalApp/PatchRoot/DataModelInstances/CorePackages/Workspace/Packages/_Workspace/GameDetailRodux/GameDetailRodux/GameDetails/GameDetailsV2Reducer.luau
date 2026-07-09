local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Immutable = require(GameDetailRoduxParent.AppCommonLib).Immutable
local AddGameDetailsV2 = require(GameDetailRodux.GameDetails.AddGameDetailsV2)

return function(p1, p2) -- line: 9
	-- upvalues: AddGameDetailsV2 (copy), Immutable (copy)
	local v7 = p1 or {}

	if p2.type == AddGameDetailsV2.name then
		v7 = Immutable.JoinDictionaries(v7, p2.gameDetails)
	end

	return v7
end
