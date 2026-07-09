local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(CorePackages.Packages.Promise)
local SetNetworkingErrorToast = require(CorePackages.Workspace.Packages.RobloxAppToastsRodux).Thunks.SetNetworkingErrorToast
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local parseAndAddGameInfos = require(CorePackages.Workspace.Packages.GameInfosRodux).parseAndAddGameInfos
local GameInfoModel = require(CorePackages.Workspace.Packages.GameModels).GameInfoModel
local TopicContentsEntryModel = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsEntryModel
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetRecommendedGameEntries = require(Modules.LuaApp.Actions.Games.SetRecommendedGameEntries)
local GameGetRecommendedGames = require(Modules.LuaApp.Http.Requests.GamesApi.GameGetRecommendedGames)
local t1 = {}

local function fetchKeymapper(p1) -- line: 18
	return "RecommendedGames" .. p1
end

function t1.Fetch(p2, p3, p4) -- line: 22
	-- upvalues: PerformFetch (copy), GameGetRecommendedGames (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), SetRecommendedGameEntries (copy), Promise (copy), SetNetworkingErrorToast (copy)
	assert(type(p3) == "string", "RecommendedGames thunk expects universeId to be a string")
	assert(type(p4) == "table", "RecommendedGames thunk expects argTable to be a table")

	return PerformFetch.Single("RecommendedGames" .. p3, function(p5) -- line: 26
		-- upvalues: GameGetRecommendedGames (copy), p2 (copy), p3 (copy), p4 (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), GameInfoModel (copy), SetRecommendedGameEntries (copy), Promise (copy), SetNetworkingErrorToast (copy)
		return GameGetRecommendedGames(p2, p3, p4):andThen(function(p6) -- line: 27
			-- upvalues: p3 (copy), TopicContentsEntryModel (copy), Cryo (copy), parseAndAddGameInfos (copy), p2 (copy), p5 (copy), GameInfoModel (copy), SetRecommendedGameEntries (copy), Promise (copy)
			local t2 = {}
			local responseBody = p6.responseBody

			if #responseBody.games == 0 then
				warn("Found no recommended games related to universe", p3)
			end

			local function forEachGameInfo(p7, p8) -- line: 36
				-- upvalues: TopicContentsEntryModel (copy), Cryo (copy), t2 (copy)
				TopicContentsEntryModel.fromGamesApiData(p7):match(function(p9) -- line: 40
					-- upvalues: Cryo (copy), p8 (copy), t2 (copy)
					local v29 = Cryo.Dictionary.join(p8, p9)

					table.insert(t2, v29)
				end):matchError(function(p10) -- line: 44
					warn(p10)
				end)
			end

			parseAndAddGameInfos(p2, p5, responseBody.games, GameInfoModel.fromGamesApi, forEachGameInfo)
			p5:dispatch(SetRecommendedGameEntries(p3, t2))

			return Promise.resolve(p6)
		end, function(p11) -- line: 54
			-- upvalues: p5 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			p5:dispatch(SetNetworkingErrorToast(p11))

			return Promise.reject(p11)
		end)
	end)
end
function t1.GetFetchingStatus(p12, p13) -- line: 61
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p12, "RecommendedGames" .. p13)
end

t1.KeyMapper = fetchKeymapper

return t1
