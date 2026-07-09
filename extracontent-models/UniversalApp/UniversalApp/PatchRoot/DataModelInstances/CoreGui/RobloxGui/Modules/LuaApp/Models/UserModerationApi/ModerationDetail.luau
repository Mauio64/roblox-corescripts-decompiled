local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Result = require(Modules.LuaApp.Result)
local FFlagEnableDeactivatedUserReactivation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableDeactivatedUserReactivation
local GetFFlagEnablePlatformEvidence = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnablePlatformEvidence
local t1 = {
	new = function() -- line: 70
		return {}
	end
}

if GetFFlagEnablePlatformEvidence() then
	t1.validateJson = t.interface({
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
		showUGCAvatarGuidelinesLink = t.optional(t.boolean)
	})
else
	t1.validateJson = t.interface({
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
		showUGCAvatarGuidelinesLink = t.optional(t.boolean)
	})
end

if GetFFlagEnablePlatformEvidence() then
	t1.validateModel = t.interface({
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
	t1.validateModel = t.interface({
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
		showUGCAvatarGuidelinesLink = t.optional(t.boolean)
	})
end

function t1.mock(p1) -- line: 194
	-- upvalues: t1 (copy), Cryo (copy)
	local v10 = p1 or {}
	local v11 = t1.new()

	v11.punishedUserId = 1137965296
	v11.messageToUser = "Mock Message"
	v11.punishmentTypeDescription = "Warn"
	v11.punishmentId = 2148187493
	v11.beginDate = "2021-03-10T20:14:00.0000000Z"
	v11.endDate = "2021-03-10T20:22:00.0000000Z"
	v11.badUtterances = {{
		labelTranslationKey = "Label.AbuseType.Harassment",
		utteranceText = "fvg behavior",
		imageUrl = ""
	}}
	v11.verificationCategory = "Email"
	v11.interventionId = "aaaa1aa1-aaa1-111a-aa11-aa1aaaa1aa11"
	v11.agreedCheckBoxExperimentVariant = "control"
	v11.isForeshadowingConsequenceEnabled = false
	v11.nextConsequenceType = "BAN"
	v11.nextConsequenceDuration = 1

	return Cryo.Dictionary.join(v11, v10)
end
function t1.fromJsonData(p2) -- line: 219
	-- upvalues: t1 (copy), Result (copy), GetFFlagEnablePlatformEvidence (copy), FFlagEnableDeactivatedUserReactivation (copy)
	if not t1.validateJson(p2) then
		return Result.error("ModerationDetail.fromJsonData expects a valid moderation JSON response")
	end

	local v13 = t1.new()

	v13.punishedUserId = p2.punishedUserId
	v13.messageToUser = p2.messageToUser
	v13.punishmentTypeDescription = p2.punishmentTypeDescription
	v13.punishmentId = p2.punishmentId
	v13.beginDate = p2.beginDate
	v13.endDate = p2.endDate
	v13.badUtterances = {}
	v13.verificationCategory = p2.verificationCategory
	v13.interventionId = p2.interventionId
	v13.consequenceTransparencyMessage = p2.consequenceTransparencyMessage
	v13.showAppealsProcessLink = p2.showAppealsProcessLink
	v13.agreedCheckBoxExperimentVariant = p2.agreedCheckBoxExperimentVariant
	v13.isForeshadowingConsequenceEnabled = p2.isForeshadowingConsequenceEnabled
	v13.showUGCAvatarGuidelinesLink = p2.showUGCAvatarGuidelinesLink

	for _, v in pairs(p2.badUtterances) do
		local t2 = {
			labelTranslationKey = v.labelTranslationKey,
			utteranceText = v.utteranceText,
			imageUrl = v.imageUrl
		}

		table.insert(v13.badUtterances, t2)
	end

	if GetFFlagEnablePlatformEvidence() and p2.violation then
		local t3 = {}

		if p2.violation.evidence then
			t3.evidence = {
				type = p2.violation.evidence.type,
				elements = p2.violation.evidence.elements,
				elementsObj = p2.violation.evidence.elementsObj,
				displayMeta = p2.violation.evidence.displayMeta
			}
		end

		t3.abuseTypeTranslationKeys = p2.violation.abuseTypeTranslationKeys
		t3.uid = p2.violation.uid
		v13.violation = t3
	end

	if p2.context then
		for k, v in pairs(p2.context) do
			if k == "SelfServiceDeactivated" and FFlagEnableDeactivatedUserReactivation then
				v13.selfServiceDeactivated = v
			elseif k == "NEXT_CONSEQUENCE_TYPE" then
				v13.nextConsequenceType = v
			elseif k == "NEXT_CONSEQUENCE_DURATION" then
				v13.nextConsequenceDuration = v
			elseif k == "IS_ALT_INFORMED" then
				v13.isAltInformed = v
			end
		end
	end

	return Result.success(v13)
end

return t1
