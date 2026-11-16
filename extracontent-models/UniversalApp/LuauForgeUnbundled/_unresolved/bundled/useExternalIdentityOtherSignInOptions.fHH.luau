local module = require("@luauforge/bundled/fCE")
local eventStreamConstants = require("@luauforge/bundled/fFm").EventStreamConstants
local dialogSize = require("@luauforge/bundled/fFp").Enums.DialogSize

local module2 = require("@luauforge/bundled/fFq")
require("@luauforge/bundled/fFr")

local function useExternalIdentityOtherSignInOptions(p2, p3)
	local module3 = require("@luauforge/bundled/fHI")
	local v5 = module.useContext(module2)
	local utils = v5.utils

	local v6 = {
		isUserAuthenticated = utils.isUserAuthenticated,
		getCapabilities = utils.getExternalIdentityCapabilities,
		authenticate = utils.authenticateWithExternalIdentity,
		eventContext = eventStreamConstants.Context.LoginFormV2Username,
		eventOrigin = v5.eventOrigin,
		modalField = eventStreamConstants.Field.LoginV2OtherSignInOptionsModal,
		dialogSize = 0
	}

	local v7 = if v5.isDialogLayoutForced then dialogSize.Medium else nil
	v6.dialogSize = v7
	return module3(p2, p3, v6)
end

return useExternalIdentityOtherSignInOptions
