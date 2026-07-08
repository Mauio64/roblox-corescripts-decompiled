local ParentParent = script.Parent.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Object = LuauPolyfill.Object
local Shared = require(ParentParent.Shared)
local console = Shared.console
local errorToString = Shared.errorToString
local describeError = Shared.describeError
local SafeFlags = require(ParentParent.SafeFlags)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout
local u12 = false
local u13 = nil
local None = Object.None
local v15 = SafeFlags.createGetFInt("ReactSchedulerYieldInterval2", 15)
local v16 = SafeFlags.createGetFInt("ReactSchedulerDesiredFrameRate", 60)()
local v17 = SafeFlags.createGetFInt("ReactSchedulerMinFrameRate", 30)()
local u18 = SafeFlags.createGetFFlag("ReactSchedulerEnableDeferredWork")()
local u19 = SafeFlags.createGetFFlag("ReactSchedulerSetFrameMarkerOnHeartbeatEnd")()
local u20 = SafeFlags.createGetFFlag("ReactSchedulerSetTargetMsByHeartbeatDelta")()
local u21 = SafeFlags.createGetFInt("ReactSchedulerNumberOfLookbackFrames", 1)()
local u22 = SafeFlags.createGetFFlag("ReactSchedulerLookbackUseRingBuffer")()
local u23 = false
local n1 = 0
local v25 = 1000 / v16
local v26 = 1000 / v17
local u27 = v25
local u28 = u27
local connection = nil
local v30 = if not u22 then nil else table.create(u21)
local n2 = 1

local function createHeartbeatConnection() -- line: 71
	-- upvalues: connection (ref), u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), v25 (copy), v26 (copy)
	if connection then
		connection:Disconnect()
	end

	connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 76
		-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), v25 (copy), v26 (copy)
		if u21 > 1 then
			if u22 then
				v30[n2] = dt * 1000
				n2 = n2 % u21 + 1

				local n3 = 0
				local v68 = u21

				for i = 1, v68 do
					if v30[i] == nil then
						v68 = i - 1

						break
					end

					n3 += v30[i]
				end

				u28 = n3 / v68
			else
				local v70 = u21

				u28 = (u28 * (v70 - 1) + dt * 1000) / v70
			end

			u27 = math.clamp(u28, v25, v26)

			return
		end

		u27 = math.clamp(dt * 1000, v25, v26)
	end)
end

if u20 then
	if connection then
		connection:Disconnect()
	end

	connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 76
		-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), v25 (copy), v26 (copy)
		if u21 > 1 then
			if u22 then
				v30[n2] = dt * 1000
				n2 = n2 % u21 + 1

				local n4 = 0
				local v43 = u21

				for i = 1, v43 do
					if v30[i] == nil then
						v43 = i - 1

						break
					end

					n4 += v30[i]
				end

				u28 = n4 / v43
			else
				local v45 = u21

				u28 = (u28 * (v45 - 1) + dt * 1000) / v45
			end

			u27 = math.clamp(u28, v25, v26)

			return
		end

		u27 = math.clamp(dt * 1000, v25, v26)
	end)
end

local function setFrameMarker() -- line: 118
	-- upvalues: n1 (ref)
	n1 = os.clock() * 1000
end

local u34 = v15()
local n5 = 0

local function doesBudgetRemain() -- line: 179
	-- upvalues: n1 (ref), u27 (ref), u34 (ref)
	local v47 = os.clock() * 1000 - n1

	return u27 - v47 > u34
end
local function performWorkUntilDeadline() -- line: 210
	-- upvalues: u13 (ref), n5 (ref), u34 (ref), u18 (ref), u19 (ref), u23 (ref), n1 (ref), u27 (ref), u12 (ref), performWorkUntilDeadline (ref), setFrameMarker (copy), ReactGlobals (copy), describeError (copy), errorToString (copy)
	if u13 ~= nil then
		local v49 = os.clock() * 1000

		n5 = v49 + u34

		local u50 = true

		if u18 and not u19 and not u23 then
			n1 = v49
		end

		if u19 and u23 then
			local v51 = os.clock() * 1000 - n1

			if not (u27 - v51 > u34) then
				u50 = false
			end
		end

		local function doWork() -- line: 240
			-- upvalues: u13 (ref), u50 (ref), v49 (copy), u12 (ref), u18 (ref), n1 (ref), u27 (ref), u34 (ref), u23 (ref), performWorkUntilDeadline (ref), u19 (ref), setFrameMarker (copy)
			if not u13(u50, v49) then
				u12 = false
				u13 = nil
			elseif u18 then
				local v76 = os.clock() * 1000 - n1

				if u27 - v76 > u34 then
					u23 = true
					task.defer(performWorkUntilDeadline)
				else
					u23 = false
					task.delay(0, performWorkUntilDeadline)

					if u19 then
						task.defer(setFrameMarker)
					end
				end
			else
				task.delay(0, performWorkUntilDeadline)
			end

			return nil
		end

		local ok, result

		if not ReactGlobals.__YOLO__ then
			ok, result = xpcall(doWork, describeError)
		else
			result = doWork()
			ok = true
		end

		if not ok then
			task.delay(0, performWorkUntilDeadline)

			if u19 then
				task.defer(setFrameMarker)
			end

			error(errorToString(result))
		end

		return
	end

	u12 = false
