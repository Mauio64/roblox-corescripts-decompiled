local parent = script.Parent.Parent.Parent
local React = require(parent.React)

return React.createContext({
	isPresent = true,
	id = "",
	onExitComplete = nil,
	passThroughData = nil
})
