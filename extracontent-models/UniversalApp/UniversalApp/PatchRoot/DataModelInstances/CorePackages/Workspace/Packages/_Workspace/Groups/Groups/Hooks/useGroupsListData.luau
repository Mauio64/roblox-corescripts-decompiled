local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local SignalsReact = require(GroupsParent.SignalsReact)
local createGroupsListStore = require(Groups.Stores.createGroupsListStore)

require(Groups.Common.Types)

local function useGroupsListData(s1: string?) -- line: 31
	-- upvalues: React (copy), createGroupsListStore (copy), SignalsReact (copy)
	local v8 = React.useMemo(function() -- line: 33
		-- upvalues: createGroupsListStore (copy)
		return createGroupsListStore()
	end, {})
	local v9 = SignalsReact.useSignalState(v8.getState)

	React.useEffect(function() -- line: 41
		-- upvalues: s1 (copy), v8 (copy)
		if not s1 or s1 == "" then
			v8.reset()

			return
		end

		v8.fetchGroups(s1)

		return function() -- line: 49
			-- upvalues: v8 (copy)
			v8.reset()
		end
	end, {
		v8,
		s1
	})

	return v9
end

return useGroupsListData
