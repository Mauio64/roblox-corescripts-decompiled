local module = require("@luauforge/bundled/fFz")

require("@luauforge/bundled/fFr")
local module2 = require("@luauforge/bundled/fCy")

local function LoginStateReducer(p2, p3, p4)
	local clone = table.clone(p2)
	local kind = p3.type

	if kind == module2.SetUserIdentifierAndType then
		clone.userIdentifier = p3.data.userIdentifier
		clone.userIdentifierType = p3.data.userIdentifierType
	else
		if kind == module2.IncrementLoginAttempts then
			clone.numLoginAttempts += 1
			return clone
		end

		if kind == module2.ResetLoginAttempts then
			clone.numLoginAttempts = 0
			return clone
		end

		if kind == module2.SetAvailableLoginMethods then
			clone.availableLoginMethods = p3.data
			return clone
		end

		if kind == module2.UpdateCredentialsProtocolStatus then
			clone.credentialsProtocolStatus = module.Dictionary.join(
				clone.credentialsProtocolStatus,
				p3.data
			)
			clone.credentialsProtocolStatus.initialStateUpdated = true
		else
			if kind == module2.SetCredentialAutoPopupShown then
				clone.shouldAutoShowCredentialPopup = false
				return clone
			end

			if kind == module2.SetComponentState then
				clone.componentState[p3.data.component] = module.Dictionary.join(
					clone.componentState[p3.data.component],
					p3.data.payload
				)
				return clone
			end

			if kind == module2.ForceLoginByUsername then
				clone.forceLoginByUsername = true
				return clone
			end

			if kind == module2.ClearForcedUsernameOverride and clone.extraProps then
				clone.extraProps.forcedUsernameOverride = nil
			end
		end
	end

	return clone
end

return LoginStateReducer
