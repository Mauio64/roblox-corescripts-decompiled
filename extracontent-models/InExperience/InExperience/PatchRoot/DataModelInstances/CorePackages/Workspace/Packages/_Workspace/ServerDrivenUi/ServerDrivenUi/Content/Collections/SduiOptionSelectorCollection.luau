local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiSharedContent = require(parent.SduiSharedContent)
local SduiPlaceholderWrapper = SduiSharedContent.SduiPlaceholderWrapper

local SduiVariableItemWidthCarousel = require(ServerDrivenUi.Content.Collections.SduiVariableItemWidthCarousel)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiOptionImpressionsEventName = SharedFlags.FFlagSduiOptionImpressionsEventName
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSduiOptionSelectorHeaderComponent = SharedFlags2.FFlagSduiOptionSelectorHeaderComponent
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiChartsSortDetailGenreFilter = SharedFlags3.FFlagSduiChartsSortDetailGenreFilter
local SharedFlags4 = require(parent.SharedFlags)
local FFlagSduiOptionSelectorAnchorTag = SharedFlags4.FFlagSduiOptionSelectorAnchorTag
local defineFastFlag = game:DefineFastFlag("LuaAppNilCheckOptionItemConfigs", false)

local function SduiOptionSelectorCollection(props)
	local sduiContext = props.sduiContext

	local v = useTokens()
	local paddingBetweenOptionSelectorAndCollection = props.paddingBetweenOptionSelectorAndCollection or v.Size.Size_400

	local state, setState = React.useState(nil)

	local v2 = state or props.selectedOption

	local ref = React.useRef(0)

	React.useEffect(function()
		setState(nil)
	end, { props.selectedOption })

	local v3 = React.useCallback(function(selectedOption)
		if typeof(selectedOption) ~= "string" or selectedOption == "" then
			sduiContext.dependencies.logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiComponentType.OptionSelectorCollection,
					message = `Invalid or missing option id: {selectedOption}`,
					propName = "optionId"
				},
				sduiContext.appPage
			)
			return
		end

		if state == selectedOption then
			return
		end

		local current

		if FFlagSduiChartsSortDetailGenreFilter then
			current = nil
		else
			setState(selectedOption)

			ref.current += 1
			current = ref.current
		end

		local v3 = props.onOptionActivated(nil, nil, { selectedOption = selectedOption })

		if FFlagSduiChartsSortDetailGenreFilter then
			if v3 == nil then
				return
			end

			setState(selectedOption)

			ref.current += 1
			current = ref.current
		end

		if typeof(v3) == "table" and typeof(v3.finally) == "function" then
			v3:finally(function()
				if ref.current == current then
					setState(nil)
				end
			end)
			return
		end

		sduiContext.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiComponentType.OptionSelectorCollection,
				message = "onOptionActivated did not return a refresh promise",
				propName = "onOptionActivated"
			},
			sduiContext.appPage
		)
		setState(nil)
	end, { props.onOptionActivated, sduiContext, state, ref })

	local items, itemTags = React.useMemo(function()
		if defineFastFlag and not (props.optionItemConfigs and props.optionsData) then
			sduiContext.dependencies.logger.reportError(SduiErrorType.InvalidProps, {
				componentType = SduiComponentType.OptionSelectorCollection,
				message = `Missing {props.optionItemConfigs and "optionsData" or "optionItemConfigs"} prop`,
				propName = props.optionItemConfigs and "optionsData" or "optionItemConfigs"
			}, sduiContext.appPage)

			return {}
		end

		local anchorTags = FFlagSduiOptionSelectorAnchorTag and {} or nil
		local clones = {}

		for k, optionItemConfig in props.optionItemConfigs do
			local v4 = props.optionsData[k]
			local id

			if v4 then
				id = v4.id
			else
				id = nil
			end

			if FFlagSduiOptionSelectorAnchorTag and anchorTags then
				local anchorTag

				if v4 then
					anchorTag = v4.anchorTag
				end

				if anchorTag == "" then
					anchorTag = nil
				end

				anchorTags[k] = anchorTag
			end

			local clone = table.clone(optionItemConfig)

			local join = Cryo.Dictionary.join
			local props2 = optionItemConfig.props or {}
			local v5 = {
				isChecked = id ~= nil and id == v2,
				onActivated = 0
			}

			function v5.onActivated()
				v3(id)
			end

			clone.props = join(props2, v5)

			table.insert(clones, clone)
		end

		if FFlagSduiOptionSelectorAnchorTag then
			return clones, anchorTags
		end

		return clones, nil
	end, { props.optionItemConfigs, props.optionsData, v2, v3 })

	local real = React.useMemo(function()
		local extraLocalProps = props.collectionComponent.props and props.collectionComponent.props.extraLocalProps
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
	local v4 = {
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
	local v5 = {
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
	local debugName

	if props.debugName then
		debugName = `{props.debugName}.OptionSelector`
	end

	v5.debugName = debugName
	v5.index = props.index
	local impressionEventName

	if FFlagSduiOptionImpressionsEventName then
		impressionEventName = props.optionImpressionEventName
	end

	v5.impressionEventName = impressionEventName
	local skipItemImpressionsLog

	if FFlagSduiOptionImpressionsEventName then
		skipItemImpressionsLog = props.skipOptionItemImpressionsLog
	end

	v5.skipItemImpressionsLog = skipItemImpressionsLog

	v5.scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal
	v5.verticalScrollingFrameRef = props.verticalScrollingFrameRef
	v5.selectionOrderBase = props.selectionOrderBase
	v5.startRow = props.startRow
	v5.numUpdatesToDelayImpressions = props.numUpdatesToDelayImpressions
	v5.appCompositionEnabled = props.appCompositionEnabled

	v5.items = items

	if not FFlagSduiOptionSelectorAnchorTag then
		itemTags = nil
	end

	v5.itemTags = itemTags
	v5.itemHeight = props.itemHeight
	v5.itemPadding = props.itemPadding

	v5.scrollButtonsEnabled = props.scrollButtonsEnabled
	local headerComponent

	if FFlagSduiOptionSelectorHeaderComponent then
		headerComponent = props.headerComponent
	end

	v5.headerComponent = headerComponent
	v5.title = props.title
	children.OptionSelector = createElement2(SduiVariableItemWidthCarousel, v5)

	children.Collection = React.createElement(SduiPlaceholderWrapper, {
		isPlaceholder = state ~= nil,
		layoutOrder = 2,
		transitionDurationSeconds = props.placeholderTransitionDurationSeconds,
		mountRealDuringPlaceholder = false,
		real = real,
		placeholder = props.placeholderCollectionComponent
	})
	return createElement("Frame", v4, children)
end

return React.memo(SduiOptionSelectorCollection)
