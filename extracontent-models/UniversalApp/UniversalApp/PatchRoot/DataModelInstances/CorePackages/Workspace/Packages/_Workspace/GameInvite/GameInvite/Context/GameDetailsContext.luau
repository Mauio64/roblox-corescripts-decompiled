local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParent.gameInviteModalType)

return (React.createContext({
	serverType = "",
	promptMessage = "",
	trigger = "",
	isCoreScript = false,
	gameDetails = {}
}))
