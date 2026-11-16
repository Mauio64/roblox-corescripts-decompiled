local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SignalsReact")
local getSduiClientPageScope = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/SduiCoreSystem").getSduiClientPageScope

local function fn(): nil
	return nil
end

local function useSduiPageScopeField(p2, p3)
	local v5 = if p2 and p2.configKey then getSduiClientPageScope(p2.configKey).getSignal(p3) else fn

	return SignalsReact.useSignalState(v5)
end

return useSduiPageScopeField
