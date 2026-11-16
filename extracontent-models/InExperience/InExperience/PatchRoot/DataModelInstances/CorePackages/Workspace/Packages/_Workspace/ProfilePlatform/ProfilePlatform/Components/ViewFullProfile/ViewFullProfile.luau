local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateDownToViewUserProfile = NavigationRodux.Thunks.NavigateDownToViewUserProfile
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local Constants = require(ProfilePlatform.Common.Constants)
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Enums = require(ProfilePlatform.Common.Enums)

local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local makeViewGroupPage = require(ProfilePlatform.Utils.makeViewGroupPage)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

function ViewFullProfile(p)
	local v = useProfileJsonComponent(Enums.Components.ViewFullProfile) or {}
	local v2 = useProfileWrapperContext()
	local profileId = v2.profileId
	local profileType = v2.profileType
	local v3 = useProfileAnalyticsContext()

	local v4 = useDispatch()
	local v5 = useLocalization({
		viewFullProfileLabel = TextKeys.ViewFullProfile,
		viewCommunityLabel = TextKeys.ViewCommunity
	})

	local useMemo = React.useMemo
	local function fn()
		if not (profileType ~= Enums.ProfileTypes.User and profileType == Enums.ProfileTypes.Community and v.type ~= Enums.ViewFullProfileTypes.Profile) then
			return v5.viewFullProfileLabel
		end

		if v.type == Enums.ViewFullProfileTypes.Community then
			return v5.viewCommunityLabel
		end

		return v5.viewFullProfileLabel
	end

	local v6

	if FFlagEnableGroupOverviewPane then
		v6 = profileType
	end

	local v7

	if FFlagEnableGroupOverviewPane then
		v7 = v.type
	end

	local text = useMemo(fn, { v5, v6, v7 })

	local useCallback = React.useCallback
	local function fn2()
		v3.fireAnalyticsEvent(EventNames.ViewPlayerProfileButton, {
			absolutePosition = v2.sourceInfo.homepageCarouselAbsolutePosition,
			isHomePageCarousel = v2.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
			source = v2.sourceInfo.source,
			isRecommendation = v2.sourceInfo.isRecommendation,
			recommendationContextType = v2.sourceInfo.recommendationContextType,
			recommendationRank = v2.sourceInfo.recommendationRank,
			recommendationSessionId = v2.sourceInfo.recommendationSessionId
		})

		if profileType == Enums.ProfileTypes.User then
			v4(NavigateDownToViewUserProfile(profileId))
		elseif profileType == Enums.ProfileTypes.Community then
			local v8

			if v.type == Enums.ViewFullProfileTypes.Profile then
				v8 = {
					name = AppPage.GenericWebPage,
					detail = urlBuilder.new({ base = UrlBase.WWW, path = `profiles/{profileId}` })(),
					extraProps = { titleKey = TextKeys.Profile }
				}
			else
				v8 = makeViewGroupPage(profileId)
			end

			if FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v8))
			else
				v4(NavigateDown(v8))
			end
		end
	end

	local v8

	if FFlagEnableGroupOverviewPane then
		v8 = profileType
	end

	local v9

	if FFlagEnableGroupOverviewPane then
		v9 = v.type
	end

	local onActivated = useCallback(fn2, { v4, profileId, v3, v2, v8, v9 })

	return React.createElement(
		HorizontalPageMargin,
		{
			size = UDim2.fromScale(1, 0),
			backgroundTransparency = 1,
			layoutOrder = p.layoutOrder,
			useAutomaticSizing = true
		},
		{
			ViewFullProfileFrame = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = p.layoutOrder
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, Constants.ADDITIONAL_PADDING)
					}),
					ViewFullProfile = React.createElement(Button, {
						buttonType = ButtonType.Secondary,
						size = UDim2.new(1, 0, 0, Constants.CTA_BUTTON_HEIGHT),
						onActivated = onActivated,
						text = text
					})
				}
			)
		}
	)
end

return ViewFullProfile
