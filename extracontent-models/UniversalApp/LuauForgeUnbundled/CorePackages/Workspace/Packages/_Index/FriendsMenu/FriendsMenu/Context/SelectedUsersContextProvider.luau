local SelectedUsersContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContext")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Cryo")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/UserProfiles")

return function(props)
	local v5 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = props.preselectedUsers or {},
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v6 = React.useCallback(function(items)
		local v7 = ""
		local result = {}

		for k, item in pairs(items) do
			if v5.data then
				v7 = UserProfiles.Selectors.getCombinedNameFromId(v5.data, item)
			end

			result[item] = {
				displayName = v7,
				layoutOrder = #result + 1,
				unremovable = props.preselectedUsersUnremovable
			}
		end

		return result
	end, nil)

	local ref = React.useRef(props.preselectedUsers and #props.preselectedUsers or 0)

	local state, setState = React.useState(not props.preselectedUsers and {} or v6(props.preselectedUsers))

	local state2, setState2 = React.useState(props.preselectedUsers and #props.preselectedUsers or 0)

	local v7 = React.useCallback(function(p2, p3)
		if props.selectionLimit == nil or state2 < props.selectionLimit then
			setState(Cryo.Dictionary.join(state, {
				[p2] = { displayName = p3, layoutOrder = ref.current }
			}))

			ref.current += 1
			setState2(state2 + 1)
		end
	end, { state })

	local v8 = React.useCallback(function(p2, p3)
		setState(Cryo.Dictionary.join(state, { [p2] = Cryo.None }))
		setState2(state2 - 1)

		if props.onRemoveCallback then
			props.onRemoveCallback(p2, p3)
		end
	end, { state })

	local v9 = React.useCallback(function(p2): boolean
		return state[p2] ~= nil
	end, { state })

	return React.createElement(SelectedUsersContext.Provider, {
		value = React.useMemo(function()
			return {
				selectedFriendsSize = state2,
				selectedFriends = state,
				addFriend = v7,
				removeFriend = v8,
				isFriendSelected = v9,
				preselectedUsers = props.preselectedUsers
			}
		end, { state, v7, v8, v9 })
	}, props.children)
end
