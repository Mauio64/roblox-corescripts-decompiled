local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
require(parent.AppCommonLib)

return (React.createContext(nil))
