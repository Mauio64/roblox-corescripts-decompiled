local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local signal = Signals.createSignal(false)
local v5 = {}

local function useGameInfos(items)
	local v6 = {}

	for k, item in items do
		table.insert(v6, (tostring(item)))
	end

	table.sort(v6)

	local joined = table.concat(v6, ",")

	local v7 = React.useMemo(function()
		if joined == "" then
			return {}
		end

		return (string.split(joined, ","))
	end, { joined })

	local v8 = React.useMemo(function()
		local gameInfos = DataHydration.Game.getGameInfoStore(false).getGameInfos(v7)
		return function(p2)
			if next(gameInfos) == nil then
				signal(p2)
				return v5
			end

			local result = {}

			for k, gameInfo in gameInfos do
				local data = gameInfo.data(p2)

				if data then
					result[k] = data
				end
			end

			return result
		end
	end, { v7 })

	return SignalsReact.useSignalState(v8)
end

return useGameInfos
