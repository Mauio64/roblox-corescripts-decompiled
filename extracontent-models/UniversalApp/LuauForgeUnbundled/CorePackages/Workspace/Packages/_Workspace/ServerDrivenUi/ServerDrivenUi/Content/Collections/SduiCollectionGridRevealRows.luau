local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local collectionGrid = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CollectionViews").CollectionGrid

local GuiService = game:GetService("GuiService")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ReactFocusNavigation")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryUtils").DiscoveryEventErrorLogger
local showMoreClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.showMoreClickEvent

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local fIntLuaAppGameGridRevealMoreButtonGapPx = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppGameGridRevealMoreButtonGapPx

local function isPositive(p2): boolean
	return p2 ~= nil and p2 > 0
end

local function getTotalRowsInGrid(p2, p3, p4)
	if p3 <= 0 then
		return nil
	end

	local v5 = math.ceil(p2 / p3)

	if p4 ~= nil and p4 > 0 then
		v5 = math.min(v5, p4)
	end

	return v5
end

local function getInitialVisibleRowsInGrid(p2, p3)
	if p2 == nil or p3 == nil then
		return nil, false
	end

	local v5 = p2 - (p3 - 1)

	if v5 <= 0 then
		return nil, true
	end

	return v5, false
end

local function SduiCollectionGridRevealRows(props)
	local itemCount = props.itemCount
	local itemsPerRow = props.itemsPerRow
	local maxNumRows = props.maxNumRows
	local v5

	if itemsPerRow <= 0 then
		v5 = nil
	else
		v5 = math.ceil(itemCount / itemsPerRow)

		if maxNumRows ~= nil and maxNumRows > 0 then
			v5 = math.min(v5, maxNumRows)
		end
	end

	local initialFeedVisibleRows = props.initialFeedVisibleRows
	local v6 = not (initialFeedVisibleRows == nil) and initialFeedVisibleRows > 0

	if v6 then
		local visibleRowsPerReveal = props.visibleRowsPerReveal
		v6 = not (visibleRowsPerReveal == nil) and visibleRowsPerReveal > 0
	end

	local initialFeedVisibleRows2 = props.initialFeedVisibleRows
	local startRow = props.startRow
	local v7, v8

	if initialFeedVisibleRows2 == nil or startRow == nil then
		v7 = nil
		v8 = false
	else
		v7 = initialFeedVisibleRows2 - (startRow - 1)

		if v7 <= 0 then
			v7 = nil
			v8 = true
		else
			v8 = false
		end
	end

	local state, setState = React.useState(v7)

	React.useEffect(function()
		setState(v7)
	end, {
		v7,
		props.initialFeedVisibleRows,
		props.visibleRowsPerReveal,
		props.startRow,
		props.sduiContext.dataUpdatedTimestamp
	})

	React.useEffect(function()
		if v6 and v8 then
			discoveryEventErrorLogger.reportError(
				"SduiCollectionGridRevealRowsInvalidFeedThreshold",
				"Unable to reveal CollectionGrid rows because the grid starts after the feed threshold",
				{
					initialFeedVisibleRows = props.initialFeedVisibleRows,
					startRow = props.startRow
				}
			)
		end
	end, { v6, v8, props.initialFeedVisibleRows, props.startRow })

	local v9 = v6 and not v8

	if v9 then
		v9 = not (v5 == nil) and state ~= nil
	end

	local v10 = if v9 then math.min(state, v5) else nil

	local v11 = v9 and v10 < v5
	local v12 = if v11 then v10 else nil
	React.useLayoutEffect(function()
		props.setDisplayedRowCount(v12)
	end, { props.setDisplayedRowCount, v12 })

	React.useEffect(function()
		local setDisplayedRowCount = props.setDisplayedRowCount
		return function()
			setDisplayedRowCount(nil)
		end
	end, { props.setDisplayedRowCount })

	local v13 = ReactFocusNavigation.useMostRecentFocusBehavior(props.setContainerFrame)
	local v14 = ReactFocusNavigation.useFocusGuiObject()

	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("collectionId", props.analyticsContext)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors(
		"collectionPosition",
		props.analyticsContext
	)
	local v15 = React.useCallback(function()
		if v10 == nil or v5 == nil or props.visibleRowsPerReveal == nil then
			return
		end

		if GuiService.SelectedCoreObject ~= nil and props.containerFrame ~= nil then
			v14(props.containerFrame)
		end

		local v16 = math.min(v10 + props.visibleRowsPerReveal, v5)
		setState(v16)

		if
			typeof(analyticsFieldInAncestors) == "string"
			and typeof(analyticsFieldInAncestors2) == "number"
		then
			showMoreClickEvent(props.sduiContext.appPage or props.sduiContext.routeName or "", {
				topicId = analyticsFieldInAncestors,
				sortIndex = analyticsFieldInAncestors2,
				previousVisibleRows = v10,
				newVisibleRows = v16,
				visibleRowsPerReveal = props.visibleRowsPerReveal,
				totalNumberOfRows = v5
			})
		else
			discoveryEventErrorLogger.reportError(
				"SduiCollectionGridRevealRowsMissingAnalytics",
				"Revealed CollectionGrid rows without valid collection analytics",
				{
					topicId = analyticsFieldInAncestors,
					sortIndex = analyticsFieldInAncestors2
				}
			)
		end
	end, {
		v5,
		v14,
		props.containerFrame,
		props.sduiContext,
		props.visibleRowsPerReveal,
		analyticsFieldInAncestors2,
		analyticsFieldInAncestors,
		v10
	})

	local element = React.createElement(getSduiComponentWrapper(props.revealRowsComponent), {
		componentConfig = props.revealRowsComponent,
		sduiContext = props.sduiContext,
		debugName = "SduiCollectionGridRevealRows.RevealRowsComponent",
		extraLocalProps = { onActivated = v15, layoutOrder = 2, zIndex = 1 }
	})

	local createElement = React.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.gridProps.LayoutOrder
	}
	local v18 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, fIntLuaAppGameGridRevealMoreButtonGapPx)
		}),
		CollectionGrid = 0,
		RevealMoreButton = 0
	}

	local createElement2 = React.createElement

	local join = Cryo.Dictionary.join
	local gridProps = props.gridProps
	local v20 = {
		containerRef = v13,
		LayoutOrder = 1,
		ZIndex = v9 and 2 or props.gridProps.ZIndex,
		maxNumRows = 0
	}
	local v21 = if v9 then v10 else props.gridProps.maxNumRows
	v20.maxNumRows = v21
	v18.CollectionGrid = createElement2(collectionGrid, join(gridProps, v20))

	if not v11 then
		element = nil
	end

	v18.RevealMoreButton = element
	return createElement("Frame", v17, v18)
end

return React.memo(SduiCollectionGridRevealRows)
