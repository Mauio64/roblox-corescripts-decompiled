local playButtonStates = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GamePlayButton").PlayButtonStates

local function getEventCtaButtonState(p2)
	return {
		isJoinEventDisabled = p2.playButtonState ~= playButtonStates.Playable and p2.playButtonState ~= playButtonStates.PlayableWithParty,
		isRsvpDisabled = not (p2.playabilityStatus and p2.playabilityStatus.isPlayable)
	}
end

return getEventCtaButtonState
