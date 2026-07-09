local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local UserInputService = game:GetService("UserInputService")
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local BackDisableStore = require(CorePackages.Workspace.Packages.BackDisableStore)
local BrowserServiceWrapper = require(Modules.LuaApp.Components.BrowserServiceWrapper)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local SetBackNavigationDisabled = require(Modules.LuaApp.Actions.SetBackNavigationDisabled)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Url = require(Modules.LuaApp.Http.Url)
local JavascriptHybrid = require(Modules.LuaApp.Enum.JavascriptHybrid)
local num = tonumber(settings():GetFVariable("CaptchaTimeout"))
local GetFFlagLuaAppCanNativeWrapperParentHandleBackNavigationCaptcha = require(Modules.LuaApp.Flags.GetFFlagLuaAppCanNativeWrapperParentHandleBackNavigationCaptcha)
local GetFFlagReplaceBrowserServiceWrapper = require(Modules.LuaApp.Flags.GetFFlagReplaceBrowserServiceWrapper)
local FFlagUseBackDisableSignalStore = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseBackDisableSignalStore
local v20 = Roact.PureComponent:extend("CaptchaPageBrowserServiceWrapper")
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)

v20.defaultProps = {
	webViewVisible = true,
	backNavigationDisabledWhileLoading = false
}

function v20.init(p1) -- line: 34
	-- upvalues: num (copy), UserInputService (copy)
	p1.state = {
		webViewVisible = p1.props.webViewVisible
	}
	p1.captchaSuccess = false
	p1.captchaData = nil
	p1.timerCancelled = false

	if p1.props.backNavigationDisabledWhileLoading then
		p1.props.setBackNavigationDisabled(true)
	end

	if num > 0 then
		spawn(function() -- line: 48
			-- upvalues: num (copy), p1 (copy)
			local n1 = 0

			repeat
				if not (n1 < num) then
					if p1.props.backNavigationDisabledWhileLoading then
						p1.props.setBackNavigationDisabled(false)
					end

					if p1.props.analytics ~= nil and p1.props.analytics.Diag ~= nil then
						p1.props.analytics.Diag:reportCounter("CaptchaPageBrowserServiceWrapper_Timeout", 1)
					end

					p1.props.navigation.goBack()

					return
				end

				wait(1)
				n1 += 1
			until p1.timerCancelled
		end)
	end

	function p1.getPlatformString() -- line: 70
		-- upvalues: UserInputService (copy)
		local Platform = UserInputService:GetPlatform()
		local s1 = "unknown"

		if Platform == Enum.Platform.Android then
			return "android"
		end

		if Platform == Enum.Platform.IOS then
			return "ios"
		end

		if Platform == Enum.Platform.UWP then
			return "uwp"
		end

		if Platform == Enum.Platform.XBoxOne then
			s1 = "xbox"
		end

		return s1
	end
	function p1.getCaptchaDxBlob(p2, p3) -- line: 87
		if p3 == nil or p3.dxBlob == nil then
			if p3.analytics ~= nil then
				local t1 = {
					captchaType = p2
				}

				p3.analytics.EventStream:setRBXEventStream("captcha", "captchaDxBlobNotSet", t1)
			end

			return ""
		end

		return p3.dxBlob
	end
	function p1.getCaptchaId(p4) -- line: 100
		if p4 == nil or p4.captchaId == nil then
			return ""
		end

		return p4.captchaId
	end
end
function v20.willUnmount(p5) -- line: 108
	-- upvalues: ToastType (copy)
	p5.timerCancelled = true

	local captchaCallback = p5.props.captchaCallback

	if not p5.captchaSuccess then
		p5.props.setCurrentToastMessage(ToastType.NetworkingError, "Authentication.Login.Response.SomethingWentWrong")
	end

	if captchaCallback then
		captchaCallback(p5.captchaSuccess, p5.captchaData)
	end
