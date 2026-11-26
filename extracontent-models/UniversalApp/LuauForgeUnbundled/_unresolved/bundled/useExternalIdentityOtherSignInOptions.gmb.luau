local module = require("@luauforge/bundled/ggX")
local eventStreamConstants = require("@luauforge/bundled/gjG").EventStreamConstants
local dialogSize = require("@luauforge/bundled/gjJ").Enums.DialogSize

local module2 = require("@luauforge/bundled/gjK")
require("@luauforge/bundled/gjL")

local function useExternalIdentityOtherSignInOptions(p2, p3)
	local module3 = require("@luauforge/bundled/gmc")
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
