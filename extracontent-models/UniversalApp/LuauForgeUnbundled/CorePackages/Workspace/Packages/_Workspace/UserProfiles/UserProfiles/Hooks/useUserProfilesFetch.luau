local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/RoactUtils")
local setupFireDiag = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/setupFireDiag")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/EventNames")
local UserProfilesAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/UserProfilesAnalytics")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SocialCommon")

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue

local useApolloAutoRetry = SocialCommon.Hooks.useApolloAutoRetry

local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local useQuery = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/ApolloClient").useQuery

local defineFastFlag = game:DefineFastFlag("UserProfilesEnableRetries", false)
local FFlagUserProfilesLogCancelledRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Flags/FFlagUserProfilesLogCancelledRequests")
local FFlagUserProfilesLogErrorCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Flags/FFlagUserProfilesLogErrorCodes")
local defineFastInt = game:DefineFastInt("UserProfileDefaultRetryCount", 2)
local defineFastFlag2 = game:DefineFastFlag("UserProfilesFilterInvalidUserIds", false)

return function(data)
	local v5

	if defineFastFlag2 then
		v5 = React.useMemo(function()
			return Cryo.List.filter(data.userIds, function(p2): boolean
				return tonumber(p2) ~= nil
			end)
		end, { data.userIds })
	end

	local v6 = if defineFastFlag2 then #v5 == 0 else #data.userIds == 0
	local query = data.query
	local v8 = {
		errorPolicy = "all",
		skip = v6 or data.skip,
		variables = 0
	}

	if not defineFastFlag2 then
		v5 = data.userIds
	end

	v8.variables = { userIds = v5 }
	local v10 = useQuery(query, v8)

	if defineFastFlag then
		local v13 = if data.overrideRetryCount then data.overrideRetryCount else defineFastInt
		v10 = useApolloAutoRetry(v10, { retryCount = v13 })
	end

	local ref = React.useRef(v10.loading or v10.isRetrying)

	if FFlagUserProfilesLogCancelledRequests then
		ref.current = v10.loading or v10.isRetrying
	end

	local v11 = React.useMemo(function()
		return setupFireDiag({
			analytics = { Diag = UserProfilesAnalytics.Diag }
		})
	end, {})

	local ref2 = React.useRef(DateTime.now())

	useEffectOnMount(function()
		ref2.current = DateTime.now()
		v11(EventNames.UserProfilesRequestBegin)
	end)

	if defineFastFlag then
		useEffectOnce(function()
			if ref2.current then
				local v12 = DateTime.now().UnixTimestampMillis - ref2.current.UnixTimestampMillis
				v11(EventNames.UserProfilesRequestFail)
				UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailDuration, v12)

				local v13 = FFlagUserProfilesLogErrorCodes and getDeepValue(v10, "error.graphQLErrors")

				if v13 then
					local deepValue = getDeepValue(v13[1] or {}, "extensions.status")

					v11(EventNames.UserProfilesErrorCode, { status = deepValue })
				end
			end
		end, v10.error)

		local function fn()
			if ref2.current then
				local v13 = DateTime.now().UnixTimestampMillis - ref2.current.UnixTimestampMillis

				if v10.data and v10.retryCount == 0 then
					v11(EventNames.UserProfilesRequestSuccess)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessDuration, v13)
				elseif v10.data then
					v11(EventNames.UserProfilesRequestSuccessAfterRetry)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestSuccessAfterRetry, v13)
				else
					v11(EventNames.UserProfilesRequestFailAfterRetry)
					UserProfilesAnalytics.Diag:reportStats(EventNames.UserProfilesRequestFailAfterRetryDuration, v13)

					local v14 = FFlagUserProfilesLogErrorCodes and getDeepValue(v10, "error.graphQLErrors")

					if v14 then
						local deepValue = getDeepValue(v14[1] or {}, "extensions.status")

						v11(EventNames.UserProfilesErrorCode, { status = deepValue })
					end
				end
			end
		end

		local v13 = if FFlagUserProfilesLogCancelledRequests then not ref.current else v10.loading == false and v10.isRetrying == false
		useEffectOnce(fn, v13)
	end

	if FFlagUserProfilesLogCancelledRequests then
		React.useEffect(function()
			return function()
				if ref.current then
					v11(EventNames.UserProfilesUnmountEarly)
				end
			end
		end, {})
	end

	return v10
end
