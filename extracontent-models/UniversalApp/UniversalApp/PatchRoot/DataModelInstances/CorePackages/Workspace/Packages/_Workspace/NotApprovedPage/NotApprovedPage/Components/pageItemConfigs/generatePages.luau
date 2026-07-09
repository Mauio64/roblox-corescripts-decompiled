local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local Constants = require(NotApprovedPage.Parent.NotApprovedPageShared).Constants
local Cryo = require(NotApprovedPage.Parent.Cryo)
local INTERVENTION_TYPES = Constants.INTERVENTION_TYPES
local PUNISHMENT_TYPE_TO_INTERVENTION_MAP = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP

require(NotApprovedPage.Common.Types)

local PageItemConfigUtils = require(NotApprovedPage.Components.pageItemConfigs.PageItemConfigUtils)
local EDUCATIONAL_PAGE_PREFIXES = PageItemConfigUtils.EDUCATIONAL_PAGE_PREFIXES
local STATIC_PAGE_NAMES = PageItemConfigUtils.STATIC_PAGE_NAMES
local policyEducationContentRegistry = require(NotApprovedPage.Components.pageItemConfigs.policyEducationConfigs.policyEducationContentRegistry)
local createPolicyEducationConfig = require(NotApprovedPage.Components.pageItemConfigs.policyEducationConfigs.createPolicyEducationConfig)
local BadUtterancesConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.BadUtterancesConfig)
local ChargebackStepsConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.ChargebackStepsConfig)
local PreventionStepsConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.PreventionStepsConfig)
local PunishmentDescriptionConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.PunishmentDescriptionConfig)
local RecentActivityConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.RecentActivityConfig)
local ReportMistakeConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.ReportMistakeConfig)
local SecondChanceConclusionConfig = require(NotApprovedPage.Components.pageItemConfigs.secondChanceConfigs.SecondChanceConclusionConfig)
local SecondChanceIntroConfig = require(NotApprovedPage.Components.pageItemConfigs.secondChanceConfigs.SecondChanceIntroConfig)
local SimpleModeratorNoteConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.SimpleModeratorNoteConfig)
local ViolationEvidenceConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.ViolationEvidenceConfig)
local WhatHappenedConfig = require(NotApprovedPage.Components.pageItemConfigs.configs.WhatHappenedConfig)
local ContinueButtonCta = require(NotApprovedPage.Components.cta.ContinueButtonCta)
local DeleteCta = require(NotApprovedPage.Components.cta.DeleteCta)
local ProceedActionsCta = require(NotApprovedPage.Components.cta.ProceedActionsCta)
local SecondChanceActionsCta = require(NotApprovedPage.Components.cta.SecondChanceActionsCta)
local UnderstandRuleContinueCta = require(NotApprovedPage.Components.cta.UnderstandRuleContinueCta)

local function getEducationalPages(_, t1: {[any]: any}, b1: boolean) -- line: 59
	-- upvalues: policyEducationContentRegistry (copy), EDUCATIONAL_PAGE_PREFIXES (copy), createPolicyEducationConfig (copy), UnderstandRuleContinueCta (copy), ContinueButtonCta (copy), Cryo (copy)
	local t2 = {}
	local t3 = {}
	local t4 = {}

	for _, v in ipairs(t1) do
		local v36 = policyEducationContentRegistry[v]

		if not v36 then
			t4[v] = true
		elseif not t3[v36.policyKey] then
			t3[v36.policyKey] = true
			table.insert(t2, {
				pageName = `{ EDUCATIONAL_PAGE_PREFIXES.Rule }{ v36.policyKey }`,
				pageItems = { createPolicyEducationConfig({
					title = v36.ruleTitle,
					subtitle = v36.ruleSubtitle,
					description = v36.ruleDescription,
					descriptionBullets = v36.ruleDescriptionBullets,
					policyKey = v36.policyKey
				}) },
				CtaComponent = if not b1 then ContinueButtonCta else UnderstandRuleContinueCta
			})
			table.insert(t2, {
				pageName = `{ EDUCATIONAL_PAGE_PREFIXES.Importance }{ v36.policyKey }`,
				pageItems = { createPolicyEducationConfig({
					title = v36.importanceTitle,
					description = v36.importanceDescription,
					policyKey = v36.policyKey
				}) },
				CtaComponent = if not b1 then ContinueButtonCta else UnderstandRuleContinueCta
			})
		end
	end

	return {
		educationalPages = t2,
		unmappedViolationKeys = Cryo.Dictionary.keys(t4)
	}
end

return {
	generatePages = function(p2, t5: {[any]: any}, p3) -- line: 143
		-- upvalues: PUNISHMENT_TYPE_TO_INTERVENTION_MAP (copy), INTERVENTION_TYPES (copy), STATIC_PAGE_NAMES (copy), PunishmentDescriptionConfig (copy), WhatHappenedConfig (copy), RecentActivityConfig (copy), DeleteCta (copy), ContinueButtonCta (copy), SecondChanceIntroConfig (copy), ReportMistakeConfig (copy), getEducationalPages (copy), PreventionStepsConfig (copy), ChargebackStepsConfig (copy), UnderstandRuleContinueCta (copy), ProceedActionsCta (copy), SecondChanceConclusionConfig (copy), SecondChanceActionsCta (copy)
		local t6 = {}
		local v41 = PUNISHMENT_TYPE_TO_INTERVENTION_MAP[p2.punishmentTypeDescription] == INTERVENTION_TYPES.Deleted
		local v42 = not not p3 and p3.educational_pass_eligible

		table.insert(t6, {
			pageName = STATIC_PAGE_NAMES.Intro,
			pageItems = {
				PunishmentDescriptionConfig,
				WhatHappenedConfig,
				RecentActivityConfig
			},
			CtaComponent = if not v41 then ContinueButtonCta else DeleteCta
		})

		if v41 then
			return {
				pages = t6,
				unmappedViolationKeys = {}
			}
		end

		if v42 then
			table.insert(t6, {
				pageName = STATIC_PAGE_NAMES.SecondChanceIntro,
				pageItems = {
					SecondChanceIntroConfig,
					ReportMistakeConfig
				},
				CtaComponent = ContinueButtonCta
			})
		end

		local v43 = getEducationalPages(p2, t5, v42)

		for _, v45 in v43.educationalPages do
			table.insert(t6, v45)
		end

		table.insert(t6, {
			pageName = STATIC_PAGE_NAMES.Resolution,
			pageItems = {
				PreventionStepsConfig,
				ChargebackStepsConfig,
				ReportMistakeConfig
			},
			CtaComponent = if not v42 then ProceedActionsCta else UnderstandRuleContinueCta
		})

		if v42 then
			table.insert(t6, {
				pageName = STATIC_PAGE_NAMES.SecondChanceConclusion,
				pageItems = { SecondChanceConclusionConfig },
				CtaComponent = SecondChanceActionsCta
			})
		end

		return {
			pages = t6,
			unmappedViolationKeys = v43.unmappedViolationKeys
		}
	end,
	getReviewedEvidencePageItemConfigs = function() -- line: 46
		-- upvalues: ViolationEvidenceConfig (copy), BadUtterancesConfig (copy), SimpleModeratorNoteConfig (copy)
		return {
			ViolationEvidenceConfig,
			BadUtterancesConfig,
			SimpleModeratorNoteConfig
		}
	end
}
