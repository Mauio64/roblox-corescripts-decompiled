local GameProductInfoRodux = script:FindFirstAncestor("GameProductInfoRodux")
local GameProductInfoRoduxParent = GameProductInfoRodux.Parent
local Promise = require(GameProductInfoRoduxParent.Promise)
local Result = require(GameProductInfoRoduxParent.Result)
local PerformFetch = require(GameProductInfoRoduxParent.Http).PerformFetch
local Logging = require(GameProductInfoRoduxParent.AppCommonLib).Logging
local SetGamesProductInfo = require(GameProductInfoRodux.SetGamesProductInfo)
local GamesGetProductInfo = require(GameProductInfoRodux.GamesGetProductInfo)
local GameProductInfo = require(GameProductInfoRodux.GameProductInfo)
local t1 = {}

local function v11(p1) -- line: 16
	return "luaapp.gamesapi.games-product-info." .. p1
end

t1.KeyMapper = v11

function t1.Fetch(p2, p3) -- line: 22
	-- upvalues: PerformFetch (copy), v11 (copy), GamesGetProductInfo (copy), Result (copy), GameProductInfo (copy), Logging (copy), SetGamesProductInfo (copy), Promise (copy)
	assert(type(p3) == "table", "FetchGamesProductInfo thunk expects universeIds to be a table")
	assert(#p3 > 0, "FetchGamesProductInfo thunk expects universeIds count to be greater than 0")
	assert(#p3 <= 100, "FetchGamesProductInfo thunk expects universeIds count to not exceed " .. 100)

	return PerformFetch.Batch(p3, v11, function(p4, p5) -- line: 30
		-- upvalues: GamesGetProductInfo (copy), p2 (copy), Result (copy), GameProductInfo (copy), Logging (copy), SetGamesProductInfo (copy), Promise (copy)
		return GamesGetProductInfo(p2, p5):andThen(function(p6) -- line: 31
			-- upvalues: p5 (copy), Result (copy), GameProductInfo (copy), Logging (copy), p4 (copy), SetGamesProductInfo (copy), Promise (copy)
			local t2 = {}

			for _, v in ipairs(p5) do
				t2["luaapp.gamesapi.games-product-info." .. v] = Result.new(false, nil)
			end

			local v23 = p6 and (p6.responseBody and p6.responseBody.data)

			if v23 ~= nil then
				local t3 = {}

				for _, v in ipairs(v23) do
					GameProductInfo.fromJsonData(v):match(function(p7) -- line: 42
						-- upvalues: t3 (copy), t2 (copy), Result (copy)
						t3[p7.universeId] = p7
						t2["luaapp.gamesapi.games-product-info." .. p7.universeId] = Result.new(true, nil)
					end):matchError(function(p8) -- line: 46
						-- upvalues: Logging (copy)
						Logging.warn(p8)
					end)
				end

				if next(t3) then
					p4:dispatch(SetGamesProductInfo(t3))
				end
			else
				Logging.warn("Response from GamesGetProductInfo is malformed!")
			end

			return Promise.resolve(t2)
		end, function(_) -- line: 59
			-- upvalues: p5 (copy), Result (copy), Promise (copy)
			local t4 = {}

			for _, v in ipairs(p5) do
				t4["luaapp.gamesapi.games-product-info." .. v] = Result.new(false, nil)
			end

			return Promise.resolve(t4)
		end)
	end)
end
function t1.GetFetchingStatus(p10, p11) -- line: 69
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p10, "luaapp.gamesapi.games-product-info." .. p11)
end

return t1
