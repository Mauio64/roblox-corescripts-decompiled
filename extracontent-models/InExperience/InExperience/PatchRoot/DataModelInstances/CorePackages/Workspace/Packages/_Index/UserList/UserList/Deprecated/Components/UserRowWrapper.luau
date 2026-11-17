local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local useEffect = React.useEffect
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local Foundation = require(parent.Foundation)
local UserPresence = Foundation.Enums.UserPresence
local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
local DataHydration = require(parent.DataHydration)
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType

local UserRow = require(script.Parent.UserRow)

local function UserRowWrapper(p)
	local onActivated = React.useCallback(function()
		p.onActivated(p.userId)
	end, { p.onActivated, p.userId })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	useEffect(function()
		UserProfileStore.get().fetchNamesByUserIds({ (tostring(p.userId)) }, function(p2)
			local status = p2.status
			local data = p2.data

			if status == "success" and #data > 0 and data[1] and data[1].names then
				local combinedName = data[1].names.getCombinedName(false)
				local username = data[1].names.getUsername(false)
				setState(combinedName)
				setState2(username)
			end
		end)
	end, { p.userId })

	local v = useGetPresenceByUserId(p.userId)

	local userPresence = React.useMemo(function()
		local userPresenceType = v and v.userPresenceType

		if
			userPresenceType == PresenceType.Online
			or userPresenceType == PresenceType.InStudio
			or userPresenceType == PresenceType.InGame
		then
			return UserPresence.Active
		end

		return UserPresence.None
	end, { v })

	return React.createElement(UserRow, {
		userId = p.userId,
		userPresence = userPresence,
		displayName = state,
		username = state2,
		onActivated = onActivated
	})
end

return UserRowWrapper
