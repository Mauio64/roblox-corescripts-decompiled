local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local UserProfiles = require(UserListParent.UserProfiles)
local useEffect = React.useEffect
local useSelector = require(UserListParent.RoactUtils).Hooks.RoactRodux.useSelector
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local PresenceType = require(UserList.Rodux.RoduxPresence).Enums.PresenceType
local RODUX_KEY = require(UserList.Common.Constants).RODUX_KEY
local getDeepValue = require(UserListParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local UserPresence = require(UserListParent.Foundation).Enums.UserPresence
local FFlagUserListPresenceStoreMigration = require(UserList.Flags.FFlagUserListPresenceStoreMigration)
local v13 = if not FFlagUserListPresenceStoreMigration then nil else require(UserListParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v14 = if not FFlagUserListPresenceStoreMigration then nil else require(UserListParent.DataHydration).Presence.PresenceEnums.PresenceType
local v15 = game:DefineFastFlag("UserProfileStoreDataFetchFix", false)
local UserRow = require(script.Parent.UserRow)

local function UserRowWrapper(t1: {[any]: any}) -- line: 34
	-- upvalues: React (copy), useEffect (copy), UserProfileStore (copy), v15 (copy), FFlagUserListPresenceStoreMigration (copy), v13 (copy), useSelector (copy), getDeepValue (copy), RODUX_KEY (copy), PresenceType (copy), v14 (copy), UserPresence (copy), UserRow (copy)
	local v19 = React.useCallback(function() -- line: 35
		-- upvalues: t1 (copy)
		t1.onActivated(t1.userId)
	end, {
		t1.onActivated,
		t1.userId
	})
	local v20, v21 = React.useState("")
	local v22, v23 = React.useState("")

	useEffect(function() -- line: 42
		-- upvalues: UserProfileStore (copy), t1 (copy), v15 (copy), v21 (copy), v23 (copy)
		UserProfileStore.get().fetchNamesByUserIds({ (tostring(t1.userId)) }, function(p1) -- line: 43
			-- upvalues: v15 (copy), v21 (copy), v23 (copy)
			if v15 then
				local status = p1.status
				local data = p1.data

				if status == "success" and #data > 0 and data[1] and data[1].names then
					local v32 = data[1].names.getCombinedName(false)
					local v33 = data[1].names.getUsername(false)

					v21(v32)
					v23(v33)

					return
				end
			else
				local status = p1.status
				local data = p1.data

				if status == "success" then
					local v36 = data[1].names.getCombinedName(false)
					local v37 = data[1].names.getUsername(false)

					v21(v36)
					v23(v37)
				end
			end
		end)
	end, { t1.userId })

	local v24 = if not FFlagUserListPresenceStoreMigration then useSelector(function(p2) -- line: 66
		-- upvalues: getDeepValue (copy), RODUX_KEY (copy), t1 (copy)
		return getDeepValue(p2, string.format("%s.Presence.byUserId.%s", RODUX_KEY, t1.userId)) or {}
	end) else v13(t1.userId)
	local v25 = if not FFlagUserListPresenceStoreMigration then v24.userPresenceType == PresenceType.Online or (v24.userPresenceType == PresenceType.InStudio or v24.userPresenceType == PresenceType.InGame) else nil
	local v26 = if not FFlagUserListPresenceStoreMigration then if not v25 then UserPresence.None else UserPresence.Active else React.useMemo(function() -- line: 79
		-- upvalues: v24 (copy), v14 (copy), UserPresence (copy)
		local v28 = v24 and v24.userPresenceType

		if v28 == v14.Online or (v28 == v14.InStudio or v28 == v14.InGame) then
			return UserPresence.Active
		end

		return UserPresence.None
	end, { v24 })

	return React.createElement(UserRow, {
		userId = t1.userId,
		userPresence = v26,
		displayName = v20,
		username = v22,
		onActivated = v19
	})
end

return UserRowWrapper
