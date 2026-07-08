local RobloxAppHooks = script:FindFirstAncestor("RobloxAppHooks")
local RobloxAppHooksParent = RobloxAppHooks.Parent
local AppSystemInfo = require(RobloxAppHooksParent.RoactServiceTags).AppSystemInfo
local useRoactService = require(RobloxAppHooks.useRoactService)

local function useSystemInfo() -- line: 6
	-- upvalues: useRoactService (copy), AppSystemInfo (copy)
	return useRoactService(AppSystemInfo)
end

return useSystemInfo
