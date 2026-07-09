local Parent = script:FindFirstAncestor("AvatarExperienceServerDrivenUi").Parent
local React = require(Parent.React)
local AppCommonLib = require(Parent.AppCommonLib)
local useTokens = require(Parent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local VirtualizedFeed = require(Parent.AvatarExperienceUIKit).FeedComponents.VirtualizedFeed
local CATALOG_RESULTS_HORIZONTAL_MARGIN = require(Parent.AvatarExperienceCatalog).Constants.CATALOG_RESULTS_HORIZONTAL_MARGIN
local FFlagAXFixSduiCatalogRowJump = require(Parent.AvatarExperienceFlags).FFlagAXFixSduiCatalogRowJump
local t1 = {}

local function SduiCatalogVirtualizedFeed(t2: {[any]: any}) -- line: 59
	-- upvalues: useTokens (copy), CATALOG_RESULTS_HORIZONTAL_MARGIN (copy), React (copy), AppCommonLib (copy), FFlagAXFixSduiCatalogRowJump (copy), findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), SduiErrors (copy), getSduiComponentWrapper (copy), VirtualizedFeed (copy)
	local analyticsContext = t2.analyticsContext
	local sduiContext = t2.sduiContext
	local feedItems = t2.feedItems
	local debugName = t2.debugName
	local v20 = useTokens()
	local v21 = if not t2.horizontalPadding then CATALOG_RESULTS_HORIZONTAL_MARGIN else t2.horizontalPadding
	local v22 = React.useMemo(function() -- line: 70
		-- upvalues: AppCommonLib (copy)
		return AppCommonLib.Signal.new()
	end, {})
	local v23 = React.useRef(nil)
	local v24 = React.useCallback(function(_: number) -- line: 76
		-- upvalues: v22 (copy)
		v22:fire()
	end, {})
	local u25 = nil
	local v26 = nil

	if FFlagAXFixSduiCatalogRowJump then
		local v27, v28 = React.useState(0)
		local v29 = React.useRef(0)

		v26 = React.useCallback(function(n2: number) -- line: 89
			-- upvalues: v29 (copy), v28 (copy)
			if n2 == v29.current then
				return
			end

			v29.current = n2
			v28(n2)
		end, {})

		if v27 > 0 then
			u25 = math.max(0, v27 - v21 * 2)
		end
	end

	local v30 = React.useCallback(function(t3: {[any]: any}) -- line: 104
		-- upvalues: findAnalyticsField (copy), t1 (copy), SduiBuilder (copy), sduiContext (copy), SduiErrors (copy), debugName (copy), getSduiComponentWrapper (copy), v22 (copy), FFlagAXFixSduiCatalogRowJump (copy), u25 (ref), React (copy), analyticsContext (copy)
		local item = t3.item
		local index = t3.index
		local v36 = findAnalyticsField("componentType", item.analyticsData or t1) or SduiBuilder.getComponentType(item, sduiContext)

		if not v36 then
			sduiContext.dependencies.logger.reportError(SduiErrors.SduiErrorType.NilComponentType, {
				componentType = "CatalogVirtualizedFeed",
				name = debugName,
				message = `Nil componentType in CatalogVirtualizedFeed at feedItem index { index }`
			}, sduiContext.appPage)

			return nil
		end

		local t4 = {
			feedItemPosition = index,
			itemComponentType = v36,
			componentType = v36
		}
		local v38 = getSduiComponentWrapper(item)
		local v39 = if not item.props or item.props.layoutOrder == nil then index else item.props.layoutOrder
		local t5 = {
			startRow = 1,
			scrollViewPositionChangedSignal = v22,
			layoutOrder = v39,
			feedRowWidth = if not FFlagAXFixSduiCatalogRowJump then nil else u25
		}

		return React.createElement(v38, {
			debugName = `catalogVirtualizedFeedItem{ index }`,
			componentConfig = item,
			sduiContext = sduiContext,
			localAnalyticsData = t4,
			extraLocalProps = t5,
			parentAnalyticsContext = if not item.__isClientBinding then analyticsContext else nil
		})
	end, {
		feedItems,
		debugName,
		v22,
		sduiContext,
		analyticsContext,
		if not FFlagAXFixSduiCatalogRowJump then nil else u25
	})

	if feedItems == nil then
		return nil
	end

	return React.createElement(VirtualizedFeed, {
		data = feedItems,
		renderItem = v30,
		flatListRef = v23,
		horizontalPadding = v21,
		verticalPadding = if t2.verticalPadding == nil then v20.Padding.Small else t2.verticalPadding,
		windowSize = t2.windowSize,
		initialNumToRender = t2.initialNumToRender,
		maxToRenderPerBatch = t2.maxToRenderPerBatch,
		updateCellsBatchingPeriod = t2.updateCellsBatchingPeriod,
		scrollEventThrottle = t2.scrollEventThrottle,
		onScroll = v24,
		onContainerWidthChanged = v26,
		onEndReached = t2.onScrollToEnd,
		onEndReachedThreshold = t2.onEndReachedThreshold,
		isLoading = t2.isLoading,
		isEndOfList = t2.isEndOfList,
		scrollToTopLabel = t2.scrollToTopLabel,
		endOfListBottomPadding = t2.endOfListBottomPadding,
		LayoutOrder = t2.layoutOrder,
		Size = t2.Size,
		backgroundColor = t2.backgroundColor,
		backgroundTransparency = t2.backgroundTransparency
	})
end

return React.memo(SduiCatalogVirtualizedFeed)
