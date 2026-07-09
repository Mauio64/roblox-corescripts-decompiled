return function(p1) -- line: 1
	return function(p2, p3) -- line: 2
		-- upvalues: p1 (copy)
		local v4 = p1.eventList[p2]

		p1.diagImpl:reportStats(v4.name, p3.loadingTime)
	end
end
