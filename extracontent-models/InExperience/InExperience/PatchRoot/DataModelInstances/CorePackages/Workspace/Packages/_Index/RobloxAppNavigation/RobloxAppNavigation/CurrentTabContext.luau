local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

return React.createContext(AppPage.None)
