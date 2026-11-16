local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/deferred/dUv")
local closeCentralOverlay = require("@luauforge/deferred/dVI").Thunks.CloseCentralOverlay
local module2 = require("@luauforge/deferred/dVJ")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps")
local module4 = require("@luauforge/deferred/dVL")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local roactAppPolicy = require("@luauforge/deferred/dVN").RoactAppPolicy
local module6 = require("@luauforge/deferred/dVO")
local module7 = require("@luauforge/deferred/dVP")
local module8 = require("@luauforge/deferred/dVQ")
local module9 = require("@luauforge/deferred/dVR")

local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/AnalyticsService")
local appFeaturePolicies = require("@luauforge/deferred/dVN").AppFeaturePolicies
local appPage = module8.AppPage
local module11 = require("@luauforge/deferred/dVV")
local module12 = require("@luauforge/deferred/dVW")
local module13 = require("@luauforge/deferred/dWL")
local CapturesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Context/CapturesContext")
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local getExperiencesDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking").NetworkingGames.GetExperiencesDetails
local module15 = require("@luauforge/deferred/dXM")
local localization = require("@luauforge/deferred/dXu").Localization
local localizationProvider = require("@luauforge/deferred/dWX").LocalizationProvider
local navigateBack = module4.Thunks.NavigateBack
local navigateDown = module4.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@luauforge/deferred/dXT").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/deferred/dXU").NavigationCommands else nil

local Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/App/Networking")
local onViewportSizeChanged = module.Utils.onViewportSizeChanged
local module17 = require("@luauforge/deferred/dXV")
local module18 = require("@luauforge/deferred/dXU")
local ScreenSizeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Actions/ScreenSizeChanged")
local setupFireEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Analytics/setupFireEvent")
local styleProviderWithDefaultTheme = module9.StyleProviderWithDefaultTheme
require("@luauforge/deferred/dXw")
local url = module2.Url

local module21 = require("@luauforge/deferred/dWM")
local foundationProvider = module21.FoundationProvider

local module22 = require("@luauforge/deferred/dYb")
local module23 = require("@luauforge/deferred/dYc")

local useCallback = React.useCallback
local useDispatch = module7.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useNavigationProps = module18.useNavigationProps
local useState = React.useState

local module24 = require("@luauforge/deferred/dYd")
local fFlagEnableAbuseReportRevampFlow = require("@luauforge/deferred/dXT").FFlagEnableAbuseReportRevampFlow
local defineFastFlag = game:DefineFastFlag("EnableAbuseReportRevampPost", false)

local v5 = module12()

return function()
	local v6 = useDispatch()

	local state, setState = useState(false)
	local state2, setState2 = useState(false)

	local v7 = useNavigationProps(function(p2, data, p3)
		return {
			onNavigateBackCallback = data.onNavigateBackCallback,
			postId = data.postId,
			userId = tostring(data.userId)
		}
	end)

	useEffect(function()
		v5:dispatch(Networking.ContentSharingNetworking.GetPostsByPostId.API({
			limit = module24,
			postId = v7.postId,
			userId = v7.userId
		})):andThen(function()
			local v8 = module15(getDeepValue(
				v5:getState(),
				"ContentSharing.byUserId." .. v7.userId .. ".posts"
			) or {})
			v5:dispatch(getExperiencesDetails.API(v8))
		end):catch(function()
			setState(true)
		end)
	end, { v7.postId, v7.userId })

	useEffect(function()
		return (onViewportSizeChanged(function(p2)
			v5:dispatch(ScreenSizeChanged(p2))
		end))
	end, {})

	local v8 = useCallback(setupFireEvent({
		analytics = AnalyticsService,
		infoForAllEvents = {
			creatorUserId = v7.userId,
			source = module11.AnalyticsSource
		}
	}), { v7.userId })

	local v9 = React.useCallback(function(p2)
		if v7.onNavigateBackCallback ~= nil then
			v7.onNavigateBackCallback(p2)
		end

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			v6(navigateBack())
		end
	end, { v7.onNavigateBackCallback })

	local v10 = React.useCallback(function(p2)
		if fFlagEnableAbuseReportRevampFlow and defineFastFlag then
			v6(module23({
				abuseVector = module22.ContentPostScreenshot,
				targetId = p2,
				onClose = function()
					v6(closeCentralOverlay())
				end
			}))
			return
		end

		local v11 = {
			name = appPage.GenericWebPage,
			detail = string.format(module11.AbuseReportUrl, url.BASE_URL, HttpService:UrlEncode(p2)),
			extraProps = { titleKey = "Feature.Catalog.Action.Report" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			v6(navigateDown(v11, nil))
		end
	end, {})

	local v11 = React.useCallback(function(p2)
		v6(module17(p2))
	end, {})

	return React.createElement(module6.StoreProvider, { store = v5 }, {
		ContextProvider = React.createElement(CapturesContext.Provider, {
			value = {
				fireAnalyticsEvent = v8,
				isZooming = state2,
				navigateBack = v9,
				navigateToItemDetailPage = v11,
				navigateToReportPage = v10,
				setIsZooming = setState2
			}
		}, {
			PolicyProvider = React.createElement(roactAppPolicy.Provider, {
				policy = { appFeaturePolicies }
			}, {
				FoundationProvider = React.createElement(
					foundationProvider,
					{
						colorMode = module21.Enums.ColorMode.Dark,
						DONOTUSE_colorUpdate = true
					},
					{
						LocalizationProvider = React.createElement(
							localizationProvider,
							{
								localization = localization.new(LocalizationService.RobloxLocaleId)
							},
							{
								StyleProvider = React.createElement(
									styleProviderWithDefaultTheme,
									{ withDarkTheme = true },
									{
										Feed = React.createElement(module13, {
											creatorUserId = v7.userId,
											initialPostId = v7.postId,
											initialPostsCallFailed = state
										})
									}
								)
							}
						)
					}
				)
			})
		})
	})
end
