local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local profileCTAService = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/ProfileCtaService").ProfileCTAService

local function useUserListCTAs(list)
	local state, setState = React.useState({})

	React.useEffect(function()
		local v5 = profileCTAService.connectRealTimeUpdates()
		return function()
			v5.Disconnect()
		end
	end, {})

	React.useEffect(function()
		if #list == 0 then
			return
		end

		setState((profileCTAService.getProfileCTAs(list)))
	end, { list })

	return state
end

return useUserListCTAs
