local CollectionService = game:GetService("CollectionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local gridMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/UIBlox").App.Grid.GridMetrics

local useNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Hooks.useNetworking

local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Impressions").Constants

local useAvatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceNavigation").AvatarRoute.Hooks.useAvatarRoute

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local useWidgetListInfoViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/useWidgetListInfoViewModel")
local getOrderedWidgets = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/getOrderedWidgets")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListBreakPointEnum")
local getWidgetItemIdsFromWidgetInfo = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getWidgetItemIdsFromWidgetInfo")
local getBreakpointFromRowWidth = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getBreakpointFromRowWidth")
local getUIScaleFromTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getUIScaleFromTokens")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Constants")
local WidgetConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")
local useOnRequestImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Hooks/useOnRequestImpressionsSignal")

local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/WidgetPanel/WidgetPanelView")

local function useWidgetPanelViewModel(props)
	local context = props.context

	local v6 = getUIScaleFromTokens((useTokens()))

	local state, setState = React.useState(0)
	local ref = React.useRef(nil)
	React.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
				ref.current = nil
			end
		end
	end, {})

	local v7 = React.useCallback(function(p2)
		if not p2 then
			return
		end

		local x = p2.AbsoluteSize.X

		if ref.current then
			task.cancel(ref.current)
		end

		ref.current = task.delay(0.2, function()
			ref.current = nil
			setState(x)
		end)
	end, {})

	if props.rowWidth ~= nil then
		state = props.rowWidth
	end

	local v8

	if props.breakpoint == nil then
		v8 = getBreakpointFromRowWidth(not (state > 0) and 0 or state, v6)
	else
		v8 = props.breakpoint
	end

	local v9 = useCatalogPageMonolithDependencies()
	local catalogGridWidget = v9.CatalogGridWidget
	local fetchWidgetInfo = v9.fetchWidgetInfo
	local catalogAnalytics = v9.catalogAnalytics

	local v10 = useNetworking()
	React.useEffect(function()
		fetchWidgetInfo(v10, nil, context)
	end, { context, v10, fetchWidgetInfo })

	local ref2 = React.useRef(nil)
	local v11 = useOnRequestImpressionsSignal()

	local v12 = useAvatarRoute()
	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = v12.current.key
	end

	local v13 = React.useCallback(function(): boolean
		return v12.current.key == ref3.current
	end, { v12 })

	local ref4 = React.useRef({})
	local ref5 = React.useRef({})
	local v14 = React.useCallback(function(items)
		local current = ref4.current
		local current2 = ref5.current

		for k, item in items do
			if current[item.Name] then
				continue
			end

			local attribute = item:GetAttribute(constants.ItemIndex)
			local v15 = if typeof(attribute) == "number" then current2[attribute] else nil

			if v15 == nil then
				continue
			end

			catalogAnalytics.widgetInteractionV2(v15, WidgetConstants.ActionType.IMPRESSION)
			current[item.Name] = true
		end
	end, { catalogAnalytics })

	local v15 = React.useCallback(function(ancestor)
		local tagged = CollectionService:GetTagged(WidgetConstants.WidgetExposureMetadata.TagName)

		if ancestor == nil then
			return {}
		end

		local result = {}

		for k, v16 in tagged do
			if v16:IsDescendantOf(ancestor) then
				table.insert(result, v16)
			end
		end

		return result
	end, {})

	local v16 = useWidgetListInfoViewModel(nil, context, v8)

	local v17 = not (v16 and v16.widgets) and {} or getOrderedWidgets(v16.widgets)

	if #v17 == 0 then
		return { status = "hidden" }
	end

	local smallMetrics = gridMetrics.getSmallMetrics(state, Constants.WIDGET_COLUMN_PADDING)

	local v18 = {}
	local children = {}

	for k, v19 in v17 do
		local widget = v19.widget
		local position = v19.position

		local v20 = math.max(widget.template.previewColumns or 1, 1)

		local v21 = {
			requestId = widget.requestId,
			widgetPosition = position,
			widgetId = widget.id,
			widgetType = widget.type,
			widgetAbsPosition = (position - 1) * v20,
			widgetItemIds = getWidgetItemIdsFromWidgetInfo(widget, v20)
		}

		v18[position] = v21

		local id = widget.id
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v24 = {
			widgetRow = position,
			widgetInfo = widget,
			itemsPerRow = v20,
			rowCount = widget.template.previewRows,
			rowHeight = smallMetrics.itemWidth,
			itemSize = Vector2.new(smallMetrics.itemWidth, smallMetrics.itemWidth),
			widgetAnalyticsInfo = v21,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			rowWidth = 0
		}
		local v25 = if state > 0 then state else nil
		v24.rowWidth = v25
		children[id] = createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = k
		}, {
			Widget = createElement2(catalogGridWidget, v24)
		})
	end

	ref5.current = v18

	return {
		status = "visible",
		viewProps = {
			LayoutOrder = props.LayoutOrder,
			panelRef = ref2,
			onAbsoluteSizeChanged = v7,
			onRequestImpressionsSignal = v11,
			pageFilter = v13,
			onImpressionsDetected = v14,
			collectObjectsFunc = v15,
			children = children
		}
	}
end

return useWidgetPanelViewModel
