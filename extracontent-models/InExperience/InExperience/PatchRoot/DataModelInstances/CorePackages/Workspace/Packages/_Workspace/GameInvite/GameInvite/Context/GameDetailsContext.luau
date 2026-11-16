local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
require(parent.gameInviteModalType)

return (React.createContext({
	gameDetails = {},
	serverType = "",
	promptMessage = "",
	trigger = "",
	isCoreScript = false
}))
