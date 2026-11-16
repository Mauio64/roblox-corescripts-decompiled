require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useProfileNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileNames")

local function useProfileName(p2)
	local v6 = useProfileNames((React.useMemo(function()
		if p2 then
			return { p2 }
		end

		return {}
	end, { p2 })))

	return React.useMemo(function()
		local v7 = if p2 then v6.namesByUserId[p2] else nil
		local v8 = { status = v6.status, combinedName = 0, username = 0 }
		local v9 = if v7 then v7.combinedName else nil
		v8.combinedName = v9
		local v10 = if v7 then v7.username else nil
		v8.username = v10
		return v8
	end, { v6, p2 })
end

return useProfileName
