local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserProfiles")
local useEffect = React.useEffect
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils").Hooks.RoactRodux.useSelector
local userProfileStore = UserProfiles.Stores.UserProfileStore
local presenceType = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Rodux/RoduxPresence").Enums.PresenceType
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants").RODUX_KEY
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue
local userPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation").Enums.UserPresence
local FFlagUserListPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListPresenceStoreMigration")

local useGetPresenceByUserId = if FFlagUserListPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/FriendsCommon").Hooks.useGetPresenceByUserId else nil

local presenceType2 = if FFlagUserListPresenceStoreMigration then require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration").Presence.PresenceEnums.PresenceType else nil

local defineFastFlag = game:DefineFastFlag("UserProfileStoreDataFetchFix", false)

local UserRow = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Deprecated/Components/UserRow")

local function UserRowWrapper(p2)
	local v5 = React.useCallback(function()
		p2.onActivated(p2.userId)
	end, { p2.onActivated, p2.userId })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	useEffect(function()
		userProfileStore.get().fetchNamesByUserIds({ (tostring(p2.userId)) }, function(p3)
			if defineFastFlag then
				local status = p3.status
				local data = p3.data

				if status == "success" and #data > 0 and data[1] and data[1].names then
					local combinedName = data[1].names.getCombinedName(false)
					local username = data[1].names.getUsername(false)
					setState(combinedName)
					setState2(username)
				end
			else
				local status = p3.status
				local data = p3.data

				if status == "success" then
					local combinedName = data[1].names.getCombinedName(false)
					local username = data[1].names.getUsername(false)
					setState(combinedName)
					setState2(username)
				end
			end
		end)
	end, { p2.userId })
	local v6

	if FFlagUserListPresenceStoreMigration then
		v6 = useGetPresenceByUserId(p2.userId)
	else
		v6 = useSelector(function(p3)
			return getDeepValue(p3, string.format("%s.Presence.byUserId.%s", RODUX_KEY, p2.userId)) or {}
		end)
	end

	local v7

	if not FFlagUserListPresenceStoreMigration then
		v7 = v6.userPresenceType == presenceType.Online
			or v6.userPresenceType == presenceType.InStudio
			or v6.userPresenceType == presenceType.InGame
	end

	local v8

	if FFlagUserListPresenceStoreMigration then
		v8 = React.useMemo(function()
			local userPresenceType = v6 and v6.userPresenceType

			if
				userPresenceType == presenceType2.Online
				or userPresenceType == presenceType2.InStudio
				or userPresenceType == presenceType2.InGame
			then
				return userPresence.Active
			end

			return userPresence.None
		end, { v6 })
	else
		v8 = if v7 then userPresence.Active else userPresence.None
	end

	return React.createElement(UserRow, {
		userId = p2.userId,
		userPresence = v8,
		displayName = state,
		username = state2,
		onActivated = v5
	})
end

return UserRowWrapper
