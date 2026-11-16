local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation")
local getNavigation = RoactNavigation.getNavigation
local actions = RoactNavigation.Actions
local events = RoactNavigation.Events
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Signals")
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SignalsExperimental")

local fFlagSignalsNavP2NavigationPrimitives = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/SharedFlags").FFlagSignalsNavP2NavigationPrimitives

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local function makeEvent(p2, p3, p4)
	return table.freeze({
		type = events.Action,
		action = p2,
		state = p3,
		lastState = p4
	})
end

local function createSignalsNavigationObject(p2)
	local v5 = {}
	local values = {}
	local signal, v6 = createSignal(false)

	local function notifySubscribers(p3)
		for callback in v5 do
			task.spawn(callback, p3)
		end
	end

	local function notifyEvents()
		if fFlagSignalsNavP2NavigationPrimitives then
			v6(false)
		end

		local v7 = values
		values = {}

		for k, v8 in v7 do
			for callback in v5 do
				task.spawn(callback, v8)
			end
		end
	end

	local signal2, v7 = createSignal(function()
		local v8 = actions.init()
		local stateForAction = p2.getStateForAction(v8)
		local frozen = table.freeze({
			type = events.Action,
			action = v8,
			state = stateForAction,
			lastState = nil
		})

		table.insert(values, frozen)
		return stateForAction
	end)

	local function dispatch(p3): boolean
		if __DEV__ and p3.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			if fFlagSignalsNavP2NavigationPrimitives then
				v6(false)
			end

			v7(p2.getStateForAction(actions.init()))
			return true
		else
			local v8 = signal2(false)
			local stateForAction = p2.getStateForAction(p3, v8)
			local v9 = stateForAction or v8
			local frozen = table.freeze({
				type = events.Action,
				action = p3,
				state = v9,
				lastState = v8
			})

			if stateForAction == nil or v9 == v8 then
				for callback in v5 do
					task.spawn(callback, frozen)
				end

				return stateForAction == nil
			end

			table.insert(values, frozen)

			if fFlagSignalsNavP2NavigationPrimitives then
				SignalsExperimental.batch(function()
					v6(true)
					v7(v9)
				end)
			else
				v7(v9)
			end

			return true
		end
	end

	local function v8(): nil
		return nil
	end

	local computed = createComputed(function(p3)
		return getNavigation(p2, signal2(p3), dispatch, v5, function(p4, p5)
			return p5
		end, function()
			return v8()
		end)
	end)

	v8 = computed

	return {
		dispatch = dispatch,
		notifyEvents = notifyEvents,
		getState = signal2,
		getNavigation = computed,
		getIsNavigating = signal
	}
end

return createSignalsNavigationObject
