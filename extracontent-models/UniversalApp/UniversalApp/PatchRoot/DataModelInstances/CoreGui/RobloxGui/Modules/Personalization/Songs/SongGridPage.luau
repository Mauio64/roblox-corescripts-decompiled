local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local GridMetrics = UIBlox.App.Grid.GridMetrics
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local LayoutConfig = RobloxAppEnums.LayoutConfig
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local PersonalizationTopBar = require(Modules.Personalization.PersonalizationTopBar)
local RefreshScrollingFrame = require(Modules.LuaApp.Components.RefreshScrollingFrame)
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local TopicInfosReducer = require(CorePackages.Workspace.Packages.TopicInfosRodux).TopicInfosReducer
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local GameCollections = require(CorePackages.Workspace.Packages.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local CollectionGrid = require(CorePackages.Workspace.Packages.CollectionViews).CollectionGrid
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local GameTile = require(CorePackages.Workspace.Packages.GameTile)
local ScreenSizeImpressionsTracker = require(CorePackages.Workspace.Packages.Impressions).ScreenSizeImpressionsTracker
local SendItemImpressions = require(CorePackages.Workspace.Packages.UnifiedLogging).SendItemImpressions
local SendItemActionEvent = require(CorePackages.Workspace.Packages.UnifiedLogging).SendItemActionEvent
local ContentType = require(CorePackages.Workspace.Packages.UnifiedLogging).ContentType
local SongTile = require(CorePackages.Workspace.Packages.SongTile).SongTile
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local flaggedMutedError = require(CorePackages.Workspace.Packages.Loggers).flaggedMutedError
local GameTileConstants = GameTile.GameTileConstants
local GAME_GRID_CHILD_PADDING = DiscoveryTypes.Constants.GAME_GRID_CHILD_PADDING
local WithFooter = LayoutConfig.Kind.Experiences.WithFooter
local SongList = AppPage.SongList

return function() -- line: 75
	-- upvalues: useDesignTokens (copy), React (copy), Signal (copy), usePreferredInput (copy), useRoactService (copy), RoactAnalytics (copy), AppEventIngestService (copy), useLocalization (copy), useSelector (copy), useNavigationProps (copy), TopicInfosReducer (copy), TopicContentsReducer (copy), useScreenSize (copy), DiscoveryUtils (copy), GridMetrics (copy), GAME_GRID_CHILD_PADDING (copy), useTextSizeOffset (copy), useResponsiveLayout (copy), WithFooter (copy), Responsive (copy), useGetGameTileHeight (copy), GameTileConstants (copy), useGameCollectionLayoutParams (copy), SendItemImpressions (copy), SongList (copy), ContentType (copy), flaggedMutedError (copy), SendItemActionEvent (copy), SongTile (copy), PersonalizationTopBar (copy), RefreshScrollingFrame (copy), DiscoveryTypes (copy), CollectionGrid (copy), ScreenSizeImpressionsTracker (copy)
	local v45 = useDesignTokens()
	local v46 = React.useRef(nil)
	local v47, v48 = React.useState(nil)
	local v49, v50 = React.useState(nil)
	local v51 = React.useRef(Signal.new())
	local v52 = usePreferredInput()
	local v53 = useRoactService(RoactAnalytics)
	local v54 = useRoactService(AppEventIngestService)
	local v55 = useLocalization({
		chartsTitle = "CommonUI.Features.Label.Charts"
	})
	local v56 = useSelector(function(p1) -- line: 89
		return p1.TopBar.topBarHeight or 0
	end)
	local sortId = useNavigationProps(function(p2) -- line: 93
		return {
			sortId = p2
		}
	end).sortId
	local v58 = `SongListPage_{ sortId }`
	local v59 = useSelector(function(p3) -- line: 101
		-- upvalues: TopicInfosReducer (copy), sortId (copy)
		return p3.Personalization[TopicInfosReducer.key][sortId]
	end)
	local v60 = useSelector(function(p4) -- line: 104
		-- upvalues: TopicContentsReducer (copy), sortId (copy)
		return p4.Personalization[TopicContentsReducer.key][sortId]
	end)
	local v61 = v60 and v60.entries or {}
	local v62 = useScreenSize()
	local v63 = v62 and v62.X or 0
	local v64 = DiscoveryUtils.getPageSideMargin(v63)
	local vector2 = Vector2.new(v63 - 2 * v64, v62.Y)
	local v66 = v47 or v62
	local vector2_2 = Vector2.new(vector2.X, v66 and v66.Y or 0)
	local itemWidth = GridMetrics.getSmallMetrics(vector2_2.X, GAME_GRID_CHILD_PADDING).itemWidth
	local v69 = useTextSizeOffset()
	local v70 = useResponsiveLayout("columns", WithFooter)
	local v71 = useResponsiveLayout("gutter", WithFooter) or GAME_GRID_CHILD_PADDING
	local v72 = useResponsiveLayout("verticalGutter", WithFooter) or v71
	local v73 = math.floor((vector2_2.X + v71) / (itemWidth + v71))
	local v74 = v52 == Responsive.Input.Pointer
	local v75 = useGetGameTileHeight(v74, "Narrow", v74, false, false, v69, nil, GameTileConstants.TileTextLines.Narrow.titleTextLines)
	local v76 = useGameCollectionLayoutParams("Narrow", v49, false, {
		columnGap = v71,
		numColumns = v70 or v73,
		sideMargin = v64
	})
	local v77 = React.useCallback(function(p5) -- line: 142
		-- upvalues: v59 (copy), v61 (copy), SendItemImpressions (copy), v54 (copy), v53 (copy), v76 (copy), SongList (copy), ContentType (copy)
		if not v59 then
			return
		end

		if not v61 then
			return
		end

		local t1 = {}

		for _, v in ipairs(v61) do
			table.insert(t1, {
				id = v.contentId
			})
		end

		SendItemImpressions.sendFromItemCollection(v54, v53, p5, t1, v76.numColumns, SongList, 1, ContentType.Song, #t1, nil, v59.name)
	end, {
		v54,
		v53,
		v61,
		v76.numColumns,
		v59
	})
	local v78 = React.useCallback(function(s1: string, n1: number) -- line: 178
		-- upvalues: v61 (copy), flaggedMutedError (copy), v76 (copy), SendItemActionEvent (copy), v54 (copy), v53 (copy), SongList (copy), sortId (copy), ContentType (copy)
		if not v61 then
			flaggedMutedError("SongGridPageMissingEntries", "entries is nil for handleSongClick")

			return
		end

		if v76.numColumns <= 0 then
			warn("numColumns should not be 0 or nil when calculating row number")

			return
		end

		local v90 = math.ceil(n1 / v76.numColumns)

		SendItemActionEvent.sendFromItemCollection(v54, v53, {
			id = s1
		}, v90, n1, SongList, 1, sortId, #v61, ContentType.Song, "OpenSongDetails")
	end, {
		v54,
		v53,
		sortId,
		v61
	})
	local v79 = React.useCallback(function(t2: {[any]: any}, n2: number, p6) -- line: 193
		-- upvalues: React (copy), SongTile (copy), v74 (copy), v58 (copy), v52 (copy), Responsive (copy), v78 (copy)
		return React.createElement(SongTile, {
			contentId = t2.contentId,
			hasBackground = v74,
			hasOutline = v74,
			impressionsTag = v58,
			layoutOrder = n2,
			size = p6,
			useLargerFooterFont = v52 == Responsive.Input.Pointer,
			reportTileOpened = function() -- line: 202
				-- upvalues: v78 (copy), t2 (copy), n2 (copy)
				v78(t2.contentId, n2)
			end,
			isContained = v74
		}), "SongTile"
	end, {
		v52,
		v58,
		v78,
		v74
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1)
	}, {
		TopBar = React.createElement(PersonalizationTopBar, {
			titleText = v55.chartsTitle
		}),
		ScrollingFrame = React.createElement(RefreshScrollingFrame, {
			createEndOfScrollElement = true,
			Position = UDim2.new(0, 0, 0, v56),
			Size = UDim2.new(1, 0, 1, -v56),
			BackgroundTransparency = v45.LuaApps.SeeAll.BackgroundTransparency,
			onAbsoluteSizeChangedCallback = function(p7) -- line: 223
				-- upvalues: v48 (copy)
				if p7 then
					v48(p7.AbsoluteSize)
				end
			end,
			onCanvasPositionChangedCallback = function() -- line: 228
				-- upvalues: v51 (copy)
				v51.current:fire()
			end,
			ref = v46
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING)
			}),
			CollectionGrid = React.createElement(CollectionGrid, {
				hideHeaderButton = true,
				columnGap = v76.columnGap,
				containerRef = v50,
				getItemHeight = v75,
				items = v61,
				numColumns = v76.numColumns,
				renderItem = v79,
				sideMargin = v76.sideMargin,
				title = v59 and v59.displayName or "",
				verticalPadding = v72,
				verticalScrollingFrameRef = v46
			}),
			SeeAllImpressionsDetector = React.createElement(ScreenSizeImpressionsTracker, {
				impressionsTag = v58,
				pageContext = SongList,
				parentRef = v46,
				scrollViewPositionChangedSignal = v51.current,
				sendImpressions = v77
			})
		})
	})
end
