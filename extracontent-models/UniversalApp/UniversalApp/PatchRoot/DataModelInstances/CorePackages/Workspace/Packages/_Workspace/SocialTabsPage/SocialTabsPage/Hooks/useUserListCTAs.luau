local Parent = script:FindFirstAncestor("SocialTabsPage").Parent
local React = require(Parent.React)
local ProfileCTAService = require(Parent.ProfileCtaService).ProfileCTAService

local function useUserListCTAs(t1: {[any]: any}) -- line: 8
	-- upvalues: React (copy), ProfileCTAService (copy)
	local v6, v7 = React.useState({})

	React.useEffect(function() -- line: 11
		-- upvalues: ProfileCTAService (copy)
		local v8 = ProfileCTAService.connectRealTimeUpdates()

		return function() -- line: 13
			-- upvalues: v8 (copy)
			v8.Disconnect()
		end
	end, {})
	React.useEffect(function() -- line: 18
		-- upvalues: t1 (copy), ProfileCTAService (copy), v7 (copy)
		if #t1 == 0 then
			return
		end

		local v9 = ProfileCTAService.getProfileCTAs(t1)

		v7(v9)
	end, { t1 })

	return v6
end

return useUserListCTAs
