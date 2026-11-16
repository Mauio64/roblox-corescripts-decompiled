local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
require(parent.gameInviteModalType)

return (React.createContext({
	isFullHeight = false,
	isFullWidth = false,
	modalSize = UDim2.new(0, 0, 0, 0),
	modalMode = "default"
}))
