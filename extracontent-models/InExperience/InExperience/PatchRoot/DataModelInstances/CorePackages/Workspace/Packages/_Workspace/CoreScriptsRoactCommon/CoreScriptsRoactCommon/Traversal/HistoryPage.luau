local GuiService = game:GetService("GuiService")
local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local AppCommonLib = require(Parent.AppCommonLib)
local CollectionViews = require(Parent.CollectionViews)
local Cryo = require(Parent.Cryo)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Foundation = require(Parent.Foundation)
local GameCollections = require(Parent.GameCollections)
local Impressions = require(Parent.Impressions)
local Localization = require(Parent.Localization)
local React = require(Parent.React)
local RoactServiceTags = require(Parent.RoactServiceTags)
local RobloxAppHooks = require(Parent.RobloxAppHooks)
local ViewportUtils = require(Parent.ViewportUtils)
local SharedFlags = require(Parent.SharedFlags)
local Constants = require(script.Parent.Constants)
local TraversalExperienceCard = require(script.Parent.TraversalExperienceCard)
local TraversalTelemetry = require(script.Parent.TraversalTelemetry)
local v19 = game:DefineFastInt("MaxTraversalHistoryCardsPerRow709", 6)
local FFlagTraversalHistoryDiscoveryTelemetry = SharedFlags.FFlagTraversalHistoryDiscoveryTelemetry
local FFlagTraversalExpPagePaddingFixes = require(script.Parent.Flags).FFlagTraversalExpPagePaddingFixes
local v22 = game:DefineFastFlag("TraversalUseDiscoveryCollectionViews", false)
local v23 = game:DefineFastFlag("TraversalUseXSmallCollectionItems", false)
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local Signal = AppCommonLib.Signal
local CollectionLayoutCalculators = CollectionViews.CollectionLayoutCalculators
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
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

local function getCardsPerRowAndCardWidth(t1: {[any]: any}) -- line: 73
	local availableWidth = t1.availableWidth
	local maxCardsPerRow = t1.maxCardsPerRow
	local minCardWidth = t1.minCardWidth
	local v48 = t1.cardGap or 0
	local v49 = math.floor((availableWidth + v48) / (minCardWidth + v48))
	local v50 = math.floor((availableWidth - v48 * (v49 - 1)) / v49)
	local v51 = math.floor((availableWidth - v48 * (maxCardsPerRow - 1)) / maxCardsPerRow)

	if v49 < 1 then
		return 1, minCardWidth
	end

	if v50 < v51 then
		return maxCardsPerRow, v51
	end

	return v49, v50
