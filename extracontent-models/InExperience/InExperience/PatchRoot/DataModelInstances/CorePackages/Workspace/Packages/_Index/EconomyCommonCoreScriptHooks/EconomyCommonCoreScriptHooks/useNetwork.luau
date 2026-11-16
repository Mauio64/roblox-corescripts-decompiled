local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)

local NetworkContext = require(script.Parent.NetworkContext)

local function useNetwork()
	return React.useContext(NetworkContext)
end

return useNetwork
