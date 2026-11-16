local function startAudioOnLoad(instance, callback)
	local function startIfLoaded() -- 1 equivalent call inferred from this helper
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
	startIfLoaded() -- inferred equivalent call
	return isReadyChangedConnection
end

return startAudioOnLoad
