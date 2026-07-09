local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParent.type)

return (React.createContext({
	notificationPayload = nil,
	state = nil,
	cardSize = nil,
	handleActions = nil,
	openMetaActions = nil,
	readOnly = nil,
	cardTransparency = nil
}))
