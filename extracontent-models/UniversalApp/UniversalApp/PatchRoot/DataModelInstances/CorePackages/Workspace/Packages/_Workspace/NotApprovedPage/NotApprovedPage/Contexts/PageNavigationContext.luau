local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local STATIC_PAGE_NAMES = require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils).STATIC_PAGE_NAMES
local generatePages = require(NotApprovedPage.Components.pageItemConfigs.generatePages).generatePages
local useNotApprovedPageContext = require(NotApprovedPage.Contexts.NotApprovedPageContext).useNotApprovedPageContext
local policyEducationContentRegistry = require(NotApprovedPage.Components.pageItemConfigs.policyEducationConfigs.policyEducationContentRegistry)
local NotApprovedPageParent = NotApprovedPage.Parent
local ArgCheck = require(NotApprovedPageParent.ArgCheck)
local React = require(NotApprovedPageParent.React)
local useMemo = React.useMemo
local useState = React.useState
local useCallback = React.useCallback
local useContext = React.useContext
local createContext = React.createContext
local FFlagEnableNapReactivationNotice = require(NotApprovedPage.Flags.FFlagEnableNapReactivationNotice)
local v15 = createContext({})

return {
	PageNavigationProvider = function(t1: {[any]: any}) -- line: 83
		-- upvalues: useState (copy), useNotApprovedPageContext (copy), useMemo (copy), generatePages (copy), STATIC_PAGE_NAMES (copy), useCallback (copy), FFlagEnableNapReactivationNotice (copy), policyEducationContentRegistry (copy), React (copy), v15 (copy)
		local v17, v18 = useState(1)
		local v19, v20 = useState(false)
		local untranslatedReasons = useNotApprovedPageContext().violationReasons.untranslatedReasons
		local commutationEligibility = useNotApprovedPageContext().commutationEligibility
		local v23 = useMemo(function() -- line: 90
			-- upvalues: generatePages (copy), t1 (copy), untranslatedReasons (copy), commutationEligibility (copy)
			return generatePages(t1.moderationDetail, untranslatedReasons, commutationEligibility)
		end, {
			t1.moderationDetail,
			untranslatedReasons,
			commutationEligibility
		})
		local pages = v23.pages
		local unmappedViolationKeys = v23.unmappedViolationKeys
		local v26 = #pages
		local v27 = pages[v17]
		local v28 = if not v27 then STATIC_PAGE_NAMES.Unknown else v27.pageName
		local v29 = not not commutationEligibility and commutationEligibility.educational_pass_eligible
		local v30 = useCallback(function() -- line: 105
			-- upvalues: v17 (copy), v26 (copy), FFlagEnableNapReactivationNotice (copy), v20 (copy), v18 (copy)
			if v17 < v26 then
				if FFlagEnableNapReactivationNotice then
					v20(true)
				end

				v18(function(p1) -- line: 110
					return p1 + 1
				end)
			end
		end, {
			v17,
			v26
		})
		local v31 = useCallback(function() -- line: 116
			-- upvalues: v17 (copy), v18 (copy)
			if v17 > 1 then
				v18(function(p2) -- line: 118
					return p2 - 1
				end)
			end
		end, { v17 })
		local v32 = v17 == 1
		local v33 = v17 == v26
		local v34 = useCallback(function() -- line: 129
			-- upvalues: v26 (copy), v28 (copy), STATIC_PAGE_NAMES (copy), v17 (copy), v29 (copy)
			if v26 <= 1 or (v28 == STATIC_PAGE_NAMES.Intro or v28 == STATIC_PAGE_NAMES.SecondChanceIntro) then
				return 0
			end

			local v38 = v26 - 1
			local v39 = v17 - 1

			if v29 then
				v38 -= 1
				v39 -= 1
			end

			if v38 <= 0 then
				return 0
			end

			return (math.round(v39 / v38 * 100))
		end, {
			v17,
			v26,
			v28
		})
		local v35 = useMemo(function() -- line: 157
			-- upvalues: untranslatedReasons (copy), policyEducationContentRegistry (copy)
			for _, v41 in untranslatedReasons do
				if policyEducationContentRegistry[v41] then
					return true
				end
			end

			return false
		end, { untranslatedReasons })
		local v36 = useMemo(function() -- line: 166
			-- upvalues: v17 (copy), v28 (copy), v26 (copy), v30 (copy), v31 (copy), v32 (copy), v33 (copy), v34 (copy), v35 (copy), FFlagEnableNapReactivationNotice (copy), v19 (copy), v27 (copy), unmappedViolationKeys (copy)
			return {
				currentPage = v17,
				currentPageName = v28,
				totalPages = v26,
				goToNextPage = v30,
				goToPreviousPage = v31,
				isFirstPage = v32,
				isLastPage = v33,
				getProgress = v34,
				hasEducationalPages = v35,
				hasNavigatedForward = not not FFlagEnableNapReactivationNotice and v19,
				currentPageConfigs = if not v27 then {} else v27.pageItems,
				CurrentCtaComponent = if not v27 then nil else v27.CtaComponent,
				unmappedViolationKeys = unmappedViolationKeys
			}
		end, {
			v17,
			v26,
			v28,
			v30,
			v31,
			v32,
			v33,
			v34,
			pages,
			v35,
			v19,
			unmappedViolationKeys
		})

		return React.createElement(v15.Provider, {
			value = v36
		}, t1.children)
	end,
	usePageNavigation = function() -- line: 204
		-- upvalues: useContext (copy), v15 (copy), ArgCheck (copy)
		local v37 = useContext(v15)

		ArgCheck.assert(v37 and v37.currentPage ~= nil, "usePageNavigation must be used within PageNavigationProvider")

		return v37
	end
}
