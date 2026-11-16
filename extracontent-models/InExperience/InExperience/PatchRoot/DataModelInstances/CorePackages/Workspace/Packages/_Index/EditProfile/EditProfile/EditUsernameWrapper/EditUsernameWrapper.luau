local EditProfile = script:FindFirstAncestor("EditProfile")
local HttpService = game:GetService("HttpService")
local parent = EditProfile.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local Constants = require(EditProfile.Common.Constants)
local JavascriptHybrid = Constants.JavascriptHybrid
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local UserProfiles = require(parent.UserProfiles)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)

local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames

local useAnalytics = Analytics.useAnalytics

local function EditUsernameWrapper(props)
	local v = useLocalUserId()
	local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
	local query

	if FFlagUserProfilePlatformProfile then
		query = UserProfiles.Queries.userProfilesBasicNamesByUserIds
	else
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	end

	local v2 = useUserProfilesFetch({
		userIds = { v },
		query = query
	})

	local v3 = useLocalization({ updated = TextKeys.UsernameUpdated })

	local v4 = useAnalytics()

	local function getFeatureStringFromHybridEvent(data) -- 2 equivalent calls inferred from this helper
		if
			data.moduleID == JavascriptHybrid.Module.Navigation
			and data.functionName == JavascriptHybrid.Function.navigateToFeature
			and data.params
			and data.params.params
		then
			return data.params.params.feature
		end

		return nil
	end

	local function isCloseEditUsername(data): boolean -- 1 equivalent call inferred from this helper
		return getFeatureStringFromHybridEvent(data) == JavascriptHybrid.Feature.CloseUpdateUsernameModal -- inferred equivalent call
	end

	local function isCompletedEditUsername(data): boolean -- 1 equivalent call inferred from this helper
		return getFeatureStringFromHybridEvent(data) == JavascriptHybrid.Feature.UpdateUsernameModalSuccess -- inferred equivalent call
	end

	local function updateUsername() -- 1 equivalent call inferred from this helper
		v2.refetch()

		v4.fireAnalyticsEvent(EventNames.UsernameSaved)
	end

	return React.createElement(props.BrowserWrapperComponent, {
		isVisible = true,
		webViewVisible = true,
		modal = false,
		url = urlBuilder.static.settings.account() .. "?changeusername",
		isGenericWebview = true,
		javaScriptCallback = function(json)
			local jsonDecode = HttpService:JSONDecode(json)

			if isCompletedEditUsername(jsonDecode) then -- inferred equivalent call
				updateUsername() -- inferred equivalent call

				if props.onUsernameChanged then
					props.onUsernameChanged()
				end

				props.navigation.goBack()
				props.showToast(v3.updated)
			elseif isCloseEditUsername(jsonDecode) then -- inferred equivalent call
				props.navigation.goBack()
			end
		end
	})
end

return RoactNavigation.withNavigation(EditUsernameWrapper)
