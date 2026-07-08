local u1 = nil

if game:GetEngineFeature("ReportAnythingScreenshot") then
	game:GetService("SafetyService").ScreenshotContentReady:Connect(function(_, p2) -- line: 7
		-- upvalues: u1 (ref)
		u1 = p2
	end)
end

local t1 = {}

t1.__index = t1

function t1.GetScreenshotContentId(_) -- line: 17
	-- upvalues: u1 (ref)
	return u1
end
function t1.SetScreenshotContentId(_, p5) -- line: 22
	-- upvalues: u1 (ref)
	u1 = p5
end

return t1