end
local function HistoryPage(t2: {[any]: any}, p1) -- line: 95
	-- upvalues: useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), useTokens (copy), useLocalization (copy), FFlagTraversalExpPagePaddingFixes (copy), React (copy), v22 (copy), v23 (copy), GuiService (copy), CollectionItemSize (copy), CollectionLayoutCalculators (copy), CollectionViews (copy), getCardsPerRowAndCardWidth (copy), v19 (copy), Signal (copy), Cryo (copy), TraversalExperienceCard (copy), Constants (copy), TraversalTelemetry (copy), FFlagTraversalHistoryDiscoveryTelemetry (copy), gamePlayIntent (copy), DiscoveryAnalytics (copy), useViewportBounds (copy), SendGameImpressions (copy), FFlagIntegrateTraversalHistoryInSideSheet (copy), View (copy), IconButton (copy), IconName (copy), FoundationText (copy), ScrollView (copy), ImpressionsTrackerWithoutNavigation (copy)
	local v54 = useRoactService(AppEventIngestService)
	local v55 = useRoactService(RoactAnalytics)
	local v56 = useTokens()
	local v57 = useLocalization({
		historyTitle = "CoreScripts.TopBar.Traversal.History",
		historyDescription = "CoreScripts.InGameMenu.Traversal.HistoryDescription"
	})
	local v58 = if not FFlagTraversalExpPagePaddingFixes then v56.Gap.Small else v56.Gap.Large
	local XLarge = v56.Padding.XLarge
	local v60, v61 = React.useState(0)
	local v63, u64

	if v22 then
		local v62 = if not v23 or GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small then CollectionItemSize.Small else CollectionItemSize.XSmall

		v63 = CollectionLayoutCalculators.calculateNumColumns(v60, 0, v58, v62, v56)
		u64 = CollectionViews.calculateItemWidth(v63, v58, 0, v60, 0)
	else
		local v65

		v63, v65 = getCardsPerRowAndCardWidth({
			availableWidth = v60,
			maxCardsPerRow = v19,
			minCardWidth = v56.Size.Size_2500,
			cardGap = v58
		})
		u64 = v65
	end

	local u66 = math.max(v63, 1)
	local v67 = math.floor(#t2.historyItems / u66)
	local v68 = React.useRef(nil)
	local v69 = React.useRef({})
	local v70 = React.useCallback(function(p2, p3) -- line: 130
		-- upvalues: v69 (copy)
		v69.current[p2] = p3
	end, {})
	local v71 = React.useRef(nil)
	local v72 = React.useMemo(function() -- line: 134
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v73 = Cryo.List.map(t2.historyItems, function(p4, p5) -- line: 138
		-- upvalues: React (copy), TraversalExperienceCard (copy), Constants (copy), t2 (copy), TraversalTelemetry (copy), FFlagTraversalHistoryDiscoveryTelemetry (copy), gamePlayIntent (copy), v54 (copy), DiscoveryAnalytics (copy), u64 (ref), v70 (copy)
		return React.createElement(TraversalExperienceCard, {
			key = p5,
			name = p4.name,
			image = p4.image,
			impressionIndex = p5,
			impressionTag = Constants.CardImpressionTag,
			rating = p4.rating,
			onActivated = function() -- line: 146
				-- upvalues: t2 (copy), TraversalTelemetry (copy), p4 (copy), p5 (copy), FFlagTraversalHistoryDiscoveryTelemetry (copy), gamePlayIntent (copy), v54 (copy), DiscoveryAnalytics (copy)
				if not t2.onCardItemActivated then
					return
				end

				TraversalTelemetry.sendHistoryPageExperienceTileClick({
					integration_id = "history_landing_game_tile",
					event_type = "click",
					destination_universe_id = tostring(p4.universeId),
					recency_pos = p5
				})

				if FFlagTraversalHistoryDiscoveryTelemetry then
					gamePlayIntent(v54, DiscoveryAnalytics.Constants.Context.InExpHistoryTile, {
						placeId = tostring(p4.placeId),
						universeId = tostring(p4.universeId),
						sortEntryIndex = tostring(p5)
					})
				end

				t2.onCardItemActivated(p4.universeId)
			end,
			width = u64,
			ref = function(p6) -- line: 168
				-- upvalues: v70 (copy), p5 (copy)
				v70(p5, p6)
			end
		})
	end)
	local v74 = React.useRef(false)

	React.useEffect(function() -- line: 177
		-- upvalues: v74 (copy), v68 (copy), v71 (copy), t2 (copy), v67 (copy), u66 (ref)
		if v74.current then
			return
		end

		if not v68.current or not v71.current or not t2.onLoadMoreHistory then
			return
		end

		local v85 = v68.current * v67

		if v85 + v68.current <= v71.current.AbsoluteSize.Y then
			v74.current = true

			local v86 = math.max(math.floor((v71.current.AbsoluteSize.Y - v85) / v68.current), 1) * u66

			t2.onLoadMoreHistory(v86)
		end
	end, {
		t2.onLoadMoreHistory,
		u66,
		v67
	})

	local v75 = useViewportBounds()
	local v76 = React.useCallback(function(p7) -- line: 205
		-- upvalues: FFlagTraversalHistoryDiscoveryTelemetry (copy), t2 (copy), SendGameImpressions (copy), v54 (copy), v55 (copy), u66 (ref), v67 (copy)
		if FFlagTraversalHistoryDiscoveryTelemetry then
			local t3 = {}

			for v89, v90 in t2.historyItems do
				if v90 then
					table.insert(t3, {
						placeId = tostring(v90.placeId),
						universeId = tostring(v90.universeId),
						uiIndex = v89
					})
				end
			end

			SendGameImpressions.sendFromTraversalHistoryPage(v54, v55, p7, t3, u66, v67)
		end
	end, {
		t2.historyItems,
		v55,
		u66,
		v54,
		v67
	})
	local v77 = React.useCallback(function() -- line: 237
		-- upvalues: TraversalTelemetry (copy), t2 (copy)
		TraversalTelemetry.sendHistoryPageBackButtonClick({
			integration_id = "history_landing_back_button",
			event_type = "click"
		})
		t2.onHistoryClose()
	end, { t2.onHistoryClose })
	local v78 = React.useCallback(function(p8) -- line: 246
		-- upvalues: XLarge (copy), v61 (copy), v69 (copy), v68 (copy)
		local v92 = p8.AbsoluteSize.X - 2 * XLarge

		v61(v92)

		if v69.current[1] then
			v68.current = v69.current[1].AbsoluteSize.Y
		end
	end, { XLarge })
	local v79 = React.useCallback(function(p9) -- line: 255
		-- upvalues: v72 (copy), t2 (copy), v68 (copy), u66 (ref)
		v72:fire()

		if not t2.onLoadMoreHistory or not v68.current then
			return
		end

		local CanvasPositionY = p9.CanvasPosition.Y
		local AbsoluteWindowSizeY = p9.AbsoluteWindowSize.Y
		local AbsoluteCanvasSizeY = p9.AbsoluteCanvasSize.Y
		local current = v68.current

		if AbsoluteCanvasSizeY <= CanvasPositionY + AbsoluteWindowSizeY + current then
			t2.onLoadMoreHistory(u66)
		end
	end, {
		t2.onLoadMoreHistory,
		u66,
		v72
	})
	local v80 = if not FFlagTraversalExpPagePaddingFixes then UDim.new(0, XLarge) else {
		left = UDim.new(0, XLarge),
		right = UDim.new(0, XLarge)
	}

	if FFlagIntegrateTraversalHistoryInSideSheet then
		v80 = {
			left = UDim.new(0, XLarge),
			right = UDim.new(0, XLarge),
			top = UDim.new(0, v56.Padding.Small)
		}
	end

	return React.createElement(View, {
		tag = "col auto-xy size-full-0",
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		}
	}, {
		TopContainer = if not FFlagIntegrateTraversalHistoryInSideSheet then if not FFlagTraversalExpPagePaddingFixes then React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			onActivated = v77,
			ref = p1
		}) else React.createElement(View, {
			tag = "size-full-0 auto-y padding-x-small padding-bottom-large"
		}, {
			ChevronButton = React.createElement(IconButton, {
				icon = IconName.ChevronLargeLeft,
				onActivated = v77,
				ref = p1
			})
		}) else nil,
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col auto-y size-full-0 " .. (not FFlagTraversalExpPagePaddingFixes and "padding-left-medium padding-top-small padding-bottom-large" or ""),
			padding = if not FFlagTraversalExpPagePaddingFixes then nil else {
				left = UDim.new(0, XLarge),
				bottom = UDim.new(0, v56.Padding.XLarge)
			}
		}, {
			Title = not FFlagIntegrateTraversalHistoryInSideSheet and React.createElement(FoundationText, {
				tag = "auto-xy text-heading-small text-truncate-split",
				Text = v57.historyTitle
			}),
			Description = React.createElement(FoundationText, {
				tag = "auto-xy text-body-large text-truncate-split",
				Text = v57.historyDescription
			})
		}),
		ScrollContent = React.createElement(ScrollView, {
			tag = "size-full shrink",
			LayoutOrder = 2,
			selectionGroup = false,
			padding = v80,
			layout = {
				Wraps = true,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v58)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			onAbsoluteSizeChanged = v78,
			onCanvasPositionChanged = v79,
			scrollingFrameRef = v71,
			selection = {
				Selectable = false
			}
		}, v73),
		TraversalHistoryCardImpressionTracker = FFlagTraversalHistoryDiscoveryTelemetry and React.createElement(ImpressionsTrackerWithoutNavigation, {
			parentRef = v71,
			impressionsTag = Constants.CardImpressionTag,
			scrollViewPositionChangedSignal = v72,
			sendImpressions = v76,
			viewPortBounds = v75
		})
	})
end

return React.memo(React.forwardRef(HistoryPage))
