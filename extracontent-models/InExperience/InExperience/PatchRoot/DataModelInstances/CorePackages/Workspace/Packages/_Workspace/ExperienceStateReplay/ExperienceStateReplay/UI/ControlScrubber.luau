local scriptParent = script.Parent
local LoadSlices = require(scriptParent.LoadSlices)
local UserInputService = game:GetService("UserInputService")
local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local t1 = {}

function computePercentX(p1, p2, p3) -- line: 13
	local p1X = p1.X
	local v11 = p1X + p2.X

	return (p3 - p1X) / (v11 - p1X)
end
function t1.jumpTo(p4) -- line: 19
	-- upvalues: Mouse (copy), LoadSlices (copy), ExperienceStateRecordingService (copy)
	local v13 = computePercentX(p4.ScrubberLoadProgress.AbsolutePosition, p4.ScrubberLoadProgress.AbsoluteSize, Mouse.X)

	if v13 < 0 or v13 > 1 then
		local v14 = computePercentX(p4.ScrubberButton.AbsolutePosition, p4.ScrubberButton.AbsoluteSize, Mouse.X)

		LoadSlices.loadNoncontiguousSlice(p4, v14)

		return
	end

	ExperienceStateRecordingService:SetPlaybackPercentage(v13)
end
function t1.setupControl(p5) -- line: 39
	-- upvalues: UserInputService (copy), t1 (copy)
	p5.ScrubberButton.MouseMoved:Connect(function() -- line: 40
		-- upvalues: UserInputService (copy), t1 (copy), p5 (copy)
		if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			return
		end

		t1.jumpTo(p5)
	end)
	p5.ScrubberButton.MouseButton1Down:Connect(function() -- line: 48
		-- upvalues: t1 (copy), p5 (copy)
		t1.jumpTo(p5)
	end)
end

return t1
