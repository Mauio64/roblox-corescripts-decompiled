local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/Promise")
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/Result")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/Http").PerformFetch
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/GameProductInfoRodux/AppCommonLib").Logging
local SetGamesProductInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/SetGamesProductInfo")
local GamesGetProductInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GamesGetProductInfo")
local GameProductInfo = require("@game/CorePackages/Workspace/Packages/_Index/GameProductInfoRodux/GameProductInfoRodux/GameProductInfo")

local function fn(p2)
	return "luaapp.gamesapi.games-product-info." .. p2
end

return {
	["KeyMapper"] = fn,
	Fetch = function(p2, list)
		assert(type(list) == "table", "FetchGamesProductInfo thunk expects universeIds to be a table")
		assert(#list > 0, "FetchGamesProductInfo thunk expects universeIds count to be greater than 0")
		assert(#list <= 100, "FetchGamesProductInfo thunk expects universeIds count to not exceed " .. 100)

		return performFetch.Batch(list, fn, function(object, list2)
			return GamesGetProductInfo(p2, list2):andThen(function(p3)
				local v6 = {}

				for i, item in ipairs(list2) do
					v6["luaapp.gamesapi.games-product-info." .. item] = Result.new(false, nil)
				end

				local data = p3 and p3.responseBody and p3.responseBody.data

				if data == nil then
					logging.warn("Response from GamesGetProductInfo is malformed!")
				else
					local v7 = {}

					for i, v8 in ipairs(data) do
						GameProductInfo.fromJsonData(v8):match(function(p4)
							v7[p4.universeId] = p4
							v6["luaapp.gamesapi.games-product-info." .. p4.universeId] = Result.new(true, nil)
						end):matchError(function(p4)
							logging.warn(p4)
						end)
					end

					if next(v7) then
						object:dispatch(SetGamesProductInfo(v7))
					end
				end

				return Promise.resolve(v6)
			end, function(p3)
				local v6 = {}

				for i, item in ipairs(list2) do
					v6["luaapp.gamesapi.games-product-info." .. item] = Result.new(false, nil)
				end

				return Promise.resolve(v6)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.games-product-info." .. p3)
	end
}
