local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/SignalsReact")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameHydrationReact/DataHydration")

local signal = Signals.createSignal(false)
local v5 = {}

local function useGameIconsForSize(items, p2, p3)
	local v6 = {}

	for k, item in items do
		table.insert(v6, (tostring(item)))
	end

	table.sort(v6)

	local v7 = { table.concat(v6, ","), p2, p3 }
	local v8 = React.useMemo(function()
		local gameIconStore = DataHydration.Game.getGameIconStore(false)
		local v9

		if p3 then
			v9 = gameIconStore.getAndFetchGameIcons(v6, p2)
		else
			v9 = gameIconStore.getGameIcons(v6, p2)
		end

		return function(p4)
			if next(v9) == nil then
				signal(p4)
				return v5
			end

			local urls = {}

			for k, v10 in v9 do
				local data = v10.data(p4)

				if data and data.url then
					urls[k] = data.url
				end
			end

			return urls
		end
	end, v7)

	return SignalsReact.useSignalState(v8)
end

return useGameIconsForSize
