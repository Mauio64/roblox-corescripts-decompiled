local constants = require("@luauforge/deferred/fUP").Constants
local module = require("@luauforge/deferred/fVI")
require("@luauforge/deferred/fUY")
local useNotApprovedPageContext = require("@luauforge/deferred/fVq").useNotApprovedPageContext

local module2 = require("@luauforge/deferred/fUU")
local module3 = require("@luauforge/deferred/fUV")
local view = module3.View
local text = module3.Text
local useMemo = module2.useMemo

local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

local function PunishmentDescription(p2)
	local v5 = useNotApprovedPageContext()
	local translations = v5.translations
	local translatedReasons = v5.violationReasons.translatedReasons
	local isKidsTreatment = v5.isKidsTreatment

	local v6 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p2.moderationDetail.punishmentTypeDescription]

	local v7 = useMemo(function()
		return module({
			violationType = translations.violationType,
			interventionType = v6,
			violationReasons = translatedReasons or {},
			isKidsTreatment = isKidsTreatment,
			endDate = p2.moderationDetail.endDate,
			translations = translations
		})
	end, {
		translations.violationType,
		translations,
		v6,
		translatedReasons,
		isKidsTreatment,
		p2.moderationDetail.endDate
	})

	return module2.createElement(
		view,
		{
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = p2.layoutOrder,
			testId = "punishment-description"
		},
		{
			Description = module2.createElement(text, {
				Text = v7,
				tag = "auto-xy text-body-medium text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1
			})
		}
	)
end

return {
	getIsVisible = function(): boolean
		return true
	end,
	renderComponent = module2.memo(PunishmentDescription)
}
