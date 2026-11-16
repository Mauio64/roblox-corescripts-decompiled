local isBadgeDetailsSheetOpen = false
local BadgeDetailsSheetState = {}

function BadgeDetailsSheetState.getIsBadgeDetailsSheetOpen()
	return isBadgeDetailsSheetOpen
end

function BadgeDetailsSheetState.setIsBadgeDetailsSheetOpen(flag: boolean)
	isBadgeDetailsSheetOpen = flag
end

return BadgeDetailsSheetState
