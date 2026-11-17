local parent = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local WebViewServiceWrapper = {}
WebViewServiceWrapper.__index = WebViewServiceWrapper

function WebViewServiceWrapper.new(data)
	local v = {}

	if GetFFlagEnableUnifiedWebViews() then
		v.webViewService = data.webViewService or WebViewService
	end

	v.title = data.title
	v.url = data.url
	v.closeCallbackConnection = nil

	local object = setmetatable(v, WebViewServiceWrapper)

	object:setCloseCallback(data.closeCallback or function() end)

	return object
end

function WebViewServiceWrapper:setCloseCallback(closeCallback)
	if GetFFlagEnableUnifiedWebViews() then
		function self.closeCallback()
			self:close()

			if closeCallback ~= nil then
				closeCallback()
			end
		end
	else
		self.closeCallback = closeCallback
	end
end

function WebViewServiceWrapper:setOpenCallback(openCallback)
	self.openCallback = openCallback
end

function WebViewServiceWrapper:open()
	if self.openCallback ~= nil then
		self.openCallback()
	end

	if self.closeCallback ~= nil and GetFFlagEnableUnifiedWebViews() then
		self.closeCallbackConnection = self.webViewService.OnWindowClosed:Connect(self.closeCallback)
	end

	if self.closeCallback ~= nil and not GetFFlagEnableUnifiedWebViews() then
		self.closeCallbackConnection = BrowserService.BrowserWindowClosed:Connect(self.closeCallback)
	end

	if GetFFlagEnableUnifiedWebViews() then
		self.webViewService:OpenWindow(self.url, self.title, true)
		return
	end

	BrowserService:SendCommand((HttpService:JSONEncode({
		command = "open",
		url = self.url,
		title = self.title,
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true
	})))
end

function WebViewServiceWrapper:close()
	if GetFFlagEnableUnifiedWebViews() then
		self.webViewService:CloseWindow()
	end

	if self.closeCallbackConnection ~= nil then
		self.closeCallbackConnection:Disconnect()
	end
end

return WebViewServiceWrapper
