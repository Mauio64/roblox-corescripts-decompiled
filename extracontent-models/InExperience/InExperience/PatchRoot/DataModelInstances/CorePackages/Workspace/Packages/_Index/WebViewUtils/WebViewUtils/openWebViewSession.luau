local parent = script:FindFirstAncestor("WebViewUtils").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function openUnified(p: string, p2: string, callback)
	local onWindowClosedConnection = nil
	local flag = false

	local function stopListening() -- 1 equivalent call inferred from this helper
		if onWindowClosedConnection ~= nil then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end
	end

	local function close() -- 1 equivalent call inferred from this helper
		if flag then
			return
		end

		flag = true
		stopListening() -- inferred equivalent call
		WebViewService:CloseWindow()
	end

	onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
		close() -- inferred equivalent call

		if callback then
			callback()
		end
	end)

	WebViewService:OpenWindow(p, p2, true)

	return close, stopListening
end

local function openBrowser(url: string, title: string, callback)
	local browserWindowClosedConnection = nil
	local flag = false

	local function stopListening() -- 2 equivalent calls inferred from this helper
		if browserWindowClosedConnection ~= nil then
			browserWindowClosedConnection:Disconnect()
			browserWindowClosedConnection = nil
		end
	end

	if callback then
		browserWindowClosedConnection = BrowserService.BrowserWindowClosed:Connect(function()
			flag = true
			stopListening() -- inferred equivalent call
			callback()
		end)
	end

	BrowserService:SendCommand(HttpService:JSONEncode({
		command = "open",
		url = url,
		title = title,
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true
	}))

	local function close()
		if flag then
			return
		end

		flag = true
		stopListening() -- inferred equivalent call
		BrowserService:CloseBrowserWindow()
	end

	return close, stopListening
end

local function openWebViewSession(url: string, title: string, callback)
	if GetFFlagEnableUnifiedWebViews() then
		return openUnified(url, title, callback)
	end

	return openBrowser(url, title, callback)
end

return openWebViewSession
