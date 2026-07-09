local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local AppPage = require(ProfilePlatformParent.RobloxAppEnums).AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local NavigationRodux = require(ProfilePlatformParent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateDownToViewUserProfile = NavigationRodux.Thunks.NavigateDownToViewUserProfile
local UrlBuilder = require(ProfilePlatformParent.UrlBuilder).UrlBuilder
local UrlBase = require(ProfilePlatformParent.UrlBuilder).UrlBase
local Constants = require(ProfilePlatform.Common.Constants)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v26 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands

function ViewFullProfile(p1) -- line: 38
	-- upvalues: FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), useProfileJsonComponent (copy), Enums (copy), useProfileWrapperContext (copy), useProfileAnalyticsContext (copy), useDispatch (copy), useLocalization (copy), TextKeys (copy), React (copy), EventNames (copy), NavigateDownToViewUserProfile (copy), UrlBuilder (copy), UrlBase (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy), HorizontalPageMargin (copy), Constants (copy), Button (copy), ButtonType (copy)
	local v28 = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else useProfileJsonComponent(Enums.Components.ViewFullProfile) or {}
	local v29 = useProfileWrapperContext()
	local profileId = v29.profileId
	local profileType = v29.profileType
	local v32 = useProfileAnalyticsContext()
	local v33 = useDispatch()
	local v34 = useLocalization({
		viewFullProfileLabel = TextKeys.ViewFullProfile,
		viewCommunityLabel = TextKeys.ViewCommunity
	})
	local v35 = React.useMemo(function() -- line: 52
		-- upvalues: profileType (copy), Enums (copy), v34 (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), v28 (copy)
		if profileType == Enums.ProfileTypes.User then
			return v34.viewFullProfileLabel
		end

		if profileType == Enums.ProfileTypes.Community then
			if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then
				return v34.viewCommunityLabel
			end

			if v28.type == Enums.ViewFullProfileTypes.Profile then
				return v34.viewFullProfileLabel
			end

			if v28.type == Enums.ViewFullProfileTypes.Community then
				return v34.viewCommunityLabel
			end
		end

		return v34.viewFullProfileLabel
	end, { v34 })
	local v36 = React.useCallback(function() -- line: 74
		-- upvalues: v32 (copy), EventNames (copy), v29 (copy), Enums (copy), profileType (copy), v33 (copy), NavigateDownToViewUserProfile (copy), profileId (copy), v28 (copy), UrlBuilder (copy), UrlBase (copy), AppPage (copy), FFlagProfilePlatformUpdateUXForNonSocialCommunities (copy), TextKeys (copy), FFlagSignalsNavP3Dispatch (copy), v26 (copy), NavigateDown (copy)
		v32.fireAnalyticsEvent(EventNames.ViewPlayerProfileButton, {
			absolutePosition = v29.sourceInfo.homepageCarouselAbsolutePosition,
			isHomePageCarousel = v29.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
			source = v29.sourceInfo.source,
			isRecommendation = v29.sourceInfo.isRecommendation,
			recommendationContextType = v29.sourceInfo.recommendationContextType,
			recommendationRank = v29.sourceInfo.recommendationRank,
			recommendationSessionId = v29.sourceInfo.recommendationSessionId
		})

		if profileType == Enums.ProfileTypes.User then
			v33(NavigateDownToViewUserProfile(profileId))

			return
		end

		if profileType == Enums.ProfileTypes.Community then
			local v37 = if v28.type ~= Enums.ViewFullProfileTypes.Profile then UrlBuilder.user.group({
				groupId = profileId
			}) else UrlBuilder.new({
				base = UrlBase.WWW,
				path = `profiles/{ profileId }`
			})()
			local t1 = {
				name = AppPage.GenericWebPage,
				detail = v37,
				extraProps = {
					titleKey = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities or v28.type ~= Enums.ViewFullProfileTypes.Profile then TextKeys.Community else TextKeys.Profile
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v26.down(v26.fromLegacyPage(t1))

				return
			end

			v33(NavigateDown(t1))
		end
	end, {
		v33,
		profileId,
		v32,
		v29
	})

	return React.createElement(HorizontalPageMargin, {
		backgroundTransparency = 1,
		useAutomaticSizing = true,
		size = UDim2.fromScale(1, 0),
		layoutOrder = p1.layoutOrder
	}, {
		ViewFullProfileFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = p1.layoutOrder
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Constants.ADDITIONAL_PADDING)
			}),
			ViewFullProfile = React.createElement(Button, {
				buttonType = ButtonType.Secondary,
				size = UDim2.new(1, 0, 0, Constants.CTA_BUTTON_HEIGHT),
				onActivated = v36,
				text = v35
			})
		})
	})
end

return ViewFullProfile
