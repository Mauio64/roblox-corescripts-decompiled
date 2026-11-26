local GameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Index/GameInfosRodux/GameInfosRodux/GameInfosReducer")
local AddGames = require("@game/CorePackages/Workspace/Packages/_Index/GameInfosRodux/GameInfosRodux/AddGames")
local syncGameInfosToStore = require("@game/CorePackages/Workspace/Packages/_Index/GameInfosRodux/GameInfosRodux/syncGameInfosToStore")

local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/tutils")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DiscoveryTypes")

local function parseAndAddGameInfos(p2, object, items, callback, callback2, callback3)
	local v5 = object:getState().Personalization[GameInfosReducer.key]

	local v6 = {}
	local v7 = {}
	local universeIds = {}

	for k, item in items do
		callback(item):match(function(p3)
			local universeId = p3.universeId
			v6[universeId] = p3

			if not tutils.shallowEqual(p3, v5[universeId]) then
				v7[universeId] = p3

				if not callback3 or callback3(universeId) then
					table.insert(universeIds, universeId)
				end
			end

			if callback2 then
				callback2(item, p3)
			end
		end):matchError(function(p3)
			warn(`parseAndAddGameInfos could not parse gameInfo: {p3}`)
		end)
	end

	if next(v7) then
		object:dispatch(AddGames(v7))
	end

	if next(v6) then
		syncGameInfosToStore(v6)
	end

	if #universeIds > 0 then
		DataHydration.Game.getGameIconStore(false).getAndFetchGameIcons(universeIds)
	end
end

return parseAndAddGameInfos
