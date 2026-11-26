local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/UniversalAppPolicy")

local function createSduiPolicyStore()
	local signal, v5 = Signals.createSignal(nil)

	return { getAppPolicy = signal, setAppPolicy = v5 }
end

local sduiPolicyStore = nil

local function getSduiPolicyStore()
	if sduiPolicyStore == nil then
		local signal, v5 = Signals.createSignal(nil)

		sduiPolicyStore = { getAppPolicy = signal, setAppPolicy = v5 }
	end

	return sduiPolicyStore
end

return getSduiPolicyStore
