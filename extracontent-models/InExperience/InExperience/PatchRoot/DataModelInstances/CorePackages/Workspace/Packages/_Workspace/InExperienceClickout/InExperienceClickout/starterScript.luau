local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")

local parent = script.Parent
local parent2 = parent.Parent
local Loggers = require(parent2.Loggers)

local ClickoutTelemetry = require(parent.ClickoutTelemetry)

local flaggedMutedError = Loggers.flaggedMutedError

local defineFastFlag = game:DefineFastFlag("LuaAppIsClickoutEnabledUniverse", false)
local SharedFlags = require(parent2.SharedFlags)
local GetFFlagEnableUnifiedWebViews = SharedFlags.GetFFlagEnableUnifiedWebViews

local function starterScript()
	if not defineFastFlag then
		return
	end

	ReplicatedStorage:WaitForChild("AdClickoutEvent").Event:Connect(function(url: string)
		if string.find(url, "[<>]") then
			flaggedMutedError("InExperienceClickout_InvalidURL", `AdClickoutEvent received invalid URL: {url}`)
			return
		end

		if not string.match(url, "^https://") then
			flaggedMutedError(
				"InExperienceClickout_InvalidURL",
				`AdClickoutEvent received URL with invalid scheme: {url}`
			)

			return
		end

		if #url == 0 then
			flaggedMutedError("InExperienceClickout_InvalidURL", "AdClickoutEvent received empty URL.")
			return
		end

		if #url > 512 then
			flaggedMutedError(
				"InExperienceClickout_InvalidURL",
				`AdClickoutEvent received URL exceeding max length: {url}`
			)

			return
		end

		local guid = HttpService:GenerateGUID(false)

		local connection = nil

		if GetFFlagEnableUnifiedWebViews() then
			connection = WebViewService.OnWindowClosed:Connect(function()
				ClickoutTelemetry.logWebviewToggled(false, guid, url)
				WebViewService:CloseWindow()

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end)
		else
			connection = BrowserService.BrowserWindowClosed:Connect(function()
				ClickoutTelemetry.logWebviewToggled(false, guid, url)

				if connection then
					connection:Disconnect()
					connection = nil
				end
			end)
		end

		ClickoutTelemetry.logWebviewToggled(true, guid, url)

		if GetFFlagEnableUnifiedWebViews() then
			WebViewService:OpenWindow(url, nil, true, nil, nil, true)
		else
			local success, result = pcall(function()
				return HttpService:JSONEncode({
					command = "open",
					url = url,
					visible = true,
					isGenericWebview = true,
					showDomainAsTitle = true
				})
			end)

			if success then
				BrowserService:SendCommand(result)
			else
				flaggedMutedError(
					"InExperienceClickout_JSONEncodeFailed",
					`AdClickoutEvent failed to JSON encode command for URL: {url}`
				)
			end
		end
	end)
end

return starterScript
