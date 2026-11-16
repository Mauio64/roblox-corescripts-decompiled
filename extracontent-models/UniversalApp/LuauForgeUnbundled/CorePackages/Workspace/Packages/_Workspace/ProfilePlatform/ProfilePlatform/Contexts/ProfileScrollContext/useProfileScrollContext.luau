local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local ProfileScrollContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileScrollContext/ProfileScrollContext")

return function()
	return React.useContext(ProfileScrollContext)
end
