local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SignalsReact")

local createGroupsListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Stores/createGroupsListStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/Types")

local function useGroupsListData(p2)
	local v5 = React.useMemo(function()
		return createGroupsListStore()
	end, {})

	local v6 = SignalsReact.useSignalState(v5.getState)

	React.useEffect(function()
		if p2 and p2 ~= "" then
			v5.fetchGroups(p2)

			return function()
				v5.reset()
			end
		end

		v5.reset()
	end, { v5, p2 })

	return v6
end

return useGroupsListData
