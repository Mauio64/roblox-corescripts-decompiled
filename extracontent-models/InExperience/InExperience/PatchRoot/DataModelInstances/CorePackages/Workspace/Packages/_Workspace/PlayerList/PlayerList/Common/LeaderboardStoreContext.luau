local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.LeaderboardStore)

return (React.createContext(nil))
