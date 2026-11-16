local parent = script:FindFirstAncestor("SignalsUtils").Parent
local Signals = require(parent.Signals)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local getCurrentUserId = LocalUserIdStore.LocalUserIdStore.getCurrentUserId

local function createSessionScopedSignal(p, p2)
	local computed = Signals.createComputed(function(p3)
		getCurrentUserId(p3)
		local signal, setter = Signals.createSignal(p, p2)
		return { getter = signal, setter = setter }
	end)

	local function getter(p3)
		return computed(p3).getter(p3)
	end

	local function setter(p3)
		computed().setter(p3)
	end
	return getter, setter
end

return createSessionScopedSignal
