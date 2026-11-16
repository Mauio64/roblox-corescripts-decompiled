return function(p)
	return {
		Diag = { reportCounter = p.fn() },
		EventStream = { setRBXEventStream = p.fn() }
	}
end
