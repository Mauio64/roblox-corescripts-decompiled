local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)

return React.createContext(nil)
