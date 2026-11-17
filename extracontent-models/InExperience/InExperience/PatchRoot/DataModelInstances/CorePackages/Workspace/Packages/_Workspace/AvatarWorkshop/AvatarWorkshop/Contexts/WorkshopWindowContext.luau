local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)

return React.createContext({
	verticalLayout = false,
	onClose = function() end
})
