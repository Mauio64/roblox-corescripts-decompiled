local set = {}

return {
	hasSeenOfferId = function(p2): boolean
		return set[p2] == true
	end,
	addOfferId = function(p2)
		set[p2] = true
	end,
	clearOfferIds = function()
		set = {}
	end
}
