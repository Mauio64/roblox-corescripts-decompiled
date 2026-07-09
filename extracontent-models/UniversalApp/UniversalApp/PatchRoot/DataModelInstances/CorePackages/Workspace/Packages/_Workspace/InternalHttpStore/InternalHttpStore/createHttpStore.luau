local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)
local HttpSessionTracker = require(scriptParent.HttpSessionTracker)
local createFetchSignal = require(scriptParent.createFetchSignal)
local createCancelRequestHandler = require(scriptParent.GlobalHandlers.createCancelRequestHandler)
local createNetworkStatsHandler = require(scriptParent.GlobalHandlers.createNetworkStatsHandler)
local createGrafanaLoggingHandler = require(scriptParent.GlobalHandlers.createGrafanaLoggingHandler)

require(scriptParent.HttpStoreTypes)

local t1 = {}

local function createHTTPStore() -- line: 31
	-- upvalues: t1 (ref), createFetchSignal (copy), createCancelRequestHandler (copy), createNetworkStatsHandler (copy), createGrafanaLoggingHandler (copy), Signals (copy), HttpSessionTracker (copy)
	return {
		fetch = function(s1: string?, p1) -- line: 33
			-- upvalues: t1 (ref), createFetchSignal (copy), createCancelRequestHandler (copy), createNetworkStatsHandler (copy), createGrafanaLoggingHandler (copy), Signals (copy)
			if s1 and t1[s1] then
				return t1[s1].getFetchSignal, t1[s1].cancelRequest
			end

			local v13, v14 = createFetchSignal(p1)
			local u15 = createCancelRequestHandler(v13)
			local v16 = createNetworkStatsHandler(u15)
			local v17 = createGrafanaLoggingHandler(u15)

			local function v18() -- line: 55
				-- upvalues: v16 (copy), v17 (copy), v14 (copy)
				v16()
				v17()
				v14()
			end

			if s1 then
				local v19 = Signals.createEffect(function(p2) -- line: 62
					-- upvalues: u15 (ref), t1 (ref), s1 (copy)
					local v23 = u15(p2)

					if v23.status == "Success" or v23.status == "Failed" then
						t1[s1] = nil
					end
				end)

				function v18() -- line: 69
					-- upvalues: v19 (copy), v16 (copy), v17 (copy), v14 (copy), t1 (ref), s1 (copy)
					v19()
					v16()
					v17()
					v14()
					t1[s1] = nil
				end

				t1[s1] = {
					getFetchSignal = u15,
					cancelRequest = v18
				}
			end

			return u15, v18
		end,
		cancelAll = function() -- line: 84
			-- upvalues: t1 (ref), HttpSessionTracker (copy)
			for _, v21 in t1 do
				v21.cancelRequest()
			end

			t1 = {}
			HttpSessionTracker.cancelAll()
		end
	}
end

return createHTTPStore
