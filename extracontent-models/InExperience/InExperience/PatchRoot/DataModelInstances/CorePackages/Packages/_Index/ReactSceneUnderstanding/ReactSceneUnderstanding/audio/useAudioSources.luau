local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local SoundService = game:GetService("SoundService")

local Cryo = require(ReactSceneUnderstanding.Parent.Cryo)
local React = require(ReactSceneUnderstanding.Parent.React)
local useTimedLoop = require(ReactSceneUnderstanding.useTimedLoop)

local useState = React.useState

local function getAllAudioSources()
	local success, result = pcall(function()
		return SoundService:GetAudioInstances()
	end)

	if success then
		return Cryo.List.filter(result, function(instance)
			return instance:IsA("Sound") or instance:IsA("AudioPlayer")
		end)
	end

	return {}
end

local function useAudioSources()
	local state, setState = useState(getAllAudioSources)

	useTimedLoop(1, function()
		setState(getAllAudioSources())
	end)

	return state
end

return useAudioSources
