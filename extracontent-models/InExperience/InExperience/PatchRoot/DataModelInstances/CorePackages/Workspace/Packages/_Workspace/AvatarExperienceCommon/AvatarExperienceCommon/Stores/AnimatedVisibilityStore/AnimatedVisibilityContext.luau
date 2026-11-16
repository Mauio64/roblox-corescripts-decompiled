local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)

require(script.Parent.createAnimatedVisibilityStore)

return (React.createContext(nil))
