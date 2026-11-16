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

local function useGameIconsForSize(items, p, flag: boolean?)
	local v3 = {}

	for _, item in items do
		table.insert(v3, (tostring(item)))
	end

	table.sort(v3)

	local v4 = { table.concat(v3, ","), p, flag }
	local v5 = React.useMemo(function()
		local gameIconStore = DataHydration.Game.getGameIconStore(false)
		local v5

		if flag then
			v5 = gameIconStore.getAndFetchGameIcons(v3, p)
		else
			v5 = gameIconStore.getGameIcons(v3, p)
		end

		return function(p2)
			if FFlagMigrateGameInfoToStore and next(v5) == nil then
				v(p2)
				return v2
			end

			local urls = {}

			for k, v6 in v5 do
				local data = v6.data(p2)

				if data and data.url then
					urls[k] = data.url
				end
			end

			return urls
		end
	end, v4)

	return SignalsReact.useSignalState(v5)
end

return useGameIconsForSize
