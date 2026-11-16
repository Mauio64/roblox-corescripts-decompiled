local MediaPlayback = script:FindFirstAncestor("MediaPlayback")

local React = require(MediaPlayback.Parent.React)

local enableAudioPlaybackInApp = require(MediaPlayback.Common.enableAudioPlaybackInApp)

local useEffect = React.useEffect

local defineFastInt = game:DefineFastInt("InitializeFmodMsDelay", 0)

local function useLazyFmod()
	useEffect(function()
		task.delay(defineFastInt / 1000, function()
			enableAudioPlaybackInApp()
		end)
	end, {})
end

return useLazyFmod
