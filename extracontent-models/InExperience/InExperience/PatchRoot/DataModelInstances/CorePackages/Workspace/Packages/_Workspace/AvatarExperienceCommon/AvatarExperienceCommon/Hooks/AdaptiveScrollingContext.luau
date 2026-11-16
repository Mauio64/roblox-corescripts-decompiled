local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
require(parent.AppCommonLib)

return (React.createContext(nil))
