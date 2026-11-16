local function startAudioOnLoad(instance, callback)
	local function startIfLoaded()
		if not instance.IsReady then
			return
		end

		instance.TimePosition = instance.PlaybackRegion.Min

		if callback() then
			instance.PlaybackSpeed = 1

			if not instance.IsPlaying then
				instance:Play()
			end
		end
	end

	local isReadyChangedConnection = instance:GetPropertyChangedSignal("IsReady"):Connect(startIfLoaded)

	if not instance.IsReady then
		return isReadyChangedConnection
	end

	instance.TimePosition = instance.PlaybackRegion.Min

	if callback() then
		instance.PlaybackSpeed = 1

		if not instance.IsPlaying then
			instance:Play()
		end
	end

	return isReadyChangedConnection
end

return startAudioOnLoad
