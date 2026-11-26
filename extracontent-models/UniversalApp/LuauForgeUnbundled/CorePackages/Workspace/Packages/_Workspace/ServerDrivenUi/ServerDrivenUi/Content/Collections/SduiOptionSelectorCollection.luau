local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiComponentType = SduiCoreSystem.SduiComponentType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiPlaceholderWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiPlaceholderWrapper

local SduiVariableItemWidthCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/Collections/SduiVariableItemWidthCarousel")

local fFlagSduiOptionImpressionsEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionImpressionsEventName
local fFlagSduiOptionSelectorHeaderComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionSelectorHeaderComponent
local fFlagSduiChartsSortDetailGenreFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiChartsSortDetailGenreFilter
local fFlagSduiOptionSelectorAnchorTag = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionSelectorAnchorTag

local fFlagSduiOptionSelectorSkipSelectedRefresh = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiOptionSelectorSkipSelectedRefresh

local function SduiOptionSelectorCollection(props)
	local sduiContext = props.sduiContext

	local v5 = useTokens()
	local paddingBetweenOptionSelectorAndCollection = props.paddingBetweenOptionSelectorAndCollection
		or v5.Size.Size_400

	local state, setState = React.useState(nil)

	local v6 = state or props.selectedOption

	local ref = React.useRef(0)

	React.useEffect(function()
		setState(nil)
	end, { props.selectedOption })

	local useCallback = React.useCallback
	local function fn(value)
		if typeof(value) ~= "string" or value == "" then
			sduiContext.dependencies.logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiComponentType.OptionSelectorCollection,
					message = `Invalid or missing option id: {value}`,
					propName = "optionId"
				},
				sduiContext.appPage
			)
			return
		end

		local v7 = if fFlagSduiOptionSelectorSkipSelectedRefresh then v6 else state

		if v7 == value then
			return
		end

		local current

		if fFlagSduiChartsSortDetailGenreFilter then
			current = nil
		else
			setState(value)

			ref.current += 1
			current = ref.current
		end

		local v8 = props.onOptionActivated(nil, nil, { selectedOption = value })

		if fFlagSduiChartsSortDetailGenreFilter then
			if v8 == nil then
				return
			end

			setState(value)

			ref.current += 1
			current = ref.current
		end

		if typeof(v8) == "table" and typeof(v8.finally) == "function" then
			v8:finally(function()
				if ref.current == current then
					setState(nil)
				end
			end)
			return
		end

		sduiContext.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiComponentType.OptionSelectorCollection,
				message = "onOptionActivated did not return a refresh promise",
				propName = "onOptionActivated"
			},
			sduiContext.appPage
		)
		setState(nil)
	end

	local onOptionActivated = props.onOptionActivated
	local v8 = if not fFlagSduiOptionSelectorSkipSelectedRefresh then state else nil
	local v10 = useCallback(fn, {
		onOptionActivated,
		sduiContext,
		v8,
		ref,
		if fFlagSduiOptionSelectorSkipSelectedRefresh then v6 else nil
	})

	local v11, v12 = React.useMemo(function()
		if not (props.optionItemConfigs and props.optionsData) then
			sduiContext.dependencies.logger.reportError(sduiErrorType.InvalidProps, {
				componentType = sduiComponentType.OptionSelectorCollection,
				message = `Missing {props.optionItemConfigs and "optionsData" or "optionItemConfigs"} prop`,
				propName = props.optionItemConfigs and "optionsData" or "optionItemConfigs"
			}, sduiContext.appPage)

			return {}
		end

		local anchorTags = fFlagSduiOptionSelectorAnchorTag and {} or nil
		local clones = {}

		for k, optionItemConfig in props.optionItemConfigs do
			local v13 = props.optionsData[k]
			local id = if v13 then v13.id else nil

			if fFlagSduiOptionSelectorAnchorTag and anchorTags then
				local anchorTag = if v13 then v13.anchorTag else nil

				if anchorTag == "" then
					anchorTag = nil
				end

				anchorTags[k] = anchorTag
			end

			local clone = table.clone(optionItemConfig)

			local join = Cryo.Dictionary.join
			local props2 = optionItemConfig.props or {}
			local v14 = {
				isChecked = id ~= nil and id == v6,
				onActivated = 0
			}

			function v14.onActivated()
				v10(id)
			end

			clone.props = join(props2, v14)

			table.insert(clones, clone)
		end

		if fFlagSduiOptionSelectorAnchorTag then
			return clones, anchorTags
		end

		return clones, nil
	end, { props.optionItemConfigs, props.optionsData, v6, v10 })

	local v13 = React.useMemo(function()
		local extraLocalProps = props.collectionComponent.props
			and props.collectionComponent.props.extraLocalProps
			or {}

		return React.cloneElement(props.collectionComponent, {
			extraLocalProps = Cryo.Dictionary.join(extraLocalProps, {
				index = props.index,
				scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = props.verticalScrollingFrameRef,
				selectionOrderBase = props.selectionOrderBase,
				startRow = props.startRow,
				numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions,
				appCompositionEnabled = props.appCompositionEnabled
			})
		})
	end, {
		props.collectionComponent,
		props.index,
		props.scrollViewPositionChangedSignal,
		props.verticalScrollingFrameRef,
		props.selectionOrderBase,
		props.startRow,
		props.numUpdatesToDelayImpressions,
		props.appCompositionEnabled
	})

	local createElement = React.createElement
	local v15 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.fromScale(1, 0)
	}
	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, paddingBetweenOptionSelectorAndCollection)
		}),
		OptionSelector = 0,
		Collection = 0
	}

	local createElement2 = React.createElement
	local v17 = {
		sduiContext = sduiContext,
		analyticsContext = props.analyticsContext,
		componentConfig = props.componentConfig,
		debugName = 0,
		index = 0,
		layoutOrder = 1,
		impressionEventName = 0,
		skipItemImpressionsLog = 0,
		scrollViewPositionChangedSignal = 0,
		verticalScrollingFrameRef = 0,
		selectionOrderBase = 0,
		startRow = 0,
		numUpdatesToDelayImpressions = 0,
		appCompositionEnabled = 0,
		items = 0,
		itemTags = 0,
		itemHeight = 0,
		itemPadding = 0,
		sideMargin = 0,
		scrollButtonsEnabled = 0,
		headerComponent = 0,
		title = 0
	}
	local v18 = if props.debugName then `{props.debugName}.OptionSelector` else nil
	v17.debugName = v18
	v17.index = props.index

	local v19 = if fFlagSduiOptionImpressionsEventName then props.optionImpressionEventName else nil
	v17.impressionEventName = v19

	local v20 = if fFlagSduiOptionImpressionsEventName then props.skipOptionItemImpressionsLog else nil
	v17.skipItemImpressionsLog = v20

	v17.scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	v17.verticalScrollingFrameRef = props.verticalScrollingFrameRef
	v17.selectionOrderBase = props.selectionOrderBase
	v17.startRow = props.startRow
	v17.numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions
	v17.appCompositionEnabled = props.appCompositionEnabled

	v17.items = v11

	if not fFlagSduiOptionSelectorAnchorTag then
		v12 = nil
	end

	v17.itemTags = v12
	v17.itemHeight = props.itemHeight
	v17.itemPadding = props.itemPadding

	v17.scrollButtonsEnabled = props.scrollButtonsEnabled
	local v21 = if fFlagSduiOptionSelectorHeaderComponent then props.headerComponent else nil
	v17.headerComponent = v21
	v17.title = props.title
	children.OptionSelector = createElement2(SduiVariableItemWidthCarousel, v17)

	children.Collection = React.createElement(sduiPlaceholderWrapper, {
		isPlaceholder = state ~= nil,
		layoutOrder = 2,
		transitionDurationSeconds = props.placeholderTransitionDurationSeconds,
		mountRealDuringPlaceholder = false,
		real = v13,
		placeholder = props.placeholderCollectionComponent
	})
	return createElement("Frame", v15, children)
end

return React.memo(SduiOptionSelectorCollection)
