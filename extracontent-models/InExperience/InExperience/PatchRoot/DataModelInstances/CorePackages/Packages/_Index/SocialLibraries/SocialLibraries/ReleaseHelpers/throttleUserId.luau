return function(p): boolean
	return p.userId % 100 + 1 <= p.throttle
end
