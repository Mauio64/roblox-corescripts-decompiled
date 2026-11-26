return function(p2)
	return function(p3, p4)
		local event = p2.eventList[p3]
		p2.diagImpl:reportStats(event.name, p4.loadingTime)
	end
end
