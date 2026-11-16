local parent = script.Parent.Parent
local RoactNavigation = require(parent.RoactNavigation)
local getNavigation = RoactNavigation.getNavigation
local Actions = RoactNavigation.Actions
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require(parent.SignalsExperimental)

require(script.Parent.types)

local __DEV__ = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

local function createProjectedNavigationObject(p)
	local v = {}
	local signal, v2 = createSignal(false)

	local signal2, v3 = createSignal(function()
		return (p.getStateForAction(Actions.init()))
	end)

	local v4 = nil
	local v5 = {}

	local function setDispatch(callback)
		v4 = callback

		if #v5 > 0 then
			local v6 = v5
			v5 = {}

			for _, v7 in v6 do
				callback(v7)
			end
		end
	end

	local function clearDispatch()
		v4 = nil
	end

	local function dispatch(p2): boolean
		if __DEV__ and p2.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			SignalsExperimental.batch(function()
				v3((p.getStateForAction(Actions.init())))
				v2(false)
			end)
			return true
		end

		if v4 ~= nil then
			v4(p2)
			return true
		end

		local v6 = signal2(false)
		local stateForAction = p.getStateForAction(p2, v6)

		if stateForAction ~= nil and stateForAction ~= v6 then
			v3(stateForAction)
		end

		table.insert(v5, p2)
		return true
	end

	local function v6(): nil
		return nil
	end

	local getNavigation2 = createComputed(function(p2)
		return getNavigation(p, signal2(p2), dispatch, v, function(_, p3)
			return p3
		end, function()
			return v6()
		end)
	end)

	v6 = getNavigation2
	return {
		dispatch = dispatch,
		notifyEvents = function() end,
		getState = signal2,
		getNavigation = getNavigation2,
		getIsNavigating = signal,
		update = function(p2)
			if p2 == nil then
				return
			end

			SignalsExperimental.batch(function()
				v3(p2)
				v2(p2.isTransitioning == true)
			end)
		end,
		setDispatch = setDispatch,
		clearDispatch = clearDispatch
	}
end

return createProjectedNavigationObject
