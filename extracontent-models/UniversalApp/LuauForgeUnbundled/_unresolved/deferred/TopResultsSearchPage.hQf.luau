local CorePackages = game:GetService("CorePackages")
local IXPService = game:GetService("IXPService")

local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local UIBlox = require(CorePackages.Packages.UIBlox)
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local emptyState = UIBlox.App.Indicator.EmptyState
local images = UIBlox.App.ImageSet.Images
local module2 = require("@luauforge/bundled/dDZ")
local useCollectionLayoutConfig = require("@luauforge/bundled/ehg").useCollectionLayoutConfig
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local module4 = require("@luauforge/bundled/gDL")
local useFeedVideoPlaybackContext = module4.useFeedVideoPlaybackContext
local videoEndReason = module4.AnalyticsEnums.VideoEndReason

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local removeSduiRootConfig = require("@luauforge/bundled/dDZ").RemoveSduiRootConfig
local modules = require("@luauforge/bundled/dtb").Modules
local removeTextSearchResults = modules.LuaApp.Actions.RemoveTextSearchResults
local context = modules.LuaApp.Components.Search.SearchTypeSelection.Context

local getTopSearchResultsFetchName = require("@luauforge/bundled/egz").getTopSearchResultsFetchName

local module5 = require("@luauforge/bundled/hPX")
local module6 = require("@luauforge/deferred/hQg")
local module7 = require("@luauforge/bundled/hQe")

local visibilityControl = require("@luauforge/bundled/dKz").VisibilityControl

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local fFlagSduiSearchResultsPageEnabled = SharedFlags.FFlagSduiSearchResultsPageEnabled
local fFlagSduiSrpShowNavOnNewSearch = SharedFlags.FFlagSduiSrpShowNavOnNewSearch
local fFlagLuaAppCompositionSearch = SharedFlags.FFlagLuaAppCompositionSearch
local fFlagLuaAppLogSearchTopPageExposure = SharedFlags.FFlagLuaAppLogSearchTopPageExposure
local fFlagLuaAppSearchResultsPageGameTileVideo = SharedFlags.FFlagLuaAppSearchResultsPageGameTileVideo
local fFlagLuaAppVideoAutoplayFeedElection = SharedFlags.FFlagLuaAppVideoAutoplayFeedElection
local fFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay
local fStringLuaAppSearchTopPageIxpLayer = SharedFlags.FStringLuaAppSearchTopPageIxpLayer

local searchPage = appPage.SearchPage

local iconsstatusoof_xlarge = images["icons/status/oof_xlarge"]

