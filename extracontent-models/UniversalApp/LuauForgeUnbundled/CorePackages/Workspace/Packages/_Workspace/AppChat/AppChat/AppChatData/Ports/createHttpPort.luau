local module = require("@luauforge/deferred/ioT")
local useSelector = require("@luauforge/deferred/ioV").Hooks.RoactRodux.useSelector
local useSignalState = require("@luauforge/deferred/ioW").useSignalState
local loginStatus = require("@luauforge/deferred/ioX").LoginStatus

local fFlagUseSignalsForAuthenticationStatus = require("@luauforge/deferred/ioY").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/deferred/ioZ").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local module2 = require("@luauforge/deferred/ipa")
local userProfileStore = module2.Stores.UserProfileStore

local function selectAuthenticationStatus(p2)
	return { authenticationStatus = p2.AuthenticationStatus.status }
end

local function usePlatformNameQueryRefetch(object)
	local v5 = useSelector(selectAuthenticationStatus)

	local v7 = (if fFlagUseSignalsForAuthenticationStatus then useSignalState(getAuthenticationStatusStore(false).getStatus) else v5.authenticationStatus) == loginStatus.LOGGED_IN
	local state, setState = module.useState({})

	local v8 = module2.Hooks.useUserProfilesFetch({
		userIds = state,
		query = module2.Queries.userProfilesDisplayUserPlatformNamesByUserIds
	})

	local v9 = module2.Hooks.useUserProfilesFetch({
		userIds = state,
		query = module2.Queries.userProfilesCombinedAndPlatformByUserIds
	})

	module.useEffect(function()
		local v10

		if v7 and object then
			v10 = object:observeEvent("UserProfileNotifications", function(p2)
				if p2.Type == "PlatformName" then
					setState({ (tostring(p2.VieweeUserId)) })
				end
			end)
		else
			v10 = nil
		end

		return function()
			if v10 and v10.disconnect then
				v10:disconnect()
			end
		end
	end, { v7, object })

	local useEffect = module.useEffect
	local function fn()
		v8.refetch({ userIds = state })

		if v9 then
			v9.refetch({ userIds = state })
		end

		userProfileStore.get().invalidateCachedNamesForUserIds(state)
	end

	local refetch = v8.refetch
	local v11 = if v9 then v9.refetch else nil
	useEffect(fn, { state, refetch, v11 })
end

return usePlatformNameQueryRefetch
