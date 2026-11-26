local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local class = {}
class.__index = class

function class.new(data)
	local v5 = {}

	if getFFlagEnableUnifiedWebViews() then
		v5.webViewService = data.webViewService or WebViewService
	end

	v5.title = data.title
	v5.url = data.url
	v5.closeCallbackConnection = nil

	local object = setmetatable(v5, class)

	object:setCloseCallback(data.closeCallback or function() end)

	return object
end

function class:setCloseCallback(closeCallback)
	if getFFlagEnableUnifiedWebViews() then
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

function class:setOpenCallback(openCallback)
	self.openCallback = openCallback
end

function class:open()
	if self.openCallback ~= nil then
		self.openCallback()
	end

	if self.closeCallback ~= nil and getFFlagEnableUnifiedWebViews() then
		self.closeCallbackConnection = self.webViewService.OnWindowClosed:Connect(self.closeCallback)
	end

	if self.closeCallback ~= nil and not getFFlagEnableUnifiedWebViews() then
		self.closeCallbackConnection = BrowserService.BrowserWindowClosed:Connect(self.closeCallback)
	end

	if getFFlagEnableUnifiedWebViews() then
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

function class.close(p2)
	if getFFlagEnableUnifiedWebViews() then
		p2.webViewService:CloseWindow()
	end

	if p2.closeCallbackConnection ~= nil then
		p2.closeCallbackConnection:Disconnect()
	end
end

return class
