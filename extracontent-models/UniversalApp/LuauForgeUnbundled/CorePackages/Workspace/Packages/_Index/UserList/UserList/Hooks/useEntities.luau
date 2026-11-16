local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local function useEntities(items)
	return (React.useMemo(function()
		local v5 = {}

		for k, item in items do
			v5[item.id] = item
		end

		return { entitiesMap = v5 }
	end, { items }))
end

return useEntities
