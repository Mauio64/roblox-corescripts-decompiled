local parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local Signals = require(parent.Signals)
require(parent.UniversalAppPolicy)

local function createSduiPolicyStore() -- 1 equivalent call inferred from this helper
	local signal, setAppPolicy = Signals.createSignal(nil)

	return { getAppPolicy = signal, setAppPolicy = setAppPolicy }
end

local sduiPolicyStore = nil

local function getSduiPolicyStore()
	if sduiPolicyStore == nil then
		sduiPolicyStore = createSduiPolicyStore() -- inferred equivalent call
	end

	return sduiPolicyStore
end

return getSduiPolicyStore
