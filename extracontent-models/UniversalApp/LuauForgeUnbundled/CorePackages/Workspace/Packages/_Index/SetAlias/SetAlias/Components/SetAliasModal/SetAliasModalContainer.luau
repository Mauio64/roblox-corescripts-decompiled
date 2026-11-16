local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SharedFlags").FFlagUserProfilePlatformProfile

local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialStopwatch")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialLuaAnalytics")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactUtils")

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")
local SetAliasModal = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Components/SetAliasModal/SetAliasModal")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Common/Constants")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics")
local eventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics

local loadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local react = dependencies.React
local networkingAliases = dependencies.NetworkingAliases
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnMount = dependencies.Hooks.useEffectOnMount
local useUserProfilesFetch = dependencies.UserProfiles.Hooks.useUserProfilesFetch
local v5

if fFlagUserProfilePlatformProfile then
	v5 = dependencies.UserProfiles.Queries.userProfilesBasicNamesByUserIds
else
	v5 = dependencies.UserProfiles.Queries.userProfilesAllNamesByUserIds
end

local writeNamesQuery = dependencies.UserProfiles.Mutations.writeNamesQuery
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local v6 = { Moderated = "Moderated", Success = "Success" }

return function(p2)
	local v7 = useDispatch()

	local param = p2.navigation.getParam(Constants.PROFILE_USER_ID)
	local state, setState = react.useState(false)
	local v8 = useUserProfilesFetch({
		userIds = { param },
		query = v5
	})

	local v9 = useAnalytics()
	local v10 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local v11 = (getDeepValue(v8, "data.userProfiles") or {})[1] or {}

	local deepValue = getDeepValue(v11, "names.alias")
	local deepValue2 = getDeepValue(v11, "names.displayName")

	useEffectOnMount(function()
		if v9 then
			v9.fireAnalyticsEvent(eventNames.CustomizeNameModalOpened)
		end
	end)

	react.useEffect(function()
		local v12 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)
		v9.fireAnalyticsEvent(eventNames.CustomizeNameLoadingStage, {
			status = loadingStages.Fetching,
			statValue = v12 and v12.timeElapsed
		})

		return function()
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CustomizeNameOpened)
		end
	end, {})

	useEffectOnce(function()
		local v12 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)
		local fireAnalyticsEvent = v9.fireAnalyticsEvent
		local customizeNameLoadingStage = eventNames.CustomizeNameLoadingStage
		local v14 = if v8.data then loadingStages.Done else loadingStages.Failed
		fireAnalyticsEvent(customizeNameLoadingStage, {
			status = v14,
			statValue = v12 and v12.timeElapsed
		})
	end, v8.data or v8.error)

	local function fn(p3)
		return v7(networkingAliases.SetUserTag.API(param, p3)):andThen(function(p4)
			if getDeepValue(p4, "responseBody.status") == "Moderated" then
				setState(true)

				if v9 then
					v9.fireAnalyticsEvent(eventNames.CustomizeNameSaveAttemptInvalidInput, {
						alias = p3
					})
				end
			else
				if v9 then
					v9.fireAnalyticsEvent(eventNames.CustomizeNameSaved, { alias = p3 })
				end

				writeNamesQuery({
					client = v8.client,
					query = v5,
					userId = param,
					names = {
						alias = p3,
						contactName = getDeepValue(v11, "names.contactName"),
						displayName = getDeepValue(v11, "names.displayName"),
						username = getDeepValue(v11, "names.username")
					}
				})
				p2.navigation.pop()
			end
		end)
	end

	return react.createElement(SetAliasModal, {
		screenSize = v10,
		alias = deepValue,
		displayName = deepValue2,
		cancelOnActivated = function()
			p2.navigation.pop()
		end,
		saveOnActivated = fn,
		hasSaveAliasError = state,
		onTextChanged = function()
			if state then
				setState(false)
			end
		end,
		isLoading = v8.loading
	})
end
