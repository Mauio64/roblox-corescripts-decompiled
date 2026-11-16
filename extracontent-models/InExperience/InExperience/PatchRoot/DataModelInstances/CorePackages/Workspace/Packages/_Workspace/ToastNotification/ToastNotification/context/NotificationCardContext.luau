local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
require(parent.type)

return (React.createContext({
	state = nil,
	cardSize = nil,
	handleActions = nil,
	cardTransparency = nil,
	notificationReceivedTimestampMs = nil,
	timers = nil,
	displayTimestampMs = nil
}))
