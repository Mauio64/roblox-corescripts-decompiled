local Parent = script:FindFirstAncestor("PreHomePage").Parent
local LaunchContext = require(Parent.AppStartup).Enums.LaunchContext
local GetPasswordManagerUsageStore = require(Parent.AuthCommon).Stores.GetPasswordManagerUsageStore

return {
	userJustLoggedIn = function(p1) -- line: 14
		-- upvalues: LaunchContext (copy)
		p1:flush()

		return p1:getState().LaunchContext == LaunchContext.Login
	end,
	didUsePasswordManagerMediatedLogin = function() -- line: 20
		-- upvalues: GetPasswordManagerUsageStore (copy)
		local v5 = GetPasswordManagerUsageStore(false)

		if v5 == nil then
			return false
		end

		return v5.getLoggedinUsingSavedPassword(false) or v5.getSavedPasswordAfterLogin(false)
	end,
	didUsePasswordManagerMediatedSignup = function() -- line: 30
		-- upvalues: GetPasswordManagerUsageStore (copy)
		local v6 = GetPasswordManagerUsageStore(false)

		if v6 == nil then
			return false
		end

		return v6.getPasswordManagerMediatedSignup(false)
	end
}
