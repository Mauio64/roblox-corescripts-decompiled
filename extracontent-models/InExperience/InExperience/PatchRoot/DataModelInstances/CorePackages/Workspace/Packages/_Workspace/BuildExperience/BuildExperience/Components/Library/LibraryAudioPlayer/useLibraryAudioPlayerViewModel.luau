local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local MediaPlayback = require(parent.MediaPlayback)
local Navigation = require(parent.Navigation)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local SignalsReact = require(parent.SignalsReact)
require(script.Parent.LibraryAudioPlayerView)
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)

local function useLibraryAudioPlayerViewModel(data)
	local isActive = data.isActive ~= false
	local v = MediaPlayback.useAudioStore(data.soundId, false)
	local v2 = Navigation.useNavigation()
	local state, setState = React.useState(v2 == nil or v2.isFocused())
	React.useEffect(function()
		setState(v2 == nil or v2.isFocused())

		if v2 == nil then
			return nil
		end

		local v3 = v2.addListener(RoactNavigation.Events.WillFocus, function()
			setState(true)
		end)
		local v4 = v2.addListener(RoactNavigation.Events.WillBlur, function()
			setState(false)
		end)
		return function()
			v3.remove()
			v4.remove()
		end
	end, { v2 or false })
	local isPlaying = SignalsReact.useSignalState(v.getIsPlaying)
	local v3 = SignalsReact.useSignalState(v.getIsLoaded)
	local duration = SignalsReact.useSignalState(v.getDuration)
	local elapsed = SignalsReact.useSignalBinding(v.getElapsed)
	local state2, setState2 = React.useState(false)

	React.useEffect(function()
		setState2(false)

		if v3 then
			return nil
		end

		local thread = task.delay(15, function()
			setState2(true)
			sendBuildExperienceEvent("LIBRARY_FETCH_FAILED", {
				universeId = game.GameId,
				placeId = game.PlaceId
			}, {
				surface = "Detail",
				kind = "Sound",
				reason = "audio_load_timeout"
			})
		end)
		return function()
			task.cancel(thread)
		end
	end, { v, v3 })

	local onTogglePlayback = React.useCallback(function()
		if not (v3 and state and isActive) then
			return
		end

		if isPlaying then
			v.pause()
		else
			MediaPlayback.getAudioPlaybackStore(false).pauseAll()
			v.play()
		end

		sendBuildExperienceEvent("LIBRARY_ASSET_CLICK", {
			universeId = game.GameId,
			placeId = game.PlaceId
		}, {
			surface = "Detail",
			kind = "Sound",
			action = isPlaying and "pause" or "play"
		})
	end, { v, v3, isPlaying, state, isActive })

	local ref = React.useRef(false)
	local onSeekStarted = React.useCallback(function()
		ref.current = v3 and isActive and state and isPlaying
		v.pause()
	end, { v, v3, isActive, state, isPlaying })
	local onSeek = React.useCallback(function(value: number)
		if v3 and isActive and state then
			v.seek(math.clamp(value, 0, 1) * duration)
		end
	end, { v, duration, v3, isActive, state })
	local onSeekEnded = React.useCallback(function()
		if ref.current and isActive and state then
			v.play()
		end

		ref.current = false
	end, { v, isActive, state })

	React.useEffect(function()
		if not state then
			v.stop()
		elseif not isActive then
			v.pause()
		end
	end, { v, state, isActive })

	React.useEffect(function()
		return function()
			v.stop()
		end
	end, { v })

	return {
		isCompact = data.isCompact,
		title = data.title,
		artist = data.soundLabel or "",
		isPlaying = isPlaying,
		elapsed = elapsed,
		duration = duration,
		onTogglePlayback = onTogglePlayback,
		onSeek = onSeek,
		onSeekStarted = onSeekStarted,
		onSeekEnded = onSeekEnded,
		unavailableText = data.unavailableText,
		status = v3 and "Ready" or state2 and "Failed" or "Loading"
	}
end

return useLibraryAudioPlayerViewModel
