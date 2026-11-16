local count = 0
local HttpCanceller = {}

function HttpCanceller.currentSession()
	return count
end

function HttpCanceller.cancel()
	count += 1
end

return HttpCanceller
