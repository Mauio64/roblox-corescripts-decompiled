local ParentParent = script.Parent.Parent
local RoactNavigation = require(ParentParent.RoactNavigation)
local getNavigation = RoactNavigation.getNavigation
local Actions = RoactNavigation.Actions
local Events = RoactNavigation.Events
local Signals = require(ParentParent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require(ParentParent.SignalsExperimental)
local FFlagSignalsNavP2NavigationPrimitives = require(ParentParent.SharedFlags).FFlagSignalsNavP2NavigationPrimitives
local v11 = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

require(script.Parent.types)

local function makeEvent(p1, p2, p3) -- line: 28
	-- upvalues: Events (copy)
	return table.freeze({
		type = Events.Action,
		action = p1,
		state = p2,
		lastState = p3
	})
end
local function createSignalsNavigationObject(p4) -- line: 37
	-- upvalues: createSignal (copy), FFlagSignalsNavP2NavigationPrimitives (copy), Actions (copy), Events (copy), v11 (copy), SignalsExperimental (copy), createComputed (copy), getNavigation (copy)
	local t1 = {}
	local t2 = {}
	local v20, v21 = createSignal(false)

	local function notifySubscribers(p5) -- line: 42
		-- upvalues: t1 (copy)
		for v29 in t1 do
			task.spawn(v29, p5)
		end
	end

	local v23, v24 = createSignal(function() -- line: 59
		-- upvalues: Actions (copy), p4 (copy), Events (copy), t2 (ref)
		local v34 = Actions.init()
		local v35 = p4.getStateForAction(v34)
		local v36 = table.freeze({
			lastState = nil,
			type = Events.Action,
			action = v34,
			state = v35
		})

		table.insert(t2, v36)

		return v35
	end)

	local function dispatch(p6) -- line: 67
		-- upvalues: v11 (copy), FFlagSignalsNavP2NavigationPrimitives (copy), v21 (copy), v24 (copy), p4 (copy), Actions (copy), v23 (copy), Events (copy), t1 (copy), t2 (ref), SignalsExperimental (copy)
		if v11 and p6.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			if FFlagSignalsNavP2NavigationPrimitives then
				v21(false)
			end

			v24((p4.getStateForAction(Actions.init())))

			return true
		end

		local v38 = v23(false)
		local v39 = p4.getStateForAction(p6, v38)
		local v40 = v39 or v38
		local v41 = table.freeze({
			type = Events.Action,
			action = p6,
			state = v40,
			lastState = v38
		})

		if v39 == nil or v40 == v38 then
			for v42 in t1 do
				task.spawn(v42, v41)
			end

			return v39 == nil
		end

		table.insert(t2, v41)

		if FFlagSignalsNavP2NavigationPrimitives then
			SignalsExperimental.batch(function() -- line: 88
				-- upvalues: v21 (copy), v24 (copy), v40 (copy)
				v21(true)
				v24(v40)
			end)
		else
			v24(v40)
		end

		return true
	end
	local function u26() -- line: 98
		return nil
	end

	local v27 = createComputed(function(p7) -- line: 102
		-- upvalues: v23 (copy), getNavigation (copy), p4 (copy), dispatch (copy), t1 (copy), u26 (ref)
		local v44 = v23(p7)

		return getNavigation(p4, v44, dispatch, t1, function(_, p9) -- line: 104
			return p9
		end, function() -- line: 106
			-- upvalues: u26 (ref)
			return u26()
		end)
	end)

	u26 = v27

	return {
		dispatch = dispatch,
		notifyEvents = function() -- line: 48
			-- upvalues: FFlagSignalsNavP2NavigationPrimitives (copy), v21 (copy), t2 (ref), t1 (copy)
			if FFlagSignalsNavP2NavigationPrimitives then
				v21(false)
			end

			local v30 = t2

			t2 = {}

			for _, v32 in v30 do
				for v33 in t1 do
					task.spawn(v33, v32)
				end
			end
		end,
		getState = v23,
		getNavigation = v27,
		getIsNavigating = v20
	}
end

return createSignalsNavigationObject
