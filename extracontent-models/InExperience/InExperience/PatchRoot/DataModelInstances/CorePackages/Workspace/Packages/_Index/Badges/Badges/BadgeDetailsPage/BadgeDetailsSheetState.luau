local u1 = false

return {
	getIsBadgeDetailsSheetOpen = function() -- line: 3
		-- upvalues: u1 (ref)
		return u1
	end,
	setIsBadgeDetailsSheetOpen = function(b1: boolean) -- line: 7
		-- upvalues: u1 (ref)
		u1 = b1
	end
}
