local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useContactImporterConfiguration = require(CorePackages.Workspace.Packages.ContactImporter).Utils.useContactImporterConfiguration
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local FFlagLuaAppCompositionAlways = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppCompositionAlways
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local OmniFeedConstants = DiscoveryTypes.OmniFeedConstants
local RoactAnalytics = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactAnalytics
local AppEventIngestService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppEventIngestService
local SetCurrentToastMessage = require(CorePackages.Workspace.Packages.ToastRodux).Actions.SetCurrentToastMessage
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NavigateToUserInfo = require(Modules.LuaApp.Thunks.NavigateToUserInfo)
local NavigateDownToAddFriendsPage = require(Modules.LuaApp.Thunks.NavigateDownToAddFriendsPage)
local useNavigateFromAddFriends = require(Modules.LuaApp.Components.FriendsCarousel.utils.useNavigateFromAddFriends)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local llama = LuaSocialLibrariesDeps.llama
local getFFlagPYMKAddFriendsEntry = require(CorePackages.Workspace.Packages.SharedFlags).getFFlagPYMKAddFriendsEntry
local getFFlagPYMKShowAddFriendsButton_DEV = require(Modules.Personalization.Flags.getFFlagPYMKShowAddFriendsButton_DEV)
local FFlagCreateConnectionsHub = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCreateConnectionsHub
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING
local PYMKCarouselEntryPoint = require(Modules.LuaApp.Components.PYMKCarousel.api).PYMKCarouselEntryPoint
local t2 = {
	renderFriendRecommendationCarousel = function(t1: {[any]: any}) -- line: 80
		-- upvalues: Roact (copy), PYMKCarouselEntryPoint (copy)
		return Roact.createElement(PYMKCarouselEntryPoint, t1)
	end
}
local v34 = RoactServices.connect({
	roactAnalytics = RoactAnalytics,
	eventIngestService = AppEventIngestService
})(function(t3: {[any]: any}) -- line: 85
	-- upvalues: Cryo (copy), t2 (copy), OmniFeedProps (copy), AppPage (copy), React (copy), useSelector (copy), getDeepValue (copy), useDispatch (copy), FFlagCreateConnectionsHub (copy), useNavigation (copy), NavigateToUserInfo (copy), useNavigateFromAddFriends (copy), NavigateDownToAddFriendsPage (copy), useContactImporterConfiguration (copy), SetCurrentToastMessage (copy), FFlagLuaAppCompositionAlways (copy), FormFactor (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), GAME_CAROUSEL_SIDE_WIDE_PADDING (copy), OmniFeedConstants (copy), getFFlagPYMKShowAddFriendsButton_DEV (copy), Roact (copy), llama (copy), getFFlagPYMKAddFriendsEntry (copy)
	local v37 = Cryo.Dictionary.join(t2, t3)
	local v38 = v37[OmniFeedProps.key] and v37[OmniFeedProps.key].appPage or AppPage.Home
	local v39 = v37[OmniFeedProps.key] and v37[OmniFeedProps.key].feedItemStartRow or nil
	local v40 = React.useMemo(function() -- line: 91
		-- upvalues: v37 (copy), v38 (copy), v39 (copy)
		return {
			sortIndex = v37.sortIndex,
			appPage = v38,
			sortId = v37.topicId,
			startRow = v39 or -1
		}
	end, {
		v37.sortIndex,
		v38,
		v37.topicId,
		v39
	})
	local v41 = if not v37[OmniFeedProps.key] then nil else v37[OmniFeedProps.key].scrollViewPositionChangedSignal
	local v42 = useSelector(function(p1) -- line: 103
		return p1.FormFactor
	end)
	local v43 = useSelector(function(p2) -- line: 107
		-- upvalues: getDeepValue (copy), AppPage (copy)
		return getDeepValue(p2, string.format("OmniRecommendations.%s.recommendationsId", AppPage.Home)) or {}
	end)
	local v44 = useDispatch()
	local v45 = if not FFlagCreateConnectionsHub then nil else useNavigation()
	local v46 = useNavigateFromAddFriends({
		policyIsEnabled = v37.isContactImporterPolicyEnabled
	})
	local shouldShowContactImporterModal = useContactImporterConfiguration({
		policyIsEnabled = v37.isContactImporterPolicyEnabled
	}).shouldShowContactImporterModal
	local v48 = not not FFlagLuaAppCompositionAlways or v37[OmniFeedProps.key] and v37[OmniFeedProps.key].appCompositionEnabled
	local v49 = if not v48 then if v42 ~= FormFactor.COMPACT then GAME_CAROUSEL_SIDE_WIDE_PADDING else GAME_CAROUSEL_SIDE_COMPACT_PADDING else nil
	local v50 = v37.topicLayoutData or {}
	local v51 = v50[OmniFeedConstants.TopicLayoutDataKeys.PYMKFindFriendsEnabled] == "true" or (v50[OmniFeedConstants.TopicLayoutDataKeys.PYMKFindFriendsEnabled] == true or getFFlagPYMKShowAddFriendsButton_DEV())
	local v52 = v50[OmniFeedConstants.TopicLayoutDataKeys.PYMKSeeAllEnabled] == "true" or (v50[OmniFeedConstants.TopicLayoutDataKeys.PYMKSeeAllEnabled] == true or getFFlagPYMKShowAddFriendsButton_DEV())

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		key = v43,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		FriendRecommendationCarouselFeedItem = v37.renderFriendRecommendationCarousel({
			findFriendsTileEnabled = v51,
			seeAllTileEnabled = v52,
			pageContext = v38,
			scrollViewPositionChangedSignal = v41,
			carouselTitle = v37.carouselTitle,
			openProfilePeekView = function(p3, p4) -- line: 113
				-- upvalues: v44 (copy), NavigateToUserInfo (copy), Cryo (copy)
				v44(NavigateToUserInfo(p3, {
					profilePeekViewProps = Cryo.Dictionary.join({
						resetPeekView = true
					}, p4 or {})
				}))
			end,
			sideMargin = v49,
			showToast = function(s1: string) -- line: 136
				-- upvalues: v44 (copy), SetCurrentToastMessage (copy)
				v44(SetCurrentToastMessage({
					toastMessage = s1
				}))
			end,
			roactAnalytics = llama.None,
			diagService = v37.roactAnalytics.Diag,
			shouldShowContactImporterBadge = if not getFFlagPYMKAddFriendsEntry() then nil else shouldShowContactImporterModal,
			goToAddFriendsPage = not getFFlagPYMKAddFriendsEntry() and function() -- line: 180
			end or function(b1: boolean?) -- line: 120
				-- upvalues: v46 (copy), FFlagCreateConnectionsHub (copy), v45 (copy), AppPage (copy), v44 (copy), NavigateDownToAddFriendsPage (copy)
				if b1 then
					v46()

					return
				end

				if FFlagCreateConnectionsHub then
					v45.navigate(AppPage.CoHubAddConnections)

					return
				end

				v44(NavigateDownToAddFriendsPage())
			end,
			eventIngestService = v37.eventIngestService,
			sortAnalyticsData = v40,
			appCompositionEnabled = v48
		})
	})
end)

if getFFlagPYMKAddFriendsEntry() then
	v34 = UniversalAppPolicy.connect(function(p5) -- line: 194
		return {
			isContactImporterPolicyEnabled = p5.getContactImporterEnabled()
		}
	end)(v34)
end

return v34
