local PlayabilityRodux = script:FindFirstAncestor("PlayabilityRodux")
local parent = PlayabilityRodux.Parent

local Promise = require(parent.Promise)
local Result = require(parent.Result)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local GamesMultigetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.GamesMultigetPlayabilityStatus)
local SetPlayabilityStatus = require(PlayabilityRodux.PlayabilityStatus.SetPlayabilityStatus)
local PlayabilityStatusModel = require(PlayabilityRodux.PlayabilityStatus.PlayabilityStatusModel)

local Logger = require(PlayabilityRodux.Logger)

local function keyMapper(p) -- 4 equivalent calls inferred from this helper
	return "luaapp.gamesapi.playabilitystatus." .. p
end

local ApiFetchPlayabilityStatus = {}
ApiFetchPlayabilityStatus.KeyMapper = keyMapper

function ApiFetchPlayabilityStatus.Fetch(p, list)
	assert(type(list) == "table", "ApiFetchPlayabilityStatus thunk expects universeIds to be a table")
	assert(#list > 0, "ApiFetchPlayabilityStatus thunk expects universeIds count to be greater than 0")
	assert(#list <= 100, "ApiFetchPlayabilityStatus thunk expects universeIds count to not exceed " .. 100)

	return PerformFetch.Batch(list, keyMapper, function(object, list2)
		return GamesMultigetPlayabilityStatus(p, list2):andThen(function(p2)
			local v = {}

			for _, item in ipairs(list2) do
				v[keyMapper(item)] = Result.new(false, nil) -- inferred equivalent call
			end

			local responseBody = p2 and p2.responseBody

			if responseBody == nil then
				Logger:warning("Response from GameGetVotes is malformed!")
			else
				local v2 = {}

				for _, v3 in pairs(responseBody) do
					PlayabilityStatusModel.fromJsonData(v3):match(function(p3)
						v2[p3.universeId] = p3
						v[keyMapper(tostring(v3.universeId))] = Result.new(true, nil) -- inferred equivalent call
					end):matchError(function(p3)
						warn(p3)
					end)
				end

				if next(v2) then
					object:dispatch(SetPlayabilityStatus(v2))
				end
			end

			return Promise.resolve(v)
		end, function(_)
			local v = {}

			for _, item in ipairs(list2) do
				v[keyMapper(item)] = Result.new(false, nil) -- inferred equivalent call
			end

			return Promise.resolve(v)
		end)
	end)
end

function ApiFetchPlayabilityStatus.GetFetchingStatus(p, p2)
	return PerformFetch.GetStatus(p, keyMapper(p2)) -- inferred equivalent call
end

return ApiFetchPlayabilityStatus
