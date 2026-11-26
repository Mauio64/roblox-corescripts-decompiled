local module = require("@luauforge/deferred/eko")
local module2 = require("@luauforge/deferred/fdc")
local useSignalState = require("@luauforge/deferred/eky").useSignalState

local useBatchedImpressions = module2.useBatchedImpressions

local module3 = require("@luauforge/deferred/fdh")
local module4 = require("@luauforge/deferred/ele")
local module5 = require("@luauforge/deferred/eli")
local module6 = require("@luauforge/deferred/ekJ")
local useSchoolVerificationFlow = require("@luauforge/deferred/eln").useSchoolVerificationFlow
require("@luauforge/deferred/ekr")
local module7 = require("@luauforge/deferred/fbx")
local module8 = require("@luauforge/deferred/fbK")
local module9 = require("@luauforge/deferred/fbE")
local module10 = require("@luauforge/deferred/fdi")
local module11 = require("@luauforge/deferred/elp")
local module12 = require("@luauforge/deferred/fdn")

local eventNames = module7.EventNames

local function mapImpressionItem(p2, p3, p4)
	return { schoolId = p2 }
end

local function SchoolSelectionContainer(p2)
	local navigation = p2.navigation
	local v5 = useSchoolVerificationFlow()

	local v6 = module7.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module11 or not module9 then
			return nil
		end

		v6(eventNames.SchoolSelectionPageLoad)
		return nil
	end, { v6 })

	local v7 = useSignalState(v5.getSchools)

	local v9 = module4({
		schools = module.useMemo(function()
			local result = table.create(#v7)

			for k, v9 in v7 do
				table.insert(result, module6.schoolToListItem(v9))
			end

			return result
		end, { v7 })
	})

	local state, setState = module.useState(nil)
	local state2, setState2 = module.useState(false)

	local ref = if module10 then module.useRef(false) else nil
	local ref2 = if module10 then module.useRef(false) else nil

	local ref3 = if module10 then module.useRef(v6) else nil

	if ref3 then
		ref3.current = v6
	end

	local v10

	if module10 then
		v10 = useBatchedImpressions({
			batchTimeMs = module12,
			mapItem = mapImpressionItem,
			onFlush = module9 and function(list, p3)
				local schoolIds = table.create(#list)

				for k, item in list do
					table.insert(schoolIds, item.schoolId)
				end

				ref3.current(eventNames.SchoolSelectionSchoolImpression, {
					schoolIds = table.concat(schoolIds, ",")
				})
			end or nil
		})
	else
		v10 = nil
	end

	local function fn(p3, p4)
		if module10 and module9 and v10 then
			v10.addImpression(p3, p4)
		end
	end

	local v13 = module.useCallback(fn, { if v10 then v10.addImpression else nil })

	local v14 = module.useCallback(function()
		if module10 and ref2 then
			ref2.current = true
		end
	end, {})

	local v15 = module.useCallback(function(p3)
		if module10 and module9 and ref and v9.query ~= "" then
			ref.current = true
			v6(eventNames.SchoolSelectionSearchPerformed, { searchQuery = v9.query })
		end
	end, { v9.query, v6 })

	local v16 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local v17 = module.useCallback(function(p3)
		setState(p3)

		if p3 == nil then
			return
		end

		if module9 then
			local v18 = nil

			v18 = module10 and ref and ref2 and {
				didSearch = ref.current,
				didScroll = ref2.current,
				schoolCount = #v7
			} or v18

			v6(eventNames.SchoolSelectionSchoolClick, v18)
		end

		for k, v18 in v7 do
			if v18.schoolId == p3 then
				v5.setSelectedSchool(v18)
				navigation.navigate(module5.GraduationYear)
				break
			end
		end
	end, { v5, navigation, v7, v6 })

	local v18 = module.useCallback(function()
		if module9 then
			v6(eventNames.SchoolSelectionCantFindSchoolClick)
		end

		setState2(true)
	end, { v6 })

	local v19 = module.useCallback(function()
		setState2(false)
	end, {})

	local createElement = module.createElement
	local v21 = {
		onBack = v16,
		schools = v9.schools,
		selectedSchoolId = state,
		onSchoolSelected = v17,
		query = v9.query,
		onQueryChanged = v9.setQuery,
		onSearchFocusLost = 0,
		onSchoolImpression = 0,
		onScrollStarted = 0,
		onCantFindSchool = 0,
		isCantFindSchoolOpen = 0,
		onDismissCantFindSchool = 0
	}

	if not module10 then
		v15 = nil
	end

	v21.onSearchFocusLost = v15

	if not module10 then
		v13 = nil
	end

	v21.onSchoolImpression = v13

	if not module10 then
		v14 = nil
	end

	v21.onScrollStarted = v14
	v21.onCantFindSchool = v18
	v21.isCantFindSchoolOpen = state2
	v21.onDismissCantFindSchool = v19
	local element = createElement(module3, v21)

	if module11 and module9 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module8, {
				eventName = eventNames.SchoolSelectionPageLoad,
				fields = {
					schoolMatchCount = #v7
				}
			}),
			Page = element
		})
	end

	return element
end

return SchoolSelectionContainer
