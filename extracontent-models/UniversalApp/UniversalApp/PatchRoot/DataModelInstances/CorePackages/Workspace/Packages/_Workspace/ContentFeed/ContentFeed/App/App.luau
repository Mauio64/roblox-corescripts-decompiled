local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local CloseCentralOverlay = require(ParentParentParent.CentralOverlay).Thunks.CloseCentralOverlay
local Http = require(ParentParentParent.Http)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local NavigationRodux = require(ParentParentParent.NavigationRodux)
local React = require(ParentParentParent.React)
local RoactAppPolicy = require(ParentParentParent.UniversalAppPolicy).RoactAppPolicy
local RoactRodux = require(ParentParentParent.RoactRodux)
local RoactUtils = require(ParentParentParent.RoactUtils)
local RobloxAppEnums = require(ParentParentParent.RobloxAppEnums)
local Style = require(ParentParentParent.Style)
local AnalyticsService = require(ParentParent.Analytics.AnalyticsService)
local AppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).AppFeaturePolicies
local AppPage = RobloxAppEnums.AppPage
local Constants = require(ParentParent.Constants)
local createStore = require(ParentParent.createStore)
local Feed = require(ParentParent.Components.Feed)
local FeedContext = require(ParentParent.App.FeedContext)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local GetExperiencesDetails = require(ParentParent.App.Networking).NetworkingGames.GetExperiencesDetails
local getUniverseIds = require(ParentParent.Utils.getUniverseIds)
local Localization = require(ParentParentParent.RobloxAppLocales).Localization
local LocalizationProvider = require(ParentParentParent.Localization).LocalizationProvider
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ParentParentParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v31 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local Networking = require(ParentParent.App.Networking)
local onViewportSizeChanged = CapturesCommon.Utils.onViewportSizeChanged
local OpenAppItemDetails = require(ParentParent.Thunks.OpenAppItemDetails)
local RobloxAppNavigation = require(ParentParentParent.RobloxAppNavigation)
local ScreenSizeChanged = require(ParentParent.Actions.ScreenSizeChanged)
local setupFireEvent = require(ParentParent.Analytics.setupFireEvent)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

require(ParentParent.Types)

