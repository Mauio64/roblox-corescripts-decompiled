local HttpService = game:GetService("HttpService")

local parent = script.Parent.Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local function createWebViewWindow(data)
	local flag = false
	local onClosed = nil
	local v = nil

	local function handleClosed() -- 3 equivalent calls inferred from this helper
		if not flag then
			return
		end

		flag = false
		local v2 = onClosed
		onClosed = nil

		if v2 then
			v2()
		end
	end

	local function ensureConnected()
		if v then
			return
		end

		if data.isUnifiedWebViewEnabled() then
			v = data.webViewService.OnWindowClosed:Connect(function()
				if flag then
					data.webViewService:CloseWindow()
				end

				handleClosed() -- inferred equivalent call
			end)
		else
			v = data.browserService.BrowserWindowClosed:Connect(handleClosed)
		end
	end

	return {
		open = function(url: string, title: string, p)
			ensureConnected()
			handleClosed() -- inferred equivalent call
			flag = true
			onClosed = p and p.onClosed

			local windowType = p and p.windowType

			if not data.isUnifiedWebViewEnabled() then
				data.browserService:SendCommand(HttpService:JSONEncode({
					command = "open",
					url = url,
					title = title,
					visible = true,
					isGenericWebview = true,
					enableOverlayReplacement = true
				}))
			elseif windowType == "Dialog" then
				data.webViewService:OpenWindow(url, title, true, nil, "Dialog")
			else
				data.webViewService:OpenWindow(url, title, true)
			end
		end,
		close = function()
			if not flag then
				return
			end

			if data.isUnifiedWebViewEnabled() then
				data.webViewService:CloseWindow()
			else
				data.browserService:CloseBrowserWindow()
			end

			handleClosed() -- inferred equivalent call
		end,
		isOpen = function()
			return flag
		end
	}
end

local default = nil

local function getDefault()
	if default then
		return default
	end

	default = createWebViewWindow({
		webViewService = game:GetService("WebViewService"),
		browserService = game:GetService("BrowserService"),
		isUnifiedWebViewEnabled = GetFFlagEnableUnifiedWebViews
	})

	return default
end

return { createWebViewWindow = createWebViewWindow, getDefault = getDefault }
