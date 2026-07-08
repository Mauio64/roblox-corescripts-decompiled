return function(p1) -- line: 12
	local ParentParent = script.Parent.Parent
	local ReactGlobals = require(ParentParent.ReactGlobals)
	local Shared = require(ParentParent.Shared)
	local describeError = Shared.describeError
	local ReactFeatureFlags = Shared.ReactFeatureFlags
	local SchedulerFeatureFlags = require(script.Parent.SchedulerFeatureFlags)
	local enableSchedulerDebugging = SchedulerFeatureFlags.enableSchedulerDebugging
	local enableProfiling = SchedulerFeatureFlags.enableProfiling
	local v10 = p1 or require(script.Parent.SchedulerHostConfig)
	local requestHostCallback = v10.requestHostCallback
	local requestHostTimeout = v10.requestHostTimeout
	local cancelHostTimeout = v10.cancelHostTimeout
	local shouldYieldToHost = v10.shouldYieldToHost
	local getCurrentTime = v10.getCurrentTime
	local forceFrameRate = v10.forceFrameRate
	local requestPaint = v10.requestPaint
	local setSchedulerFlags = v10.setSchedulerFlags
	local getSchedulerFlags = v10.getSchedulerFlags
	local NoYield = require(script.Parent.NoYield)
	local u21 = nil
	local u22 = nil
	local u23 = nil

	function u22(t1: {[any]: any}, t2: {[any]: any}, n1: number) -- line: 78
		-- upvalues: u21 (ref)
		while true do
			local v64 = math.floor(n1 / 2)
			local v65 = t1[v64]

			if v65 == nil or not (u21(v65, t2) > 0) then
				break
			end

			t1[v64] = t2
			t1[n1] = v65
			n1 = v64
		end
	end
	function u23(t3: {[any]: any}, t4: {[any]: any}, n2: number) -- line: 94
		-- upvalues: u21 (ref)
		local v69 = #t3

		while n2 < v69 do
			local v70 = n2 * 2
			local v71 = t3[v70]
			local v72 = v70 + 1
			local v73 = t3[v72]

			if v71 ~= nil and u21(v71, t4) < 0 then
				if v73 ~= nil and u21(v73, v71) < 0 then
					t3[n2] = v73
					t3[v72] = t4
					n2 = v72
				else
					t3[n2] = v71
					t3[v70] = t4
					n2 = v70
				end

				continue
			end

			if v73 == nil or not (u21(v73, t4) < 0) then
				return
			end

			t3[n2] = v73
			t3[v72] = t4
			n2 = v72
		end
	end
	function u21(t5: {[any]: any}, t6: {[any]: any}) -- line: 124
		local v76 = t5.sortIndex - t6.sortIndex

		if v76 == 0 then
			return t5.id - t6.id
		end

		return v76
	end

	local SchedulerPriorities = require(script.Parent.SchedulerPriorities)
	local ImmediatePriority = SchedulerPriorities.ImmediatePriority
	local UserBlockingPriority = SchedulerPriorities.UserBlockingPriority
	local NormalPriority = SchedulerPriorities.NormalPriority
	local LowPriority = SchedulerPriorities.LowPriority
	local IdlePriority = SchedulerPriorities.IdlePriority
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
	local t7 = {}
	local t8 = {}
	local n3 = 1
	local u44 = false
	local u45 = nil
	local u46 = NormalPriority
	local u47 = false
	local u48 = false
	local u49 = false
	local u50 = nil
	local u51 = nil

	local function advanceTimers(p2) -- line: 191
		-- upvalues: t8 (copy), u23 (ref), t7 (copy), u22 (ref), enableProfiling (copy), markTaskStart (copy)
		local v78 = t8[1]

		while v78 ~= nil do
			if v78.callback == nil then
				local v79 = t8
				local v80 = v79[1]

				if v80 ~= nil then
					local v81 = v79[#v79]

					v79[#v79] = nil

					if v81 ~= v80 then
						v79[1] = v81
						u23(v79, v81, 1)
					end
				end
			else
				if not (p2 >= v78.startTime) then
					return
				end

				local v82 = t8
				local v83 = v82[1]

				if v83 ~= nil then
					local v84 = v82[#v82]

					v82[#v82] = nil

					if v84 ~= v83 then
						v82[1] = v84
						u23(v82, v84, 1)
					end
				end

				v78.sortIndex = v78.expirationTime

				local v85 = t7
				local v86 = #v85 + 1

				v85[v86] = v78
				u22(v85, v78, v86)

				if enableProfiling then
					markTaskStart(v78, p2)
					v78.isQueued = true
				end
			end

			v78 = t8[1]
		end
	end
	local function u53(p3) -- line: 217
		-- upvalues: u49 (ref), advanceTimers (copy), u48 (ref), t7 (copy), requestHostCallback (copy), u50 (ref), t8 (copy), requestHostTimeout (copy), u53 (ref)
		u49 = false
		advanceTimers(p3)

		if not u48 then
			if t7[1] ~= nil then
				u48 = true
				requestHostCallback(u50)

				return
			end

			local v88 = t8[1]

			if v88 ~= nil then
				requestHostTimeout(u53, v88.startTime - p3)
			end
		end
	end

	function u50(p4, p5) -- line: 234
		-- upvalues: enableProfiling (copy), markSchedulerUnsuspended (copy), u48 (ref), u49 (ref), cancelHostTimeout (copy), u47 (ref), u46 (ref), ReactGlobals (copy), u51 (ref), describeError (copy), u45 (ref), getCurrentTime (copy), markTaskErrored (copy), markSchedulerSuspended (copy)
		if enableProfiling then
			markSchedulerUnsuspended(p5)
		end

		u48 = false

		if u49 then
			u49 = false
			cancelHostTimeout()
		end

		u47 = true

		local v91 = u46
		local ok, result

		if not ReactGlobals.__YOLO__ then
			if enableProfiling then
				ok, result = xpcall(u51, describeError, p4, p5)

				if not ok and u45 ~= nil then
					local v94 = getCurrentTime()

					markTaskErrored(u45, v94)
					u45.isQueued = false
				end
			else
				ok = true
				result = u51(p4, p5)
			end
		else
			ok = true
			result = u51(p4, p5)
		end

		u45 = nil
		u46 = v91
		u47 = false

		if enableProfiling then
			local v95 = getCurrentTime()

			markSchedulerSuspended(v95)
		end

		if not ok then
			error(result)
		end

		return result
	end
	function u51(p6, p7) -- line: 291
		-- upvalues: ReactGlobals (copy), ReactFeatureFlags (copy), advanceTimers (copy), u45 (ref), t7 (copy), enableSchedulerDebugging (copy), u44 (ref), shouldYieldToHost (copy), u46 (ref), markTaskRun (copy), NoYield (copy), getCurrentTime (copy), markTaskYield (copy), enableProfiling (copy), markTaskCompleted (copy), u23 (ref), t8 (copy), requestHostTimeout (copy), u53 (ref)
		local v98 = ReactGlobals.__DEV__ and ReactFeatureFlags.catchYieldingInDEV

		advanceTimers(p7)
		u45 = t7[1]

		while u45 ~= nil and (not enableSchedulerDebugging or not u44) and (not (p7 < u45.expirationTime) or p6 and not shouldYieldToHost()) do
			local callback = u45.callback

			if typeof(callback) == "function" then
				u45.callback = nil
				u46 = u45.priorityLevel

				local v100 = p7 >= u45.expirationTime

				markTaskRun(u45, p7)

				local v101 = if not v98 then callback(v100) else NoYield(callback, v100)

				p7 = getCurrentTime()

				if typeof(v101) == "function" then
					u45.callback = v101
					markTaskYield(u45, p7)
				else
					if enableProfiling then
						markTaskCompleted(u45, p7)
						u45.isQueued = false
					end

					if u45 == t7[1] then
						local v102 = t7
						local v103 = v102[1]

						if v103 ~= nil then
							local v104 = v102[#v102]

							v102[#v102] = nil

							if v104 ~= v103 then
								v102[1] = v104
								u23(v102, v104, 1)
							end
						end
					end
				end

				advanceTimers(p7)
			else
				local v105 = t7
				local v106 = v105[1]

				if v106 ~= nil then
					local v107 = v105[#v105]

					v105[#v105] = nil

					if v107 ~= v106 then
						v105[1] = v107
						u23(v105, v107, 1)
					end
				end
			end

			u45 = t7[1]
		end

		if u45 ~= nil then
			return true
		end

		local v108 = t8[1]

		if v108 ~= nil then
			requestHostTimeout(u53, v108.startTime - p7)
		end

		return false
	end

	return {
		unstable_ImmediatePriority = ImmediatePriority,
		unstable_UserBlockingPriority = UserBlockingPriority,
		unstable_NormalPriority = NormalPriority,
		unstable_IdlePriority = IdlePriority,
		unstable_LowPriority = LowPriority,
		unstable_runWithPriority = function(p8, p9) -- line: 358
			-- upvalues: ImmediatePriority (copy), UserBlockingPriority (copy), NormalPriority (copy), LowPriority (copy), IdlePriority (copy), u46 (ref), ReactGlobals (copy), describeError (copy)
			if p8 ~= ImmediatePriority and (p8 ~= UserBlockingPriority and p8 ~= NormalPriority and p8 ~= LowPriority and p8 ~= IdlePriority) then
				p8 = NormalPriority
			end

			local v111 = u46

			u46 = p8

			local ok, result

			if not ReactGlobals.__YOLO__ then
				ok, result = xpcall(p9, describeError)
			else
				ok = true
				result = p9()
			end

			u46 = v111

			if not ok then
				error(result)
			end

			return result
		end,
		unstable_next = function(p10) -- line: 393
			-- upvalues: u46 (ref), ImmediatePriority (copy), UserBlockingPriority (copy), NormalPriority (copy), ReactGlobals (copy), describeError (copy)
			local v115 = if u46 ~= ImmediatePriority and (u46 ~= UserBlockingPriority and u46 ~= NormalPriority) then u46 else NormalPriority
			local v116 = u46

			u46 = v115

			local ok, result

			if not ReactGlobals.__YOLO__ then
				ok, result = xpcall(p10, describeError)
			else
				ok = true
				result = p10()
			end

			u46 = v116

			if not ok then
				error(result)
			end

			return result
		end,
		unstable_scheduleCallback = function(p11, p12, p13) -- line: 457
			-- upvalues: getCurrentTime (copy), ImmediatePriority (copy), UserBlockingPriority (copy), IdlePriority (copy), LowPriority (copy), n3 (ref), enableProfiling (copy), t8 (copy), u22 (ref), t7 (copy), u49 (ref), cancelHostTimeout (copy), requestHostTimeout (copy), u53 (ref), markTaskStart (copy), u48 (ref), u47 (ref), requestHostCallback (copy), u50 (ref)
			local v124 = getCurrentTime()
			local v126

			if typeof(p13) == "table" then
				local delay = p13.delay

				v126 = if typeof(delay) ~= "number" or not (delay > 0) then v124 else v124 + delay
			else
				v126 = v124
			end

			local v127 = v126 + if p11 ~= ImmediatePriority then if p11 ~= UserBlockingPriority then if p11 ~= IdlePriority then p11 ~= LowPriority and 5000 or 10000 else 1073741823 else 250 else -1
			local t9 = {
				sortIndex = -1,
				id = n3,
				callback = p12,
				priorityLevel = p11,
				startTime = v126,
				expirationTime = v127
			}

			n3 += 1

			if enableProfiling then
				t9.isQueued = false
			end

			if v124 < v126 then
				t9.sortIndex = v126

				local v129 = t8
				local v130 = #v129 + 1

				v129[v130] = t9
				u22(v129, t9, v130)

				if #t7 == 0 and t9 == t8[1] then
					if u49 then
						cancelHostTimeout()
					else
						u49 = true
					end

					requestHostTimeout(u53, v126 - v124)

					return t9
				end
			else
				t9.sortIndex = v127

				local v131 = t7
				local v132 = #v131 + 1

				v131[v132] = t9
				u22(v131, t9, v132)

				if enableProfiling then
					markTaskStart(t9, v124)
					t9.isQueued = true
				end

				if not u48 and not u47 then
					u48 = true
					requestHostCallback(u50)
				end
			end

			return t9
		end,
		unstable_cancelCallback = function(p14) -- line: 553
			-- upvalues: enableProfiling (copy), getCurrentTime (copy), markTaskCanceled (copy)
			if enableProfiling and p14.isQueued then
				local v134 = getCurrentTime()

				markTaskCanceled(p14, v134)
				p14.isQueued = false
			end

			p14.callback = nil
		end,
		unstable_wrapCallback = function(p15) -- line: 429
			-- upvalues: u46 (ref), ReactGlobals (copy), describeError (copy)
			local v120 = u46

			return function(...) -- line: 432
				-- upvalues: u46 (ref), v120 (copy), ReactGlobals (copy), p15 (copy), describeError (copy)
				local v135 = u46

				u46 = v120

				local ok, result

				if not ReactGlobals.__YOLO__ then
					ok, result = xpcall(p15, describeError, ...)
				else
					ok = true
					result = p15(...)
				end

				u46 = v135

				if not ok then
					error(result)
				end

				return result
			end
		end,
		unstable_getCurrentPriorityLevel = function() -- line: 568
			-- upvalues: u46 (ref)
			return u46
		end,
		unstable_shouldYield = shouldYieldToHost,
		unstable_requestPaint = requestPaint,
		unstable_continueExecution = function() -- line: 541
			-- upvalues: u44 (ref), u48 (ref), u47 (ref), requestHostCallback (copy), u50 (ref)
			u44 = false

			if not u48 and not u47 then
				u48 = true
				requestHostCallback(u50)
			end
		end,
		unstable_pauseExecution = function() -- line: 537
			-- upvalues: u44 (ref)
			u44 = true
		end,
		unstable_getFirstCallbackNode = function() -- line: 549
			-- upvalues: t7 (copy)
			return t7[1]
		end,
		unstable_now = getCurrentTime,
		unstable_forceFrameRate = forceFrameRate,
		unstable_setSchedulerFlags = setSchedulerFlags,
		unstable_getSchedulerFlags = getSchedulerFlags,
		unstable_Profiling = if not enableProfiling then nil else {
			startLoggingProfilingEvents = startLoggingProfilingEvents,
			stopLoggingProfilingEvents = stopLoggingProfilingEvents
		}
	}
end
