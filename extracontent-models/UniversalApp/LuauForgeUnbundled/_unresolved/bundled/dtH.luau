local reportToDiagByCountryCode = require("@luauforge/bundled/dtI").ReportToDiagByCountryCode
local module = require("@luauforge/bundled/dqe")
local module2 = require("@luauforge/bundled/dqd")

local module3 = require("@luauforge/bundled/dqt")
local EnumNetworkStatus = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/NetworkStatus/EnumNetworkStatus")
local module5 = require("@luauforge/bundled/dtj")
local module6 = require("@luauforge/bundled/dqc")
local module7 = require("@luauforge/bundled/dtJ")
local module8 = require("@luauforge/bundled/dqM")

local fVariable = tonumber(settings():GetFVariable("PercentReportingGamesListRTT"))

return function(p2, data)
	return function(object)
		local searchKeyword = data.searchKeyword
		local searchUuid = data.searchUuid

		if not searchUuid then
			return module.reject("Must have a searchUuid.")
		end

		if not searchKeyword then
			return module.reject("Must have a searchKeyword to search with.")
		end

		if object:getState().RequestsStatus.SearchesInGamesStatus[searchUuid] == EnumNetworkStatus.Fetching then
			return module.resolve("Search with Uuid " .. searchUuid .. " has been debounced")
		end

		local v5 = {}
		v5.SearchQuery = searchKeyword
		v5.SessionId = searchUuid
		v5.PageType = "all"
		v5.GlobalSessionId = data.omniSearchUuid

		if data.isAppend then
			local searchesInGame = object:getState().Search.SearchesInGames[searchUuid]
			assert(searchesInGame, "Should always have SearchesInGames for searchUuid")
			v5.PageToken = searchesInGame.nextPageToken
		end

		local v6 = data

		if module8 then
			local state = object:getState()
			local v7 = if state.Search then state.Search.SearchesInGames[searchUuid] else nil
			local v8 = module7(v7, data.isAppend)

			if v8 then
				v5.viewportWidth = v8.X
				v5.viewportHeight = v8.Y
			end

			v6 = module2.Dictionary.join(data, { viewportSize = v8 })
		end

		object:dispatch(module3(searchUuid, EnumNetworkStatus.Fetching))

		return module5(p2, v5):andThen(function(p3)
			local v7 = object:dispatch(module6(p2, v6, p3))
			reportToDiagByCountryCode("GamesList", "RoundTripTime", p3.responseTimeMs, fVariable)
			return v7
		end, function(p3)
			object:dispatch(module3(searchUuid, EnumNetworkStatus.Failed))
			return module.reject(p3)
		end)
	end
end
