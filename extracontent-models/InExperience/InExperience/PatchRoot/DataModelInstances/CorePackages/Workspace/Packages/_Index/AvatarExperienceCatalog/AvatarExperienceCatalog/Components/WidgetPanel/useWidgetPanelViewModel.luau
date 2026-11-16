local CollectionService = game:GetService("CollectionService")

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(parent.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking

local Impressions = require(parent.Impressions)
local Constants = Impressions.Constants

local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local useWidgetListInfoViewModel = require(AvatarExperienceCatalog.Components.ResultsList.useWidgetListInfoViewModel)
local getOrderedWidgets = require(AvatarExperienceCatalog.Components.ResultsList.getOrderedWidgets)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)
local getWidgetItemIdsFromWidgetInfo = require(AvatarExperienceCatalog.Utils.getWidgetItemIdsFromWidgetInfo)
local getBreakpointFromRowWidth = require(AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth)
local getUIScaleFromTokens = require(AvatarExperienceCatalog.Utils.getUIScaleFromTokens)
local Constants2 = require(AvatarExperienceCatalog.Constants)
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
local useOnRequestImpressionsSignal = require(AvatarExperienceCatalog.Components.Hooks.useOnRequestImpressionsSignal)

local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

require(script.Parent.WidgetPanelView)

local function useWidgetPanelViewModel(props)
	local context = props.context

	local uiScaleFromTokens = getUIScaleFromTokens((useTokens()))

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

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		if not p then
			return
		end

		local x = p.AbsoluteSize.X

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

	local v

	if props.breakpoint == nil then
		v = getBreakpointFromRowWidth(not (state > 0) and 0 or state, uiScaleFromTokens)
	else
		v = props.breakpoint
	end

	local v2 = useCatalogPageMonolithDependencies()
	local catalogGridWidget = v2.CatalogGridWidget
	local fetchWidgetInfo = v2.fetchWidgetInfo
	local catalogAnalytics = v2.catalogAnalytics

	local v3 = useNetworking()
	React.useEffect(function()
		fetchWidgetInfo(v3, nil, context)
	end, { context, v3, fetchWidgetInfo })

	local ref2 = React.useRef(nil)
	local onRequestImpressionsSignal = useOnRequestImpressionsSignal()

	local v4 = useAvatarRoute()
	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = v4.current.key
	end

	local pageFilter = React.useCallback(function(): boolean
		return v4.current.key == ref3.current
	end, { v4 })

	local ref4 = React.useRef({})
	local ref5 = React.useRef({})
	local onImpressionsDetected = React.useCallback(function(items)
		local current = ref4.current
		local current2 = ref5.current

		for _, item in items do
			if current[item.Name] then
				continue
			end

			local attribute = item:GetAttribute(Constants.ItemIndex)
			local v5

			if typeof(attribute) == "number" then
				v5 = current2[attribute]
			end

			if v5 == nil then
				continue
			end

			catalogAnalytics.widgetInteractionV2(v5, WidgetConstants.ActionType.IMPRESSION)
			current[item.Name] = true
		end
	end, { catalogAnalytics })

	local collectObjectsFunc = React.useCallback(function(ancestor)
		local tagged = CollectionService:GetTagged(WidgetConstants.WidgetExposureMetadata.TagName)

		if ancestor == nil then
			return {}
		end

		local result = {}

		for _, v5 in tagged do
			if v5:IsDescendantOf(ancestor) then
				table.insert(result, v5)
			end
		end

		return result
	end, {})

	local v5 = useWidgetListInfoViewModel(nil, context, v)

	local v6 = not (v5 and v5.widgets) and {} or getOrderedWidgets(v5.widgets)

	if #v6 == 0 then
		return { status = "hidden" }
	end

	local smallMetrics = GridMetrics.getSmallMetrics(state, Constants2.WIDGET_COLUMN_PADDING)

	local current = {}
	local children = {}

	for k, v7 in v6 do
		local widget = v7.widget
		local position = v7.position

		local itemsPerRow = math.max(widget.template.previewColumns or 1, 1)

		local widgetAnalyticsInfo = {
			requestId = widget.requestId,
			widgetPosition = position,
			widgetId = widget.id,
			widgetType = widget.type,
			widgetAbsPosition = (position - 1) * itemsPerRow,
			widgetItemIds = getWidgetItemIdsFromWidgetInfo(widget, itemsPerRow)
		}

		current[position] = widgetAnalyticsInfo

		local id = widget.id
		local createElement = React.createElement

		local createElement2 = React.createElement
		local v8 = {
			widgetRow = position,
			widgetInfo = widget,
			itemsPerRow = itemsPerRow,
			rowCount = widget.template.previewRows,
			rowHeight = smallMetrics.itemWidth,
			itemSize = Vector2.new(smallMetrics.itemWidth, smallMetrics.itemWidth),
			widgetAnalyticsInfo = widgetAnalyticsInfo,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			rowWidth = 0
		}
		local rowWidth

		if state > 0 then
			rowWidth = state
		end

		v8.rowWidth = rowWidth
		children[id] = createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = k }, {
			Widget = createElement2(catalogGridWidget, v8)
		})
	end

	ref5.current = current

	return {
		status = "visible",
		viewProps = {
			LayoutOrder = props.LayoutOrder,
			panelRef = ref2,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			onRequestImpressionsSignal = onRequestImpressionsSignal,
			pageFilter = pageFilter,
			onImpressionsDetected = onImpressionsDetected,
			collectObjectsFunc = collectObjectsFunc,
			children = children
		}
	}
end

return useWidgetPanelViewModel
