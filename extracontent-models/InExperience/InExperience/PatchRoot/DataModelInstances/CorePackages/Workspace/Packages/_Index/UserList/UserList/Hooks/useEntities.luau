local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
require(UserList.Common.Enums)
require(UserList.Common.Types)

local function useEntities(items)
	return (React.useMemo(function()
		local entitiesMap = {}

		for _, item in items do
			entitiesMap[item.id] = item
		end

		return { entitiesMap = entitiesMap }
	end, { items }))
end

return useEntities
