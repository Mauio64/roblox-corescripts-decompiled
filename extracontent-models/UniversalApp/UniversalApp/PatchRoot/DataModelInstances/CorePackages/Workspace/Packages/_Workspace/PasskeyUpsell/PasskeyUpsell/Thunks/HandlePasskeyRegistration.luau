local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local AuthCommon = require(Parent.AuthCommon)
local RegisterPasskey = AuthCommon.Thunks.RegisterPasskey
local PasskeyConstants = AuthCommon.Common.PasskeyConstants
local Promise = require(Parent.Promise)
local Logger = require(Parent.Loggers).Logger

local function handlePasskeyRegistration(p1, s1: string?) -- line: 17
	-- upvalues: Logger (copy), RegisterPasskey (copy), Promise (copy), PasskeyConstants (copy)
	Logger:info("Invoking RegisterPasskey")

	return RegisterPasskey(p1, s1 or "passkeyUpsell"):andThen(function() -- line: 19
		-- upvalues: Logger (copy), Promise (copy)
		Logger:info("Passkey Upsell Registration completed.")

		return Promise.resolve(true)
	end, function(p2) -- line: 23
		-- upvalues: Logger (copy), PasskeyConstants (copy), Promise (copy)
		Logger:debug("User encountered unknown error during passkey upsell registration: ", p2)

		if p2 and p2.name == PasskeyConstants.USER_OS_DIALOG_ERROR_NAME then
			return Promise.resolve(false)
		end

		return Promise.reject()
	end)
end

return handlePasskeyRegistration
