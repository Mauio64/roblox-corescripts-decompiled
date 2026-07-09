local AccountRecovery = script:FindFirstAncestor("AccountRecovery")

require(AccountRecovery.Store.State)
require(AccountRecovery.Store.Action)

local ModalState = require(AccountRecovery.Enums.ModalState)
local AccountRecoveryActionType = require(AccountRecovery.Enums.AccountRecoveryActionType)

local function AccountRecoveryStateReducer(p1, p2, _) -- line: 8
	-- upvalues: AccountRecoveryActionType (copy), ModalState (copy)
	local v8 = table.clone(p1)
	local type = p2.type

	if type == AccountRecoveryActionType.SET_RECOVERY_SESSION_ID then
		v8.recoverySessionId = p2.data.recoverySessionId

		return v8
	end

	if type == AccountRecoveryActionType.SET_PHONE_PREFIX_LIST then
		v8.phonePrefixList = p2.data.phonePrefixList

		return v8
	end

	if type == AccountRecoveryActionType.SET_MODAL_STATE_AND_PROPS then
		v8.modalStateAndProps = p2.data.modalStateAndProps

		return v8
	end

	if type == AccountRecoveryActionType.SET_RECOVERY_INTENT then
		v8.recover2sv = p2.data.recover2sv
		v8.recoverPassword = p2.data.recoverPassword

		return v8
	end

	if type == AccountRecoveryActionType.RESET_RECOVERY_FLOW then
		v8.continuingRecovery = p2.data.continuingRecovery
		v8.recoverySessionId = p2.data.recoverySessionId
		v8.autofillIdentifier = p2.data.autofillIdentifier
		v8.recover2sv = p2.data.recover2sv
		v8.recoverPassword = p2.data.recoverPassword
		v8.deeplinkUuid = p2.data.deeplinkUuid
		v8.modalStateAndProps = {
			props = nil,
			modalState = ModalState.NONE
		}
	end

	return v8
end

return AccountRecoveryStateReducer
