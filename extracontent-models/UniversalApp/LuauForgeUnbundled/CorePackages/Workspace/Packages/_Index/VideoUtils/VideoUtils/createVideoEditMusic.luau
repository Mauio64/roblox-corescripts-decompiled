local function createVideoEditMusic(p2, callback)
	local videoEditMusic = Instance.new("Folder")
	videoEditMusic.Name = "VideoEditMusic"
	videoEditMusic.Parent = game:GetService("CoreGui")
	local audioPlayer = Instance.new("AudioPlayer")
	audioPlayer.Asset = `rbxassetid://{p2}`
	audioPlayer.PlaybackSpeed = 0
	audioPlayer.Parent = videoEditMusic
	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Parent = videoEditMusic
	local wire = Instance.new("Wire")
	wire.SourceInstance = audioPlayer
	wire.TargetInstance = audioDeviceOutput
	wire.Parent = videoEditMusic
	local v5 = false
	local isReadyChangedConnection = audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function()
		if audioPlayer.IsReady then
			if v5 and not audioPlayer.IsPlaying then
				audioPlayer:Play()
			end

			audioPlayer.TimePosition = callback()
		end
	end)
	audioPlayer:Play()

	return {
		setPosition = function(timePosition)
			audioPlayer.TimePosition = timePosition
		end,
		setPlaying = function(p3)
			v5 = p3

			if p3 and audioPlayer.IsReady and not audioPlayer.IsPlaying then
				audioPlayer:Play()
				audioPlayer.TimePosition = callback()
			end

			audioPlayer.PlaybackSpeed = p3 and 1 or 0
		end,
		destroy = function()
			isReadyChangedConnection:Disconnect()
			videoEditMusic:Destroy()
		end
	}
end

return createVideoEditMusic
