local UserProfiles = script:FindFirstAncestor("UserProfiles")
local UserProfilesParent = UserProfiles.Parent
local Cryo = require(UserProfilesParent.Cryo)
local React = require(UserProfilesParent.React)
local RoactUtils = require(UserProfilesParent.RoactUtils)
local setupFireDiag = require(UserProfiles.Analytics.setupFireDiag)
local EventNames = require(UserProfiles.Analytics.EventNames)
local UserProfilesAnalytics = require(UserProfiles.Analytics.UserProfilesAnalytics)
local SocialCommon = require(UserProfilesParent.SocialCommon)
local getDeepValue = require(UserProfilesParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useApolloAutoRetry = SocialCommon.Hooks.useApolloAutoRetry
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local useQuery = require(UserProfilesParent.ApolloClient).useQuery
local v15 = game:DefineFastFlag("UserProfilesEnableRetries", false)
local FFlagUserProfilesLogCancelledRequests = require(UserProfiles.Flags.FFlagUserProfilesLogCancelledRequests)
local FFlagUserProfilesLogErrorCodes = require(UserProfiles.Flags.FFlagUserProfilesLogErrorCodes)
local v18 = game:DefineFastInt("UserProfileDefaultRetryCount", 2)
local v19 = game:DefineFastFlag("UserProfilesFilterInvalidUserIds", false)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: v19 (copy), React (copy), Cryo (copy), useQuery (copy), v15 (copy), useApolloAutoRetry (copy), v18 (copy), FFlagUserProfilesLogCancelledRequests (copy), setupFireDiag (copy), UserProfilesAnalytics (copy), useEffectOnMount (copy), EventNames (copy), useEffectOnce (copy), FFlagUserProfilesLogErrorCodes (copy), getDeepValue (copy)
	local v21 = nil

	if v19 then
		v21 = React.useMemo(function() -- line: 37
			-- upvalues: Cryo (copy), t1 (copy)
			return Cryo.List.filter(t1.userIds, function(p1) -- line: 38
				return tonumber(p1) ~= nil
			end)
		end, { t1.userIds })
	end

	local v22 = if not v19 then #t1.userIds == 0 else #v21 == 0
	local v23 = useQuery(t1.query, {
		errorPolicy = "all",
		skip = v22 or t1.skip,
		variables = {
			userIds = if not v19 then t1.userIds else v21
		}
	})
	local u24 = v23

	if v15 then
		u24 = useApolloAutoRetry(v23, {
			retryCount = if not t1.overrideRetryCount then v18 else t1.overrideRetryCount
		})
	end

	local v25 = React.useRef(u24.loading or u24.isRetrying)

	if FFlagUserProfilesLogCancelledRequests then
		v25.current = u24.loading or u24.isRetrying
	end

	local v26 = React.useMemo(function() -- line: 68
		-- upvalues: setupFireDiag (copy), UserProfilesAnalytics (copy)
		return setupFireDiag({
			analytics = {
				Diag = UserProfilesAnalytics.Diag
			}
		})
	end, {})
	local v27 = React.useRef(DateTime.now())

	useEffectOnMount(function() -- line: 78
		-- upvalues: v27 (copy), v26 (copy), EventNames (copy)
		v27.current = DateTime.now()
		v26(EventNames.UserProfilesRequestBegin)
	end)

	if v15 then
		useEffectOnce(function() -- line: 84
			-- upvalues: v27 (copy), v26 (copy), EventNames (copy), UserProfilesAnalytics (copy), FFlagUserProfilesLogErrorCodes (copy), getDeepValue (copy), u24 (ref)
			if v27.current then
				local v28 = DateTime.now().UnixTimestampMillis - v27.current.UnixTimestampMillis

				v26(EventNames.UserProfilesRequestFail)
				UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailDuration, v28)

				if FFlagUserProfilesLogErrorCodes then
					local v29 = getDeepValue(u24, "error.graphQLErrors")

					if v29 then
						local v30 = v29[1] or {}
						local v31 = getDeepValue(v30, "extensions.status")

						v26(EventNames.UserProfilesErrorCode, {
							status = v31
						})
					end
				end
			end
		end, u24.error)
		useEffectOnce(function() -- line: 105
			-- upvalues: v27 (copy), u24 (ref), v26 (copy), EventNames (copy), UserProfilesAnalytics (copy), FFlagUserProfilesLogErrorCodes (copy), getDeepValue (copy)
			if v27.current then
				local v32 = DateTime.now().UnixTimestampMillis - v27.current.UnixTimestampMillis

				if u24.data and u24.retryCount == 0 then
					v26(EventNames.UserProfilesRequestSuccess)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessDuration, v32)

					return
				end

				if u24.data then
					v26(EventNames.UserProfilesRequestSuccessAfterRetry)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessAfterRetry, v32)

					return
				end

				v26(EventNames.UserProfilesRequestFailAfterRetry)
				UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailAfterRetryDuration, v32)

				if FFlagUserProfilesLogErrorCodes then
					local v33 = getDeepValue(u24, "error.graphQLErrors")

					if v33 then
						local v34 = v33[1] or {}
						local v35 = getDeepValue(v34, "extensions.status")

						v26(EventNames.UserProfilesErrorCode, {
							status = v35
						})
					end
				end
			end
		end, if not FFlagUserProfilesLogCancelledRequests then u24.loading == false and u24.isRetrying == false else not v25.current)
	end

	if FFlagUserProfilesLogCancelledRequests then
		React.useEffect(function() -- line: 148
			-- upvalues: v25 (copy), v26 (copy), EventNames (copy)
			return function() -- line: 149
				-- upvalues: v25 (copy), v26 (copy), EventNames (copy)
				if v25.current then
					v26(EventNames.UserProfilesUnmountEarly)
				end
			end
		end, {})
	end

	return u24
end
