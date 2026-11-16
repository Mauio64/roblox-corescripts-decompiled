local GuiService = game:GetService("GuiService")

local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local AppCommonLib = require(parent.AppCommonLib)
local CollectionViews = require(parent.CollectionViews)
local Cryo = require(parent.Cryo)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local GameCollections = require(parent.GameCollections)
local Impressions = require(parent.Impressions)
local Localization = require(parent.Localization)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local ViewportUtils = require(parent.ViewportUtils)
local SharedFlags = require(parent.SharedFlags)

local Constants = require(script.Parent.Constants)
local TraversalExperienceCard = require(script.Parent.TraversalExperienceCard)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)

local defineFastInt = game:DefineFastInt("MaxTraversalHistoryCardsPerRow709", 6)
local FFlagTraversalHistoryDiscoveryTelemetry = SharedFlags.FFlagTraversalHistoryDiscoveryTelemetry
local Flags = require(script.Parent.Flags)
local FFlagTraversalExpPagePaddingFixes = Flags.FFlagTraversalExpPagePaddingFixes
local defineFastFlag = game:DefineFastFlag("TraversalUseDiscoveryCollectionViews", false)
local defineFastFlag2 = game:DefineFastFlag("TraversalUseXSmallCollectionItems", false)
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet

local Signal = AppCommonLib.Signal
local CollectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local useTokens = Foundation.Hooks.useTokens
local SendGameImpressions = GameCollections.SendGameImpressions
local ImpressionsTrackerWithoutNavigation = Impressions.ImpressionsTrackerWithoutNavigation
local useViewportBounds = ViewportUtils.useViewportBounds
local useLocalization = Localization.Hooks.useLocalization
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local useRoactService = RobloxAppHooks.useRoactService

local function getCardsPerRowAndCardWidth(data)
	local availableWidth = data.availableWidth
	local maxCardsPerRow = data.maxCardsPerRow
	local minCardWidth = data.minCardWidth
	local cardGap = data.cardGap or 0

	local v = math.floor((availableWidth + cardGap) / (minCardWidth + cardGap))

	local v2 = math.floor((availableWidth - cardGap * (v - 1)) / v)
	local v3 = math.floor((availableWidth - cardGap * (maxCardsPerRow - 1)) / maxCardsPerRow)

	if v < 1 then
		return 1, minCardWidth
	end

	if v2 < v3 then
		return maxCardsPerRow, v3
	end

	return v, v2
end

