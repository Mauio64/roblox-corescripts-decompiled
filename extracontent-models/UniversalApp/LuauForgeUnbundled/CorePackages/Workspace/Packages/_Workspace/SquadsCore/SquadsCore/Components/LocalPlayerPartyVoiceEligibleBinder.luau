local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/CrossExperienceVoice")

local useIsLocalPlayerPartyVoiceEligible = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useIsLocalPlayerPartyVoiceEligible")
local useIsBackgroundDMActive = CrossExperienceVoice.Hooks.useIsBackgroundDMActive

return function(p2): nil
	local v5 = useIsLocalPlayerPartyVoiceEligible()
	local v6 = useIsBackgroundDMActive()

	React.useEffect(function()
		p2.onChange(v5 and v6)
	end, { v5, v6 })

	return nil
end
