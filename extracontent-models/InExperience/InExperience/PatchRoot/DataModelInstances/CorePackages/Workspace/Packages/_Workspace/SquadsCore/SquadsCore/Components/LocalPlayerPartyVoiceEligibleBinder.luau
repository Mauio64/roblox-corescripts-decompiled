local Parent = script:FindFirstAncestor("SquadsCore").Parent
local React = require(Parent.React)
local CrossExperienceVoice = require(Parent.CrossExperienceVoice)
local useIsLocalPlayerPartyVoiceEligible = require(script.Parent.Parent.Hooks.useIsLocalPlayerPartyVoiceEligible)
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: useIsLocalPlayerPartyVoiceEligible (copy), useIsBackgroundDMActive (copy), React (copy)
	local v7 = useIsLocalPlayerPartyVoiceEligible()
	local v8 = useIsBackgroundDMActive()

	React.useEffect(function() -- line: 18
		-- upvalues: t1 (copy), v7 (copy), v8 (copy)
		t1.onChange(v7 and v8)
	end, {
		v7,
		v8
	})

	return nil
end
