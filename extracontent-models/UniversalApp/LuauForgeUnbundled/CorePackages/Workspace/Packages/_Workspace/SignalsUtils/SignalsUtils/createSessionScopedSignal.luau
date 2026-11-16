local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsUtils/Signals")
local getCurrentUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SignalsUtils/LocalUserIdStore").LocalUserIdStore.getCurrentUserId

local function createSessionScopedSignal(p2, p3)
	local computed = Signals.createComputed(function(p4)
		getCurrentUserId(p4)
		local signal, v5 = Signals.createSignal(p2, p3)
		return { getter = signal, setter = v5 }
	end)

	local function getter(p4)
		return computed(p4).getter(p4)
	end

	local function setter(p4)
		computed().setter(p4)
	end
	return getter, setter
end

return createSessionScopedSignal
