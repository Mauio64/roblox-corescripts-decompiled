local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/fpu")

local fFlagEnableDeactivatedUserReactivation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableDeactivatedUserReactivation

local fFlagKidsNotApprovedPageTreatment = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagKidsNotApprovedPageTreatment

local getFFlagEnablePlatformEvidence = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnablePlatformEvidence

local v5 = {}

function v5.new()
	return {}
end

if getFFlagEnablePlatformEvidence() then
	v5.validateJson = t.interface({
		punishedUserId = t.number,
		messageToUser = t.string,
		punishmentTypeDescription = t.string,
		punishmentId = t.number,
		beginDate = t.string,
		endDate = t.string,
		badUtterances = t.table,
		verificationCategory = t.string,
		interventionId = t.string,
		isForeshadowingConsequenceEnabled = t.optional(t.boolean),
		agreedCheckBoxExperimentVariant = t.optional(t.string),
		context = t.optional(t.table),
		violation = t.optional(t.table),
		labelTranslationKey = t.optional(t.string),
		showUGCAvatarGuidelinesLink = t.optional(t.boolean)
	})
else
	v5.validateJson = t.interface({
		punishedUserId = t.number,
		messageToUser = t.string,
		punishmentTypeDescription = t.string,
		punishmentId = t.number,
		beginDate = t.string,
		endDate = t.string,
		badUtterances = t.table,
		verificationCategory = t.string,
		interventionId = t.string,
		isForeshadowingConsequenceEnabled = t.optional(t.boolean),
		agreedCheckBoxExperimentVariant = t.optional(t.string),
		context = t.optional(t.table),
		labelTranslationKey = t.optional(t.string),
		showUGCAvatarGuidelinesLink = t.optional(t.boolean)
	})
end

if getFFlagEnablePlatformEvidence() then
	v5.validateModel = t.interface({
		punishedUserId = t.number,
		messageToUser = t.string,
		punishmentTypeDescription = t.string,
		punishmentId = t.number,
		beginDate = t.string,
		endDate = t.string,
		badUtterances = t.table,
		verificationCategory = t.string,
		interventionId = t.string,
		showAppealsProcessLink = t.boolean,
		consequenceTransparencyMessage = t.string,
		agreedCheckBoxExperimentVariant = t.optional(t.string),
		selfServiceDeactivated = t.optional(t.boolean),
		isForeshadowingConsequenceEnabled = t.optional(t.boolean),
		nextConsequenceType = t.optional(t.string),
		nextConsequenceDuration = t.optional(t.number),
		isAltInformed = t.optional(t.boolean),
		showUGCAvatarGuidelinesLink = t.optional(t.boolean),
		labelTranslationKey = t.optional(t.string),
		violation = t.optional(t.interface({
			evidence = t.optional(t.interface({
				type = t.string,
				elements = t.optional(t.table),
				elementsObj = t.optional(t.map(t.string, t.any)),
				displayMeta = t.optional(t.interface({
					lowercaseKey = t.string,
					capitalizedKey = t.string,
					icon = t.string
				}))
			})),
			abuseTypeTranslationKeys = t.table,
			uid = t.string
		}))
	})
else
	v5.validateModel = t.interface({
		punishedUserId = t.number,
		messageToUser = t.string,
		punishmentTypeDescription = t.string,
		punishmentId = t.number,
		beginDate = t.string,
		endDate = t.string,
		badUtterances = t.table,
		verificationCategory = t.string,
		interventionId = t.string,
		showAppealsProcessLink = t.boolean,
		consequenceTransparencyMessage = t.string,
		agreedCheckBoxExperimentVariant = t.optional(t.string),
		selfServiceDeactivated = t.optional(t.boolean),
		isForeshadowingConsequenceEnabled = t.optional(t.boolean),
		nextConsequenceType = t.optional(t.string),
		nextConsequenceDuration = t.optional(t.number),
		isAltInformed = t.optional(t.boolean),
		showUGCAvatarGuidelinesLink = t.optional(t.boolean),
		labelTranslationKey = t.optional(t.string)
	})
