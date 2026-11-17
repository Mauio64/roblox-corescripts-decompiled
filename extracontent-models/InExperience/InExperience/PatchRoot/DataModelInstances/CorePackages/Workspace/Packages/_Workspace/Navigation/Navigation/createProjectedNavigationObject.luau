local parent = script.Parent.Parent
local RoactNavigation = require(parent.RoactNavigation)
local getNavigation = RoactNavigation.getNavigation
local Actions = RoactNavigation.Actions
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require(parent.SignalsExperimental)

require(script.Parent.types)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

local v = SharedFlags.FIntSignalsNavPendingLockFailsafeMs / 1000

local function createProjectedNavigationObject(p, p2)
	local onPendingFailsafeRelease

	if p2 == nil then
		onPendingFailsafeRelease = nil
	else
		onPendingFailsafeRelease = p2.onPendingFailsafeRelease
	end

	local v2 = {}
	local signal, v3 = createSignal(false)

	local signal2, v4 = createSignal(function()
		return (p.getStateForAction(Actions.init()))
	end)

	local v5 = nil
	local v6 = {}

	local signal3, v7 = createSignal(false)

	local v8 = {}

	local function markPending(p3)
		local v9 = { committed = false, pendingSince = os.clock() }
		v8[p3] = v9
		v7(true)
		task.delay(v, function()
			if v8[p3] == v9 then
				local v10 = p3

				if v10 == nil then
					table.clear(v8)

					v7(next(v8) ~= nil)
				elseif v8[v10] ~= nil then
					v8[v10] = nil

					v7(next(v8) ~= nil)
				end

				if onPendingFailsafeRelease ~= nil then
					onPendingFailsafeRelease(p3, v9.committed, v9.pendingSince)
				end
			end
		end)
	end

	local function setDispatch(callback)
		v5 = callback

		if #v6 > 0 then
			local v9 = v6
			v6 = {}

			for _, v10 in v9 do
				callback(v10)
			end
		end
	end

	local function clearDispatch()
		v5 = nil

		if FFlagSignalsNavPendingLock then
			table.clear(v8)

			v7(next(v8) ~= nil)
		end
	end

	local function dispatch(p3): boolean
		if __DEV__ and p3.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			SignalsExperimental.batch(function()
				v4((p.getStateForAction(Actions.init())))
				v3(false)

				if FFlagSignalsNavPendingLock then
					table.clear(v8)

					v7(next(v8) ~= nil)
				end
			end)
			return true
		end

		if v5 == nil then
			local v9 = signal2(false)
			local stateForAction = p.getStateForAction(p3, v9)

			if stateForAction ~= nil and stateForAction ~= v9 then
				v4(stateForAction)
			end

			table.insert(v6, p3)
			return true
		else
			if not FFlagSignalsNavPendingLock then
				v5(p3)
				return true
			end

			markPending(p3)

			local v9 = false
			task.defer(function()
				if not v9 then
					local v10 = p3

					if v10 == nil then
						table.clear(v8)

						v7(next(v8) ~= nil)
					elseif v8[v10] ~= nil then
						v8[v10] = nil

						v7(next(v8) ~= nil)
					end
				end
			end)
			v5(p3)
			v9 = true
			return true
		end
	end

	local function v9(): nil
		return nil
	end

	local getNavigation2 = createComputed(function(p3)
		return getNavigation(p, signal2(p3), dispatch, v2, function(_, p4)
			return p4
		end, function()
			return v9()
		end)
	end)

	v9 = getNavigation2
	return {
		dispatch = dispatch,
		notifyEvents = function() end,
		getState = signal2,
		getNavigation = getNavigation2,
		getIsNavigating = signal,
		getIsPending = signal3,
		update = function(p3)
			if p3 == nil then
				return
			end

			SignalsExperimental.batch(function()
				v4(p3)
				v3(p3.isTransitioning == true)
			end)
		end,
		setDispatch = setDispatch,
		clearDispatch = clearDispatch,
		clearPending = function(p3)
			if p3 == nil then
				table.clear(v8)
			elseif v8[p3] == nil then
				return
			else
				v8[p3] = nil
			end

			v7(next(v8) ~= nil)
		end,
		markPendingCommitted = function(p3)
			local v10 = v8[p3]

			if v10 ~= nil then
				v10.committed = true
			end
		end
	}
end

return createProjectedNavigationObject
