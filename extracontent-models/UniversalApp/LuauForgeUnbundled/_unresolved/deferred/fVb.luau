local constants = require("@luauforge/deferred/fUP").Constants

local module = require("@luauforge/deferred/fVc")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChat/Cryo")
local module3 = require("@luauforge/deferred/fVf")
require("@luauforge/deferred/fUR")
local module4 = require("@luauforge/deferred/fUY")

local module5 = require("@luauforge/deferred/fVg")

local module6 = require("@luauforge/deferred/fVj")
local module7 = require("@luauforge/deferred/fVu")
local module8 = require("@luauforge/deferred/fVv")
local module9 = require("@luauforge/deferred/fVH")
local module10 = require("@luauforge/deferred/fVJ")
local module11 = require("@luauforge/deferred/fVM")

local module12 = require("@luauforge/deferred/fVO")
local module13 = require("@luauforge/deferred/fVP")
local module14 = require("@luauforge/deferred/fVL")
local module15 = require("@luauforge/deferred/fVK")
local module16 = require("@luauforge/deferred/fVQ")

local module17 = require("@luauforge/deferred/fVR")
local module18 = require("@luauforge/deferred/fVZ")
local module19 = require("@luauforge/deferred/fWa")
local module20 = require("@luauforge/deferred/fWi")
local module21 = require("@luauforge/deferred/fWm")

local EDUCATIONAL_PAGE_PREFIXES = module4.EDUCATIONAL_PAGE_PREFIXES
local INTERVENTION_TYPES = constants.INTERVENTION_TYPES

local module22 = require("@luauforge/deferred/fVi")
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP
local STATIC_PAGE_NAMES = module4.STATIC_PAGE_NAMES

local fFlagKidsNotApprovedPageTreatment = module3.FFlagKidsNotApprovedPageTreatment

local function getEducationalPages(p2, list, p3, p4)
	if fFlagKidsNotApprovedPageTreatment then
		local v5 = {}
		local deduplicationKeys = {}

		local set = {}
		local v6 = {}

		for i, item in ipairs(list) do
			local v7 = module5(item, p4)

			if v7 then
				local deduplicationKey = v7.deduplicationKey or v7.policyKey
				local v8 = v5[deduplicationKey]

				if v8 then
					if v7.deduplicationKey and not v8.deduplicationKey then
						v5[deduplicationKey] = v7
					end
				else
					v5[deduplicationKey] = v7
					table.insert(deduplicationKeys, deduplicationKey)
				end
			else
				set[item] = true
			end
		end

		for i, v7 in ipairs(deduplicationKeys) do
			local v8 = v5[v7]

			local v9 = {
				pageName = `{EDUCATIONAL_PAGE_PREFIXES.Rule}{v8.policyKey}`,
				pageItems = { module({
						title = v8.ruleTitle,
						subtitle = v8.ruleSubtitle,
						description = v8.ruleDescription,
						descriptionBullets = v8.ruleDescriptionBullets,
						policyKey = v8.policyKey
					}) },
				CtaComponent = if p3 then module21 else module17
			}
			table.insert(v6, v9)

			local v11 = {
				pageName = `{EDUCATIONAL_PAGE_PREFIXES.Importance}{v8.policyKey}`,
				pageItems = { module({
						title = v8.importanceTitle,
						description = v8.importanceDescription,
						descriptionBullets = v8.importanceDescriptionBullets,
						policyKey = v8.policyKey
					}) },
				CtaComponent = if p3 then module21 else module17
			}
			table.insert(v6, v11)
		end

		return {
			educationalPages = v6,
			unmappedViolationKeys = Cryo.Dictionary.keys(set)
		}
	else
		local policyKeySet = {}
		local v5 = {}

		local set = {}

		for i, item in ipairs(list) do
			local v6 = module22[item]

			if v6 then
				if not policyKeySet[v6.policyKey] then
					policyKeySet[v6.policyKey] = true

					local v7 = {
						pageName = `{EDUCATIONAL_PAGE_PREFIXES.Rule}{v6.policyKey}`,
						pageItems = { module({
								title = v6.ruleTitle,
								subtitle = v6.ruleSubtitle,
								description = v6.ruleDescription,
								descriptionBullets = v6.ruleDescriptionBullets,
								policyKey = v6.policyKey
							}) },
						CtaComponent = if p3 then module21 else module17
					}
					table.insert(v5, v7)

					local v9 = {
						pageName = `{EDUCATIONAL_PAGE_PREFIXES.Importance}{v6.policyKey}`,
						pageItems = { module({
								title = v6.importanceTitle,
								description = v6.importanceDescription,
								policyKey = v6.policyKey
							}) },
						CtaComponent = if p3 then module21 else module17
					}
					table.insert(v5, v9)
				end
			else
				set[item] = true
			end
		end

		return {
			educationalPages = v5,
			unmappedViolationKeys = Cryo.Dictionary.keys(set)
		}
	end
end

return {
	generatePages = function(p2, p3, p4, p5)
		local v5 = {}
		local v7 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p2.punishmentTypeDescription] == INTERVENTION_TYPES.Deleted

		local v8 = if p4 then p4.educational_pass_eligible else false

		local v9 = {
			pageName = STATIC_PAGE_NAMES.Intro,
			pageItems = { module9, module16, module10 },
			CtaComponent = if v7 then module18 else module17
		}
		table.insert(v5, v9)

		if v7 then
			return { pages = v5, unmappedViolationKeys = {} }
		end

		if v8 then
			table.insert(v5, {
				pageName = STATIC_PAGE_NAMES.SecondChanceIntro,
				pageItems = { module13, module11 },
				CtaComponent = module17
			})
		end

		local educationalPages = getEducationalPages(p2, p3, v8, p5 or false)

		for k, educationalPage in educationalPages.educationalPages do
			table.insert(v5, educationalPage)
		end

		local v11 = {
			pageName = STATIC_PAGE_NAMES.Resolution,
			pageItems = { module8, module7, module11 },
			CtaComponent = if v8 then module21 else module19
		}
		table.insert(v5, v11)

		if v8 then
			table.insert(v5, {
				pageName = STATIC_PAGE_NAMES.SecondChanceConclusion,
				pageItems = { module12 },
				CtaComponent = module20
			})
		end

		return {
			pages = v5,
			unmappedViolationKeys = educationalPages.unmappedViolationKeys
		}
	end,
	getReviewedEvidencePageItemConfigs = function()
		return { module15, module6, module14 }
	end
}
