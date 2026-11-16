local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local UserProfiles = require(parent.UserProfiles)
local useEffect = React.useEffect
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local RoduxPresence = require(UserList.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local Constants = require(UserList.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local Foundation = require(parent.Foundation)
local UserPresence = Foundation.Enums.UserPresence
local FFlagUserListPresenceStoreMigration = require(UserList.Flags.FFlagUserListPresenceStoreMigration)
local useGetPresenceByUserId

if FFlagUserListPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType

if FFlagUserListPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local defineFastFlag = game:DefineFastFlag("UserProfileStoreDataFetchFix", false)

local UserRow = require(script.Parent.UserRow)

local function UserRowWrapper(p)
	local onActivated = React.useCallback(function()
		p.onActivated(p.userId)
	end, { p.onActivated, p.userId })

	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")

	useEffect(function()
		UserProfileStore.get().fetchNamesByUserIds({ (tostring(p.userId)) }, function(p2)
			if defineFastFlag then
				local status = p2.status
				local data = p2.data

				if status == "success" and #data > 0 and data[1] and data[1].names then
					local combinedName = data[1].names.getCombinedName(false)
					local username = data[1].names.getUsername(false)
					setState(combinedName)
					setState2(username)
				end
			else
				local status = p2.status
				local data = p2.data

				if status == "success" then
					local combinedName = data[1].names.getCombinedName(false)
					local username = data[1].names.getUsername(false)
					setState(combinedName)
					setState2(username)
				end
			end
		end)
	end, { p.userId })
	local v

	if FFlagUserListPresenceStoreMigration then
		v = useGetPresenceByUserId(p.userId)
	else
		v = useSelector(function(p2)
			return getDeepValue(p2, string.format("%s.Presence.byUserId.%s", RODUX_KEY, p.userId)) or {}
		end)
	end

	local v2

	if not FFlagUserListPresenceStoreMigration then
		v2 = v.userPresenceType == PresenceType.Online
			or v.userPresenceType == PresenceType.InStudio
			or v.userPresenceType == PresenceType.InGame
	end

	local userPresence

	if FFlagUserListPresenceStoreMigration then
		userPresence = React.useMemo(function()
			local userPresenceType = v and v.userPresenceType

			if
				userPresenceType == presenceType.Online
				or userPresenceType == presenceType.InStudio
				or userPresenceType == presenceType.InGame
			then
				return UserPresence.Active
			end

			return UserPresence.None
		end, { v })
	elseif v2 then
		userPresence = UserPresence.Active
	else
		userPresence = UserPresence.None
	end

	return React.createElement(UserRow, {
		userId = p.userId,
		userPresence = userPresence,
		displayName = state,
		username = state2,
		onActivated = onActivated
	})
end

return UserRowWrapper
