local count = 0
local HttpSession = {}

function HttpSession.currentSession()
	return count
end

function HttpSession.startNewSession()
	count += 1
end

return HttpSession
