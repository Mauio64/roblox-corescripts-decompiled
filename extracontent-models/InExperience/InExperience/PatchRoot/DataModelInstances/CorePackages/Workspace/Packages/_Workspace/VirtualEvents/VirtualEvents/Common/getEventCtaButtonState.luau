local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local GamePlayButton = require(VirtualEvents.Parent.GamePlayButton)
local PlayButtonStates = GamePlayButton.PlayButtonStates

local function getEventCtaButtonState(p)
	return {
		isJoinEventDisabled = p.playButtonState ~= PlayButtonStates.Playable and p.playButtonState ~= PlayButtonStates.PlayableWithParty,
		isRsvpDisabled = not (p.playabilityStatus and p.playabilityStatus.isPlayable)
	}
end

return getEventCtaButtonState
