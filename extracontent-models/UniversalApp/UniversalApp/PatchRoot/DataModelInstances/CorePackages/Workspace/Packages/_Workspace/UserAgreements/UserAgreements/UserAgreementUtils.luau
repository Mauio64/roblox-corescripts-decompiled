local ParentParent = script.Parent.Parent
local Logging = require(ParentParent.AppCommonLib).Logging
local t1 = {
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

setmetatable(t1, {
	__index = function(_, p2) -- line: 19
		-- upvalues: Logging (copy)
		Logging.warn(string.format("Unknown User Agreement Type: %s", (tostring(p2))))

		return false
	end
})

return {
	agreementTypes = t1,
	CheckAgreementTypeExists = function(p3) -- line: 28
		-- upvalues: t1 (copy)
		return t1[p3]
	end
}
