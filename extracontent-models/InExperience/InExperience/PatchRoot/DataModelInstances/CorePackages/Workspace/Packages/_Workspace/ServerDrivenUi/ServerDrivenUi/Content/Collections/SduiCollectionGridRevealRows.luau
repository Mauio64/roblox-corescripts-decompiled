local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local CollectionViews = require(parent.CollectionViews)
local CollectionGrid = CollectionViews.CollectionGrid

local GuiService = game:GetService("GuiService")
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local showMoreClickEvent = DiscoveryAnalytics.Events.showMoreClickEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppGameGridRevealMoreButtonGapPx = SharedFlags.FIntLuaAppGameGridRevealMoreButtonGapPx

local function isPositive(p: number?): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p > 0
end

local function getTotalRowsInGrid(p: number, p2: number, p3: number?)
	if p2 <= 0 then
		return nil
	end

	local v = math.ceil(p / p2)

	if p3 ~= nil and p3 > 0 then
		return (math.min(v, p3))
	end

	return v
end

local function getInitialVisibleRowsInGrid(initialFeedVisibleRows: number?, startRow: number?) -- 1 equivalent call inferred from this helper
	if initialFeedVisibleRows == nil or startRow == nil then
		return nil, false
	end

	local v = initialFeedVisibleRows - (startRow - 1)

	if v <= 0 then
		return nil, true
	end

	return v, false
end

local function SduiCollectionGridRevealRows(props)
	local itemCount = props.itemCount
	local itemsPerRow = props.itemsPerRow
	local maxNumRows = props.maxNumRows
	local totalNumberOfRows

	if itemsPerRow <= 0 then
		totalNumberOfRows = nil
	else
		totalNumberOfRows = math.ceil(itemCount / itemsPerRow)

		if maxNumRows ~= nil and maxNumRows > 0 then
			totalNumberOfRows = math.min(totalNumberOfRows, maxNumRows)
		end
	end

	local v = isPositive(props.initialFeedVisibleRows) and isPositive(props.visibleRowsPerReveal) -- inferred equivalent call

	local initialVisibleRowsInGrid, v2 = getInitialVisibleRowsInGrid(props.initialFeedVisibleRows, props.startRow) -- inferred equivalent call
	local state, setState = React.useState(initialVisibleRowsInGrid)

	React.useEffect(function()
		setState(initialVisibleRowsInGrid)
	end, {
		initialVisibleRowsInGrid,
		props.initialFeedVisibleRows,
		props.visibleRowsPerReveal,
		props.startRow,
		props.sduiContext.dataUpdatedTimestamp
	})

	React.useEffect(function()
		if v and v2 then
			DiscoveryEventErrorLogger.reportError(
				"SduiCollectionGridRevealRowsInvalidFeedThreshold",
				"Unable to reveal CollectionGrid rows because the grid starts after the feed threshold",
				{ initialFeedVisibleRows = props.initialFeedVisibleRows, startRow = props.startRow }
			)
		end
	end, { v, v2, props.initialFeedVisibleRows, props.startRow })

	local v3 = v and not v2

	if v3 then
		if totalNumberOfRows == nil then
			v3 = false
		else
			v3 = state ~= nil
		end
	end

	local previousVisibleRows

	if v3 then
		previousVisibleRows = math.min(state, totalNumberOfRows)
	else
		previousVisibleRows = nil
	end

	local v4 = v3 and previousVisibleRows < totalNumberOfRows
	local v5

	if v4 then
		v5 = previousVisibleRows
	else
		v5 = nil
	end

	React.useLayoutEffect(function()
		props.setDisplayedRowCount(v5)
	end, { props.setDisplayedRowCount, v5 })

	React.useEffect(function()
		local setDisplayedRowCount = props.setDisplayedRowCount
		return function()
			setDisplayedRowCount(nil)
		end
	end, { props.setDisplayedRowCount })

	local containerRef = ReactFocusNavigation.useMostRecentFocusBehavior(props.setContainerFrame)
	local v6 = ReactFocusNavigation.useFocusGuiObject()

	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("collectionId", props.analyticsContext)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("collectionPosition", props.analyticsContext)
	local onActivated = React.useCallback(function()
		if previousVisibleRows == nil or totalNumberOfRows == nil or props.visibleRowsPerReveal == nil then
			return
		end

		if GuiService.SelectedCoreObject ~= nil and props.containerFrame ~= nil then
			v6(props.containerFrame)
		end

		local newVisibleRows = math.min(previousVisibleRows + props.visibleRowsPerReveal, totalNumberOfRows)
		setState(newVisibleRows)

		if typeof(analyticsFieldInAncestors) == "string" and typeof(analyticsFieldInAncestors2) == "number" then
			showMoreClickEvent(props.sduiContext.appPage or props.sduiContext.routeName or "", {
				topicId = analyticsFieldInAncestors,
				sortIndex = analyticsFieldInAncestors2,
				previousVisibleRows = previousVisibleRows,
				newVisibleRows = newVisibleRows,
				visibleRowsPerReveal = props.visibleRowsPerReveal,
				totalNumberOfRows = totalNumberOfRows
			})
		else
			DiscoveryEventErrorLogger.reportError(
				"SduiCollectionGridRevealRowsMissingAnalytics",
				"Revealed CollectionGrid rows without valid collection analytics",
				{ topicId = analyticsFieldInAncestors, sortIndex = analyticsFieldInAncestors2 }
			)
		end
	end, {
		totalNumberOfRows,
		v6,
		props.containerFrame,
		props.sduiContext,
		props.visibleRowsPerReveal,
		analyticsFieldInAncestors2,
		analyticsFieldInAncestors,
		previousVisibleRows
	})

	local element = React.createElement(getSduiComponentWrapper(props.revealRowsComponent), {
		componentConfig = props.revealRowsComponent,
		sduiContext = props.sduiContext,
		debugName = "SduiCollectionGridRevealRows.RevealRowsComponent",
		extraLocalProps = { onActivated = onActivated, layoutOrder = 2, zIndex = 1 }
	})

	local createElement = React.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.gridProps.LayoutOrder
	}
	local v8 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, FIntLuaAppGameGridRevealMoreButtonGapPx)
		}),
		CollectionGrid = 0,
		RevealMoreButton = 0
	}

	local createElement2 = React.createElement

	local join = Cryo.Dictionary.join
	local gridProps = props.gridProps
	local v9 = {
		containerRef = containerRef,
		LayoutOrder = 1,
		ZIndex = v3 and 2 or props.gridProps.ZIndex,
		maxNumRows = 0
	}
	local maxNumRows2

	if v3 then
		maxNumRows2 = previousVisibleRows
	else
		maxNumRows2 = props.gridProps.maxNumRows
	end

	v9.maxNumRows = maxNumRows2
	v8.CollectionGrid = createElement2(CollectionGrid, join(gridProps, v9))

	if not v4 then
		element = nil
	end

	v8.RevealMoreButton = element
	return createElement("Frame", v7, v8)
end

return React.memo(SduiCollectionGridRevealRows)
