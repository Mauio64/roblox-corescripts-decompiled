local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

require(Parent.Navigation)

local u2 = nil
local u3 = false
local t1 = {
	dispatch = function() -- line: 17
		-- upvalues: u3 (ref)
		if not u3 then
			u3 = true
			print("AppNavigationRegistry: not registered. This is expected in tests that aren't testing navigation. If you *are* testing navigation, please ensure AppNavigation.lua has been required.")
		end

		return false
	end,
	getIsNavigating = function() -- line: 24
		return false
	end
}

return {
	register = function(p1) -- line: 29
		-- upvalues: u2 (ref)
		assert(u2 == nil, "Attempted to double-register AppNavigation")
		u2 = p1
	end,
	get = function() -- line: 34
		-- upvalues: u2 (ref), t1 (copy)
		return u2 or t1
	end,
	isRegistered = function() -- line: 41
		-- upvalues: u2 (ref)
		return u2 ~= nil
	end,
	_resetForTest = function() -- line: 45
		-- upvalues: u2 (ref)
		u2 = nil
	end
}
