local logging = require("@luauforge/bundled/gsS").Logging

local v5 = {
	TermsOfService = true,
	PrivacyPolicy = true,
	RiderTerms = true,
	ChildrenPrivacyPolicy = true,
	LuobuThirdPartyDataUse = true,
	TransferPersonalInformationPolicy = true,
	OptionalPersonalInformationPolicy = true,
	ThirdPartyPersonalInformationPolicy = true,
	PersonalInformationPolicy = true,
	StudioTermsForVNGSKU = true
}

setmetatable(v5, {
	__index = function(p2, p3): boolean
		logging.warn(string.format("Unknown User Agreement Type: %s", (tostring(p3))))
		return false
	end
})

return {
	["agreementTypes"] = v5,
	CheckAgreementTypeExists = function(p2)
		return v5[p2]
	end
}
