local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
require(parent.type)

return (React.createContext({
	notificationPayload = nil,
	state = nil,
	cardSize = nil,
	handleActions = nil,
	openMetaActions = nil,
	readOnly = nil,
	cardTransparency = nil
}))
