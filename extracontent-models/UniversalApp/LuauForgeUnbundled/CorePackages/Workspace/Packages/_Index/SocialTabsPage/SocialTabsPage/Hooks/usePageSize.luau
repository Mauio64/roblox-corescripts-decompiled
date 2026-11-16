local useIsWideMode = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SocialCommon").Hooks.useIsWideMode

local function usePageSize(): number
	if useIsWideMode() then
		return 50
	end

	return 25
end

return usePageSize
