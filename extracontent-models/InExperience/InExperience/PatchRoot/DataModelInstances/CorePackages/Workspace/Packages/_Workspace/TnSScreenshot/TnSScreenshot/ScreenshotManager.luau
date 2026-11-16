local parent = script:FindFirstAncestor("TnSScreenshot").Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableInAppBugReporting = SharedFlags.GetFFlagEnableInAppBugReporting

local ScreenshotManager = {}
ScreenshotManager.__index = ScreenshotManager

local v = {}
local v2 = {}

local v3 = false

local _ = { RAABTestReason = "RAABTest" }

local function fn(SafetyService)
	SafetyService.ScreenshotUploaded:Connect(function(p, p2)
		local v4 = v[p]

		if not v4 then
			return
		end

		v4(p2)
		table.remove(v, p)
	end)
	SafetyService.ScreenshotContentReady:Connect(function(p, p2)
		local v4 = v2[p]

		if not v4 then
			return
		end

		v4(p2)
		table.remove(v2, p)
	end)
	v3 = true
end

local function fn2() -- 1 equivalent call inferred from this helper
	return game:GetEngineFeature("ReportAnythingScreenshot")
		and game:GetEngineFeature("ReportAnythingScreenshotUploadedSignal")
end

function ScreenshotManager.TakeScreenshotWithCallback(_, callback, callback2, p: string?): boolean
	if not fn2() then -- inferred equivalent call
		return false
	end

	local SafetyService = game:GetService("SafetyService")
	local v4 = SafetyService:TakeScreenshot({
		registerContent = callback2 == nil and 0 or 1,
		reason = GetFFlagEnableInAppBugReporting() and p or "RAABTest"
	})

	v[v4] = callback
	v2[v4] = callback2

	if not v3 then
		fn(SafetyService)
	end

	return true
end

return ScreenshotManager
