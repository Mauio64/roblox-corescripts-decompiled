local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)
local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local JavascriptHybrid = require(Modules.LuaApp.Enum.JavascriptHybrid)
local BrowserServiceWrapper = require(Modules.LuaApp.Components.BrowserServiceWrapper)
local GetFFlagPhoneVerificationWebviewShouldBeFullscreen = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagPhoneVerificationWebviewShouldBeFullscreen
local v10 = Roact.PureComponent:extend("PhoneVerificationNativeWrapper")

v10.defaultProps = {
	closeCallback = nil,
	BrowserWrapperComponent = BrowserServiceWrapper
}

local function getFeatureStringFromHybridEvent(p1) -- line: 23
	-- upvalues: JavascriptHybrid (copy)
	if p1.moduleID == JavascriptHybrid.Module.Navigation and (p1.functionName == JavascriptHybrid.Function.navigateToFeature and p1.params and p1.params.params) then
		return p1.params.params.feature
	end

	return nil
end
local function isCloseContactMethodUpsellWebviewEvent(p2) -- line: 48
	-- upvalues: JavascriptHybrid (copy)
	return ((if p2.moduleID ~= JavascriptHybrid.Module.Navigation or (p2.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not p2.params or not p2.params.params)) then nil else p2.params.params.feature)) == JavascriptHybrid.Feature.CloseContactMethodUpsellWebview
end
local function isCompletedContactMethodUpsellWebviewEvent(p3) -- line: 53
	-- upvalues: JavascriptHybrid (copy)
	return ((if p3.moduleID ~= JavascriptHybrid.Module.Navigation or (p3.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not p3.params or not p3.params.params)) then nil else p3.params.params.feature)) == JavascriptHybrid.Feature.CompletedContactMethodUpsellWebview
end

function v10.init(p4) -- line: 59
	p4.isPhoneVerificationSuccessful = false
end
function v10.render(p5) -- line: 63
	-- upvalues: Roact (copy), GetFFlagPhoneVerificationWebviewShouldBeFullscreen (copy), Url (copy), HttpService (copy), JavascriptHybrid (copy)
	return Roact.createElement(p5.props.BrowserWrapperComponent, {
		isVisible = true,
		webViewVisible = true,
		isGenericWebview = true,
		modal = not GetFFlagPhoneVerificationWebviewShouldBeFullscreen(),
		displayOrder = p5.props.displayOrder,
		url = Url.BASE_URL .. "phone-verification",
		javaScriptCallback = function(p6) -- line: 71
			-- upvalues: HttpService (copy), JavascriptHybrid (copy), p5 (copy)
			local data = HttpService:JSONDecode(p6)

			if ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.CompletedContactMethodUpsellWebview then
				p5.isPhoneVerificationSuccessful = true

				if p5.props.onSuccessCallback then
					p5.props.onSuccessCallback()

					return
				end
			elseif ((if data.moduleID ~= JavascriptHybrid.Module.Navigation or (data.functionName ~= JavascriptHybrid.Function.navigateToFeature or (not data.params or not data.params.params)) then nil else data.params.params.feature)) == JavascriptHybrid.Feature.CloseContactMethodUpsellWebview then
				p5.props.navigation.goBack()
			end
		end
	})
end
function v10.willUnmount(p7) -- line: 85
	if p7.props.closeCallback then
		p7.props.closeCallback(p7.isPhoneVerificationSuccessful)
	end
end

return (RoactNavigation.withNavigation(v10))
