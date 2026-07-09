local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local VerifyEmailPage = require(script.Parent.VerifyEmailPage)
local TextKeys = require(Schools.Common.TextKeys)
local isValidEmail = require(Schools.Common.isValidEmail)
local Routes = require(Schools.Navigation.Routes)

local function VerifyEmailContainer(t1: {[any]: any}) -- line: 16
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), isValidEmail (copy), Routes (copy), VerifyEmailPage (copy)
	local navigation = t1.navigation
	local v12 = useLocalization({
		errorInvalidEmail = TextKeys.VerifyEmailErrorInvalidEmail
	})
	local v13, v14 = React.useState("")
	local v15, v16 = React.useState(function() -- line: 24
		return nil
	end)
	local v17 = React.useCallback(function(s1: string) -- line: 28
		-- upvalues: v14 (copy), v16 (copy)
		v14(s1)
		v16(nil)
	end, {})
	local v18 = React.useCallback(function() -- line: 34
		-- upvalues: navigation (copy)
		navigation.pop()
	end, { navigation })
	local v19 = React.useCallback(function() -- line: 38
		-- upvalues: isValidEmail (copy), v13 (copy), v16 (copy), v12 (copy), navigation (copy), Routes (copy)
		if not isValidEmail(v13) then
			v16(v12.errorInvalidEmail)

			return
		end

		v16(nil)
		navigation.navigate(Routes.SchoolWaitlist)
	end, {
		v13,
		v12.errorInvalidEmail,
		navigation
	})
	local v20 = React.useCallback(function() -- line: 51
	end, {})
	local v21 = React.useCallback(function() -- line: 55
	end, {})
	local v22 = React.useCallback(function() -- line: 59
	end, {})

	return React.createElement(VerifyEmailPage, {
		email = v13,
		onEmailChanged = v17,
		errorMessage = v15,
		onContinue = v19,
		onBack = v18,
		onLearnMore = v20,
		onTermsOfService = v21,
		onPrivacyPolicy = v22
	})
end

return VerifyEmailContainer
