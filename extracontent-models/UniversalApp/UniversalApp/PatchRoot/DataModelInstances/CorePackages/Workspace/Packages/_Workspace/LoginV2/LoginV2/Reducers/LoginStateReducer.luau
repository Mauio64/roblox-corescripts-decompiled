local LoginV2 = script:FindFirstAncestor("LoginV2")
local LoginV2Parent = LoginV2.Parent
local Cryo = require(LoginV2Parent.Cryo)

require(LoginV2.Components.Types)

local LoginActionType = require(LoginV2.Enums.LoginActionType)

local function LoginStateReducer(p1, p2, _) -- line: 9
	-- upvalues: LoginActionType (copy), Cryo (copy)
	local v9 = table.clone(p1)
	local type = p2.type

	if type == LoginActionType.SetUserIdentifierAndType then
		v9.userIdentifier = p2.data.userIdentifier
		v9.userIdentifierType = p2.data.userIdentifierType

		return v9
	end

	if type == LoginActionType.IncrementLoginAttempts then
		v9.numLoginAttempts = v9.numLoginAttempts + 1

		return v9
	end

	if type == LoginActionType.ResetLoginAttempts then
		v9.numLoginAttempts = 0

		return v9
	end

	if type == LoginActionType.SetAvailableLoginMethods then
		v9.availableLoginMethods = p2.data

		return v9
	end

	if type == LoginActionType.UpdateCredentialsProtocolStatus then
		v9.credentialsProtocolStatus = Cryo.Dictionary.join(v9.credentialsProtocolStatus, p2.data)
		v9.credentialsProtocolStatus.initialStateUpdated = true

		return v9
	end

	if type == LoginActionType.SetCredentialAutoPopupShown then
		v9.shouldAutoShowCredentialPopup = false

		return v9
	end

	if type == LoginActionType.SetComponentState then
		v9.componentState[p2.data.component] = Cryo.Dictionary.join(v9.componentState[p2.data.component], p2.data.payload)

		return v9
	end

	if type == LoginActionType.ForceLoginByUsername then
		v9.forceLoginByUsername = true

		return v9
	end

	if type == LoginActionType.ClearForcedUsernameOverride and v9.extraProps then
		v9.extraProps.forcedUsernameOverride = nil
	end

	return v9
end

return LoginStateReducer
