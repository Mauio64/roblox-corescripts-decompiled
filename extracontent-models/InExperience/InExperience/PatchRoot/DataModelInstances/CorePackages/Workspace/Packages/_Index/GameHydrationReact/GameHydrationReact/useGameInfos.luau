local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)
local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags.FFlagMigrateGameInfoToStore
local v, v2

if FFlagMigrateGameInfoToStore then
	v = Signals.createSignal(false)
	v2 = {}
else
	v = nil
	v2 = nil
end

local function useGameInfos(items)
	local v3 = {}

	for _, item in items do
		table.insert(v3, (tostring(item)))
	end

	table.sort(v3)

	local joined = table.concat(v3, ",")

	local v4 = React.useMemo(function()
		if joined == "" then
			return {}
		end

		return (string.split(joined, ","))
	end, { joined })

	local v5 = React.useMemo(function()
		local gameInfos = DataHydration.Game.getGameInfoStore(false).getGameInfos(v4)
		return function(p)
			if FFlagMigrateGameInfoToStore and next(gameInfos) == nil then
				v(p)
				return v2
			end

			local result = {}

			for k, gameInfo in gameInfos do
				local data = gameInfo.data(p)

				if data then
					result[k] = data
				end
			end

			return result
		end
	end, { v4 })

	return SignalsReact.useSignalState(v5)
end

return useGameInfos
