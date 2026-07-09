local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local SelectedUsersContext = require(scriptParent.SelectedUsersContext)
local React = require(ParentParent.React)
local Cryo = require(ParentParent.Cryo)
local UserProfiles = require(ParentParent.UserProfiles)

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: UserProfiles (copy), React (copy), Cryo (copy), SelectedUsersContext (copy)
	local v8 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = t1.preselectedUsers or {},
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local v9 = React.useCallback(function(p1) -- line: 25
		-- upvalues: v8 (copy), UserProfiles (copy), t1 (copy)
		local t2 = {}
		local s1 = ""

		for _, v in pairs(p1) do
			if v8.data then
				s1 = UserProfiles.Selectors.getCombinedNameFromId(v8.data, v)
			end

			t2[v] = {
				displayName = s1,
				layoutOrder = #t2 + 1,
				unremovable = t1.preselectedUsersUnremovable
			}
		end

		return t2
	end, nil)
	local v10 = React.useRef(not t1.preselectedUsers and 0 or #t1.preselectedUsers)
	local v11, v12 = React.useState(if not t1.preselectedUsers then {} else v9(t1.preselectedUsers))
	local v13, v14 = React.useState(not t1.preselectedUsers and 0 or #t1.preselectedUsers)
	local v15 = React.useCallback(function(p2, p3) -- line: 49
		-- upvalues: t1 (copy), v13 (copy), v12 (copy), Cryo (copy), v11 (copy), v10 (copy), v14 (copy)
		if t1.selectionLimit == nil or v13 < t1.selectionLimit then
			v12(Cryo.Dictionary.join(v11, {
				[p2] = {
					displayName = p3,
					layoutOrder = v10.current
				}
			}))
			v10.current = v10.current + 1
			v14(v13 + 1)
		end
	end, { v11 })
	local v16 = React.useCallback(function(p4, p5) -- line: 63
		-- upvalues: v12 (copy), Cryo (copy), v11 (copy), v14 (copy), v13 (copy), t1 (copy)
		v12(Cryo.Dictionary.join(v11, {
			[p4] = Cryo.None
		}))
		v14(v13 - 1)

		if t1.onRemoveCallback then
			t1.onRemoveCallback(p4, p5)
		end
	end, { v11 })
	local v17 = React.useCallback(function(p6) -- line: 71
		-- upvalues: v11 (copy)
		return v11[p6] ~= nil
	end, { v11 })

	return React.createElement(SelectedUsersContext.Provider, {
		value = React.useMemo(function() -- line: 76
			-- upvalues: v13 (copy), v11 (copy), v15 (copy), v16 (copy), v17 (copy), t1 (copy)
			return {
				selectedFriendsSize = v13,
				selectedFriends = v11,
				addFriend = v15,
				removeFriend = v16,
				isFriendSelected = v17,
				preselectedUsers = t1.preselectedUsers
			}
		end, {
			v11,
			v15,
			v16,
			v17
		})
	}, t1.children)
end
