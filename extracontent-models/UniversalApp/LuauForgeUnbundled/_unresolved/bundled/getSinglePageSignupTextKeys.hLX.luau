local module = require("@luauforge/bundled/hLY")
local module2 = require("@luauforge/bundled/hLZ")

local function getSinglePageSignupTextKeys(p2, p3)
	local v5 = module() or p3 == true
	local v6 = module2() and p2 == true

	return {
		signUpHeading = v5 and "Authentication.SignUp.Action.CreateAccountSentenceCase" or "Authentication.SignUp.Action.CreateAccount",
		signUpButton = "Authentication.SignUp.Action.CreateAccount",
		birthdayPickerHeading = v6 and "Authentication.SignUp.Label.SelectBirthdaySentenceCase" or "Authentication.SignUp.Label.Birthday",
		birthdayPickerConfirmButton = v6 and "Authentication.SignUp.Button.OKCaptialized" or "Authentication.SignUp.Label.ConfirmBirthday"
	}
end

return getSinglePageSignupTextKeys
