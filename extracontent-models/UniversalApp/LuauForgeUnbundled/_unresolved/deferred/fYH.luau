local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)

local setNetworkingErrorToast = require("@luauforge/bundled/ecX").Thunks.SetNetworkingErrorToast
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local parseAndAddGameInfos = require("@luauforge/bundled/dzK").parseAndAddGameInfos
local gameInfoModel = require("@luauforge/deferred/fWM").GameInfoModel
local topicContentsEntryModel = require("@luauforge/bundled/dzJ").TopicContentsEntryModel

local module = require("@luauforge/bundled/dzB")
local module2 = require("@luauforge/deferred/fYI")

local function fetchKeymapper(p2)
	return "RecommendedGames" .. p2
end

return {
	Fetch = function(p2, value, p3)
		assert(type(value) == "string", "RecommendedGames thunk expects universeId to be a string")
		assert(type(p3) == "table", "RecommendedGames thunk expects argTable to be a table")
		return performFetch.Single("RecommendedGames" .. value, function(object)
			return module2(p2, value, p3):andThen(function(p4)
				local values = {}
				local responseBody = p4.responseBody

				if #responseBody.games == 0 then
					warn("Found no recommended games related to universe", value)
				end

				local function forEachGameInfo(p5, p6)
					topicContentsEntryModel.fromGamesApiData(p5):match(function(p7)
						table.insert(values, (Cryo.Dictionary.join(p6, p7)))
					end):matchError(function(p7)
						warn(p7)
					end)
				end

				parseAndAddGameInfos(
					p2,
					object,
					responseBody.games,
					gameInfoModel.fromGamesApi,
					forEachGameInfo
				)

				object:dispatch(module(value, values))

				return Promise.resolve(p4)
			end, function(p4)
				object:dispatch(setNetworkingErrorToast(p4))
				return Promise.reject(p4)
			end)
		end)
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, "RecommendedGames" .. p3)
	end,
	KeyMapper = fetchKeymapper
}
