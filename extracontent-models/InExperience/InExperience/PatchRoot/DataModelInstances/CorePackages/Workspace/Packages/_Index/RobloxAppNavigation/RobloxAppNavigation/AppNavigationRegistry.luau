local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
require(parent.Navigation)
require(parent.Signals)

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

local function get() -- 1 equivalent call inferred from this helper
	return v or v3
end

local AppNavigationRegistry = {}

function AppNavigationRegistry.register(p)
	assert(v == nil, "Attempted to double-register AppNavigation")
	v = p
end

AppNavigationRegistry.get = get

function AppNavigationRegistry.isRegistered(): boolean
	return v ~= nil
end

function AppNavigationRegistry.isNavigationLocked(p)
	local v4 = get() -- inferred equivalent call
	local getIsPending = v4.getIsPending
	local v5 = v4.getIsNavigating(p)

	if not v5 then
		if getIsPending == nil then
			return false
		end

		return (getIsPending(p))
	end

	return v5
end

function AppNavigationRegistry._resetForTest()
	v = nil
end

return AppNavigationRegistry
