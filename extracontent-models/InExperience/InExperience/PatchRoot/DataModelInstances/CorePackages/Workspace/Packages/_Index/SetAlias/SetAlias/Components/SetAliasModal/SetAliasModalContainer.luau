local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SocialStopwatch = require(ParentParentParent.SocialStopwatch)
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local RoactUtils = require(ParentParentParent.RoactUtils)
local dependencies = require(ParentParent.dependencies)
local SetAliasModal = require(script.Parent.SetAliasModal)
local Constants = require(ParentParent.Common.Constants)
local Analytics = require(ParentParent.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local LoadingStages = SocialLuaAnalytics.Analytics.Enums.LoadingStages
local React = dependencies.React
local NetworkingAliases = dependencies.NetworkingAliases
local getDeepValue = dependencies.SocialLibraries.Dictionary.getDeepValue
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnMount = dependencies.Hooks.useEffectOnMount
local useUserProfilesFetch = dependencies.UserProfiles.Hooks.useUserProfilesFetch
local userProfilesAllNamesByUserIds = dependencies.UserProfiles.Queries.userProfilesAllNamesByUserIds
local writeNamesQuery = dependencies.UserProfiles.Mutations.writeNamesQuery
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local _ = {
	Moderated = "Moderated",
	Success = "Success"
}

return function(p1) -- line: 47
	-- upvalues: useDispatch (copy), Constants (copy), React (copy), useUserProfilesFetch (copy), userProfilesAllNamesByUserIds (copy), useAnalytics (copy), useSelector (copy), getDeepValue (copy), useEffectOnMount (copy), EventNames (copy), SocialStopwatch (copy), LoadingStages (copy), useEffectOnce (copy), NetworkingAliases (copy), writeNamesQuery (copy), SetAliasModal (copy)
	local v25 = useDispatch()
	local v26 = p1.navigation.getParam(Constants.PROFILE_USER_ID)
	local v27, v28 = React.useState(false)
	local v29 = useUserProfilesFetch({
		userIds = { v26 },
		query = userProfilesAllNamesByUserIds
	})
	local v30 = useAnalytics()
	local v31 = useSelector(function(t1: {[any]: any}) -- line: 57
		return t1.ScreenSize
	end)
	local v32 = (getDeepValue(v29, "data.userProfiles") or {})[1] or {}
	local v33 = getDeepValue(v32, "names.alias")
	local v34 = getDeepValue(v32, "names.displayName")

	useEffectOnMount(function() -- line: 67
		-- upvalues: v30 (copy), EventNames (copy)
		if v30 then
			v30.fireAnalyticsEvent(EventNames.CustomizeNameModalOpened)
		end
	end)
	React.useEffect(function() -- line: 73
		-- upvalues: SocialStopwatch (copy), v30 (copy), EventNames (copy), LoadingStages (copy)
		local v36 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)

		v30.fireAnalyticsEvent(EventNames.CustomizeNameLoadingStage, {
			status = LoadingStages.Fetching,
			statValue = v36 and v36.timeElapsed
		})

		return function() -- line: 80
			-- upvalues: SocialStopwatch (copy)
			SocialStopwatch.Stopwatch.stop(SocialStopwatch.Events.CustomizeNameOpened)
		end
	end, {})
	useEffectOnce(function() -- line: 85
		-- upvalues: SocialStopwatch (copy), v30 (copy), EventNames (copy), v29 (copy), LoadingStages (copy)
		local v37 = SocialStopwatch.Stopwatch.get(SocialStopwatch.Events.CustomizeNameOpened)

		v30.fireAnalyticsEvent(EventNames.CustomizeNameLoadingStage, {
			status = if not v29.data then LoadingStages.Failed else LoadingStages.Done,
			statValue = v37 and v37.timeElapsed
		})
	end, v29.data or v29.error)

	return React.createElement(SetAliasModal, {
		screenSize = v31,
		alias = v33,
		displayName = v34,
		cancelOnActivated = function() -- line: 93
			-- upvalues: p1 (copy)
			p1.navigation.pop()
		end,
		saveOnActivated = function(s1: string) -- line: 97
			-- upvalues: v25 (copy), NetworkingAliases (copy), v26 (copy), getDeepValue (copy), v28 (copy), v30 (copy), EventNames (copy), writeNamesQuery (copy), v29 (copy), userProfilesAllNamesByUserIds (copy), v32 (copy), p1 (copy)
			return v25(NetworkingAliases.SetUserTag.API(v26, s1)):andThen(function(p2) -- line: 98
				-- upvalues: getDeepValue (copy), v28 (copy), v30 (copy), EventNames (copy), s1 (copy), writeNamesQuery (copy), v29 (copy), userProfilesAllNamesByUserIds (copy), v26 (copy), v32 (copy), p1 (copy)
				if getDeepValue(p2, "responseBody.status") == "Moderated" then
					v28(true)

					if v30 then
						v30.fireAnalyticsEvent(EventNames.CustomizeNameSaveAttemptInvalidInput, {
							alias = s1
						})
					end

					return
				end

				if v30 then
					v30.fireAnalyticsEvent(EventNames.CustomizeNameSaved, {
						alias = s1
					})
				end

				writeNamesQuery({
					client = v29.client,
					query = userProfilesAllNamesByUserIds,
					userId = v26,
					names = {
						alias = s1,
						contactName = getDeepValue(v32, "names.contactName"),
						displayName = getDeepValue(v32, "names.displayName"),
						username = getDeepValue(v32, "names.username")
					}
				})
				p1.navigation.pop()
			end)
		end,
		hasSaveAliasError = v27,
		onTextChanged = function() -- line: 130
			-- upvalues: v27 (copy), v28 (copy)
			if v27 then
				v28(false)
			end
		end,
		isLoading = v29.loading
	})
end
