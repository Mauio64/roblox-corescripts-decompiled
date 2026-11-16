local CorePackages = game:GetService("CorePackages")

local SignalsReact = require(CorePackages.Packages.SignalsReact)

local GetPlaytestModeStore = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon.GetPlaytestModeStore)

local function useIsPlaytestMode()
	local playtestModeStore = GetPlaytestModeStore(false)

	return SignalsReact.useSignalState(playtestModeStore.getIsPlaytestMode)
end

return useIsPlaytestMode
