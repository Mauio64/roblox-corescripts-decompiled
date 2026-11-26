local module = require("@luauforge/deferred/gzV")
local generatePages = require("@luauforge/deferred/gzZ").generatePages
local module2 = require("@luauforge/deferred/gzW")

local module3 = require("@luauforge/deferred/gAe")
require("@luauforge/deferred/gzP")
local useNotApprovedPageContext = require("@luauforge/deferred/gAo").useNotApprovedPageContext

local module4 = require("@luauforge/deferred/gzS")
local useMemo = module4.useMemo
local useState = module4.useState
local useCallback = module4.useCallback
local useContext = module4.useContext
local createContext = module4.createContext

local module5 = require("@luauforge/deferred/gAW")

local STATIC_PAGE_NAMES = module2.STATIC_PAGE_NAMES

local context = createContext({})

return {
	PageNavigationProvider = function(p2)
		local state, setState = useState(1)
		local state2, setState2 = useState(false)

		local v5 = useNotApprovedPageContext()
		local untranslatedReasons = v5.violationReasons.untranslatedReasons
		local commutationEligibility = v5.commutationEligibility
		local isKidsTreatment = v5.isKidsTreatment

		local v6 = useMemo(function()
			return generatePages(
				p2.moderationDetail,
				untranslatedReasons,
				commutationEligibility,
				isKidsTreatment
			)
		end, {
			p2.moderationDetail,
			untranslatedReasons,
			commutationEligibility,
			isKidsTreatment
		})

		local pages = v6.pages
		local unmappedViolationKeys = v6.unmappedViolationKeys
		local count = #pages

		local page = pages[state]
		local v7 = if page then page.pageName else STATIC_PAGE_NAMES.Unknown

		local v8 = if commutationEligibility then commutationEligibility.educational_pass_eligible else false

		local v9 = useCallback(function()
			if state < count then
				if module5 then
					setState2(true)
				end

				setState(function(p3)
					return p3 + 1
				end)
			end
		end, { state, count })

		local v10 = useCallback(function()
			if state > 1 then
				setState(function(p3)
					return p3 - 1
				end)
			end
		end, { state })
		local v11 = state == 1
		local v12 = state == count
		local v13 = useCallback(function()
			if count <= 1 or v7 == STATIC_PAGE_NAMES.Intro or v7 == STATIC_PAGE_NAMES.SecondChanceIntro then
				return 0
			end

			local v14 = count - 1
			local v15 = state - 1

			if v8 then
				v14 -= 1
				v15 -= 1
			end

			if v14 <= 0 then
				return 0
			end

			return (math.round(v15 / v14 * 100))
		end, { state, count, v7, v8 })

		local v14 = useMemo(function(): boolean
			for k, untranslatedReason in untranslatedReasons do
				if module3(untranslatedReason, isKidsTreatment) then
					return true
				end
			end

			return false
		end, { untranslatedReasons, isKidsTreatment })

		local v15 = useMemo(function()
			local v16 = {
				currentPage = state,
				currentPageName = v7,
				totalPages = count,
				goToNextPage = v9,
				goToPreviousPage = v10,
				isFirstPage = v11,
				isLastPage = v12,
				getProgress = v13,
				hasEducationalPages = v14,
				hasNavigatedForward = if module5 then state2 else false,
				currentPageConfigs = not page and {} or page.pageItems,
				CurrentCtaComponent = 0,
				unmappedViolationKeys = 0
			}
			local v18 = if page then page.CtaComponent else nil
			v16.CurrentCtaComponent = v18
			v16.unmappedViolationKeys = unmappedViolationKeys
			return v16
		end, {
			state,
			count,
			v7,
			v9,
			v10,
			v11,
			v12,
			v13,
			pages,
			v14,
			state2,
			unmappedViolationKeys,
			page
		})

		return module4.createElement(context.Provider, { value = v15 }, p2.children)
	end,
	usePageNavigation = function()
		local v5 = useContext(context)

		module.assert(
			v5 and v5.currentPage ~= nil,
			"usePageNavigation must be used within PageNavigationProvider"
		)

		return v5
	end
}
