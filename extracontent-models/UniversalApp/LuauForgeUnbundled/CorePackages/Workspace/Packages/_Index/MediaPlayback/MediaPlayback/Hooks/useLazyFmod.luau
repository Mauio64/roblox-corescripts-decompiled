local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaPlayback/React")

local enableAudioPlaybackInApp = require("@game/CorePackages/Workspace/Packages/_Index/MediaPlayback/MediaPlayback/Common/enableAudioPlaybackInApp")

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
