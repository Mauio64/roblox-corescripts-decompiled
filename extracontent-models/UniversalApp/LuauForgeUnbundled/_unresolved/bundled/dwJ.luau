local reportToDiagByCountryCode = require("@luauforge/bundled/dwK").ReportToDiagByCountryCode
local module = require("@luauforge/bundled/dwL")
local module2 = require("@luauforge/bundled/dtg")
local module3 = require("@luauforge/bundled/dtf")

local module4 = require("@luauforge/bundled/dtv")
local EnumNetworkStatus = require("@game/CorePackages/Packages/_Index/RoduxNetworking/RoduxNetworking/NetworkStatus/EnumNetworkStatus")
local module6 = require("@luauforge/bundled/dwl")
local module7 = require("@luauforge/bundled/dte")
local module8 = require("@luauforge/bundled/dwM")
local module9 = require("@luauforge/bundled/dtO")

local fVariable = tonumber(settings():GetFVariable("PercentReportingGamesListRTT"))

return function(p2, data)
	return function(object)
		local searchKeyword = data.searchKeyword
		local searchUuid = data.searchUuid

		if not searchUuid then
			return module2.reject("Must have a searchUuid.")
		end

		if not searchKeyword then
			return module2.reject("Must have a searchKeyword to search with.")
		end

		if object:getState().RequestsStatus.SearchesInGamesStatus[searchUuid] == EnumNetworkStatus.Fetching then
			return module2.resolve("Search with Uuid " .. searchUuid .. " has been debounced")
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

		if module9 then
			local state = object:getState()
			local v7 = if state.Search then state.Search.SearchesInGames[searchUuid] else nil
			local v8 = module8(v7, data.isAppend)

			if v8 then
				v5.viewportWidth = v8.X
				v5.viewportHeight = v8.Y
			end

			v6 = module3.Dictionary.join(data, { viewportSize = v8 })
		end

		object:dispatch(module4(searchUuid, EnumNetworkStatus.Fetching))

		return module6(p2, v5):andThen(function(p3)
			local v7 = object:dispatch(module7(p2, v6, p3))

			if not module then
				reportToDiagByCountryCode("GamesList", "RoundTripTime", p3.responseTimeMs, fVariable)
			end

			return v7
		end, function(p3)
			object:dispatch(module4(searchUuid, EnumNetworkStatus.Failed))
			return module2.reject(p3)
		end)
	end
end
