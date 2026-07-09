local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local React = require(UserActivationFrameworkParent.React)

require(UserActivationFramework.Types)

return React.createContext({
	dispatch = nil,
	navigation = nil,
	activationFrameworkState = {}
})
