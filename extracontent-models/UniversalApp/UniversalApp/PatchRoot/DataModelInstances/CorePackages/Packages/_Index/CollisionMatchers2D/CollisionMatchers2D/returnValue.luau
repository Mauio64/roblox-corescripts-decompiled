return function(pass, p, p2)
	return {
		pass = pass,
		message = pass and p or p2 or p
	}
end
