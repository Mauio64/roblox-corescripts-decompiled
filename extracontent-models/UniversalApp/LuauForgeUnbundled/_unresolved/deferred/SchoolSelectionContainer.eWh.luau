local module = require("@luauforge/deferred/egU")
local module2 = require("@luauforge/deferred/eWd")
local useSignalState = require("@luauforge/deferred/ehe").useSignalState

local useBatchedImpressions = module2.useBatchedImpressions

local module3 = require("@luauforge/deferred/eWi")
local module4 = require("@luauforge/deferred/ehK")
local module5 = require("@luauforge/deferred/ehO")
local module6 = require("@luauforge/deferred/ehp")
local useSchoolVerificationFlow = require("@luauforge/deferred/ehT").useSchoolVerificationFlow
require("@luauforge/deferred/egX")
local module7 = require("@luauforge/deferred/eUy")
local module8 = require("@luauforge/deferred/eUL")
local module9 = require("@luauforge/deferred/eUF")
local module10 = require("@luauforge/deferred/eWj")
local module11 = require("@luauforge/deferred/ehV")
local module12 = require("@luauforge/deferred/eWo")

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

	local v8 = module4({
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

	local v9

	if module10 then
		v9 = useBatchedImpressions({
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
		v9 = nil
	end

	local function fn(p3, p4)
		if module10 and module9 and v9 then
			v9.addImpression(p3, p4)
		end
	end

	local v12 = module.useCallback(fn, { if v9 then v9.addImpression else nil })

	local v13 = module.useCallback(function()
		if module10 and ref2 then
			ref2.current = true
		end
	end, {})

	local v14 = module.useCallback(function(p3)
		if module10 and module9 and ref and v8.query ~= "" then
			ref.current = true
			v6(eventNames.SchoolSelectionSearchPerformed, { searchQuery = v8.query })
		end
	end, { v8.query, v6 })

	local v15 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local v16 = module.useCallback(function(p3)
		setState(p3)

		if p3 == nil then
			return
		end

		if module9 then
			local v17 = nil

			v17 = module10 and ref and ref2 and {
				didSearch = ref.current,
				didScroll = ref2.current,
				schoolCount = #v7
			} or v17

			v6(eventNames.SchoolSelectionSchoolClick, v17)
		end

		for k, v17 in v7 do
			if v17.schoolId == p3 then
				v5.setSelectedSchool(v17)
				navigation.navigate(module5.GraduationYear)
				break
			end
		end
	end, { v5, navigation, v7, v6 })

	local v17 = module.useCallback(function()
		if module9 then
			v6(eventNames.SchoolSelectionCantFindSchoolClick)
		end

		setState2(true)
	end, { v6 })

	local v18 = module.useCallback(function()
		setState2(false)
	end, {})

	local createElement = module.createElement
	local v20 = {
		onBack = v15,
		schools = v8.schools,
		selectedSchoolId = state,
		onSchoolSelected = v16,
		query = v8.query,
		onQueryChanged = v8.setQuery,
		onSearchFocusLost = 0,
		onSchoolImpression = 0,
		onScrollStarted = 0,
		onCantFindSchool = 0,
		isCantFindSchoolOpen = 0,
		onDismissCantFindSchool = 0
	}

	if not module10 then
		v14 = nil
	end

	v20.onSearchFocusLost = v14

	if not module10 then
		v12 = nil
	end

	v20.onSchoolImpression = v12

	if not module10 then
		v13 = nil
	end

	v20.onScrollStarted = v13
	v20.onCantFindSchool = v17
	v20.isCantFindSchoolOpen = state2
	v20.onDismissCantFindSchool = v18
	local element = createElement(module3, v20)

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
