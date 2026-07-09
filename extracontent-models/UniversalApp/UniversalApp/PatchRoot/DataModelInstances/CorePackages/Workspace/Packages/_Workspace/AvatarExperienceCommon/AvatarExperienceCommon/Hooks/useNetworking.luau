local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local RoactNetworking = require(Parent.RoactServiceTags).RoactNetworking

local function useNetworking() -- line: 8
	-- upvalues: useRoactService (copy), RoactNetworking (copy)
	return useRoactService(RoactNetworking)
end

return useNetworking
