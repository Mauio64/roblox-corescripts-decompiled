local MultiPageSignup = script:FindFirstAncestor("MultiPageSignup")
local MultiPageSignupParent = MultiPageSignup.Parent
local UserActivationFramework = require(MultiPageSignupParent.UserActivationFramework)
local UserActivationSignupPageState = UserActivationFramework.Enums.UserActivationSignupPageState

require(MultiPageSignupParent.Navigation)

local React = require(MultiPageSignupParent.React)
local EnterBirthdayComponent = require(MultiPageSignup.Components.EnterBirthdayComponent)
local EnterUserIdentifierComponent = require(MultiPageSignup.Components.EnterUserIdentifierComponent)
local AddAuthMethodComponent = require(MultiPageSignup.Components.AddAuthMethodComponent)
local SelectGenderComponent = require(MultiPageSignup.Components.SelectGenderComponent)
local NonInteractiveStoreUserAgreementsComponent = require(MultiPageSignup.Components.NonInteractiveStoreUserAgreementsComponent)
local Cryo = require(MultiPageSignupParent.Cryo)
local Namespace = UserActivationFramework.Enums.Namespace

return function() -- line: 28
	-- upvalues: UserActivationSignupPageState (copy), EnterBirthdayComponent (copy), Cryo (copy), Namespace (copy), React (copy), NonInteractiveStoreUserAgreementsComponent (copy), EnterUserIdentifierComponent (copy), AddAuthMethodComponent (copy), SelectGenderComponent (copy)
	local t1 = {}
	local t2 = {}
	local EnterBirthday = UserActivationSignupPageState.EnterBirthday
	local v17 = EnterBirthdayComponent

	t2[EnterBirthday] = function(p1) -- line: 20
		-- upvalues: Cryo (copy), Namespace (copy), React (copy), v17 (copy)
		local v33 = Cryo.Dictionary.join(p1, {
			namespace = Namespace.MultiPageSignup
		})

		return React.createElement(v17, v33)
	end

	local t3 = {}
	local NonInteractiveStoreUserAgreements = UserActivationSignupPageState.NonInteractiveStoreUserAgreements
	local v20 = NonInteractiveStoreUserAgreementsComponent

	t3[NonInteractiveStoreUserAgreements] = function(p2) -- line: 20
		-- upvalues: Cryo (copy), Namespace (copy), React (copy), v20 (copy)
		local v35 = Cryo.Dictionary.join(p2, {
			namespace = Namespace.MultiPageSignup
		})

		return React.createElement(v20, v35)
	end

	local t4 = {}
	local EnterUserIdentifier = UserActivationSignupPageState.EnterUserIdentifier
	local v23 = EnterUserIdentifierComponent

	t4[EnterUserIdentifier] = function(p3) -- line: 20
		-- upvalues: Cryo (copy), Namespace (copy), React (copy), v23 (copy)
		local v37 = Cryo.Dictionary.join(p3, {
			namespace = Namespace.MultiPageSignup
		})

		return React.createElement(v23, v37)
	end

	local t5 = {}
	local AddAuthMethod = UserActivationSignupPageState.AddAuthMethod
	local v26 = AddAuthMethodComponent

	t5[AddAuthMethod] = function(p4) -- line: 20
		-- upvalues: Cryo (copy), Namespace (copy), React (copy), v26 (copy)
		local v39 = Cryo.Dictionary.join(p4, {
			namespace = Namespace.MultiPageSignup
		})

		return React.createElement(v26, v39)
	end

	local t6 = {}
	local SelectGender = UserActivationSignupPageState.SelectGender
	local v29 = SelectGenderComponent

	t6[SelectGender] = function(p5) -- line: 20
		-- upvalues: Cryo (copy), Namespace (copy), React (copy), v29 (copy)
		local v41 = Cryo.Dictionary.join(p5, {
			namespace = Namespace.MultiPageSignup
		})

		return React.createElement(v29, v41)
	end
	t1[1] = t2
	t1[2] = t3
	t1[3] = t4
	t1[4] = t5
	t1[5] = t6

	return t1
end
