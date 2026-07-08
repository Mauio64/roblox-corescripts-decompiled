local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Cryo = require(ServerDrivenUiParent.Cryo)
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiComponentType = SduiCoreSystem.SduiComponentType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiPlaceholderWrapper = require(ServerDrivenUiParent.SduiSharedContent).SduiPlaceholderWrapper
local SduiVariableItemWidthCarousel = require(ServerDrivenUi.Content.Collections.SduiVariableItemWidthCarousel)
local FFlagSduiOptionImpressionsEventName = require(ServerDrivenUiParent.SharedFlags).FFlagSduiOptionImpressionsEventName

local function SduiOptionSelectorCollection(t1: {[any]: any}) -- line: 65
	-- upvalues: useTokens (copy), React (copy), SduiErrorType (copy), SduiComponentType (copy), Cryo (copy), SduiVariableItemWidthCarousel (copy), FFlagSduiOptionImpressionsEventName (copy), SduiPlaceholderWrapper (copy)
	local sduiContext = t1.sduiContext
	local v15 = useTokens()
	local v16 = t1.paddingBetweenOptionSelectorAndCollection or v15.Size.Size_400
	local v17, v18 = React.useState(nil)
	local v19 = v17 or t1.selectedOption
	local v20 = React.useRef(0)

	React.useEffect(function() -- line: 79
		-- upvalues: v18 (copy)
		v18(nil)
	end, { t1.selectedOption })

	local v21 = React.useCallback(function(p1) -- line: 83
		-- upvalues: sduiContext (copy), SduiErrorType (copy), SduiComponentType (copy), v17 (copy), v18 (copy), v20 (copy), t1 (copy)
		if typeof(p1) ~= "string" or p1 == "" then
			sduiContext.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				propName = "optionId",
				name = SduiComponentType.OptionSelectorCollection,
				message = `Invalid or missing option id: { p1 }`
			}, sduiContext.appPage)

			return
		end

		if p1 == v17 then
			return
		end

		v18(p1)

		local v25 = v20

		v25.current = v25.current + 1

		local current = v20.current
		local v27 = t1.onOptionActivated(nil, nil, {
			selectedOption = p1
		})

		if typeof(v27) ~= "table" or typeof(v27.finally) ~= "function" then
			sduiContext.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
				message = "onOptionActivated did not return a refresh promise",
				propName = "onOptionActivated",
				name = SduiComponentType.OptionSelectorCollection
			}, sduiContext.appPage)
			v18(nil)

			return
		end

		v27:finally(function() -- line: 117
			-- upvalues: v20 (copy), current (copy), v18 (copy)
			if v20.current == current then
				v18(nil)
			end
		end)
	end, {
		t1.onOptionActivated,
		sduiContext,
		v17,
		v20
	})
	local v22 = React.useMemo(function() -- line: 125
		-- upvalues: t1 (copy), Cryo (copy), v19 (copy), v21 (copy)
		local t2 = {}

		for v29, v30 in t1.optionItemConfigs do
			local v31 = t1.optionsData[v29]
			local v32 = if not v31 then nil else v31.id
			local v33 = table.clone(v30)

			v33.props = Cryo.Dictionary.join(v30.props or {}, {
				isChecked = v32 ~= nil and v32 == v19,
				onActivated = function() -- line: 137
					-- upvalues: v21 (copy), v32 (copy)
					v21(v32)
				end
			})
			table.insert(t2, v33)
		end

		return t2
	end, {
		t1.optionItemConfigs,
		t1.optionsData,
		v19,
		v21
	})
	local v23 = React.useMemo(function() -- line: 149
		-- upvalues: t1 (copy), React (copy), Cryo (copy)
		local v34 = t1.collectionComponent.props and t1.collectionComponent.props.extraLocalProps or {}

		return React.cloneElement(t1.collectionComponent, {
			extraLocalProps = Cryo.Dictionary.join(v34, {
				index = t1.index,
				scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
				verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
				selectionOrderBase = t1.selectionOrderBase,
				startRow = t1.startRow,
				numUpdatesToDelayImpressions = t1.numUpdatesToDelayImpressions,
				appCompositionEnabled = t1.appCompositionEnabled
			})
		})
	end, {
		t1.collectionComponent,
		t1.index,
		t1.scrollViewPositionChangedSignal,
		t1.verticalScrollingFrameRef,
		t1.selectionOrderBase,
		t1.startRow,
		t1.numUpdatesToDelayImpressions,
		t1.appCompositionEnabled
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder,
		Size = UDim2.fromScale(1, 0)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v16)
		}),
		OptionSelector = React.createElement(SduiVariableItemWidthCarousel, {
			layoutOrder = 1,
			sideMargin = 0,
			sduiContext = sduiContext,
			analyticsContext = t1.analyticsContext,
			componentConfig = t1.componentConfig,
			debugName = if not t1.debugName then nil else `{ t1.debugName }.OptionSelector`,
			index = t1.index,
			impressionEventName = if not FFlagSduiOptionImpressionsEventName then nil else t1.optionImpressionEventName,
			skipItemImpressionsLog = if not FFlagSduiOptionImpressionsEventName then nil else t1.skipOptionItemImpressionsLog,
			scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
			selectionOrderBase = t1.selectionOrderBase,
			startRow = t1.startRow,
			numUpdatesToDelayImpressions = t1.numUpdatesToDelayImpressions,
			appCompositionEnabled = t1.appCompositionEnabled,
			items = v22,
			itemHeight = t1.itemHeight,
			itemPadding = t1.itemPadding,
			scrollButtonsEnabled = t1.scrollButtonsEnabled,
			title = t1.title
		}),
		Collection = React.createElement(SduiPlaceholderWrapper, {
			layoutOrder = 2,
			mountRealDuringPlaceholder = false,
			isPlaceholder = v17 ~= nil,
			transitionDurationSeconds = t1.placeholderTransitionDurationSeconds,
			real = v23,
			placeholder = t1.placeholderCollectionComponent
		})
	})
end

return React.memo(SduiOptionSelectorCollection)
