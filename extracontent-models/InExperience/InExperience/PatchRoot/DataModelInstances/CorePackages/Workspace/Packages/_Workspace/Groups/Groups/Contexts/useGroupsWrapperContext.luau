local parent = script:FindFirstAncestor("Groups").Parent
local GroupsWrapperContext = require(script.Parent.GroupsWrapperContext)
local React = require(parent.React)

return function()
	return React.useContext(GroupsWrapperContext)
end
