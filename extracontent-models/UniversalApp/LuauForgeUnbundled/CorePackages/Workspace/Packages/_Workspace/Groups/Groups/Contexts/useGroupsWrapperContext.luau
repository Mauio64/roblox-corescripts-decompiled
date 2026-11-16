local GroupsWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts/GroupsWrapperContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")

return function()
	return React.useContext(GroupsWrapperContext)
end
