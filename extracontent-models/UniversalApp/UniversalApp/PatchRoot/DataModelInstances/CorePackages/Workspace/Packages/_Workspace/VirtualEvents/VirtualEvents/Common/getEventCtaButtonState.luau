local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local PlayButtonStates = require(VirtualEvents.Parent.GamePlayButton).PlayButtonStates

local function getEventCtaButtonState(p1) -- line: 14
	-- upvalues: PlayButtonStates (copy)
	local v5 = p1.playButtonState == PlayButtonStates.Playable or p1.playButtonState == PlayButtonStates.PlayableWithParty
	local v6 = p1.playabilityStatus and p1.playabilityStatus.isPlayable

	return {
		isJoinEventDisabled = not v5,
		isRsvpDisabled = not v6
	}
end

return getEventCtaButtonState
