local EditProfile = script:FindFirstAncestor("EditProfile")
local HttpService = game:GetService("HttpService")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local RoactNavigation = require(EditProfileParent.RoactNavigation)
local JavascriptHybrid = require(EditProfile.Common.Constants).JavascriptHybrid
local UrlBuilder = require(EditProfileParent.UrlBuilder).UrlBuilder
local SocialToast = require(EditProfileParent.SocialToast)
local Images = require(EditProfileParent.UIBlox).App.ImageSet.Images
local UserProfiles = require(EditProfileParent.UserProfiles)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)
local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local FFlagEditProfileMigration = require(EditProfile.Flags).FFlagEditProfileMigration

local function EditUsernameWrapper(t1: {[any]: any}) -- line: 36
	-- upvalues: useLocalUserId (copy), UserProfiles (copy), useLocalization (copy), TextKeys (copy), SocialToast (copy), useAnalytics (copy), JavascriptHybrid (copy), EventNames (copy), React (copy), UrlBuilder (copy), HttpService (copy), FFlagEditProfileMigration (copy), Images (copy)
	local v20 = useLocalUserId()
	local v21 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v20 },
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	})
	local v22 = useLocalization({
		updated = TextKeys.UsernameUpdated
	})
	local v23 = SocialToast.useOpenToast()
	local v24 = useAnalytics()

	local function getFeatureStringFromHybridEvent(p1) -- line: 50
		-- upvalues: JavascriptHybrid (copy)
		if p1.moduleID == JavascriptHybrid.Module.Navigation and (p1.functionName == JavascriptHybrid.Function.navigateToFeature and p1.params and p1.params.params) then
			return p1.params.params.feature
		end

		return nil
	end
	local function isCloseEditUsername(p2) -- line: 75
		-- upvalues: JavascriptHybrid (copy)
		return ((if p2.moduleID ~= JavascriptHybrid.Module.Navigation or (p2.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not p2.params or not p2.params.params)) then nil else p2.params.params.feature)) == JavascriptHybrid.Feature.CloseUpdateUsernameModal
	end
	local function isCompletedEditUsername(p3) -- line: 80
		-- upvalues: JavascriptHybrid (copy)
		return ((if p3.moduleID ~= JavascriptHybrid.Module.Navigation or (p3.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not p3.params or not p3.params.params)) then nil else p3.params.params.feature)) == JavascriptHybrid.Feature.UpdateUsernameModalSuccess
	end
	local function updateUsername() -- line: 85
		-- upvalues: v21 (copy), v24 (copy), EventNames (copy)
		v21.refetch()
		v24.fireAnalyticsEvent(EventNames.UsernameSaved)
	end

	return React.createElement(t1.BrowserWrapperComponent, {
		isVisible = true,
		webViewVisible = true,
		modal = false,
		isGenericWebview = true,
		url = UrlBuilder.static.settings.account() .. "?changeusername",
		javaScriptCallback = function(p4) -- line: 97
			-- upvalues: HttpService (copy), JavascriptHybrid (copy), v21 (copy), v24 (copy), EventNames (copy), t1 (copy), FFlagEditProfileMigration (copy), v22 (copy), v23 (copy), Images (copy)
			local data = HttpService:JSONDecode(p4)

			if ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.UpdateUsernameModalSuccess then
				v21.refetch()
				v24.fireAnalyticsEvent(EventNames.UsernameSaved)

				if t1.onUsernameChanged then
					t1.onUsernameChanged()
				end

				t1.navigation.goBack()

				if FFlagEditProfileMigration then
					t1.showToast(v22.updated)

					return
				end

				v23({
					toastTitle = v22.updated,
					iconImage = Images["icons/actions/accept"]
				})

				return
			end

			if ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.CloseUpdateUsernameModal then
				t1.navigation.goBack()
			end
		end
	})
end

return RoactNavigation.withNavigation(EditUsernameWrapper)
