local PlayabilityRodux = script:FindFirstAncestor("PlayabilityRodux")
local PlayabilityRoduxParent = PlayabilityRodux.Parent
local Promise = require(PlayabilityRoduxParent.Promise)
local Result = require(PlayabilityRoduxParent.Result)
local PerformFetch = require(PlayabilityRoduxParent.Http).PerformFetch
local GamesMultigetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.GamesMultigetPlayabilityStatus)
local SetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.SetPlayabilityStatus)
local PlayabilityStatusModel = require(PlayabilityRodux.PlayabilityStatus.PlayabilityStatusModel)
local Logger = require(PlayabilityRodux.Logger)

local function keyMapper(p1) -- line: 15
	return "luaapp.gamesapi.playabilitystatus." .. p1
end

return {
	KeyMapper = keyMapper,
	Fetch = function(p2, p3) -- line: 23
		-- upvalues: PerformFetch (copy), keyMapper (copy), GamesMultigetPlayabilityStatus (copy), Result (copy), PlayabilityStatusModel (copy), SetPlayabilityStatus (copy), Logger (copy), Promise (copy)
		assert(type(p3) == "table", "ApiFetchPlayabilityStatus thunk expects universeIds to be a table")
		assert(#p3 > 0, "ApiFetchPlayabilityStatus thunk expects universeIds count to be greater than 0")
		assert(#p3 <= 100, "ApiFetchPlayabilityStatus thunk expects universeIds count to not exceed " .. 100)

		return PerformFetch.Batch(p3, keyMapper, function(p4, p5) -- line: 31
			-- upvalues: GamesMultigetPlayabilityStatus (copy), p2 (copy), Result (copy), PlayabilityStatusModel (copy), SetPlayabilityStatus (copy), Logger (copy), Promise (copy)
			return GamesMultigetPlayabilityStatus(p2, p5):andThen(function(p6) -- line: 32
				-- upvalues: p5 (copy), Result (copy), PlayabilityStatusModel (copy), p4 (copy), SetPlayabilityStatus (copy), Logger (copy), Promise (copy)
				local t1 = {}

				for _, v in ipairs(p5) do
					t1["luaapp.gamesapi.playabilitystatus." .. v] = Result.new(false, nil)
				end

				local v22 = p6 and p6.responseBody

				if v22 ~= nil then
					local t2 = {}

					for _, v in pairs(v22) do
						PlayabilityStatusModel.fromJsonData(v):match(function(p7) -- line: 45
							-- upvalues: t2 (copy), t1 (copy), v (copy), Result (copy)
							t2[p7.universeId] = p7
							t1["luaapp.gamesapi.playabilitystatus." .. tostring(v.universeId)] = Result.new(true, nil)
						end):matchError(function(p8) -- line: 49
							warn(p8)
						end)
					end

					if next(t2) then
						p4:dispatch(SetPlayabilityStatus(t2))
					end
				else
					Logger:warning("Response from GameGetVotes is malformed!")
				end

				return Promise.resolve(t1)
			end, function(_) -- line: 62
				-- upvalues: p5 (copy), Result (copy), Promise (copy)
				local t3 = {}

				for _, v in ipairs(p5) do
					t3["luaapp.gamesapi.playabilitystatus." .. v] = Result.new(false, nil)
				end

				return Promise.resolve(t3)
			end)
		end)
	end,
	GetFetchingStatus = function(p10, p11) -- line: 72
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p10, "luaapp.gamesapi.playabilitystatus." .. p11)
	end
}
