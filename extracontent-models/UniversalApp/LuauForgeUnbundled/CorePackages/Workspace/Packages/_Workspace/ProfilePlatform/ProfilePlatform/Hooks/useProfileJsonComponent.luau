require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local module = require("@luauforge/bundled/feH")
local useProfileJson = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJson")

return function(p2)
	return module(useProfileJson(), `components.{p2}`) or {}
end
