local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SignalsReact")
local ProfileCtaService = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/ProfileCtaService")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local profileCTAService = ProfileCtaService.ProfileCTAService
local useSignalState = SignalsReact.useSignalState

local function useProfileCta(p2)
	local v5 = React.useMemo(function()
		return profileCTAService.getProfileCTA(p2)
	end, { p2 })

	return useSignalState(v5.data), (useSignalState(v5.status))
end

return useProfileCta
