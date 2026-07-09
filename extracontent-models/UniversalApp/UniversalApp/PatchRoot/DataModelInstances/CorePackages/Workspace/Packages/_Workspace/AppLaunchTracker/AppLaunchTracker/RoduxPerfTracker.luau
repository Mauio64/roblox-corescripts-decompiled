require(script.Parent.AppLaunchTrackerTypes)

local t1 = {
	__className = "Devtools"
}

t1.__index = t1

local function createTable() -- line: 43
	return (table.create(100))
end

function t1.new(b1: boolean, b2: boolean, b3: boolean?) -- line: 48
	-- upvalues: t1 (copy)
	return (setmetatable({
		shouldTrack = false,
		flushCount = 0,
		totalFlushTimeMs = 0,
		reduceCount = 0,
		totalReduceTimeMs = 0,
		maxListenerCount = 0,
		totalThunkTimeMs = 0,
		thunkCount = 0,
		reportTopAction = b1,
		reportTopThunk = b2,
		startImmediately = b3,
		actionCounts = if not b1 then nil else table.create(100),
		actionTotalTimes = if not b1 then nil else table.create(100),
		thunkCounts = if not b2 then nil else table.create(100),
		thunkTotalTimes = if not b2 then nil else table.create(100)
	}, t1))
end
function t1._hookIntoStore(p1, p2) -- line: 80
	p1.store = p2
	p1.originalReducer = p2._reducer
	p1.originalFlushHandler = p2._flushHandler

	if p1.startImmediately then
		p1:startTracking()
	end
end
function t1.trackingReducer(p3, p4, p5) -- line: 90
	assert(p3.originalReducer, "self.originalReducer must exist")

	local elapsed = os.clock()
	local v16 = p3.originalReducer(p4, p5)
	local v17 = (os.clock() - elapsed) * 1000

	p3.totalReduceTimeMs = p3.totalReduceTimeMs + v17
	p3.reduceCount = p3.reduceCount + 1

	if p3.reportTopAction and p3.actionCounts and p3.actionTotalTimes then
		local v18 = p5.type or tostring(p5)

		if v18 then
			local v19 = (p3.actionCounts[v18] or 0) + 1

			p3.actionCounts[v18] = v19

			local v20 = (p3.actionTotalTimes[v18] or 0) + v17

			p3.actionTotalTimes[v18] = v20
		end
	end

	return v16
end
function t1.trackingFlush(p6, ...) -- line: 115
	local elapsed = os.clock()

	p6.originalFlushHandler(...)

	local v23 = (os.clock() - elapsed) * 1000

	p6.totalFlushTimeMs = p6.totalFlushTimeMs + v23
	p6.flushCount = p6.flushCount + 1

	local v24 = #p6.store.changed._listeners

	if v24 > p6.maxListenerCount then
		p6.maxListenerCount = v24
	end
end
function t1.startTracking(p7) -- line: 130
	function p7.store._flushHandler(...) -- line: 131
		-- upvalues: p7 (copy)
		return p7:trackingFlush(...)
	end
	function p7.store._reducer(...) -- line: 134
		-- upvalues: p7 (copy)
		return p7:trackingReducer(...)
	end

	p7.shouldTrack = true
end
function t1.stopTracking(p8) -- line: 140
	if p8.shouldTrack then
		p8.shouldTrack = false
		p8.store._flushHandler = p8.originalFlushHandler
		p8.store._reducer = p8.originalReducer
	end
end
function t1.clear(p9) -- line: 148
	p9.flushCount = 0
	p9.totalFlushTimeMs = 0
	p9.reduceCount = 0
	p9.totalReduceTimeMs = 0
	p9.maxListenerCount = 0
	p9.totalThunkTimeMs = 0
	p9.thunkCount = 0

	if p9.reportTopAction then
		p9.actionCounts = table.create(100)
		p9.actionTotalTimes = table.create(100)
	end

	if p9.reportTopThunk then
		p9.thunkCounts = table.create(100)
		p9.thunkTotalTimes = table.create(100)
	end
end

local function getRelevantLineFromTrace(s1: string) -- line: 167
	local parts = string.split(s1, "\n")

	for i = 3, #parts do
		local v31 = parts[i]

		if not string.find(v31, "AppLaunchTracker") and not string.find(v31, "_Index.Rodux") and not string.find(v31, "_Index.RoactRodux") and not string.find(v31, "_Index.Promise") and not string.find(v31, ".RoactRodux") then
			return v31
		end
	end

	return nil
