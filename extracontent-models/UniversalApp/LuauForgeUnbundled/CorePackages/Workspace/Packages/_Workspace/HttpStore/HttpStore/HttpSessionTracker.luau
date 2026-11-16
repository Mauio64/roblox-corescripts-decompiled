local count = 0
return {
	currentSession = function()
		return count
	end,
	cancelAll = function()
		count += 1
	end
}
