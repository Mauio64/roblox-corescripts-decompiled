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

local function useAudibleSounds() -- line: 31
	-- upvalues: SceneAnalysisContext (copy), useAudioSources (copy), useCameraState (copy), usePrevious (copy), useCallback (copy), sortByAudibleVolume (copy), useTimedLoop (copy), useEffect (copy), enums (copy)
	local v14 = SceneAnalysisContext.use()
	local v15 = useAudioSources()
	local v16 = useCameraState()
	local v17 = usePrevious(v16)
	local v18 = useCallback(function() -- line: 37
		-- upvalues: v14 (copy), sortByAudibleVolume (copy), v15 (copy)
		v14.setAudibleSounds(sortByAudibleVolume(v15))
	end, {
		v15,
		v14.setAudibleSounds
	})

	useTimedLoop(1, function() -- line: 56
		-- upvalues: v18 (copy)
		v18()
	end)
	useEffect(function() -- line: 60
		-- upvalues: v14 (copy), v15 (copy), v18 (copy)
		if #v14.audibleSounds == 0 and #v15 > 0 then
			v18()
		end
	end, {
		#v14.audibleSounds,
		#v15,
		v18
	})
	useEffect(function() -- line: 66
		-- upvalues: v16 (copy), v17 (copy), enums (copy), v18 (copy)
		if v16 ~= v17 and v16 == enums.CameraState.Idle then
			v18()
		end
	end, {
		v16,
		v17,
		v18
	})

	return v14.audibleSounds
end

return useAudibleSounds
