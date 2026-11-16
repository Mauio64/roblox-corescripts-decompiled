local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
require(parent.Configs.ConfigTypes)

return React.createContext({})
