local parent = script.Parent
local LoadSlices = require(parent.LoadSlices)

local UserInputService = game:GetService("UserInputService")
local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local Players = game:GetService("Players")
local mouse = Players.LocalPlayer:GetMouse()

local ControlScrubber = {}

function computePercentX(p, p2, p3)
	local x = p.X
	local v = x + p2.X
	return (p3 - x) / (v - x)
end

function ControlScrubber.jumpTo(p)
	local v = computePercentX(p.ScrubberLoadProgress.AbsolutePosition, p.ScrubberLoadProgress.AbsoluteSize, mouse.X)

	if v < 0 or v > 1 then
		local v2 = computePercentX(p.ScrubberButton.AbsolutePosition, p.ScrubberButton.AbsoluteSize, mouse.X)

		LoadSlices.loadNoncontiguousSlice(p, v2)
	else
		ExperienceStateRecordingService:SetPlaybackPercentage(v)
	end
end

function ControlScrubber.setupControl(p)
	p.ScrubberButton.MouseMoved:Connect(function()
		if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			return
		end

		ControlScrubber.jumpTo(p)
	end)

	p.ScrubberButton.MouseButton1Down:Connect(function()
		ControlScrubber.jumpTo(p)
	end)
end

return ControlScrubber
