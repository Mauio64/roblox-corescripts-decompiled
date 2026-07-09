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
local v12 = game:DefineFastFlag("UserProfileStoreDataFetchFix", false)
local UserRow = require(script.Parent.UserRow)

local function UserRowWrapper(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), useEffect (copy), UserProfileStore (copy), v12 (copy), useSelector (copy), getDeepValue (copy), RODUX_KEY (copy), PresenceType (copy), UserPresence (copy), UserRow (copy)
	local v16 = React.useCallback(function() -- line: 28
		-- upvalues: t1 (copy)
		t1.onActivated(t1.userId)
	end, {
		t1.onActivated,
		t1.userId
	})
	local v17, v18 = React.useState("")
	local v19, v20 = React.useState("")

	useEffect(function() -- line: 35
		-- upvalues: UserProfileStore (copy), t1 (copy), v12 (copy), v18 (copy), v20 (copy)
		UserProfileStore.get().fetchNamesByUserIds({ (tostring(t1.userId)) }, function(p1) -- line: 36
			-- upvalues: v12 (copy), v18 (copy), v20 (copy)
			if v12 then
				local status = p1.status
				local data = p1.data

				if status == "success" and #data > 0 and data[1] and data[1].names then
					local v27 = data[1].names.getCombinedName(false)
					local v28 = data[1].names.getUsername(false)

					v18(v27)
					v20(v28)

					return
				end
			else
				local status = p1.status
				local data = p1.data

				if status == "success" then
					local v31 = data[1].names.getCombinedName(false)
					local v32 = data[1].names.getUsername(false)

					v18(v31)
					v20(v32)
				end
			end
		end)
	end, { t1.userId })

	local v21 = useSelector(function(p2) -- line: 57
		-- upvalues: getDeepValue (copy), RODUX_KEY (copy), t1 (copy)
		return getDeepValue(p2, string.format("%s.Presence.byUserId.%s", RODUX_KEY, t1.userId)) or {}
	end)
	local v22 = if not (v21.userPresenceType == PresenceType.Online or (v21.userPresenceType == PresenceType.InStudio or v21.userPresenceType == PresenceType.InGame)) then UserPresence.None else UserPresence.Active

	return React.createElement(UserRow, {
		userId = t1.userId,
		userPresence = v22,
		displayName = v17,
		username = v19,
		onActivated = v16
	})
end

return UserRowWrapper
