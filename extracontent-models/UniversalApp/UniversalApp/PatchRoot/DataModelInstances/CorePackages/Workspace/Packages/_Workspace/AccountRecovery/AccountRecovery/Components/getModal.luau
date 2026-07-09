local AccountRecovery = script:FindFirstAncestor("AccountRecovery")
local AccountRecoveryParent = AccountRecovery.Parent
local React = require(AccountRecoveryParent.React)
local memoize = require(AccountRecoveryParent.AppCommonLib).memoize

require(AccountRecovery.Components.Types)

local ModalState = require(AccountRecovery.Enums.ModalState)
local UpdateEmail = require(AccountRecovery.Components.Modal.UpdateEmail)
local SaveOrDeleteTwoStepMethod = require(AccountRecovery.Components.Modal.SaveOrDeleteTwoStepMethod)
local AddNewPasskey = require(AccountRecovery.Components.Modal.AddNewPasskey)

return memoize(function(p1) -- line: 13
	-- upvalues: ModalState (copy), React (copy), UpdateEmail (copy), SaveOrDeleteTwoStepMethod (copy), AddNewPasskey (copy)
	if p1 == nil then
		return nil
	end

	if p1.modalState == ModalState.UPDATE_EMAIL then
		return React.createElement(UpdateEmail, p1.props)
	end

	if p1.modalState == ModalState.SAVE_OR_DELETE_TWO_STEP_METHOD then
		return React.createElement(SaveOrDeleteTwoStepMethod, p1.props)
	end

	if p1.modalState == ModalState.ADD_NEW_PASSKEY then
		return React.createElement(AddNewPasskey, p1.props)
	end

	return nil
end)
