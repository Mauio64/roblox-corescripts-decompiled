require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local SupportedProfileTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/SupportedProfileTypes")

return function(p2)
	return SupportedProfileTypes[p2] or {}
end
