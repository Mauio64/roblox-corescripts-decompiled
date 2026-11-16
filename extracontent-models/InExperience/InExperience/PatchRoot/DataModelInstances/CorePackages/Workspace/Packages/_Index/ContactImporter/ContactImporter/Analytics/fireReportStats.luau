return function(p)
	return function(p2, p3)
		local event = p.eventList[p2]
		p.diagImpl:reportStats(event.name, p3.loadingTime)
	end
end
