local parent = script:FindFirstAncestor("GameHydrationReact").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local DataHydration = require(parent.DataHydration)

local signal = Signals.createSignal(false)
local v = {}

local function useGameIconsForSize(items, p, flag: boolean?)
	local v2 = {}

	for _, item in items do
		table.insert(v2, (tostring(item)))
	end

	table.sort(v2)

	local v3 = { table.concat(v2, ","), p, flag }
	local v4 = React.useMemo(function()
		local gameIconStore = DataHydration.Game.getGameIconStore(false)
		local v4

		if flag then
			v4 = gameIconStore.getAndFetchGameIcons(v2, p)
		else
			v4 = gameIconStore.getGameIcons(v2, p)
		end

		return function(p2)
			if next(v4) == nil then
				signal(p2)
				return v
			end

			local urls = {}

			for k, v5 in v4 do
				local data = v5.data(p2)

				if data and data.url then
					urls[k] = data.url
				end
			end

			return urls
		end
	end, v3)

	return SignalsReact.useSignalState(v4)
end

return useGameIconsForSize
