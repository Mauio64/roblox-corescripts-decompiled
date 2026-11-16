local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local dependencies = require(CrossExperienceVoice.dependencies)

local react = dependencies.React
local CrossExperienceVoiceManager = require(CrossExperienceVoice.CrossExperienceVoiceManager)
local default = CrossExperienceVoiceManager.default
local audioFocusService = default:getAudioFocusService()

return function()
	local state, setState = react.useState(-1)

	if audioFocusService then
		react.useEffect(function()
			setState(default:getCurrentAudioContext())

			audioFocusService.OnContextRegistered:Connect(function()
				setState(default:getCurrentAudioContext())
			end)

			audioFocusService.OnContextUnregistered:Connect(function()
				setState(default:getCurrentAudioContext())
			end)

			audioFocusService.OnDeafenVoiceAudio:Connect(function(_)
				setState(default:getCurrentAudioContext())
			end)

			audioFocusService.OnUndeafenVoiceAudio:Connect(function(_)
				setState(default:getCurrentAudioContext())
			end)
		end, {})
	end

	return state
end
