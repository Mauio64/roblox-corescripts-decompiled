local LinkStatus = require("@game/CorePackages/Packages/_Index/RoduxShareLinks/RoduxShareLinks/Enums/LinkStatus")

local function computeIsSignUpButtonEnabled(data): boolean
	local v5 = data.shouldUsePasswordlessSignup

	if data.passkeySignupEnabled and data.shouldUsePasskeySignup and not data.passkeysAvailable then
		v5 = false
	end

	if
		not data.signupCheckboxDisabled
		and data.shouldRequireSignupCheckbox
		and not data.signupAgreementsChecked
	then
		return false
	end

	local isDisplayNameFieldRequired = data.displayNamesOnSignupExperimentEnabled
		and data.isDisplayNameFieldRequired
	local v6

	if
		data.usernameValid == LinkStatus.Valid
		and data.passwordValid == LinkStatus.Valid
		and (not data.shouldUseAlternateBirthday or data.birthdayValid == LinkStatus.Valid)
	then
		if isDisplayNameFieldRequired then
			v6 = data.displayNameValid ~= LinkStatus.Valid
		end
	else
		v6 = true
	end

	if data.birthday and data.validBirthday == false then
		return false
	end

	if data.shouldUseMinimalSignup and data.birthday then
		if data.shouldUseAlternateBirthday and data.birthdayValid ~= LinkStatus.Valid then
			return false
		end

		return true
	elseif v5 and data.birthday and data.username ~= "" and data.usernameValid == LinkStatus.Valid then
		if data.shouldUseAlternateBirthday and data.birthdayValid ~= LinkStatus.Valid then
			return false
		end

		return true
	elseif
		data.birthday
		and not v6
		and data.username ~= ""
		and data.password ~= ""
		and (not isDisplayNameFieldRequired or data.displayName ~= "")
	then
		return data.validBirthday ~= false
	else
		return false
	end
end

return computeIsSignUpButtonEnabled
