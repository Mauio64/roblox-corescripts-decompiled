local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
require(parent.Navigation)

local v = nil

local v2 = false

local v3 = {
	dispatch = function(): boolean
		if not v2 then
			v2 = true
			print("AppNavigationRegistry: not registered. This is expected in tests that aren't testing navigation. If you *are* testing navigation, please ensure AppNavigation.lua has been required.")
		end

		return false
	end,
	getIsNavigating = function(): boolean
		return false
	end
}
local AppNavigationRegistry = {}

function AppNavigationRegistry.register(p)
	assert(v == nil, "Attempted to double-register AppNavigation")
	v = p
end

function AppNavigationRegistry.get()
	return v or v3
end

function AppNavigationRegistry.isRegistered(): boolean
	return v ~= nil
end

function AppNavigationRegistry._resetForTest()
	v = nil
end

return AppNavigationRegistry
