local CrossExperienceVoice = script:FindFirstAncestor("CrossExperienceVoice")
local React = require(CrossExperienceVoice.dependencies).React
local default = require(CrossExperienceVoice.CrossExperienceVoiceManager).default
local v4 = default:getAudioFocusService()

return function() -- line: 8
	-- upvalues: React (copy), v4 (copy), default (copy)
	local v5, v6 = React.useState(-1)

	if v4 then
		React.useEffect(function() -- line: 12
			-- upvalues: v6 (copy), default (copy), v4 (copy)
			v6(default:getCurrentAudioContext())
			v4.OnContextRegistered:Connect(function() -- line: 15
				-- upvalues: v6 (copy), default (copy)
				v6(default:getCurrentAudioContext())
			end)
			v4.OnContextUnregistered:Connect(function() -- line: 19
				-- upvalues: v6 (copy), default (copy)
				v6(default:getCurrentAudioContext())
			end)
			v4.OnDeafenVoiceAudio:Connect(function(_) -- line: 23
				-- upvalues: v6 (copy), default (copy)
				v6(default:getCurrentAudioContext())
			end)
			v4.OnUndeafenVoiceAudio:Connect(function(_) -- line: 27
				-- upvalues: v6 (copy), default (copy)
				v6(default:getCurrentAudioContext())
			end)
		end, {})
	end

	return v5
end
