local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local useIsWideMode = require(Parent.SocialCommon).Hooks.useIsWideMode

local function usePageSize() -- line: 10
	-- upvalues: useIsWideMode (copy)
	if useIsWideMode() then
		return 50
	end

	return 25
end

return usePageSize
