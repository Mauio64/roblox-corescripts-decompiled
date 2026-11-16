local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation").View
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryTypes")
local GameFilters = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/GameFilters")
local filterPillCarousel = GameFilters.FilterPillCarousel
local getOptionContextTag = GameFilters.getOptionContextTag

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UnifiedLogging")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local sduiComponentType = SduiCoreSystem.SduiComponentType

local useCollectionAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiSharedContent/Components/useCollectionAnalyticsContext")

local function buildSelectionsFromGroups(filterGroups)
	local selectedOptionIdsByFilterType = {}

	if not filterGroups then
		return selectedOptionIdsByFilterType
	end

	for k, item in filterGroups do
		if item.filterType and item.filterType ~= "" then
			selectedOptionIdsByFilterType[item.filterType] = item.selectedOptionId or item.defaultOptionId
		end
	end

	return selectedOptionIdsByFilterType
end

local function convertToFilterModel(filterGroup, p2)
	local displayName = filterGroup.displayName
	local v5 = {}

	for k, option in filterGroup.options do
		table.insert(v5, {
			optionId = option.optionId,
			optionDisplayName = option.displayName,
			optionContextTag = option.optionContextTag
		})

		if option.optionId == p2 then
			displayName = option.displayName
		end
	end

	local inactiveOptionIdSet

	if filterGroup.inactiveOptionIds and #filterGroup.inactiveOptionIds > 0 then
		inactiveOptionIdSet = {}

		for k, inactiveOptionId in filterGroup.inactiveOptionIds do
			inactiveOptionIdSet[inactiveOptionId] = true
		end
	end

	return {
		filterId = filterGroup.filterId,
		filterType = filterGroup.filterType or "",
		filterDisplayName = filterGroup.displayName,
		filterOptions = v5,
		defaultOptionId = filterGroup.defaultOptionId,
		selectedOptionId = p2,
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

	local v5 = React.useMemo(function()
		if not filterGroups then
			return {}
		end

		local result = {}

		for k, filterGroup in filterGroups do
			local filterType = filterGroup.filterType or ""
			local v6 = if filterType ~= "" then state[filterType] else nil
			table.insert(result, convertToFilterModel(filterGroup, v6 or filterGroup.defaultOptionId))
		end

		return result
	end, { filterGroups, state })

	local v6, v7 = useCollectionAnalyticsContext(
		analyticsContext,
		sduiComponentType.FilterPillsCarousel,
		#v5,
		#v5,
		sduiContext,
		nil
	)

	local v8 = React.useMemo(function()
		local result = {}

		for k, v9 in v5 do
			table.insert(result, {
				id = v9.filterId,
				itemPosition = k,
				itemComponentType = "FilterPill",
				filterId = v9.filterId,
				selectedOptionId = v9.selectedOptionId or "",
				selectedOptionContextTag = getOptionContextTag(v9, v9.selectedOptionId)
			})
		end

		return result
	end, { v5 })

	local v9 = React.useCallback(function(p2)
		reportUnifiedLoggingImpressions(
			sduiContext,
			p2,
			v8,
			v7.current,
			nil,
			props.impressionEventName,
			props.skipItemImpressionsLog
		)
	end, {
		sduiContext,
		v8,
		v7,
		props.impressionEventName,
		props.skipItemImpressionsLog
	})

	local v10 = React.useCallback(function(p2, p3, p4, p5, p6, p7, p8)
		if props.onFilterClick then
			props.onFilterClick(nil, nil, {
				buttonName = p2,
				filterId = p3,
				selectedOptionId = p4,
				previousOptionId = p5,
				selectedOptionContextTag = p6,
				previousOptionContextTag = p7,
				isActive = p8
			})
		end
	end, { props.onFilterClick })

	local v11 = React.useCallback(function(p2, p3)
		setState(function(p4)
			local joined = Cryo.Dictionary.join(p4, { [p2] = p3 })

			if props.onFilterApplied then
				props.onFilterApplied(nil, nil, { filterSelections = joined })
			end

			return joined
		end)
	end, { props.onFilterApplied })

	local v12 = not v7.current and 0 or v7.current.collectionPosition

	if filterGroups and #filterGroups ~= 0 then
		return React.createElement(
			view,
			{
				tag = props.tag,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = props.backgroundStyle
			},
			{
				Content = React.createElement(filterPillCarousel, {
					title = props.title,
					filters = v5,
					sortIndex = v12,
					onFilterApplied = v11,
					containerRef = ref,
					pageContext = sduiContext.routeName or sduiContext.appPage,
					dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp,
					scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
					sendImpressions = v9,
					sendFilterClick = v10
				})
			}
		)
	end

	return nil
end

return React.memo(SduiFilterPillsCarousel)
