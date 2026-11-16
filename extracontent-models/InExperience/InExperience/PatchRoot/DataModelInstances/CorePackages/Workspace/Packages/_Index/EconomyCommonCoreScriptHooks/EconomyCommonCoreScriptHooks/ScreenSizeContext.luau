local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)

return React.createContext(Vector2.new(0, 0))
