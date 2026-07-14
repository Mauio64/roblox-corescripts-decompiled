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
local u16 = SafeFlags.createGetFInt("ReactSchedulerDesiredFrameRate", 60)()
local u17 = SafeFlags.createGetFInt("ReactSchedulerMinFrameRate", 30)()
local u18 = SafeFlags.createGetFFlag("ReactSchedulerEnableDeferredWork")()
local u19 = SafeFlags.createGetFFlag("ReactSchedulerSetFrameMarkerOnHeartbeatEnd")()
local u20 = SafeFlags.createGetFFlag("ReactSchedulerSetTargetMsByHeartbeatDelta")()
local u21 = SafeFlags.createGetFInt("ReactSchedulerNumberOfLookbackFrames", 1)()
local u22 = SafeFlags.createGetFFlag("ReactSchedulerLookbackUseRingBuffer")()
local u23 = false
local n1 = 0
local u25 = 1000 / u16
local u26 = 1000 / u17
local u27 = u25
local u28 = u27
local connection = nil
local v30 = if not u22 then nil else table.create(u21)
local n2 = 1

local function resetFrameBudgets() -- line: 71
	-- upvalues: u25 (ref), u16 (ref), u26 (ref), u17 (ref), u27 (ref), u28 (ref)
	u25 = 1000 / u16
	u26 = 1000 / u17
	u27 = u25
	u28 = u27
end
local function createHeartbeatConnection() -- line: 78
	-- upvalues: connection (ref), u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), u25 (ref), u26 (ref)
	if connection then
		connection:Disconnect()
	end

	connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 83
		-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), u25 (ref), u26 (ref)
		if u21 > 1 then
			if u22 then
				v30[n2] = dt * 1000
				n2 = n2 % u21 + 1

				local n3 = 0
				local v69 = u21

				for i = 1, v69 do
					if v30[i] == nil then
						v69 = i - 1

						break
					end

					n3 += v30[i]
				end

				u28 = n3 / v69
			else
				local v71 = u21

				u28 = (u28 * (v71 - 1) + dt * 1000) / v71
			end

			u27 = math.clamp(u28, u25, u26)

			return
		end

		u27 = math.clamp(dt * 1000, u25, u26)
	end)
end

if u20 then
	if connection then
		connection:Disconnect()
	end

	connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 83
		-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), u25 (ref), u26 (ref)
		if u21 > 1 then
			if u22 then
				v30[n2] = dt * 1000
				n2 = n2 % u21 + 1

				local n4 = 0
				local v44 = u21

				for i = 1, v44 do
					if v30[i] == nil then
						v44 = i - 1

						break
					end

					n4 += v30[i]
				end

				u28 = n4 / v44
			else
				local v46 = u21

				u28 = (u28 * (v46 - 1) + dt * 1000) / v46
			end

			u27 = math.clamp(u28, u25, u26)

			return
		end

		u27 = math.clamp(dt * 1000, u25, u26)
	end)
end

local function setFrameMarker() -- line: 125
	-- upvalues: n1 (ref)
	n1 = os.clock() * 1000
end

local u35 = v15()
local n5 = 0

local function doesBudgetRemain() -- line: 198
	-- upvalues: n1 (ref), u27 (ref), u35 (ref)
	local v48 = os.clock() * 1000 - n1

	return u27 - v48 > u35
end
local function performWorkUntilDeadline() -- line: 229
	-- upvalues: u13 (ref), n5 (ref), u35 (ref), u18 (ref), u19 (ref), u23 (ref), n1 (ref), u27 (ref), u12 (ref), performWorkUntilDeadline (ref), setFrameMarker (copy), ReactGlobals (copy), describeError (copy), errorToString (copy)
	if u13 ~= nil then
		local v50 = os.clock() * 1000

		n5 = v50 + u35

		local u51 = true

		if u18 and not u19 and not u23 then
			n1 = v50
		end

		if u19 and u23 then
			local v52 = os.clock() * 1000 - n1

			if not (u27 - v52 > u35) then
				u51 = false
			end
		end

		local function doWork() -- line: 259
			-- upvalues: u13 (ref), u51 (ref), v50 (copy), u12 (ref), u18 (ref), n1 (ref), u27 (ref), u35 (ref), u23 (ref), performWorkUntilDeadline (ref), u19 (ref), setFrameMarker (copy)
			if not u13(u51, v50) then
				u12 = false
				u13 = nil
			elseif u18 then
				local v77 = os.clock() * 1000 - n1

				if u27 - v77 > u35 then
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
local function wrapPerformWorkWithCoroutine(p1) -- line: 320
	local co = coroutine.create(function() -- line: 321
		-- upvalues: p1 (copy)
		while true do
			local co = coroutine.wrap(p1)
			local ok, result = pcall(co)

			coroutine.yield(ok, result)
		end
	end)

	return function() -- line: 331
		-- upvalues: co (copy)
		local _, result, v83 = coroutine.resume(co)

		if not result then
			error(v83)
		end
	end
