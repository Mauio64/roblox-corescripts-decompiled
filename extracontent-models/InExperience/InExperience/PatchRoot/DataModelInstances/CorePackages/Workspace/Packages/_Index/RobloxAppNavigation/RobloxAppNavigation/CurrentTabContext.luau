local Parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local React = require(Parent.React)
local AppPage = require(Parent.RobloxAppEnums).AppPage

return React.createContext(AppPage.None)
