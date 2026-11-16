local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local React = require(ReactSceneUnderstanding.Parent.React)
local ReactUtils = require(ReactSceneUnderstanding.Parent.ReactUtils)
local SceneAnalysisContext = require(ReactSceneUnderstanding.SceneAnalysisContext)
local enums = require(ReactSceneUnderstanding.enums)
local useCameraState = require(ReactSceneUnderstanding.useCameraState)
local sortByAudibleVolume = require(ReactSceneUnderstanding.audio.sortByAudibleVolume)
local useAudioSources = require(ReactSceneUnderstanding.audio.useAudioSources)
local useTimedLoop = require(ReactSceneUnderstanding.useTimedLoop)

local useCallback = React.useCallback
local useEffect = React.useEffect
local usePrevious = ReactUtils.usePrevious

local function useAudibleSounds()
	local v = SceneAnalysisContext.use()
	local v2 = useAudioSources()
	local v3 = useCameraState()
	local v4 = usePrevious(v3)

	local v5 = useCallback(function()
		v.setAudibleSounds(sortByAudibleVolume(v2))
	end, { v2, v.setAudibleSounds })

	useTimedLoop(1, function()
		v5()
	end)

	useEffect(function()
		if #v.audibleSounds == 0 and #v2 > 0 then
			v5()
		end
	end, { #v.audibleSounds, #v2, v5 })

	useEffect(function()
		if v3 ~= v4 and v3 == enums.CameraState.Idle then
			v5()
		end
	end, { v3, v4, v5 })

	return v.audibleSounds
end

return useAudibleSounds
