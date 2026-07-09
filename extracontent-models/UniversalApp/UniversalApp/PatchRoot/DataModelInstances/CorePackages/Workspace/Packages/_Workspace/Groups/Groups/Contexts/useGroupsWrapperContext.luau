local Parent = script:FindFirstAncestor("Groups").Parent
local GroupsWrapperContext = require(script.Parent.GroupsWrapperContext)
local React = require(Parent.React)

return function() -- line: 6
	-- upvalues: React (copy), GroupsWrapperContext (copy)
	return React.useContext(GroupsWrapperContext)
end
