local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local SharedFlags = require(parent2.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile

local SocialStopwatch = require(parent2.SocialStopwatch)
local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local RoactUtils = require(parent2.RoactUtils)

local dependencies = require(parent.dependencies)
local SetAliasModal = require(script.Parent.SetAliasModal)
local Constants = require(parent.Common.Constants)

local Analytics = require(parent.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics

local LoadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local react = dependencies.React
local networkingAliases = dependencies.NetworkingAliases
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnMount = dependencies.Hooks.useEffectOnMount
local useUserProfilesFetch = dependencies.UserProfiles.Hooks.useUserProfilesFetch
local query

if FFlagUserProfilePlatformProfile then
	query = dependencies.UserProfiles.Queries.userProfilesBasicNamesByUserIds
else
	query = dependencies.UserProfiles.Queries.userProfilesAllNamesByUserIds
end

local writeNamesQuery = dependencies.UserProfiles.Mutations.writeNamesQuery
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local _ = { Moderated = "Moderated", Success = "Success" }

return function(p)
	local v = useDispatch()

	local param = p.navigation.getParam(Constants.PROFILE_USER_ID)
	local state, setState = react.useState(false)
	local v2 = useUserProfilesFetch({
		userIds = { param },
		query = query
	})

	local v3 = useAnalytics()
	local screenSize = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v4 = (getDeepValue(v2, "data.userProfiles") or {})[1] or {}

	local deepValue = getDeepValue(v4, "names.alias")
	local deepValue2 = getDeepValue(v4, "names.displayName")

	useEffectOnMount(function()
		if v3 then
			v3.fireAnalyticsEvent(EventNames.CustomizeNameModalOpened)
		end
	end)

	react.useEffect(function()
		local v5 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)
		v3.fireAnalyticsEvent(EventNames.CustomizeNameLoadingStage, {
			status = LoadingStages.Fetching,
			statValue = v5 and v5.timeElapsed
		})

		return function()
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CustomizeNameOpened)
		end
	end, {})

	useEffectOnce(function()
		local v5 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)
		local fireAnalyticsEvent = v3.fireAnalyticsEvent
		local customizeNameLoadingStage = EventNames.CustomizeNameLoadingStage
		local status

		if v2.data then
			status = LoadingStages.Done
		else
			status = LoadingStages.Failed
		end

		fireAnalyticsEvent(customizeNameLoadingStage, {
			status = status,
			statValue = v5 and v5.timeElapsed
		})
	end, v2.data or v2.error)

	local function fn(alias: string)
		return v(networkingAliases.SetUserTag.API(param, alias)):andThen(function(p2)
			if getDeepValue(p2, "responseBody.status") == "Moderated" then
				setState(true)

				if v3 then
					v3.fireAnalyticsEvent(EventNames.CustomizeNameSaveAttemptInvalidInput, {
						alias = alias
					})
				end
			else
				if v3 then
					v3.fireAnalyticsEvent(EventNames.CustomizeNameSaved, { alias = alias })
				end

				writeNamesQuery({
					client = v2.client,
					query = query,
					userId = param,
					names = {
						alias = alias,
						contactName = getDeepValue(v4, "names.contactName"),
						displayName = getDeepValue(v4, "names.displayName"),
						username = getDeepValue(v4, "names.username")
					}
				})
				p.navigation.pop()
			end
		end)
	end

	return react.createElement(SetAliasModal, {
		screenSize = screenSize,
		alias = deepValue,
		displayName = deepValue2,
		cancelOnActivated = function()
			p.navigation.pop()
		end,
		saveOnActivated = fn,
		hasSaveAliasError = state,
		onTextChanged = function()
			if state then
				setState(false)
			end
		end,
		isLoading = v2.loading
	})
end
