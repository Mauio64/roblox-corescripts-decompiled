local parent = script:FindFirstAncestor("SquadsCore").Parent

local React = require(parent.React)
local CrossExperienceVoice = require(parent.CrossExperienceVoice)

local useIsLocalPlayerPartyVoiceEligible = require(script.Parent.Parent.Hooks.useIsLocalPlayerPartyVoiceEligible)
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive

return function(p): nil
	local v = useIsLocalPlayerPartyVoiceEligible()
	local v2 = useIsBackgroundDMActive()

	React.useEffect(function()
		p.onChange(v and v2)
	end, { v, v2 })

	return nil
end
