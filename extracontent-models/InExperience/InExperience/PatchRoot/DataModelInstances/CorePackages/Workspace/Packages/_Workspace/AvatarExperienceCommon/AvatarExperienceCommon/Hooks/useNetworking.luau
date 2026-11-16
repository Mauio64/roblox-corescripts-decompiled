local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking

local function useNetworking()
	return useRoactService(RoactNetworking)
end

return useNetworking
