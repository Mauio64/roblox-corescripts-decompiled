local CorePackages = game:GetService("CorePackages")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local GetPlaytestModeStore = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon.GetPlaytestModeStore)

local function useIsPlaytestMode() -- line: 7
	-- upvalues: GetPlaytestModeStore (copy), SignalsReact (copy)
	local v5 = GetPlaytestModeStore(false)

	return SignalsReact.useSignalState(v5.getIsPlaytestMode)
end

return useIsPlaytestMode
