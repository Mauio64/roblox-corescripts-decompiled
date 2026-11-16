local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local parent = GameProductInfoRodux.Parent
local Promise = require(parent.Promise)
local Result = require(parent.Result)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local AppCommonLib = require(parent.AppCommonLib)
local Logging = AppCommonLib.Logging
local SetGamesProductInfo = require(GameProductInfoRodux.SetGamesProductInfo)
local GamesGetProductInfo = require(GameProductInfoRodux.GamesGetProductInfo)
local GameProductInfo = require(GameProductInfoRodux.GameProductInfo)

local function fn(p) -- 4 equivalent calls inferred from this helper
	return "luaapp.gamesapi.games-product-info." .. p
end

local FetchGamesProductInfo = {}
FetchGamesProductInfo.KeyMapper = fn

function FetchGamesProductInfo.Fetch(p, list)
	assert(type(list) == "table", "FetchGamesProductInfo thunk expects universeIds to be a table")
	assert(#list > 0, "FetchGamesProductInfo thunk expects universeIds count to be greater than 0")
	assert(#list <= 100, "FetchGamesProductInfo thunk expects universeIds count to not exceed " .. 100)

	return PerformFetch.Batch(list, fn, function(object, list2)
		return GamesGetProductInfo(p, list2):andThen(function(p2)
			local v = {}

			for _, item in ipairs(list2) do
				v[fn(item)] = Result.new(false, nil) -- inferred equivalent call
			end

			local data = p2 and p2.responseBody and p2.responseBody.data

			if data == nil then
				Logging.warn("Response from GamesGetProductInfo is malformed!")
			else
				local v2 = {}

				for _, v3 in ipairs(data) do
					GameProductInfo.fromJsonData(v3):match(function(p3)
						v2[p3.universeId] = p3
						v[fn(p3.universeId)] = Result.new(true, nil) -- inferred equivalent call
					end):matchError(function(p3)
						Logging.warn(p3)
					end)
				end

				if next(v2) then
					object:dispatch(SetGamesProductInfo(v2))
				end
			end

			return Promise.resolve(v)
		end, function(_)
			local v = {}

			for _, item in ipairs(list2) do
				v[fn(item)] = Result.new(false, nil) -- inferred equivalent call
			end

			return Promise.resolve(v)
		end)
	end)
end

function FetchGamesProductInfo.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, fn(p2)) -- inferred equivalent call
end

return FetchGamesProductInfo
