local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local SignalsReact = require(parent.SignalsReact)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope

local function fn(): nil
	return nil
end

local function useSduiPageScopeField(p, p2: string)
	local v

	if p and p.configKey then
		v = getSduiClientPageScope(p.configKey).getSignal(p2)
	else
		v = fn
	end

	return SignalsReact.useSignalState(v)
end

return useSduiPageScopeField