local function HistoryPage(props, ref5)
	local v = useRoactService(AppEventIngestService)
	local v2 = useRoactService(RoactAnalytics)
	local v3 = useTokens()
	local v4 = useLocalization({
		historyTitle = "CoreScripts.TopBar.Traversal.History",
		historyDescription = "CoreScripts.InGameMenu.Traversal.HistoryDescription"
	})
	local cardGap

	if FFlagTraversalExpPagePaddingFixes then
		cardGap = v3.Gap.Large
	else
		cardGap = v3.Gap.Small
	end

	local xLarge = v3.Padding.XLarge
	local state, setState = React.useState(0)
	local v5, width

	if defineFastFlag then
		local v6

		if defineFastFlag2 and GuiService.ViewportDisplaySize == Enum.DisplaySize.Small then
			v6 = CollectionItemSize.XSmall
		else
			v6 = CollectionItemSize.Small
		end

		v5 = CollectionLayoutCalculators.calculateNumColumns(state, 0, cardGap, v6, v3)
		width = CollectionViews.calculateItemWidth(v5, cardGap, 0, state, 0)
	else
		v5, width = getCardsPerRowAndCardWidth({
			availableWidth = state,
			maxCardsPerRow = defineFastInt,
			minCardWidth = v3.Size.Size_2500,
			cardGap = cardGap
		})
	end

	local v6 = math.max(v5, 1)
	local v7 = math.floor(#props.historyItems / v6)
	local ref = React.useRef(nil)
	local ref2 = React.useRef({})
	local v8 = React.useCallback(function(p, p2)
		ref2.current[p] = p2
	end, {})
	local ref3 = React.useRef(nil)
	local scrollViewPositionChangedSignal = React.useMemo(function()
		return Signal.new()
	end, {})

	local mapped = Cryo.List.map(props.historyItems, function(props2, p)
		return React.createElement(TraversalExperienceCard, {
			key = p,
			name = props2.name,
			image = props2.image,
			impressionIndex = p,
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
					recency_pos = p
				})

				if FFlagTraversalHistoryDiscoveryTelemetry then
					gamePlayIntent(v, DiscoveryAnalytics.Constants.Context.InExpHistoryTile, {
						placeId = tostring(props2.placeId),
						universeId = tostring(props2.universeId),
						sortEntryIndex = tostring(p)
					})
				end

				props.onCardItemActivated(props2.universeId)
			end,
			width = width,
			ref = function(p2)
				v8(p, p2)
			end
		})
	end)

	local ref4 = React.useRef(false)
	React.useEffect(function()
		if ref4.current or not (ref.current and ref3.current and props.onLoadMoreHistory) then
			return
		end

		local v9 = ref.current * v7

		if v9 + ref.current <= ref3.current.AbsoluteSize.Y then
			ref4.current = true
			local v10 = math.max(math.floor((ref3.current.AbsoluteSize.Y - v9) / ref.current), 1) * v6
			props.onLoadMoreHistory(v10)
		end
	end, { props.onLoadMoreHistory, v6, v7 })

	local viewPortBounds = useViewportBounds()
	local sendImpressions = React.useCallback(function(p)
		if FFlagTraversalHistoryDiscoveryTelemetry then
			local v9 = {}

			for k, historyItem in props.historyItems do
				if historyItem then
					table.insert(v9, {
						placeId = tostring(historyItem.placeId),
						universeId = tostring(historyItem.universeId),
						uiIndex = k
					})
				end
			end

			SendGameImpressions.sendFromTraversalHistoryPage(v, v2, p, v9, v6, v7)
		end
	end, { props.historyItems, v2, v6, v, v7 })

	local onActivated = React.useCallback(function()
		TraversalTelemetry.sendHistoryPageBackButtonClick({
			integration_id = "history_landing_back_button",
			event_type = "click"
		})

		props.onHistoryClose()
	end, { props.onHistoryClose })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.X - 2 * xLarge)

		if ref2.current[1] then
			ref.current = ref2.current[1].AbsoluteSize.Y
		end
	end, { xLarge })

	local onCanvasPositionChanged = React.useCallback(function(data)
		scrollViewPositionChangedSignal:fire()

		if not (props.onLoadMoreHistory and ref.current) then
			return
		end

		local y = data.CanvasPosition.Y
		local y2 = data.AbsoluteWindowSize.Y
		local y3 = data.AbsoluteCanvasSize.Y
		local current = ref.current

		if y3 <= y + y2 + current then
			props.onLoadMoreHistory(v6)
		end
	end, { props.onLoadMoreHistory, v6, scrollViewPositionChangedSignal })
	local v9

	if FFlagTraversalExpPagePaddingFixes then
		v9 = { left = UDim.new(0, xLarge), right = UDim.new(0, xLarge) }
	else
		v9 = UDim.new(0, xLarge)
	end

	local padding = FFlagIntegrateTraversalHistoryInSideSheet
		and {
			left = UDim.new(0, xLarge),
			right = UDim.new(0, xLarge),
			top = UDim.new(0, v3.Padding.Small)
		}
		or v9

	local createElement = React.createElement
	local v10 = {
		tag = "col auto-xy size-full-0",
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}
	local topContainer

	if not FFlagIntegrateTraversalHistoryInSideSheet then
		if FFlagTraversalExpPagePaddingFixes then
			topContainer = React.createElement(
				View,
				{ tag = "size-full-0 auto-y padding-x-small padding-bottom-large" },
				{
					ChevronButton = React.createElement(IconButton, {
						icon = IconName.ChevronLargeLeft,
						onActivated = onActivated,
						ref = ref5
					})
				}
			)
		else
			topContainer = React.createElement(IconButton, {
				icon = IconName.ChevronLargeLeft,
				onActivated = onActivated,
				ref = ref5
			})
		end
	end

	return createElement(View, v10, {
		TopContainer = topContainer,
		Header = React.createElement(View, {
			tag = "col auto-y size-full-0 " .. (FFlagTraversalExpPagePaddingFixes and "" or "padding-left-medium padding-top-small padding-bottom-large"),
			padding = FFlagTraversalExpPagePaddingFixes and {
				left = UDim.new(0, xLarge),
				bottom = UDim.new(0, v3.Padding.XLarge)
			} or nil,
			LayoutOrder = 1
		}, {
			Title = not FFlagIntegrateTraversalHistoryInSideSheet and React.createElement(Text, {
				Text = v4.historyTitle,
				tag = "auto-xy text-heading-small text-truncate-split"
			}),
			Description = React.createElement(Text, {
				Text = v4.historyDescription,
				tag = "auto-xy text-body-large text-truncate-split"
			})
		}),
		ScrollContent = React.createElement(ScrollView, {
			tag = "size-full shrink",
			padding = padding,
			layout = {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, cardGap),
				Wraps = true
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			LayoutOrder = 2,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			onCanvasPositionChanged = onCanvasPositionChanged,
			scrollingFrameRef = ref3,
			selection = { Selectable = false },
			selectionGroup = false
		}, mapped),
		TraversalHistoryCardImpressionTracker = FFlagTraversalHistoryDiscoveryTelemetry and React.createElement(ImpressionsTrackerWithoutNavigation, {
			parentRef = ref3,
			impressionsTag = Constants.CardImpressionTag,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			sendImpressions = sendImpressions,
			viewPortBounds = viewPortBounds
		})
	})
end

return React.memo(React.forwardRef(HistoryPage))
