local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParent.type)

return (React.createContext({
	state = nil,
	cardSize = nil,
	handleActions = nil,
	cardTransparency = nil,
	notificationReceivedTimestampMs = nil,
	timers = nil,
	displayTimestampMs = nil
}))
