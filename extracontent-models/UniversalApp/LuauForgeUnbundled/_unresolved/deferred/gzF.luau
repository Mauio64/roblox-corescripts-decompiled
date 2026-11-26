local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/ego")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local module3 = require("@luauforge/bundled/fBV")
local module4 = require("@luauforge/deferred/fvP")
local module5 = require("@luauforge/bundled/dFm")
local module6 = require("@luauforge/bundled/dzE")
local module7 = require("@luauforge/bundled/dVn")
local module8 = require("@luauforge/deferred/gzG")
local fVariable = tonumber(settings():GetFVariable("CaptchaTimeout"))

local module9 = require("@luauforge/deferred/gzH")
local module10 = require("@luauforge/deferred/fBU")

local extended = module.PureComponent:extend("CaptchaPageBrowserServiceWrapper")

local module11 = require("@luauforge/bundled/ecq")

extended.defaultProps = {
	webViewVisible = true,
	backNavigationDisabledWhileLoading = false
}

function extended:init()
	self.state = { webViewVisible = self.props.webViewVisible }

	self.captchaSuccess = false
	self.captchaData = nil

	self.timerCancelled = false

	if self.props.backNavigationDisabledWhileLoading then
		self.props.setBackNavigationDisabled(true)
	end

	if fVariable > 0 then
		spawn(function()
			local count = 0

			while count < fVariable do
				wait(1)
				count += 1

				if self.timerCancelled then
					return
				end
			end

			if self.props.backNavigationDisabledWhileLoading then
				self.props.setBackNavigationDisabled(false)
			end

			if self.props.analytics ~= nil and self.props.analytics.Diag ~= nil then
				self.props.analytics.Diag:reportCounter("CaptchaPageBrowserServiceWrapper_Timeout", 1)
			end

			self.props.navigation.goBack()
		end)
	end

	function self.getPlatformString(): boolean | string
		local platform = UserInputService:GetPlatform()

		if platform == Enum.Platform.Android then
			return "android"
		end

		if platform == Enum.Platform.IOS then
			return "ios"
		end

		if platform == Enum.Platform.UWP then
			return "uwp"
		end

		return platform == Enum.Platform.XBoxOne and "xbox" or "unknown"
	end

	function self.getCaptchaDxBlob(p2, p3)
		if p3 ~= nil and p3.dxBlob ~= nil then
			return p3.dxBlob
		end

		if p3.analytics ~= nil then
			p3.analytics.EventStream:setRBXEventStream("captcha", "captchaDxBlobNotSet", {
				captchaType = p2
			})
		end

		return ""
	end

	function self.getCaptchaId(p2)
		if p2 == nil or p2.captchaId == nil then
			return ""
		end

		return p2.captchaId
	end
end

function extended:willUnmount()
	self.timerCancelled = true
	local captchaCallback = self.props.captchaCallback

	if not self.captchaSuccess then
		self.props.setCurrentToastMessage(
			module6.NetworkingError,
			"Authentication.Login.Response.SomethingWentWrong"
		)
	end

	if captchaCallback then
		captchaCallback(self.captchaSuccess, self.captchaData)
	end
end

function extended:render()
	local isVisible = self.props.isVisible
	local displayOrder = self.props.DisplayOrder
	local captchaType = self.props.captchaType
	local cvalueType = self.props.cvalueType
	local cvalue = self.props.cvalue
	local backNavigationDisabledWhileLoading = self.props.backNavigationDisabledWhileLoading
	local v5

	if captchaType == "login" then
		local captchaDxBlob = self.getCaptchaDxBlob("login", self.props)
		string.format(
			"%scaptcha/app/login?hybrid-return-token=1&credentialsType=%s&credentialsValue=%s&data-exchange-blob=%s",
			module7.WWW_URL,
			cvalueType,
			cvalue,
			captchaDxBlob
		)

		local captchaId = self.getCaptchaId(self.props)
		v5 = string.format(
			"%scaptcha/app/login?hybrid-return-token=1&credentialsType=%s&credentialsValue=%s&data-exchange-blob=%s&hybrid-return-captcha-id=%s",
			module7.WWW_URL,
			cvalueType,
			cvalue,
			captchaDxBlob,
			captchaId
		)
	else
		local captchaDxBlob = self.getCaptchaDxBlob(captchaType, self.props)
		string.format(
			"%scaptcha/app/signup?hybrid-return-token=1&data-exchange-blob=%s",
			module7.WWW_URL,
			captchaDxBlob
		)
		local captchaId = self.getCaptchaId(self.props)
		v5 = string.format(
			"%scaptcha/app/signup?hybrid-return-token=1&data-exchange-blob=%s&hybrid-return-captcha-id=%s",
			module7.WWW_URL,
			captchaDxBlob,
			captchaId
		)
	end

	return module.createElement(module4, {
		backNavigationHandledByParent = module9(),
		isVisible = isVisible and self.state.webViewVisible,
		modal = true,
		webViewVisible = self.state.webViewVisible,
		displayOrder = displayOrder,
		url = v5,
		windowClosedCallback = function()
			if backNavigationDisabledWhileLoading then
				self.props.setBackNavigationDisabled(false)
			end

			self.timerCancelled = true

			if not module10() then
				self.props.navigation.goBack()
			end
		end,
		javaScriptCallback = function(json)
			if backNavigationDisabledWhileLoading then
				self.props.setBackNavigationDisabled(false)
			end

			local jsonDecode = HttpService:JSONDecode(json)

			if
				jsonDecode.moduleID == module8.Module.Navigation
				and jsonDecode.functionName == module8.Function.navigateToFeature
				and jsonDecode.params
				and jsonDecode.params.params
			then
				self.timerCancelled = true

				if self.props.analytics ~= nil and self.props.analytics.Diag ~= nil then
					self.props.analytics.Diag:reportCounter(
						"CaptchaPageBrowserServiceWrapper_NotTimeout",
						1
					)
				end

				if jsonDecode.params.params.feature == module8.Feature.CaptchaSuccess then
					self.captchaSuccess = true
					self.captchaData = jsonDecode.params.params.captchaData

					self.props.navigation.goBack()
				elseif jsonDecode.params.params.feature == module8.Feature.CaptchaShown then
					self:setState({ webViewVisible = true })
				end
			end
		end
	})
end

local v5 = RoactNavigation.withNavigation(extended)

local v6 = roactServices.connect({ analytics = module11 })(v5)

return useSheetNavigation.connect(nil, function(callback)
	return {
		setCurrentToastMessage = function(p2, p3)
			return callback(module5({ toastType = p2, toastMessage = p3 }))
		end,
		setBackNavigationDisabled = function(p2)
			return module3.setDisabled(p2)
		end
	}
end)(v6)
