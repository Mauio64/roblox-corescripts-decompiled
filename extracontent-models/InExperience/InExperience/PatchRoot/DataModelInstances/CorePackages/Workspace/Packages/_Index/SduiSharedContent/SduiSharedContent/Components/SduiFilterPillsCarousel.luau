local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local Cryo = require(Parent.Cryo)
local React = require(Parent.React)
local View = require(Parent.Foundation).View

require(Parent.SduiCompat)
require(Parent.DiscoveryTypes)

local GameFilters = require(Parent.GameFilters)
local FilterPillCarousel = GameFilters.FilterPillCarousel
local getOptionContextTag = GameFilters.getOptionContextTag

require(Parent.UnifiedLogging)

local SduiCoreSystem = require(Parent.SduiCoreSystem)
local reportUnifiedLoggingImpressions = SduiCoreSystem.reportUnifiedLoggingImpressions
local SduiComponentType = SduiCoreSystem.SduiComponentType
local useCollectionAnalyticsContext = require(script.Parent.useCollectionAnalyticsContext)

local function buildSelectionsFromGroups(t1: {[any]: any}?) -- line: 66
	local t2 = {}

	if not t1 then
		return t2
	end

	for _, v18 in t1 do
		if v18.filterType and v18.filterType ~= "" then
			t2[v18.filterType] = v18.selectedOptionId or v18.defaultOptionId
		end
	end

	return t2
end
local function convertToFilterModel(t3: {[any]: any}, s1: string) -- line: 79
	local displayName = t3.displayName
	local t4 = {}

	for _, v24 in t3.options do
		table.insert(t4, {
			optionId = v24.optionId,
			optionDisplayName = v24.displayName,
			optionContextTag = v24.optionContextTag
		})

		if s1 == v24.optionId then
			displayName = v24.displayName
		end
	end

	local t5 = nil

	if t3.inactiveOptionIds and #t3.inactiveOptionIds > 0 then
		t5 = {}

		for _, v27 in t3.inactiveOptionIds do
			t5[v27] = true
		end
	end

	return {
		filterId = t3.filterId,
		filterType = t3.filterType or "",
		filterDisplayName = t3.displayName,
		filterOptions = t4,
		defaultOptionId = t3.defaultOptionId,
		selectedOptionId = s1,
		selectedOptionDisplayName = displayName,
		inactiveOptionIds = t5
	}
end
local function SduiFilterPillsCarousel(t6: {[any]: any}) -- line: 117
	-- upvalues: React (copy), buildSelectionsFromGroups (copy), convertToFilterModel (copy), useCollectionAnalyticsContext (copy), SduiComponentType (copy), getOptionContextTag (copy), reportUnifiedLoggingImpressions (copy), Cryo (copy), View (copy), FilterPillCarousel (copy)
	local filterGroups = t6.filterGroups
	local sduiContext = t6.sduiContext
	local analyticsContext = t6.analyticsContext
	local v32, v33 = React.useState(function() -- line: 122
		-- upvalues: buildSelectionsFromGroups (copy), filterGroups (copy)
		return (buildSelectionsFromGroups(filterGroups))
	end)

	React.useEffect(function() -- line: 126
		-- upvalues: filterGroups (copy), v33 (copy), buildSelectionsFromGroups (copy)
		if filterGroups then
			v33((buildSelectionsFromGroups(filterGroups)))
		end
	end, { filterGroups })

	local v34 = React.useRef(nil)
	local v35 = React.useMemo(function() -- line: 134
		-- upvalues: filterGroups (copy), v32 (copy), convertToFilterModel (copy)
		if not filterGroups then
			return {}
		end

		local t7 = {}

		for _, v45 in filterGroups do
			local v46 = v45.filterType or ""
			local v47 = if v46 == "" then nil else v32[v46]

			table.insert(t7, (convertToFilterModel(v45, v47 or v45.defaultOptionId)))
		end

		return t7
	end, {
		filterGroups,
		v32
	})
	local _, v37 = useCollectionAnalyticsContext(analyticsContext, SduiComponentType.FilterPillsCarousel, #v35, #v35, sduiContext, nil)
	local v38 = React.useMemo(function() -- line: 156
		-- upvalues: v35 (copy), getOptionContextTag (copy)
		local t8 = {}

		for v49, v50 in v35 do
			table.insert(t8, {
				itemComponentType = "FilterPill",
				id = v50.filterId,
				itemPosition = v49,
				filterId = v50.filterId,
				selectedOptionId = v50.selectedOptionId or "",
				selectedOptionContextTag = getOptionContextTag(v50, v50.selectedOptionId)
			})
		end

		return t8
	end, { v35 })
	local v39 = React.useCallback(function(t9: {[any]: any}) -- line: 173
		-- upvalues: reportUnifiedLoggingImpressions (copy), sduiContext (copy), v38 (copy), v37 (copy), t6 (copy)
		reportUnifiedLoggingImpressions(sduiContext, t9, v38, v37.current, nil, t6.impressionEventName, t6.skipItemImpressionsLog)
	end, {
		sduiContext,
		v38,
		v37,
		t6.impressionEventName,
		t6.skipItemImpressionsLog
	})
	local v40 = React.useCallback(function(s2: string, s3: string, s4: string, s5: string?, s6: string?, s7: string?, b1: boolean?) -- line: 194
		-- upvalues: t6 (copy)
		if t6.onFilterClick then
			t6.onFilterClick(nil, nil, {
				buttonName = s2,
				filterId = s3,
				selectedOptionId = s4,
				previousOptionId = s5,
				selectedOptionContextTag = s6,
				previousOptionContextTag = s7,
				isActive = b1
			})
		end
	end, { t6.onFilterClick })
	local v41 = React.useCallback(function(s8: string, s9: string) -- line: 218
		-- upvalues: v33 (copy), Cryo (copy), t6 (copy)
		v33(function(p1) -- line: 219
			-- upvalues: Cryo (copy), s8 (copy), s9 (copy), t6 (copy)
			local v62 = Cryo.Dictionary.join(p1, {
				[s8] = s9
			})

			if t6.onFilterApplied then
				t6.onFilterApplied(nil, nil, {
					filterSelections = v62
				})
			end

			return v62
		end)
	end, { t6.onFilterApplied })
	local v42 = not v37.current and 0 or v37.current.collectionPosition

	if not filterGroups or #filterGroups == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = t6.tag,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		backgroundStyle = t6.backgroundStyle
	}, {
		Content = React.createElement(FilterPillCarousel, {
			title = t6.title,
			filters = v35,
			sortIndex = v42,
			onFilterApplied = v41,
			containerRef = v34,
			pageContext = sduiContext.routeName or sduiContext.appPage,
			dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp,
			scrollViewPositionChangedSignal = t6.scrollViewPositionChangedSignal,
			sendImpressions = v39,
			sendFilterClick = v40
		})
	})
end

return React.memo(SduiFilterPillsCarousel)
