local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)

return React.createContext({
	fireEvent = Dash.noop
})
