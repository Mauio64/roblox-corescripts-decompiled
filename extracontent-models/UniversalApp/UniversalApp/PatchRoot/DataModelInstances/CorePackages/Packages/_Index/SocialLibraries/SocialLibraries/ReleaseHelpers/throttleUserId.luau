return function(t1: {[any]: any}) -- line: 1
	return t1.userId % 100 + 1 <= t1.throttle
end
