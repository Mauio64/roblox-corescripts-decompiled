local ExperienceStateRecordingService = game:GetService("ExperienceStateRecordingService")

local parent = script.Parent
local SecondsToTimeStr = require(parent.SecondsToTimeStr)

return {
	setupListener = function(data)
		ExperienceStateRecordingService.PlaybackStatusUpdated:Connect(function(p, _)
			data.ScrubberPlayProgress.Size = UDim2.new(p, 0, 1, 0)

			if data.loadedLengthSeconds and data.replayToLoadedStartSeconds then
				data.CurrentTimeLabel.Text = SecondsToTimeStr.convertSecondsToTimeStr(p * data.loadedLengthSeconds + data.replayToLoadedStartSeconds)
			end
		end)
	end
}
