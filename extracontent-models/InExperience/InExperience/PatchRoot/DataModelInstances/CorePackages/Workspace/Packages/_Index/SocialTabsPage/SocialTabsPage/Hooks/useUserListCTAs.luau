local parent = script:FindFirstAncestor("SocialTabsPage").Parent

local React = require(parent.React)
local ProfileCtaService = require(parent.ProfileCtaService)
local ProfileCTAService = ProfileCtaService.ProfileCTAService

local function useUserListCTAs(list)
	local state, setState = React.useState({})

	React.useEffect(function()
		local v = ProfileCTAService.connectRealTimeUpdates()
		return function()
			v.Disconnect()
		end
	end, {})

	React.useEffect(function()
		if #list == 0 then
			return
		end

		setState((ProfileCTAService.getProfileCTAs(list)))
	end, { list })

	return state
end

return useUserListCTAs
