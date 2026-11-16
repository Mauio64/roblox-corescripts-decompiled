local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local ChallengeHeaders = require(script.Parent.ChallengeHeaders)
local BuildChallengeWebViewUrl = require(script.Parent.BuildChallengeWebViewUrl)
require(script.Parent.BuildHybridCallback)
require(GenericChallenges.Types.ChallengeParameters)
local GenericType = require(GenericChallenges.Types.GenericType)
local SharedFlags = require(GenericChallenges.Parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews
local FFlagHideChallengeWebViewsUntilDisplayed = require(script.Parent.Flags.FFlagHideChallengeWebViewsUntilDisplayed)
local FFlagReleaseTextBoxFocusOnChallengeOpen = require(script.Parent.Flags.FFlagReleaseTextBoxFocusOnChallengeOpen)

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local WebViewService

if GetFFlagEnableUnifiedWebViews() then
	WebViewService = game:GetService("WebViewService")
else
	WebViewService = nil
end

local engineFeature = game:GetEngineFeature("WebViewHasHideHeader")

local defineFastInt = game:DefineFastInt("HiddenChallengeWebViewTimeoutSeconds", 3)

local ChallengeWebView = {}
ChallengeWebView.__index = ChallengeWebView

function ChallengeWebView.new(data)
	local v = {}

	if GetFFlagEnableUnifiedWebViews() then
		v.webViewService = data.webViewService or WebViewService
	else
		v.browserService = data.browserService or BrowserService
	end

	local v2

	if data.rawResponseHeaders ~= nil then
		v2 = ChallengeHeaders.new(data.rawResponseHeaders)
	end

	local typed

	if v2 ~= nil then
		typed = v2.challengeType.typed
	end

	v.opensVisible = not FFlagHideChallengeWebViewsUntilDisplayed
		or typed ~= GenericType.Captcha
		and typed ~= GenericType.CaptchaV2
		and typed ~= GenericType.ProofOfWork
		and typed ~= GenericType.Turnstile

	v.visible = v.opensVisible
	v.isOpen = false
	v.openGeneration = 0

	v.challengeUrl = BuildChallengeWebViewUrl(v2, data.challengeType, data.challengeParameters)

	v.title = data.title

	if data.hybridCallback ~= nil then
		v.hybridCallback = data.hybridCallback
	end

	if data.closeCallback ~= nil then
		v.closeCallback = data.closeCallback
	end

	if data.openCallback ~= nil then
		v.openCallback = data.openCallback
	end

	v.hybridCallbackConnection = nil

	v.modal = false

	if data.modal ~= nil then
		v.modal = data.modal
	end

	return (setmetatable(v, ChallengeWebView))
end

function ChallengeWebView:setCloseCallback(closeCallback)
	if GetFFlagEnableUnifiedWebViews() then
		function self.closeCallback()
			self.webViewService:CloseWindow()
			closeCallback()
		end
	else
		self.closeCallback = closeCallback
	end
end

function ChallengeWebView:setOpenCallback(openCallback)
	self.openCallback = openCallback
end

function ChallengeWebView:setHybridCallback(hybridCallback)
	self.hybridCallback = hybridCallback
end

local function openUnifiedWebView(webViewService, challengeUrl: string, title: string, visible: boolean)
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

local function mutateUnifiedWebViewVisibility(webViewService, challengeUrl: string, title: string, visible: boolean) -- 1 equivalent call inferred from this helper
	webViewService:MutateWindow(challengeUrl, title, visible, "")
end

function ChallengeWebView:setVisible(visible: boolean)
	if self.visible == visible or not self.isOpen then
		return
	end

	self.visible = visible
	local focusedTextBox = FFlagReleaseTextBoxFocusOnChallengeOpen and visible and UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	if GetFFlagEnableUnifiedWebViews() then
		mutateUnifiedWebViewVisibility(self.webViewService, self.challengeUrl, self.title, visible) -- inferred equivalent call
	else
		self.browserService:SendCommand(HttpService:JSONEncode({
			command = "config",
			visible = visible
		}))
	end
end

function ChallengeWebView:open()
	assert(self.hybridCallback ~= nil, "hybrid callback has not been initialized")

	if self.openCallback ~= nil then
		self.openCallback()
	end

	if GetFFlagEnableUnifiedWebViews() then
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
		if GetFFlagEnableUnifiedWebViews() then
			self.closeCallbackConnection = self.webViewService.OnWindowClosed:Connect(fn)
		else
			self.closeCallbackConnection = self.browserService.BrowserWindowClosed:Connect(fn)
		end
	end

	assert(string.len(self.challengeUrl) > 0, "challenge url must have been constructed")
	assert(self.hybridCallbackConnection ~= nil, "hybrid callback connection should be initialized")
	local focusedTextBox = FFlagReleaseTextBoxFocusOnChallengeOpen
		and self.visible
		and UserInputService:GetFocusedTextBox()

	if focusedTextBox then
		focusedTextBox:ReleaseFocus()
	end

	self.isOpen = true
	self.openGeneration += 1

	if GetFFlagEnableUnifiedWebViews() then
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
		local v = defineFastInt
		local v2 = v <= 0 and 3 or v

		local openGeneration = self.openGeneration
		task.delay(v2, function()
			if self.isOpen and self.openGeneration == openGeneration and not self.visible then
				self:setVisible(true)
			end
		end)
	end
end

function ChallengeWebView:close()
	self.isOpen = false
	self.visible = self.opensVisible

	if self.hybridCallbackConnection ~= nil then
		self.hybridCallbackConnection:Disconnect()
	end

	if GetFFlagEnableUnifiedWebViews() then
		self.webViewService:CloseWindow()
	else
		self.browserService:CloseBrowserWindow()
	end

	if self.closeCallbackConnection ~= nil then
		self.closeCallbackConnection:Disconnect()
	end
end

return ChallengeWebView
