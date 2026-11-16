local parent = script.Parent
local parent2 = parent.Parent
local InternalHttpStore = require(parent2.InternalHttpStore)
require(parent2.Signals)

local createErrorStatusHandler = require(parent.Handlers.createErrorStatusHandler)
local GetHttpStore = InternalHttpStore.GetHttpStore

require(parent.Types)
local HttpSessionTracker = require(parent.HttpSessionTracker)

local function createHttpStore(p, p2)
	local httpStore = GetHttpStore(p2)
	local v = {}

	return {
		fetch = function(p3: string, p4)
			local currentSession = HttpSessionTracker.currentSession()

			if v[currentSession] == nil then
				v[currentSession] = {}
			end

			local fetched, cancelRequest = httpStore.fetch(p3, p4)

			local getFetchSignal = createErrorStatusHandler(p)(fetched)

			v[currentSession][p3] = {
				getFetchSignal = getFetchSignal,
				cancelRequest = cancelRequest
			}

			return getFetchSignal, cancelRequest
		end,
		cancelAll = function()
			local currentSession = HttpSessionTracker.currentSession()

			if v[currentSession] then
				for _, v2 in v[currentSession] do
					v2.cancelRequest()
				end
			end

			v[currentSession] = nil
			HttpSessionTracker.cancelAll()
			v[HttpSessionTracker.currentSession()] = {}
		end
	}
end

return createHttpStore
