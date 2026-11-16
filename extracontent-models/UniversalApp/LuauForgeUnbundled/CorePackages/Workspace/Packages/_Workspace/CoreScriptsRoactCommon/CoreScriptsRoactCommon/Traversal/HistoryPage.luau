local GuiService = game:GetService("GuiService")

local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/AppCommonLib")
local CollectionViews = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CollectionViews")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Cryo")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Foundation")
local GameCollections = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/GameCollections")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Impressions")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RoactServiceTags")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/RobloxAppHooks")
local ViewportUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/ViewportUtils")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/SharedFlags")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Constants")
local TraversalExperienceCard = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalExperienceCard")
local TraversalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/TraversalTelemetry")

local defineFastInt = game:DefineFastInt("MaxTraversalHistoryCardsPerRow709", 6)
local fFlagTraversalHistoryDiscoveryTelemetry = SharedFlags.FFlagTraversalHistoryDiscoveryTelemetry
local fFlagTraversalExpPagePaddingFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/Flags").FFlagTraversalExpPagePaddingFixes
local defineFastFlag = game:DefineFastFlag("TraversalUseDiscoveryCollectionViews", false)
local defineFastFlag2 = game:DefineFastFlag("TraversalUseXSmallCollectionItems", false)
local fFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet

local signal = AppCommonLib.Signal
local collectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators
local collectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local view = Foundation.View
local scrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens
local sendGameImpressions = GameCollections.SendGameImpressions
local impressionsTrackerWithoutNavigation = Impressions.ImpressionsTrackerWithoutNavigation
local useViewportBounds = ViewportUtils.useViewportBounds
local useLocalization = Localization.Hooks.useLocalization
local appEventIngestService = RoactServiceTags.AppEventIngestService
local roactAnalytics = RoactServiceTags.RoactAnalytics
local useRoactService = RobloxAppHooks.useRoactService

local function getCardsPerRowAndCardWidth(data)
	local availableWidth = data.availableWidth
	local maxCardsPerRow = data.maxCardsPerRow
	local minCardWidth = data.minCardWidth
	local cardGap = data.cardGap or 0

	local v5 = math.floor((availableWidth + cardGap) / (minCardWidth + cardGap))

	local v6 = math.floor((availableWidth - cardGap * (v5 - 1)) / v5)
	local v7 = math.floor((availableWidth - cardGap * (maxCardsPerRow - 1)) / maxCardsPerRow)

	if v5 < 1 then
		return 1, minCardWidth
	end

	if v6 < v7 then
		return maxCardsPerRow, v7
	end

	return v5, v6
end

