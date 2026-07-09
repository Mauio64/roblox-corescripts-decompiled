local Parent = script:FindFirstAncestor("QueryRefetch").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local LoginStatus = require(Parent.RobloxAppEnums).LoginStatus
local UserProfiles = require(Parent.UserProfiles)
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local FFlagUserProfileStoreQueryRefetch = require(Parent.SharedFlags).FFlagUserProfileStoreQueryRefetch

local function selectAuthenticationStatus(p1) -- line: 12
	return {
		authenticationStatus = p1.AuthenticationStatus.status
	}
end
local function usePlatformNameQueryRefetch(p2) -- line: 20
	-- upvalues: useSelector (copy), selectAuthenticationStatus (copy), LoginStatus (copy), React (copy), UserProfiles (copy), FFlagUserProfileStoreQueryRefetch (copy), UserProfileStore (copy)
	local v12 = useSelector(selectAuthenticationStatus).authenticationStatus == LoginStatus.LOGGED_IN
	local v13, v14 = React.useState({})
	local v15 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v13,
		query = UserProfiles.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})
	local v16 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v13,
		query = UserProfiles.Queries.userProfilesCombinedAndPlatformByUserIds
	})

	React.useEffect(function() -- line: 37
		-- upvalues: v12 (copy), p2 (copy), v14 (copy)
		local u17 = nil

		if v12 and p2 then
			u17 = p2:observeEvent("UserProfileNotifications", function(p3) -- line: 40
				-- upvalues: v14 (copy)
				if p3.Type == "PlatformName" then
					v14({ (tostring(p3.VieweeUserId)) })
				end
			end)
		end

		return function() -- line: 47
			-- upvalues: u17 (ref)
			if u17 and u17.disconnect then
				u17:disconnect()
			end
		end
	end, {
		v12,
		p2
	})
	React.useEffect(function() -- line: 55
		-- upvalues: v15 (copy), v13 (copy), v16 (copy), FFlagUserProfileStoreQueryRefetch (copy), UserProfileStore (copy)
		v15.refetch({
			userIds = v13
		})

		if v16 then
			v16.refetch({
				userIds = v13
			})
		end

		if FFlagUserProfileStoreQueryRefetch then
			UserProfileStore.get().invalidateCachedNamesForUserIds(v13)
		end
	end, {
		v13,
		v15.refetch,
		if not v16 then nil else v16.refetch
	})
end

return usePlatformNameQueryRefetch
