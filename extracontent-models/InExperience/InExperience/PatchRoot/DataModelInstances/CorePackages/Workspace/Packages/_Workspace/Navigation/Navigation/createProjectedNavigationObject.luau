local ParentParent = script.Parent.Parent
local RoactNavigation = require(ParentParent.RoactNavigation)
local getNavigation = RoactNavigation.getNavigation
local Actions = RoactNavigation.Actions
local Signals = require(ParentParent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local SignalsExperimental = require(ParentParent.SignalsExperimental)

require(script.Parent.types)

local v9 = _G.__DEV__ or _G.__TESTEZ_RUNNING_TEST__

local function createProjectedNavigationObject(p1) -- line: 44
	-- upvalues: createSignal (copy), Actions (copy), SignalsExperimental (copy), v9 (copy), createComputed (copy), getNavigation (copy)
	local t1 = {}
	local v13, v14 = createSignal(false)
	local v15, v16 = createSignal(function() -- line: 52
		-- upvalues: p1 (copy), Actions (copy)
		return (p1.getStateForAction(Actions.init()))
	end)
	local u17 = nil
	local t2 = {}

	local function dispatch(p2) -- line: 94
		-- upvalues: v9 (copy), SignalsExperimental (copy), v16 (copy), p1 (copy), Actions (copy), v14 (copy), u17 (ref), v15 (copy), t2 (ref)
		if v9 and p2.type == "RESET_NAVIGATION_FOR_TESTING_ONLY__DO_NOT_USE_IN_PRODUCTION" then
			SignalsExperimental.batch(function() -- line: 96
				-- upvalues: v16 (copy), p1 (copy), Actions (copy), v14 (copy)
				v16((p1.getStateForAction(Actions.init())))
				v14(false)
			end)

			return true
		end

		if u17 == nil then
			local v28 = v15(false)
			local v29 = p1.getStateForAction(p2, v28)

			if v29 ~= nil and v29 ~= v28 then
				v16(v29)
			end

			table.insert(t2, p2)

			return true
		end

		u17(p2)

		return true
	end
	local function u20() -- line: 123
		return nil
	end

	local v21 = createComputed(function(p3) -- line: 126
		-- upvalues: v15 (copy), getNavigation (copy), p1 (copy), dispatch (copy), t1 (copy), u20 (ref)
		local v31 = v15(p3)

		return getNavigation(p1, v31, dispatch, t1, function(_, p5) -- line: 128
			return p5
		end, function() -- line: 130
			-- upvalues: u20 (ref)
			return u20()
		end)
	end)

	u20 = v21

	return {
		dispatch = dispatch,
		notifyEvents = function() -- line: 118
		end,
		getState = v15,
		getNavigation = v21,
		getIsNavigating = v13,
		update = function(p6) -- line: 79
			-- upvalues: SignalsExperimental (copy), v16 (copy), v14 (copy)
			if p6 == nil then
				return
			end

			SignalsExperimental.batch(function() -- line: 83
				-- upvalues: v16 (copy), p6 (copy), v14 (copy)
				v16(p6)
				v14(p6.isTransitioning == true)
			end)
		end,
		setDispatch = function(p7: ((...any) -> ...any)) -- line: 61
			-- upvalues: u17 (ref), t2 (ref)
			u17 = p7

			if #t2 > 0 then
				local v23 = t2

				t2 = {}

				for _, v25 in v23 do
					p7(v25)
				end
			end
		end,
		clearDispatch = function() -- line: 72
			-- upvalues: u17 (ref)
			u17 = nil
		end
	}
end

return createProjectedNavigationObject
