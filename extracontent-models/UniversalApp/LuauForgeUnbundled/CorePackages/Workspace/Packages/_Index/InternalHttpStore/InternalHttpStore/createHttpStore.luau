local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/InternalHttpStore/Signals")
local FFlagDisableLegacyReportToDiag = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/SharedFlags/FFlagDisableLegacyReportToDiag")

local HttpSessionTracker = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpSessionTracker")
local createFetchSignal = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/createFetchSignal")
local createCancelRequestHandler = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/GlobalHandlers/createCancelRequestHandler")
local createNetworkStatsHandler = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/GlobalHandlers/createNetworkStatsHandler")
local createGrafanaLoggingHandler = require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/GlobalHandlers/createGrafanaLoggingHandler")

require("@game/CorePackages/Workspace/Packages/_Index/InternalHttpStore/InternalHttpStore/HttpStoreTypes")

local v5 = {}

local function createHTTPStore()
	return {
		fetch = function(p2, p3)
			if p2 and v5[p2] then
				return v5[p2].getFetchSignal, v5[p2].cancelRequest
			end

			local v6, v7 = createFetchSignal(p3)

			local v8 = createCancelRequestHandler(v6)

			local v9 = if not FFlagDisableLegacyReportToDiag then createNetworkStatsHandler(v8) else nil

			local v10 = createGrafanaLoggingHandler(v8)
			local fn

			if p2 then
				local effect = Signals.createEffect(function(p4)
					local v11 = v8(p4)

					if v11.status == "Success" or v11.status == "Failed" then
						v5[p2] = nil
					end
				end)

				fn = function()
					effect()

					if v9 then
						v9()
					end

					v10()
					v7()

					v5[p2] = nil
				end

				v5[p2] = { getFetchSignal = v8, cancelRequest = fn }
			else
				fn = function()
					if v9 then
						v9()
					end

					v10()
					v7()
				end
			end

			return v8, fn
		end,
		cancelAll = function()
			for k, v6 in v5 do
				v6.cancelRequest()
			end

			v5 = {}

			HttpSessionTracker.cancelAll()
		end
	}
end

return createHTTPStore
