local HttpService = game:GetService("HttpService")

local getFFlagEnableUnifiedWebViews = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountSettingsEntryPoints/SharedFlags").GetFFlagEnableUnifiedWebViews

local function createWebViewWindow(data)
	local flag = false
	local onClosed = nil
	local v5 = nil

	local function handleClosed()
		if not flag then
			return
		end

		flag = false
		local v6 = onClosed
		onClosed = nil

		if v6 then
			v6()
		end
	end

	local function ensureConnected()
		if v5 then
			return
		end

		if data.isUnifiedWebViewEnabled() then
			v5 = data.webViewService.OnWindowClosed:Connect(function()
				if flag then
					data.webViewService:CloseWindow()
				end

				if not flag then
					return
				end

				flag = false
				local v6 = onClosed
				onClosed = nil

				if v6 then
					v6()
				end
			end)
		else
			v5 = data.browserService.BrowserWindowClosed:Connect(handleClosed)
		end
	end

	return {
		open = function(p2, p3, p4)
			ensureConnected()

			if flag then
				flag = false
				local v6 = onClosed
				onClosed = nil

				if v6 then
					v6()
				end
			end

			flag = true
			onClosed = p4 and p4.onClosed

			local windowType = p4 and p4.windowType

			if not data.isUnifiedWebViewEnabled() then
				data.browserService:SendCommand(HttpService:JSONEncode({
					command = "open",
					url = p2,
					title = p3,
					visible = true,
					isGenericWebview = true,
					enableOverlayReplacement = true
				}))
			elseif windowType == "Dialog" then
				data.webViewService:OpenWindow(p2, p3, true, nil, "Dialog")
			else
				data.webViewService:OpenWindow(p2, p3, true)
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

			if not flag then
				return
			end

			flag = false
			local v6 = onClosed
			onClosed = nil

			if v6 then
				v6()
			end
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
		isUnifiedWebViewEnabled = getFFlagEnableUnifiedWebViews
	})

	return default
end

return { createWebViewWindow = createWebViewWindow, getDefault = getDefault }
