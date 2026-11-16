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

local function useGameIconsForSize(items, p2, p3)
	local v7 = {}

	for k, item in items do
		table.insert(v7, (tostring(item)))
	end

	table.sort(v7)

	local v8 = { table.concat(v7, ","), p2, p3 }
	local v9 = React.useMemo(function()
		local gameIconStore = DataHydration.Game.getGameIconStore(false)
		local v10

		if p3 then
			v10 = gameIconStore.getAndFetchGameIcons(v7, p2)
		else
			v10 = gameIconStore.getGameIcons(v7, p2)
		end

		return function(p4)
			if fFlagMigrateGameInfoToStore and next(v10) == nil then
				v5(p4)
				return v6
			end

			local urls = {}

			for k, v11 in v10 do
				local data = v11.data(p4)

				if data and data.url then
					urls[k] = data.url
				end
			end

			return urls
		end
	end, v8)

	return SignalsReact.useSignalState(v9)
end

return useGameIconsForSize
