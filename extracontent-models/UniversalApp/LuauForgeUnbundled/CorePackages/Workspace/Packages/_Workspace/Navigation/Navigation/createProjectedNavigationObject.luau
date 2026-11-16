local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation")
local getNavigation = RoactNavigation.getNavigation
local actions = RoactNavigation.Actions
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SignalsExperimental")

require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

local function createProjectedNavigationObject(p2)
	local v5 = {}
	local signal, v6 = createSignal(false)

	local signal2, v7 = createSignal(function()
		return p2.getStateForAction(actions.init())
	end)

	local v8 = nil
	local v9 = {}

	local function setDispatch(callback)
		v8 = callback

		if #v9 > 0 then
			local v10 = v9
			v9 = {}

			for k, v11 in v10 do
				callback(v11)
			end
		end
	end

	local function clearDispatch()
		v8 = nil
	end

	local function dispatch(p3): boolean
		if __DEV__ and p3.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			SignalsExperimental.batch(function()
				v7(p2.getStateForAction(actions.init()))
				v6(false)
			end)
			return true
		end

		if v8 ~= nil then
			v8(p3)
			return true
		end

		local v10 = signal2(false)
		local stateForAction = p2.getStateForAction(p3, v10)

		if stateForAction ~= nil and stateForAction ~= v10 then
			v7(stateForAction)
		end

		table.insert(v9, p3)
		return true
	end

	local function v10(): nil
		return nil
	end

	local computed = createComputed(function(p3)
		return getNavigation(p2, signal2(p3), dispatch, v5, function(p4, p5)
			return p5
		end, function()
			return v10()
		end)
	end)

	v10 = computed
	return {
		dispatch = dispatch,
		notifyEvents = function() end,
		getState = signal2,
		getNavigation = computed,
		getIsNavigating = signal,
		update = function(p3)
			if p3 == nil then
				return
			end

			SignalsExperimental.batch(function()
				v7(p3)
				v6(p3.isTransitioning == true)
			end)
		end,
		setDispatch = setDispatch,
		clearDispatch = clearDispatch
	}
end

return createProjectedNavigationObject
