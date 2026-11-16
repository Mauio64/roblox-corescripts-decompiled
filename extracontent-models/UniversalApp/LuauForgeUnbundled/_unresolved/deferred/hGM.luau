local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local UIBlox = require(CorePackages.Packages.UIBlox)
local useResponsiveLayout = UIBlox.Core.Layout.Responsive.useResponsiveLayout
local gridMetrics = UIBlox.App.Grid.GridMetrics
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local module = require("@luauforge/bundled/cyO")

local useNavigationProps = require("@luauforge/bundled/dCu").useNavigationProps

local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
local useScreenSize = RobloxAppHooks.useScreenSize
local useRoactService = RobloxAppHooks.useRoactService

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/RoactServiceTags")
local roactAnalytics = RoactServiceTags.RoactAnalytics
local appEventIngestService = RoactServiceTags.AppEventIngestService

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local layoutConfig = RobloxAppEnums.LayoutConfig

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module6 = require("@luauforge/bundled/hEB")
local module7 = require("@luauforge/bundled/edl")

local topicContentsReducer = require("@luauforge/bundled/dzJ").TopicContentsReducer

local topicInfosReducer = require("@luauforge/bundled/dzL").TopicInfosReducer

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local module8 = require("@luauforge/deferred/gao")
local useGameCollectionLayoutParams = module8.useGameCollectionLayoutParams
local useGetGameTileHeight = module8.useGetGameTileHeight

local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal

local collectionGrid = require("@luauforge/bundled/edJ").CollectionGrid
local module9 = require("@luauforge/bundled/edc")
local module10 = require("@luauforge/bundled/fYU")
local screenSizeImpressionsTracker = require("@luauforge/bundled/edd").ScreenSizeImpressionsTracker
local sendItemImpressions = require("@luauforge/bundled/eeh").SendItemImpressions
local sendItemActionEvent = require("@luauforge/bundled/eeh").SendItemActionEvent
local contentType = require("@luauforge/bundled/eeh").ContentType
local songTile = require("@luauforge/deferred/hGN").SongTile
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").flaggedMutedError

local gameTileConstants = module10.GameTileConstants

local GAME_GRID_CHILD_PADDING = module.Constants.GAME_GRID_CHILD_PADDING

local withFooter = layoutConfig.Kind.Experiences.WithFooter

local songList = appPage.SongList

return function()
	local v5 = useDesignTokens()
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local ref2 = React.useRef(signal.new())

	local v6 = usePreferredInput()
	local v7 = useRoactService(roactAnalytics)
	local v8 = useRoactService(appEventIngestService)
	local v9 = useLocalization({ chartsTitle = "CommonUI.Features.Label.Charts" })

	local v10 = useSelector(function(p2)
		return p2.TopBar.topBarHeight or 0
	end)

	local sortId = useNavigationProps(function(p2)
		return { sortId = p2 }
	end).sortId
	local formatted = `SongListPage_{sortId}`

	local v11 = useSelector(function(p2)
		return p2.Personalization[topicInfosReducer.key][sortId]
	end)

	local v12 = useSelector(function(p2)
		return p2.Personalization[topicContentsReducer.key][sortId]
	end)

	local entries = v12 and v12.entries or {}

	local v13 = useScreenSize()
	local x = v13 and v13.X or 0
	local pageSideMargin = module9.getPageSideMargin(x)

	local vector2 = Vector2.new(x - 2 * pageSideMargin, v13.Y)
	local v14 = state or v13
	local vector2_2 = Vector2.new(vector2.X, v14 and v14.Y or 0)
	local itemWidth = gridMetrics.getSmallMetrics(vector2_2.X, GAME_GRID_CHILD_PADDING).itemWidth

	local v15 = useTextSizeOffset()
	local v16 = useResponsiveLayout("columns", withFooter)
	local v17 = useResponsiveLayout("gutter", withFooter) or GAME_GRID_CHILD_PADDING
	local v18 = useResponsiveLayout("verticalGutter", withFooter) or v17
	local v19 = math.floor((vector2_2.X + v17) / (itemWidth + v17))

	local v20 = v6 == Responsive.Input.Pointer
	local v21 = useGetGameTileHeight(
		v20,
		"Narrow",
		v20,
		false,
		false,
		v15,
		nil,
		gameTileConstants.TileTextLines.Narrow.titleTextLines
	)

	local v22 = useGameCollectionLayoutParams("Narrow", state2, false, {
		columnGap = v17,
		numColumns = v16 or v19,
		sideMargin = pageSideMargin
	})

	local v23 = React.useCallback(function(p2)
		if not (v11 and entries) then
			return
		end

		local v24 = {}

		for i, entry in ipairs(entries) do
			table.insert(v24, { id = entry.contentId })
		end

		sendItemImpressions.sendFromItemCollection(
			v8,
			v7,
			p2,
			v24,
			v22.numColumns,
			songList,
			1,
			contentType.Song,
			#v24,
			nil,
			v11.name
		)
	end, { v8, v7, entries, v22.numColumns, v11 })

	local v24 = React.useCallback(function(p2, p3)
		if not entries then
			flaggedMutedError("SongGridPageMissingEntries", "entries is nil for handleSongClick")
			return
		end

		if v22.numColumns <= 0 then
			warn("numColumns should not be 0 or nil when calculating row number")
			return
		end

		local v25 = math.ceil(p3 / v22.numColumns)
		sendItemActionEvent.sendFromItemCollection(
			v8,
			v7,
			{ id = p2 },
			v25,
			p3,
			songList,
			1,
			sortId,
			#entries,
			contentType.Song,
			"OpenSongDetails"
		)
	end, { v8, v7, sortId, entries })

	local v25 = React.useCallback(function(p2, p3, p4)
		return React.createElement(songTile, {
			contentId = p2.contentId,
			hasBackground = v20,
			hasOutline = v20,
			impressionsTag = formatted,
			layoutOrder = p3,
			size = p4,
			useLargerFooterFont = v6 == Responsive.Input.Pointer,
			reportTileOpened = function()
				v24(p2.contentId, p3)
			end,
			isContained = v20
		}), "SongTile"
	end, { v6, formatted, v24, v20 })

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		},
		{
			TopBar = React.createElement(module6, { titleText = v9.chartsTitle }),
			ScrollingFrame = React.createElement(module7, {
				Position = UDim2.new(0, 0, 0, v10),
				Size = UDim2.new(1, 0, 1, -v10),
				createEndOfScrollElement = true,
				BackgroundTransparency = v5.LuaApps.SeeAll.BackgroundTransparency,
				onAbsoluteSizeChangedCallback = function(p2)
					if p2 then
						setState(p2.AbsoluteSize)
					end
				end,
				onCanvasPositionChangedCallback = function()
					ref2.current:fire()
				end,
				ref = ref
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, module.Constants.GAME_GRID_PADDING)
				}),
				CollectionGrid = React.createElement(collectionGrid, {
					columnGap = v22.columnGap,
					containerRef = setState2,
					getItemHeight = v21,
					hideHeaderButton = true,
					items = entries,
					numColumns = v22.numColumns,
					renderItem = v25,
					sideMargin = v22.sideMargin,
					title = v11 and v11.displayName or "",
					verticalPadding = v18,
					verticalScrollingFrameRef = ref
				}),
				SeeAllImpressionsDetector = React.createElement(screenSizeImpressionsTracker, {
					impressionsTag = formatted,
					pageContext = songList,
					parentRef = ref,
					scrollViewPositionChangedSignal = ref2.current,
					sendImpressions = v23
				})
			})
		}
	)
end
