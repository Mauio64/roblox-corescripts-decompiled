local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WebViewService = game:GetService("WebViewService")
local BrowserService = game:GetService("BrowserService")
local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Loggers = require(scriptParentParent.Loggers)
local ClickoutTelemetry = require(scriptParent.ClickoutTelemetry)
local flaggedMutedError = Loggers.flaggedMutedError
local v10 = game:DefineFastFlag("LuaAppIsClickoutEnabledUniverse", false)
local GetFFlagEnableUnifiedWebViews = require(scriptParentParent.SharedFlags).GetFFlagEnableUnifiedWebViews

local function starterScript() -- line: 19
	-- upvalues: v10 (copy), ReplicatedStorage (copy), flaggedMutedError (copy), HttpService (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), ClickoutTelemetry (copy), BrowserService (copy)
	if not v10 then
		return
	end

	ReplicatedStorage:WaitForChild("AdClickoutEvent").Event:Connect(function(s1: string) -- line: 26
		-- upvalues: flaggedMutedError (copy), HttpService (copy), GetFFlagEnableUnifiedWebViews (copy), WebViewService (copy), ClickoutTelemetry (copy), BrowserService (copy)
		if string.find(s1, "[<>]") then
			flaggedMutedError("InExperienceClickout_InvalidURL", `AdClickoutEvent received invalid URL: { s1 }`)

			return
		end

		if not string.match(s1, "^https://") then
			flaggedMutedError("InExperienceClickout_InvalidURL", `AdClickoutEvent received URL with invalid scheme: { s1 }`)

			return
		end

		if #s1 == 0 then
			flaggedMutedError("InExperienceClickout_InvalidURL", "AdClickoutEvent received empty URL.")

			return
		end

		if #s1 > 512 then
			flaggedMutedError("InExperienceClickout_InvalidURL", `AdClickoutEvent received URL exceeding max length: { s1 }`)

			return
		end

		local guid = HttpService:GenerateGUID(false)
		local u15 = nil

		u15 = if not GetFFlagEnableUnifiedWebViews() then BrowserService.BrowserWindowClosed:Connect(function() -- line: 68
			-- upvalues: ClickoutTelemetry (copy), guid (copy), s1 (copy), u15 (ref)
			ClickoutTelemetry.logWebviewToggled(false, guid, s1)

			if u15 then
				u15:Disconnect()
				u15 = nil
			end
		end) else WebViewService.OnWindowClosed:Connect(function() -- line: 59
			-- upvalues: ClickoutTelemetry (copy), guid (copy), s1 (copy), WebViewService (copy), u15 (ref)
			ClickoutTelemetry.logWebviewToggled(false, guid, s1)
			WebViewService:CloseWindow()

			if u15 then
				u15:Disconnect()
				u15 = nil
			end
		end)
		ClickoutTelemetry.logWebviewToggled(true, guid, s1)

		if GetFFlagEnableUnifiedWebViews() then
			WebViewService:OpenWindow(s1, nil, true, nil, nil, true)
		else
			local ok, result = pcall(function() -- line: 89
				-- upvalues: HttpService (copy), s1 (copy)
				return HttpService:JSONEncode({
					command = "open",
					visible = true,
					isGenericWebview = true,
					showDomainAsTitle = true,
					url = s1
				})
			end)

			if not ok then
				flaggedMutedError("InExperienceClickout_JSONEncodeFailed", `AdClickoutEvent failed to JSON encode command for URL: { s1 }`)

				return
			end

			BrowserService:SendCommand(result)
		end
	end)
end

return starterScript
