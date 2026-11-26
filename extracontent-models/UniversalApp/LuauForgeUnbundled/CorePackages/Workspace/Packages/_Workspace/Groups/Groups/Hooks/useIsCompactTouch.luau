local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SignalsReact")
local CommunityListRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/CommunityListRouting")

local function useIsCompactTouch()
	return SignalsReact.useSignalState(CommunityListRouting.getIsCompactTouch)
end

return useIsCompactTouch
