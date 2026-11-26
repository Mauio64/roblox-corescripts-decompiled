local HttpService = game:GetService("HttpService")

local fFlagUserProfilePlatformProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagUserProfilePlatformProfile
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactNavigation")
local javascriptHybrid = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Constants").JavascriptHybrid
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UrlBuilder").UrlBuilder

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/UserProfiles")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/TextKeys")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics")
local eventNames = Analytics.EventNames

local useAnalytics = Analytics.useAnalytics

local function EditUsernameWrapper(props)
	local v5 = useLocalUserId()
	local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch

	local v7 = if fFlagUserProfilePlatformProfile then UserProfiles.Queries.userProfilesBasicNamesByUserIds else UserProfiles.Queries.userProfilesAllNamesByUserIds
	local v8 = useUserProfilesFetch({
		userIds = { v5 },
		query = v7
	})

	local v9 = useLocalization({ updated = TextKeys.UsernameUpdated })

	local v10 = useAnalytics()

	local function getFeatureStringFromHybridEvent(data)
		if
			data.moduleID == javascriptHybrid.Module.Navigation
			and data.functionName == javascriptHybrid.Function.navigateToFeature
			and data.params
			and data.params.params
		then
			return data.params.params.feature
		end

		return nil
	end

	local function isCloseEditUsername(data): boolean
		return (if data.moduleID == javascriptHybrid.Module.Navigation and data.functionName == javascriptHybrid.Function.navigateToFeature and data.params and data.params.params then data.params.params.feature else nil) == javascriptHybrid.Feature.CloseUpdateUsernameModal
	end

	local function isCompletedEditUsername(data): boolean
		return (if data.moduleID == javascriptHybrid.Module.Navigation and data.functionName == javascriptHybrid.Function.navigateToFeature and data.params and data.params.params then data.params.params.feature else nil) == javascriptHybrid.Feature.UpdateUsernameModalSuccess
	end

	local function updateUsername()
		v8.refetch()

		v10.fireAnalyticsEvent(eventNames.UsernameSaved)
	end

	return React.createElement(props.BrowserWrapperComponent, {
		isVisible = true,
		webViewVisible = true,
		modal = false,
		url = urlBuilder.static.settings.account() .. "?changeusername",
		isGenericWebview = true,
		javaScriptCallback = function(json)
			local jsonDecode = HttpService:JSONDecode(json)
			local v11

			if
				jsonDecode.moduleID == javascriptHybrid.Module.Navigation
				and jsonDecode.functionName == javascriptHybrid.Function.navigateToFeature
				and jsonDecode.params
				and jsonDecode.params.params
			then
				v11 = jsonDecode.params.params.feature
			end

			if v11 == javascriptHybrid.Feature.UpdateUsernameModalSuccess then
				v8.refetch()

				v10.fireAnalyticsEvent(eventNames.UsernameSaved)

				if props.onUsernameChanged then
					props.onUsernameChanged()
				end

				props.navigation.goBack()
				props.showToast(v9.updated)
			else
				local v12

				if
					jsonDecode.moduleID == javascriptHybrid.Module.Navigation
					and jsonDecode.functionName == javascriptHybrid.Function.navigateToFeature
					and jsonDecode.params
					and jsonDecode.params.params
				then
					v12 = jsonDecode.params.params.feature
				end

				if v12 == javascriptHybrid.Feature.CloseUpdateUsernameModal then
					props.navigation.goBack()
				end
			end
		end
	})
end

return RoactNavigation.withNavigation(EditUsernameWrapper)
