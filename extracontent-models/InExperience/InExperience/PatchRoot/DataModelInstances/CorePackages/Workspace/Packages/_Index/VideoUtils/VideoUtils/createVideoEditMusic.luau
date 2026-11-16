local function createVideoEditMusic(p: string, callback)
	local videoEditMusic = Instance.new("Folder")
	videoEditMusic.Name = "VideoEditMusic"
	videoEditMusic.Parent = game:GetService("CoreGui")
	local audioPlayer = Instance.new("AudioPlayer")
	audioPlayer.Asset = `rbxassetid://{p}`
	audioPlayer.PlaybackSpeed = 0
	audioPlayer.Parent = videoEditMusic
	local audioDeviceOutput = Instance.new("AudioDeviceOutput")
	audioDeviceOutput.Parent = videoEditMusic
	local wire = Instance.new("Wire")
	wire.SourceInstance = audioPlayer
	wire.TargetInstance = audioDeviceOutput
	wire.Parent = videoEditMusic
	local v = false
	local isReadyChangedConnection = audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(function()
		if audioPlayer.IsReady then
			if v and not audioPlayer.IsPlaying then
				audioPlayer:Play()
			end

			audioPlayer.TimePosition = callback()
		end
	end)
	audioPlayer:Play()

	return {
		setPosition = function(timePosition: number)
			audioPlayer.TimePosition = timePosition
		end,
		setPlaying = function(flag: boolean)
			v = flag

			if flag and audioPlayer.IsReady and not audioPlayer.IsPlaying then
				audioPlayer:Play()
				audioPlayer.TimePosition = callback()
			end

			audioPlayer.PlaybackSpeed = flag and 1 or 0
		end,
		destroy = function()
			isReadyChangedConnection:Disconnect()
			videoEditMusic:Destroy()
		end
	}
end

return createVideoEditMusic
