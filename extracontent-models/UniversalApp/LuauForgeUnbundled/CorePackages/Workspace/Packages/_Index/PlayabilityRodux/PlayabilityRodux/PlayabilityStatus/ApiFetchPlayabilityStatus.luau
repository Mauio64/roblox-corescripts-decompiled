local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Promise")
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Result")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayabilityRodux/Http").PerformFetch
local GamesMultigetPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Index/PlayabilityRodux/PlayabilityRodux/PlayabilityStatus/GamesMultigetPlayabilityStatus")
local SetPlayabilityStatus = require("@game/CorePackages/Workspace/Packages/_Index/PlayabilityRodux/PlayabilityRodux/PlayabilityStatus/SetPlayabilityStatus")
local PlayabilityStatusModel = require("@game/CorePackages/Workspace/Packages/_Index/PlayabilityRodux/PlayabilityRodux/PlayabilityStatus/PlayabilityStatusModel")

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/PlayabilityRodux/PlayabilityRodux/Logger")

local function keyMapper(p2)
	return "luaapp.gamesapi.playabilitystatus." .. p2
end

return {
	["KeyMapper"] = keyMapper,
	Fetch = function(p2, list)
		assert(type(list) == "table", "ApiFetchPlayabilityStatus thunk expects universeIds to be a table")
		assert(#list > 0, "ApiFetchPlayabilityStatus thunk expects universeIds count to be greater than 0")
		assert(
			#list <= 100,
			"ApiFetchPlayabilityStatus thunk expects universeIds count to not exceed " .. 100
		)

		return performFetch.Batch(list, keyMapper, function(object, list2)
			return GamesMultigetPlayabilityStatus(p2, list2):andThen(function(p3)
				local v5 = {}

				for i, item in ipairs(list2) do
					v5["luaapp.gamesapi.playabilitystatus." .. item] = Result.new(false, nil)
				end

				local responseBody = p3 and p3.responseBody

				if responseBody == nil then
					Logger:warning("Response from GameGetVotes is malformed!")
				else
					local v6 = {}

					for k, v7 in pairs(responseBody) do
						PlayabilityStatusModel.fromJsonData(v7):match(function(p4)
							v6[p4.universeId] = p4
							v5["luaapp.gamesapi.playabilitystatus." .. tostring(v7.universeId)] = Result.new(true, nil)
						end):matchError(function(p4)
							warn(p4)
						end)
					end

					if next(v6) then
						object:dispatch(SetPlayabilityStatus(v6))
					end
				end

				return Promise.resolve(v5)
			end, function(p3)
				local v5 = {}

				for i, item in ipairs(list2) do
					v5["luaapp.gamesapi.playabilitystatus." .. item] = Result.new(false, nil)
				end

				return Promise.resolve(v5)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.playabilitystatus." .. p3)
	end
}
