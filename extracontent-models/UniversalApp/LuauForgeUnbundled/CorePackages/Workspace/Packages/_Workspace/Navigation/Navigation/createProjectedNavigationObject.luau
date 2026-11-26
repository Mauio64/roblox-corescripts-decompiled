local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation")
local getNavigation = RoactNavigation.getNavigation
local actions = RoactNavigation.Actions
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SignalsExperimental")

require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SharedFlags")
local fFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

local v5 = SharedFlags.FIntSignalsNavPendingLockFailsafeMs / 1000

local function createProjectedNavigationObject(p2, p3)
	local onPendingFailsafeRelease = if p3 ~= nil then p3.onPendingFailsafeRelease else nil

	local v6 = {}
	local signal, v7 = createSignal(false)

	local signal2, v8 = createSignal(function()
		return p2.getStateForAction(actions.init())
	end)

	local v9 = nil
	local v10 = {}

	local signal3, v11 = createSignal(false)

	local v12 = {}

	local function markPending(p4)
		local v13 = { committed = false, pendingSince = os.clock() }
		v12[p4] = v13
		v11(true)
		task.delay(v5, function()
			if v12[p4] == v13 then
				local v14 = p4

				if v14 == nil then
					table.clear(v12)

					v11(next(v12) ~= nil)
				elseif v12[v14] ~= nil then
					v12[v14] = nil

					v11(next(v12) ~= nil)
				end

				if onPendingFailsafeRelease ~= nil then
					onPendingFailsafeRelease(p4, v13.committed, v13.pendingSince)
				end
			end
		end)
	end

	local function setDispatch(callback)
		v9 = callback

		if #v10 > 0 then
			local v13 = v10
			v10 = {}

			for k, v14 in v13 do
				callback(v14)
			end
		end
	end

	local function clearDispatch()
		v9 = nil

		if fFlagSignalsNavPendingLock then
			table.clear(v12)

			v11(next(v12) ~= nil)
		end
	end

	local function dispatch(p4): boolean
		if __DEV__ and p4.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			SignalsExperimental.batch(function()
				v8(p2.getStateForAction(actions.init()))
				v7(false)

				if fFlagSignalsNavPendingLock then
					table.clear(v12)

					v11(next(v12) ~= nil)
				end
			end)
			return true
		end

		if v9 == nil then
			local v13 = signal2(false)
			local stateForAction = p2.getStateForAction(p4, v13)

			if stateForAction ~= nil and stateForAction ~= v13 then
				v8(stateForAction)
			end

			table.insert(v10, p4)
			return true
		else
			if not fFlagSignalsNavPendingLock then
				v9(p4)
				return true
			end

			markPending(p4)

			local v13 = false
			task.defer(function()
				if not v13 then
					local v14 = p4

					if v14 == nil then
						table.clear(v12)

						v11(next(v12) ~= nil)
					elseif v12[v14] ~= nil then
						v12[v14] = nil

						v11(next(v12) ~= nil)
					end
				end
			end)
			v9(p4)
			v13 = true
			return true
		end
	end

	local function v13(): nil
		return nil
	end

	local computed = createComputed(function(p4)
		return getNavigation(p2, signal2(p4), dispatch, v6, function(p5, p6)
			return p6
		end, function()
			return v13()
		end)
	end)

	v13 = computed
	return {
		dispatch = dispatch,
		notifyEvents = function() end,
		getState = signal2,
		getNavigation = computed,
		getIsNavigating = signal,
		getIsPending = signal3,
		update = function(p4)
			if p4 == nil then
				return
			end

			SignalsExperimental.batch(function()
				v8(p4)
				v7(p4.isTransitioning == true)
			end)
		end,
		setDispatch = setDispatch,
		clearDispatch = clearDispatch,
		clearPending = function(p4)
			if p4 == nil then
				table.clear(v12)
			elseif v12[p4] == nil then
				return
			else
				v12[p4] = nil
			end

			v11(next(v12) ~= nil)
		end,
		markPendingCommitted = function(p4)
			local v14 = v12[p4]

			if v14 ~= nil then
				v14.committed = true
			end
		end
	}
end

return createProjectedNavigationObject
