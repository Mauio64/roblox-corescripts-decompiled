local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local SignalsReact = require(Parent.SignalsReact)
local getSduiClientPageScope = require(Parent.SduiCoreSystem).getSduiClientPageScope

local function v4() -- line: 7
	return nil
end
local function useSduiPageScopeField(p1, s1: string) -- line: 11
	-- upvalues: getSduiClientPageScope (copy), v4 (copy), SignalsReact (copy)
	local v8 = if not p1 or not p1.configKey then v4 else getSduiClientPageScope(p1.configKey).getSignal(s1)

	return SignalsReact.useSignalState(v8)
end

return useSduiPageScopeField