end
function v20.render(p6) -- line: 121
	-- upvalues: Url (copy), Roact (copy), BrowserServiceWrapper (copy), GetFFlagLuaAppCanNativeWrapperParentHandleBackNavigationCaptcha (copy), GetFFlagReplaceBrowserServiceWrapper (copy), HttpService (copy), JavascriptHybrid (copy)
	local isVisible = p6.props.isVisible
	local DisplayOrder = p6.props.DisplayOrder
	local captchaType = p6.props.captchaType
	local cvalueType = p6.props.cvalueType
	local cvalue = p6.props.cvalue
	local backNavigationDisabledWhileLoading = p6.props.backNavigationDisabledWhileLoading
	local v36

	if captchaType == "login" then
		local v34 = p6.getCaptchaDxBlob(captchaType, p6.props)

		string.format("%scaptcha/app/login?hybrid-return-token=1&credentialsType=%s&credentialsValue=%s&data-exchange-blob=%s", Url.WWW_URL, cvalueType, cvalue, v34)

		local v35 = p6.getCaptchaId(p6.props)

		v36 = string.format("%scaptcha/app/login?hybrid-return-token=1&credentialsType=%s&credentialsValue=%s&data-exchange-blob=%s&hybrid-return-captcha-id=%s", Url.WWW_URL, cvalueType, cvalue, v34, v35)
	else
		local v37 = p6.getCaptchaDxBlob(captchaType, p6.props)

		string.format("%scaptcha/app/signup?hybrid-return-token=1&data-exchange-blob=%s", Url.WWW_URL, v37)

		local v38 = p6.getCaptchaId(p6.props)

		v36 = string.format("%scaptcha/app/signup?hybrid-return-token=1&data-exchange-blob=%s&hybrid-return-captcha-id=%s", Url.WWW_URL, v37, v38)
	end

	return Roact.createElement(BrowserServiceWrapper, {
		modal = true,
		backNavigationHandledByParent = GetFFlagLuaAppCanNativeWrapperParentHandleBackNavigationCaptcha(),
		isVisible = isVisible and p6.state.webViewVisible,
		webViewVisible = p6.state.webViewVisible,
		displayOrder = DisplayOrder,
		url = v36,
		windowClosedCallback = function() -- line: 167
			-- upvalues: backNavigationDisabledWhileLoading (copy), p6 (copy), GetFFlagReplaceBrowserServiceWrapper (copy)
			if backNavigationDisabledWhileLoading then
				p6.props.setBackNavigationDisabled(false)
			end

			p6.timerCancelled = true

			if not GetFFlagReplaceBrowserServiceWrapper() then
				p6.props.navigation.goBack()
			end
		end,
		javaScriptCallback = function(p7) -- line: 176
			-- upvalues: backNavigationDisabledWhileLoading (copy), p6 (copy), HttpService (copy), JavascriptHybrid (copy)
			if backNavigationDisabledWhileLoading then
				p6.props.setBackNavigationDisabled(false)
			end

			local data = HttpService:JSONDecode(p7)

			if data.moduleID == JavascriptHybrid.Module.Navigation and data.functionName == JavascriptHybrid.Function.navigateToFeature and data.params and data.params.params then
				p6.timerCancelled = true

				if p6.props.analytics ~= nil and p6.props.analytics.Diag ~= nil then
					p6.props.analytics.Diag:reportCounter("CaptchaPageBrowserServiceWrapper_NotTimeout", 1)
				end

				if data.params.params.feature == JavascriptHybrid.Feature.CaptchaSuccess then
					p6.captchaSuccess = true
					p6.captchaData = data.params.params.captchaData
					p6.props.navigation.goBack()

					return
				end

				if data.params.params.feature == JavascriptHybrid.Feature.CaptchaShown then
					p6:setState({
						webViewVisible = true
					})
				end
			end
		end
	})
end

local v22 = RoactNavigation.withNavigation(v20)
local v23 = RoactServices.connect({
	analytics = RoactAnalytics
})(v22)

return RoactRodux.connect(nil, function(p8) -- line: 219
	-- upvalues: SetCurrentToastMessage (copy), FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), SetBackNavigationDisabled (copy)
	return {
		setCurrentToastMessage = function(p9, p10) -- line: 221
			-- upvalues: p8 (copy), SetCurrentToastMessage (copy)
			return p8(SetCurrentToastMessage({
				toastType = p9,
				toastMessage = p10
			}))
		end,
		setBackNavigationDisabled = function(p11) -- line: 227
			-- upvalues: FFlagUseBackDisableSignalStore (copy), BackDisableStore (copy), p8 (copy), SetBackNavigationDisabled (copy)
			if FFlagUseBackDisableSignalStore then
				return (BackDisableStore.setDisabled(p11))
			end

			return (p8(SetBackNavigationDisabled(p11)))
		end
	}
end)(v23)
