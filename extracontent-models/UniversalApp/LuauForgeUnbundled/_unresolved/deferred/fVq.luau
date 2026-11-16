require("@luauforge/deferred/fUR")

local module = require("@luauforge/deferred/fUX")

local module2 = require("@luauforge/deferred/fUU")
local useMemo = module2.useMemo
local useContext = module2.useContext

local module3 = require("@luauforge/deferred/fVr")
local initializeEmojis = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/ExpChat/Autocomplete/Initializations/initializeEmojis")
local module5 = require("@luauforge/deferred/fVh")
local module6 = require("@luauforge/deferred/fVl")

local context = module2.createContext({})

return {
	NotApprovedPageProvider = function(props)
		local translations = props.translations
		local badUtterances = props.moderationDetail.badUtterances
		local violation = props.moderationDetail.violation
		local commutationEligibility = props.commutationEligibility
		local isKidsTreatment = props.isKidsTreatment or false
		local labelTranslationKey = props.moderationDetail.labelTranslationKey
		local messageToUser = props.moderationDetail.messageToUser

		local v5 = useMemo(function()
			local labelTranslationKeys = {}

			if violation and module6.isVisibleInView(violation) then
				labelTranslationKeys = violation.abuseTypeTranslationKeys
			elseif badUtterances then
				for k, badUtterance in badUtterances do
					table.insert(labelTranslationKeys, badUtterance.labelTranslationKey)
				end
			end

			local v6 = initializeEmojis(labelTranslationKeys, nil)
			local v7

			if isKidsTreatment then
				v7 = module3(labelTranslationKeys, translations)
			else
				v7 = initializeEmojis(labelTranslationKeys, translations)
			end

			local v8

			if messageToUser and messageToUser ~= "" then
				v8 = messageToUser
			else
				v8 = translations.fallbackModeratorNote
			end

			if isKidsTreatment and labelTranslationKey then
				local v9 = module5.CONTENT_BY_ABUSE_KEY[labelTranslationKey]
				local v10 = if v9 then translations[v9.moderatorNote] else nil

				if v10 and v10 ~= "" then
					v8 = v10
				end
			end

			return {
				translations = translations,
				violationReasons = { translatedReasons = v7, untranslatedReasons = v6 },
				commutationEligibility = commutationEligibility,
				isKidsTreatment = isKidsTreatment,
				moderatorNote = v8
			}
		end, {
			badUtterances,
			violation,
			translations,
			commutationEligibility,
			isKidsTreatment,
			labelTranslationKey,
			messageToUser
		})

		return module2.createElement(context.Provider, { value = v5 }, props.children)
	end,
	useNotApprovedPageContext = function()
		local v5 = useContext(context)

		module.assert(
			v5 and v5.translations,
			"useNotApprovedPageContext returned invalid context, usually this means the NotApprovedPageProvider is not present in the tree"
		)

		return {
			translations = v5.translations,
			violationReasons = v5.violationReasons,
			commutationEligibility = v5.commutationEligibility,
			isKidsTreatment = v5.isKidsTreatment,
			moderatorNote = v5.moderatorNote
		}
	end
}
