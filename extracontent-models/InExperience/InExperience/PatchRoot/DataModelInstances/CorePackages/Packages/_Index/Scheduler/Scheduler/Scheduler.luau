return function(p)
	local parent = script.Parent.Parent
	local ReactGlobals = require(parent.ReactGlobals)
	local Shared = require(parent.Shared)

	local describeError = Shared.describeError
	local reactFeatureFlags = Shared.ReactFeatureFlags

	local SchedulerFeatureFlags = require(script.Parent.SchedulerFeatureFlags)
	local enableSchedulerDebugging = SchedulerFeatureFlags.enableSchedulerDebugging
	local enableProfiling = SchedulerFeatureFlags.enableProfiling

	local v = p or require(script.Parent.SchedulerHostConfig)
	local requestHostCallback = v.requestHostCallback
	local requestHostTimeout = v.requestHostTimeout
	local cancelHostTimeout = v.cancelHostTimeout
	local shouldYieldToHost = v.shouldYieldToHost
	local getCurrentTime = v.getCurrentTime
	local forceFrameRate = v.forceFrameRate
	local requestPaint = v.requestPaint
	local setSchedulerFlags = v.setSchedulerFlags
	local getSchedulerFlags = v.getSchedulerFlags

	local NoYield = require(script.Parent.NoYield)

	local fn
	local fn2
	local fn3

	fn2 = function(list, p2, p3: number)
		while true do
			local v2 = math.floor(p3 / 2)
			local v3 = list[v2]

			if v3 == nil or not (fn(v3, p2) > 0) then
				break
			end

			list[v2] = p2
			list[p3] = v3
			p3 = v2
		end
	end

	fn3 = function(list, item, p2: number)
		local v2 = #list

		while p2 < v2 do
			local v3 = p2 * 2
			local item2 = list[v3]
			local v4 = v3 + 1
			local item3 = list[v4]

			if item2 == nil or not (fn(item2, item) < 0) then
				if item3 == nil or not (fn(item3, item) < 0) then
					break
				end

				list[p2] = item3
				list[v4] = item
				p2 = v4
			elseif item3 == nil or not (fn(item3, item2) < 0) then
				list[p2] = item2
				list[v3] = item
				p2 = v3
			else
				list[p2] = item3
				list[v4] = item
				p2 = v4
			end
		end
	end

	fn = function(p2, p3)
		local v2 = p2.sortIndex - p3.sortIndex

		if v2 == 0 then
			return p2.id - p3.id
		end

		return v2
	end

	local SchedulerPriorities = require(script.Parent.SchedulerPriorities)
	local immediatePriority = SchedulerPriorities.ImmediatePriority
	local userBlockingPriority = SchedulerPriorities.UserBlockingPriority
	local normalPriority = SchedulerPriorities.NormalPriority
	local lowPriority = SchedulerPriorities.LowPriority
	local idlePriority = SchedulerPriorities.IdlePriority

	local SchedulerProfiling = require(script.Parent.SchedulerProfiling)
	local markTaskRun = SchedulerProfiling.markTaskRun
	local markTaskYield = SchedulerProfiling.markTaskYield
	local markTaskCompleted = SchedulerProfiling.markTaskCompleted
	local markTaskCanceled = SchedulerProfiling.markTaskCanceled
	local markTaskErrored = SchedulerProfiling.markTaskErrored
	local markSchedulerSuspended = SchedulerProfiling.markSchedulerSuspended
	local markSchedulerUnsuspended = SchedulerProfiling.markSchedulerUnsuspended
	local markTaskStart = SchedulerProfiling.markTaskStart
	local stopLoggingProfilingEvents = SchedulerProfiling.stopLoggingProfilingEvents
	local startLoggingProfilingEvents = SchedulerProfiling.startLoggingProfilingEvents

	local v2 = {}
	local v3 = {}

	local id = 1

	local v4 = false

	local v5 = nil
	local v6 = normalPriority

	local v7 = false

	local v8 = false
	local flag = false

	local fn4
	local fn5

	local function fn6(list, p2) -- 3 equivalent calls inferred from this helper
		local v9 = #list + 1
		list[v9] = p2

		fn2(list, p2, v9)
	end

	local function fn7(list) -- 10 equivalent calls inferred from this helper
		return list[1]
	end

	local function fn8(list) -- 4 equivalent calls inferred from this helper
		local item = list[1]

		if item == nil then
			return nil
		end

		local item2 = list[#list]
		list[#list] = nil

		if item2 ~= item then
			list[1] = item2
			fn3(list, item2, 1)
		end

		return item
	end

	local function advanceTimers(p2)
		local v9 = fn7(v3) -- inferred equivalent call

		while v9 ~= nil do
			if v9.callback == nil then
				fn8(v3) -- inferred equivalent call
			else
				if not (v9.startTime <= p2) then
					break
				end

				fn8(v3) -- inferred equivalent call
				v9.sortIndex = v9.expirationTime
				fn6(v2, v9) -- inferred equivalent call

				if enableProfiling then
					markTaskStart(v9, p2)
					v9.isQueued = true
				end
			end

			v9 = fn7(v3) -- inferred equivalent call
		end
	end

	local function fn9(p2)
		flag = false
		advanceTimers(p2)

		if not v8 then
			if fn7(v2) == nil then -- inferred equivalent call
				local v9 = fn7(v3) -- inferred equivalent call

				if v9 ~= nil then
					requestHostTimeout(fn9, v9.startTime - p2)
				end
			else
				v8 = true
				requestHostCallback(fn4)
			end
		end
	end

	fn4 = function(p2, p3)
		if enableProfiling then
			markSchedulerUnsuspended(p3)
		end

		v8 = false

		if flag then
			flag = false
			cancelHostTimeout()
		end

		v7 = true
		local v9 = v6
		local result, success

		if ReactGlobals.__YOLO__ then
			result = fn5(p2, p3)
			success = true
		elseif enableProfiling then
			success, result = xpcall(fn5, describeError, p2, p3)

			if not success and v5 ~= nil then
				local currentTime = getCurrentTime()
				markTaskErrored(v5, currentTime)
				v5.isQueued = false
			end
		else
			result = fn5(p2, p3)
			success = true
		end

		v5 = nil
		v6 = v9
		v7 = false

		if enableProfiling then
			markSchedulerSuspended((getCurrentTime()))
		end

		if not success then
			error(result)
		end

		return result
	end

	fn5 = function(p2, p3): boolean
		local catchYieldingInDEV = ReactGlobals.__DEV__ and reactFeatureFlags.catchYieldingInDEV

		advanceTimers(p3)
		v5 = fn7(v2) -- inferred equivalent call

		while
			v5 ~= nil
			and not (enableSchedulerDebugging and v4)
			and (not (p3 < v5.expirationTime) or p2 and not shouldYieldToHost())
		do
			local callback = v5.callback

			if typeof(callback) == "function" then
				v5.callback = nil
				v6 = v5.priorityLevel
				local v9 = v5.expirationTime <= p3
				markTaskRun(v5, p3)
				local callback2

				if catchYieldingInDEV then
					callback2 = NoYield(callback, v9)
				else
					callback2 = callback(v9)
				end

				p3 = getCurrentTime()

				if typeof(callback2) == "function" then
					v5.callback = callback2
					markTaskYield(v5, p3)
				else
					if enableProfiling then
						markTaskCompleted(v5, p3)
						v5.isQueued = false
					end

					if v5 == fn7(v2) then -- inferred equivalent call
						fn8(v2) -- inferred equivalent call
					end
				end

				advanceTimers(p3)
			else
				fn8(v2) -- inferred equivalent call
			end

			v5 = fn7(v2) -- inferred equivalent call
		end

		if v5 ~= nil then
			return true
		end

		local v9 = fn7(v3) -- inferred equivalent call

		if v9 ~= nil then
			requestHostTimeout(fn9, v9.startTime - p3)
		end

		return false
	end

	return {
		unstable_ImmediatePriority = immediatePriority,
		unstable_UserBlockingPriority = userBlockingPriority,
		unstable_NormalPriority = normalPriority,
		unstable_IdlePriority = idlePriority,
		unstable_LowPriority = lowPriority,
		unstable_runWithPriority = function(p2, callback)
			if
				p2 ~= immediatePriority
				and p2 ~= userBlockingPriority
				and p2 ~= normalPriority
				and p2 ~= lowPriority
				and p2 ~= idlePriority
			then
				p2 = normalPriority
			end

			local v9 = v6
			v6 = p2
			local result, success

			if ReactGlobals.__YOLO__ then
				result = callback()
				success = true
			else
				success, result = xpcall(callback, describeError)
			end

			v6 = v9

			if not success then
				error(result)
			end

			return result
		end,
		unstable_next = function(callback)
			local v9

			if v6 == immediatePriority or v6 == userBlockingPriority or v6 == normalPriority then
				v9 = normalPriority
			else
				v9 = v6
			end

			local v10 = v6
			v6 = v9
			local result, success

			if ReactGlobals.__YOLO__ then
				result = callback()
				success = true
			else
				success, result = xpcall(callback, describeError)
			end

			v6 = v10

			if not success then
				error(result)
			end

			return result
		end,
		unstable_scheduleCallback = function(priorityLevel, callback, p2)
			local currentTime = getCurrentTime()
			local v9

			if typeof(p2) == "table" then
				local delay = p2.delay

				if typeof(delay) == "number" and delay > 0 then
					v9 = currentTime + delay
				else
					v9 = currentTime
				end
			else
				v9 = currentTime
			end

			local v10 = v9 + (priorityLevel == immediatePriority and -1 or priorityLevel == userBlockingPriority and 250 or priorityLevel == idlePriority and 1073741823 or priorityLevel == lowPriority and 10000 or 5000)

			local v11 = {
				id = id,
				callback = callback,
				priorityLevel = priorityLevel,
				startTime = v9,
				expirationTime = v10,
				sortIndex = -1
			}

			id += 1

			if enableProfiling then
				v11.isQueued = false
			end

			if currentTime < v9 then
				v11.sortIndex = v9
				fn6(v3, v11) -- inferred equivalent call

				if #v2 == 0 and v11 == fn7(v3) then -- inferred equivalent call
					if flag then
						cancelHostTimeout()
					else
						flag = true
					end

					requestHostTimeout(fn9, v9 - currentTime)
					return v11
				end
			else
				v11.sortIndex = v10
				fn6(v2, v11) -- inferred equivalent call

				if enableProfiling then
					markTaskStart(v11, currentTime)
					v11.isQueued = true
				end

				if not (v8 or v7) then
					v8 = true
					requestHostCallback(fn4)
				end
			end

			return v11
		end,
		unstable_cancelCallback = function(p2)
			if enableProfiling and p2.isQueued then
				markTaskCanceled(p2, (getCurrentTime()))
				p2.isQueued = false
			end

			p2.callback = nil
		end,
		unstable_wrapCallback = function(callback)
			local v9 = v6

			return function(...)
				local v10 = v6
				v6 = v9
				local result, success

				if ReactGlobals.__YOLO__ then
					result = callback(...)
					success = true
				else
					success, result = xpcall(callback, describeError, ...)
				end

				v6 = v10

				if not success then
					error(result)
				end

				return result
			end
		end,
		unstable_getCurrentPriorityLevel = function()
			return v6
		end,
		unstable_shouldYield = shouldYieldToHost,
		unstable_requestPaint = requestPaint,
		unstable_continueExecution = function()
			v4 = false

			if not (v8 or v7) then
				v8 = true
				requestHostCallback(fn4)
			end
		end,
		unstable_pauseExecution = function()
			v4 = true
		end,
		unstable_getFirstCallbackNode = function()
			return fn7(v2) -- inferred equivalent call
		end,
		unstable_now = getCurrentTime,
		unstable_forceFrameRate = forceFrameRate,
		unstable_setSchedulerFlags = setSchedulerFlags,
		unstable_getSchedulerFlags = getSchedulerFlags,
		unstable_Profiling = enableProfiling and {
			startLoggingProfilingEvents = startLoggingProfilingEvents,
			stopLoggingProfilingEvents = stopLoggingProfilingEvents
		} or nil
	}
end
