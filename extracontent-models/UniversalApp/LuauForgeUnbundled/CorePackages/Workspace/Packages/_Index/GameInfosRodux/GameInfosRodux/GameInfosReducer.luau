local AddGames = require("@game/CorePackages/Workspace/Packages/_Index/GameInfosRodux/GameInfosRodux/AddGames")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DiscoveryTypes")

local function getMergedState(p2, games)
	local v5 = {}

	for k, item in pairs(games) do
		if p2[k] then
			v5[k] = Cryo.Dictionary.join(p2[k], games[k])
		else
			v5[k] = games[k]
		end
	end

	return (Cryo.Dictionary.join(p2, v5))
end

return {
	key = "GameInfosKey",
	reducer = function(options, p2)
		local v5 = options or {}
		assert(v5, "")

		if p2.type == AddGames.name then
			v5 = getMergedState(v5, p2.games)
		end

		return v5
	end
}