end

function v5.mock(options)
	local v6 = v5.new()
	v6.punishedUserId = 1137965296
	v6.messageToUser = "Mock Message"
	v6.punishmentTypeDescription = "Warn"
	v6.punishmentId = 2148187493
	v6.beginDate = "2021-03-10T20:14:00.0000000Z"
	v6.endDate = "2021-03-10T20:22:00.0000000Z"
	v6.badUtterances = {
		{
			labelTranslationKey = "Label.AbuseType.Harassment",
			utteranceText = "fvg behavior",
			imageUrl = ""
		}
	}

	v6.verificationCategory = "Email"
	v6.interventionId = "aaaa1aa1-aaa1-111a-aa11-aa1aaaa1aa11"
	v6.labelTranslationKey = "Label.AbuseType.Harassment"
	v6.agreedCheckBoxExperimentVariant = "control"
	v6.isForeshadowingConsequenceEnabled = false
	v6.nextConsequenceType = "BAN"
	v6.nextConsequenceDuration = 1
	return Cryo.Dictionary.join(v6, options or {})
end

function v5.fromJsonData(data)
	if not v5.validateJson(data) then
		return module.error("ModerationDetail.fromJsonData expects a valid moderation JSON response")
	end

	local v6 = v5.new()

	v6.punishedUserId = data.punishedUserId
	v6.messageToUser = data.messageToUser
	v6.punishmentTypeDescription = data.punishmentTypeDescription
	v6.punishmentId = data.punishmentId
	v6.beginDate = data.beginDate
	v6.endDate = data.endDate
	v6.badUtterances = {}
	v6.verificationCategory = data.verificationCategory
	v6.interventionId = data.interventionId

	if fFlagKidsNotApprovedPageTreatment then
		v6.labelTranslationKey = data.labelTranslationKey
	end

	v6.consequenceTransparencyMessage = data.consequenceTransparencyMessage
	v6.showAppealsProcessLink = data.showAppealsProcessLink
	v6.agreedCheckBoxExperimentVariant = data.agreedCheckBoxExperimentVariant
	v6.isForeshadowingConsequenceEnabled = data.isForeshadowingConsequenceEnabled
	v6.showUGCAvatarGuidelinesLink = data.showUGCAvatarGuidelinesLink

	for k, badUtterance in pairs(data.badUtterances) do
		local v7 = {
			["labelTranslationKey"] = badUtterance.labelTranslationKey,
			utteranceText = badUtterance.utteranceText,
			imageUrl = badUtterance.imageUrl
		}
		table.insert(v6.badUtterances, v7)
	end

	if getFFlagEnablePlatformEvidence() and data.violation then
		local v7 = {}

		if data.violation.evidence then
			v7.evidence = {
				["type"] = data.violation.evidence.type,
				elements = data.violation.evidence.elements,
				elementsObj = data.violation.evidence.elementsObj,
				displayMeta = data.violation.evidence.displayMeta
			}
		end

		v7.abuseTypeTranslationKeys = data.violation.abuseTypeTranslationKeys
		v7.uid = data.violation.uid
		v6.violation = v7
	end

	if data.context then
		for k, v7 in pairs(data.context) do
			if k == "SelfServiceDeactivated" and fFlagEnableDeactivatedUserReactivation then
				v6.selfServiceDeactivated = v7
			elseif k == "NEXT_CONSEQUENCE_TYPE" then
				v6.nextConsequenceType = v7
			elseif k == "NEXT_CONSEQUENCE_DURATION" then
				v6.nextConsequenceDuration = v7
			elseif k == "IS_ALT_INFORMED" then
				v6.isAltInformed = v7
			end
		end
	end

	return module.success(v6)
end

return v5
