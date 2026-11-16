local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local parent = GameDetailRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)

return function(options, p)
	local v = options or {}

	if p.type == AddGameDetails.name then
		return (Immutable.JoinDictionaries(v, p.gameDetails))
	end

	return v
end
