local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local SocialCommon = require(parent.SocialCommon)
local useIsWideMode = SocialCommon.Hooks.useIsWideMode

local function usePageSize(): number
	return if useIsWideMode() then 50 else 25
end

return usePageSize
