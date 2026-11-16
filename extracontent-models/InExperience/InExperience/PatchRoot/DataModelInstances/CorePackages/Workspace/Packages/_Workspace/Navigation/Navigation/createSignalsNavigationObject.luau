local parent = script.Parent.Parent
local RoactNavigation = require(parent.RoactNavigation)
local getNavigation = RoactNavigation.getNavigation
local Actions = RoactNavigation.Actions
local Events = RoactNavigation.Events
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local SignalsExperimental = require(parent.SignalsExperimental)

local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP2NavigationPrimitives = SharedFlags.FFlagSignalsNavP2NavigationPrimitives

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

require(script.Parent.types)

local function makeEvent(action, state, lastState) -- 2 equivalent calls inferred from this helper
	return table.freeze({
		type = Events.Action,
		action = action,
		state = state,
		lastState = lastState
	})
end

local function createSignalsNavigationObject(p)
	local v = {}
	local events = {}
	local signal, v2 = createSignal(false)

	local function notifySubscribers(p2) -- 2 equivalent calls inferred from this helper
		for callback in v do
			task.spawn(callback, p2)
		end
	end

	local function notifyEvents()
		if FFlagSignalsNavP2NavigationPrimitives then
			v2(false)
		end

		local v3 = events
		events = {}

		for _, v4 in v3 do
			notifySubscribers(v4) -- inferred equivalent call
		end
	end

	local signal2, v3 = createSignal(function()
		local v3 = Actions.init()
		local stateForAction = p.getStateForAction(v3)
		local event = makeEvent(v3, stateForAction) -- inferred equivalent call
		table.insert(events, event)
		return stateForAction
	end)

	local function dispatch(action): boolean
		if __DEV__ and action.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			if FFlagSignalsNavP2NavigationPrimitives then
				v2(false)
			end

			v3((p.getStateForAction(Actions.init())))
			return true
		else
			local lastState = signal2(false)
			local stateForAction = p.getStateForAction(action, lastState)
			local state = stateForAction or lastState
			local event = makeEvent(action, state, lastState) -- inferred equivalent call

			if stateForAction == nil or state == lastState then
				notifySubscribers(event) -- inferred equivalent call
				return stateForAction == nil
			end

			table.insert(events, event)

			if FFlagSignalsNavP2NavigationPrimitives then
				SignalsExperimental.batch(function()
					v2(true)
					v3(state)
				end)
			else
				v3(state)
			end

			return true
		end
	end

	local function v4(): nil
		return nil
	end

	local getNavigation2 = createComputed(function(p2)
		return getNavigation(p, signal2(p2), dispatch, v, function(_, p3)
			return p3
		end, function()
			return v4()
		end)
	end)

	v4 = getNavigation2

	return {
		dispatch = dispatch,
		notifyEvents = notifyEvents,
		getState = signal2,
		getNavigation = getNavigation2,
		getIsNavigating = signal
	}
end

return createSignalsNavigationObject
