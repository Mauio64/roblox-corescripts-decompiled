local parent = script:FindFirstAncestor("GameInfosRodux").Parent

local AddGames = require(script.Parent.AddGames)
local Cryo = require(parent.Cryo)
require(parent.DiscoveryTypes)

local function getMergedState(options, games)
	local v = {}

	for k, _ in pairs(games) do
		if options[k] then
			v[k] = Cryo.Dictionary.join(options[k], games[k])
		else
			v[k] = games[k]
		end
	end

	return (Cryo.Dictionary.join(options, v))
end

return {
	key = "GameInfosKey",
	reducer = function(options, p)
		options = options or {}
		assert(options, "")

		if p.type == AddGames.name then
			options = getMergedState(options, p.games)
		end

		return options
	end
}
