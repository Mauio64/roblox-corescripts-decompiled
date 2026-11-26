local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Signals")
local AppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/AppFeaturePolicies")
local UniversalAppGetPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/UniversalAppGetPolicy")

local function createAppPolicyStore()
	local signal, v5 = Signals.createSignal(AppFeaturePolicies(UniversalAppGetPolicy.read() or {}))

	UniversalAppGetPolicy.onPolicyChanged(function(options)
		v5(AppFeaturePolicies(options or {}))
	end)

	return { getAppPolicy = signal }
end

return createAppPolicyStore
