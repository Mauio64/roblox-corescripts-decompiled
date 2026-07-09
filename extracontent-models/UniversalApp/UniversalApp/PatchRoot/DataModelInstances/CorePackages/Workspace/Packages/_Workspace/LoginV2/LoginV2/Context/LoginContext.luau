local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local React = require(LoginV2Parent.React)

require(LoginV2.Components.Types)

return React.createContext({
	dispatch = nil,
	parentNavigation = nil,
	state = {}
})
