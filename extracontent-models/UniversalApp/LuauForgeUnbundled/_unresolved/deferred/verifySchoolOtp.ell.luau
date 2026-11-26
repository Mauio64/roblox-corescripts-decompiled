local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
local module5 = require("@luauforge/deferred/ekJ")
local module6 = require("@luauforge/deferred/ekq")
require("@luauforge/deferred/ekr")

local verifyErrorKind = module6.VerifyErrorKind

local v5 = {
	invalidOtpCode = verifyErrorKind.OtpMismatch,
	otpExpired = verifyErrorKind.OtpExpired,
	invalidOtpFormat = verifyErrorKind.OtpInvalidFormat,
	otpAlreadyUsed = verifyErrorKind.OtpAlreadyUsed,
	tooManyAttempts = verifyErrorKind.OtpTooManyAttempts
}

local function verifySchoolOtp(p2, p3, p4, p5)
	local fetched = module.fetch({
		method = "POST",
		url = module3.emailOtp,
		analyticsKey = "school-verification.verify-otp",
		body = {
			schoolId = p2,
			otp = p4,
			graduationYearOption = {
				roleId = p3.roleId,
				activeStudent = p3.activeStudent
			}
		},
		network = p5,
		decode = function(p6)
			return module5.decodeVerifyOtp(p6)
		end
	})

	return module.asPromise(fetched):catch(function(p6)
		return module2.reject(module4(p6, v5))
	end)
end

return verifySchoolOtp
