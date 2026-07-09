local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local ChallengeHeaders = require(script.Parent.ChallengeHeaders)
local BuildChallengeWebViewUrl = require(script.Parent.BuildChallengeWebViewUrl)

require(script.Parent.BuildHybridCallback)
require(GenericChallenges.Types.ChallengeParameters)

local GetFFlagEnableUnifiedWebViews = require(GenericChallenges.Parent.SharedFlags).GetFFlagEnableUnifiedWebViews
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local v7 = if not GetFFlagEnableUnifiedWebViews() then nil else game:GetService("WebViewService")
local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 63
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy), v7 (copy), BrowserService (copy), ChallengeHeaders (copy), BuildChallengeWebViewUrl (copy), t1 (copy)
	local t3 = {}

	if GetFFlagEnableUnifiedWebViews() then
		t3.webViewService = t2.webViewService or v7
	else
		t3.browserService = t2.browserService or BrowserService
	end

	local v11 = nil

	if t2.rawResponseHeaders ~= nil then
		v11 = ChallengeHeaders.new(t2.rawResponseHeaders)
	end

	t3.challengeUrl = BuildChallengeWebViewUrl(v11, t2.challengeType, t2.challengeParameters)
	t3.title = t2.title

	if t2.hybridCallback ~= nil then
		t3.hybridCallback = t2.hybridCallback
	end

	if t2.closeCallback ~= nil then
		t3.closeCallback = t2.closeCallback
	end

	if t2.openCallback ~= nil then
		t3.openCallback = t2.openCallback
	end

	t3.hybridCallbackConnection = nil
	t3.modal = false

	if t2.modal ~= nil then
		t3.modal = t2.modal
	end

	return (setmetatable(t3, t1))
end
function t1.setCloseCallback(t4: {[any]: any}, p1: ((...any) -> ...any)) -- line: 108
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy)
	if GetFFlagEnableUnifiedWebViews() then
		function t4.closeCallback() -- line: 111
			-- upvalues: t4 (copy), p1 (copy)
			t4.webViewService:CloseWindow()
			p1()
		end

		return
	end

	t4.closeCallback = p1
end
function t1.setOpenCallback(t5: {[any]: any}, p2: ((...any) -> ...any)) -- line: 120
	t5.openCallback = p2
end
function t1.setHybridCallback(p3, p4) -- line: 125
	p3.hybridCallback = p4
end
function t1.open(p5) -- line: 130
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy), HttpService (copy)
	assert(p5.hybridCallback ~= nil, "hybrid callback has not been initialized")

	if p5.openCallback ~= nil then
		p5.openCallback()
	end

	if GetFFlagEnableUnifiedWebViews() then
		p5.hybridCallbackConnection = p5.webViewService.OnJavaScriptCall:Connect(p5.hybridCallback)
	else
		p5.hybridCallbackConnection = p5.browserService.JavaScriptCallback:Connect(p5.hybridCallback)
	end

	if p5.closeCallback ~= nil then
		if GetFFlagEnableUnifiedWebViews() then
			p5.closeCallbackConnection = p5.webViewService.OnWindowClosed:Connect(p5.closeCallback)
		else
			p5.closeCallbackConnection = p5.browserService.BrowserWindowClosed:Connect(p5.closeCallback)
		end
	end

	assert(string.len(p5.challengeUrl) > 0, "challenge url must have been constructed")
	assert(p5.hybridCallbackConnection ~= nil, "hybrid callback connection should be initialized")

	if GetFFlagEnableUnifiedWebViews() then
		p5.webViewService:OpenWindow(p5.challengeUrl, p5.title, true)

		return
	end

	local json = HttpService:JSONEncode({
		command = "open",
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true,
		url = p5.challengeUrl,
		title = p5.title,
		modal = p5.modal
	})

	p5.browserService:SendCommand(json)
end
function t1.close(p6) -- line: 168
	-- upvalues: GetFFlagEnableUnifiedWebViews (copy)
	if p6.hybridCallbackConnection ~= nil then
		p6.hybridCallbackConnection:Disconnect()
	end

	if GetFFlagEnableUnifiedWebViews() then
		p6.webViewService:CloseWindow()
	else
		p6.browserService:CloseBrowserWindow()
	end

	if p6.closeCallbackConnection ~= nil then
		p6.closeCallbackConnection:Disconnect()
	end
end

return t1
