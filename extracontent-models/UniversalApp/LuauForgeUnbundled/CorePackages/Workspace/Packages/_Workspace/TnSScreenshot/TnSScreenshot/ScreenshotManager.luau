local getFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/TnSScreenshot/SharedFlags").GetFFlagEnableInAppBugReporting

local v5 = {}
v5.__index = v5

local v6 = {}
local v7 = {}

local v8 = false

local v9 = { RAABTestReason = "RAABTest" }

local function fn(SafetyService)
	SafetyService.ScreenshotUploaded:Connect(function(p2, p3)
		local v10 = v6[p2]

		if not v10 then
			return
		end

		v10(p3)
		table.remove(v6, p2)
	end)
	SafetyService.ScreenshotContentReady:Connect(function(p2, p3)
		local v10 = v7[p2]

		if not v10 then
			return
		end

		v10(p3)
		table.remove(v7, p2)
	end)
	v8 = true
end

function v5:TakeScreenshotWithCallback(p3, p4, p5): boolean
	if not (game:GetEngineFeature("ReportAnythingScreenshot") and game:GetEngineFeature("ReportAnythingScreenshotUploadedSignal")) then
		return false
	end

	local SafetyService = game:GetService("SafetyService")
	local v10 = SafetyService:TakeScreenshot({
		registerContent = p4 == nil and 0 or 1,
		reason = getFFlagEnableInAppBugReporting() and p5 or "RAABTest"
	})

	v6[v10] = p3
	v7[v10] = p4

	if not v8 then
		fn(SafetyService)
	end

	return true
end

return v5
