local UserProfiles = script:FindFirstAncestor("UserProfiles")
local parent = UserProfiles.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local setupFireDiag = require(UserProfiles.Analytics.setupFireDiag)
local EventNames = require(UserProfiles.Analytics.EventNames)
local UserProfilesAnalytics = require(UserProfiles.Analytics.UserProfilesAnalytics)
local SocialCommon = require(parent.SocialCommon)

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local useApolloAutoRetry = SocialCommon.Hooks.useApolloAutoRetry

local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local ApolloClient = require(parent.ApolloClient)
local useQuery = ApolloClient.useQuery

local defineFastFlag = game:DefineFastFlag("UserProfilesEnableRetries", false)
local FFlagUserProfilesLogCancelledRequests = require(UserProfiles.Flags.FFlagUserProfilesLogCancelledRequests)
local FFlagUserProfilesLogErrorCodes = require(UserProfiles.Flags.FFlagUserProfilesLogErrorCodes)
local defineFastInt = game:DefineFastInt("UserProfileDefaultRetryCount", 2)
local defineFastFlag2 = game:DefineFastFlag("UserProfilesFilterInvalidUserIds", false)

return function(data)
	local userIds

	if defineFastFlag2 then
		userIds = React.useMemo(function()
			return Cryo.List.filter(data.userIds, function(p): boolean
				return tonumber(p) ~= nil
			end)
		end, { data.userIds })
	end

	local v

	if defineFastFlag2 then
		v = #userIds == 0
	else
		v = #data.userIds == 0
	end

	local query = data.query
	local v2 = {
		errorPolicy = "all",
		skip = v or data.skip,
		variables = 0
	}

	if not defineFastFlag2 then
		userIds = data.userIds
	end

	v2.variables = { userIds = userIds }
	local v3 = useQuery(query, v2)

	if defineFastFlag then
		local retryCount

		if data.overrideRetryCount then
			retryCount = data.overrideRetryCount
		else
			retryCount = defineFastInt
		end

		v3 = useApolloAutoRetry(v3, { retryCount = retryCount })
	end

	local ref = React.useRef(v3.loading or v3.isRetrying)

	if FFlagUserProfilesLogCancelledRequests then
		ref.current = v3.loading or v3.isRetrying
	end

	local v4 = React.useMemo(function()
		return setupFireDiag({
			analytics = { Diag = UserProfilesAnalytics.Diag }
		})
	end, {})

	local ref2 = React.useRef(DateTime.now())

	useEffectOnMount(function()
		ref2.current = DateTime.now()
		v4(EventNames.UserProfilesRequestBegin)
	end)

	if defineFastFlag then
		useEffectOnce(function()
			if ref2.current then
				local v5 = DateTime.now().UnixTimestampMillis - ref2.current.UnixTimestampMillis
				v4(EventNames.UserProfilesRequestFail)
				UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailDuration, v5)

				local v6 = FFlagUserProfilesLogErrorCodes and getDeepValue(v3, "error.graphQLErrors")

				if v6 then
					local deepValue = getDeepValue(v6[1] or {}, "extensions.status")

					v4(EventNames.UserProfilesErrorCode, { status = deepValue })
				end
			end
		end, v3.error)

		local function fn()
			if ref2.current then
				local v5 = DateTime.now().UnixTimestampMillis - ref2.current.UnixTimestampMillis

				if v3.data and v3.retryCount == 0 then
					v4(EventNames.UserProfilesRequestSuccess)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessDuration, v5)
				elseif v3.data then
					v4(EventNames.UserProfilesRequestSuccessAfterRetry)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessAfterRetry, v5)
				else
					v4(EventNames.UserProfilesRequestFailAfterRetry)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailAfterRetryDuration, v5)

					local v6 = FFlagUserProfilesLogErrorCodes and getDeepValue(v3, "error.graphQLErrors")

					if v6 then
						local deepValue = getDeepValue(v6[1] or {}, "extensions.status")

						v4(EventNames.UserProfilesErrorCode, { status = deepValue })
					end
				end
			end
		end

		local v5

		if FFlagUserProfilesLogCancelledRequests then
			v5 = not ref.current
		elseif v3.loading == false then
			v5 = v3.isRetrying == false
		else
			v5 = false
		end

		useEffectOnce(fn, v5)
	end

	if FFlagUserProfilesLogCancelledRequests then
		React.useEffect(function()
			return function()
				if ref.current then
					v4(EventNames.UserProfilesUnmountEarly)
				end
			end
		end, {})
	end

	return v3
end
