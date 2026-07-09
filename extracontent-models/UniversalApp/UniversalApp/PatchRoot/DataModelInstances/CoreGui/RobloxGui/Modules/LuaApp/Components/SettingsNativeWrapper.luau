local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local default = require(CorePackages.Workspace.Packages.CredentialsProtocol).CredentialsProtocol.default
local JavascriptHybrid = require(Modules.LuaApp.Enum.JavascriptHybrid)
local ExecuteJavaScriptInWebView = require(Modules.LuaApp.Util.ExecuteJavaScriptInWebView)
local BrowserServiceWrapper = require(Modules.LuaApp.Components.BrowserServiceWrapper)
local withLocalization = require(Modules.LuaApp.withLocalization)
local GetFFlagLuaAppEnableCredentialsProtocol = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFFlagLuaAppEnableCredentialsProtocol
local GetFIntLuaAppCredentialsProtocolTimeout = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolTimeout
local GetFIntLuaAppCredentialsProtocolAvailableTimeout = require(CorePackages.Workspace.Packages.CredentialsProtocol).Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local v15 = game:DefineFastFlag("RequireDeviceBoundOnlyForFIDO2", false)
local v16 = Roact.PureComponent:extend("SettingsNativeWrapper")

v16.defaultProps = {
	url = nil,
	titleKey = nil,
	isVisible = false,
	windowClosedCallback = nil,
	displayOrder = nil,
	BrowserWrapperComponent = BrowserServiceWrapper
}

local function getFeatureStringFromHybridEvent(p1) -- line: 33
	-- upvalues: JavascriptHybrid (copy)
	if p1.moduleID == JavascriptHybrid.Module.Navigation and (p1.functionName == JavascriptHybrid.Function.navigateToFeature and p1.params and p1.params.params) then
		return p1.params.params.feature
	end

	return nil
end

function v16.render(p2) -- line: 45
	-- upvalues: withLocalization (copy), Roact (copy), HttpService (copy), GetFFlagLuaAppEnableCredentialsProtocol (copy), JavascriptHybrid (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v15 (copy), ExecuteJavaScriptInWebView (copy), GetFIntLuaAppCredentialsProtocolTimeout (copy), Logging (copy)
	return withLocalization({
		title = p2.props.titleKey
	})(function(p3) -- line: 46
		-- upvalues: Roact (copy), p2 (copy), HttpService (copy), GetFFlagLuaAppEnableCredentialsProtocol (copy), JavascriptHybrid (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v15 (copy), ExecuteJavaScriptInWebView (copy), GetFIntLuaAppCredentialsProtocolTimeout (copy), Logging (copy)
		return Roact.createElement(p2.props.BrowserWrapperComponent, {
			modal = false,
			webViewVisible = true,
			isGenericWebview = true,
			isVisible = p2.props.isVisible,
			title = p3.title,
			displayOrder = p2.props.displayOrder,
			url = p2.props.url,
			windowClosedCallback = p2.props.windowClosedCallback,
			javaScriptCallback = function(p4) -- line: 56
				-- upvalues: HttpService (copy), GetFFlagLuaAppEnableCredentialsProtocol (copy), JavascriptHybrid (copy), default (copy), GetFIntLuaAppCredentialsProtocolAvailableTimeout (copy), v15 (copy), ExecuteJavaScriptInWebView (copy), GetFIntLuaAppCredentialsProtocolTimeout (copy), Logging (copy)
				local data = HttpService:JSONDecode(p4)

				if GetFFlagLuaAppEnableCredentialsProtocol() and ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.CredentialsProtocolAvailable then
					default:isAvailable(default.CredentialsTypes.FIDO2, GetFIntLuaAppCredentialsProtocolAvailableTimeout()):andThen(function(p5) -- line: 69
						-- upvalues: v15 (copy), ExecuteJavaScriptInWebView (copy), data (copy)
						local v24 = p5.isAvailable or false

						if v15 then
							v24 = not not v24 and (p5.supportsDeviceBoundOnly or false)
						end

						ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, (tostring(v24)))
					end):catch(function() -- line: 77
						-- upvalues: ExecuteJavaScriptInWebView (copy), data (copy)
						ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, "false")
					end)

					return
				end

				if GetFFlagLuaAppEnableCredentialsProtocol() and ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.RegisterCredentials then
					default:registerCredentials(default.CredentialsTypes.FIDO2, data.params.params.data.creationOptionsJSON, GetFIntLuaAppCredentialsProtocolTimeout()):andThen(function(p6) -- line: 93
						-- upvalues: Logging (copy), HttpService (copy), ExecuteJavaScriptInWebView (copy), data (copy)
						if p6 ~= nil then
							Logging.warn("Executing javascript on webview to return RegisterCredentialsResponse")

							local json = HttpService:JSONEncode(p6)

							ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, json)
						end
					end):catch(function() -- line: 100
						-- upvalues: ExecuteJavaScriptInWebView (copy), data (copy)
						ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, "")
					end)

					return
				end

				if GetFFlagLuaAppEnableCredentialsProtocol() and ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.GetCredentials then
					default:getCredentials(default.CredentialsTypes.FIDO2, data.params.params.data.authenticationOptionsJSON, GetFIntLuaAppCredentialsProtocolTimeout()):andThen(function(p7) -- line: 116
						-- upvalues: Logging (copy), HttpService (copy), ExecuteJavaScriptInWebView (copy), data (copy)
						if p7 ~= nil then
							Logging.warn("Executing javascript on webview to return GetCredentialsResponse")

							local json = HttpService:JSONEncode(p7)

							ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, json)
						end
					end):catch(function() -- line: 123
						-- upvalues: ExecuteJavaScriptInWebView (copy), data (copy)
						ExecuteJavaScriptInWebView.Execute(data.params.params.data.callId, "")
					end)

					return
				end
			end
		})
	end)
end

return (RoactNavigation.withNavigation(v16))
