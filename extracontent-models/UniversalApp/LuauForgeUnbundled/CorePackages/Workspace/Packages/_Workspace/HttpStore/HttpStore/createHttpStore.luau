local InternalHttpStore = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/InternalHttpStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/Signals")

local createErrorStatusHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/Handlers/createErrorStatusHandler")
local getHttpStore = InternalHttpStore.GetHttpStore

require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/Types")
local HttpSessionTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/HttpStore/HttpStore/HttpSessionTracker")

local function createHttpStore(p2, p3)
	local httpStore = getHttpStore(p3)
	local v5 = {}

	return {
		fetch = function(p4, p5)
			local currentSession = HttpSessionTracker.currentSession()

			if v5[currentSession] == nil then
				v5[currentSession] = {}
			end

			local fetched, v6 = httpStore.fetch(p4, p5)

			local v7 = createErrorStatusHandler(p2)(fetched)

			v5[currentSession][p4] = { getFetchSignal = v7, cancelRequest = v6 }

			return v7, v6
		end,
		cancelAll = function()
			local currentSession = HttpSessionTracker.currentSession()

			if v5[currentSession] then
				for k, v6 in v5[currentSession] do
					v6.cancelRequest()
				end
			end

			v5[currentSession] = nil
			HttpSessionTracker.cancelAll()
			local currentSession2 = HttpSessionTracker.currentSession()
			v5[currentSession2] = {}
		end
	}
end

return createHttpStore
