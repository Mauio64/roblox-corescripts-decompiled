local parent = script.Parent.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)

local Object = LuauPolyfill.Object
local Shared = require(parent.Shared)
local console = Shared.console
local errorToString = Shared.errorToString
local describeError = Shared.describeError
local SafeFlags = require(parent.SafeFlags)

local function fn() -- 5 equivalent calls inferred from this helper
	return os.clock() * 1000
end

local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local v = false
local v2 = nil
local v3 = Object.None

local getFInt = SafeFlags.createGetFInt("ReactSchedulerYieldInterval2", 15)

local desiredFrameRate = SafeFlags.createGetFInt("ReactSchedulerDesiredFrameRate", 60)()

local minimumFrameRate = SafeFlags.createGetFInt("ReactSchedulerMinFrameRate", 30)()

local deferredWork = SafeFlags.createGetFFlag("ReactSchedulerEnableDeferredWork")()

local heartbeatFrameMarker = SafeFlags.createGetFFlag("ReactSchedulerSetFrameMarkerOnHeartbeatEnd")()

local targetMsByHeartbeatDelta = SafeFlags.createGetFFlag("ReactSchedulerSetTargetMsByHeartbeatDelta")()

local numberOfLookbackFrames = SafeFlags.createGetFInt("ReactSchedulerNumberOfLookbackFrames", 1)()

local lookbackUseRingBuffer = SafeFlags.createGetFFlag("ReactSchedulerLookbackUseRingBuffer")()

local v4 = false
local v5 = 0
local v6 = 1000 / desiredFrameRate
local v7 = 1000 / minimumFrameRate
local v8 = v6
local v9 = v8

local heartbeatConnection = nil
local v10

if lookbackUseRingBuffer then
	v10 = table.create(numberOfLookbackFrames)
else
	v10 = nil
end

local v11 = 1

local function resetFrameBudgets() -- 2 equivalent calls inferred from this helper
	v6 = 1000 / desiredFrameRate
	v7 = 1000 / minimumFrameRate
	v8 = v6
	v9 = v8
end

local function createHeartbeatConnection() -- 1 equivalent call inferred from this helper
	if heartbeatConnection then
		heartbeatConnection:Disconnect()
	end

	local RunService = game:GetService("RunService")
	heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
		if not (numberOfLookbackFrames > 1) then
			v8 = math.clamp(dt * 1000, v6, v7)

			return
		end

		if lookbackUseRingBuffer then
			v10[v11] = dt * 1000
			v11 = v11 % numberOfLookbackFrames + 1

			local v12 = numberOfLookbackFrames
			local total = 0

			for i = 1, v12 do
				if v10[i] == nil then
					v12 = i - 1
					break
				end

				total += v10[i]
			end

			v9 = total / v12
		else
			local v12 = numberOfLookbackFrames
			v9 = (v9 * (v12 - 1) + dt * 1000) / v12
		end

		v8 = math.clamp(v9, v6, v7)
	end)
end

if targetMsByHeartbeatDelta then
	if heartbeatConnection then
		heartbeatConnection:Disconnect()
	end

	local RunService = game:GetService("RunService")
	heartbeatConnection = RunService.Heartbeat:Connect(function(dt: number)
		if not (numberOfLookbackFrames > 1) then
			v8 = math.clamp(dt * 1000, v6, v7)

			return
		end

		if lookbackUseRingBuffer then
			v10[v11] = dt * 1000
			v11 = v11 % numberOfLookbackFrames + 1

			local v12 = numberOfLookbackFrames
			local total = 0

			for i = 1, v12 do
				if v10[i] == nil then
					v12 = i - 1
					break
				end

				total += v10[i]
			end

			v9 = total / v12
		else
			local v12 = numberOfLookbackFrames
			v9 = (v9 * (v12 - 1) + dt * 1000) / v12
		end

		v8 = math.clamp(v9, v6, v7)
	end)
end

local function setFrameMarker()
	v5 = fn() -- inferred equivalent call
end

local yieldInterval = getFInt()
local v12 = 0

