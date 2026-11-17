local GameInfosRodux = script:FindFirstAncestor("GameInfosRodux")
local GameInfosReducer = require(GameInfosRodux.GameInfosReducer)
local AddGames = require(GameInfosRodux.AddGames)
local syncGameInfosToStore = require(GameInfosRodux.syncGameInfosToStore)

local parent = GameInfosRodux.Parent
local tutils = require(parent.tutils)
local DataHydration = require(parent.DataHydration)
require(parent.DiscoveryTypes)

local function parseAndAddGameInfos(_, object, items, callback, callback2, callback3)
	local v = object:getState().Personalization[GameInfosReducer.key]

	local v2 = {}
	local v3 = {}
	local universeIds = {}

	for _, item in items do
		callback(item):match(function(p)
			local universeId = p.universeId
			v2[universeId] = p

			if not tutils.shallowEqual(p, v[universeId]) then
				v3[universeId] = p

				if not callback3 or callback3(universeId) then
					table.insert(universeIds, universeId)
				end
			end

			if callback2 then
				callback2(item, p)
			end
		end):matchError(function(p)
			warn(`parseAndAddGameInfos could not parse gameInfo: {p}`)
		end)
	end

	if next(v3) then
		object:dispatch(AddGames(v3))
	end

	if next(v2) then
		syncGameInfosToStore(v2)
	end

	if #universeIds > 0 then
		DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(universeIds)
	end
end

return parseAndAddGameInfos