local function HistoryPage(props, p2)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useRoactService(roactAnalytics)
	local v7 = useTokens()
	local v8 = useLocalization({
		historyTitle = "CoreScripts.TopBar.Traversal.History",
		historyDescription = "CoreScripts.InGameMenu.Traversal.HistoryDescription"
	})

	local v9 = if fFlagTraversalExpPagePaddingFixes then v7.Gap.Large else v7.Gap.Small
	local xLarge = v7.Padding.XLarge
	local state, setState = React.useState(0)
	local v10, v11

	if defineFastFlag then
		local v12

		if defineFastFlag2 and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small then
			v12 = collectionItemSize.XSmall
		else
			v12 = collectionItemSize.Small
		end

		v10 = collectionLayoutCalculators.calculateNumColumns(state, 0, v9, v12, v7)
		v11 = CollectionViews.calculateItemWidth(v10, v9, 0, state, 0)
	else
		v10, v11 = getCardsPerRowAndCardWidth({
			availableWidth = state,
			maxCardsPerRow = defineFastInt,
			minCardWidth = v7.Size.Size_2500,
			cardGap = v9
		})
	end

	local v12 = math.max(v10, 1)
	local v13 = math.floor(#props.historyItems / v12)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({})
	local v14 = React.useCallback(function(p3, p4)
		ref2.current[p3] = p4
	end, {})
	local ref3 = React.useRef(nil)
	local v15 = React.useMemo(function()
		return signal.new()
	end, {})

	local mapped = Cryo.List.map(props.historyItems, function(props2, p3)
		return React.createElement(TraversalExperienceCard, {
			key = p3,
			name = props2.name,
			image = props2.image,
			impressionIndex = p3,
			impressionTag = Constants.CardImpressionTag,
			rating = props2.rating,
			onActivated = function()
				if not props.onCardItemActivated then
					return
				end

				TraversalTelemetry.sendHistoryPageExperienceTileClick({
					integration_id = "history_landing_game_tile",
					event_type = "click",
					destination_universe_id = tostring(props2.universeId),
					recency_pos = p3
				})

				if fFlagTraversalHistoryDiscoveryTelemetry then
					gamePlayIntent(v5, DiscoveryAnalytics.Constants.Context.InExpHistoryTile, {
						placeId = tostring(props2.placeId),
						universeId = tostring(props2.universeId),
						sortEntryIndex = tostring(p3)
					})
				end

				props.onCardItemActivated(props2.universeId)
			end,
			width = v11,
			ref = function(p4)
				v14(p3, p4)
			end
		})
	end)

	local ref4 = React.useRef(false)
	React.useEffect(function()
		if ref4.current or not (ref.current and ref3.current and props.onLoadMoreHistory) then
			return
		end

		local v16 = ref.current * v13

		if v16 + ref.current <= ref3.current.AbsoluteSize.Y then
			ref4.current = true
			local v17 = math.max(math.floor((ref3.current.AbsoluteSize.Y - v16) / ref.current), 1) * v12
			props.onLoadMoreHistory(v17)
		end
	end, { props.onLoadMoreHistory, v12, v13 })

	local v16 = useViewportBounds()
	local v17 = React.useCallback(function(p3)
		if fFlagTraversalHistoryDiscoveryTelemetry then
			local v18 = {}

			for k, historyItem in props.historyItems do
				if historyItem then
					table.insert(v18, {
						placeId = tostring(historyItem.placeId),
						universeId = tostring(historyItem.universeId),
						uiIndex = k
					})
				end
			end

			sendGameImpressions.sendFromTraversalHistoryPage(v5, v6, p3, v18, v12, v13)
		end
	end, { props.historyItems, v6, v12, v5, v13 })

	local v18 = React.useCallback(function()
		TraversalTelemetry.sendHistoryPageBackButtonClick({
			integration_id = "history_landing_back_button",
			event_type = "click"
		})

		props.onHistoryClose()
	end, { props.onHistoryClose })

	local v19 = React.useCallback(function(p3)
		setState(p3.AbsoluteSize.X - 2 * xLarge)

		if ref2.current[1] then
			ref.current = ref2.current[1].AbsoluteSize.Y
		end
	end, { xLarge })

	local v20 = React.useCallback(function(data)
		v15:fire()

		if not (props.onLoadMoreHistory and ref.current) then
			return
		end

		local y = data.CanvasPosition.Y
		local y2 = data.AbsoluteWindowSize.Y
		local y3 = data.AbsoluteCanvasSize.Y
		local current = ref.current

		if y3 <= y + y2 + current then
			props.onLoadMoreHistory(v12)
		end
	end, { props.onLoadMoreHistory, v12, v15 })

	local v21 = if fFlagTraversalExpPagePaddingFixes then {
		left = UDim.new(0, xLarge),
		right = UDim.new(0, xLarge)
	} else UDim.new(0, xLarge)

	local v22 = fFlagIntegrateTraversalHistoryInSideSheet
		and {
			left = UDim.new(0, xLarge),
			right = UDim.new(0, xLarge),
			top = UDim.new(0, v7.Padding.Small)
		}
		or v21

	local createElement = React.createElement
	local v24 = {
		tag = "col auto-xy size-full-0",
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}
	local v25

	if not fFlagIntegrateTraversalHistoryInSideSheet then
		if fFlagTraversalExpPagePaddingFixes then
			v25 = React.createElement(
				view,
				{ tag = "size-full-0 auto-y padding-x-small padding-bottom-large" },
				{
					ChevronButton = React.createElement(iconButton, {
						icon = iconName.ChevronLargeLeft,
						onActivated = v18,
						ref = p2
					})
				}
			)
		else
			v25 = React.createElement(iconButton, {
				icon = iconName.ChevronLargeLeft,
				onActivated = v18,
				ref = p2
			})
		end
	end

	return createElement(view, v24, {
		TopContainer = v25,
		Header = React.createElement(view, {
			tag = "col auto-y size-full-0 " .. (fFlagTraversalExpPagePaddingFixes and "" or "padding-left-medium padding-top-small padding-bottom-large"),
			padding = fFlagTraversalExpPagePaddingFixes and {
				left = UDim.new(0, xLarge),
				bottom = UDim.new(0, v7.Padding.XLarge)
			} or nil,
			LayoutOrder = 1
		}, {
			Title = not fFlagIntegrateTraversalHistoryInSideSheet and React.createElement(text, {
				Text = v8.historyTitle,
				tag = "auto-xy text-heading-small text-truncate-split"
			}),
			Description = React.createElement(text, {
				Text = v8.historyDescription,
				tag = "auto-xy text-body-large text-truncate-split"
			})
		}),
		ScrollContent = React.createElement(scrollView, {
			tag = "size-full shrink",
			padding = v22,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v9),
				Wraps = true
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			LayoutOrder = 2,
			onAbsoluteSizeChanged = v19,
			onCanvasPositionChanged = v20,
			scrollingFrameRef = ref3,
			selection = { Selectable = false },
			selectionGroup = false
		}, mapped),
		TraversalHistoryCardImpressionTracker = fFlagTraversalHistoryDiscoveryTelemetry and React.createElement(impressionsTrackerWithoutNavigation, {
			parentRef = ref3,
			impressionsTag = Constants.CardImpressionTag,
			scrollViewPositionChangedSignal = v15,
			sendImpressions = v17,
			viewPortBounds = v16
		})
	})
end

return React.memo(React.forwardRef(HistoryPage))
