local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")
local scriptParent = script.Parent
local SecondsToTimeStr = require(scriptParent.SecondsToTimeStr)

return {
	setupListener = function(p1) -- line: 9
		-- upvalues: ExperienceStateRecordingService (copy), SecondsToTimeStr (copy)
		ExperienceStateRecordingService.PlaybackStatusUpdated:Connect(function(p2, _) -- line: 10
			-- upvalues: p1 (copy), SecondsToTimeStr (copy)
			p1.ScrubberPlayProgress.Size = UDim2.new(p2, 0, 1, 0)

			if p1.loadedLengthSeconds and p1.replayToLoadedStartSeconds then
				p1.CurrentTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(p2 * p1.loadedLengthSeconds + p1.replayToLoadedStartSeconds)
			end
		end)
	end
}
