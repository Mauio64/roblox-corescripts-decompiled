local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ProfileCtaService = require(parent.ProfileCtaService)
require(UserList.Common.Types)

local ProfileCTAService = ProfileCtaService.ProfileCTAService
local useSignalState = SignalsReact.useSignalState

local function useProfileCta(p: string)
	local v = React.useMemo(function()
		return ProfileCTAService.getProfileCTA(p)
	end, { p })

	return useSignalState(v.data), (useSignalState(v.status))
end

return useProfileCta
