local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationSignupPageState = require(UserActivationFramework.Enums.UserActivationSignupPageState)
local NavigationAction = require(UserActivationFramework.Enums.NavigationAction)
local PayloadKey = require(UserActivationFramework.Enums.PayloadKey)

require(UserActivationFramework.Enums.Namespace)

local UserActivationFrameworkParent = UserActivationFramework.Parent
local FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage = require(UserActivationFrameworkParent.SharedFlags).FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage

function containsValue(p1, p2) -- line: 19
	for _, v in pairs(p1) do
		if v == p2 then
			return true
		end
	end

	return false
end

local function UpdateActivationWorkflow(p3, p4, t1: {[any]: any}, p5, t2: {[any]: any}, t3: {[any]: any}?) -- line: 28
	-- upvalues: NavigationAction (copy), FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage (copy), UserActivationSignupPageState (copy), PayloadKey (copy)
	if p5 == NavigationAction.Close then
		return nil
	end

	local v18 = if not FFlagEnableMultipageSignupNonInteractiveUserAgreementsPage then {
		[UserActivationSignupPageState.EnterBirthday] = UserActivationSignupPageState.EnterUserIdentifier,
		[UserActivationSignupPageState.EnterUserIdentifier] = UserActivationSignupPageState.AddAuthMethod,
		[UserActivationSignupPageState.AddAuthMethod] = UserActivationSignupPageState.SelectGender,
		[UserActivationSignupPageState.SelectGender] = UserActivationSignupPageState.Complete,
		[UserActivationSignupPageState.Complete] = UserActivationSignupPageState.Complete
	} else {
		[UserActivationSignupPageState.EnterBirthday] = UserActivationSignupPageState.NonInteractiveStoreUserAgreements,
		[UserActivationSignupPageState.NonInteractiveStoreUserAgreements] = UserActivationSignupPageState.EnterUserIdentifier,
		[UserActivationSignupPageState.EnterUserIdentifier] = UserActivationSignupPageState.AddAuthMethod,
		[UserActivationSignupPageState.AddAuthMethod] = UserActivationSignupPageState.SelectGender,
		[UserActivationSignupPageState.SelectGender] = UserActivationSignupPageState.Complete,
		[UserActivationSignupPageState.Complete] = UserActivationSignupPageState.Complete
	}

	v18[UserActivationSignupPageState.TestingPageA] = UserActivationSignupPageState.TestingPageB
	v18[UserActivationSignupPageState.TestingPageB] = UserActivationSignupPageState.TestingPageC

	local t4 = {
		[UserActivationSignupPageState.EnterBirthday] = {
			NavigationAction.Next,
			NavigationAction.Close
		},
		[UserActivationSignupPageState.EnterUserIdentifier] = {
			NavigationAction.Next,
			NavigationAction.Back
		},
		[UserActivationSignupPageState.NonInteractiveStoreUserAgreements] = {
			NavigationAction.Next,
			NavigationAction.Back
		},
		[UserActivationSignupPageState.AddAuthMethod] = {
			NavigationAction.Next,
			NavigationAction.Back
		},
		[UserActivationSignupPageState.SelectGender] = {
			NavigationAction.Next,
			NavigationAction.Back
		},
		[UserActivationSignupPageState.Complete] = {},
		[UserActivationSignupPageState.TestingPageA] = { NavigationAction.Next },
		[UserActivationSignupPageState.TestingPageB] = {
			NavigationAction.Next,
			NavigationAction.Back
		},
		[UserActivationSignupPageState.TestingPageC] = {}
	}
	local v20 = table.clone(t2)

	if p5 == NavigationAction.Next or p5 == NavigationAction.Skip then
		if p4 == UserActivationSignupPageState.EnterUserIdentifier and t3 and t3[PayloadKey.SignupPasskeyResult] and #t3[PayloadKey.SignupPasskeyResult] > 0 then
			p4 = UserActivationSignupPageState.SelectGender
		else
			p4 = v18[p4]

			if p4 == nil then
				return nil
			end
		end

		table.insert(v20, p4)
	elseif p5 == NavigationAction.Back then
		if not containsValue(t4[p4], NavigationAction.Back) then
			return nil
		end

		table.remove(v20)

		if #v20 == 0 then
			return nil
		end

		p4 = v20[#v20]
	elseif p5 == NavigationAction.Reset then
		p4 = t2[1]
		v20 = if not (#t2 > 0) then {} else { p4 }
	end

	local v21 = t4[p4] or {}

	if p4 == UserActivationSignupPageState.SelectGender and t3 and t3[PayloadKey.SignupPasskeyResult] and #t3[PayloadKey.SignupPasskeyResult] > 0 then
		v21 = { NavigationAction.Next }
	end

	return {
		namespace = p3,
		state = p4,
		availableActions = v21,
		payload = t1,
		history = v20
	}
end

return UpdateActivationWorkflow
