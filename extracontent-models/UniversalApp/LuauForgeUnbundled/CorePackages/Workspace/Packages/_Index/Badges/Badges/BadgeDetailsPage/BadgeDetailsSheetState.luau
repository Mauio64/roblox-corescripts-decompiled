local isBadgeDetailsSheetOpen = false

return {
	getIsBadgeDetailsSheetOpen = function()
		return isBadgeDetailsSheetOpen
	end,
	setIsBadgeDetailsSheetOpen = function(p2)
		isBadgeDetailsSheetOpen = p2
	end
}
