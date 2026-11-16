local ProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileWrapperContext")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

return function()
	return React.useContext(ProfileWrapperContext)
end
