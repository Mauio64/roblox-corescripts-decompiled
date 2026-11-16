local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
local module5 = require("@luauforge/deferred/ehp")
local module6 = require("@luauforge/deferred/egW")
require("@luauforge/deferred/egX")
local module7 = require("@luauforge/deferred/ehr")
local module8 = require("@luauforge/deferred/eVy")

local verifyErrorKind = module6.VerifyErrorKind

local v5 = {
	invalidEmailFormat = verifyErrorKind.NotSchoolEmail,
	invalidEmailAddress = verifyErrorKind.NotSchoolEmail,
	emailNotAllowed = verifyErrorKind.NotSchoolEmail,
	unsupportedCountry = verifyErrorKind.NotSchoolEmail,
	emailVerificationNotSupported = verifyErrorKind.NotSchoolEmail,
	emailAlreadyLinked = verifyErrorKind.AlreadyLinked
}

if module7 then
	v5.schoolNotAvailable = verifyErrorKind.SchoolNotAvailable
end

if module8 then
	v5.noSchoolsMatched = verifyErrorKind.NotSchoolEmail
end

local function submitSchoolEmail(p2, p3)
	local fetched = module.fetch({
		method = "POST",
		url = module3.email,
		analyticsKey = "school-verification.submit-email",
		body = { emailAddress = p2 },
		network = p3,
		decode = function(p4)
			return module5.decodeSchoolVerification(p4)
		end
	})

	return module.asPromise(fetched):catch(function(p4)
		return module2.reject(module4(p4, v5))
	end)
end

return submitSchoolEmail
