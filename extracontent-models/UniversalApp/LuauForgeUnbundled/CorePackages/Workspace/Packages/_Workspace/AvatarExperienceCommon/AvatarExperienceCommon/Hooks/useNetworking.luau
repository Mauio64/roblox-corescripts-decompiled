local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/RoactServiceTags").RoactNetworking

local function useNetworking()
	return useRoactService(roactNetworking)
end

return useNetworking
