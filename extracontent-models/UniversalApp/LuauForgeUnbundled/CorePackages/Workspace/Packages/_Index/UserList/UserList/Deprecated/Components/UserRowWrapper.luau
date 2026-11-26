local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserProfiles")
local useEffect = React.useEffect
local userProfileStore = UserProfiles.Stores.UserProfileStore
local userPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").Enums.UserPresence
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/FriendsCommon").Hooks.useGetPresenceByUserId
local presenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration").Presence.PresenceEnums.PresenceType

local UserRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserRow")

local function UserRowWrapper(p2)
	local v5 = React.useCallback(function()
		p2.onActivated(p2.userId)
	end, { p2.onActivated, p2.userId })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	useEffect(function()
		userProfileStore.get().fetchNamesByUserIds({ (tostring(p2.userId)) }, function(p3)
			local status = p3.status
			local data = p3.data

			if status == "success" and #data > 0 and data[1] and data[1].names then
				local combinedName = data[1].names.getCombinedName(false)
				local username = data[1].names.getUsername(false)
				setState(combinedName)
				setState2(username)
			end
		end)
	end, { p2.userId })

	local v6 = useGetPresenceByUserId(p2.userId)

	local v7 = React.useMemo(function()
		local userPresenceType = v6 and v6.userPresenceType

		if
			userPresenceType == presenceType.Online
			or userPresenceType == presenceType.InStudio
			or userPresenceType == presenceType.InGame
		then
			return userPresence.Active
		end

		return userPresence.None
	end, { v6 })

	return React.createElement(UserRow, {
		userId = p2.userId,
		userPresence = v7,
		displayName = state,
		username = state2,
		onActivated = v5
	})
end

return UserRowWrapper
