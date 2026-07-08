local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)

require(UserList.Common.Enums)
require(UserList.Common.Types)

local function useEntities(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy)
	return (React.useMemo(function() -- line: 20
		-- upvalues: t1 (copy)
		local t2 = {}

		for _, v8 in t1 do
			t2[v8.id] = v8
		end

		return {
			entitiesMap = t2
		}
	end, { t1 }))
end

return useEntities
