local module = require("@luauforge/bundled/ecV")

local authenticationProtocol = require("@luauforge/bundled/fND").AuthenticationProtocol
local module2 = require("@luauforge/bundled/fNS")
local module3 = require("@luauforge/bundled/eee")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppToastsRodux/RobloxAppToastsRodux")
local module5 = require("@luauforge/bundled/dCp")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

local module6 = require("@luauforge/bundled/fNT")
local module7 = require("@luauforge/bundled/fNW")

return function(p2, p3, p4, p5)
	return function(object)
		local default = authenticationProtocol.default
		local v5, v6

		if p5.useMSDKWebAuthentication() then
			local v7, v8 = object:dispatch(module6(p4, p2, p3)):await()

			if not v7 then
				object:dispatch(module7(false))
				return
			end

			local v9 = {
				name = module5.GenericWebPage,
				detail = v8.loginPage,
				extraProps = {
					titleKey = "Authentication.Login.QrCodeLoginTitle",
					onClose = function()
						object:dispatch(module7(false))
					end
				}
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v9))
			else
				object:dispatch(module3(v9))
			end

			v5, v6 = default:listenWebAuthResponset(authenticationProtocol.AuthProviders.MSDK):await()
		else
			v5, v6 = default:requestAuth(authenticationProtocol.AuthProviders.MSDK, p3):await()
		end

		if v5 then
			if v6.statusCode == 0 then
				return module.resolve(v6.tokenAuthBody)
			end

			p2.Diag:reportCounter("RequestMSDKLoginReturnErrorCode_" .. v6.statusCode, 1)
		end

		if p5.useMSDKWebAuthentication() then
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				object:dispatch(RobloxAppToastsRodux())
			end
		end

		object:dispatch(module2(v6.errMessageKey))
		p2.Diag:reportCounter("RequestMSDKLoginAuthenticationProtocolFailure", 1)
		return module.reject()
	end
end
