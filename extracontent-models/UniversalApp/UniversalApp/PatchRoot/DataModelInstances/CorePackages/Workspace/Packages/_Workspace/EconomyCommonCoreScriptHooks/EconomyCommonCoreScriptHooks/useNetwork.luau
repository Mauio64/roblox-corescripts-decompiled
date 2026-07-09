local Parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(Parent.React)
local NetworkContext = require(script.Parent.NetworkContext)

local function useNetwork() -- line: 7
	-- upvalues: React (copy), NetworkContext (copy)
	return React.useContext(NetworkContext)
end

return useNetwork
