local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local Roact = require(CorePackages.Packages.Roact)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module2 = require("@luauforge/deferred/fUI")

local module3 = require("@luauforge/deferred/fov")

local getFFlagPhoneVerificationWebviewShouldBeFullscreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagPhoneVerificationWebviewShouldBeFullscreen

local extended = Roact.PureComponent:extend("PhoneVerificationNativeWrapper")

extended.defaultProps = { BrowserWrapperComponent = module3, closeCallback = nil }

local function getFeatureStringFromHybridEvent(data)
	if
		data.moduleID == module2.Module.Navigation
		and data.functionName == module2.Function.navigateToFeature
		and data.params
		and data.params.params
	then
		return data.params.params.feature
	end

	return nil
end

local function isCloseContactMethodUpsellWebviewEvent(data): boolean
	return (if data.moduleID == module2.Module.Navigation and data.functionName == module2.Function.navigateToFeature and data.params and data.params.params then data.params.params.feature else nil) == module2.Feature.CloseContactMethodUpsellWebview
end

local function isCompletedContactMethodUpsellWebviewEvent(data): boolean
	return (if data.moduleID == module2.Module.Navigation and data.functionName == module2.Function.navigateToFeature and data.params and data.params.params then data.params.params.feature else nil) == module2.Feature.CompletedContactMethodUpsellWebview
end

function extended:init()
	self.isPhoneVerificationSuccessful = false
end

function extended:render()
	return Roact.createElement(self.props.BrowserWrapperComponent, {
		isVisible = true,
		modal = not getFFlagPhoneVerificationWebviewShouldBeFullscreen(),
		webViewVisible = true,
		displayOrder = self.props.displayOrder,
		url = Url.BASE_URL .. "phone-verification",
		isGenericWebview = true,
		javaScriptCallback = function(json)
			local jsonDecode = HttpService:JSONDecode(json)
			local v5

			if
				jsonDecode.moduleID == module2.Module.Navigation
				and jsonDecode.functionName == module2.Function.navigateToFeature
				and jsonDecode.params
				and jsonDecode.params.params
			then
				v5 = jsonDecode.params.params.feature
			end

			if v5 == module2.Feature.CompletedContactMethodUpsellWebview then
				self.isPhoneVerificationSuccessful = true

				if self.props.onSuccessCallback then
					self.props.onSuccessCallback()
				end
			else
				local v6

				if
					jsonDecode.moduleID == module2.Module.Navigation
					and jsonDecode.functionName == module2.Function.navigateToFeature
					and jsonDecode.params
					and jsonDecode.params.params
				then
					v6 = jsonDecode.params.params.feature
				end

				if v6 == module2.Feature.CloseContactMethodUpsellWebview then
					self.props.navigation.goBack()
				end
			end
		end
	})
end

function extended.willUnmount(p2)
	if p2.props.closeCallback then
		p2.props.closeCallback(p2.isPhoneVerificationSuccessful)
	end
end

return (RoactNavigation.withNavigation(extended))
