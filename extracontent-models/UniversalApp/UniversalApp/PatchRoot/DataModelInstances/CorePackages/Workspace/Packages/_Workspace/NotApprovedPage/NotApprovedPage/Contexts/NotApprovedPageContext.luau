local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local NotApprovedPageParent = NotApprovedPage.Parent
local ArgCheck = require(NotApprovedPageParent.ArgCheck)
local React = require(NotApprovedPageParent.React)
local useMemo = React.useMemo
local useContext = React.useContext
local platformEvidence = require(NotApprovedPage.Utils.platformEvidence)
local collectUniqueTranslations = require(NotApprovedPage.Utils.collectUniqueTranslations)
local v9 = React.createContext({})

return {
	NotApprovedPageProvider = function(t1: {[any]: any}) -- line: 50
		-- upvalues: useMemo (copy), platformEvidence (copy), collectUniqueTranslations (copy), React (copy), v9 (copy)
		local translations = t1.translations
		local badUtterances = t1.moderationDetail.badUtterances
		local violation = t1.moderationDetail.violation
		local commutationEligibility = t1.commutationEligibility
		local v15 = useMemo(function() -- line: 55
			-- upvalues: violation (copy), platformEvidence (copy), collectUniqueTranslations (copy), translations (copy), badUtterances (copy), commutationEligibility (copy)
			local t2 = {}
			local t3 = {}

			if violation and platformEvidence.isVisibleInView(violation) then
				t2 = collectUniqueTranslations(violation.abuseTypeTranslationKeys, translations)
				t3 = collectUniqueTranslations(violation.abuseTypeTranslationKeys, nil)
			elseif badUtterances then
				local t4 = {}

				for _, v21 in badUtterances do
					table.insert(t4, v21.labelTranslationKey)
				end

				t2 = collectUniqueTranslations(t4, translations)
				t3 = collectUniqueTranslations(t4, nil)
			end

			return {
				translations = translations,
				violationReasons = {
					translatedReasons = t2,
					untranslatedReasons = t3
				},
				commutationEligibility = commutationEligibility
			}
		end, {
			badUtterances,
			violation,
			translations,
			commutationEligibility
		})

		return React.createElement(v9.Provider, {
			value = v15
		}, t1.children)
	end,
	useNotApprovedPageContext = function() -- line: 89
		-- upvalues: useContext (copy), v9 (copy), ArgCheck (copy)
		local v16 = useContext(v9)

		ArgCheck.assert(v16 and v16.translations, "useNotApprovedPageContext returned invalid context, usually this means the NotApprovedPageProvider is not present in the tree")

		return {
			translations = v16.translations,
			violationReasons = v16.violationReasons,
			commutationEligibility = v16.commutationEligibility
		}
	end
}
