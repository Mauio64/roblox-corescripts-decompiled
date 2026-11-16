require("@luauforge/bundled/fJi")
require("@luauforge/bundled/fJB")
local module = require("@luauforge/bundled/fJD")
local module2 = require("@luauforge/bundled/fJC")

local function AccountRecoveryStateReducer(p2, p3, p4)
	local clone = table.clone(p2)
	local kind = p3.type

	if kind == module2.SET_RECOVERY_SESSION_ID then
		clone.recoverySessionId = p3.data.recoverySessionId
		return clone
	end

	if kind == module2.SET_PHONE_PREFIX_LIST then
		clone.phonePrefixList = p3.data.phonePrefixList
		return clone
	end

	if kind == module2.SET_MODAL_STATE_AND_PROPS then
		clone.modalStateAndProps = p3.data.modalStateAndProps
		return clone
	end

	if kind == module2.SET_RECOVERY_INTENT then
		clone.recover2sv = p3.data.recover2sv
		clone.recoverPassword = p3.data.recoverPassword
	elseif kind == module2.RESET_RECOVERY_FLOW then
		clone.continuingRecovery = p3.data.continuingRecovery
		clone.recoverySessionId = p3.data.recoverySessionId
		clone.autofillIdentifier = p3.data.autofillIdentifier
		clone.recover2sv = p3.data.recover2sv
		clone.recoverPassword = p3.data.recoverPassword
		clone.deeplinkUuid = p3.data.deeplinkUuid
		clone.modalStateAndProps = { modalState = module.NONE, props = nil }
	end

	return clone
end

return AccountRecoveryStateReducer
