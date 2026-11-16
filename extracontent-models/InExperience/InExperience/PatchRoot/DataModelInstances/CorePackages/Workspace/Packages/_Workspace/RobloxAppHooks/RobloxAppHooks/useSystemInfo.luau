local RobloxAppHooks = script:FindFirstAncestor("RobloxAppHooks")
local parent = RobloxAppHooks.Parent
local RoactServiceTags = require(parent.RoactServiceTags)
local AppSystemInfo = RoactServiceTags.AppSystemInfo
local useRoactService = require(RobloxAppHooks.useRoactService)

local function useSystemInfo()
	return useRoactService(AppSystemInfo)
end

return useSystemInfo
