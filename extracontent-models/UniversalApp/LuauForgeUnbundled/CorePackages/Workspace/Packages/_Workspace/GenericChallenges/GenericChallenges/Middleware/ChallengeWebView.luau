local ChallengeHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeHeaders")
local BuildChallengeWebViewUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/BuildChallengeWebViewUrl")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/BuildHybridCallback")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeParameters")
local GenericType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/GenericType")
local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/SharedFlags").GetFFlagEnableUnifiedWebViews
local FFlagHideChallengeWebViewsUntilDisplayed = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagHideChallengeWebViewsUntilDisplayed")
local FFlagReleaseTextBoxFocusOnChallengeOpen = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagReleaseTextBoxFocusOnChallengeOpen")

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local WebViewService = if getFFlagEnableUnifiedWebViews() then game:GetService("WebViewService") else nil
local engineFeature = game:GetEngineFeature("WebViewHasHideHeader")

local defineFastInt = game:DefineFastInt("HiddenChallengeWebViewTimeoutSeconds", 3)

local class = {}
class.__index = class

function class.new(data)
	local v5 = {}

	if getFFlagEnableUnifiedWebViews() then
		v5.webViewService = data.webViewService or WebViewService
	else
		v5.browserService = data.browserService or BrowserService
	end

	local v6 = if data.rawResponseHeaders ~= nil then ChallengeHeaders.new(data.rawResponseHeaders) else nil

	local typed = if v6 ~= nil then v6.challengeType.typed else nil
	v5.opensVisible = not FFlagHideChallengeWebViewsUntilDisplayed
		or typed ~= GenericType.Captcha
		and typed ~= GenericType.CaptchaV2
		and typed ~= GenericType.ProofOfWork
		and typed ~= GenericType.Turnstile

	v5.visible = v5.opensVisible
	v5.isOpen = false
	v5.openGeneration = 0

	v5.challengeUrl = BuildChallengeWebViewUrl(v6, data.challengeType, data.challengeParameters)

	v5.title = data.title

	if data.hybridCallback ~= nil then
		v5.hybridCallback = data.hybridCallback
	end

	if data.closeCallback ~= nil then
		v5.closeCallback = data.closeCallback
	end

	if data.openCallback ~= nil then
		v5.openCallback = data.openCallback
	end

	v5.hybridCallbackConnection = nil

	v5.modal = false

	if data.modal ~= nil then
		v5.modal = data.modal
	end

	return (setmetatable(v5, class))
end

function class:setCloseCallback(closeCallback)
	if getFFlagEnableUnifiedWebViews() then
		function self.closeCallback()
			self.webViewService:CloseWindow()
			closeCallback()
		end
	else
		self.closeCallback = closeCallback
	end
end

function class:setOpenCallback(openCallback)
	self.openCallback = openCallback
end

function class:setHybridCallback(hybridCallback)
	self.hybridCallback = hybridCallback
end

local function openUnifiedWebView(webViewService, challengeUrl, title, visible)
	if FFlagHideChallengeWebViewsUntilDisplayed and engineFeature and not visible then
		webViewService:OpenWindowV2(challengeUrl, { Title = title, IsVisible = visible })
	else
		webViewService:OpenWindow(challengeUrl, title, visible)
	end
end

local function releaseFocusedTextBox()
	local focusedTextBox = UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end
end

local function mutateUnifiedWebViewVisibility(object, p2, p3, p4)
	object:MutateWindow(p2, p3, p4, "")
end

function class:setVisible(visible)
	if self.visible == visible or not self.isOpen then
		return
	end

	self.visible = visible
	local focusedTextBox = FFlagReleaseTextBoxFocusOnChallengeOpen and visible and UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	if getFFlagEnableUnifiedWebViews() then
		self.webViewService:MutateWindow(self.challengeUrl, self.title, visible, "")
	else
		self.browserService:SendCommand(HttpService:JSONEncode({
			command = "config",
			visible = visible
		}))
	end
end

function class:open()
	assert(self.hybridCallback ~= nil, "hybrid callback has not been initialized")

	if self.openCallback ~= nil then
		self.openCallback()
	end

	if getFFlagEnableUnifiedWebViews() then
		self.hybridCallbackConnection = self.webViewService.OnJavaScriptCall:Connect(self.hybridCallback)
	else
		self.hybridCallbackConnection = self.browserService.JavaScriptCallback:Connect(self.hybridCallback)
	end

	local closeCallback = self.closeCallback
	local fn = not self.opensVisible and function()
		self.isOpen = false
		self.visible = self.opensVisible

		if self.closeCallback ~= nil then
			self.closeCallback()
		end
	end or closeCallback

	if fn ~= nil then
		if getFFlagEnableUnifiedWebViews() then
			self.closeCallbackConnection = self.webViewService.OnWindowClosed:Connect(fn)
		else
			self.closeCallbackConnection = self.browserService.BrowserWindowClosed:Connect(fn)
		end
	end

	assert(string.len(self.challengeUrl) > 0, "challenge url must have been constructed")
	assert(self.hybridCallbackConnection ~= nil, "hybrid callback connection should be initialized")
	local focusedTextBox = FFlagReleaseTextBoxFocusOnChallengeOpen and self.visible and UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	self.isOpen = true
	self.openGeneration += 1

	if getFFlagEnableUnifiedWebViews() then
		openUnifiedWebView(self.webViewService, self.challengeUrl, self.title, self.visible)
	else
		local jsonEncode = HttpService:JSONEncode({
			command = "open",
			url = self.challengeUrl,
			title = self.title,
			visible = self.visible,
			modal = self.modal,
			isGenericWebview = true,
			enableOverlayReplacement = true
		})

		self.browserService:SendCommand(jsonEncode)
	end

	if not self.visible then
		local v5 = defineFastInt
		local v6 = v5 <= 0 and 3 or v5

		local openGeneration = self.openGeneration
		task.delay(v6, function()
			if self.isOpen and self.openGeneration == openGeneration and not self.visible then
				self:setVisible(true)
			end
		end)
	end
end

function class:close()
	self.isOpen = false
	self.visible = self.opensVisible

	if self.hybridCallbackConnection ~= nil then
		self.hybridCallbackConnection:Disconnect()
	end

	if getFFlagEnableUnifiedWebViews() then
		self.webViewService:CloseWindow()
	else
		self.browserService:CloseBrowserWindow()
	end

	if self.closeCallbackConnection ~= nil then
		self.closeCallbackConnection:Disconnect()
	end
end

return class
