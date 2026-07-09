local GameDetailRodux = script:FindFirstAncestor("GameDetailRodux")
local GameDetailRoduxParent = GameDetailRodux.Parent
local Promise = require(GameDetailRoduxParent.Promise)
local ArgCheck = require(GameDetailRoduxParent.ArgCheck)
local Result = require(GameDetailRoduxParent.Result)
local PerformFetch = require(GameDetailRoduxParent.Http).PerformFetch
local GamesMultigetDetails = require(script.Parent.GamesMultigetDetails)
local AddGameDetails = require(GameDetailRodux.GameDetails.AddGameDetails)
local SetGameDetailError = require(GameDetailRodux.GameDetails.SetGameDetailError)
local GameDetailModel = require(GameDetailRodux.GameDetails.GameDetailModel)
local EnumGameDetailErrorTypes = require(GameDetailRoduxParent.DiscoveryTypes).EnumGameDetailErrorTypes
local Logger = require(GameDetailRodux.Logger)
local t1 = {}

local function v14(p1) -- line: 20
	return "luaapp.gamesapi.games." .. p1
end

t1.KeyMapper = v14

function t1.GetFetchingStatus(p2, p3) -- line: 26
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p2, "luaapp.gamesapi.games." .. p3)
end
function t1.Fetch(p4, p5) -- line: 30
	-- upvalues: ArgCheck (copy), PerformFetch (copy), v14 (copy), GamesMultigetDetails (copy), GameDetailModel (copy), Result (copy), SetGameDetailError (copy), EnumGameDetailErrorTypes (copy), AddGameDetails (copy), Logger (copy), Promise (copy)
	ArgCheck.isType(p5, "table", "ApiFetchGameDetails: universeIds")

	return PerformFetch.Batch(p5, v14, function(p6, p7) -- line: 33
		-- upvalues: GamesMultigetDetails (copy), p4 (copy), GameDetailModel (copy), Result (copy), SetGameDetailError (copy), EnumGameDetailErrorTypes (copy), AddGameDetails (copy), Logger (copy), Promise (copy)
		return GamesMultigetDetails(p4, p7):andThen(function(p8) -- line: 34
			-- upvalues: GameDetailModel (copy), Result (copy), p7 (copy), p6 (copy), SetGameDetailError (copy), EnumGameDetailErrorTypes (copy), AddGameDetails (copy), Logger (copy), Promise (copy)
			local t2 = {}
			local v24 = p8 and (p8.responseBody and p8.responseBody.data)

			if v24 ~= nil then
				local t3 = {}

				for _, v in ipairs(v24) do
					local v28 = GameDetailModel.fromJsonData(v)

					t3[v28.id] = v28
					t2["luaapp.gamesapi.games." .. v28.id] = Result.new(true, v28)
				end

				for _, v in pairs(p7) do
					if not t3[v] then
						p6:dispatch(SetGameDetailError(v, EnumGameDetailErrorTypes.ExperienceUnavailable))
					end
				end

				if next(t3) then
					p6:dispatch(AddGameDetails(t3))
				end
			else
				Logger:warning("Response from GamesMultigetDetails is malformed!")
			end

			return Promise.resolve(t2)
		end, function(_) -- line: 61
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end)
	end)
end

return t1
