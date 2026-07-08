local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local InternalHttpStore = require(scriptParentParent.InternalHttpStore)

require(scriptParentParent.Signals)

local createErrorStatusHandler = require(scriptParent.Handlers.createErrorStatusHandler)
local GetHttpStore = InternalHttpStore.GetHttpStore

require(scriptParent.Types)

local HttpSessionTracker = require(scriptParent.HttpSessionTracker)

local function createHttpStore(p1, p2) -- line: 25
	-- upvalues: GetHttpStore (copy), HttpSessionTracker (copy), createErrorStatusHandler (copy)
	local v10 = GetHttpStore(p2)
	local t1 = {}

	return {
		fetch = function(s1: string, p3) -- line: 30
			-- upvalues: HttpSessionTracker (copy), t1 (copy), v10 (copy), createErrorStatusHandler (copy), p1 (copy)
			local v14 = HttpSessionTracker.currentSession()

			if t1[v14] == nil then
				t1[v14] = {}
			end

			local v15, v16 = v10.fetch(s1, p3)
			local v17 = createErrorStatusHandler(p1)(v15)

			t1[v14][s1] = {
				getFetchSignal = v17,
				cancelRequest = v16
			}

			return v17, v16
		end,
		cancelAll = function() -- line: 46
			-- upvalues: HttpSessionTracker (copy), t1 (copy)
			local v18 = HttpSessionTracker.currentSession()

			if t1[v18] then
				for _, v20 in t1[v18] do
					v20.cancelRequest()
				end
			end

			t1[v18] = nil
			HttpSessionTracker.cancelAll()
			t1[HttpSessionTracker.currentSession()] = {}
		end
	}
end

return createHttpStore
