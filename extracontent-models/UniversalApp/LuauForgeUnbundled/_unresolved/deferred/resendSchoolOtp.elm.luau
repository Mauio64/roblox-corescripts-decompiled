local module = require("@luauforge/deferred/ekE")
local module2 = require("@luauforge/deferred/ekF")

local module3 = require("@luauforge/deferred/ekG")
local module4 = require("@luauforge/deferred/ekI")
require("@luauforge/deferred/ekr")
local module5 = require("@luauforge/deferred/ekq")

local v5 = { tooManyAttempts = module5.VerifyErrorKind.OtpTooManyAttempts }

local v6 = { [429] = module5.VerifyErrorKind.OtpTooManyAttempts }

local function resendSchoolOtp(p2)
	local fetched = module.fetch({
		method = "POST",
		url = module3.otpResend,
		analyticsKey = "school-verification.resend-otp",
		network = p2,
		decode = function(): nil
			return nil
		end
	})

	return module.asPromise(fetched):catch(function(p3)
		return module2.reject(module4(p3, v5, v6))
	end)
end

return resendSchoolOtp
