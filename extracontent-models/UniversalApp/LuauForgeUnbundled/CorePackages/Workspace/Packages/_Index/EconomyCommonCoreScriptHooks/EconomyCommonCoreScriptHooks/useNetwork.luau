local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/React")

local NetworkContext = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/NetworkContext")

local function useNetwork()
	return React.useContext(NetworkContext)
end

return useNetwork
