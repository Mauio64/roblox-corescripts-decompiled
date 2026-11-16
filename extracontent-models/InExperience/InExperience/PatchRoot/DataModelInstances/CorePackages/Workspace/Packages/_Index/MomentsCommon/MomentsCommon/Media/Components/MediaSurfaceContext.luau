local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)

local frozen = table.freeze({})

return React.createContext(frozen)
