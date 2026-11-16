require(script.Parent.AppLaunchTrackerTypes)

local RoduxPerfTracker = {}
RoduxPerfTracker.__className = "Devtools"
RoduxPerfTracker.__index = RoduxPerfTracker

local function createTable()
	return (table.create(100))
end

function RoduxPerfTracker.new(reportTopAction: boolean, reportTopThunk: boolean, startImmediately: boolean?)
	local actionCounts

	if reportTopAction then
		actionCounts = table.create(100)
	end

	local actionTotalTimes

	if reportTopAction then
		actionTotalTimes = table.create(100)
	end

	local thunkCounts

	if reportTopThunk then
		thunkCounts = table.create(100)
	end

	local thunkTotalTimes

	if reportTopThunk then
		thunkTotalTimes = table.create(100)
	end

	return (setmetatable({
		reportTopAction = reportTopAction,
		reportTopThunk = reportTopThunk,
		startImmediately = startImmediately,
		shouldTrack = false,
		flushCount = 0,
		totalFlushTimeMs = 0,
		reduceCount = 0,
		totalReduceTimeMs = 0,
		maxListenerCount = 0,
		totalThunkTimeMs = 0,
		thunkCount = 0,
		actionCounts = actionCounts,
		actionTotalTimes = actionTotalTimes,
		thunkCounts = thunkCounts,
		thunkTotalTimes = thunkTotalTimes
	}, RoduxPerfTracker))
end

function RoduxPerfTracker:_hookIntoStore(store)
	self.store = store
	self.originalReducer = store._reducer
	self.originalFlushHandler = store._flushHandler

	if self.startImmediately then
		self:startTracking()
	end
end

function RoduxPerfTracker:trackingReducer(p, p2)
	assert(self.originalReducer, "self.originalReducer must exist")
	local lastTime = os.clock()
	local originalReducer = self.originalReducer(p, p2)
	local v = (os.clock() - lastTime) * 1000
	self.totalReduceTimeMs += v
	self.reduceCount += 1

	local kind = self.reportTopAction and self.actionCounts and self.actionTotalTimes and (p2.type or tostring(p2))

	if not kind then
		return originalReducer
	end

	local v2 = (self.actionCounts[kind] or 0) + 1
	self.actionCounts[kind] = v2

	local v3 = (self.actionTotalTimes[kind] or 0) + v
	self.actionTotalTimes[kind] = v3

	return originalReducer
end

function RoduxPerfTracker:trackingFlush(...)
	local lastTime = os.clock()
	self.originalFlushHandler(...)
	local v = (os.clock() - lastTime) * 1000
	self.totalFlushTimeMs += v
	self.flushCount += 1

	local count = #self.store.changed._listeners

	if self.maxListenerCount < count then
		self.maxListenerCount = count
	end
end

function RoduxPerfTracker:startTracking()
	function self.store._flushHandler(...)
		return self:trackingFlush(...)
	end

	function self.store._reducer(...)
		return self:trackingReducer(...)
	end

	self.shouldTrack = true
end

function RoduxPerfTracker:stopTracking()
	if self.shouldTrack then
		self.shouldTrack = false
		self.store._flushHandler = self.originalFlushHandler
		self.store._reducer = self.originalReducer
	end
end

function RoduxPerfTracker:clear()
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

local function getRelevantLineFromTrace(traceback: string)
	local v = string.split(traceback, "\n")

	for i = 3, #v do
		local v2 = v[i]

		if not (string.find(v2, "AppLaunchTracker") or string.find(v2, "_Index.Rodux") or string.find(v2, "_Index.RoactRodux") or string.find(v2, "_Index.Promise") or string.find(v2, ".RoactRodux")) then
			return v2
		end
	end

	return nil
end

local function getThunkName(p)
	local relevantLineFromTrace = getRelevantLineFromTrace(debug.traceback())

	if relevantLineFromTrace then
		return relevantLineFromTrace
	end

	return debug.info(p, "slf")
end

function RoduxPerfTracker.makeThunkMiddleware(data, p)
	local function tracebackReporter(p2)
		return debug.traceback(p2)
	end

	local function thunkMiddleware(callback, object)
		return function(callback2)
			if typeof(callback2) ~= "function" then
				return callback(callback2)
			end

			local success, result = xpcall(function()
				if not data.shouldTrack then
					return callback2(object, p)
				end

				local lastTime = os.clock()
				local v = callback2(object, p)
				local v2 = (os.clock() - lastTime) * 1000
				data.totalThunkTimeMs += v2
				data.thunkCount += 1

				if data.reportTopThunk and data.thunkCounts and data.thunkTotalTimes then
					local v3 = getRelevantLineFromTrace(debug.traceback()) or debug.info(callback2, "slf")

					local v4 = (data.thunkCounts[v3] or 0) + 1
					data.thunkCounts[v3] = v4

					local v5 = (data.thunkTotalTimes[v3] or 0) + v2
					data.thunkTotalTimes[v3] = v5
				end

				return v
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
	local v = nil
	local v2 = nil

	for k, item in items do
		if not ((v or -1) < item) then
			continue
		end

		v2 = k
		v = item
	end

	return v2, v
end

local function fixThunkName(value: string)
	return value:gsub("CoreGui.RobloxGui.Modules.", ""):gsub("CorePackages.Workspace.Packages._Workspace.", "")
end

function RoduxPerfTracker.getStats(data)
	local topActionCount = nil
	local topThunkName = nil
	local topThunkDurationMs = nil
	local topThunkCount = nil
	local topActionDurationMs, topActionName

	if data.reportTopAction and data.actionCounts and data.actionTotalTimes then
		for k, actionTotalTime in data.actionTotalTimes do
			if not ((topActionDurationMs or -1) < actionTotalTime) then
				continue
			end

			topActionName = k
			topActionDurationMs = actionTotalTime
		end

		if topActionName then
			topActionCount = data.actionCounts[topActionName]
		end
	end

	if data.reportTopThunk and data.thunkCounts and data.thunkTotalTimes then
		for k, thunkTotalTime in data.thunkTotalTimes do
			if not ((topThunkDurationMs or -1) < thunkTotalTime) then
				continue
			end

			topThunkName = k
			topThunkDurationMs = thunkTotalTime
		end

		if topThunkName then
			topThunkCount = data.thunkCounts[topThunkName]
			topThunkName = topThunkName:gsub("CoreGui.RobloxGui.Modules.", ""):gsub(
				"CorePackages.Workspace.Packages._Workspace.",
				""
			)
		end
	end

	return {
		flushCount = data.flushCount,
		totalFlushTimeMs = data.totalFlushTimeMs,
		reduceCount = data.reduceCount,
		totalReduceTimeMs = data.totalReduceTimeMs,
		maxListenerCount = data.maxListenerCount,
		totalThunkTimeMs = data.totalThunkTimeMs,
		thunkCount = data.thunkCount,
		topActionName = topActionName,
		topActionDurationMs = topActionDurationMs,
		topActionCount = topActionCount,
		topThunkName = topThunkName,
		topThunkDurationMs = topThunkDurationMs,
		topThunkCount = topThunkCount
	}
end

return RoduxPerfTracker