local Url = Http.Url
local Foundation = require(ParentParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local AbuseVector = require(ParentParentParent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(ParentParentParent.GenericAbuseReporting.OpenDynamicAbuseReport)
local useCallback = React.useCallback
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useState = React.useState
local FIntContentFeedInitialPostLoadLimit = require(ParentParent.Flags.FIntContentFeedInitialPostLoadLimit)
local FFlagEnableAbuseReportRevampFlow = require(ParentParentParent.SharedFlags).FFlagEnableAbuseReportRevampFlow
local v51 = game:DefineFastFlag("EnableAbuseReportRevampPost", false)
local v52 = createStore()

return function() -- line: 65
	-- upvalues: useDispatch (copy), useState (copy), useNavigationProps (copy), useEffect (copy), v52 (copy), Networking (copy), FIntContentFeedInitialPostLoadLimit (copy), getDeepValue (copy), getUniverseIds (copy), GetExperiencesDetails (copy), onViewportSizeChanged (copy), ScreenSizeChanged (copy), useCallback (copy), setupFireEvent (copy), AnalyticsService (copy), Constants (copy), React (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), NavigateBack (copy), FFlagEnableAbuseReportRevampFlow (copy), v51 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), AppPage (copy), Url (copy), HttpService (copy), NavigateDown (copy), OpenAppItemDetails (copy), RoactRodux (copy), FeedContext (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), FoundationProvider (copy), Foundation (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), StyleProviderWithDefaultTheme (copy), Feed (copy)
	local v53 = useDispatch()
	local v54, v55 = useState(false)
	local v56, v57 = useState(false)
	local v58 = useNavigationProps(function(_, p2, _) -- line: 71
		return {
			onNavigateBackCallback = p2.onNavigateBackCallback,
			postId = p2.postId,
			userId = tostring(p2.userId)
		}
	end)

	useEffect(function() -- line: 79
		-- upvalues: v52 (copy), Networking (copy), FIntContentFeedInitialPostLoadLimit (copy), v58 (copy), getDeepValue (copy), getUniverseIds (copy), GetExperiencesDetails (copy), v55 (copy)
		v52:dispatch(Networking.ContentSharingNetworking.GetPostsByPostId.API({
			limit = FIntContentFeedInitialPostLoadLimit,
			postId = v58.postId,
			userId = v58.userId
		})):andThen(function() -- line: 86
			-- upvalues: getDeepValue (copy), v52 (copy), v58 (copy), getUniverseIds (copy), GetExperiencesDetails (copy)
			local v70 = getDeepValue(v52:getState(), "ContentSharing.byUserId." .. v58.userId .. ".posts") or {}
			local v71 = getUniverseIds(v70)

			v52:dispatch(GetExperiencesDetails.API(v71))
		end):catch(function() -- line: 94
			-- upvalues: v55 (copy)
			v55(true)
		end)
	end, {
		v58.postId,
		v58.userId
	})
	useEffect(function() -- line: 100
		-- upvalues: onViewportSizeChanged (copy), v52 (copy), ScreenSizeChanged (copy)
		return (onViewportSizeChanged(function(vector2: Vector2) -- line: 101
			-- upvalues: v52 (copy), ScreenSizeChanged (copy)
			v52:dispatch(ScreenSizeChanged(vector2))
		end))
	end, {})

	local v59 = useCallback(setupFireEvent({
		analytics = AnalyticsService,
		infoForAllEvents = {
			creatorUserId = v58.userId,
			source = Constants.AnalyticsSource
		}
	}), { v58.userId })
	local v60 = React.useCallback(function(b1: boolean) -- line: 119
		-- upvalues: v58 (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), v53 (copy), NavigateBack (copy)
		if v58.onNavigateBackCallback ~= nil then
			v58.onNavigateBackCallback(b1)
		end

		if FFlagSignalsNavP3Dispatch then
			v31.back()

			return
		end

		v53(NavigateBack())
	end, { v58.onNavigateBackCallback })
	local v61 = React.useCallback(function(s1: string) -- line: 130
		-- upvalues: FFlagEnableAbuseReportRevampFlow (copy), v51 (copy), v53 (copy), OpenDynamicAbuseReport (copy), AbuseVector (copy), CloseCentralOverlay (copy), AppPage (copy), Constants (copy), Url (copy), HttpService (copy), FFlagSignalsNavP3Dispatch (copy), v31 (copy), NavigateDown (copy)
		if FFlagEnableAbuseReportRevampFlow and v51 then
			v53(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.ContentPostScreenshot,
				targetId = s1,
				onClose = function() -- line: 135
					-- upvalues: v53 (copy), CloseCentralOverlay (copy)
					v53(CloseCentralOverlay())
				end
			}))

			return
		end

		local t1 = {
			name = AppPage.GenericWebPage,
			detail = string.format(Constants.AbuseReportUrl, Url.BASE_URL, HttpService:UrlEncode(s1)),
			extraProps = {
				titleKey = "Feature.Catalog.Action.Report"
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v31.down(v31.fromLegacyPage(t1))

			return
		end

		v53(NavigateDown(t1, nil))
	end, {})
	local v62 = React.useCallback(function(s2: string) -- line: 155
		-- upvalues: v53 (copy), OpenAppItemDetails (copy)
		v53(OpenAppItemDetails(s2))
	end, {})

	return React.createElement(RoactRodux.StoreProvider, {
		store = v52
	}, {
		ContextProvider = React.createElement(FeedContext.Provider, {
			value = {
				fireAnalyticsEvent = v59,
				isZooming = v56,
				navigateBack = v60,
				navigateToItemDetailPage = v62,
				navigateToReportPage = v61,
				setIsZooming = v57
			}
		}, {
			PolicyProvider = React.createElement(RoactAppPolicy.Provider, {
				policy = { AppFeaturePolicies }
			}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					DONOTUSE_colorUpdate = true,
					theme = Foundation.Enums.Theme.Dark
				}, {
					LocalizationProvider = React.createElement(LocalizationProvider, {
						localization = Localization.new(LocalizationService.RobloxLocaleId)
					}, {
						StyleProvider = React.createElement(StyleProviderWithDefaultTheme, {
							withDarkTheme = true
						}, {
							Feed = React.createElement(Feed, {
								creatorUserId = v58.userId,
								initialPostId = v58.postId,
								initialPostsCallFailed = v54
							})
						})
					})
				})
			})
		})
	})
end