end
local function getThunkName(p10) -- line: 184
	-- upvalues: getRelevantLineFromTrace (copy)
	local v33 = getRelevantLineFromTrace(debug.traceback())

	if v33 then
		return v33
	end

	return debug.info(p10, "slf")
end

function t1.makeThunkMiddleware(p11, p12) -- line: 192
	-- upvalues: getRelevantLineFromTrace (copy)
	local function tracebackReporter(p13) -- line: 193
		return debug.traceback(p13)
	end
	local function thunkMiddleware(p14, p15) -- line: 196
		-- upvalues: p11 (copy), p12 (copy), getRelevantLineFromTrace (copy), tracebackReporter (copy)
		return function(p16) -- line: 197
			-- upvalues: p11 (copy), p15 (copy), p12 (copy), getRelevantLineFromTrace (copy), tracebackReporter (copy), p14 (copy)
			if typeof(p16) == "function" then
				local ok, result = xpcall(function() -- line: 199
					-- upvalues: p11 (copy), p16 (copy), p15 (copy), p12 (copy), getRelevantLineFromTrace (copy)
					if p11.shouldTrack then
						local elapsed = os.clock()
						local v62 = p16(p15, p12)
						local v63 = (os.clock() - elapsed) * 1000
						local v64 = p11

						v64.totalThunkTimeMs = v64.totalThunkTimeMs + v63

						local v65 = p11

						v65.thunkCount = v65.thunkCount + 1

						if p11.reportTopThunk and p11.thunkCounts and p11.thunkTotalTimes then
							local v66 = p16
							local v67 = getRelevantLineFromTrace(debug.traceback()) or debug.info(v66, "slf")
							local v68 = (p11.thunkCounts[v67] or 0) + 1

							p11.thunkCounts[v67] = v68

							local v69 = (p11.thunkTotalTimes[v67] or 0) + v63

							p11.thunkTotalTimes[v67] = v69
						end

						return v62
					end

					return p16(p15, p12)
				end, tracebackReporter)

				if not ok then
					p15._errorReporter.reportReducerError(p15:getState(), p16, {
						message = "Caught error in thunk",
						thrownValue = result
					})

					return nil
				end

				return result
			end

			return p14(p16)
		end
	end

	return thunkMiddleware
end

local function getTopValue(t2: {[any]: any}) -- line: 243
	local v39 = nil
	local v40 = nil

	for v41, v42 in t2 do
		if v42 > (v39 or -1) then
			v39 = v42
			v40 = v41
		end
	end

	return v40, v39
end
local function fixThunkName(s2: string) -- line: 255
	return s2:gsub("CoreGui.RobloxGui.Modules.", ""):gsub("CorePackages.Workspace.Packages._Workspace.", "")
end

function t1.getStats(p17) -- line: 259
	local v45 = nil
	local v46 = nil
	local v47 = nil
	local v48 = nil
	local v49 = nil
	local v50 = nil

	if p17.reportTopAction and (p17.actionCounts and p17.actionTotalTimes) then
		v46 = nil
		v45 = nil

		for v51, v52 in p17.actionTotalTimes do
			if v52 > (v46 or -1) then
				v46 = v52
				v45 = v51
			end
		end

		if v45 then
			v47 = p17.actionCounts[v45]
		end
	end

	if p17.reportTopThunk and p17.thunkCounts and p17.thunkTotalTimes then
		v49 = nil
		v48 = nil

		for v53, v54 in p17.thunkTotalTimes do
			if v54 > (v49 or -1) then
				v49 = v54
				v48 = v53
			end
		end

		if v48 then
			v50 = p17.thunkCounts[v48]
			v48 = v48:gsub("CoreGui.RobloxGui.Modules.", ""):gsub("CorePackages.Workspace.Packages._Workspace.", "")
		end
	end

	return {
		flushCount = p17.flushCount,
		totalFlushTimeMs = p17.totalFlushTimeMs,
		reduceCount = p17.reduceCount,
		totalReduceTimeMs = p17.totalReduceTimeMs,
		maxListenerCount = p17.maxListenerCount,
		totalThunkTimeMs = p17.totalThunkTimeMs,
		thunkCount = p17.thunkCount,
		topActionName = v45,
		topActionDurationMs = v46,
		topActionCount = v47,
		topThunkName = v48,
		topThunkDurationMs = v49,
		topThunkCount = v50
	}
end

return t1
