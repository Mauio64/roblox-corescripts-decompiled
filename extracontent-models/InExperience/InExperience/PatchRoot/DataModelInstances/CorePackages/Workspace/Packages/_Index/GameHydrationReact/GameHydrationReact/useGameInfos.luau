local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local signal = Signals.createSignal(false)
local v = {}

local function useGameInfos(items)
	local v2 = {}

	for _, item in items do
		table.insert(v2, (tostring(item)))
	end

	table.sort(v2)

	local joined = table.concat(v2, ",")

	local v3 = React.useMemo(function()
		if joined == "" then
			return {}
		end

		return (string.split(joined, ","))
	end, { joined })

	local v4 = React.useMemo(function()
		local gameInfos = DataHydration.Game.getGameInfoStore(false).getGameInfos(v3)
		return function(p)
			if next(gameInfos) == nil then
				signal(p)
				return v
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
	end, { v3 })

	return SignalsReact.useSignalState(v4)
end

return useGameInfos