end
local function wrapPerformWorkWithCoroutine(p1) -- line: 301
	local co = coroutine.create(function() -- line: 302
		-- upvalues: p1 (copy)
		while true do
			local co = coroutine.wrap(p1)
			local ok, result = pcall(co)

			coroutine.yield(ok, result)
		end
	end)

	return function() -- line: 312
		-- upvalues: co (copy)
		local _, result, v82 = coroutine.resume(co)

		if not result then
			error(v82)
		end
	end
end

local v39 = performWorkUntilDeadline
local co = coroutine.create(function() -- line: 302
	-- upvalues: v39 (copy)
	while true do
		local co = coroutine.wrap(v39)
		local ok, result = pcall(co)

		coroutine.yield(ok, result)
	end
end)

function performWorkUntilDeadline() -- line: 312
	-- upvalues: co (copy)
	local _, result, v62 = coroutine.resume(co)

	if not result then
		error(v62)
	end
end

return {
	requestHostCallback = function(p2) -- line: 322
		-- upvalues: u13 (ref), u12 (ref), performWorkUntilDeadline (ref), u19 (ref), setFrameMarker (copy)
		u13 = p2

		if not u12 then
			u12 = true
			task.delay(0, performWorkUntilDeadline)

			if u19 then
				task.defer(setFrameMarker)
			end
		end
	end,
	cancelHostCallback = function() -- line: 334
		-- upvalues: u13 (ref)
		u13 = nil
	end,
	requestHostTimeout = function(p3, p4) -- line: 338
		-- upvalues: None (ref), setTimeout (copy)
		None = setTimeout(function() -- line: 339
			-- upvalues: p3 (copy)
			p3(os.clock() * 1000)
		end, p4)
	end,
	cancelHostTimeout = function() -- line: 344
		-- upvalues: clearTimeout (copy), None (ref), Object (copy)
		clearTimeout(None)
		None = Object.None
	end,
	shouldYieldToHost = function() -- line: 187
		-- upvalues: n5 (ref)
		return os.clock() * 1000 >= n5
	end,
	requestPaint = function() -- line: 192
	end,
	getCurrentTime = function() -- line: 22
		return os.clock() * 1000
	end,
	forceFrameRate = function(p5) -- line: 194
		-- upvalues: console (copy), u34 (ref)
		if p5 < 0 or p5 > 125 then
			console.warn("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported")

			return
		end

		if p5 > 0 then
			u34 = math.floor(1000 / p5)

			return
		end

		u34 = 5
	end,
	setSchedulerFlags = function(t1: {[any]: any}) -- line: 138
		-- upvalues: u34 (ref), u18 (ref), u19 (ref), u20 (ref), connection (ref), u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), v25 (copy), v26 (copy)
		if t1.yieldInterval ~= nil then
			u34 = t1.yieldInterval
		end

		if t1.deferredWork ~= nil then
			u18 = t1.deferredWork
		end

		if t1.heartbeatFrameMarker ~= nil then
			u19 = t1.heartbeatFrameMarker
		end

		if t1.targetMsByHeartbeatDelta ~= nil then
			u20 = t1.targetMsByHeartbeatDelta

			if t1.targetMsByHeartbeatDelta then
				if connection then
					connection:Disconnect()
				end

				connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 76
					-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), v25 (copy), v26 (copy)
					if u21 > 1 then
						if u22 then
							v30[n2] = dt * 1000
							n2 = n2 % u21 + 1

							local n6 = 0
							local v73 = u21

							for i = 1, v73 do
								if v30[i] == nil then
									v73 = i - 1

									break
								end

								n6 += v30[i]
							end

							u28 = n6 / v73
						else
							local v75 = u21

							u28 = (u28 * (v75 - 1) + dt * 1000) / v75
						end

						u27 = math.clamp(u28, v25, v26)

						return
					end

					u27 = math.clamp(dt * 1000, v25, v26)
				end)
			elseif connection then
				connection:Disconnect()
				connection = nil
				u27 = v25
			end
		end

		if t1.numberOfLookbackFrames ~= nil then
			u21 = t1.numberOfLookbackFrames
		end

		if t1.lookbackUseRingBuffer ~= nil then
			u22 = t1.lookbackUseRingBuffer
		end
	end,
	getSchedulerFlags = function() -- line: 168
		-- upvalues: u34 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref)
		return {
			yieldInterval = u34,
			deferredWork = u18,
			heartbeatFrameMarker = u19,
			targetMsByHeartbeatDelta = u20,
			numberOfLookbackFrames = u21,
			lookbackUseRingBuffer = u22
		}
	end
}
