local Parent = script:FindFirstAncestor("CurrencyTransfers").Parent
local GetFFlagEnableUnifiedWebViews = require(Parent.SharedFlags).GetFFlagEnableUnifiedWebViews
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 47
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), t1 (copy)
	local t3 = {}

	if GetFFlagEnableUnifiedWebViews() then
		t3.webViewService = t2.webViewService or WebViewService
	end

	t3.title = t2.title
	t3.url = t2.url
	t3.closeCallbackConnection = nil

	local v9 = setmetatable(t3, t1)

	v9:setCloseCallback(t2.closeCallback or function() -- line: 61
	end)

	return v9
end
function t1.setCloseCallback(p1, p2) -- line: 66
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy)
	if GetFFlagEnableUnifiedWebViews() then
		function p1.closeCallback() -- line: 68
			-- upvalues: p1 (copy), p2 (copy)
			p1:close()

			if p2 ~= nil then
				p2()
			end
		end

		return
	end

	p1.closeCallback = p2
end
function t1.setOpenCallback(p3, p4) -- line: 79
	p3.openCallback = p4
end
function t1.open(p5) -- line: 83
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy), BrowserService (copy), HttpService (copy)
	if p5.openCallback ~= nil then
		p5.openCallback()
	end

	if p5.closeCallback ~= nil and GetFFlagEnableUnifiedWebViews() then
		p5.closeCallbackConnection = p5.webViewService.OnWindowClosed:Connect(p5.closeCallback)
	end

	if p5.closeCallback ~= nil and not GetFFlagEnableUnifiedWebViews() then
		p5.closeCallbackConnection = BrowserService.BrowserWindowClosed:Connect(p5.closeCallback)
	end

	if GetFFlagEnableUnifiedWebViews() then
		p5.webViewService:OpenWindow(p5.url, p5.title, true)

		return
	end

	local json = HttpService:JSONEncode({
		command = "open",
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true,
		url = p5.url,
		title = p5.title
	})

	BrowserService:SendCommand(json)
end
function t1.close(p6) -- line: 110
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy)
	if GetFFlagEnableUnifiedWebViews() then
		p6.webViewService:CloseWindow()
	end

	if p6.closeCallbackConnection ~= nil then
		p6.closeCallbackConnection:Disconnect()
	end
end

return t1
