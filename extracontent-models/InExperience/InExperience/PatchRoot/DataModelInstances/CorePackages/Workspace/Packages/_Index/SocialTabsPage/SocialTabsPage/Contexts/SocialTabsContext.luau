local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)

return React.createContext(nil)
