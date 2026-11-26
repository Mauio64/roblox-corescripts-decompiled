require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Navigation")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppNavigation/Signals")

local v5 = nil

local v6 = false

local v7 = {
	dispatch = function(): boolean
		if not v6 then
			v6 = true
			print("AppNavigationRegistry: not registered. This is expected in tests that aren't testing navigation. If you *are* testing navigation, please ensure AppNavigation.lua has been required.")
		end

		return false
	end,
	getIsNavigating = function(): boolean
		return false
	end
}

return {
	register = function(p2)
		assert(v5 == nil, "Attempted to double-register AppNavigation")
		v5 = p2
	end,
	get = function()
		return v5 or v7
	end,
	isRegistered = function(): boolean
		return v5 ~= nil
	end,
	isNavigationLocked = function(p2)
		local v8 = v5 or v7
		local getIsPending = v8.getIsPending
		local v9 = v8.getIsNavigating(p2)

		if not v9 then
			v9 = not (getIsPending == nil) and getIsPending(p2)
		end

		return v9
	end,
	_resetForTest = function()
		v5 = nil
	end
}
