local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local createGroupsListStore = require(Groups.Stores.createGroupsListStore)
require(Groups.Common.Types)

local function useGroupsListData(p: string?)
	local v = React.useMemo(function()
		return createGroupsListStore()
	end, {})

	local v2 = SignalsReact.useSignalState(v.getState)

	React.useEffect(function()
		if p and p ~= "" then
			v.fetchGroups(p)

			return function()
				v.reset()
			end
		end

		v.reset()
	end, { v, p })

	return v2
end

return useGroupsListData
