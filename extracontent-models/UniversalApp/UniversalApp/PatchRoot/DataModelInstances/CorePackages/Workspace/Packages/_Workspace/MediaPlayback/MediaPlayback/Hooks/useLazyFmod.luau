local MediaPlayback = script:FindFirstAncestor("MediaPlayback")
local React = require(MediaPlayback.Parent.React)
local enableAudioPlaybackInApp = require(MediaPlayback.Common.enableAudioPlaybackInApp)
local useEffect = React.useEffect
local v5 = game:DefineFastInt("InitializeFmodMsDelay", 0)

local function useLazyFmod() -- line: 24
	-- upvalues: useEffect (copy), v5 (copy), enableAudioPlaybackInApp (copy)
	useEffect(function() -- line: 25
		-- upvalues: v5 (copy), enableAudioPlaybackInApp (copy)
		task.delay(v5 / 1000, function() -- line: 26
			-- upvalues: enableAudioPlaybackInApp (copy)
			enableAudioPlaybackInApp()
		end)
	end, {})
end

return useLazyFmod
