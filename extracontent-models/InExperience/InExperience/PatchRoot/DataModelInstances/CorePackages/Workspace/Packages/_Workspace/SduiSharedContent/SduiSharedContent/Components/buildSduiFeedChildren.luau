local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local parent = SduiSharedContent.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local SduiFeedItem = require(SduiSharedContent.Components.SduiFeedItem)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiCollectionGridRevealRows = SharedFlags2.FFlagSduiCollectionGridRevealRows
local FFlagAppPageShellScrollToTopFocus = SharedFlags2.FFlagAppPageShellScrollToTopFocus
local FFlagSduiIndividualFeedItemSpacing = SharedFlags2.FFlagSduiIndividualFeedItemSpacing
local FFlagSduiSamePoolFeedItemSpacing = SharedFlags2.FFlagSduiSamePoolFeedItemSpacing
local defineFastFlag = game:DefineFastFlag("SduiFeedDebugNameWithImpressionsTag", false)

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = DiscoveryTypes.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER

local v = {}

local function getSpacingAfterFeedItem(gapBetweenFeedItems: number?, k: number, gapAfterFirstFeedItem: number?, samePoolFeedItemGap: number?, p) -- 1 equivalent call inferred from this helper
	if gapBetweenFeedItems == nil then
		return nil
	end

	if
		FFlagSduiSamePoolFeedItemSpacing
		and samePoolFeedItemGap ~= nil
		and p ~= nil
		and p.continuesPreviousSection == true
	then
		return samePoolFeedItemGap
	end

	if k == 1 and gapAfterFirstFeedItem ~= nil and gapAfterFirstFeedItem >= 0 then
		return gapAfterFirstFeedItem
	end

	return gapBetweenFeedItems
end

local function buildSduiFeedChildren(props)
	local children = {}
	local sduiContext = props.sduiContext

	local startRow = props.extraLocalProps and props.extraLocalProps.startRow
	local v2 = typeof(startRow) ~= "number" and 1 or startRow

	local maxConfigs = props.maxConfigs
	local gapBetweenFeedItems

	if FFlagSduiIndividualFeedItemSpacing then
		gapBetweenFeedItems = props.gapBetweenFeedItems
	end

	local gapAfterFirstFeedItem

	if FFlagSduiIndividualFeedItemSpacing then
		gapAfterFirstFeedItem = props.gapAfterFirstFeedItem
	end

	for k, config in props.configs do
		if maxConfigs ~= nil and maxConfigs < k then
			break
		end

		local v3 = findAnalyticsField("componentType", config.analyticsData or v)
			or SduiBuilder.getComponentType(config, sduiContext)

		if v3 then
			local formatted = `{props.componentType}{k}_{v3}`
			local sduiComponentWrapper = getSduiComponentWrapper(config)

			local _extraLocalProps = props.extraLocalProps

			local startRowGetter = config.startRowGetter
			local extraLocalPropSignals = startRowGetter ~= nil and { startRow = startRowGetter } or nil
			local startRow2

			if startRowGetter == nil then
				startRow2 = v2 + k - 1
			else
				startRow2 = Cryo.None
			end

			local join = Cryo.Dictionary.join
			local extraLocalProps = props.extraLocalProps or v
			local setDisplayedRowCount

			if FFlagSduiCollectionGridRevealRows then
				setDisplayedRowCount = config.setDisplayedRowCount
			end

			local v4 = join(extraLocalProps, {
				startRow = startRow2,
				setDisplayedRowCount = setDisplayedRowCount
			})

			local joined = Cryo.Dictionary.join(v4, { index = k })

			if FFlagAppPageShellScrollToTopFocus and props.selectionOrderBase ~= nil then
				joined = Cryo.Dictionary.join(joined, {
					selectionOrderBase = props.selectionOrderBase + k * SORT_INDEX_SELECTION_ORDER_MULTIPLIER
				})
			end

			local createElement = React.createElement
			local debugName

			if defineFastFlag and props.impressionsTag ~= nil and props.impressionsTag ~= "" then
				debugName = `{formatted}_{props.impressionsTag}`
			else
				debugName = formatted
			end

			local element = createElement(sduiComponentWrapper, {
				debugName = debugName,
				componentConfig = config,
				sduiContext = sduiContext,
				localAnalyticsData = {
					feedItemPosition = k,
					itemComponentType = v3,
					componentType = v3,
					collectionPosition = k
				},
				extraLocalProps = joined,
				extraLocalPropSignals = extraLocalPropSignals
			})
			local layoutOrder

			if config.props and config.props.layoutOrder ~= nil then
				layoutOrder = config.props.layoutOrder
			else
				layoutOrder = k
			end

			local zIndex

			if config.props and config.props.zIndex ~= nil then
				zIndex = config.props.zIndex
			else
				zIndex = -k
			end

			local v5

			if props.negateImpressionIndex then
				v5 = -k
			else
				v5 = k
			end

			local v6

			if FFlagSduiIndividualFeedItemSpacing then
				v6 = layoutOrder * 2
				local samePoolFeedItemGap

				if FFlagSduiSamePoolFeedItemSpacing then
					samePoolFeedItemGap = props.samePoolFeedItemGap
				end

				local v7

				if FFlagSduiSamePoolFeedItemSpacing then
					v7 = props.configs[k + 1]
				end

				samePoolFeedItemGap = getSpacingAfterFeedItem( -- inferred equivalent call
					gapBetweenFeedItems,
					k,
					gapAfterFirstFeedItem,
					samePoolFeedItemGap,
					v7
				)

				if samePoolFeedItemGap ~= nil and samePoolFeedItemGap > 0 then
					children[`{formatted}_GapAfter`] = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, samePoolFeedItemGap),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = v6 + 1
					})
				end
			end

			local createElement2 = React.createElement

			if FFlagSduiIndividualFeedItemSpacing then
				layoutOrder = v6
			end

			local v7 = {
				layoutOrder = layoutOrder,
				zIndex = zIndex,
				index = v5,
				impressionsTag = props.impressionsTag,
				selectionBehaviorLeft = props.selectionBehaviorLeft,
				selectionBehaviorRight = props.selectionBehaviorRight,
				defaultFocusRef = 0
			}
			local defaultFocusRef

			if FFlagAppPageShellScrollToTopFocus and k == 1 then
				defaultFocusRef = props.defaultFocusRef
			end

			v7.defaultFocusRef = defaultFocusRef
			children[formatted] = createElement2(SduiFeedItem, v7, { Item = element })
		else
			local v4 = {
				componentType = props.componentType,
				name = props.debugName,
				message = `Nil componentType in {props.componentType} at index {k}`
			}

			if FFlagSduiErrorPaths then
				addSduiErrorContextFields(v4, config.errorContext)
			end

			sduiContext.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.NilComponentType,
				v4,
				sduiContext.appPage
			)
		end
	end

	return children
end

return buildSduiFeedChildren
