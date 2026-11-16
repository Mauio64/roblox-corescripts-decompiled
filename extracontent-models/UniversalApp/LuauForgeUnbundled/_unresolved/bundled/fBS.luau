local setAuthenticationStatus = require("@luauforge/bundled/fBO").Actions.SetAuthenticationStatus
local module = require("@luauforge/bundled/dHq")
local module2 = require("@luauforge/bundled/fBn")
local module3 = require("@luauforge/bundled/fBQ")
local module4 = require("@luauforge/bundled/fAJ")
local module5 = require("@luauforge/bundled/dCp")
local module6 = require("@luauforge/bundled/eee")
local module7 = require("@luauforge/bundled/dCo")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseSignalsForAuthenticationStatus = SharedFlags.FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/fBO").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

return function(p2)
	return function(object)
		return module4(p2):andThen(function(p3)
			module2.setRobloxLocaleId(p3.signupAndLoginLocale)

			if fFlagUseSignalsForAuthenticationStatus then
				getAuthenticationStatusStore(false).setAuthenticationStatus(module3.LOGGED_OUT)
			else
				object:dispatch(setAuthenticationStatus(module3.LOGGED_OUT))
			end

			if module7.WeChatLoginEnabled() then
				object:dispatch(module({
					{ name = module5.WeChatLoginWrapper }
				}))
			elseif module7.LuaAppLoginUIEnabled() then
				object:dispatch(module({
					{ name = module5.Landing }
				}))
			elseif fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage({
					name = module5.LoginNative
				}))
			else
				object:dispatch(module6({ name = module5.LoginNative }))
			end
		end)
	end
end
