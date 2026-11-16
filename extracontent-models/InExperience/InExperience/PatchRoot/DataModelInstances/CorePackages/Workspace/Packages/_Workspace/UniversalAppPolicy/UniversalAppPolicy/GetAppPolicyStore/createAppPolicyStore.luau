local UniversalAppPolicy = script:FindFirstAncestor("UniversalAppPolicy")
local parent = UniversalAppPolicy.Parent

local Signals = require(parent.Signals)
local AppFeaturePolicies = require(UniversalAppPolicy.AppFeaturePolicies)
local UniversalAppGetPolicy = require(UniversalAppPolicy.UniversalAppGetPolicy)

local function createAppPolicyStore()
	local signal, v = Signals.createSignal(AppFeaturePolicies(UniversalAppGetPolicy.read() or {}))

	UniversalAppGetPolicy.onPolicyChanged(function(options)
		v(AppFeaturePolicies(options or {}))
	end)

	return { getAppPolicy = signal }
end

return createAppPolicyStore
