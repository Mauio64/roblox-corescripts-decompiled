local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Promise")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/ArgCheck")
local Result = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Result")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").PerformFetch

local GamesMultigetDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/GamesMultigetDetails")
local AddGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/AddGameDetails")
local SetGameDetailError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/SetGameDetailError")
local GameDetailModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/GameDetails/GameDetailModel")
local enumGameDetailErrorTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/DiscoveryTypes").EnumGameDetailErrorTypes

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/GameDetailRodux/Logger")

local function fn(p2)
	return "luaapp.gamesapi.games." .. p2
end

return {
	["KeyMapper"] = fn,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "luaapp.gamesapi.games." .. p3)
	end,
	Fetch = function(p2, p3)
		ArgCheck.isType(p3, "table", "ApiFetchGameDetails: universeIds")

		return performFetch.Batch(p3, fn, function(object, items)
			return GamesMultigetDetails(p2, items):andThen(function(p4)
				local v6 = {}

				local data = p4 and p4.responseBody and p4.responseBody.data

				if data == nil then
					Logger:warning("Response from GamesMultigetDetails is malformed!")
				else
					local v7 = {}

					for i, v8 in ipairs(data) do
						local v9 = GameDetailModel.fromJsonData(v8)
						v7[v9.id] = v9
						v6["luaapp.gamesapi.games." .. v9.id] = Result.new(true, v9)
					end

					for k, item in pairs(items) do
						if not v7[item] then
							object:dispatch(SetGameDetailError(item, enumGameDetailErrorTypes.ExperienceUnavailable))
						end
					end

					if next(v7) then
						object:dispatch(AddGameDetails(v7))
					end
				end

				return Promise.resolve(v6)
			end, function(p4)
				return Promise.resolve({})
			end)
		end)
	end
}
