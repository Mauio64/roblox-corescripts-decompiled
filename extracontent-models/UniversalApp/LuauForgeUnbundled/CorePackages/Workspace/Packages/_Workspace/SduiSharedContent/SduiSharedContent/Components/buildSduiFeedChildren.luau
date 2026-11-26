local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagSduiErrorPaths

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryTypes")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrors = SduiCoreSystem.SduiErrors
local addSduiErrorContextFields = SduiCoreSystem.addSduiErrorContextFields

local SduiFeedItem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/SduiFeedItem")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags")
local fFlagSduiCollectionGridRevealRows = SharedFlags.FFlagSduiCollectionGridRevealRows
local fFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local fFlagSduiIndividualFeedItemSpacing = SharedFlags.FFlagSduiIndividualFeedItemSpacing
local fFlagSduiSamePoolFeedItemSpacing = SharedFlags.FFlagSduiSamePoolFeedItemSpacing
local defineFastFlag = game:DefineFastFlag("SduiFeedDebugNameWithImpressionsTag", false)

local SORT_INDEX_SELECTION_ORDER_MULTIPLIER = DiscoveryTypes.Constants.SORT_INDEX_SELECTION_ORDER_MULTIPLIER

local v5 = {}

local function getSpacingAfterFeedItem(p2, p3, p4, p5, p6)
	if p2 == nil then
		return nil
	end

	if
		fFlagSduiSamePoolFeedItemSpacing
		and p5 ~= nil
		and p6 ~= nil
		and p6.continuesPreviousSection == true
	then
		return p5
	end

	if p3 == 1 and p4 ~= nil and p4 >= 0 then
		return p4
	end

	return p2
end

local function buildSduiFeedChildren(props)
	local children = {}
	local sduiContext = props.sduiContext

	local startRow = props.extraLocalProps and props.extraLocalProps.startRow
	local v6 = typeof(startRow) ~= "number" and 1 or startRow

	local maxConfigs = props.maxConfigs
	local gapBetweenFeedItems = if fFlagSduiIndividualFeedItemSpacing then props.gapBetweenFeedItems else nil
	local gapAfterFirstFeedItem = if fFlagSduiIndividualFeedItemSpacing then props.gapAfterFirstFeedItem else nil

	for k, config in props.configs do
		if maxConfigs ~= nil and maxConfigs < k then
			break
		end

		local v7 = findAnalyticsField("componentType", config.analyticsData or v5)
			or sduiBuilder.getComponentType(config, sduiContext)

		if v7 then
			local formatted = `{props.componentType}{k}_{v7}`
			local sduiComponentWrapper = getSduiComponentWrapper(config)

			local extraLocalProps = props.extraLocalProps

			local startRowGetter = config.startRowGetter
			local v9 = startRowGetter ~= nil and { startRow = startRowGetter } or nil

			local v10 = if startRowGetter == nil then v6 + k - 1 else Cryo.None
			local join = Cryo.Dictionary.join
			local extraLocalProps2 = props.extraLocalProps or v5

			local v12 = if fFlagSduiCollectionGridRevealRows then config.setDisplayedRowCount else nil
			local v13 = join(extraLocalProps2, {
				startRow = v10,
				setDisplayedRowCount = v12
			})

			local joined = Cryo.Dictionary.join(v13, { index = k })

			if fFlagAppPageShellScrollToTopFocus and props.selectionOrderBase ~= nil then
				joined = Cryo.Dictionary.join(joined, {
					selectionOrderBase = props.selectionOrderBase + k * SORT_INDEX_SELECTION_ORDER_MULTIPLIER
				})
			end

			local createElement = React.createElement

			local v15 = if defineFastFlag and props.impressionsTag ~= nil and props.impressionsTag ~= "" then `{formatted}_{props.impressionsTag}` else formatted
			local element = createElement(sduiComponentWrapper, {
				debugName = v15,
				componentConfig = config,
				sduiContext = sduiContext,
				localAnalyticsData = {
					feedItemPosition = k,
					itemComponentType = v7,
					componentType = v7,
					collectionPosition = k
				},
				extraLocalProps = joined,
				extraLocalPropSignals = v9
			})

			local v16 = if config.props and config.props.layoutOrder ~= nil then config.props.layoutOrder else k

			local v17 = if config.props and config.props.zIndex ~= nil then config.props.zIndex else -k

			local v18 = if props.negateImpressionIndex then -k else k
			local v19

			if fFlagSduiIndividualFeedItemSpacing then
				v19 = v16 * 2

				local v20 = if fFlagSduiSamePoolFeedItemSpacing then props.samePoolFeedItemGap else nil
				local v21 = if fFlagSduiSamePoolFeedItemSpacing then props.configs[k + 1] else nil

				if gapBetweenFeedItems == nil then
					v20 = nil
				elseif
					not fFlagSduiSamePoolFeedItemSpacing
					or v20 == nil
					or v21 == nil
					or v21.continuesPreviousSection ~= true
				then
					if k == 1 and gapAfterFirstFeedItem ~= nil and gapAfterFirstFeedItem >= 0 then
						v20 = gapAfterFirstFeedItem
					else
						v20 = gapBetweenFeedItems
					end
				end

				if v20 ~= nil and v20 > 0 then
					children[`{formatted}_GapAfter`] = React.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, v20),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = v19 + 1
					})
				end
			end

			local createElement2 = React.createElement

			if fFlagSduiIndividualFeedItemSpacing then
				v16 = v19
			end

			local v21 = {
				layoutOrder = v16,
				zIndex = v17,
				index = v18,
				impressionsTag = props.impressionsTag,
				selectionBehaviorLeft = props.selectionBehaviorLeft,
				selectionBehaviorRight = props.selectionBehaviorRight,
				defaultFocusRef = 0
			}
			local v22 = if fFlagAppPageShellScrollToTopFocus and k == 1 then props.defaultFocusRef else nil
			v21.defaultFocusRef = v22
			children[formatted] = createElement2(SduiFeedItem, v21, { Item = element })
		else
			local v8 = {
				componentType = props.componentType,
				name = props.debugName,
				message = `Nil componentType in {props.componentType} at index {k}`
			}

			if fFlagSduiErrorPaths then
				addSduiErrorContextFields(v8, config.errorContext)
			end

			sduiContext.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.NilComponentType,
				v8,
				sduiContext.appPage
			)
		end
	end

	return children
end

return buildSduiFeedChildren
