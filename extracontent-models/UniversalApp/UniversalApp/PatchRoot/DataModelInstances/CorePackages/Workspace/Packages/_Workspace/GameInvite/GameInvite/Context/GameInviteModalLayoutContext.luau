local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)

require(ParentParent.gameInviteModalType)

return (React.createContext({
	isFullHeight = false,
	isFullWidth = false,
	modalMode = "default",
	modalSize = UDim2.new(0, 0, 0, 0)
}))
