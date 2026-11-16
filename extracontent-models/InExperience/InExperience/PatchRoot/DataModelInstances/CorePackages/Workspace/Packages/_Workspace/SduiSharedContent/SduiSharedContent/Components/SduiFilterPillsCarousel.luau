local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
require(parent.SduiCompat)

require(parent.DiscoveryTypes)
local GameFilters = require(parent.GameFilters)
local FilterPillCarousel = GameFilters.FilterPillCarousel
local getOptionContextTag = GameFilters.getOptionContextTag

require(parent.UnifiedLogging)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiComponentType = SduiCoreSystem.SduiComponentType

local useCollectionAnalyticsContext = require(script.Parent.useCollectionAnalyticsContext)

local function buildSelectionsFromGroups(filterGroups)
	local selectedOptionIdsByFilterType = {}

	if not filterGroups then
		return selectedOptionIdsByFilterType
	end

	for _, item in filterGroups do
		if item.filterType and item.filterType ~= "" then
			selectedOptionIdsByFilterType[item.filterType] = item.selectedOptionId or item.defaultOptionId
		end
	end

	return selectedOptionIdsByFilterType
end

local function convertToFilterModel(filterGroup, selectedOptionId: string)
	local displayName = filterGroup.displayName
	local filterOptions = {}

	for _, option in filterGroup.options do
		table.insert(filterOptions, {
			optionId = option.optionId,
			optionDisplayName = option.displayName,
			optionContextTag = option.optionContextTag
		})

		if option.optionId == selectedOptionId then
			displayName = option.displayName
		end
	end

	local inactiveOptionIdSet

	if filterGroup.inactiveOptionIds and #filterGroup.inactiveOptionIds > 0 then
		inactiveOptionIdSet = {}

		for _, inactiveOptionId in filterGroup.inactiveOptionIds do
			inactiveOptionIdSet[inactiveOptionId] = true
		end
	end

	return {
		filterId = filterGroup.filterId,
		filterType = filterGroup.filterType or "",
		filterDisplayName = filterGroup.displayName,
		filterOptions = filterOptions,
		defaultOptionId = filterGroup.defaultOptionId,
		selectedOptionId = selectedOptionId,
		selectedOptionDisplayName = displayName,
		inactiveOptionIds = inactiveOptionIdSet
	}
end

local function SduiFilterPillsCarousel(props)
	local filterGroups = props.filterGroups
	local sduiContext = props.sduiContext
	local analyticsContext = props.analyticsContext

	local state, setState = React.useState(function()
		return buildSelectionsFromGroups(filterGroups)
	end)

	React.useEffect(function()
		if filterGroups then
			setState(buildSelectionsFromGroups(filterGroups))
		end
	end, { filterGroups })

	local ref = React.useRef(nil)

	local filters = React.useMemo(function()
		if not filterGroups then
			return {}
		end

		local result = {}

		for _, filterGroup in filterGroups do
			local filterType = filterGroup.filterType or ""
			local v

			if filterType ~= "" then
				v = state[filterType]
			end

			table.insert(result, convertToFilterModel(filterGroup, v or filterGroup.defaultOptionId))
		end

		return result
	end, { filterGroups, state })

	local _, v = useCollectionAnalyticsContext(
		analyticsContext,
		SduiComponentType.FilterPillsCarousel,
		#filters,
		#filters,
		sduiContext,
		nil
	)

	local v2 = React.useMemo(function()
		local result = {}

		for k, v2 in filters do
			table.insert(result, {
				id = v2.filterId,
				itemPosition = k,
				itemComponentType = "FilterPill",
				filterId = v2.filterId,
				selectedOptionId = v2.selectedOptionId or "",
				selectedOptionContextTag = getOptionContextTag(v2, v2.selectedOptionId)
			})
		end

		return result
	end, { filters })

	local sendImpressions = React.useCallback(function(p)
		reportUnifiedLoggingImpressions(
			sduiContext,
			p,
			v2,
			v.current,
			nil,
			props.impressionEventName,
			props.skipItemImpressionsLog
		)
	end, { sduiContext, v2, v, props.impressionEventName, props.skipItemImpressionsLog })

	local sendFilterClick = React.useCallback(
		function(buttonName: string, filterId: string, selectedOptionId: string, previousOptionId: string?, selectedOptionContextTag: string?, previousOptionContextTag: string?, isActive: boolean?)
			if props.onFilterClick then
				props.onFilterClick(nil, nil, {
					buttonName = buttonName,
					filterId = filterId,
					selectedOptionId = selectedOptionId,
					previousOptionId = previousOptionId,
					selectedOptionContextTag = selectedOptionContextTag,
					previousOptionContextTag = previousOptionContextTag,
					isActive = isActive
				})
			end
		end,
		{ props.onFilterClick }
	)

	local onFilterApplied = React.useCallback(function(p: string, p2: string)
		setState(function(p3)
			local joined = Cryo.Dictionary.join(p3, { [p] = p2 })

			if props.onFilterApplied then
				props.onFilterApplied(nil, nil, { filterSelections = joined })
			end

			return joined
		end)
	end, { props.onFilterApplied })

	local sortIndex = not v.current and 0 or v.current.collectionPosition

	if filterGroups and #filterGroups ~= 0 then
		return React.createElement(
			View,
			{
				tag = props.tag,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = props.backgroundStyle
			},
			{
				Content = React.createElement(FilterPillCarousel, {
					title = props.title,
					filters = filters,
					sortIndex = sortIndex,
					onFilterApplied = onFilterApplied,
					containerRef = ref,
					pageContext = sduiContext.routeName or sduiContext.appPage,
					dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp,
					scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
					sendImpressions = sendImpressions,
					sendFilterClick = sendFilterClick
				})
			}
		)
	end

	return nil
end

return React.memo(SduiFilterPillsCarousel)
