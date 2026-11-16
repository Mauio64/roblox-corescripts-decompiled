local parent = script.Parent.Parent
local SignalsScheduler = require(parent.SignalsScheduler)
local flush = SignalsScheduler.flush
local schedule = SignalsScheduler.schedule

local callUserSpace = require(script.Parent.callUserSpace)

local frozen = table.freeze({ __mode = "k" })
local function createWeakSet(p) -- 2 equivalent calls inferred from this helper
	return (setmetatable(p, frozen))
end

local function defaultEquals(p, p2): boolean
	return p == p2
end

local function handleError(flag: boolean, ...)
	if not flag then
		local v = ...
		error(v)
	end
end

local function handleScopeValidation(kill, flag: boolean, ...)
	kill()
	handleError(flag, ...)
	return ...
end

local function callUserSpaceWithScopeValidation(callback, callback2)
	local v = true

	local function wrappedScope(callback3)
		if not v then
			error("attempted to use scope beyond scope's lifetime")
		end

		return callback2(callback3)
	end

	local function kill()
		v = false
	end

	return handleScopeValidation(kill, pcall(callUserSpace, callback, wrappedScope))
end

if not (_G.__SIGNALS_VALIDATION_ENABLED__ or _G.__DEV__) then
	callUserSpaceWithScopeValidation = callUserSpace
end

local Signals = {}

function Signals.createSignal(callback, callback2)
	local v = false
	local v2 = 0

	local v3 = nil
	local v4 = nil

	if callback2 == nil then
		callback2 = defaultEquals
	end

	local function ensureInitialized()
		if not v then
			v = true
			local v5

			if typeof(callback) == "function" then
				v5 = callUserSpace(callback)
			else
				v5 = callback
			end

			v3 = v5
			v2 = os.clock()
			v4 = createWeakSet({}) -- inferred equivalent call
		end
	end

	local function source(callback3, flag: boolean?)
		if callback3 == nil then
			return v2
		end

		if flag then
			v4[callback3] = nil
		else
			v4[callback3] = true
		end

		return 0
	end

	local function connectToScope(callback3) -- 1 equivalent call inferred from this helper
		if callback3 then
			local v5 = callback3(source)
			v4[v5] = true
		end
	end

	local function notifyObservers() -- 1 equivalent call inferred from this helper
		for k in v4 do
			k()
		end

		table.clear(v4)
	end

	local function getter(callback3)
		ensureInitialized()
		connectToScope(callback3) -- inferred equivalent call
		return v3
	end

	local function setter(callback3)
		ensureInitialized()

		if typeof(callback3) == "function" then
			callback3 = callUserSpace(callback3, v3)
		end

		if not callUserSpace(callback2, v3, callback3) then
			v3 = callback3
			v2 = os.clock()
			notifyObservers() -- inferred equivalent call
			flush()
		end
	end

	return getter, setter
end

function Signals.createComputed(callback, callback2)
	local v = false
	local flag = false
	local v2 = 0
	local v3 = 0

	local v4 = nil
	local set = nil
	local v5 = nil

	if callback2 == nil then
		callback2 = defaultEquals
	end

	local function notifyObservers() -- 1 equivalent call inferred from this helper
		for k in v5 do
			k()
		end

		table.clear(v5)
	end

	local function observer()
		if not flag then
			flag = true
			notifyObservers() -- inferred equivalent call
		end
	end

	local function scope(callback3)
		set[callback3] = true
		return observer
	end

	local function ensureInitialized()
		if not v then
			v = true
			v5 = createWeakSet({}) -- inferred equivalent call
			set = {}
			v4 = callUserSpaceWithScopeValidation(callback, scope)
			v3 = os.clock()
			v2 = v3
		end
	end

	local function disconnectSources() -- 1 equivalent call inferred from this helper
		for k in set do
			k(observer, true)
		end

		table.clear(set)
	end

	local function flushNotifications()
		if flag then
			flag = false

			for k in set do
				local v6 = k()

				if v3 < v6 then
					disconnectSources() -- inferred equivalent call
					local v7 = callUserSpaceWithScopeValidation(callback, scope)
					v3 = os.clock()

					if not callUserSpace(callback2, v4, v7) then
						v4 = v7
						v2 = v3
					end

					return
				end
			end

			for k in set do
				k(observer)
			end
		end
	end

	local function source(callback3, flag2: boolean?)
		if callback3 == nil then
			flushNotifications()
			return v2
		end

		if flag2 then
			v5[callback3] = nil
		else
			v5[callback3] = true
		end

		return 0
	end

	local function connectToScope(callback3) -- 1 equivalent call inferred from this helper
		if callback3 then
			local v6 = callback3(source)
			v5[v6] = true
		end
	end

	local function getter(callback3)
		ensureInitialized()
		flushNotifications()
		connectToScope(callback3) -- inferred equivalent call
		return v4
	end

	return getter
end

function Signals.createEffect(callback)
	local v = false
	local v2 = false
	local v3 = 0

	local set = {}

	local observer

	local function disconnectSources() -- 2 equivalent calls inferred from this helper
		for k in set do
			k(observer, true)
		end

		table.clear(set)
	end

	local function dispose()
		v2 = true
		disconnectSources() -- inferred equivalent call
	end

	local function scope(callback2)
		set[callback2] = true
		return observer
	end

	local function processNotification()
		if not v2 then
			v = false

			for k in set do
				local v4 = k()

				if v3 < v4 then
					disconnectSources() -- inferred equivalent call
					callUserSpaceWithScopeValidation(callback, scope)
					v3 = os.clock()
					return
				end
			end

			for k in set do
				k(observer)
			end
		end
	end

	observer = function()
		if not (v2 or v) then
			v = true
			schedule(processNotification)
		end
	end

	callUserSpaceWithScopeValidation(callback, scope)
	v3 = os.clock()

	return dispose
end

return Signals
