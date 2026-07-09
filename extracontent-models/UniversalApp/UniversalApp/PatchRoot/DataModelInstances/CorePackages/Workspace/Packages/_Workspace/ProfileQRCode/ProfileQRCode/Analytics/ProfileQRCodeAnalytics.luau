local Parent = script:FindFirstAncestor("ProfileQRCode").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)

return React.createContext({
	fireEvent = Dash.noop
})
