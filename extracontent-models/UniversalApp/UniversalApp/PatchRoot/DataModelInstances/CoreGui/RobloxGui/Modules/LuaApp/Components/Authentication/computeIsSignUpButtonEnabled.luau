local Modules = game:GetService("CoreGui").RobloxGui.Modules
local InputValidity = require(Modules.LuaApp.Components.Authentication.Enum.InputValidity)

local function computeIsSignUpButtonEnabled(t1: {[any]: any}) -- line: 29
	-- upvalues: InputValidity (copy)
	local shouldUsePasswordlessSignup = t1.shouldUsePasswordlessSignup

	if t1.passkeySignupEnabled and (t1.shouldUsePasskeySignup and not t1.passkeysAvailable) then
		shouldUsePasswordlessSignup = false
	end

	if not t1.signupCheckboxDisabled and t1.shouldRequireSignupCheckbox and not t1.signupAgreementsChecked then
		return false
	end

	local v6 = t1.displayNamesOnSignupExperimentEnabled and t1.isDisplayNameFieldRequired
	local v7 = t1.usernameValid ~= InputValidity.Valid or (t1.passwordValid ~= InputValidity.Valid or not not t1.shouldUseAlternateBirthday and t1.birthdayValid ~= InputValidity.Valid) or if not v6 then nil else t1.displayNameValid ~= InputValidity.Valid

	if t1.useBirthdayDropdownForGamepadEnabled and t1.birthday and t1.validBirthday == false then
		return false
	end

	if t1.shouldUseMinimalSignup and t1.birthday then
		if t1.shouldUseAlternateBirthday and t1.birthdayValid ~= InputValidity.Valid then
			return false
		end

		return true
	end

	if shouldUsePasswordlessSignup and t1.birthday and t1.username ~= "" and t1.usernameValid == InputValidity.Valid then
		if t1.shouldUseAlternateBirthday and t1.birthdayValid ~= InputValidity.Valid then
			return false
		end

		return true
	end

	if not t1.birthday or v7 or t1.username == "" or t1.password == "" or (v6 and t1.displayName == "" or nil) then
		return false
	end

	if t1.validBirthday == false then
		return false
	end

	return true
end

return computeIsSignUpButtonEnabled
