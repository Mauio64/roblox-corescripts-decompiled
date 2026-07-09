local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local AuthenticationProtocol = require(CorePackages.Workspace.Packages.AuthenticationProtocol).AuthenticationProtocol
local SetMSDKLoginErrMessageKey = require(Modules.Luobu.Actions.SetMSDKLoginErrMessageKey)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local AppPage = require(Modules.LuaApp.AppPage)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local RequestAuthMetaData = require(Modules.Luobu.Thunks.RequestAuthMetaData)
local SetMSDKLoginInProgress = require(Modules.Luobu.Actions.SetMSDKLoginInProgress)

return function(p1, p2, p3, p4) -- line: 17
	-- upvalues: AuthenticationProtocol (copy), RequestAuthMetaData (copy), SetMSDKLoginInProgress (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), Promise (copy), NavigateBack (copy), SetMSDKLoginErrMessageKey (copy)
	return function(p5) -- line: 18
		-- upvalues: AuthenticationProtocol (copy), p4 (copy), RequestAuthMetaData (copy), p3 (copy), p1 (copy), p2 (copy), SetMSDKLoginInProgress (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy), Promise (copy), NavigateBack (copy), SetMSDKLoginErrMessageKey (copy)
		local default = AuthenticationProtocol.default
		local v22, v23

		if p4.useMSDKWebAuthentication() then
			local v19, v20 = p5:dispatch(RequestAuthMetaData(p3, p1, p2)):await()

			if not v19 then
				p5:dispatch(SetMSDKLoginInProgress(false))

				return
			end

			local t1 = {
				name = AppPage.GenericWebPage,
				detail = v20.loginPage,
				extraProps = {
					titleKey = "Authentication.Login.QrCodeLoginTitle",
					onClose = function() -- line: 34
						-- upvalues: p5 (copy), SetMSDKLoginInProgress (copy)
						p5:dispatch(SetMSDKLoginInProgress(false))
					end
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v10.down(v10.fromLegacyPage(t1))
			else
				p5:dispatch(NavigateDown(t1))
			end

			v22, v23 = default:listenWebAuthResponset(AuthenticationProtocol.AuthProviders.MSDK):await()
		else
			v22, v23 = default:requestAuth(AuthenticationProtocol.AuthProviders.MSDK, p2):await()
		end

		if v22 then
			if v23.statusCode == 0 then
				return Promise.resolve(v23.tokenAuthBody)
			end

			p1.Diag:reportCounter("RequestMSDKLoginReturnErrorCode_" .. v23.statusCode, 1)
		end

		if p4.useMSDKWebAuthentication() then
			if FFlagSignalsNavP3Dispatch then
				v10.back()
			else
				p5:dispatch(NavigateBack())
			end
		end

		p5:dispatch(SetMSDKLoginErrMessageKey(v23.errMessageKey))
		p1.Diag:reportCounter("RequestMSDKLoginAuthenticationProtocolFailure", 1)

		return Promise.reject()
	end
end
