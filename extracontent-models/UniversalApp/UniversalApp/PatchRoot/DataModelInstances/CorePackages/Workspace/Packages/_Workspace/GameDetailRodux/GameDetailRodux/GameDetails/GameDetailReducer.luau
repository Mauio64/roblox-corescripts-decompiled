local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Immutable = require(GameDetailRoduxParent.AppCommonLib).Immutable
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)

return function(p1, p2) -- line: 8
	-- upvalues: AddGameDetails (copy), Immutable (copy)
	local v7 = p1 or {}

	if p2.type == AddGameDetails.name then
		v7 = Immutable.JoinDictionaries(v7, p2.gameDetails)
	end

	return v7
end
