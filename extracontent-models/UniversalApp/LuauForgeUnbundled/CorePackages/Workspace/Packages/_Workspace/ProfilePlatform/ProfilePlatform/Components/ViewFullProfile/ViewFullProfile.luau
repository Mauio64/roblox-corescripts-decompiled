local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppEnums").AppPage
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/NavigationRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local navigateDownToViewUserProfile = NavigationRodux.Thunks.NavigateDownToViewUserProfile
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UrlBuilder").UrlBase

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local makeViewGroupPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/makeViewGroupPage")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppNavigation").NavigationCommands else nil

function LUAUFORGE_MODULE_GLOBALS_fgS_ViewFullProfile(p2)
	local v5 = useProfileJsonComponent(Enums.Components.ViewFullProfile) or {}
	local v6 = useProfileWrapperContext()
	local profileId = v6.profileId
	local profileType = v6.profileType
	local v7 = useProfileAnalyticsContext()

	local v8 = useDispatch()
	local v9 = useLocalization({
		viewFullProfileLabel = TextKeys.ViewFullProfile,
		viewCommunityLabel = TextKeys.ViewCommunity
	})

	local useMemo = React.useMemo
	local function fn()
		if not (profileType ~= Enums.ProfileTypes.User and profileType == Enums.ProfileTypes.Community and v5.type ~= Enums.ViewFullProfileTypes.Profile) then
			return v9.viewFullProfileLabel
		end

		if v5.type == Enums.ViewFullProfileTypes.Community then
			return v9.viewCommunityLabel
		end

		return v9.viewFullProfileLabel
	end

	local v11 = if fFlagEnableGroupOverviewPane then profileType else nil
	local v12 = if fFlagEnableGroupOverviewPane then v5.type else nil
	local v13 = useMemo(fn, { v9, v11, v12 })

	local useCallback = React.useCallback
	local function fn2()
		v7.fireAnalyticsEvent(EventNames.ViewPlayerProfileButton, {
			absolutePosition = v6.sourceInfo.homepageCarouselAbsolutePosition,
			isHomePageCarousel = v6.sourceInfo.source == Enums.Sources.HomepageFriendsCarousel,
			source = v6.sourceInfo.source,
			isRecommendation = v6.sourceInfo.isRecommendation,
			recommendationContextType = v6.sourceInfo.recommendationContextType,
			recommendationRank = v6.sourceInfo.recommendationRank,
			recommendationSessionId = v6.sourceInfo.recommendationSessionId
		})

		if profileType == Enums.ProfileTypes.User then
			v8(navigateDownToViewUserProfile(profileId))
		elseif profileType == Enums.ProfileTypes.Community then
			local v14

			if v5.type == Enums.ViewFullProfileTypes.Profile then
				v14 = {
					name = appPage.GenericWebPage,
					detail = urlBuilder.new({
						base = urlBase.WWW,
						path = `profiles/{profileId}`
					})(),
					extraProps = { titleKey = TextKeys.Profile }
				}
			else
				v14 = makeViewGroupPage(profileId)
			end

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v14))
			else
				v8(navigateDown(v14))
			end
		end
	end

	local v15 = if fFlagEnableGroupOverviewPane then profileType else nil
	local v16 = if fFlagEnableGroupOverviewPane then v5.type else nil
	local v17 = useCallback(fn2, { v8, profileId, v7, v6, v15, v16 })

	return React.createElement(
		horizontalPageMargin,
		{
			size = UDim2.fromScale(1, 0),
			backgroundTransparency = 1,
			layoutOrder = p2.layoutOrder,
			useAutomaticSizing = true
		},
		{
			ViewFullProfileFrame = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					LayoutOrder = p2.layoutOrder
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, Constants.ADDITIONAL_PADDING)
					}),
					ViewFullProfile = React.createElement(button, {
						buttonType = buttonType.Secondary,
						size = UDim2.new(1, 0, 0, Constants.CTA_BUTTON_HEIGHT),
						onActivated = v17,
						text = v13
					})
				}
			)
		}
	)
end

return LUAUFORGE_MODULE_GLOBALS_fgS_ViewFullProfile
