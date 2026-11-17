local parent = script.Parent

local parent2 = parent.Parent

local Signals = require(parent2.Signals)
local FFlagDisableLegacyReportToDiag = require(parent2.SharedFlags.FFlagDisableLegacyReportToDiag)

local HttpSessionTracker = require(parent.HttpSessionTracker)
local createFetchSignal = require(parent.createFetchSignal)
local createCancelRequestHandler = require(parent.GlobalHandlers.createCancelRequestHandler)
local createNetworkStatsHandler = require(parent.GlobalHandlers.createNetworkStatsHandler)
local createGrafanaLoggingHandler = require(parent.GlobalHandlers.createGrafanaLoggingHandler)

require(parent.HttpStoreTypes)

local v = {}

local function createHTTPStore()
	return {
		fetch = function(p: string?, p2)
			if p and v[p] then
				return v[p].getFetchSignal, v[p].cancelRequest
			end

			local fetchSignal, v2 = createFetchSignal(p2)

			local cancelRequestHandler = createCancelRequestHandler(fetchSignal)
			local v3

			if FFlagDisableLegacyReportToDiag then
				v3 = nil
			else
				v3 = createNetworkStatsHandler(cancelRequestHandler)
			end

			local grafanaLoggingHandler = createGrafanaLoggingHandler(cancelRequestHandler)
			local fn

			if p then
				local effect = Signals.createEffect(function(p3)
					local v4 = cancelRequestHandler(p3)

					if v4.status == "Success" or v4.status == "Failed" then
						v[p] = nil
					end
				end)

				fn = function()
					effect()

					if v3 then
						v3()
					end

					grafanaLoggingHandler()
					v2()

					v[p] = nil
				end

				v[p] = { getFetchSignal = cancelRequestHandler, cancelRequest = fn }
			else
				fn = function()
					if v3 then
						v3()
					end

					grafanaLoggingHandler()
					v2()
				end
			end

			return cancelRequestHandler, fn
		end,
		cancelAll = function()
			for _, v2 in v do
				v2.cancelRequest()
			end

			v = {}

			HttpSessionTracker.cancelAll()
		end
	}
end

return createHTTPStore
