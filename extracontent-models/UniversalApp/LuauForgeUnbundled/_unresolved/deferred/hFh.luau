local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes

local modules = require("@luauforge/bundled/dpZ").Modules
local setSearchInGamesStatus = modules.LuaApp.Actions.SetSearchInGamesStatus
local searchRetrievalStatus = modules.LuaApp.Enum.SearchRetrievalStatus
local searchGetOmniSearch = modules.LuaApp.Http.Requests.SearchGetOmniSearch
local handleGameSearchResults = modules.LuaApp.Thunks.Search.HandleGameSearchResults
local resolveSearchViewportSize = modules.Personalization.OmniFeed.resolveSearchViewportSize
local fFlagSearchEmphasisViewportNonSdui = modules.LuaApp.Flags.FFlagSearchEmphasisViewportNonSdui

local module = require("@luauforge/bundled/fpw")
local module2 = require("@luauforge/deferred/hEQ")
local module3 = require("@luauforge/deferred/eeq")
local module4 = require("@luauforge/deferred/ecT")

return function(p2, data)
	return performFetch.Single(module4(data.searchKeyword), function(object)
		local v5 = {
			searchQuery = data.searchKeyword,
			sessionId = data.searchUuid,
			verticalType = "auto",
			globalSessionId = data.omniSearchUuid
		}

		local v6 = data

		if fFlagSearchEmphasisViewportNonSdui then
			local state = object:getState()
			local v7 = if state.Search then state.Search.SearchesInGames[data.searchUuid] else nil
			local searchViewportSize = resolveSearchViewportSize(v7, false)

			if searchViewportSize then
				v5.viewportWidth = searchViewportSize.X
				v5.viewportHeight = searchViewportSize.Y
			end

			v6 = Cryo.Dictionary.join(data, { viewportSize = searchViewportSize })
		end

		object:dispatch(setSearchInGamesStatus(data.searchUuid, searchRetrievalStatus.Fetching))
		return searchGetOmniSearch(p2, v5):andThen(function(p3)
			local v7

			if p3.responseBody.vertical == module2.User then
				v7 = searchTypes.Players
			else
				v7 = searchTypes.Games
			end

			object:dispatch(module(data.searchUuid, v7))

			if v7 ~= searchTypes.Players then
				return object:dispatch(handleGameSearchResults(p2, v6, p3))
			end

			object:dispatch(setSearchInGamesStatus(data.searchUuid, searchRetrievalStatus.NotStarted))
			return object:dispatch(module3(p2, data, p3))
		end, function(p3)
			object:dispatch(setSearchInGamesStatus(data.searchUuid, searchRetrievalStatus.Failed))
			return Promise.reject(p3)
		end)
	end)
end
