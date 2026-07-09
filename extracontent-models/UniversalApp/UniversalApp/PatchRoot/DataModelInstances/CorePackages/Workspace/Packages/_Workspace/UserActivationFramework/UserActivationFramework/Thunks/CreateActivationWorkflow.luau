local UserActivationFramework = script:FindFirstAncestor("UserActivationFramework")
local UserActivationFrameworkParent = UserActivationFramework.Parent
local AppStorageUtilities = require(UserActivationFrameworkParent.AuthCommon).Utils.AppStorageUtilities
local UserActivationSignupPageState = require(UserActivationFramework.Enums.UserActivationSignupPageState)
local NavigationAction = require(UserActivationFramework.Enums.NavigationAction)

require(UserActivationFramework.Enums.PayloadKey)
require(UserActivationFramework.Enums.Namespace)

local function CreateActivationWorkflow(p1, t1: {[any]: any}, b1: boolean) -- line: 23
	-- upvalues: AppStorageUtilities (copy), UserActivationSignupPageState (copy), NavigationAction (copy)
	if b1 then
		AppStorageUtilities.setSignupActionRequired("")
		AppStorageUtilities.flush()
	end

	local EnterBirthday = UserActivationSignupPageState.EnterBirthday
	local t2 = {}

	if EnterBirthday == UserActivationSignupPageState.EnterBirthday then
		t2 = {
			NavigationAction.Close,
			NavigationAction.Next
		}
	elseif EnterBirthday == UserActivationSignupPageState.AddAuthMethod then
		t2 = { NavigationAction.Next }
	end

	return {
		namespace = p1,
		state = EnterBirthday,
		availableActions = t2,
		payload = t1,
		history = { EnterBirthday }
	}
end

return CreateActivationWorkflow
