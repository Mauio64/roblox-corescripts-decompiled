local appSystemInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactServiceTags").AppSystemInfo
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RobloxAppHooks/useRoactService")

local function useSystemInfo()
	return useRoactService(appSystemInfo)
end

return useSystemInfo
