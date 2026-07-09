local CorePackages = game:GetService("CorePackages")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t1 = {
	TermsOfService = true,
	PrivacyPolicy = true,
	RiderTerms = true,
	ChildrenPrivacyPolicy = true,
	LuobuThirdPartyDataUse = true,
	StudioTermsForVNGSKU = true
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 14
		-- upvalues: Logging (copy)
		Logging.warn(string.format("Unknown User Agreement Type: %s", (tostring(p2))))

		return false
	end
})

return {
	CheckAgreementTypeExists = function(p3) -- line: 22
		-- upvalues: t1 (copy)
		return t1[p3]
	end
}
