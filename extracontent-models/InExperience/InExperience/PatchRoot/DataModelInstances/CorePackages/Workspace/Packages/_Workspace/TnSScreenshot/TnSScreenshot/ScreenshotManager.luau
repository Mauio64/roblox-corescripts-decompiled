local Parent = script:FindFirstAncestor("TnSScreenshot").Parent
local GetFFlagEnableInAppBugReporting = require(Parent.SharedFlags).GetFFlagEnableInAppBugReporting
local t1 = {}

t1.__index = t1

local t2 = {}
local t3 = {}
local u6 = false
local t4 = {
	RAABTestReason = "RAABTest"
}

local function v8(p1) -- line: 27
	-- upvalues: t2 (copy), t3 (copy), u6 (ref)
	p1.ScreenshotUploaded:Connect(function(p2, p3) -- line: 28
		-- upvalues: t2 (copy)
		local v18 = t2[p2]

		if not v18 then
			return
		end

		v18(p3)
		table.remove(t2, p2)
	end)
	p1.ScreenshotContentReady:Connect(function(p4, p5) -- line: 37
		-- upvalues: t3 (copy)
		local v21 = t3[p4]

		if not v21 then
			return
		end

		v21(p5)
		table.remove(t3, p4)
	end)
	u6 = true
end

function t1.TakeScreenshotWithCallback(_: {[any]: any}, p6: ((...any) -> ...any), p7: ((...any) -> ...any)?, s1: string?) -- line: 59
	-- upvalues: GetFFlagEnableInAppBugReporting (copy), t4 (copy), t2 (copy), t3 (copy), u6 (ref), v8 (copy)
	if not game:GetEngineFeature("ReportAnythingScreenshot") or not game:GetEngineFeature("ReportAnythingScreenshotUploadedSignal") then
		return false
	end

	local SafetyService = game:GetService("SafetyService")
	local v15 = SafetyService:TakeScreenshot({
		registerContent = p7 == nil and 0 or 1,
		reason = if not GetFFlagEnableInAppBugReporting() then t4.RAABTestReason else s1 or t4.RAABTestReason
	})

	t2[v15] = p6
	t3[v15] = p7

	if not u6 then
		v8(SafetyService)
	end

	return true
end

return t1
