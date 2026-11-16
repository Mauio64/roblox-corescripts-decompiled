require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/AppLaunchTrackerTypes")

local v5 = {}
v5.__className = "Devtools"
v5.__index = v5

local function createTable()
	return (table.create(100))
end

function v5.new(p2, p3, p4)
	local v7 = if p2 then table.create(100) else nil
	local v8 = if p2 then table.create(100) else nil
	local v9 = if p3 then table.create(100) else nil
	local v10 = if p3 then table.create(100) else nil

	return (setmetatable({
		reportTopAction = p2,
		reportTopThunk = p3,
		startImmediately = p4,
		shouldTrack = false,
		flushCount = 0,
		totalFlushTimeMs = 0,
		reduceCount = 0,
		totalReduceTimeMs = 0,
		maxListenerCount = 0,
		totalThunkTimeMs = 0,
		thunkCount = 0,
		actionCounts = v7,
		actionTotalTimes = v8,
		thunkCounts = v9,
		thunkTotalTimes = v10
	}, v5))
end

function v5:_hookIntoStore(store)
	self.store = store
	self.originalReducer = store._reducer
	self.originalFlushHandler = store._flushHandler

	if self.startImmediately then
		self:startTracking()
	end
end

function v5:trackingReducer(p2, p3)
	assert(self.originalReducer, "self.originalReducer must exist")
	local lastTime = os.clock()
	local originalReducer = self.originalReducer(p2, p3)
	local v6 = (os.clock() - lastTime) * 1000
	self.totalReduceTimeMs += v6
	self.reduceCount += 1

	local kind = self.reportTopAction
		and self.actionCounts
		and self.actionTotalTimes
		and (p3.type or tostring(p3))

	if not kind then
		return originalReducer
	end

	local v7 = (self.actionCounts[kind] or 0) + 1
	self.actionCounts[kind] = v7

	local v8 = (self.actionTotalTimes[kind] or 0) + v6
	self.actionTotalTimes[kind] = v8

	return originalReducer
end

function v5:trackingFlush(...)
	local lastTime = os.clock()
	self.originalFlushHandler(...)
	local v6 = (os.clock() - lastTime) * 1000
	self.totalFlushTimeMs += v6
	self.flushCount += 1

	local count = #self.store.changed._listeners

	if self.maxListenerCount < count then
		self.maxListenerCount = count
	end
end

function v5:startTracking()
	function self.store._flushHandler(...)
		return self:trackingFlush(...)
	end

	function self.store._reducer(...)
		return self:trackingReducer(...)
	end

	self.shouldTrack = true
end

function v5:stopTracking()
	if self.shouldTrack then
		self.shouldTrack = false
		self.store._flushHandler = self.originalFlushHandler
		self.store._reducer = self.originalReducer
	end
end

function v5:clear()
	self.flushCount = 0
	self.totalFlushTimeMs = 0
	self.reduceCount = 0
	self.totalReduceTimeMs = 0
	self.maxListenerCount = 0
	self.totalThunkTimeMs = 0
	self.thunkCount = 0

	if self.reportTopAction then
		self.actionCounts = table.create(100)
		self.actionTotalTimes = table.create(100)
	end

	if self.reportTopThunk then
		self.thunkCounts = table.create(100)
		self.thunkTotalTimes = table.create(100)
	end
end

local function getRelevantLineFromTrace(traceback)
	local v6 = string.split(traceback, "\n")

	for i = 3, #v6 do
		local v7 = v6[i]

		if not (string.find(v7, "AppLaunchTracker") or string.find(v7, "_Index.Rodux") or string.find(v7, "_Index.RoactRodux") or string.find(v7, "_Index.Promise") or string.find(v7, ".RoactRodux")) then
			return v7
		end
	end

	return nil
end

local function getThunkName(p2)
	local relevantLineFromTrace = getRelevantLineFromTrace(debug.traceback())

	if relevantLineFromTrace then
		return relevantLineFromTrace
	end

	return debug.info(p2, "slf")
end

function v5.makeThunkMiddleware(data, p2)
	local function tracebackReporter(p3)
		return debug.traceback(p3)
	end

	local function thunkMiddleware(callback, object)
		return function(callback2)
			if typeof(callback2) ~= "function" then
				return callback(callback2)
			end

			local success, result = xpcall(function()
				if not data.shouldTrack then
					return callback2(object, p2)
				end

				local lastTime = os.clock()
				local v6 = callback2(object, p2)
				local v7 = (os.clock() - lastTime) * 1000
				data.totalThunkTimeMs += v7
				data.thunkCount += 1

				if data.reportTopThunk and data.thunkCounts and data.thunkTotalTimes then
					local v11 = getRelevantLineFromTrace(debug.traceback()) or debug.info(callback2, "slf")

					local v12 = (data.thunkCounts[v11] or 0) + 1
					data.thunkCounts[v11] = v12

					local v13 = (data.thunkTotalTimes[v11] or 0) + v7
					data.thunkTotalTimes[v11] = v13
				end

				return v6
			end, tracebackReporter)

			if success then
				return result
			end

			object._errorReporter.reportReducerError(object:getState(), callback2, {
				message = "Caught error in thunk",
				thrownValue = result
			})

			return nil
		end
	end

	return thunkMiddleware
end

local function getTopValue(items)
	local v6 = nil
	local v7 = nil

	for k, item in items do
		if not ((v6 or -1) < item) then
			continue
		end

		v7 = k
		v6 = item
	end

	return v7, v6
end

local function fixThunkName(value)
	return value:gsub("CoreGui.RobloxGui.Modules.", ""):gsub(
		"CorePackages.Workspace.Packages._Workspace.",
		""
	)
end

function v5:getStats()
	local v6 = nil
	local v7 = nil
	local v8 = nil
	local v9 = nil
	local v10, v11

	if self.reportTopAction and self.actionCounts and self.actionTotalTimes then
		for k, actionTotalTime in self.actionTotalTimes do
			if not ((v10 or -1) < actionTotalTime) then
				continue
			end

			v11 = k
			v10 = actionTotalTime
		end

		if v11 then
			v6 = self.actionCounts[v11]
		end
	end

	if self.reportTopThunk and self.thunkCounts and self.thunkTotalTimes then
		for k, thunkTotalTime in self.thunkTotalTimes do
			if not ((v8 or -1) < thunkTotalTime) then
				continue
			end

			v7 = k
			v8 = thunkTotalTime
		end

		if v7 then
			v9 = self.thunkCounts[v7]
			v7 = v7:gsub("CoreGui.RobloxGui.Modules.", ""):gsub(
				"CorePackages.Workspace.Packages._Workspace.",
				""
			)
		end
	end

	return {
		flushCount = self.flushCount,
		totalFlushTimeMs = self.totalFlushTimeMs,
		reduceCount = self.reduceCount,
		totalReduceTimeMs = self.totalReduceTimeMs,
		maxListenerCount = self.maxListenerCount,
		totalThunkTimeMs = self.totalThunkTimeMs,
		thunkCount = self.thunkCount,
		topActionName = v11,
		topActionDurationMs = v10,
		topActionCount = v6,
		topThunkName = v7,
		topThunkDurationMs = v8,
		topThunkCount = v9
	}
end

return v5