local function TopResultsSearchPage(props)
	if fFlagLuaAppLogSearchTopPageExposure then
		React.useEffect(function()
			IXPService:LogFlagLinkedUserLayerExposure(fStringLuaAppSearchTopPageIxpLayer)
		end, {})
	end

	if fFlagSduiSearchResultsPageEnabled then
		local sduiSearchResultsPage = require("@luauforge/bundled/fwb").SduiSearchResultsPage
		local size_600 = useDesignTokens().Size.Size_600

		local canvasTopPadding = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
		local searchKeyword = props.searchParameters.searchKeyword

		if fFlagSduiSrpShowNavOnNewSearch then
			React.useEffect(function()
				if searchKeyword and searchKeyword ~= "" then
					visibilityControl.show()
				end
			end, { searchKeyword })
		end

		return React.createElement(sduiSearchResultsPage, {
			searchKeyword = searchKeyword,
			searchUuid = props.searchUuid,
			globalSessionId = props.omniSearchUuid,
			pageTopPadding = (canvasTopPadding or 0) + size_600,
			onScrollDirectionChanged = props.onScrollDirectionChanged
		})
	else
		local v5 = useLocalization({
			requestFailed = "Feature.Toast.NetworkingError.SomethingIsWrong",
			noResultsFound = "CommonUI.Controls.NoResultsFound"
		})

		local v6 = useRoactService(roactNetworking)
		local v7 = useDispatch()

		local v8 = React.useCallback(function()
			return v7(module6(v6, {
				keyword = props.searchParameters.searchKeyword,
				searchUuid = props.searchUuid,
				omniSearchUuid = props.omniSearchUuid,
				searchVertical = "blended"
			})):catch(function()
				return Promise.resolve()
			end)
		end, { props.searchParameters.searchKeyword, props.searchUuid, props.omniSearchUuid })

		React.useEffect(function()
			v8()
		end, { v8 })

		React.useEffect(function()
			return function()
				v7(removeSduiRootConfig(`{searchPage}_{props.searchUuid}`))
				v7(module7(props.searchUuid))
				v7(removeTextSearchResults(props.searchUuid))
			end
		end, { props.searchUuid, v7 })

		local v9 = useSelector(function(p2)
			local status = performFetch.GetStatus(
				p2,
				getTopSearchResultsFetchName("blended", props.searchUuid)
			)
			return retrievalStatus.fromRawValue(status)
		end)

		local v10 = v9 == retrievalStatus.Done
		local state, setState = React.useState(v10)

		React.useEffect(function()
			if not state and v10 then
				setState(true)
			end
		end, { state, v10 })

		local v11 = useSelector(function(p2)
			local v12 = p2.Personalization.OrderedOmniItems[searchPage]
				and p2.Personalization.OrderedOmniItems[searchPage][props.searchUuid]
				or nil

			return v12 and v12.allItems or {}
		end)

		local size_600 = useDesignTokens().Size.Size_600

		local state2 = nil
		local setState2 = nil
		local ref = nil

		if fFlagLuaAppLayoutParamsInContext then
			state2, setState2 = React.useState(nil)
		else
			ref = React.useRef(nil)
		end

		local v12 = if fFlagLuaAppLayoutParamsInContext then useCollectionLayoutConfig(state2) else nil

		local useSduiContextFromRoduxAndProcessConfigs = module2.useSduiContextFromRoduxAndProcessConfigs

		if not fFlagLuaAppLayoutParamsInContext then
			v12 = nil
		end

		local v14 = useSduiContextFromRoduxAndProcessConfigs(
			searchPage,
			v12,
			`{searchPage}_{props.searchUuid}`
		)
		local v15, v16, v17

		if fFlagLuaAppSearchResultsPageGameTileVideo then
			local v18 = usePreferredInput()

			local v19 = React.useContext(context)
			local v21 = (if v19 then v19.activeSearchType else nil) == searchTypes.TopResults

			local v23 = if not fFlagLuaAppOneByTwoHoverIdleAutoplay then v18 == Responsive.Input.Touch else nil
			local v27

			if fFlagLuaAppOneByTwoHoverIdleAutoplay then
				v27 = module4.getPlaybackDetectionMethod(v18, false)
			end

			v15, v16, v17 = useFeedVideoPlaybackContext(
				v23,
				not v21 or nil,
				fFlagLuaAppVideoAutoplayFeedElection and true or nil,
				fFlagLuaAppVideoAutoplayFeedElection and true or nil,
				v27
			)

			if fFlagLuaAppVideoAutoplayFeedElection then
				local v28 = #v11 > 0

				local viewportVideoAutoplayController = if v15 then v15.viewportVideoAutoplayController else nil

				React.useEffect(function()
					if not viewportVideoAutoplayController then
						return
					end

					if not v21 then
						viewportVideoAutoplayController:reset(videoEndReason.ExitViewport)
						return
					end

					if not v28 then
						return
					end

					viewportVideoAutoplayController:forceScheduleInitialWinnerUpdate()
				end, { v21, v28, viewportVideoAutoplayController })
			end
		else
			v15 = nil
			v16 = nil
			v17 = nil
		end

		local createElement = React.createElement

		if state then
			v9 = retrievalStatus.Done
		end

		return createElement(loadingStateContainer, {
			dataStatus = v9,
			renderOnFailed = function()
				return React.createElement(emptyState, {
					onActivated = v8,
					text = v5.requestFailed
				})
			end,
			renderOnLoaded = function()
				if not (v11 and #v11 > 0) then
					return (React.createElement(emptyState, {
						icon = iconsstatusoof_xlarge,
						text = v5.noResultsFound
					}))
				end

				local createElement2 = React.createElement
				local v21 = {
					topPadding = size_600,
					pageContext = searchPage,
					refresh = v8,
					omniFeedItems = v11,
					createEndOfScrollElement = true,
					onScrollDirectionChanged = props.onScrollDirectionChanged,
					impressionsTag = "TOPSEARCHRESULTS_FEEDITEM_IMPRESSIONS",
					analyticsContext = "TOPSEARCH_OMNIFEED",
					scrollingFrameRef = if fFlagLuaAppLayoutParamsInContext then setState2 else ref,
					canvasTopPadding = 0,
					sduiContext = 0,
					appCompositionEnabled = 0,
					videoPlaybackContext = 0,
					onScrollStart = 0,
					onScrollSettled = 0
				}

				local v23 = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
				v21.canvasTopPadding = v23
				v21.sduiContext = v14
				v21.appCompositionEnabled = fFlagLuaAppCompositionSearch and true or nil
				v21.videoPlaybackContext = if fFlagLuaAppSearchResultsPageGameTileVideo then v15 else nil

				v21.onScrollStart = if fFlagLuaAppSearchResultsPageGameTileVideo then v16 else nil
				v21.onScrollSettled = if fFlagLuaAppSearchResultsPageGameTileVideo then v17 else nil
				return (createElement2(module5, v21))
			end
		})
	end
end

return TopResultsSearchPage
