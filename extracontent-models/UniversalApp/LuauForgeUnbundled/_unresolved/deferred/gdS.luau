local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local default = require("@luauforge/bundled/fCb").CredentialsProtocol.default
local module = require("@luauforge/deferred/fUI")
local module2 = require("@luauforge/deferred/gdT")
local module3 = require("@luauforge/deferred/fov")
local module4 = require("@luauforge/bundled/edC")

local getFFlagLuaAppEnableCredentialsProtocol = require("@luauforge/bundled/fCb").Flags.GetFFlagLuaAppEnableCredentialsProtocol

local getFIntLuaAppCredentialsProtocolTimeout = require("@luauforge/bundled/fCb").Flags.GetFIntLuaAppCredentialsProtocolTimeout

local getFIntLuaAppCredentialsProtocolAvailableTimeout = require("@luauforge/bundled/fCb").Flags.GetFIntLuaAppCredentialsProtocolAvailableTimeout
local defineFastFlag = game:DefineFastFlag("RequireDeviceBoundOnlyForFIDO2", false)

local extended = Roact.PureComponent:extend("SettingsNativeWrapper")

extended.defaultProps = {
	BrowserWrapperComponent = module3,
	url = nil,
	titleKey = nil,
	isVisible = false,
	windowClosedCallback = nil,
	displayOrder = nil
}

local function getFeatureStringFromHybridEvent(data)
	if
		data.moduleID == module.Module.Navigation
		and data.functionName == module.Function.navigateToFeature
		and data.params
		and data.params.params
	then
		return data.params.params.feature
	end

	return nil
end

function extended.render(p2)
	return module4({ title = p2.props.titleKey })(function(p3)
		return Roact.createElement(p2.props.BrowserWrapperComponent, {
			isVisible = p2.props.isVisible,
			modal = false,
			title = p3.title,
			webViewVisible = true,
			displayOrder = p2.props.displayOrder,
			url = p2.props.url,
			isGenericWebview = true,
			windowClosedCallback = p2.props.windowClosedCallback,
			javaScriptCallback = function(json)
				local jsonDecode = HttpService:JSONDecode(json)

				if getFFlagLuaAppEnableCredentialsProtocol() then
					local v5

					if
						jsonDecode.moduleID == module.Module.Navigation
						and jsonDecode.functionName == module.Function.navigateToFeature
						and jsonDecode.params
						and jsonDecode.params.params
					then
						v5 = jsonDecode.params.params.feature
					end

					if v5 == module.Feature.CredentialsProtocolAvailable then
						default:isAvailable(
							default.CredentialsTypes.FIDO2,
							getFIntLuaAppCredentialsProtocolAvailableTimeout()
						):andThen(function(p4)
							local v6 = p4.isAvailable or false

							if defineFastFlag then
								v6 = v6 and p4.supportsDeviceBoundOnly or false
							end

							module2.Execute(jsonDecode.params.params.data.callId, (tostring(v6)))
						end):catch(function()
							module2.Execute(jsonDecode.params.params.data.callId, "false")
						end)
						return
					end
				end

				if getFFlagLuaAppEnableCredentialsProtocol() then
					local v5

					if
						jsonDecode.moduleID == module.Module.Navigation
						and jsonDecode.functionName == module.Function.navigateToFeature
						and jsonDecode.params
						and jsonDecode.params.params
					then
						v5 = jsonDecode.params.params.feature
					end

					if v5 == module.Feature.RegisterCredentials then
						default:registerCredentials(
							default.CredentialsTypes.FIDO2,
							jsonDecode.params.params.data.creationOptionsJSON,
							getFIntLuaAppCredentialsProtocolTimeout()
						):andThen(function(p4)
							if p4 ~= nil then
								logging.warn("Executing javascript on webview to return RegisterCredentialsResponse")
								local jsonEncode = HttpService:JSONEncode(p4)
								module2.Execute(jsonDecode.params.params.data.callId, jsonEncode)
							end
						end):catch(function()
							module2.Execute(jsonDecode.params.params.data.callId, "")
						end)
						return
					end
				end

				if getFFlagLuaAppEnableCredentialsProtocol() then
					local v5

					if
						jsonDecode.moduleID == module.Module.Navigation
						and jsonDecode.functionName == module.Function.navigateToFeature
						and jsonDecode.params
						and jsonDecode.params.params
					then
						v5 = jsonDecode.params.params.feature
					end

					if v5 == module.Feature.GetCredentials then
						default:getCredentials(
							default.CredentialsTypes.FIDO2,
							jsonDecode.params.params.data.authenticationOptionsJSON,
							getFIntLuaAppCredentialsProtocolTimeout()
						):andThen(function(p4)
							if p4 ~= nil then
								logging.warn("Executing javascript on webview to return GetCredentialsResponse")
								local jsonEncode = HttpService:JSONEncode(p4)
								module2.Execute(jsonDecode.params.params.data.callId, jsonEncode)
							end
						end):catch(function()
							module2.Execute(jsonDecode.params.params.data.callId, "")
						end)
					end
				end
			end
		})
	end)
end

return (RoactNavigation.withNavigation(extended))
