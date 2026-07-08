local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)

require(script.Parent.createAnimatedVisibilityStore)

return (React.createContext(nil))