end

local v40 = performWorkUntilDeadline
local co = coroutine.create(function() -- line: 321
	-- upvalues: v40 (copy)
	while true do
		local co = coroutine.wrap(v40)
		local ok, result = pcall(co)

		coroutine.yield(ok, result)
	end
end)

function performWorkUntilDeadline() -- line: 331
	-- upvalues: co (copy)
	local _, result, v63 = coroutine.resume(co)

	if not result then
		error(v63)
	end
end

return {
	requestHostCallback = function(p2) -- line: 341
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
	cancelHostCallback = function() -- line: 353
		-- upvalues: u13 (ref)
		u13 = nil
	end,
	requestHostTimeout = function(p3, p4) -- line: 357
		-- upvalues: None (ref), setTimeout (copy)
		None = setTimeout(function() -- line: 358
			-- upvalues: p3 (copy)
			p3(os.clock() * 1000)
		end, p4)
	end,
	cancelHostTimeout = function() -- line: 363
		-- upvalues: clearTimeout (copy), None (ref), Object (copy)
		clearTimeout(None)
		None = Object.None
	end,
	shouldYieldToHost = function() -- line: 206
		-- upvalues: n5 (ref)
		return os.clock() * 1000 >= n5
	end,
	requestPaint = function() -- line: 211
	end,
	getCurrentTime = function() -- line: 22
		return os.clock() * 1000
	end,
	forceFrameRate = function(p5) -- line: 213
		-- upvalues: console (copy), u35 (ref)
		if p5 < 0 or p5 > 125 then
			console.warn("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported")

			return
		end

		if p5 > 0 then
			u35 = math.floor(1000 / p5)

			return
		end

		u35 = 5
	end,
	setSchedulerFlags = function(t1: {[any]: any}) -- line: 147
		-- upvalues: u35 (ref), u16 (ref), u25 (ref), u26 (ref), u17 (ref), u27 (ref), u28 (ref), u18 (ref), u19 (ref), u20 (ref), connection (ref), u21 (ref), u22 (ref), v30 (copy), n2 (ref)
		if t1.yieldInterval ~= nil then
			u35 = t1.yieldInterval
		end

		if t1.desiredFrameRate ~= nil then
			u16 = t1.desiredFrameRate
			u25 = 1000 / u16
			u26 = 1000 / u17
			u27 = u25
			u28 = u27
		end

		if t1.minimumFrameRate ~= nil then
			u17 = t1.minimumFrameRate
			u25 = 1000 / u16
			u26 = 1000 / u17
			u27 = u25
			u28 = u27
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

				connection = game:GetService("RunService").Heartbeat:Connect(function(dt: number) -- line: 83
					-- upvalues: u21 (ref), u22 (ref), v30 (copy), n2 (ref), u28 (ref), u27 (ref), u25 (ref), u26 (ref)
					if u21 > 1 then
						if u22 then
							v30[n2] = dt * 1000
							n2 = n2 % u21 + 1

							local n6 = 0
							local v74 = u21

							for i = 1, v74 do
								if v30[i] == nil then
									v74 = i - 1

									break
								end

								n6 += v30[i]
							end

							u28 = n6 / v74
						else
							local v76 = u21

							u28 = (u28 * (v76 - 1) + dt * 1000) / v76
						end

						u27 = math.clamp(u28, u25, u26)

						return
					end

					u27 = math.clamp(dt * 1000, u25, u26)
				end)
			elseif connection then
				connection:Disconnect()
				connection = nil
				u27 = u25
			end
		end

		if t1.numberOfLookbackFrames ~= nil then
			u21 = t1.numberOfLookbackFrames
		end

		if t1.lookbackUseRingBuffer ~= nil then
			u22 = t1.lookbackUseRingBuffer
		end
	end,
	getSchedulerFlags = function() -- line: 185
		-- upvalues: u35 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref)
		return {
			yieldInterval = u35,
			desiredFrameRate = u16,
			minimumFrameRate = u17,
			deferredWork = u18,
			heartbeatFrameMarker = u19,
			targetMsByHeartbeatDelta = u20,
			numberOfLookbackFrames = u21,
			lookbackUseRingBuffer = u22
		}
	end
}
