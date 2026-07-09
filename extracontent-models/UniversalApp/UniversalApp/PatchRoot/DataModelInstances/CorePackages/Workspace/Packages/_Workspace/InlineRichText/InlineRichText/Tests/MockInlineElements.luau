return {
	default = {
		new = function(...) -- line: 7
			return ...
		end
	},
	LinkElement = {
		new = function(p1, p2) -- line: 18
			return {
				elements = p1,
				onActivated = p2.onActivated
			}
		end
	}
}
