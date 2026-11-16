local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/WebViewUtils/SharedFlags").GetFFlagEnableUnifiedWebViews

local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local WebViewService = game:GetService("WebViewService")

local function openUnified(p2, p3, callback)
	local onWindowClosedConnection = nil
	local flag = false

	local function stopListening()
		if onWindowClosedConnection ~= nil then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end
	end

	local function close()
		if flag then
			return
		end

		flag = true

		if onWindowClosedConnection ~= nil then
			onWindowClosedConnection:Disconnect()
			onWindowClosedConnection = nil
		end

		WebViewService:CloseWindow()
	end

	onWindowClosedConnection = WebViewService.OnWindowClosed:Connect(function()
		if not flag then
			flag = true

			if onWindowClosedConnection ~= nil then
				onWindowClosedConnection:Disconnect()
				onWindowClosedConnection = nil
			end

			WebViewService:CloseWindow()
		end

		if callback then
			callback()
		end
	end)

	WebViewService:OpenWindow(p2, p3, true)

	return close, stopListening
end

local function openBrowser(p2, p3, callback)
	local browserWindowClosedConnection = nil
	local flag = false

	local function stopListening()
		if browserWindowClosedConnection ~= nil then
			browserWindowClosedConnection:Disconnect()
			browserWindowClosedConnection = nil
		end
	end

	if callback then
		browserWindowClosedConnection = BrowserService.BrowserWindowClosed:Connect(function()
			flag = true

			if browserWindowClosedConnection ~= nil then
				browserWindowClosedConnection:Disconnect()
				browserWindowClosedConnection = nil
			end

			callback()
		end)
	end

	BrowserService:SendCommand(HttpService:JSONEncode({
		command = "open",
		url = p2,
		title = p3,
		visible = true,
		isGenericWebview = true,
		enableOverlayReplacement = true
	}))

	local function close()
		if flag then
			return
		end

		flag = true

		if browserWindowClosedConnection ~= nil then
			browserWindowClosedConnection:Disconnect()
			browserWindowClosedConnection = nil
		end

		BrowserService:CloseBrowserWindow()
	end

	return close, stopListening
end

local function openWebViewSession(p2, p3, p4)
	if getFFlagEnableUnifiedWebViews() then
		return openUnified(p2, p3, p4)
	end

	return openBrowser(p2, p3, p4)
end

return openWebViewSession
