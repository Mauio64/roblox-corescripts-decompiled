local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local SoundService = game:GetService("SoundService")
local Cryo = require(ReactSceneUnderstanding.Parent.Cryo)
local React = require(ReactSceneUnderstanding.Parent.React)
local useTimedLoop = require(ReactSceneUnderstanding.useTimedLoop)
local useState = React.useState

local function getAllAudioSources() -- line: 13
	-- upvalues: SoundService (copy), Cryo (copy)
	local ok, result = pcall(function() -- line: 20
		-- upvalues: SoundService (copy)
		return SoundService:GetAudioInstances()
	end)

	if ok then
		return Cryo.List.filter(result, function(p1) -- line: 25
			return p1:IsA("Sound") or p1:IsA("AudioPlayer")
		end)
	end

	return {}
end
local function useAudioSources() -- line: 33
	-- upvalues: useState (copy), getAllAudioSources (copy), useTimedLoop (copy)
	local v11, v12 = useState(getAllAudioSources)

	useTimedLoop(1, function() -- line: 36
		-- upvalues: v12 (copy), getAllAudioSources (copy)
		v12(getAllAudioSources())
	end)

	return v11
end

return useAudioSources
