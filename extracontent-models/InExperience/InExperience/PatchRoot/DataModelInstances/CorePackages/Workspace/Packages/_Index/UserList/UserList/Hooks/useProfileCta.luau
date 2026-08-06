local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local SignalsReact = require(UserListParent.SignalsReact)
local ProfileCtaService = require(UserListParent.ProfileCtaService)

require(UserList.Common.Types)

local ProfileCTAService = ProfileCtaService.ProfileCTAService
local useSignalState = SignalsReact.useSignalState

local function useProfileCta(s1: string) -- line: 18
	-- upvalues: React (copy), ProfileCTAService (copy), useSignalState (copy)
	local v10 = React.useMemo(function() -- line: 19
		-- upvalues: ProfileCTAService (copy), s1 (copy)
		return ProfileCTAService.getProfileCTA(s1)
	end, { s1 })

	return useSignalState(v10.data), (useSignalState(v10.status))
end

return useProfileCta
