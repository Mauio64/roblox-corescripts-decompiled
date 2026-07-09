local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local VIOLATION_TYPE_TO_PLURAL_MAP = require(NotApprovedPage.Parent.NotApprovedPageShared).Constants.VIOLATION_TYPE_TO_PLURAL_MAP
local platformEvidence = require(NotApprovedPage.Utils.platformEvidence)
local FFlagNapPublicEvidenceTranslationKeys = require(NotApprovedPage.Flags.FFlagNapPublicEvidenceTranslationKeys)

local function setViolationEvidenceTranslationKeys(p1, t1: {[any]: any}) -- line: 12
	-- upvalues: platformEvidence (copy), FFlagNapPublicEvidenceTranslationKeys (copy), VIOLATION_TYPE_TO_PLURAL_MAP (copy)
	local violation = p1.violation

	if not violation or not platformEvidence.isVisibleInView(violation) then
		return
	end

	local evidence = violation.evidence

	for _, v11 in evidence.elements or {} do
		if v11.labelKey then
			t1[v11.labelKey] = "Feature.AppealsPortal." .. v11.labelKey
		end

		if v11.altLabelKey then
			t1[v11.altLabelKey] = "Feature.AppealsPortal." .. v11.altLabelKey
		end

		if FFlagNapPublicEvidenceTranslationKeys and v11.textKey then
			local v12 = v11.textKey .. "_" .. v11.labelKey

			if v11.textKeyParameters then
				local t2 = { "Feature.NotApproved." .. v11.textKey }

				for v14, v15 in v11.textKeyParameters do
					t2[v14] = v15
				end

				t1[v12] = t2
			else
				t1[v12] = "Feature.NotApproved." .. v11.textKey
			end
		end
	end

	for _, v17 in violation.abuseTypeTranslationKeys do
		t1[v17] = "Feature.NotApproved." .. v17
	end

	if evidence.displayMeta then
		local capitalizedKey = evidence.displayMeta.capitalizedKey

		if capitalizedKey and capitalizedKey ~= "" then
			t1.violationType = VIOLATION_TYPE_TO_PLURAL_MAP[capitalizedKey]
		end
	end
end

return setViolationEvidenceTranslationKeys
