local parent = script.Parent
local parent2 = parent.Parent.Parent

local SelectedUsersContext = require(parent.SelectedUsersContext)

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local UserProfiles = require(parent2.UserProfiles)

return function(props)
	local v = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = props.preselectedUsers or {},
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v2 = React.useCallback(function(items)
		local displayName = ""
		local result = {}

		for _, item in pairs(items) do
			if v.data then
				displayName = UserProfiles.Selectors.getCombinedNameFromId(v.data, item)
			end

			result[item] = {
				displayName = displayName,
				layoutOrder = #result + 1,
				unremovable = props.preselectedUsersUnremovable
			}
		end

		return result
	end, nil)

	local ref = React.useRef(props.preselectedUsers and #props.preselectedUsers or 0)

	local state, setState = React.useState(not props.preselectedUsers and {} or v2(props.preselectedUsers))

	local state2, setState2 = React.useState(props.preselectedUsers and #props.preselectedUsers or 0)

	local addFriend = React.useCallback(function(p, displayName)
		if props.selectionLimit == nil or state2 < props.selectionLimit then
			setState(Cryo.Dictionary.join(state, {
				[p] = { displayName = displayName, layoutOrder = ref.current }
			}))

			ref.current += 1
			setState2(state2 + 1)
		end
	end, { state })

	local removeFriend = React.useCallback(function(p, p2)
		setState(Cryo.Dictionary.join(state, { [p] = Cryo.None }))
		setState2(state2 - 1)

		if props.onRemoveCallback then
			props.onRemoveCallback(p, p2)
		end
	end, { state })

	local isFriendSelected = React.useCallback(function(p): boolean
		return state[p] ~= nil
	end, { state })

	return React.createElement(SelectedUsersContext.Provider, {
		value = React.useMemo(function()
			return {
				selectedFriendsSize = state2,
				selectedFriends = state,
				addFriend = addFriend,
				removeFriend = removeFriend,
				isFriendSelected = isFriendSelected,
				preselectedUsers = props.preselectedUsers
			}
		end, { state, addFriend, removeFriend, isFriendSelected })
	}, props.children)
end
