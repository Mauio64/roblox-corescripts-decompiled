local module = require("@luauforge/deferred/ehk")
local module2 = require("@luauforge/deferred/ehl")

local module3 = require("@luauforge/deferred/ehm")
local module4 = require("@luauforge/deferred/eho")
local module5 = require("@luauforge/deferred/ehp")
local module6 = require("@luauforge/deferred/egW")
require("@luauforge/deferred/egX")

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
