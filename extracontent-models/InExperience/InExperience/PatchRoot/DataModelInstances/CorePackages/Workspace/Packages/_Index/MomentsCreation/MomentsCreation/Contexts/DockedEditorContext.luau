local parent = script:FindFirstAncestor("MomentsCreation").Parent

local React = require(parent.React)

return React.createContext({
	setDockedEditorHeight = function(_: number) end
})
