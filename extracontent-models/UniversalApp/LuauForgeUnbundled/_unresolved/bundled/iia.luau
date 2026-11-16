local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation

local useContactImporterConfiguration = require("@luauforge/bundled/coQ").Utils.useContactImporterConfiguration
local universalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local fFlagLuaAppCompositionAlways = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCompositionAlways
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/cyO")
local omniFeedConstants = module.OmniFeedConstants
local roactAnalytics = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactAnalytics
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppEventIngestService
local setCurrentToastMessage = require("@luauforge/bundled/dwC").Actions.SetCurrentToastMessage

local omniFeedProps = require("@luauforge/bundled/dpZ").Modules.Personalization.OmniFeed.OmniFeedProps

local module2 = require("@luauforge/bundled/edM")
local module3 = require("@luauforge/bundled/ftX")
local module4 = require("@luauforge/bundled/ihX")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local llama = LuaSocialLibrariesDeps.llama

local getFFlagPYMKAddFriendsEntry = require("@game/CorePackages/Workspace/Packages/SharedFlags").getFFlagPYMKAddFriendsEntry
local module5 = require("@luauforge/bundled/iib")
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCreateConnectionsHub

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local pymkCarouselEntryPoint = require("@luauforge/bundled/cgs").PYMKCarouselEntryPoint

local v5 = {
	renderFriendRecommendationCarousel = function(p2)
		return Roact.createElement(pymkCarouselEntryPoint, p2)
	end
}

local v6 = roactServices.connect({
	roactAnalytics = roactAnalytics,
	eventIngestService = appEventIngestService
})(function(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local appPage2 = joined[omniFeedProps.key] and joined[omniFeedProps.key].appPage or appPage.Home
	local feedItemStartRow

	if joined[omniFeedProps.key] then
		feedItemStartRow = joined[omniFeedProps.key].feedItemStartRow or nil
	else
		feedItemStartRow = nil
	end

	local v7 = React.useMemo(function()
		return {
			sortIndex = joined.sortIndex,
			appPage = appPage2,
			sortId = joined.topicId,
			startRow = feedItemStartRow or -1
		}
	end, { joined.sortIndex, appPage2, joined.topicId, feedItemStartRow })
	local scrollViewPositionChangedSignal

	if joined[omniFeedProps.key] then
		scrollViewPositionChangedSignal = joined[omniFeedProps.key].scrollViewPositionChangedSignal
	end

	local v8 = useSelector(function(p3)
		return p3.FormFactor
	end)

	local v9 = useSelector(function(p3)
		return getDeepValue(p3, string.format("OmniRecommendations.%s.recommendationsId", appPage.Home))
			or {}
	end)

	local v10 = useDispatch()
	local v11 = if fFlagCreateConnectionsHub then useNavigation() else nil
	local function fn(p3, options)
		v10(module2(p3, {
			profilePeekViewProps = Cryo.Dictionary.join({ resetPeekView = true }, options or {})
		}))
	end

	local v12 = module4({ policyIsEnabled = joined.isContactImporterPolicyEnabled })
	local function fn2(p3)
		if p3 then
			v12()
		elseif fFlagCreateConnectionsHub then
			v11.navigate(appPage.CoHubAddConnections)
		else
			v10(module3())
		end
	end

	local shouldShowContactImporterModal = useContactImporterConfiguration({
		policyIsEnabled = joined.isContactImporterPolicyEnabled
	}).shouldShowContactImporterModal

	local function fn3(p3)
		v10(setCurrentToastMessage({ toastMessage = p3 }))
	end

	local v13 = fFlagLuaAppCompositionAlways and true
		or joined[omniFeedProps.key] and joined[omniFeedProps.key].appCompositionEnabled
	local v14

	if not v13 then
		if v8 == formFactor.COMPACT then
			v14 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
		else
			v14 = GAME_CAROUSEL_SIDE_WIDE_PADDING
		end
	end

	local topicLayoutData = joined.topicLayoutData or {}

	local v15 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PYMKFindFriendsEnabled] == "true"
		or topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PYMKFindFriendsEnabled] == true
		or module5()
	local v16 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PYMKSeeAllEnabled] == "true"
		or topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PYMKSeeAllEnabled] == true
		or module5()

	local createElement = Roact.createElement
	local v18 = { key = v9, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local renderFriendRecommendationCarousel = joined.renderFriendRecommendationCarousel
	local v20 = {
		findFriendsTileEnabled = v15,
		seeAllTileEnabled = v16,
		pageContext = appPage2,
		scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
		carouselTitle = joined.carouselTitle,
		openProfilePeekView = fn,
		sideMargin = v14,
		showToast = fn3,
		roactAnalytics = llama.None,
		diagService = joined.roactAnalytics.Diag,
		shouldShowContactImporterBadge = 0,
		goToAddFriendsPage = 0,
		eventIngestService = 0,
		sortAnalyticsData = 0,
		appCompositionEnabled = 0
	}

	if not getFFlagPYMKAddFriendsEntry() then
		shouldShowContactImporterModal = nil
	end

	v20.shouldShowContactImporterBadge = shouldShowContactImporterModal

	v20.goToAddFriendsPage = not getFFlagPYMKAddFriendsEntry() and function() end or fn2
	v20.eventIngestService = joined.eventIngestService
	v20.sortAnalyticsData = v7
	v20.appCompositionEnabled = v13
	return createElement("Frame", v18, {
		FriendRecommendationCarouselFeedItem = renderFriendRecommendationCarousel(v20)
	})
end)

if getFFlagPYMKAddFriendsEntry() then
	v6 = universalAppPolicy.connect(function(p2)
		return { isContactImporterPolicyEnabled = p2.getContactImporterEnabled() }
	end)(v6)
end

return v6
