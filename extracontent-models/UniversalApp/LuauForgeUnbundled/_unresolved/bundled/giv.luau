local launchContext = require("@luauforge/bundled/giw").Enums.LaunchContext
local getPasswordManagerUsageStore = require("@luauforge/bundled/gix").Stores.GetPasswordManagerUsageStore

return {
	userJustLoggedIn = function(object): boolean
		object:flush()
		return object:getState().LaunchContext == launchContext.Login
	end,
	didUsePasswordManagerMediatedLogin = function()
		local passwordManagerUsageStore = getPasswordManagerUsageStore(false)

		if passwordManagerUsageStore == nil then
			return false
		end

		return passwordManagerUsageStore.getLoggedinUsingSavedPassword(false)
			or passwordManagerUsageStore.getSavedPasswordAfterLogin(false)
	end,
	didUsePasswordManagerMediatedSignup = function()
		local passwordManagerUsageStore = getPasswordManagerUsageStore(false)

		if passwordManagerUsageStore == nil then
			return false
		end

		return passwordManagerUsageStore.getPasswordManagerMediatedSignup(false)
	end
}
