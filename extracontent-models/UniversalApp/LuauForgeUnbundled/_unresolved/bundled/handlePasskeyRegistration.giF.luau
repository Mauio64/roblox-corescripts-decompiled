local module = require("@luauforge/bundled/giG")
local registerPasskey = module.Thunks.RegisterPasskey
local passkeyConstants = module.Common.PasskeyConstants
local passkeyRegistrationSource = module.Enums.PasskeyRegistrationSource
local module2 = require("@luauforge/bundled/giH")
local logger = require("@luauforge/bundled/giI").Logger

local fFlagEmitPasskeyRegistrationSourceOnFinish = require("@luauforge/bundled/giJ").FFlagEmitPasskeyRegistrationSourceOnFinish

local function handlePasskeyRegistration(p2, value, p3)
	logger:info("Invoking RegisterPasskey")
	local v5 = value or "passkeyUpsell"
	local v6

	if fFlagEmitPasskeyRegistrationSourceOnFinish then
		v6 = registerPasskey(p2, v5, nil, p3 or passkeyRegistrationSource.PasskeyUpsellPostLogin)
	else
		v6 = registerPasskey(p2, v5)
	end

	return v6:andThen(function()
		logger:info("Passkey Upsell Registration completed.")
		return module2.resolve(true)
	end, function(p4)
		logger:debug("User encountered unknown error during passkey upsell registration: ", p4)

		if p4 and p4.name == passkeyConstants.USER_OS_DIALOG_ERROR_NAME then
			return module2.resolve(false)
		end

		return module2.reject()
	end)
end

return handlePasskeyRegistration
