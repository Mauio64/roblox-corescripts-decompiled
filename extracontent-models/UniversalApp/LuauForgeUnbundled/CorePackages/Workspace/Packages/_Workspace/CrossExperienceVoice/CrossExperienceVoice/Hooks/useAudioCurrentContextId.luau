local react = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/dependencies").React
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CrossExperienceVoice/CrossExperienceVoice/CrossExperienceVoiceManager").default
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

			audioFocusService.OnDeafenVoiceAudio:Connect(function(p2)
				setState(default:getCurrentAudioContext())
			end)

			audioFocusService.OnUndeafenVoiceAudio:Connect(function(p2)
				setState(default:getCurrentAudioContext())
			end)
		end, {})
	end

	return state
end
