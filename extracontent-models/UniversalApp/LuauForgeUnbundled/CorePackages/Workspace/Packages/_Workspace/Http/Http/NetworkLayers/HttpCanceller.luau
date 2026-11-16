local count = 0
return {
	currentSession = function()
		return count
	end,
	cancel = function()
		count += 1
	end
}
