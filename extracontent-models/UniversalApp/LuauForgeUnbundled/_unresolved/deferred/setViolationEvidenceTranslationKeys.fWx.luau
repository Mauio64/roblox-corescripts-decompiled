require("@luauforge/deferred/fUR")

local VIOLATION_TYPE_TO_PLURAL_MAP = require("@luauforge/deferred/fUP").Constants.VIOLATION_TYPE_TO_PLURAL_MAP

local module = require("@luauforge/deferred/fVl")

local module2 = require("@luauforge/deferred/fVn")

local function setViolationEvidenceTranslationKeys(p2, p3)
	local violation = p2.violation

	if not (violation and module.isVisibleInView(violation)) then
		return
	end

	local evidence = violation.evidence

	for k, v5 in evidence.elements or {} do
		if v5.labelKey then
			p3[v5.labelKey] = "Feature.AppealsPortal." .. v5.labelKey
		end

		if v5.altLabelKey then
			p3[v5.altLabelKey] = "Feature.AppealsPortal." .. v5.altLabelKey
		end

		if not (module2 and v5.textKey) then
			continue
		end

		local v6 = v5.textKey .. "_" .. v5.labelKey

		if v5.textKeyParameters then
			local textKeyParameters = { "Feature.NotApproved." .. v5.textKey }

			for k2, textKeyParameter in v5.textKeyParameters do
				textKeyParameters[k2] = textKeyParameter
			end

			p3[v6] = textKeyParameters
		else
			p3[v6] = "Feature.NotApproved." .. v5.textKey
		end
	end

	for k, abuseTypeTranslationKey in violation.abuseTypeTranslationKeys do
		p3[abuseTypeTranslationKey] = "Feature.NotApproved." .. abuseTypeTranslationKey
	end

	if evidence.displayMeta then
		local capitalizedKey = evidence.displayMeta.capitalizedKey

		if capitalizedKey and capitalizedKey ~= "" then
			p3.violationType = VIOLATION_TYPE_TO_PLURAL_MAP[capitalizedKey]
		end
	end
end

return setViolationEvidenceTranslationKeys