local function setSchedulerFlags(data)
	if data.yieldInterval ~= nil then
		yieldInterval = data.yieldInterval
	end

	if data.desiredFrameRate ~= nil then
		desiredFrameRate = data.desiredFrameRate
		resetFrameBudgets() -- inferred equivalent call
	end

	if data.minimumFrameRate ~= nil then
		minimumFrameRate = data.minimumFrameRate
		resetFrameBudgets() -- inferred equivalent call
	end

	if data.deferredWork ~= nil then
		deferredWork = data.deferredWork
	end

	if data.heartbeatFrameMarker ~= nil then
		heartbeatFrameMarker = data.heartbeatFrameMarker
	end

	if data.targetMsByHeartbeatDelta ~= nil then
		targetMsByHeartbeatDelta = data.targetMsByHeartbeatDelta

		if data.targetMsByHeartbeatDelta then
			createHeartbeatConnection() -- inferred equivalent call
		elseif heartbeatConnection then
			heartbeatConnection:Disconnect()
			heartbeatConnection = nil
			v8 = v6
		end
	end

	if data.numberOfLookbackFrames ~= nil then
		numberOfLookbackFrames = data.numberOfLookbackFrames
	end

	if data.lookbackUseRingBuffer ~= nil then
		lookbackUseRingBuffer = data.lookbackUseRingBuffer
	end
end

local function getSchedulerFlags()
	return {
		yieldInterval = yieldInterval,
		desiredFrameRate = desiredFrameRate,
		minimumFrameRate = minimumFrameRate,
		deferredWork = deferredWork,
		heartbeatFrameMarker = heartbeatFrameMarker,
		targetMsByHeartbeatDelta = targetMsByHeartbeatDelta,
		numberOfLookbackFrames = numberOfLookbackFrames,
		lookbackUseRingBuffer = lookbackUseRingBuffer
	}
end

local function doesBudgetRemain(): boolean -- 2 equivalent calls inferred from this helper
	local v13 = fn() - v5 -- inferred equivalent call
	local v14 = v8 - v13
	return yieldInterval < v14
end

local function shouldYieldToHost(): boolean
	local v13 = fn() -- inferred equivalent call
	return v12 <= v13
end

local function forceFrameRate(p)
	if p < 0 or p > 125 then
		console.warn("forceFrameRate takes a positive int between 0 and 125, forcing frame rates higher than 125 fps is not supported")
	elseif p > 0 then
		yieldInterval = math.floor(1000 / p)
	else
		yieldInterval = 5
	end
end

local function performWorkUntilDeadline()
	if v2 == nil then
		v = false

		return
	end

	local v13 = fn() -- inferred equivalent call
	v12 = v13 + yieldInterval
	local v14 = true

	if deferredWork and not (heartbeatFrameMarker or v4) then
		v5 = v13
	end

	if heartbeatFrameMarker and v4 and not doesBudgetRemain() then -- inferred equivalent call
		v14 = false
	end

	local function doWork(): nil
		if v2(v14, v13) then
			if deferredWork then
				if doesBudgetRemain() then -- inferred equivalent call
					v4 = true
					task.defer(performWorkUntilDeadline)
				else
					v4 = false
					task.delay(0, performWorkUntilDeadline)

					if heartbeatFrameMarker then
						task.defer(setFrameMarker)
					end
				end
			else
				task.delay(0, performWorkUntilDeadline)
			end
		else
			v = false
			v2 = nil
		end

		return nil
	end

	local result, success

	if ReactGlobals.__YOLO__ then
		result = doWork()
		success = true
	else
		success, result = xpcall(doWork, describeError)
	end

	if not success then
		task.delay(0, performWorkUntilDeadline)

		if heartbeatFrameMarker then
			task.defer(setFrameMarker)
		end

		error(errorToString(result))
	end
end

local function wrapPerformWorkWithCoroutine(performWorkUntilDeadline2) -- 1 equivalent call inferred from this helper
	local thread = coroutine.create(function()
		while true do
			local success, result = pcall((coroutine.wrap(performWorkUntilDeadline2)))
			coroutine.yield(success, result)
		end
	end)

	return function()
		local _, v13, v14 = coroutine.resume(thread)

		if not v13 then
			error(v14)
		end
	end
end
performWorkUntilDeadline = wrapPerformWorkWithCoroutine(performWorkUntilDeadline) -- inferred equivalent call
local Default = {}

function Default.requestHostCallback(p)
	v2 = p

	if not v then
		v = true

		task.delay(0, performWorkUntilDeadline)

		if heartbeatFrameMarker then
			task.defer(setFrameMarker)
		end
	end
end

function Default.cancelHostCallback()
	v2 = nil
end

function Default.requestHostTimeout(callback, p)
	v3 = setTimeout(function()
		callback(fn()) -- inferred equivalent call
	end, p)
end

function Default.cancelHostTimeout()
	clearTimeout(v3)
	v3 = Object.None
end

Default.shouldYieldToHost = shouldYieldToHost

function Default.requestPaint() end

Default.getCurrentTime = fn
Default.forceFrameRate = forceFrameRate
Default.setSchedulerFlags = setSchedulerFlags
Default.getSchedulerFlags = getSchedulerFlags
return Default
