local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SharedFlags").FFlagMigrateGameInfoToStore
local v5, v6

if fFlagMigrateGameInfoToStore then
	v5 = Signals.createSignal(false)
	v6 = {}
else
	v5 = nil
	v6 = nil
end

local function useGameInfos(items)
	local v7 = {}

	for k, item in items do
		table.insert(v7, (tostring(item)))
	end

	table.sort(v7)

	local joined = table.concat(v7, ",")

	local v8 = React.useMemo(function()
		if joined == "" then
			return {}
		end

		return (string.split(joined, ","))
	end, { joined })

	local v9 = React.useMemo(function()
		local gameInfos = DataHydration.Game.getGameInfoStore(false).getGameInfos(v8)
		return function(p2)
			if fFlagMigrateGameInfoToStore and next(gameInfos) == nil then
				v5(p2)
				return v6
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
	end, { v8 })

	return SignalsReact.useSignalState(v9)
end

return useGameInfos
