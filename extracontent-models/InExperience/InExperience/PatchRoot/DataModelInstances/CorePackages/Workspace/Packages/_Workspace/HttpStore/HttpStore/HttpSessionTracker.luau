local count = 0
local HttpSessionTracker = {}

function HttpSessionTracker.currentSession()
	return count
end

function HttpSessionTracker.cancelAll()
	count += 1
end

return HttpSessionTracker
